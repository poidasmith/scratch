
local ffi, bit, win, ui, user32, gdi32 = require "setup" ()
local kernel32 = ffi.load "kernel32"

local file_watcher = require "file_watcher"

local checker = file_watcher.build_dir(".")

live = { 
	check = function(hwnd)
		if checker() then
			user32.DestroyWindow(hwnd)
			user32.PostQuitMessage(100)
		end
	end,
}

local cl = ffi.string(kernel32.GetCommandLineA())
local args = {}
for arg in string.gmatch(cl, "%a+") do
	table.insert(args, arg)
end

print(stringit(args))

repeat 
	local res = dofile(args[3])
until res ~= 100  
