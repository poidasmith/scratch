
package.path = "../lua/?.lua;?.lua"

require "common"

setenv("PATH", env("%PATH%;../build/Databoris-Debug/"))

--os.env.PATH = os.env.PATH .. ";../build/Databoris-Debug/"   

local db = require "database"

local repo = db.repo_open "f:/eclipse/git/scratch"
--db.git_repository_open(

