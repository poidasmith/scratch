
package.path = "../lua/?.lua;?.lua"
local ui = require "uiapi"

--local win1 = ui.create("TEST1", 

local hwnd_mt = { __index = hwnd_idx }
ffi.metatype("HWND", hwnd_mt)

local editor = win {
	-- properties
	class  = "Scintilla",
	styles = nil,
	
	--[[ use layout manager
	x      = 100,
	y      = 100,
	width  = 800,
	height = 600,
	]]
	
	-- setup editor
	init   = function(self, hwnd)
	end,
	
	-- paint editor
	paint  = function(self, hwnd)
	end,
	
	-- resize editor
	resize = function(self, hwnd)
	end,
}


local w = window.new("Scintilla", 500, 400)


-- main windows layout

table = {
	rows = {
		{
			height  = 10,
			class   = "blah",
			hscroll = nil,
			vscroll = { pos = 10 },
			fg      = nil,
			bg      = nil,
			columns = {
				{
				},
			}
		}
	},
}