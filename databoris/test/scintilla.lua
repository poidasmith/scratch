
package.path = "../lua/?.lua;?.lua"
require "common"

setenv("PATH", env("%PATH%;../build/Databoris-Debug/"))

local ffi    = require "ffi"
local bit    = require "bit"
local user32 = ffi.load "user32"
local win    = require "winnt"
local user32 = ffi.load "user32"
local gdi32  = ffi.load "gdi32"
local ui     = require "uiapi"
local scc    = require "const_scintilla"

local function read_file(f)
	local f = io.open(f, "r")
	local content = f:read("*all")
	f:close()
	return content
end

local sci = {
	hwnd   = nil,
	proc   = nil,
	position = nil,
	config = {
		width  = 400,
		height = 800,
		tabs   = { width = 2 },
		font_face = "Bitstream Vera Sans Mono", 
		font_size = 10,
		keywords  = "local end for if then else elseif do return nil function",
		style  = { 
			fore       = 0xe0e0e0, 
			back       = 0x242424, 
			comment    = 0x808080,
			string     = 0xFED8A9,
			keyword    = 0xE4C9C9,
			sel_fore   = 0xffffff, 
			sel_back   = 0x804000, 
			caret_fore = 0xaaaa88, 
			line_back  = 0x000000, 
		},
		caret  = { 
			line_visible = true, 
			width        = 2 
		},
		selection = { 
			eol_filled = true 
		},
	},
}

local function lps(s) return ffi.cast("LPARAM", s) end  
local function wps(s) return ffi.cast("WPARAM", s) end  

