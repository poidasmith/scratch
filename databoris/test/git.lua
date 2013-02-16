
package.path = "../lua/?.lua;?.lua"

require "bootstrap"

setenv("PATH", env("%PATH%;../build/Databoris-Debug/"))

--os.env.PATH = os.env.PATH .. ";../build/Databoris-Debug/"   

local db = require "database"

-- TEST

local repo = db.open "f:/eclipse/git/scratch"
local oid = repo:name_to_id "refs/remotes/origin/master"
-- better? repo:ref['remotes/origin/master']
print(oid)
local c = repo:lookup(oid)
print(c.type)
print(c.message)
print("author="..stringit(c.author))
--print(c.time)
print(c.id)
print(c.id)
print(stringit(c.parents))
local tree = c.tree
print(tree.type)
print(repo:type(tree.id))
local entries = tree.entries
print(stringit(entries))

local function dump_tree(tree, indent)
	local indent = indent or 0
	for k,v in pairs(tree.entries) do
		printf("%s%-20s %s, %s", ("    "):rep(indent), k, v.id, v.type)
		if v.type == db.GIT_OBJ_TREE then
			--printf("tree")
			local st = repo:lookup(v.id)
			--print(st)
			dump_tree(st, indent + 1)
		end
	end
end

dump_tree(tree)

--local readme = repo:lookup(entries['README.md'].id, entries['README.md'].type)
--print(readme)
--print(readme.type)
--print(readme.data)



