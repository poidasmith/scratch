
package.path = "../lua/?.lua;?.lua"

local stream = require("stream")
local socket = stream.socket

local s = socket.bind(6565)
socket.listen(s, 1)

local function listen_loop(ss)
	while true do
		local obj = ss:read_object()
		--print(stringit(obj))
		ss:write_object(obj)
		ss:flush()
	end
end

while true do
	local ss = socket.accept(s)
	pcall(listen_loop, ss)
end

table{
	cols=4,
	rows=5,
	row{
		col{"asdf"}
	}
} 