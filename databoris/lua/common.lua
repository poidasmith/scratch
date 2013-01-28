
-- random useful functions

local ffi      = require("ffi")
local kernel32 = ffi.load("kernel32")

ffi.cdef[[
bool SetEnvironmentVariableA(const char* lpName, const char* lpValue);
unsigned int GetEnvironmentVariableA(const char* lpName, char* lpBuffer, unsigned int nSize);
]]

function getenv(name, len)
	local sz  = len or 4096
	local buf = ffi.new("char[?]", sz, 0)
	kernel32.GetEnvironmentVariableA(name, buf, sz)
	return ffi.string(buf)
end

function setenv(name, value)
	return kernel32.SetEnvironmentVariableA(name, value)
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
			res = string.format("%0.x", t)
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
	return error(string.format(...))
end

function table.strict(t)
	local mt = {
		__index = function(table, key)
			if type(key) == "string" then
				error_format("%s not defined for table", key)
			end
			return table[key]
		end
	}
	setmetatable(t, mt)
	return t
end