
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

function stringit(t) 
	local res = ""
	if type(t) == "table" then
		local first = true
		res = "{"
		for i, v in pairs(t) do
			local sep = ", "
			if first then
				sep = " "
				first = false
			end
			res = res .. sep .. stringit(i) .. "=" .. stringit(v) 
		end
		res = res .. " }"
	elseif type(t) == "string" then
		res = string.format("%q", t)
	else
		res = tostring(t)		
	end
	return res
end

--local test = require "ui2"
local test = require "ffi1"

function dbos.main(...)
	test(...)
end
