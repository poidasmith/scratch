
package.path = "../lua/?.lua;../test/?.lua"

local test = require "test"

function dbos.main(...)
	test(...)
end