
local ffi = require("ffi")

ffi.cdef[[
HANDLE WINAPI CreateFile(LPCTSTR lpFileName, DWORD dwDesiredAccess, DWORD dwShareMode,
                         LPSECURITY_ATTRIBUTES lpSecurityAttributes, DWORD dwCreationDisposition,
                         DWORD dwFlagsAndAttributes, HANDLE hTemplateFile);
]]

-- base class implements stream methods
local stream = {
	big_endian = false
}

function stream:new(o) -- standard constructor
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function stream:read_word()
	local str = self.read(2)
end

function stream:read_dword()
	local str = self.read(4)
end

-- file-based stream
local file_stream = stream:new()

function file_stream:open(filename, mode)
end

function file_stream:read(len)
	
end

return {
	file = file_stream
}