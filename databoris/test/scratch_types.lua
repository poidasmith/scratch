
package.path = "../lua/?.lua;?.lua"

local env = require("lang_env")

print(env.expand("%TEMP%/test.bin"))