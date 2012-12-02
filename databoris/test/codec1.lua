
--[[
          MSN      LSN  
        +--------------------------------------------------+
null    | 0 0 0 0  0 0 0 0 | N/A               | N/A       |
true    | 0 0 0 0  0 0 0 1 | N/A               | N/A       |
false   | 0 0 0 0  0 0 1 0 | N/A               | N/A       |
int64   | 0 0 0 0  0 0 1 1 | value (8 bytes)   | N/A       |
double  | 0 0 0 0  0 1 0 0 | value (8 bytes)   | N/A       |
object  | x x 0 0  1 0 0 0 | len (num pairs)   | len pairs | = combine } into
array   | x x 0 0  1 0 0 1 | len (num elems)   | len elems | = combine } table
string  | x x 0 0  1 0 1 0 | len (num bytes)   | len bytes |
int32   | x x 0 0  1 0 1 1 | value (len bytes) | N/A       |
raw     | x x 0 0  1 1 0 0 | len (num bytes)   | len bytes |
        +--------------------------------------------------+

--]]

--local stream = require "stream"
local bit = require "bit"

local function encode_type(stream, type, len)
end

local function encode_nil(stream)
	encode_type(stream, 0)
end

local function encode_bool(stream, val)
	encode_type(stream, 0x1 and val or 0x2)	
end

local function encode_number(stream, val)
end

local function encode_string(stream, val)
	encode_type(stream, 0x6, val:len())
	stream:write(val)
end

local function encode_table(stream, val, seen_keys)
	local seen_keys = seen_keys or {}
	if seen_keys[val] then
		encode_nil()
		return
	end
	
	local len = 0
	for _ in pairs(val) do len = len + 1 end

	encode_type(stream, 0x4, len)
	for k, v in pairs(val) do
		encode(stream, k, seen_keys)
		encode(stream, v, seen_keys)
	end	
	
	seen_keys[val] = true
end

local encoders = {
	["boolean"] = encode_bool, 
	["number"]  = encode_number,
	["nil"]     = encode_nil,
	["string"]  = encode_string,
	["table"]   = encode_table,
}

local function encode(stream, val, seen_keys)
	local encoder = encoders[type(val)] or encode_nil
	encoder(stream, val, seen_keys)
end

local t1 = {
	a = 444.2,
	b = "test",
	c = false,
	d = nil,
	eeeee = true,
	ff = 123,
	[{"df"}] = "afsdf",
	[{false}] = ".033",
	[true] = 123,
	[false] = "asdf",
	-- ipairs
	"something", 23.44444, 123, 321
}

print(string.byte("6"))
encode(t1)
