
package.path = "../lua/?.lua;?.lua"

require "common"

print(env("%PATH%"))

local test = nil
print(test.test.test)