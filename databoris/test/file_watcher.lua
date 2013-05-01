
local ffi      = require "ffi"
local kernel32 = ffi.load "kernel32"

local function get_time(file)
	local attr = ffi.new("WIN32_FILE_ATTRIBUTE_DATA")
	kernel32.GetFileAttributesExA(file, 0, attr)
	return attr.ftLastWriteTime.dwLowDateTime
end

local function build(files)
	local ftimes = {}
	for i,v in ipairs(files) do
		ftimes[v] = get_time(v)
	end
	return function()
		local changed = false
		for k,v in pairs(ftimes) do			
			local t = get_time(k)
			if ftimes[k] ~= t then
				changed = true
			end
			ftimes[k] = t
		end
		return changed
	end
end

local function build_dir(dir)
	
end

return {
	build     = build,
	build_dir = build_dir,
}