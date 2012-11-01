
local ffi = require("ffi")

ffi.cdef[[
	typedef unsigned short  WORD;
	typedef unsigned char   u_char;
	typedef unsigned short  u_short;
	typedef unsigned int    u_int;
	typedef unsigned long   u_long;
	typedef UINT_PTR SOCKET;
	typedef struct fd_set {
		u_int   fd_count;
		SOCKET  fd_array[64];
	} fd_set;
	typedef struct WSAData {
	        WORD                    wVersion;
	        WORD                    wHighVersion;
	        char                    szDescription[257];
	        char                    szSystemStatus[129];
	        unsigned short          iMaxSockets;
	        unsigned short          iMaxUdpDg;
	        char *                  lpVendorInfo;
	} WSADATA;
	SOCKET accept(SOCKET s,struct sockaddr *addr, int *addrlen);	
	int bind(SOCKET s, const struct sockaddr *name, int namelen);
	int closesocket(SOCKET s);
	int connect(SOCKET s, const struct sockaddr *name, int namelen);
	struct hostent* gethostbyaddr(const char *addr, int len, int type);
	struct hostent* gethostbyname(const char *name);
	int gethostname(char *name, int namelen);
	int getsockopt(SOCKET s, int level, int optname, char *optval, int *optlen);
	u_long htonl(u_long hostlong);
	u_short htons(u_short hostshort);
	int listen(SOCKET s, int backlog);
	int ioctlsocket(SOCKET s, long cmd, u_long *argp);
	int recv(SOCKET s, char *buf, int len, int flags);
	int recvfrom(SOCKET s, char *buf, int len, int flags, struct sockaddr *from, int *fromlen);
	int select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, const struct timeval *timeout);
	int send(SOCKET s, const char *buf, int len, int flags);
	int sendto(SOCKET s, const char *buf, int len, int flags, const struct sockaddr *to, int tolen);
	int setsockopt(SOCKET s, int level, int optname, const char *optval, int optlen);
	int shutdown(SOCKET s, int how);
	SOCKET socket(int af, int type, int protocol);
	int WSAStartup(WORD wVersionRequested, WSADATA* lpWSAData);
]]

return {}