function print(s)
	if sci.hwnd2 then
		user32.SendMessageA(sci.hwnd2, scc.SCI_ADDTEXT, #s, lps(s))
		user32.SendMessageA(sci.hwnd2, scc.SCI_ADDTEXT, 1, lps("\n"))
		local pos = user32.SendMessageA(sci.hwnd2, scc.SCI_GETCURRENTPOS, 0, 0)
		local length = user32.SendMessageA(sci.hwnd2, scc.SCI_GETLENGTH, 0, 0)
		local line = user32.SendMessageA(sci.hwnd2, scc.SCI_LINEFROMPOSITION, length, 0)
		user32.SendMessageA(sci.hwnd2, scc.SCI_GOTOLINE, line, 0)
	end
end

local function sci_gettextinfo(sci)
	sci.position = user32.SendMessageA(sci.hwnd, scc.SCI_GETCURRENTPOS, 0, 0)
	sci.length   = user32.SendMessageA(sci.hwnd, scc.SCI_GETLENGTH, 0, 0)
	sci.lines    = user32.SendMessageA(sci.hwnd, scc.SCI_GETLINECOUNT, 0, 0)
	sci.line     = user32.SendMessageA(sci.hwnd, scc.SCI_LINEFROMPOSITION, sci.position, 0)
end

local function sci_settext(hwnd, text)
	user32.SendMessageA(hwnd, scc.SCI_SETTEXT, 0, lps(text))
end

local function sci_configure(hwnd, config)
	user32.SendMessageA(hwnd, scc.SCI_CREATEDOCUMENT, 0, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETFONTQUALITY, scc.SC_EFF_QUALITY_ANTIALIASED, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETSCROLLWIDTHTRACKING, 0, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETSCROLLWIDTH, 5, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETVSCROLLBAR, 0, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETHSCROLLBAR, 0, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETTABWIDTH, config.tabs.width or 4, 0)
	
	-- set base styles	
	user32.SendMessageA(hwnd, scc.SCI_STYLECLEARALL, 0, 0)
	for style=0,scc.STYLE_MAX do
		user32.SendMessageA(hwnd, scc.SCI_STYLESETFONT, style, lps(config.font_face))
		user32.SendMessageA(hwnd, scc.SCI_STYLESETSIZE, style, config.font_size)
		user32.SendMessageA(hwnd, scc.SCI_STYLESETFORE, style, config.style.fore)
		user32.SendMessageA(hwnd, scc.SCI_STYLESETBACK, style, config.style.back)			
	end
	
	-- setup syntax hightlighting for lua
	user32.SendMessageA(hwnd, scc.SCI_SETLEXER, 15, 0)
	user32.SendMessageA(hwnd, scc.SCI_STYLESETFORE, scc.SCE_LUA_COMMENT,       config.style.comment)
	user32.SendMessageA(hwnd, scc.SCI_STYLESETFORE, scc.SCE_LUA_COMMENTLINE,   config.style.comment)
	user32.SendMessageA(hwnd, scc.SCI_STYLESETFORE, scc.SCE_LUA_COMMENTDOC,    config.style.comment)
	user32.SendMessageA(hwnd, scc.SCI_STYLESETFORE, scc.SCE_LUA_STRING,        config.style.string)
	user32.SendMessageA(hwnd, scc.SCI_STYLESETFORE, scc.SCE_LUA_LITERALSTRING, config.style.string)
	user32.SendMessageA(hwnd, scc.SCI_STYLESETFORE, scc.SCE_LUA_WORD,          config.style.keyword)
	user32.SendMessageA(hwnd, scc.SCI_SETKEYWORDS, 0, wps(config.keywords))
	
	-- setup current line highlighting, caret and selection	
	user32.SendMessageA(hwnd, scc.SCI_SETCARETLINEVISIBLE, config.caret.line_visible and 1 or 0, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETCARETLINEBACK, 0, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETCARETFORE, config.style.caret_fore, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETCARETWIDTH, 3, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETSELFORE, 1, config.style.sel_fore)
	user32.SendMessageA(hwnd, scc.SCI_SETSELBACK, 1, config.style.sel_back)
	user32.SendMessageA(hwnd, scc.SCI_SETSELEOLFILLED, config.selection.eol_filled and 1 or 0, 0)
end

local function wm_setfocus(hwnd, msg, wparam, lparam)
	user32.SetFocus(sci.hwnd)
end

local function wm_size(hwnd, msg, wparam, lparam)
	-- layout children
	local width  = win.LOWORD(lparam)
	local height = win.HIWORD(lparam)
	printf("w:%s, h%s", width, height)
	user32.MoveWindow(sci.hwnd, 0, 0, 2 * width / 3, height, true)
	user32.MoveWindow(sci.hwnd2, 2 * width / 3 + 1, 0, width / 3, height, true)
end

local function wm_close(hwnd, msg, wparam, lparam)
	-- cleanup
	print("closing")
	user32.DestroyWindow(hwnd)
end

local function wm_destroy(...)
	print("finished")
	user32.PostQuitMessage(0)
end

local function wm_notify(hwnd, msg, wparam, lparam)
	local pscin = ffi.cast("SCNotification*", lparam)
	if pscin.hwndFrom == sci.hwnd and pscin.code ~= 2013 then
		printf("notify %s, %s, %s, %s", pscin.code, scc.reverse[pscin.code], sci.position, pscin.line)
	end
end

local function wm_keydown(hwnd, msg, wparam, lparam)
	-- F9 = evaluate whole buffer, Shift-F9 = evaluate selection, Alt-F9 = evaluate from current line 
	-- 
	local shift, ctrl, alt = win.GetKeyStates(lparam)
	printf("keydown: %s %x shift=%s ctrl=%s alt=%s", wparam, lparam, shift, ctrl, alt)
	if wparam == 120 then
		if shift then
			printf("evaluate selection");	
		elseif alt then
			printf("evaluate from current line")
		else
			printf("evaluate buffer")
		end
		return true
	end
	sci_gettextinfo(sci)
	printf("%s", stringit{pos=sci.position,len=sci.length,lines=sci.lines,line=sci.line})
end

local handlers = {
	[win.WM_SIZE]     = wm_size,
	[win.WM_CLOSE]    = wm_close,
	[win.WM_DESTROY]  = wm_destroy,
	[win.WM_NOTIFY]   = wm_notify,
	[win.WM_SETFOCUS] = wm_setfocus,
	[win.WM_KEYDOWN]  = wm_keydown,
}

sci.handlers = {
	[win.WM_KEYDOWN]     = wm_keydown,
	[win.WM_SYSKEYDOWN]  = wm_keydown,
	[win.WM_CHAR]        = wm_keydown,
}

local mainWin = ui.window("DBOS_main", handlers, "DBOS - lib.bootstrap.database | lib.bootstrap.common | lib.bootstrap.stream")

local style = bit.bor(win.WS_CHILD, win.WS_VISIBLE, win.WS_TABSTOP, win.WS_CLIPCHILDREN)

-- create editor window
ffi.load "SciLexer" 
sci.hwnd = user32.CreateWindowExA(0, "Scintilla", "", style, 0, 0, 0, 0, mainWin, 0, 0, nil)
ui.subclass(sci.hwnd, sci.handlers)
sci_configure(sci.hwnd, sci.config)
sci_settext(sci.hwnd, read_file("../lua/database.lua"))

-- create output window
sci.hwnd2 = user32.CreateWindowExA(0, "Scintilla", "", style, 0, 0, 0, 0, mainWin, 0, 0, nil)
--ui.subclass(sci.hwnd2, sci.handlers)
sci_configure(sci.hwnd2, sci.config)
sci_settext(sci.hwnd2, "")

-- run loop
user32.MoveWindow(mainWin, 10, 300, 1200, 650, true)
ui.show(mainWin, win.SW_SHOW)
ui.update(mainWin)
ui.run() 

