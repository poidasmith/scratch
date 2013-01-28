
package.path = "../lua/?.lua;../test/?.lua"

local ffi = require "ffi"
local kernel32 = ffi.load "kernel32"

ffi.cdef[[
typedef char* LPTSTR;
void OutputDebugStringA(LPCSTR lpOutputString);
]]

function print(s)
	kernel32.OutputDebugStringA(s)
end

local test = require "test"

function dbos.main(...)
	test(...)
end