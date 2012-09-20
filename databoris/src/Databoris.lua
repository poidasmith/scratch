
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

function table.readonly(t)
	local proxy = {}
	local mt = {
		__index = t,
		__newindex = function(t, k, v)
			error("table is readonly")
		end
	}
	setmetatable(proxy, mt)
	return proxy
end

local test = require "ui2"

function dbos.main(...)
	test(...)
end
