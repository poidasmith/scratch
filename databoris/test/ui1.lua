
local style = {} -- import from somewhere 

local events = {}

local view = {
	{menubar,
		{menu, name = "File",
			{menu, name = "Exit", action = events.file_exit}
		}
	},
}

return { style, events, view }



