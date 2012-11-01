
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

local ffi = require("ffi")
local winnt = require("winnt")
local kernel32 = ffi.load("kernel32")

function println(o)
	kernel32.OutputDebugStringA(stringit(o) .. "\n")
end

local function trace(event, line)
	local s = debug.getinfo(2)
	--if string.find(s.short_src, "ffi1.lua") ~= nil then
		println(line .. ": " .. stringit(s.name))
	--end
end 
--debug.sethook(trace, "l")

--local test = require "ui2"
local function dofile(filename)
	local f = io.open(filename, "r")
	f = loadstring(f:read("*a"))
	println(f)
	return pcall(f)
end 

function main(...)
	local res = 0
	repeat
		--res = dofile("../test/ffi1.lua")
		iserr, res = dofile("../test/sock1.lua")
		if type(res) == "function" then
			iserr, res = pcall(res, ...)
		else
			println(res)
		end
	until iserr or res ~= 100
	println(res)
end

return main