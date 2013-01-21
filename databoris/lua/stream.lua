
--[[

	Provides a stream API on files and sockets and a (de)serializer for tables

	Serialization format as below:
	
          MSN      LSN  
        +--------------------------------------------------+
nil     | 0 0 0 0  0 0 0 0 | N/A               | N/A       |
false   | 0 0 0 0  0 0 1 0 | N/A               | N/A       |
true    | 0 0 0 0  0 0 1 1 | N/A               | N/A       |
number  | 0 0 0 0  0 1 0 0 | value (8 bytes)   | N/A       |
uint    | x x 0 0  0 1 0 1 | len (size)        | len size  | // variable sized uint
table   | x x 0 0  1 0 0 0 | len (num pairs)   | len pairs | 
string  | x x 0 0  1 0 1 0 | len (num bytes)   | len bytes |
        +--------------------------------------------------+
--]]

local ffi      = require("ffi")
local kernel32 = ffi.load("kernel32")
local wsock    = ffi.load("ws2_32")

ffi.cdef[[
typedef long           HANDLE;
typedef int            BOOL;
typedef unsigned long  DWORD;
typedef unsigned long* LPDWORD;
typedef void*          LPVOID;
typedef void*          LPCVOID;
typedef void*          LPSECURITY_ATTRIBUTES;
typedef void*          LPOVERLAPPED;
typedef const char*    LPCTSTR;
typedef unsigned int   SOCKET;   

HANDLE CreateFileA(
	LPCTSTR lpFileName, 
    DWORD dwDesiredAccess, 
    DWORD dwShareMode,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes, 
    DWORD dwCreationDisposition,
    DWORD dwFlagsAndAttributes, 
    HANDLE hTemplateFile
);
BOOL ReadFile(
	HANDLE hFile, 
	LPVOID lpBuffer, 
	DWORD nNumberOfBytesToRead, 
	LPDWORD lpNumberOfBytesRead, 
	LPOVERLAPPED lpOverlapped
);                      
BOOL WriteFile(
	HANDLE hFile,
	const char* lpBuffer,
	DWORD nNumberOfBytesToWrite,
	LPDWORD lpNumberOfBytesWritten,
	LPOVERLAPPED lpOverlapped
);
BOOL CloseHandle(
	HANDLE hObject
);
int send(
  SOCKET s,
  const char *buf,
  int len,
  int flags
);
int recv(
  SOCKET s,
  char *buf,
  int len,
  int flags
);
]]

