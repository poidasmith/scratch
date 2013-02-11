-- libgit2 wrapper
-- in-memory MRU cache of git objects
-- server framework for git operations (bespoke git server)

local ffi = require("ffi")
local git = ffi.load("git2")

ffi.cdef[[
typedef struct git_repository git_repository;
typedef struct git_reference  git_reference;
typedef struct git_config     git_config;
typedef struct git_oid        git_oid;
typedef struct git_commit     git_commit;
typedef struct git_object     git_object;
typedef struct git_odb_object git_odb_object;
typedef struct git_blob       git_blob;
typedef int    git_otype;
typedef int    git_off_t;

void git_libgit2_version(int *major, int *minor, int *rev);
int  git_libgit2_capabilities(void);
void git_libgit2_opts(int option, ...);

int  __cdecl git_repository_open(git_repository **out, const char *path);
void git_repository_free(git_repository *repo);
int  git_repository_init(git_repository **out,const char *path, unsigned is_bare);
int  git_repository_head(git_reference **out, git_repository *repo);
int  git_repository_set_workdir(git_repository *repo, const char *workdir, int update_gitlink);
int  git_repository_config(git_config **out, git_repository *repo);
void git_repository_set_config(git_repository *repo, git_config *config);

int  git_reference_lookup(git_reference **out, git_repository *repo, const char *name);
int  git_reference_name_to_id(git_oid *out, git_repository *repo, const char *name);

const char* git_commit_message(const git_commit *commit);
const git_oid* git_commit_tree_id(const git_commit *commit);
unsigned int git_commit_parentcount(const git_commit *commit);
const git_oid* git_commit_parent_id(git_commit *commit, unsigned int n);

void git_object_free(git_object *object);
int  git_object_lookup(
		git_object **object,
		git_repository *repo,
		const git_oid *id,
		git_otype type);
git_otype git_object_type(const git_object *obj);

const void* git_blob_rawcontent(const git_blob *blob);
git_off_t git_blob_rawsize(const git_blob *blob);
int git_blob_create_frombuffer(git_oid *oid, git_repository *repo, const void *buffer, size_t len);

const void* git_odb_object_data(git_odb_object *object);
int git_odb_object_size(git_odb_object *object);
]]

local impl = {}

function impl.repo_open(path)
	local repo = ffi.new("git_repository*");
	local res = git.git_repository_open(repo, path)
	if res ~= 0 then
		errorf("problem opening repository: %d", res)
	end
	return repo	
end

function impl.repo_free(repo)
	git.git_repository_free(repo)
end

return impl

