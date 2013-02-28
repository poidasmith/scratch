
--[[

	USING SCINTILLA

hmod = LoadLibrary("SciLexer.DLL");
		if (hmod==NULL)
		{
			MessageBox(hwndParent,
			"The Scintilla DLL could not be loaded.",
			"Error loading Scintilla",
			MB_OK | MB_ICONERROR);
		}
		

	hwndScintilla = CreateWindowEx(0,
		"Scintilla","", WS_CHILD | WS_VISIBLE | WS_TABSTOP | WS_CLIPCHILDREN,
		10,10,500,400,hwndParent,(HMENU)GuiID, hInstance,NULL);
		
	SendMessage(hwndScintilla,SCI_CREATEDOCUMENT, 0, 0);
		

case WM_NOTIFY:
		lpnmhdr = (LPNMHDR) lParam;

		if(lpnmhdr->hwndFrom==hwndScintilla)
		{
			switch(lpnmhdr->code)
			{
				case SCN_CHARADDED:
					/* Hey, Scintilla just told me that a new */
					/* character was added to the Edit Control.*/
					/* Now i do something cool with that char. */
				break;
			}
		}
	break;
			
]]

package.path = "../lua/?.lua;?.lua"
require "common"

setenv("PATH", env("%PATH%;../build/Databoris-Debug/"))

local ffi    = require "ffi"
local user32 = ffi.load "user32"
ffi.load "SciLexer" 

ffi.cdef [[
typedef unsigned long DWORD;
typedef const char* LPCSTR;
typedef long HINSTANCE;
typedef long HWND;
typedef long HMENU;
typedef void* LPVOID;

typedef DWORD (__stdcall* WNDPROC)(HANDLE, DWORD, DWORD, DWORD);

HWND CreateWindowExA(
	DWORD dwExStyle, 
	LPCSTR lpClassName, 
	LPCSTR lpWindowName, 
	DWORD dwStyle, 
	int X, int Y, 
	int nWidth, int nHeight, 
	HWND hWndParent, 
	HMENU hMenu, 
	HINSTANCE hInstance, 
	LPVOID lpParam);
	
]]

local hwnd_mt = { __index = hwnd_idx }
ffi.metatype("HWND", hwnd_mt)

local editor = win {
	-- properties
	class  = "Scintilla",
	styles = nil,
	
	--[[ use layout manager
	x      = 100,
	y      = 100,
	width  = 800,
	height = 600,
	]]
	
	-- setup editor
	init   = function(self, hwnd)
	end,
	
	-- paint editor
	paint  = function(self, hwnd)
	end,
	
	-- resize editor
	resize = function(self, hwnd)
	end,
}


local w = window.new("Scintilla", 500, 400)


-- main windows layout

table = {
	rows = {
		{
			height  = 10,
			class   = "blah",
			hscroll = nil,
			vscroll = { pos = 10 },
			fg      = nil,
			bg      = nil,
			columns = {
				{
				},
			}
		}
	},
}



