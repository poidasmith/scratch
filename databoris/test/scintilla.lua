
package.path = "../lua/?.lua;?.lua"
require "common"

setenv("PATH", env("%PATH%;../build/Databoris-Debug/"))

local ffi    = require "ffi"
local user32 = ffi.load "user32"
local win    = require "winnt"
local user32 = ffi.load "user32"
local gdi32  = ffi.load "gdi32"
local ui = require "uiapi"
local sci = require "scintilla_constants"
ffi.load "SciLexer" 

ffi.cdef[[
typedef struct tagSCNotification {
	HWND hwndFrom;
	UINT_PTR idFrom;
	UINT code;
	int position;
	int ch;
	int modifiers;
	int modificationType;
	const char *text;
	int length;		
	int linesAdded;	
	int message;	
	UINT_PTR wParam;	
	LONG_PTR lParam;	
	int line;		
	int foldLevelNow;
	int foldLevelPrev;
	int margin;
	int listType;
	int x;
	int y;
	int token;
	int annotationLinesAdded;
	int updated;
} SCNotification;
]]

local function read_file(f)
	local f = io.open(f, "r")
	local content = f:read("*all")
	f:close()
	return content
end

local sciConfig = {
	width  = 400,
	height = 800,
}

local function sci_configure(hwnd, config)
	local function lps(s) return ffi.cast("LPARAM", s) end  
	local function wps(s) return ffi.cast("WPARAM", s) end  
	user32.SendMessageA(hwnd, sci.SCI_CREATEDOCUMENT, 0, 0)
	user32.SendMessageA(hwnd, sci.SCI_SETTEXT, 0, lps(read_file("../lua/database.lua")))
	user32.SendMessageA(hwnd, sci.SCI_CREATEDOCUMENT, 0, 0)
	--user32.SendMessageA(hwnd, sci.SCI_SETFONTQUALITY, sci.SC_EFF_QUALITY_LCD_OPTIMIZED, 0)
	user32.SendMessageA(hwnd, sci.SCI_SETFONTQUALITY, sci.SC_EFF_QUALITY_ANTIALIASED, 0)
	user32.SendMessageA(hwnd, sci.SCI_SETSCROLLWIDTHTRACKING, 1, 0)
	user32.SendMessageA(hwnd, sci.SCI_SETTABWIDTH, 4, 0)
	
	-- set base styles	
	user32.SendMessageA(hwnd, sci.SCI_STYLECLEARALL, 0, 0)
	for style=0,sci.STYLE_MAX do
		user32.SendMessageA(hwnd, sci.SCI_STYLESETFONT, style, lps("Bitstream Vera Sans Mono"))
		user32.SendMessageA(hwnd, sci.SCI_STYLESETSIZE, style, 10)
		user32.SendMessageA(hwnd, sci.SCI_STYLESETFORE, style, 0xffffff)
		user32.SendMessageA(hwnd, sci.SCI_STYLESETBACK, style, 0x242424)			
	end
	
	-- setup syntax hightlighting for lua
	user32.SendMessageA(hwnd, sci.SCI_SETLEXER, 15, 0)
	user32.SendMessageA(hwnd, sci.SCI_STYLESETFORE, sci.SCE_LUA_COMMENT,       0x808080)
	user32.SendMessageA(hwnd, sci.SCI_STYLESETFORE, sci.SCE_LUA_COMMENTLINE,   0x808080)
	user32.SendMessageA(hwnd, sci.SCI_STYLESETFORE, sci.SCE_LUA_COMMENTDOC,    0x808080)
	user32.SendMessageA(hwnd, sci.SCI_STYLESETFORE, sci.SCE_LUA_STRING,        0xFED8A9)
	user32.SendMessageA(hwnd, sci.SCI_STYLESETFORE, sci.SCE_LUA_LITERALSTRING, 0xFED8A9)
	user32.SendMessageA(hwnd, sci.SCI_STYLESETFORE, sci.SCE_LUA_WORD,          0xE4C9C9)
	user32.SendMessageA(hwnd, sci.SCI_SETKEYWORDS, 0, wps("local end for if then else elseif do return nil function"))
	
	-- setup current line highlighting, caret and selection	
	user32.SendMessageA(hwnd, sci.SCI_SETCARETLINEVISIBLE, 1, 0)
	user32.SendMessageA(hwnd, sci.SCI_SETCARETLINEBACK, 0, 0)
	user32.SendMessageA(hwnd, sci.SCI_SETCARETFORE, 0xaaaa88, 0)
	user32.SendMessageA(hwnd, sci.SCI_SETCARETWIDTH, 2, 0)
	user32.SendMessageA(hwnd, sci.SCI_SETSELFORE, 1, 0xffffff)
	user32.SendMessageA(hwnd, sci.SCI_SETSELBACK, 1, 0x804000)
	user32.SendMessageA(hwnd, sci.SCI_SETSELEOLFILLED, 1, 0)
end

local sciWin
local sciProc

local function wm_setfocus(hwnd, msg, wparam, lparam)
	user32.SetFocus(sciWin)
end

local function wm_size(hwnd, msg, wparam, lparam)
	-- layout children
	local width  = win.LOWORD(lparam)
	local height = win.HIWORD(lparam)
	printf("w:%s, h%s", width, height)
	user32.MoveWindow(sciWin, 0, 0, width, height, true)
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
	if pscin.hwndFrom == sciWin and pscin.code ~= 2013 then
		printf("notify %s, %s", pscin.code, sci.reverse[pscin.code])
	end
end

local function wm_keydown(hwnd, msg, wparam, lparam)
	printf("keydown: %s", wparam)
	if wparam == win.VK_RIGHT then
		return true
	end
	--printf("%s", wparam)
end

local handlers = {
	[win.WM_SIZE]     = wm_size,
	[win.WM_CLOSE]    = wm_close,
	[win.WM_DESTROY]  = wm_destroy,
	[win.WM_NOTIFY]   = wm_notify,
	[win.WM_SETFOCUS] = wm_setfocus,
	[win.WM_KEYDOWN]  = wm_keydown,
}

local sciHandlers = {
	[win.WM_KEYDOWN]  = wm_keydown,
}

local mainWin = ui.window("DBOS_main", handlers, "DBOS - lib.bootstrap.database | lib.bootstrap.common | lib.bootstrap.stream")

local style = bit.bor(win.WS_CHILD, win.WS_VISIBLE, win.WS_TABSTOP, win.WS_CLIPCHILDREN)
sciWin = user32.CreateWindowExA(0, "Scintilla", "", style, 0, 0, 0, 0, mainWin, 0, 0, nil)
ui.subclass(sciWin, sciHandlers)
user32.MoveWindow(mainWin, 10, 10, 1200, 800, true)

sci_configure(sciWin, sciConfig)

ui.show(mainWin, win.SW_SHOW)
ui.update(mainWin)
ui.run() 

