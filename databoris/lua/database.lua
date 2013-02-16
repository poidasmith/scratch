-- libgit2 wrapper
-- in-memory MRU cache of git objects
-- server framework for git operations (bespoke git server)

local ffi = require("ffi")
local git = ffi.load("git2")

ffi.cdef[[
typedef struct git_repository git_repository;
typedef struct git_odb        git_odb;
typedef struct git_reference  git_reference;
typedef struct git_config     git_config;
typedef struct git_commit     git_commit;
typedef struct git_tree       git_tree;
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
int  __stdcall git_repository_odb(git_odb **out, git_repository *repo);
int  __stdcall git_repository_init(git_repository **out,const char *path, unsigned is_bare);
int  __stdcall git_repository_head(git_reference **out, git_repository *repo);
int  __stdcall git_repository_set_workdir(git_repository *repo, const char *workdir, int update_gitlink);
int  __stdcall git_repository_config(git_config **out, git_repository *repo);
void __stdcall git_repository_set_config(git_repository *repo, git_config *config);

int  __stdcall git_reference_lookup(git_reference **out, git_repository *repo, const char *name);
int  __stdcall git_reference_name_to_oid(git_oid *out, git_repository *repo, const char *name);

char* __stdcall git_oid_tostr(char *out, size_t n, const git_oid *id);

int __stdcall git_commit_lookup(git_commit **out, git_repository *repo, const git_oid *id);

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
void        __stdcall git_odb_free(git_odb *db);
int         __stdcall git_odb_read_header(size_t *len_p, git_otype *type_p, git_odb *db, const git_oid *id);

typedef __int64 git_time_t;
typedef struct git_time {
	git_time_t time;
	int offset;
} git_time;

typedef struct git_signature {
	char *name;
	char *email;
	git_time when;
} git_signature;

const char *          __stdcall git_commit_message(git_commit *commit);
const char *          __stdcall git_commit_message_encoding(git_commit *commit);
const git_signature * __stdcall git_commit_committer(git_commit *commit);
const git_signature * __stdcall git_commit_author(git_commit *commit);
const git_oid *       __stdcall git_commit_id(git_commit *commit);
git_time_t            __stdcall git_commit_time(git_commit *commit);
int                   __stdcall git_commit_time_offset(git_commit *commit);
int                   __stdcall git_commit_tree(git_tree **tree_out, git_commit *commit);
unsigned int          __stdcall git_commit_parentcount(git_commit *commit);
int                   __stdcall git_commit_parent(git_commit **parent, git_commit *commit, unsigned int n);

typedef struct git_tree_entry {
	__int16 removed;
	__int16 attr;
	git_oid oid;
	size_t filename_len;
	char filename[1];
} git_tree_entry;

unsigned int           __stdcall git_tree_entrycount(const git_tree *tree);
git_otype              __stdcall git_tree_entry_type(const git_tree_entry *entry);
const git_oid *        __stdcall git_tree_id(const git_tree *tree);
const git_tree_entry * __stdcall git_tree_entry_byindex(git_tree *tree, size_t idx);

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
		errorf("git error: %s", stringit(res))
	end
end

function db.open(path)
	local repo = ffi.new("git_repository*[1]");
	check(git.git_repository_open(repo, path))
	ffi.gc(repo[0], git.git_repository_free) -- register for cleanup
	return repo[0]	
end

-- OID

local function oid_tostring(oid)
	local out = ffi.new("char[41]")
	local res = git.git_oid_tostr(out, 41, oid)
	return ffi.string(res)
end

local oid_mt = { __tostring = oid_tostring }
local git_oid = ffi.metatype("git_oid", oid_mt)

-- REPO

local repo_idx = {}

function repo_idx.name_to_id(repo, name)
	local oid = git_oid()
	check(git.git_reference_name_to_oid(oid, repo, name))
	return oid			
end

function repo_idx.type(repo, oid)
	local podb = ffi.new("git_odb*[1]") 
	check(git.git_repository_odb(podb, repo))
	ffi.gc(podb[0], git.git_odb_free)
	local plen = ffi.new("size_t[1]")
	local ptype = ffi.new("git_otype[1]")
	check(git.git_odb_read_header(plen, ptype, podb[0], oid))
	return ptype[0], plen[0]
end

local function free(obj)
	git.git_object_free(ffi.cast("struct git_object*", obj))
end

function repo_idx.lookup(repo, oid, type)
	local type = type or repo:type(oid)
	local obj = nil
	if type == db.GIT_OBJ_COMMIT then obj = ffi.new("git_commit*[1]")
	elseif type == db.GIT_OBJ_TREE then obj = ffi.new("git_tree*[1]")
	elseif type == db.GIT_OBJ_BLOB then obj = ffi.new("git_blob*[1]")
	else
		errorf("unknown oid type: %s", type)
	end
	check(git.git_object_lookup(ffi.cast("struct git_object**", obj), repo, oid, type))
	ffi.gc(obj[0], free) -- register for cleanup
	return obj[0]		
end

local repo_mt = { __index = repo_idx }
ffi.metatype("struct git_repository", repo_mt)

-- COMMIT

local function commit_idx(commit, key)
	local function to_cmt(cmt)
		return { name = ffi.string(cmt.name), email = ffi.string(cmt.email), when = cmt.when.time, when_tz = cmt.when.offset }
	end
	if key == "type" then
		return "commit"
	elseif key == "id" then
		return git.git_commit_id(commit)
	elseif key == "message" then
		return ffi.string(git.git_commit_message(commit))
	elseif key == "comitter" then
		return to_cmt(git.git_commit_committer(commit))
	elseif key == "author" then
		return to_cmt(git.git_commit_author(commit))
	elseif key == "time" then
		return git.git_commit_time(commit)
	elseif key == "parents" then
		local parents = {}
		local parent_count = git.git_commit_parentcount(commit)
		parents.n = parent_count 	
		for i=1,parent_count do
			local parent_commit = ffi.new("git_commit*[1]")
			check(git.git_commit_parent(parent_commit, commit, i-1))
			ffi.gc(parent_commit[0], free)
			parents[i] = parent_commit[0]
		end
		return parents
	elseif key == "tree" then
		local tree = ffi.new("git_tree*[1]")
		check(git.git_commit_tree(tree, commit))		
		ffi.gc(tree[0], free)
		return tree[0]
	else
		return nil
	end
end

local com_mt = { __index = commit_idx }
ffi.metatype("struct git_commit", com_mt)

-- TREE

local function tree_idx(tree, key)
	if key == "type" then
		return "tree"
	elseif key == "id" then
		return git.git_tree_id(tree)
	elseif key == "entries" then
		local entries = {}
		local tree_size = git.git_tree_entrycount(tree)
		for i=0,tree_size-1 do
			local entry = git.git_tree_entry_byindex(tree, i)
			local n = ffi.string(entry.filename, entry.filename_len)
			local etype = git.git_tree_entry_type(entry)
			local oid = entry.oid
			entries[n] = { id=oid, type=etype }
		end	
		return entries
	end
end

local tree_mt = { __index = tree_idx }
ffi.metatype("struct git_tree", tree_mt)

-- BLOB

local function blob_idx(blob, key)
	if key == "type" then
		return "blob"
	elseif key == "data" then
		local n = git.git_blob_rawsize(blob)
		local v = git.git_blob_rawcontent(blob);
		return ffi.string(v, n)
	end
end

local blob_mt = { __index = blob_idx }
ffi.metatype("struct git_blob", blob_mt)

return db

