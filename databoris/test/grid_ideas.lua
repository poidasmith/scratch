


--[[
	get window x,y,w,h
	calc first to last visible rows
		- row count, height of each row
		- 
		
	basics:		
		 - array/list of rows
			 - row {
			 	height,
			 	data (table),
			 	formatter,
			 	renderer (default is text styler),
			 	styles
			 }
		 - array/list of columns
			 - column {
			 	name/label,
			 	attribute (name)
				width,
				getter,
				formatter,
				renderer (default is text styler),
				styles
			 }		
		 - mutations
		 	- row add / insert
		 	- row delete
		 	- attribute update
		 	- set of attribute updates
			- set of above		
		
	data structure for row heights: binary, balanced tree
	              /-- 1
		         2 (store y offset and total width)
		        / \-- 3
			4 --
			    \ /-- 5
			     6
			      \-- 7
		8 -- 
		            -- 9
		      -- 10
		            -- 11
	        12
	                -- 13 
	          -- 14
	                -- 15
]]   