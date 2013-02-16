
package.path = "../lua/?.lua;?.lua"

require "bootstrap"

setenv("PATH", env("%PATH%;../build/Databoris-Debug/"))

--os.env.PATH = os.env.PATH .. ";../build/Databoris-Debug/"   

local db = require "database"

--db.git_repository_open(

