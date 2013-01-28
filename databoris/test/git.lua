
package.path = "../lua/?.lua;?.lua"

require "common"

setenv("PATH", getenv("PATH") .. ";../build/Databoris-Debug/")   

local db = require("database")

--db.git_repository_open(

