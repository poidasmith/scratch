
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

local function find_files(pattern)
	local files = {}
	local fd = ffi.new("WIN32_FIND_DATA[1]")
	local hfind = kernel32.FindFirstFileA(pattern, fd)
	local next = 1
	while next ~= 0 and hfind ~= -1 do
		local f = ffi.string(fd[0].cFileName)
		table.insert(files, f) 
		next = kernel32.FindNextFileA(hfind, fd)
	end  
	kernel32.FindClose(hfind)
	return files
end

local function watch(pattern)
	return build(find_files(pattern))
end

return {
	watch = watch
}