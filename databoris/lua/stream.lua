
-- stream impl (files and sockets)

local function read_num(self)
	local d = self:read_buf(8)	
end

local function read_bool(self)
end

local function read_buf(self, len)
end

local function big_endian(self)
	self.big_endian = false
end

local lib = {
	big_endian    = function(self) self.big_endian = true end,
	little_endian = function(self) self.big_endian = false end,
}

return lib
