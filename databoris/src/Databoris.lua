
-- load 
--   config
--   snapshot
--   index

--require("debugger")(nil, nil, "databoris")

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

--[[
mainwindow = {
	style = bitor( win32.CS_HREDRAW, win32.CS_VREDRAW ),
	wndproc = {
		[win32.WM_DESTROY] = dbos.win32_quit,
	}
}
--]]

function win32.map_wndproc(handlers)
	return function(hwnd, msg, wparam, lparam)
		local f = handlers[msg]
		if f ~= nil then
			return f(hwnd, msg, wparam, lparam) 
		end
		return false
	end
end

function win32.wnd_close(hwnd, msg, wparam, lparam)
	win32.DestroyWindow(hwnd)
	return false
end

function win32.wnd_destroy(...)
	win32.PostQuitMessage(0)
	return true, 0
end

win32.WS_EX_CLIENTEDGE    = 0x200
win32.WS_OVERLAPPEDWINDOW = 0xCF0000
win32.CW_USEDEFAULT       = 0x80000000
win32.WM_CLOSE            = 0x0010
win32.WM_DESTROY          = 0x0002

function dbos.main(hInstance, hPrevInstance, lpCmdLine, nCmdShow)
	local clz = "lua_test_window"
	win32.RegisterClassEx(clz)
	local hwnd = win32.CreateWindowEx( 
		win32.WS_EX_CLIENTEDGE, 
		clz, 
		"The title of my window",
		win32.WS_OVERLAPPEDWINDOW,
		win32.CW_USEDEFAULT,
		win32.CW_USEDEFAULT,
		240,
		120,
		nil,
		nil,
		hInstance,
		nil,
		win32.map_wndproc({
			[win32.WM_CLOSE]   = win32.wnd_close,
			[win32.WM_DESTROY] = win32.wnd_destroy
		})
	)
	win32.ShowWindow(hwnd, nCmdShow)
	win32.UpdateWindow(hwnd)		
	return win32.MessageLoop()
end
