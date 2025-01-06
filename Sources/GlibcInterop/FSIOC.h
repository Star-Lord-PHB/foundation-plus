#ifdef __linux__
#ifndef FSIOC_H
#define FSIOC_H 1

#define _GNU_SOURCE

#include <asm/unistd.h>
#include <fcntl.h>
#include <linux/fs.h>


int fgetFileFlags(int fd, unsigned int* flags);
int fsetFileFlags(int fd, unsigned int flags);

// int getFileFlags(const char* path, unsigned int* flags);
// int setFileFlags(const char* path, unsigned int flags);


#ifdef __NR_statx

#include <linux/stat.h>
#define SUPPORT_BIRTHTIME 1

#else // __NR_statx

#include <sys/stat.h>

struct statx {
    __u32 stx_nlink;
    __u32 stx_uid;
    __u32 stx_gid;
    __u16 stx_mode;
    __u64 stx_size;
    struct timespec	stx_atime;
    struct timespec	stx_btime;
    struct timespec	stx_ctime;
    struct timespec	stx_mtime;
};

#define SUPPORT_BIRTHTIME1 0

#endif // __NR_statx

int fstat_compat(int fd, struct statx* stx);
int stat_compat(const char* path, struct statx* stx);

extern const long long UTIME_OMIT_INTEROP;
extern const long long UTIME_NOW_INTEROP;

#endif // FSIOC_H
#endif // __linux__