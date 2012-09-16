
--require "win32"

local function stringit(t) 
	local res = ""
	if type(t) == "table" then
		local first = true
		res = "{"
		for i, v in pairs(t) do
			local sep = ", "
			if first then
				sep = " "
				first = false
			end
			res = res .. sep .. stringit(i) .. "=" .. stringit(v) 
		end
		res = res .. " }"
	elseif type(t) == "string" then
		res = string.format("%q", t)
	else
		res = tostring(t)		
	end
	return res
end

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