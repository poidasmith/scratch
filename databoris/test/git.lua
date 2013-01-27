
package.path = "../lua/?.lua;?.lua"

require("log")

setenv("PATH", getenv("PATH") .. ";../build/Databoris-Debug/")   

local db = require("database")

--db.git_repository_open(

