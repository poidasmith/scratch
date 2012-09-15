
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

local backgrounds = {}

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
	return true, 0
end

function win32.wnd_lbuttondown(hwnd, ...)
	backgrounds[hwnd] = 14
	dbos.debug_printf("lbutton")
	win32.MessageBox(hwnd, win32.GetModuleFileName(), "This program is:", 40)
	return true, 0
end

function win32.wnd_destroy(...)
	win32.PostQuitMessage(0)
	return false, 0
end

function win32.wnd_erasebknd(hwnd, msg, wparam, lparam)	
	return false, 0
end

function win32.wnd_paint(hwnd, msg, wparam, lparam)	
	return true, 0
end

-- styles
win32.WS_EX_WINDOWEDGE    = 0x100
win32.WS_EX_CLIENTEDGE    = 0x200
win32.WS_OVERLAPPEDWINDOW = 0xCF0000
win32.CW_USEDEFAULT       = 0x80000000

-- messages
win32.WM_CLOSE            = 0x0010
win32.WM_DESTROY          = 0x0002
win32.WM_LBUTTONDOWN      = 0x0201
win32.WM_ERASEBKGND		  = 0x0014
win32.WM_PAINT            = 0x000F

-- icons
win32.IDI_APPLICATION = 32512

-- cursors
win32.IDC_ARROW = 32512

-- message box
win32.MB_OK       = 0
win32.MB_OKCANCEL = 1


function dbos.main(hInstance, hPrevInstance, lpCmdLine, nCmdShow)
	local clz = "lua_test_window"
	local cursor = win32.LoadCursor(win32.IDC_ARROW)
	local icon   = win32.LoadIcon(win32.IDI)
	win32.RegisterClassEx(clz, 0, 0, hInstance, icon, cursor, 11)
	local hwnd = win32.CreateWindowEx( 
		win32.WS_EX_WINDOWEDGE, 
		clz, 
		"The title of my window",
		win32.WS_OVERLAPPEDWINDOW,
		win32.CW_USEDEFAULT,
		win32.CW_USEDEFAULT,
		540,
		420,
		nil,
		nil,
		hInstance,
		nil,
		win32.map_wndproc({
			[win32.WM_CLOSE]       = win32.wnd_close,
			[win32.WM_DESTROY]     = win32.wnd_destroy,
			[win32.WM_LBUTTONDOWN] = win32.wnd_lbuttondown,
			[win32.WM_ERASEBKGND]  = win32.wnd_erasebknd,
			[win32.WM_PAINT]       = win32.wnd_paint
		})
	)
	win32.ShowWindow(hwnd, nCmdShow)
	win32.UpdateWindow(hwnd)		
	return win32.MessageLoop()
end
