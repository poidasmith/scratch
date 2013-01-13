
local ffi      = require("ffi")
local kernel32 = ffi.load("kernel32")

ffi.cdef[[
typedef long           HANDLE;
typedef int            BOOL;
typedef unsigned long  DWORD;
typedef unsigned long* LPDWORD;
typedef void*          LPVOID;
typedef void*          LPCVOID;
typedef void*          LPSECURITY_ATTRIBUTES;
typedef void*          LPOVERLAPPED;
typedef const char*    LPCTSTR;

HANDLE CreateFileA(
	LPCTSTR lpFileName, 
    DWORD dwDesiredAccess, 
    DWORD dwShareMode,
    LPSECURITY_ATTRIBUTES lpSecurityAttributes, 
    DWORD dwCreationDisposition,
    DWORD dwFlagsAndAttributes, 
    HANDLE hTemplateFile
);
BOOL ReadFile(
	HANDLE hFile, 
	LPVOID lpBuffer, 
	DWORD nNumberOfBytesToRead, 
	LPDWORD lpNumberOfBytesRead, 
	LPOVERLAPPED lpOverlapped
);                      
BOOL WriteFile(
	HANDLE hFile,
	const char* lpBuffer,
	DWORD nNumberOfBytesToWrite,
	LPDWORD lpNumberOfBytesWritten,
	LPOVERLAPPED lpOverlapped
);
BOOL CloseHandle(
	HANDLE hObject
);
]]

return {
	kernel32 = kernel32,
	
	GENERIC_READ    = 0x80000000,
	GENERIC_WRITE   = 0x40000000, 
	GENERIC_EXECUTE = 0x20000000,
	GENERIC_ALL     = 0x10000000,
	  	
	CREATE_ALWAYS     = 2,
	CREATE_NEW        = 1,
	OPEN_ALWAYS       = 4,
	OPEN_EXISTING     = 3,
	TRUNCATE_EXISTING = 5,
	
	FILE_ATTRIBUTE_NORMAL = 0x80
}	