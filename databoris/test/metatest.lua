
require "setup" ()

local m1 = {
	__newindex = function(t, k, v)
		print("newindex: ", k, "=", v)
		--rawset(t, k, v)
	end
}

local t1 = {
	hello = 123,
	sowhat = "1213534",
}

setmetatable(t1, m1)

print(stringit(t1))
t1.fred = false
t1.bob = "asdfklj"
t1.hello = 45645
print(stringit(t1))
