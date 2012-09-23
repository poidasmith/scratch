
local style = {} -- import from somewhere 

local events = {}

local view = {
	{menubar,
		{menu, 
			name = "&File", 
		    children = function(self, ctx)
			end
		}
	},
}

return { style, events, view }



