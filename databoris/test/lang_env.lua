
local ffi = require("ffi")
local kernel32 = ffi.load("kernel32")

ffi.cdef[[
typedef unsigned long  DWORD;
typedef char*          LPTSTR;
typedef const char*    LPCTSTR;

DWORD ExpandEnvironmentStringsA(
  LPCTSTR lpSrc,
  LPTSTR lpDst,
  DWORD nSize
);
]]

local function expand(str)
	local var = ffi.new("char[4906]")
	local len = kernel32.ExpandEnvironmentStringsA(str, var, 4096)
	return ffi.string(var, len)
end

return {
	expand = expand
}