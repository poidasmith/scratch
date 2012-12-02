

local loader1 = function(mod)
	return loadstring( "return \"" .. mod .. "\" ")
end

package.loaders = { loader1 } 

local l = require "testing" -- will return the string "testing"

print("test: " .. l)
