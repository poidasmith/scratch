
-- load 
--   config
--   snapshot
--   index

function dbos.stringit( t ) 
	local res = ""
	if type( t ) == "table" then
		local first = true
		res = "{"
		for i, v in pairs(t) do
			local sep = ", "
			if first then
				sep = " "
				first = false
			end
			res = res .. sep .. dbos.stringit( i ) .. "=" .. dbos.stringit( v ) 
		end
		res = res .. " }"
	elseif type( t ) == "string" then
		res = string.format( "%q", t )
	else
		res = tostring( t )		
	end
	return res
end

local stringit = dbos.stringit

function dbos.debug_printf( fmt, ... )
	dbos.debug_print( string.format( fmt, ... ) )
end




function dbos.main( argv )
	dbos.debug_printf( "args: %s", argv )
	return 62
end