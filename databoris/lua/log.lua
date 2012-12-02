
-- loggin framework

local win32 = require "win32"

local function printf(fmt, ...)
	win32.OutputDebugString(string.format(fmt, ...))
end

local function println(t)
	printf("%s\n", stringit(t))
end

return {
	printf   = printf,
	println  = println,
	stringit = stringit,
}