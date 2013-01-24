
package.path = "../lua/?.lua;?.lua"

local stream = require("stream")
local socket = stream.socket

local ss = socket.connect("127.0.0.1", 6565)
local test = {
	"hello",
	over = there,
	123,
	-123,
	true,
	nil,
	false
}

local times = 20000
local t0 = os.clock()
for i=1,times do
	ss:write_object(test)
	ss:flush()
	local r = ss:read_object()
	--print(stringit(r))
end
local t1 = os.clock()
printf("%s", stringit(t1-t0))