
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

function os.resource(hinstance, name, type)
	local ffi = require "ffi"
	ffi.cdef[[
		typedef long HRSRC;
		typedef long HMODULE;
		typedef long HGLOBAL;
		HRSRC   FindResourceA(HMODULE hModule, int name, int type);	
		HGLOBAL LoadResource(HMODULE hModule, HRSRC hResInfo);
		char*   LockResource(HGLOBAL hResData);
	]]
	local kernel32 = ffi.load "kernel32"
	local hrsrc = kernel32.FindResourceA(hinstance, name, type)
	local hglobal = kernel32.LoadResource(hinstance, hrsrc)
	return ffi.string(kernel32.LockResource(hglobal))		
end

-- require "loaders"
assert(loadstring(os.resource(0, 1, 692), "loaders"))()
require "common"
require "_main"
require "windows.service"

--println("======================")
--debug.sethook(trace, "Slfu")

