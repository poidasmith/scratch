
--[[
	need a set of modes for mapping events to model mutations
		- scrolling, navigation
		- cell editing
		- column move
		- cell selection
		
	define a state machine for each mode -> mapping of event to a mutation
]]

local controller = {
	state = { left_shift_down = true, }
	
	-- define the set of events that can occur
		-- add/delete row
		-- add/delete column
		-- update row, cell
		-- scroll, cursor move
		-- selection change
 
 	-- define mapping from system events + state to table events
 
	-- job is to mutate the view_model based on events and state
	
	-- declare pattern matches on event types and state combinations
	-- layered state filters  
}


--[[ 
	editor events: key, evaluate	
	type, source, (current) line/row, (current) column, val1, val2, val3 
]]
