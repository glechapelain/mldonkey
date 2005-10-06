#if !defined(_OCAMLFD_H)
#define _OCAMLFD_H

#if defined(__MINGW32__)

#if !defined(PTW32_STATIC_LIB)
#define PTW32_STATIC_LIB
#endif


#define FD_SETSIZE 1024

#include <winsock.h>

struct filedescr {
  union {
    HANDLE handle;
    SOCKET socket;
  } fd;
  enum { KIND_HANDLE, KIND_SOCKET } kind;
};

#define Fd_val(v) (((struct filedescr *) Data_custom_val(v))->fd.handle)
#define Socket_val(v) (((struct filedescr *) Data_custom_val(v))->fd.socket)

typedef HANDLE OS_FD;
typedef SOCKET OS_SOCKET;
typedef unsigned int uint;
extern void win32_maperr(unsigned long errcode);



#else


#define Fd_val(v) Int_val(v)
#define Socket_val(v) Int_val(v)

typedef int OS_FD;
typedef int OS_SOCKET;

#endif

#include "caml/mlvalues.h"
#include "caml/fail.h"
#include "caml/alloc.h"
#include "caml/memory.h"


#include <errno.h>
#include <stdio.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <signal.h>

#ifdef HAS_SIGNALS_H
#include <signals.h>
#endif

#include <sys/types.h>

// off_t is long on mingw, long long everywhere else
#ifdef _OFF64_T_
typedef off64_t OFF_T;
#else
typedef off_t OFF_T;
#endif

#include <sys/time.h>

#ifdef HAS_SYS_SELECT_H
#include <sys/select.h>
#endif

#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>

#ifdef HAS_UNISTD
#include <unistd.h>
#else
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2
#endif

#if defined(__OpenBSD__) || defined(__FreeBSD__)
#include <string.h>
#endif

#if !defined(__MINGW32__) && !defined(__BEOS__)
#include <sys/mman.h>
#endif


#define Nothing ((value) 0)

extern void unix_error (int errcode, char * cmdname, value arg) Noreturn;
extern void uerror (char * cmdname, value arg) Noreturn;

static int seek_command_table[] = {
  SEEK_SET, SEEK_CUR, SEEK_END
};

extern OFF_T os_lseek(OS_FD fd, OFF_T pos, int dir);
extern void os_ftruncate(OS_FD fd, OFF_T len, int sparse);
extern ssize_t os_read(OS_FD fd, char *buf, size_t len);
extern int os_getdtablesize();
extern int64 os_getfdsize(OS_FD fd);
extern int64 os_getfilesize(char *path);
extern void os_set_nonblock(OS_SOCKET fd);
extern void os_uname(char buf[]);


#define HASH_BUFFER_LEN 131072
extern unsigned char hash_buffer[HASH_BUFFER_LEN];


#endif