function hexdump(buf)
	for i=1,math.ceil(#buf/16) * 16 do
    	if (i-1) % 16 == 0 then io.write(string.format('%08X  ', i-1)) end
 		io.write( i > #buf and '   ' or string.format('%02X ', buf:byte(i)) )
 		if i %  8 == 0 then io.write(' ') end
 		if i % 16 == 0 then io.write( buf:sub(i-16+1, i):gsub('%c','.'), '\n' ) end
    end
end

function stringit(t) 
	local res = ""
	if type(t) == "table" then
		local first = true
		res = "{"
		for i, v in pairs(t) do
			local sep = ", "
			if first then
				sep = " "
				first = false
			end
			res = res .. sep .. stringit(i) .. "=" .. stringit(v) 
		end
		res = res .. " }"
	elseif type(t) == "string" then
		res = string.format("%q", t)
	elseif type(t) == "boolean" then
		res = t and "true" or "false"
	elseif type(t) == "number" then
		if math.floor(t) == t then
			res = string.format("%0.x", t)
		else
			res = string.format("%f", t)
		end
	else
		res = tostring(t)		
	end
	return res
end

local win = {
	GENERIC_READ    = 0x80000000,
	GENERIC_WRITE   = 0x40000000, 
	GENERIC_EXECUTE = 0x20000000,
	GENERIC_ALL     = 0x10000000,
	  	
	CREATE_ALWAYS     = 2,
	CREATE_NEW        = 1,
	OPEN_ALWAYS       = 4,
	OPEN_EXISTING     = 3,
	TRUNCATE_EXISTING = 5,
	
	FILE_ATTRIBUTE_NORMAL = 0x80
}

local stream = {}

function stream:new(o)
	local o = o or {}
	o.__TYPE = "stream"
	o.index = 1
	o.size = 0
	o.buf = {}
	o.buf_size = 4000,
	setmetatable(o, self)
	self.__index = self
	return o
end

function stream:write_lentype(type, len)	
	if bit.band(len, 0xff000000) ~= 0 then
		self:write(string.char(	
			bit.bor(0xc0, type),
			bit.band(0xff, len),
			bit.band(0xff, bit.rshift(len, 1)),
			bit.band(0xff, bit.rshift(len, 2)),
			bit.band(0xff, bit.rshift(len, 3))
		))
	elseif bit.band(len, 0x00ff0000) ~= 0 then
		self:write(string.char(
			bit.bor(0x80, type),
			bit.band(0xff, len),
			bit.band(0xff, bit.rshift(len, 1)),
			bit.band(0xff, bit.rshift(len, 2))
		))	
	elseif bit.band(len, 0x0000ff00) ~= 0 then
		self:write(string.char(
			bit.bor(0x40, type),
			bit.band(0xff, len),
			bit.band(0xff, bit.rshift(len, 1))
		))	
	else
		self:write(string.char(
			type,
			bit.band(0xff, len)
		))	
	end
end

function stream:write_object(val, seen)
	local seen = seen or {}
	local t = type(val)
	if t == "string" then
		self:write_lentype(10, #val)
		self:write(val)		
	elseif t == "boolean" then
		self:write(val and string.char(3) or string.char(2))
	elseif t == "number" then
		self:write(string.char(4))
		local d = ffi.new("double[1]", {val})
		self:write(ffi.string(ffi.cast("char*", d), 8))
	elseif t == "table" and not seen[val] then	
		seen[val] = true
		-- need to count first unfortunately
		local tcount = 0
		for k,v in pairs(val) do
			tcount = tcount + 1
		end
		self:write_lentype(8, tcount)
		for k,v in pairs(val) do
			-- extra hack/check to persist integer keys in much less space
			if type(k) == "number" and math.floor(k) == k then
				self:write_lentype(5, k)
			else
				self:write_object(k, seen)
			end
			self:write_object(v, seen)
		end	
	else
		self:write(string.char(0)) -- default to nil
	end
end

function stream:write_internal(str)
	print(string.format("%q", str))
end 

function stream:write(...)
	for _,str in ipairs{...} do
		--hexdump(str)
		self.buf[self.index] = str
		self.index = 1 + self.index
		self.size  = #str + self.size 
	end
	if self.size > self.buf_size then
		self:flush()
	end
end

function stream:flush()
	local t = table.concat(self.buf)
	self:write_internal(t)
	self.buf = {}
	self.index = 1
	self.size = 0
end

function stream:close()
	self:flush()
end

function stream:read(len)
	return self:read_internal(len)
end

function stream:read_internal(len)
	return nil
end

function stream:read_len(lenlen)
	local blob = self:read(lenlen)
	local len = string.byte(blob)
	if lenlen > 1 then len = len + bit.lshift(string.byte(blob, 1),8) end
	if lenlen > 2 then len = len + bit.lshift(string.byte(blob, 1),16) end
	if lenlen > 3 then len = len + bit.lshift(string.byte(blob, 1),24) end
	return len
end

function stream:read_object()
	local type = string.byte(self:read(1))
	if bit.band(0x30, type) ~= 0 then error("invalid high nibble & 0x30") end
	local lenlen = bit.rshift(type, 6) + 1
	type = bit.band(type, 0xf)
	if type == 1 or type == 7 or type == 9 then error("invalid low nibble 1,7,9") end
	if type == 0 then return nil end
	if type == 3 then return true end
	if type == 2 then return false end
	if type == 4 then return ffi.cast("double*", self:read(8))[0] end
	local len = lenlen > 0 and self:read_len(lenlen) or 0
	if type == 5 then return len end
	if type == 10 then return self:read(len) end
	local t = {}
	for i=1,len do 
		t[self:read_object()] = self:read_object()
	end
	return t
end

local file_stream = stream:new()

function file_stream:new(filename, access, create_disp, o)
	local o = o or {}
	o.handle = kernel32.CreateFileA(
		filename, 
		access, 
		0, -- exclusive lock on file
		nil, 
		create_disp, 
		win.FILE_ATTRIBUTE_NORMAL, 
		0
	)
	if not o.handle then error("unable to create file") end
	o.num_ = ffi.new("DWORD[1]")	
	return stream.new(self, o)	
end

function file_stream:new_writer(filename, o)
	return self:new(filename, win.GENERIC_WRITE, win.CREATE_ALWAYS, o)
end

function file_stream:new_reader(filename, o)
	local o = o or {}
	o.buf_ = ffi.new("char[4096]")
	return self:new(filename, win.GENERIC_READ, win.OPEN_EXISTING, o)
end

function file_stream:write_internal(str)	
	--hexdump(str)
	kernel32.WriteFile(self.handle, str, #str, self.num_, nil)	
end

function file_stream:read_internal(len)
	local left = len
	local parts = {}
	local nump = 0
	while left > 0 do
		if not kernel32.ReadFile(self.handle, self.buf_, left, self.num_, nil) then
			error("error reading file stream")
		end
		local read = tonumber(self.num_[0])
		left = left - read
		parts[#parts + 1] = ffi.string(self.buf_, read)
		nump = nump + 1
	end
	if nump == 1 then -- should be pretty common, avoids table concat
		hexdump(parts[1])
		return parts[1]
	end
	return table.concat(parts)
end

function file_stream:close()
	self:flush()
	kernel32.CloseHandle(self.handle)
end

local socket_stream = stream:new()

function socket_stream:new(socket)
	local o = o or {}
	o.socket = socket
	o.buf_ = ffi.new("char[4096]")	
	return stream.new(self, o)		
end

function socket_stream:write_internal(str)	
	hexdump(str)
	wsock.send(self.socket, str, #str, 0) -- TODO: check result
end

-- TODO: refactor/merge this into file_stream:read_internal
function socket_stream:read_internal(len)
	local left = len
	local parts = {}
	local nump = 0
	while left > 0 do
		local read = wsock.recv(self.socket, self.buf_, left, 0)
		left = left - read
		parts[#parts + 1] = ffi.string(self.buf_, read)
		nump = nump + 1
	end
	if nump == 1 then
		hexdump(parts[1])
		return parts[1]
	end
	return table.concat(parts)
end

return {
	file   = file_stream,
	socket = socket_stream,
}


