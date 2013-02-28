
local loaders = {}
loaders.cache = {} -- may not be required as builtin probably caches already

local function build_loader(self)
	return function(module)
		if not self.has_init then 
			self.has_init = true 
			if self.init then
				self:init()
			end 
		end 
		local res = loaders.cache[module]
		if not res then
			res = self:require(module)
			loaders.cache[module] = res
		end
		return res
	end
end

-- RES: load from executable resource

local function res_loader_require(self, module)
	if println then println(module) end
	local type = self.mapping[module]
	if not type then return nil end
	return loadstring(os.resource(0, 1, type))
end

function loaders.resource(mapping)
	return build_loader { 
		mapping = {
			_main    = 687, 
			common   = 689,
			database = 690, 
			stream   = 691, 
	    }, 
		require = res_loader_require
	}
end

-- GIT: load from a (bare, local) git repository

local function git_loader_init(self)
end

local function git_loader_require(module)
end

function loaders.git(repo_path, ref)
	return build_loader { 
		repo_path = repo_path, 
		ref       = ref,
		init      = git_loader_init, 
		require   = git_loader_require 
	}
end

-- TCP: load from a socket: send { fn = "loaders_require_raw", module } -> [module string]

local function tcp_loader_init(self)
end

local function tcp_loader_require(module)
end
 
function loaders.tcp(host, port, secondary_host, secondary_port)
	return build_loader {
		host           = host, port = port, 
		secondary_host = secondary_host, 
		secondary_port = secondary_port,
		init           = tcp_loader_init, 
		require        = tcp_loader_require 
 	}
end

package.loaders = { loaders.resource() }


