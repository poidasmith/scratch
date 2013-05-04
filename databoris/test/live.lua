
local ffi, bit, win, ui, user32, gdi32 = require "setup" ()
local kernel32 = ffi.load "kernel32"
local file_watcher = require "file_watcher"

local source   = file_watcher.find_files("*.lua")
local checker  = file_watcher.build(source)
local packages = mapcar(source, function(str) return str:split(".")[1] end)

live = { 
	check = function(hwnd)
		if checker() then
			user32.DestroyWindow(hwnd)
			user32.PostQuitMessage(100)
		end
	end,
}

argv = ffi.string(kernel32.GetCommandLineA()):split(" ", true)

repeat 
	for i,v in pairs(packages) do
		package.loaded[v] = nil
	end 
	local ok, res = pcall(dofile, argv[3])
	if not ok then 
		print(stringit(res))
		kernel32.Sleep(1000)		
		res = 100 
	end
until res ~= 100  
