
local loaders = {}
loaders.cache = {} -- may not be required as builtin probably caches already

local function build_loader(self)
	return function(module)
		if not self.has_init then 
			self.has_init = true 
			self.init() 
		end 
		local res = loaders.cache[module]
		if not res then
			res = self.require(module)
			loaders.cace[module] = res
		end
		return res
	end
end

-- RES: load from executable resource

local function res_loader_init(self)
	local ffi = require "ffi"
	ffi.cdef[[
		typedef long HRSRC;
		typedef long HMODULE;
		typedef long HGLOBAL;
		HRSRC   FindResourceA(HMODULE hModule, const char* lpName, const char* lpType);	
		HGLOBAL LoadResource(HMODULE hModule, HRSRC hResInfo);
		void*   LockResource(HGLOBAL hResData);
	]]
end

function loaders.resource(hinstance, mapping)
	local self = { hinstance = hinstance, mapping = mapping }
	return build_loader { init = res_loader_init, require = res_loader_require }
end

-- GIT: load from a (bare, local) git repository

local function git_loader_init(self)
end

local function git_loader_require(module)
end

function loaders.git(repo_path, ref)
	local self = { repo_path, ref }
	return build_loader { self = self, init = git_loader_init, require = git_loader_require }
end

-- TCP: load from a socket: send { fn = "loaders_require_raw", module } -> [module string]
 
function loaders.tcp(host, port)
	local self 
	return build_loader { self = self, init = tcp_loader_init, require = tcp_loader_require }
end

return loaders
