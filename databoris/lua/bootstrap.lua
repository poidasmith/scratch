
--package.path = "../lua/?.lua;../test/?.lua"

--[[
bootstrapper: 
	series of loaders
		- load from a git repo, head/tag/branch/version
		- load from a server: load_thing(name), return table (eg. contains lua code)
		
design of lua expression/script
	 - name
	 - 
	load_thing: windows.service
	{
		expr="...the code...",
		version="some string", -- could be an table too
		timestamp="sdf"		
	}

	 
lua://blah:6587,lua://blah2:6687

]]

local ffi = require "ffi"
local kernel32 = ffi.load "kernel32"
require "common"

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

local last_func = nil
local function trace(event, line)
	local caller = {debug.getinfo(2)}
	--[[local locals = {}
	local i = 1
	while true do
		local name, value = debug.getlocal(1, i)
		if not name then
			break
		end
		locals[i] = { name, value }
		i = i + 1		
	end	
	caller.locals = locals]]
	println(stringit(caller))
end 

--println("======================")
--debug.sethook(trace, "Slfu")

