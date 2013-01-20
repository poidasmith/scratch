
package.path = "../lua/?.lua;?.lua"

local stream = require("stream")
local env = require("lang_env")

-- Testing

local t = {
	"what",
	string.char(0x1f,1,2),	
	12345.2323,
	"hello ",
	this = "testing ",
	[34.55] = "som",
	innner = {
		stream,
		stream
	},
	blob = false,
	struc = true
}

local s1 = stream.file:new_writer(env.expand("%TEMP%/test.bin"))
--[[
for i=1,10000 do
	s1:write("testing", string.char(3, 2, 1, 12, 33, 53), "asdf", "235")
	s1:write("123")
end
]]--
s1:write_object(t)
s1:close()

local s2 = stream.file:new_reader(env.expand("%TEMP%/test.bin"))
local res = s2:read_object()
print(stringit(res))




