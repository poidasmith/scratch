
local ffi, bit, win, ui, user32, gdi32 = require "setup" ()
local kernel32 = ffi.load "kernel32"

local file_watcher = require "file_watcher"

local checker = file_watcher.watch("*.lua")

live = { 
	check = function(hwnd)
		if checker() then
			user32.DestroyWindow(hwnd)
			user32.PostQuitMessage(100)
		end
	end,
}

argv = ffi.string(kernel32.GetCommandLineA()):split(" ", true)
print(stringit(argv))

repeat 
	--print(stringit(package, {}))	
	package.loaded.grid_view = nil
	package.loaded.grid = nil
	print(stringit(table.keys(package.loaded)))
	local res = dofile(argv[3])
until res ~= 100  
