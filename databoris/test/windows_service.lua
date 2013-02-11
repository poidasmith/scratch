
local ffi = require "ffi"
local adv = ffi.load "Advapi32" 

ffi.cdef [[
typedef char* LPTSTR, LPSTR;
typedef unsigned long DWORD;
typedef int BOOL;
typedef void (*LPSERVICE_MAIN_FUNCTION)(DWORD dwNumServicesArgs, LPSTR *lpServiceArgVectors);
typedef struct _SERVICE_TABLE_ENTRY {
  LPTSTR                  lpServiceName;
  LPSERVICE_MAIN_FUNCTION lpServiceProc;
} SERVICE_TABLE_ENTRY, *LPSERVICE_TABLE_ENTRY;
BOOL StartServiceCtrlDispatcher(const SERVICE_TABLE_ENTRY *lpServiceTable);
void ServiceCtrlHandler(DWORD opCode);
]]

local function service_ctrl(opcode)
end

local function service_main(argc, argv)
 -- register ctrl handler
 -- 
end