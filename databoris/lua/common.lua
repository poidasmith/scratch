
-- random useful functions

local ffi      = require("ffi")
local kernel32 = ffi.load("kernel32")

ffi.cdef[[
typedef unsigned long  DWORD;
typedef char*          LPSTR;
typedef const char*    LPCSTR;

void  OutputDebugStringA(LPCSTR lpOutputString);
DWORD ExpandEnvironmentStringsA(LPCSTR lpSrc, LPSTR lpDst, DWORD nSize);
bool  SetEnvironmentVariableA(LPCSTR lpName, LPCSTR lpValue);
DWORD GetEnvironmentVariableA(LPCSTR lpName, LPSTR lpBuffer, DWORD nSize);
]]

function log(s)
	kernel32.OutputDebugStringA(stringit(s))
end

function println(o)
	if type(o) == "string" then
		kernel32.OutputDebugStringA(o .. "\n")
	end
end

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

function stringit(t, seen) 
	local res = ""
	if type(t) == "table" then
		local first = true
		res = "{"
		if seen then
			if seen[t] then
				return "{...}"
			else
				seen[t] = true
			end				
		end
		for i, v in pairs(t) do
			local sep = ", "
			if first then
				sep = " "
				first = false
			end
			res = res .. sep .. stringit(i, seen) .. "=" .. stringit(v, seen) 
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

function mapcar(a, f)
	res = {}
	for i,v in ipairs(a) do
		table.insert(res, f(v, i))
	end
	return res
end

function string.split(str, separator, quotes)
	local len = str:len()
	local idx = 1
	local inq = false
	local arr = {}
	for i = 1, len do
		local c = str:sub(i, i) 
		if not inq and c == separator then
			table.insert(arr, str:sub(idx, i-1))
			idx = i+1
		elseif quotes and c == "\"" then 
			inq = not inq 
		end
	end
    if idx < len then
		arr[#arr+1] = str:sub(idx, len)
    end
	return arr
end

function table.union(...)
	local res = {}
	local args = {...}
	for i,t in ipairs(args) do
		for k,v in pairs(t) do
			if not res[k] then
				res[k] = v
			end
		end
	end
	return res
end

-- cascaded/union view on a series of tables
function table.cascade(...)
	local args = {...}
	
end

function table.keys(t)
	local keys = {}
	for k,v in pairs(t) do
		table.insert(keys, k)
	end
	return keys
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
