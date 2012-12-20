
package.path = "../lua/?.lua;../test/?.lua"

local stream = require("stream")

local file = stream.file:read{filename="test.bin"}
