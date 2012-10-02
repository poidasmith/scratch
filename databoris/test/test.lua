
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
	elseif type(t) == "boolean" then
		res = t and "true" or "false"
	elseif type(t) == "number" then
		res = string.format("%0.x", t)
	else
		res = tostring(t)		
	end
	return res
end

--local test = require "ui2"
local test = require "ffi1"

function main(...)
	test(...)
end

return main