
package.path = "../lua/?.lua;?.lua"
require "common"
local ffi = require "ffi"
local win = require "winnt"
local adv32 = ffi.load "advapi32"

local id   = "sid"
local name = "sname"
local desc = "serv desc"
local startup_mode = win.SERVICE_AUTO_START
local deps = {}

-- get path to windows service
local service_path = "F:/eclipse/git/scratch/databoris/test/windows_service.exe"

local sc_manager = adv32.OpenSCManagerA(NULL, NULL, win.SC_MANAGER_CREATE_SERVICE)

local service = adv32.CreateServiceA(sc_manager, id, name, win.SERVICE_ALL_ACCESS, 
	win.SERVICE_WIN32_OWN_PROCESS, startup_mode, win.SERVICE_ERROR_NORMAL, 
	quote_path, load_order_group, NULL, dep_list, user, pwd)

adv32.CloseServiceHandle(service)
adv32.CloseServiceHandle(sc_manager)

