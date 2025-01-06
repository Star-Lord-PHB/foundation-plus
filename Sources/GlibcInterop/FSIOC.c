#ifdef __linux__

#include "FSIOC.h"
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <fcntl.h>


#if !defined (FS_IOC_GETFLAGS) || !defined (FS_IOC_SETFLAGS)
#include <errno.h>
#endif

#ifdef SYS_openat2
#include <linux/openat2.h>
#endif


int fgetFileFlags(int fd, unsigned int* flags) {

#ifdef FS_IOC_GETFLAGS
    return ioctl(fd, FS_IOC_GETFLAGS, flags);
#else
    errno = ENOSYS;
    return -1;
#endif

}


int fsetFileFlags(int fd, unsigned int flags) {

#ifdef FS_IOC_SETFLAGS
    return ioctl(fd, FS_IOC_SETFLAGS, &flags);
#else
    errno = ENOSYS;
    return -1;
#endif

}


int fstat_compat(int fd, struct statx* stx) {
#ifdef __NR_statx
    return syscall(
        SYS_statx, fd, "", 
        AT_EMPTY_PATH | AT_STATX_SYNC_AS_STAT, STATX_BASIC_STATS | STATX_BTIME, 
        stx
    );
#else
    struct stat st;
    int result = fstat(fd, &st);
    if (result != 0) { return -1; }
    stx->stx_nlink = (__u32)st.st_nlink;
    stx->stx_uid = (__u32)st.st_uid;
    stx->stx_gid = (__u32)st.st_gid;
    stx->stx_mode = (__u16)st.st_mode;
    stx->stx_size = (__u64)st.st_size;
    stx->stx_atime = st.st_atim;
    stx->stx_mtime = st.st_mtim;
    stx->stx_ctime = st.st_ctim;
    stx->stx_btime.tv_sec = UTIME_OMIT;
    stx->stx_btime.tv_nsec = UTIME_OMIT;
    return 0;
#endif
}


int stat_compat(const char *path, struct statx *stx) {
#ifdef __NR_statx
    return syscall(
        SYS_statx, AT_FDCWD, path, 
        AT_SYMLINK_NOFOLLOW, STATX_BASIC_STATS | STATX_BTIME, 
        stx
    );
#else
    struct stat st;
    int result = stat(path, &st);
    if (result != 0) { return -1; }
    stx->stx_nlink = (__u32)st.st_nlink;
    stx->stx_uid = (__u32)st.st_uid;
    stx->stx_gid = (__u32)st.st_gid;
    stx->stx_mode = (__u16)st.st_mode;
    stx->stx_size = (__u64)st.st_size;
    stx->stx_atime = st.st_atim;
    stx->stx_mtime = st.st_mtim;
    stx->stx_ctime = st.st_ctim;
    stx->stx_btime.tv_sec = UTIME_OMIT;
    stx->stx_btime.tv_nsec = UTIME_OMIT;
    return 0;
#endif
}


const long long UTIME_OMIT_INTEROP = UTIME_OMIT;
const long long UTIME_NOW_INTEROP = UTIME_NOW;

#endif // __linux__