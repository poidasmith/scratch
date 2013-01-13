
local win      = require("iowin")
local ffi      = require("ffi")
local kernel32 = win.kernel32

local t = {
	"what",
	string.char(0x1f,1,2),
	"hello ",
	"testing "
}

local stream = {}

function stream:new(o)
	local o = o or {}
	o.index = 1
	o.size = 0
	o.buf = {}
	o.buf_size = 4000,
	setmetatable(o, self)
	self.__index = self
	return o
end

--[[
          MSN      LSN  
        +--------------------------------------------------+
nil     | 0 0 0 0  0 0 0 0 | N/A               | N/A       |
true    | 0 0 0 0  0 0 0 1 | N/A               | N/A       |
false   | 0 0 0 0  0 0 1 0 | N/A               | N/A       |
number  | 0 0 0 0  0 1 0 0 | value (8 bytes)   | N/A       |
table   | x x 0 0  1 0 0 0 | len (num pairs)   | len pairs | 
string  | x x 0 0  1 0 1 0 | len (num bytes)   | len bytes |
        +--------------------------------------------------+
--]]

function stream:write_lentype(t, len)
end

function stream:write_object(val, seen)
	local seen = seen or {}
	local t = type(val)
	if t == "string" then
		self:write_lentype(10, #val)
		self:write_raw(val)		
	elseif t == "boolean" then
		self:write_raw(val and string.char(1) or string.char(2))
	elseif t == "number" then
		self:write_raw(string.char(4))
		-- todo: need to convert a double to an 8 byte string
	elseif t == "table" and not seen[val] then	
		seen[val] = true
		-- need to count first unfortunately
		local tcount = 0
		for k,v in pairs(t) do
			tcount = tcount + 1
		end
		self:write_lentype(8, tcount)
		for k,v in pairs(t) do
			self:write_object(k, seen)
			self:write_object(v, seen)
		end	
	else
		self:write_raw(string.char(0)) -- default to nil
	end
end

function stream:write_internal(str)
	print(string.format("%q", str))
end 

function stream:write_raw(...)
	for _,str in ipairs{...} do
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

local file_stream = stream:new()

function file_stream:new_(filename, access, create_disp, o)
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
	return self:new(o)	
end

function file_stream:new_writer(filename, o)
	return self:new_(filename, win.GENERIC_WRITE, win.CREATE_ALWAYS, o)
end

function file_stream:new_reader(filename, o)
	local o = o or {}
	o.buf_ = ffi.new("char[4096]")
	return self:new_(filename, win.GENERIC_READ, win.OPEN_EXISTING, o)
end

function file_stream:write_internal(str)	
	kernel32.WriteFile(self.handle, str, #str, self.num_, nil)	
end

function file_stream:read_internal(len)
	local left = len
	local parts = {}
	local nump = 0
	while left > 0 do
		if not kernel32.ReadFile(self.handle, self.buf_, part, self.num_, nil) then
			error("error reading file stream")
		end
		local read = tonumber(self.num_[0])
		left = left - read
		parts[#parts + 1] = ffi.string(self.buf_, read)
		nump = nump + 1
	end
	if nump == 1 then -- should be pretty common, avoids table concat
		return parts[1]
	end
	return table.concat(parts)
end

function file_stream:close()
	self:flush()
	kernel32.CloseHandle(self.handle)
end

local s1 = file_stream:new_writer("test.bin")
for i=1,10000 do
	s1:write_raw("testing", string.char(3, 2, 1, 12, 33, 53), "asdf", "235")
	s1:write_raw("123")
end
s1:close()




