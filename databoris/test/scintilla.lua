
package.path = "../lua/?.lua;?.lua"
require "common"

setenv("PATH", env("%PATH%;../build/Databoris-Debug/"))

local ffi    = require "ffi"
local user32 = ffi.load "user32"
local win    = require "winnt"
local user32 = ffi.load "user32"
local gdi32  = ffi.load "gdi32"
local ui     = require "uiapi"
local scc    = require "const_scintilla"
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

local sci = {
	hwnd   = nil,
	proc   = nil,
	position = nil,
	config = {
		width  = 400,
		height = 800,
		tabs   = { width = 4 },
		text   = read_file("../lua/database.lua"),
		style  = { 
			fore      = 0xffffff, 
			back      = 0x242424, 
			font_face = "Bitstream Vera Sans Mono", 
			font_size = 10,
			comment   = 0x808080,
			string    = 0xFED8A9,
			keyword   = 0xE4C9C9,
			keywords  = "local end for if then else elseif do return nil function",
		},
		caret  = { 
			line_visible = true, 
			line_back    = 0, 
			fore         = 0xaaaa88, 
			width        = 2 
		},
		selection = { 
			fore       = 0xffffff, 
			back       = 0x804000, 
			eol_filled = true 
		},
	},
}

local function sci_gettextinfo(sci)
	sci.position = user32.SendMessageA(sci.hwnd, scc.SCI_GETCURRENTPOS, 0, 0)
	sci.length   = user32.SendMessageA(sci.hwnd, scc.SCI_GETLENGTH, 0, 0)
	sci.lines    = user32.SendMessageA(sci.hwnd, scc.SCI_GETLINECOUNT, 0, 0)
	sci.line     = user32.SendMessageA(sci.hwnd, scc.SCI_LINEFROMPOSITION, sci.position, 0)
end

local function sci_configure(hwnd, config)
	local function lps(s) return ffi.cast("LPARAM", s) end  
	local function wps(s) return ffi.cast("WPARAM", s) end  
	user32.SendMessageA(hwnd, scc.SCI_CREATEDOCUMENT, 0, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETTEXT, 0, lps(config.text))
	user32.SendMessageA(hwnd, scc.SCI_SETFONTQUALITY, scc.SC_EFF_QUALITY_ANTIALIASED, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETSCROLLWIDTHTRACKING, 1, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETTABWIDTH, config.tabs.width or 4, 0)
	
	-- set base styles	
	user32.SendMessageA(hwnd, scc.SCI_STYLECLEARALL, 0, 0)
	for style=0,scc.STYLE_MAX do
		user32.SendMessageA(hwnd, scc.SCI_STYLESETFONT, style, lps(config.style.font_face))
		user32.SendMessageA(hwnd, scc.SCI_STYLESETSIZE, style, config.style.font_size)
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
	user32.SendMessageA(hwnd, scc.SCI_SETKEYWORDS, 0, wps(config.style.keywords))
	
	-- setup current line highlighting, caret and selection	
	user32.SendMessageA(hwnd, scc.SCI_SETCARETLINEVISIBLE, config.caret.line_visible and 1 or 0, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETCARETLINEBACK, 0, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETCARETFORE, 0xaaaa88, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETCARETWIDTH, 2, 0)
	user32.SendMessageA(hwnd, scc.SCI_SETSELFORE, 1, 0xffffff)
	user32.SendMessageA(hwnd, scc.SCI_SETSELBACK, 1, 0x804000)
	user32.SendMessageA(hwnd, scc.SCI_SETSELEOLFILLED, 1, 0)
end

local function wm_setfocus(hwnd, msg, wparam, lparam)
	user32.SetFocus(sci.hwnd)
end

local function wm_size(hwnd, msg, wparam, lparam)
	-- layout children
	local width  = win.LOWORD(lparam)
	local height = win.HIWORD(lparam)
	printf("w:%s, h%s", width, height)
	user32.MoveWindow(sci.hwnd, 0, 0, width, height, true)
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
	printf("keydown: %s %s", wparam, lparam)
	if wparam == 190 or wparam == 46 then
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
sci.hwnd = user32.CreateWindowExA(0, "Scintilla", "", style, 0, 0, 0, 0, mainWin, 0, 0, nil)
ui.subclass(sci.hwnd, sci.handlers)
user32.MoveWindow(mainWin, 10, 300, 1200, 650, true)

sci_configure(sci.hwnd, sci.config)

ui.show(mainWin, win.SW_SHOW)
ui.update(mainWin)
ui.run() 

