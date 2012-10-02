
-- load 
--   config
--   snapshot
--   index

--require("debugger")(nil, nil, "databoris")


--[[
mainwindow = {
	style = bitor( win32.CS_HREDRAW, win32.CS_VREDRAW ),
	wndproc = {
		[win32.WM_DESTROY] = dbos.win32_quit,
	}
}
--]]

package.path = "../lua/?.lua;../test/?.lua"

local test = require "test"

function dbos.main(...)
	test(...)
end
