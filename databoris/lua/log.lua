
-- loggin framework

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