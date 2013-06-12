
-- calculate visible area
local start_row, end_row = model.visible_row_at_range(current_y, current_y+height)
local start_col, end_col = model.visible_col_at_range(current_x, current_x+width)

for row in start_row..end_row do
	for col in start_col..end_col do
		
	end
end

model.row_height(row)

function model:visible_rows_in_range(y, yn) -- equivalent to querying for cell_y(n) within range
	
end 

simple_model = {
	max_col = 10,
	max_row = 10,
	
	default_height = 16,
	default_width  = 80,
	default_style  = "default",
	
	rows = {
		[1] = {
			height = 16,
			cells = {
				[1] = {
					data  = "testing",
					styles = { "default" }, -- this can be implicit
				},
				[6] = {
					data  = "123",
					styles = { "default" }, 
				} 
			}
		},
	},
	
	columns = {
		{
			
		},
	},
	
	styles = {
		default = {
			font_face  = "Bitstream Vera Sans", 
			font_size  = 14,
			font_width = 6,		
			fore       = 0xe0e0e0, 
			back       = 0x242424, 
		},
		-- attributes set overrides, elements set parent styles (default is a fixed parent)
		row_selected = { fore = 0xffffff, back = 0x804000 },			
		cell_selected = { back = 0x101010 },			
		cell_selected = {},
	}
}

local default_cell_style = {
	font_face  = "Bitstream Vera Sans", 
	font_size  = 14,
	font_width = 6,		
	fore       = 0xe0e0e0, 
	back       = 0x242424, 
}

local cell_style = {
	font_face  = "Bitstream Vera Sans", 
	font_size  = 14,
	font_width = 6,		
	fore       = 0xe0e0e0, 
	back       = 0x242424, 
	sel_fore   = 0xffffff, 
	--sel_back   = 0x201000, 
	sel_back   = 0x804000, 
	caret_fore = 0xaaaa88, 
	line_back  = 0x101010, 
}

local cell_models = {
	{ 
		text = "Hello, World! this is ok for now", -- data
		x = 10, y = 10, width = 100, height = 25, -- dimensions
		is_selected = false,
		style  = cell_style,
	},
	{ 
		text = "22", -- data
		x = 10, y = 35, width = 200, height = 25, -- dimensions
		is_selected = false,
		halign = "right",
		style  = cell_style,
	},
	{ 
		text = "Hello, World! ok then", -- data
		x = 210, y = 10, width = 200, height = 25, -- dimensions
		is_selected = true,
		is_primary_selected = true,
		is_current_row = false,
		style  = cell_style,
		halign = "centre",
		valign = "centre",
	},
	{ 
		text = string.format("%0.2f", 12344544.22),
		x = 410, y = 10, width = 120, height = 25, -- dimensions
		is_selected = false,
		is_current_row = true, -- should this be a style
		halign = "right",
		valign = "centre",
		style  = cell_style,
		hash_obs = true,
	},
}

local model = { -- optimized to retrieve metadata about a grid/table 
	-- combined:
	--  data model, column model, row model, view port, selection model
	-- think of it as a live database, optimized for querying
	-- need indexes, bespoke data structures etc..
	-- data model (actual table contents and mapping to rows/columns)
	-- row/column model (  
	
	max_row,
	max_column,
	height, -- how to measure this? think resolution/DPI
	width,	
	
	view_port = { x, y, height, width, zoom, {} }
	
}

--[[
 calculate the span of rows and cols that are visible
   - height, width, x_offset, y_offset
]]

local function visible_cells(model)
	return ipairs(model.cell_models)
end

local function build()
	return {
		cell_models   = cell_models,
		visible_cells = visible_cells,
	}
end

return {
	build = build
}
