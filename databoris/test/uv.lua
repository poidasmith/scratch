
local ffi = require "ffi"

ffi.cdef[[
typedef unsigned int SOCKET;
typedef int ssize_t;
typedef unsigned long ULONG;
typedef void* HANDLE;
typedef void* HMODULE;
typedef void* CRITICAL_SECTION;
typedef unsigned char uv_uid_t;
typedef unsigned char uv_gid_t;
typedef unsigned short u_short;
typedef unsigned short ushort;   
typedef unsigned short WORD;
typedef unsigned char  UCHAR;
typedef unsigned short USHORT;   
typedef USHORT ADDRESS_FAMILY;
typedef int uv_file;
typedef struct _stati64 uv_statbuf_t;
typedef SOCKET uv_os_sock_t;
typedef HANDLE uv_thread_t;
typedef HANDLE uv_sem_t;
typedef CRITICAL_SECTION uv_mutex_t;

typedef enum {
  UV_MAX_ERRORS
} uv_err_code;

typedef enum {
  UV_UNKNOWN_HANDLE = 0,
  UV_ASYNC,
  UV_CHECK,
  UV_FS_EVENT,
  UV_FS_POLL,
  UV_HANDLE,
  UV_IDLE,
  UV_NAMED_PIPE,
  UV_POLL,
  UV_PREPARE,
  UV_PROCESS,
  UV_STREAM,
  UV_TCP,
  UV_TIMER,
  UV_TTY,
  UV_UDP,
  UV_SIGNAL,  
  UV_FILE,
  UV_HANDLE_TYPE_MAX
} uv_handle_type;

typedef enum {
  UV_UNKNOWN_REQ = 0,
  UV_REQ_TYPE_PRIVATE,
  UV_REQ_TYPE_MAX
} uv_req_type;

typedef struct uv_loop_s uv_loop_t;
typedef struct uv_err_s uv_err_t;
typedef struct uv_handle_s uv_handle_t;
typedef struct uv_stream_s uv_stream_t;
typedef struct uv_tcp_s uv_tcp_t;
typedef struct uv_udp_s uv_udp_t;
typedef struct uv_pipe_s uv_pipe_t;
typedef struct uv_tty_s uv_tty_t;
typedef struct uv_poll_s uv_poll_t;
typedef struct uv_timer_s uv_timer_t;
typedef struct uv_prepare_s uv_prepare_t;
typedef struct uv_check_s uv_check_t;
typedef struct uv_idle_s uv_idle_t;
typedef struct uv_async_s uv_async_t;
typedef struct uv_process_s uv_process_t;
typedef struct uv_fs_event_s uv_fs_event_t;
typedef struct uv_fs_poll_s uv_fs_poll_t;
typedef struct uv_signal_s uv_signal_t;

typedef struct uv_req_s uv_req_t;
typedef struct uv_getaddrinfo_s uv_getaddrinfo_t;
typedef struct uv_shutdown_s uv_shutdown_t;
typedef struct uv_write_s uv_write_t;
typedef struct uv_connect_s uv_connect_t;
typedef struct uv_udp_send_s uv_udp_send_t;
typedef struct uv_fs_s uv_fs_t;
typedef struct uv_work_s uv_work_t;

typedef struct uv_cpu_info_s uv_cpu_info_t;
typedef struct uv_interface_address_s uv_interface_address_t;

uv_loop_t* uv_loop_new(void);
void uv_loop_delete(uv_loop_t*);
uv_loop_t* uv_default_loop(void);
int uv_run(uv_loop_t*);
int uv_run_once(uv_loop_t*);
void uv_ref(uv_handle_t*);
void uv_unref(uv_handle_t*);
void uv_update_time(uv_loop_t*);
int64_t uv_now(uv_loop_t*);

typedef struct uv_buf_t {
  ULONG len;
  char* base;
} uv_buf_t;

typedef uv_buf_t (*uv_alloc_cb)(uv_handle_t* handle, size_t suggested_size);
typedef void (*uv_read_cb)(uv_stream_t* stream, ssize_t nread, uv_buf_t buf);
typedef void (*uv_read2_cb)(uv_pipe_t* pipe, ssize_t nread, uv_buf_t buf, uv_handle_type pending);
typedef void (*uv_write_cb)(uv_write_t* req, int status);
typedef void (*uv_connect_cb)(uv_connect_t* req, int status);
typedef void (*uv_shutdown_cb)(uv_shutdown_t* req, int status);
typedef void (*uv_connection_cb)(uv_stream_t* server, int status);
typedef void (*uv_close_cb)(uv_handle_t* handle);
typedef void (*uv_poll_cb)(uv_poll_t* handle, int status, int events);
typedef void (*uv_timer_cb)(uv_timer_t* handle, int status);
typedef void (*uv_async_cb)(uv_async_t* handle, int status);
typedef void (*uv_prepare_cb)(uv_prepare_t* handle, int status);
typedef void (*uv_check_cb)(uv_check_t* handle, int status);
typedef void (*uv_idle_cb)(uv_idle_t* handle, int status);
typedef void (*uv_exit_cb)(uv_process_t*, int exit_status, int term_signal);
typedef void (*uv_walk_cb)(uv_handle_t* handle, void* arg);
typedef void (*uv_fs_cb)(uv_fs_t* req);
typedef void (*uv_work_cb)(uv_work_t* req);
typedef void (*uv_after_work_cb)(uv_work_t* req);
typedef void (*uv_getaddrinfo_cb)(uv_getaddrinfo_t* req, int status, struct addrinfo* res);
typedef void (*uv_fs_event_cb)(uv_fs_event_t* handle, const char* filename, int events, int status);
typedef void (*uv_fs_poll_cb)(uv_fs_poll_t* handle, int status, const uv_statbuf_t* prev, const uv_statbuf_t* curr);
typedef void (*uv_signal_cb)(uv_signal_t* handle, int signum);

typedef enum {
  UV_LEAVE_GROUP = 0,
  UV_JOIN_GROUP
} uv_membership;


typedef struct {
  uv_err_code code;
  int sys_errno_;
} uv_err_s ;

uv_err_t uv_last_error(uv_loop_t*);
const char* uv_strerror(uv_err_t err);
const char* uv_err_name(uv_err_t err);

typedef struct _uv_req_s {
  void* data;
  uv_req_type type;
} uv_req_s;

int uv_shutdown(uv_shutdown_t* req, uv_stream_t* handle, uv_shutdown_cb cb);

struct uv_shutdown_s {
  uv_req_s req;
  uv_stream_t* handle;
  uv_shutdown_cb cb;
};

typedef struct _uv_handle_s {
  uv_close_cb close_cb;
  void* data;
  uv_loop_t* loop;
  uv_handle_type type;
} uv_handle_s;

size_t uv_handle_size(uv_handle_type type);
size_t uv_req_size(uv_req_type type);
int uv_is_active(const uv_handle_t* handle);
void uv_walk(uv_loop_t* loop, uv_walk_cb walk_cb, void* arg);
void uv_close(uv_handle_t* handle, uv_close_cb close_cb);
uv_buf_t uv_buf_init(char* base, unsigned int len);
size_t uv_strlcpy(char* dst, const char* src, size_t size);
size_t uv_strlcat(char* dst, const char* src, size_t size);

typedef struct _uv_stream_s {
  uv_handle_s handle;
  size_t write_queue_size;
  uv_alloc_cb alloc_cb;
  uv_read_cb read_cb;
  uv_read2_cb read2_cb;
} uv_stream_s;

int uv_listen(uv_stream_t* stream, int backlog, uv_connection_cb cb);
int uv_accept(uv_stream_t* server, uv_stream_t* client);
int uv_read_start(uv_stream_t*, uv_alloc_cb alloc_cb, uv_read_cb read_cb);
int uv_read_stop(uv_stream_t*);
int uv_read2_start(uv_stream_t*, uv_alloc_cb alloc_cb, uv_read2_cb read_cb);
int uv_write(uv_write_t* req, uv_stream_t* handle, uv_buf_t bufs[], int bufcnt, uv_write_cb cb);
int uv_write2(uv_write_t* req, uv_stream_t* handle, uv_buf_t bufs[], int bufcnt, uv_stream_t* send_handle, uv_write_cb cb);

struct uv_write_s {
  uv_req_s req;
  uv_write_cb cb;
  uv_stream_t* send_handle;
  uv_stream_t* handle;
};

int uv_is_readable(const uv_stream_t* handle);
int uv_is_writable(const uv_stream_t* handle);
int uv_is_closing(const uv_handle_t* handle);

struct uv_tcp_s {
  uv_handle_s handle;
  uv_stream_s stream;
};

typedef struct in_addr {
    union {
                struct { UCHAR s_b1,s_b2,s_b3,s_b4; } S_un_b;
                struct { USHORT s_w1,s_w2; } S_un_w;
                ULONG S_addr;
        } S_un;
} in_addr;
typedef struct sockaddr_in {
  short  sin_family;
  ushort sin_port;
  struct in_addr sin_addr;
  char   sin_zero[8];
} sockaddr_in;

typedef struct in6_addr {
    union {
        UCHAR       Byte[16];
        USHORT      Word[8];
    } u;
} IN6_ADDR;

typedef struct {
    union {
        struct {
            ULONG Zone : 28;
            ULONG Level : 4;
        };
        ULONG Value;
    };
} SCOPE_ID;

typedef struct sockaddr_in6 {
    ADDRESS_FAMILY sin6_family;
    USHORT sin6_port;
    ULONG  sin6_flowinfo;
    IN6_ADDR sin6_addr;
    union {
        ULONG sin6_scope_id;
        SCOPE_ID sin6_scope_struct; 
    };
} SOCKADDR_IN6_LH;

int uv_tcp_init(uv_loop_t*, uv_tcp_t* handle);
int uv_tcp_open(uv_tcp_t* handle, uv_os_sock_t sock);
int uv_tcp_nodelay(uv_tcp_t* handle, int enable);
int uv_tcp_keepalive(uv_tcp_t* handle, int enable, unsigned int delay);

int uv_tcp_simultaneous_accepts(uv_tcp_t* handle, int enable);
int uv_tcp_bind(uv_tcp_t* handle, struct sockaddr_in);
int uv_tcp_bind6(uv_tcp_t* handle, struct sockaddr_in6);
int uv_tcp_getsockname(uv_tcp_t* handle, struct sockaddr* name, int* namelen);
int uv_tcp_getpeername(uv_tcp_t* handle, struct sockaddr* name, int* namelen);
int uv_tcp_connect(uv_connect_t* req, uv_tcp_t* handle, struct sockaddr_in address, uv_connect_cb cb);
int uv_tcp_connect6(uv_connect_t* req, uv_tcp_t* handle, struct sockaddr_in6 address, uv_connect_cb cb);

struct uv_connect_s {
  uv_req_s req;
  uv_connect_cb cb;
  uv_stream_t* handle;
};

enum uv_udp_flags {
  UV_UDP_IPV6ONLY = 1,
  UV_UDP_PARTIAL = 2
};

typedef void (*uv_udp_send_cb)(uv_udp_send_t* req, int status);
typedef void (*uv_udp_recv_cb)(uv_udp_t* handle, ssize_t nread, uv_buf_t buf, struct sockaddr* addr, unsigned flags);

struct uv_udp_s {
  uv_handle_s handle;
};

struct uv_udp_send_s {
  uv_req_s req;
  uv_udp_t* handle;
  uv_udp_send_cb cb;
};

int uv_udp_init(uv_loop_t*, uv_udp_t* handle);
int uv_udp_open(uv_udp_t* handle, uv_os_sock_t sock);
int uv_udp_bind(uv_udp_t* handle, struct sockaddr_in addr, unsigned flags);
int uv_udp_bind6(uv_udp_t* handle, struct sockaddr_in6 addr, unsigned flags);
int uv_udp_getsockname(uv_udp_t* handle, struct sockaddr* name, int* namelen);
int uv_udp_set_membership(uv_udp_t* handle, const char* multicast_addr, const char* interface_addr, uv_membership membership);
int uv_udp_set_multicast_loop(uv_udp_t* handle, int on);
int uv_udp_set_multicast_ttl(uv_udp_t* handle, int ttl);
int uv_udp_set_broadcast(uv_udp_t* handle, int on);
int uv_udp_set_ttl(uv_udp_t* handle, int ttl);
int uv_udp_send(uv_udp_send_t* req, uv_udp_t* handle, uv_buf_t bufs[], int bufcnt, struct sockaddr_in addr, uv_udp_send_cb send_cb);
int uv_udp_send6(uv_udp_send_t* req, uv_udp_t* handle, uv_buf_t bufs[], int bufcnt, struct sockaddr_in6 addr, uv_udp_send_cb send_cb);
int uv_udp_recv_start(uv_udp_t* handle, uv_alloc_cb alloc_cb, uv_udp_recv_cb recv_cb);
int uv_udp_recv_stop(uv_udp_t* handle);

struct uv_tty_s {
  uv_handle_s handle;
  uv_stream_s stream;
};

int uv_tty_init(uv_loop_t*, uv_tty_t*, uv_file fd, int readable);
int uv_tty_set_mode(uv_tty_t*, int mode);
void uv_tty_reset_mode(void);
int uv_tty_get_winsize(uv_tty_t*, int* width, int* height);
uv_handle_type uv_guess_handle(uv_file file);

struct uv_pipe_s {
  uv_handle_s handle;
  uv_stream_s stream;
  int ipc;
};

int uv_pipe_init(uv_loop_t*, uv_pipe_t* handle, int ipc);
int uv_pipe_open(uv_pipe_t*, uv_file file);
int uv_pipe_bind(uv_pipe_t* handle, const char* name);
void uv_pipe_connect(uv_connect_t* req, uv_pipe_t* handle, const char* name, uv_connect_cb cb);
void uv_pipe_pending_instances(uv_pipe_t* handle, int count);

struct uv_poll_s {
  uv_handle_s handle;
  uv_poll_cb poll_cb;
};

enum uv_poll_event {
  UV_READABLE = 1,
  UV_WRITABLE = 2
};

int uv_poll_init(uv_loop_t* loop, uv_poll_t* handle, int fd);
int uv_poll_init_socket(uv_loop_t* loop, uv_poll_t* handle, uv_os_sock_t socket);
int uv_poll_start(uv_poll_t* handle, int events, uv_poll_cb cb);
int uv_poll_stop(uv_poll_t* handle);

struct uv_prepare_s {
  uv_handle_s handle;
};

int uv_prepare_init(uv_loop_t*, uv_prepare_t* prepare);
int uv_prepare_start(uv_prepare_t* prepare, uv_prepare_cb cb);
int uv_prepare_stop(uv_prepare_t* prepare);

struct uv_check_s {
  uv_handle_s handle;
};

int uv_check_init(uv_loop_t*, uv_check_t* check);
int uv_check_start(uv_check_t* check, uv_check_cb cb);
int uv_check_stop(uv_check_t* check);

struct uv_idle_s {
  uv_handle_s handle;
};

int uv_idle_init(uv_loop_t*, uv_idle_t* idle);
int uv_idle_start(uv_idle_t* idle, uv_idle_cb cb);
int uv_idle_stop(uv_idle_t* idle);

struct uv_async_s {
  uv_handle_s handle;
};

int uv_async_init(uv_loop_t*, uv_async_t* async, uv_async_cb async_cb);
int uv_async_send(uv_async_t* async);


struct uv_timer_s {
  uv_handle_s handle;
};

int uv_timer_init(uv_loop_t*, uv_timer_t* timer);
int uv_timer_start(uv_timer_t* timer, uv_timer_cb cb, int64_t timeout, int64_t repeat);
int uv_timer_stop(uv_timer_t* timer);
int uv_timer_again(uv_timer_t* timer);
void uv_timer_set_repeat(uv_timer_t* timer, int64_t repeat);
int64_t uv_timer_get_repeat(uv_timer_t* timer);

struct uv_getaddrinfo_s {
  uv_req_s req;
  uv_loop_t* loop;
};

int uv_getaddrinfo(uv_loop_t* loop, uv_getaddrinfo_t* req, uv_getaddrinfo_cb getaddrinfo_cb, const char* node, const char* service, const struct addrinfo* hints);
void uv_freeaddrinfo(struct addrinfo* ai);

typedef enum {
  UV_IGNORE         = 0x00,
  UV_CREATE_PIPE    = 0x01,
  UV_INHERIT_FD     = 0x02,
  UV_INHERIT_STREAM = 0x04,
  UV_READABLE_PIPE  = 0x10,
  UV_WRITABLE_PIPE  = 0x20
} uv_stdio_flags;

typedef struct uv_stdio_container_s {
  uv_stdio_flags flags;
  union {
    uv_stream_t* stream;
    int fd;
  } data;
} uv_stdio_container_t;

typedef struct uv_process_options_s {
  uv_exit_cb exit_cb;
  const char* file;
  char** args;
  char** env;
  char* cwd;
  unsigned int flags;
  int stdio_count;
  uv_stdio_container_t* stdio;
  uv_uid_t uid;
  uv_gid_t gid;
} uv_process_options_t;

enum uv_process_flags {
  UV_PROCESS_SETUID = (1 << 0),
  UV_PROCESS_SETGID = (1 << 1),
  UV_PROCESS_WINDOWS_VERBATIM_ARGUMENTS = (1 << 2),
  UV_PROCESS_DETACHED = (1 << 3)
};

struct uv_process_s {
  uv_handle_s handle;
  uv_exit_cb exit_cb;
  int pid;
};

int uv_spawn(uv_loop_t*, uv_process_t*, uv_process_options_t options);
int uv_process_kill(uv_process_t*, int signum);
uv_err_t uv_kill(int pid, int signum);

struct uv_work_s {
  uv_req_s req;
  uv_loop_t* loop;
  uv_work_cb work_cb;
  uv_after_work_cb after_work_cb;
};

int uv_queue_work(uv_loop_t* loop, uv_work_t* req, uv_work_cb work_cb, uv_after_work_cb after_work_cb);

struct uv_cpu_info_s {
  char* model;
  int speed;
  struct uv_cpu_times_s {
    uint64_t user;
    uint64_t nice;
    uint64_t sys;
    uint64_t idle;
    uint64_t irq;
  } cpu_times;
};

struct uv_interface_address_s {
  char* name;
  int is_internal;
  union {
    struct sockaddr_in address4;
    struct sockaddr_in6 address6;
  } address;
};

char** uv_setup_args(int argc, char** argv);
uv_err_t uv_get_process_title(char* buffer, size_t size);
uv_err_t uv_set_process_title(const char* title);
uv_err_t uv_resident_set_memory(size_t* rss);
uv_err_t uv_uptime(double* uptime);
uv_err_t uv_cpu_info(uv_cpu_info_t** cpu_infos, int* count);
void uv_free_cpu_info(uv_cpu_info_t* cpu_infos, int count);
uv_err_t uv_interface_addresses(uv_interface_address_t** addresses, int* count);
void uv_free_interface_addresses(uv_interface_address_t* addresses, int count);

typedef enum {
  UV_FS_UNKNOWN = -1,
  UV_FS_CUSTOM,
  UV_FS_OPEN,
  UV_FS_CLOSE,
  UV_FS_READ,
  UV_FS_WRITE,
  UV_FS_SENDFILE,
  UV_FS_STAT,
  UV_FS_LSTAT,
  UV_FS_FSTAT,
  UV_FS_FTRUNCATE,
  UV_FS_UTIME,
  UV_FS_FUTIME,
  UV_FS_CHMOD,
  UV_FS_FCHMOD,
  UV_FS_FSYNC,
  UV_FS_FDATASYNC,
  UV_FS_UNLINK,
  UV_FS_RMDIR,
  UV_FS_MKDIR,
  UV_FS_RENAME,
  UV_FS_READDIR,
  UV_FS_LINK,
  UV_FS_SYMLINK,
  UV_FS_READLINK,
  UV_FS_CHOWN,
  UV_FS_FCHOWN
} uv_fs_type;

struct uv_fs_s {
  uv_req_s req;
  uv_fs_type fs_type;
  uv_loop_t* loop;
  uv_fs_cb cb;
  ssize_t result;
  void* ptr;
  const char* path;
  uv_err_code errorno;
};

void uv_fs_req_cleanup(uv_fs_t* req);
int uv_fs_close(uv_loop_t* loop, uv_fs_t* req, uv_file file, uv_fs_cb cb);
int uv_fs_open(uv_loop_t* loop, uv_fs_t* req, const char* path, int flags, int mode, uv_fs_cb cb);
int uv_fs_read(uv_loop_t* loop, uv_fs_t* req, uv_file file, void* buf, size_t length, int64_t offset, uv_fs_cb cb);
int uv_fs_unlink(uv_loop_t* loop, uv_fs_t* req, const char* path, uv_fs_cb cb);
int uv_fs_write(uv_loop_t* loop, uv_fs_t* req, uv_file file, void* buf, size_t length, int64_t offset, uv_fs_cb cb);
int uv_fs_mkdir(uv_loop_t* loop, uv_fs_t* req, const char* path, int mode, uv_fs_cb cb);
int uv_fs_rmdir(uv_loop_t* loop, uv_fs_t* req, const char* path, uv_fs_cb cb);
int uv_fs_readdir(uv_loop_t* loop, uv_fs_t* req, const char* path, int flags, uv_fs_cb cb);
int uv_fs_stat(uv_loop_t* loop, uv_fs_t* req, const char* path, uv_fs_cb cb);
int uv_fs_fstat(uv_loop_t* loop, uv_fs_t* req, uv_file file, uv_fs_cb cb);
int uv_fs_rename(uv_loop_t* loop, uv_fs_t* req, const char* path, const char* new_path, uv_fs_cb cb);
int uv_fs_fsync(uv_loop_t* loop, uv_fs_t* req, uv_file file, uv_fs_cb cb);
int uv_fs_fdatasync(uv_loop_t* loop, uv_fs_t* req, uv_file file, uv_fs_cb cb);
int uv_fs_ftruncate(uv_loop_t* loop, uv_fs_t* req, uv_file file, int64_t offset, uv_fs_cb cb);
int uv_fs_sendfile(uv_loop_t* loop, uv_fs_t* req, uv_file out_fd, uv_file in_fd, int64_t in_offset, size_t length, uv_fs_cb cb);
int uv_fs_chmod(uv_loop_t* loop, uv_fs_t* req, const char* path, int mode, uv_fs_cb cb);
int uv_fs_utime(uv_loop_t* loop, uv_fs_t* req, const char* path, double atime, double mtime, uv_fs_cb cb);
int uv_fs_futime(uv_loop_t* loop, uv_fs_t* req, uv_file file, double atime, double mtime, uv_fs_cb cb);
int uv_fs_lstat(uv_loop_t* loop, uv_fs_t* req, const char* path, uv_fs_cb cb);
int uv_fs_link(uv_loop_t* loop, uv_fs_t* req, const char* path, const char* new_path, uv_fs_cb cb);
int uv_fs_symlink(uv_loop_t* loop, uv_fs_t* req, const char* path, const char* new_path, int flags, uv_fs_cb cb);
int uv_fs_readlink(uv_loop_t* loop, uv_fs_t* req, const char* path, uv_fs_cb cb);
int uv_fs_fchmod(uv_loop_t* loop, uv_fs_t* req, uv_file file, int mode, uv_fs_cb cb);
int uv_fs_chown(uv_loop_t* loop, uv_fs_t* req, const char* path, int uid, int gid, uv_fs_cb cb);
int uv_fs_fchown(uv_loop_t* loop, uv_fs_t* req, uv_file file, int uid, int gid, uv_fs_cb cb);

enum uv_fs_event {
  UV_RENAME = 1,
  UV_CHANGE = 2
};

struct uv_fs_event_s {
  uv_handle_s handle;
  char* filename;
};

struct uv_fs_poll_s {
  uv_handle_s handle;
  void* poll_ctx;
};

int uv_fs_poll_init(uv_loop_t* loop, uv_fs_poll_t* handle);
int uv_fs_poll_start(uv_fs_poll_t* handle, uv_fs_poll_cb poll_cb, const char* path, unsigned int interval);
int uv_fs_poll_stop(uv_fs_poll_t* handle);

struct uv_signal_s {
  uv_handle_s handle;
  uv_signal_cb signal_cb;
  int signum;
};

int uv_signal_init(uv_loop_t* loop, uv_signal_t* handle);
int uv_signal_start(uv_signal_t* handle, uv_signal_cb signal_cb, int signum);
int uv_signal_stop(uv_signal_t* handle);
void uv_loadavg(double avg[3]);

enum uv_fs_event_flags {
  UV_FS_EVENT_WATCH_ENTRY = 1,
  UV_FS_EVENT_STAT = 2,
  UV_FS_EVENT_RECURSIVE = 3
};

int uv_fs_event_init(uv_loop_t* loop, uv_fs_event_t* handle, const char* filename, uv_fs_event_cb cb, int flags);

struct sockaddr_in uv_ip4_addr(const char* ip, int port);
struct sockaddr_in6 uv_ip6_addr(const char* ip, int port);
int uv_ip4_name(struct sockaddr_in* src, char* dst, size_t size);
int uv_ip6_name(struct sockaddr_in6* src, char* dst, size_t size);
uv_err_t uv_inet_ntop(int af, const void* src, char* dst, size_t size);
uv_err_t uv_inet_pton(int af, const char* src, void* dst);
int uv_exepath(char* buffer, size_t* size);
uv_err_t uv_cwd(char* buffer, size_t size);
uv_err_t uv_chdir(const char* dir);
uint64_t uv_get_free_memory(void);
uint64_t uv_get_total_memory(void);
extern uint64_t uv_hrtime(void);

typedef struct {
  HMODULE handle;
  char* errmsg;
} uv_lib_t;

void uv_disable_stdio_inheritance(void);
int uv_dlopen(const char* filename, uv_lib_t* lib);
void uv_dlclose(uv_lib_t* lib);
int uv_dlsym(uv_lib_t* lib, const char* name, void** ptr);
const char* uv_dlerror(uv_lib_t* lib);

typedef void* CONDITION_VARIABLE;
typedef void* SRWLOCK;
typedef CRITICAL_SECTION uv_mutex_t;
typedef HANDLE uv_sem_t;

typedef struct _fallback {
  unsigned int waiters_count;
  CRITICAL_SECTION waiters_count_lock;
  HANDLE signal_event;
  HANDLE broadcast_event;
} fallback;

typedef union {
  CONDITION_VARIABLE cond_var;
  fallback fallback;
} uv_cond_t;

typedef union {
  SRWLOCK srwlock_;
  struct {
    uv_mutex_t read_mutex_;
    uv_mutex_t write_mutex_;
    unsigned int num_readers_;
  } fallback_;
} uv_rwlock_t;

typedef struct {
  unsigned int n;
  unsigned int count;
  uv_mutex_t mutex;
  uv_sem_t turnstile1;
  uv_sem_t turnstile2;
} uv_barrier_t;

typedef struct uv_once_s {
  unsigned char ran;
  HANDLE event;
} uv_once_t;

int uv_mutex_init(uv_mutex_t* handle);
void uv_mutex_destroy(uv_mutex_t* handle);
void uv_mutex_lock(uv_mutex_t* handle);
int uv_mutex_trylock(uv_mutex_t* handle);
void uv_mutex_unlock(uv_mutex_t* handle);
int uv_rwlock_init(uv_rwlock_t* rwlock);
void uv_rwlock_destroy(uv_rwlock_t* rwlock);
void uv_rwlock_rdlock(uv_rwlock_t* rwlock);
int uv_rwlock_tryrdlock(uv_rwlock_t* rwlock);
void uv_rwlock_rdunlock(uv_rwlock_t* rwlock);
void uv_rwlock_wrlock(uv_rwlock_t* rwlock);
int uv_rwlock_trywrlock(uv_rwlock_t* rwlock);
void uv_rwlock_wrunlock(uv_rwlock_t* rwlock);
int uv_sem_init(uv_sem_t* sem, unsigned int value);
void uv_sem_destroy(uv_sem_t* sem);
void uv_sem_post(uv_sem_t* sem);
void uv_sem_wait(uv_sem_t* sem);
int uv_sem_trywait(uv_sem_t* sem);
int uv_cond_init(uv_cond_t* cond);
void uv_cond_destroy(uv_cond_t* cond);
void uv_cond_signal(uv_cond_t* cond);
void uv_cond_broadcast(uv_cond_t* cond);
void uv_cond_wait(uv_cond_t* cond, uv_mutex_t* mutex);
int uv_cond_timedwait(uv_cond_t* cond, uv_mutex_t* mutex, uint64_t timeout);
int uv_barrier_init(uv_barrier_t* barrier, unsigned int count);
void uv_barrier_destroy(uv_barrier_t* barrier);
void uv_barrier_wait(uv_barrier_t* barrier);
void uv_once(uv_once_t* guard, void (*callback)(void));
int uv_thread_create(uv_thread_t *tid, void (*entry)(void *arg), void *arg);
unsigned long uv_thread_self(void);
int uv_thread_join(uv_thread_t *tid);
]]

return ffi.load "uv"
