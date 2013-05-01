

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

local model = {
	rows,
	row_count,
}

local function set_bounds()
end

local function get_row_count()
end

return model_api