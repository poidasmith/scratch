
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

return function() return ffi, bit, win, ui, user32, gdi32 end 