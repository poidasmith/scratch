
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

require "common"



--println("======================")
--debug.sethook(trace, "Slfu")

