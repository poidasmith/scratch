-- libgit2 wrapper
-- in-memory MRU cache of git objects
-- server framework for git operations (bespoke git server)

local ffi = require("ffi")
local git = ffi.load("git2")

ffi.cdef[[
typedef struct git_repository git_repository;
typedef struct git_reference  git_reference;
typedef struct git_config     git_config;
typedef struct git_commit     git_commit;
typedef struct git_object     git_object;
typedef struct git_odb_object git_odb_object;
typedef struct git_blob       git_blob;
typedef int    git_otype;
typedef int    git_off_t;
typedef struct {
	unsigned char id[20];
} git_oid;

void __stdcall git_libgit2_version(int *major, int *minor, int *rev);
int  __stdcall git_libgit2_capabilities(void);
void __stdcall git_libgit2_opts(int option, ...);

int  __stdcall git_repository_open(git_repository **out, const char *path);
void __stdcall git_repository_free(git_repository *repo);
int  __stdcall git_repository_init(git_repository **out,const char *path, unsigned is_bare);
int  __stdcall git_repository_head(git_reference **out, git_repository *repo);
int  __stdcall git_repository_set_workdir(git_repository *repo, const char *workdir, int update_gitlink);
int  __stdcall git_repository_config(git_config **out, git_repository *repo);
void __stdcall git_repository_set_config(git_repository *repo, git_config *config);

int  __stdcall git_reference_lookup(git_reference **out, git_repository *repo, const char *name);
int  __stdcall git_reference_name_to_oid(git_oid *out, git_repository *repo, const char *name);

char* __stdcall git_oid_tostr(char *out, size_t n, const git_oid *id);

const char*    __stdcall git_commit_message(const git_commit *commit);
const git_oid* __stdcall git_commit_tree_id(const git_commit *commit);
unsigned int   __stdcall git_commit_parentcount(const git_commit *commit);
const git_oid* __stdcall git_commit_parent_id(git_commit *commit, unsigned int n);

void __stdcall git_object_free(git_object *object);
int  __stdcall git_object_lookup(
		git_object **object,
		git_repository *repo,
		const git_oid *id,
		git_otype type);
git_otype __stdcall git_object_type(const git_object *obj);

const void* __stdcall git_blob_rawcontent(const git_blob *blob);
git_off_t   __stdcall git_blob_rawsize(const git_blob *blob);
int         __stdcall git_blob_create_frombuffer(git_oid *oid, git_repository *repo, const void *buffer, size_t len);

const void* __stdcall git_odb_object_data(git_odb_object *object);
int         __stdcall git_odb_object_size(git_odb_object *object);
]]

local db = {
	GIT_OBJ_ANY = -2,
	GIT_OBJ_BAD = -1,
	GIT_OBJ__EXT1 = 0,
	GIT_OBJ_COMMIT = 1,
	GIT_OBJ_TREE = 2,		
	GIT_OBJ_BLOB = 3,		
	GIT_OBJ_TAG = 4,		
	GIT_OBJ__EXT2 = 5,		
	GIT_OBJ_OFS_DELTA = 6, 
	GIT_OBJ_REF_DELTA = 7	
}

local function check(res)
	if res ~= 0 then
		errorf("git error: %d", res)
	end
end

function db.open(path)
	local repo = ffi.new("git_repository*[1]");
	check(git.git_repository_open(repo, path))
	return repo[0]	
end

local repo_mt = {}
ffi.metatype("struct git_repository", { __index = repo_mt })

local obj_mt = {}
ffi.metatype("struct git_object", { __index = obj_mt })

local oid_mt = {}
local git_oid = ffi.metatype("git_oid", oid_mt)

function repo_mt.free(repo)
	git.git_repository_free(repo)
end

function repo_mt.name_to_id(repo, name)
	local oid = git_oid()
	check(git.git_reference_name_to_oid(oid, repo, name))
	return oid			
end

function repo_mt.lookup(repo, oid, type)
	local obj = ffi.new("git_object*[1]")
	check(git.git_object_lookup(obj, repo, oid, type))
	return obj[0]		
end

function oid_mt.__tostring(oid)
	local out = ffi.new("char[41]")
	local res = git.git_oid_tostr(out, 41, oid)
	return ffi.string(res)
end

function obj_mt.type(obj)
	return git.git_object_type(obj)
end

function obj_mt.data(obj)
	local str = git.git_odb_object_data(obj)
	return ffi.string(str)
end

local repo = db.open "f:/eclipse/git/scratch"
local oid = repo:name_to_id "refs/remotes/origin/master"
-- better? repo:['remotes/origin/master']
print(oid)
local obj = repo:lookup(oid, db.GIT_OBJ_COMMIT)
print(obj:type())
repo:free()

return db

