
function c1()
	print(coroutine.status(coroutine.running()))
	coroutine.yield()
end

local l = coroutine.create(c1)
coroutine.resume(l)
print(coroutine.status(l))
print(type(l))