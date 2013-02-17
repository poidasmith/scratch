
-- random useful functions

local ffi      = require("ffi")
local kernel32 = ffi.load("kernel32")

ffi.cdef[[
typedef const char* LPCSTR;
void OutputDebugStringA(LPCSTR lpOutputString);
]]

function log(s)
	kernel32.OutputDebugStringA(stringit(s))
end

function println(o)
	if type(o) == "string" then
		kernel32.OutputDebugStringA(o .. "\n")
	end
end


ffi.cdef[[
typedef unsigned long  DWORD;
typedef char*          LPTSTR;
typedef const char*    LPCTSTR;

DWORD ExpandEnvironmentStringsA(LPCTSTR lpSrc, LPTSTR lpDst, DWORD nSize);
bool SetEnvironmentVariableA(LPCTSTR lpName, LPCTSTR lpValue);
DWORD GetEnvironmentVariableA(LPCTSTR lpName, LPTSTR lpBuffer, DWORD nSize);
]]

-- TODO: use a metatable so we can do things like:
--   env.PATH = env.PATH .. ";../something/"
--   for k,v in pairs(env) do
--     print(k, "=", v)
--   end

function getenv(name, len)
	local sz  = len or 4096
	local buf = ffi.new("char[?]", sz, 0)
	kernel32.GetEnvironmentVariableA(name, buf, sz)
	return ffi.string(buf)
end

function setenv(name, value)
	return kernel32.SetEnvironmentVariableA(name, value)
end

function env(str)
	local var = ffi.new("char[4906]")
	local len = kernel32.ExpandEnvironmentStringsA(str, var, 4096)
	return ffi.string(var, len)
end

-- borrowed from http://lua-users.org/wiki/HexDump
function hexdump(buf)
	for i=1,math.ceil(#buf/16) * 16 do
    	if (i-1) % 16 == 0 then io.write(string.format('%08x  ', i-1)) end
 		io.write( i > #buf and '   ' or string.format('%02x ', buf:byte(i)) )
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
			res = string.format("%0.f", t)
		else
			res = string.format("%f", t)
		end
	else
		res = tostring(t)		
	end
	return res
end

function printf(...)
	print(string.format(...))
end

function errorf(...)
	println(string.format(...))
	return error(string.format(...))
end

function table.strict(t)
	local mt = {
		__index = function(table, key)
			if type(key) == "string" then
				errorf("%s not defined for table", key)
			end
			return table[key]
		end
	}
	setmetatable(t, mt)
	return t
end
