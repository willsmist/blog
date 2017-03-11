---
title: Linux 进程管理命令
date: 2017-02-23 04:36:09
tags:
categories:
---

Linux 进程学习笔记

<!--more-->

---

## Linux Process

Processes carry out tasks within the operating system. A program is a set of machine code instructions and data stored in an executable image on disk and is, as such, a passive entity; a process can be thought of as a computer program in action.

### State

As a process executes it changes state according to its circumstances. Linux processes have the following states:

* ***Running***

The process is either running (it is the current process in the system) or it is ready to run (it is waiting to be assigned to one of the system's CPUs).

* ***Waiting***

The process is waiting for an event or for a resource. Linux differentiates between two types of waiting process; **interruptible** and **uninterruptible**. Interruptible waiting processes can be interrupted by signals whereas uninterruptible waiting processes are waiting directly on hardware conditions and cannot be interrupted under any circumstances.

* ***Stopped***

The process has been stopped, usually by receiving a signal. A process that is being debugged can be in a stopped state.

* ***Zombie***

This is a halted process which, for some reason, still has a **task_struct** data structure in the **task vector**. It is what it sounds like, a dead process.


### Identifiers

Every process in the system has a process identifier. The process identifier is not an index into the **task vector**, it is simply a number. Each process also has User and group identifiers, these are used to control this processes access to the files and devices in the system.

### Links

In a Linux system no process is independent of any other process. Every process in the system, except the initial process has a parent process. New processes are not created, they are copied, or rather **cloned** from previous processes. Every **task_struct** representing a process keeps pointers to its parent process and to its siblings (those processes with the same parent process) as well as to its own child processes. You can see the family relationship between the running processes in a Linux system using the **pstree** command:

```
# pstree -pu
init(1)─┬─auditd(1338)───{auditd}(1339)
        ├─crond(1495)
        ├─master(1481)─┬─pickup(1491,postfix)
        │              └─qmgr(1492,postfix)
        ├─mingetty(1521)
        ├─mingetty(1523)
        ├─mingetty(1525)
        ├─mingetty(1527)
        ├─mingetty(1529)
        ├─mingetty(1536)
        ├─rsyslogd(1360)─┬─{rsyslogd}(1361)
        │                ├─{rsyslogd}(1362)
        │                └─{rsyslogd}(1363)
        ├─sshd(1401)───sshd(1557)───bash(1561)───pstree(1615)
        └─udevd(604)─┬─udevd(1535)
                     └─udevd(1537)
```

Additionally all of the processes in the system are held in a doubly linked list whose root is the init processes **task_struct** data structure. This list allows the Linux kernel to look at every process in the system. It needs to do this to provide support for commands such as ps or kill

### Times and Timers

The kernel keeps track of a processes creation time as well as the CPU time that it consumes during its lifetime. Each clock tick, the kernel updates the amount of time in **jiffies** that the current process has spent in system and in user mode. Linux also supports process specific **interval** timers, processes can use system calls to set up timers to send signals to themselves when the timers expire. These timers can be single-shot or periodic timers.


## 查看进程

### ps - report a snapshot of the current processes

***ps [options]***

**ps** displays information about a selection of the active processes. If you want a repetitive update of the selection and the displayed information, use top(1) instead.

This version of ps accepts several kinds of options:
       1   UNIX options, which may be grouped and must be preceded by a dash.
       2   BSD options, which may be grouped and must not be used with a dash.
       3   GNU long options, which are preceded by two dashes.

Options of different types may be freely mixed, but conflicts can appear. There are some synonymous options, which are functionally identical, due to the many standards and ps implementations that this ps is compatible with.


EXAMPLES
       To see every process on the system using standard syntax:
          ps -e
          ps -ef
          ps -eF
          ps -ely

       To see every process on the system using BSD syntax:
          ps ax
          ps axu

       To print a process tree:
          ps -ejH
          ps axjf


* **a** option causes ps to list all processes with a terminal (tty), or to list all processes when used together with the **x** option.

* **x** option causes ps to list all processes owned by you (same EUID as ps), or to list all processes when used together with the **a** option.

* **u** output format control option. display user-oriented format.

* **j** BSD job control format

* **f** ASCII-art process hierarchy (forest)

* **-e**  Select all processes. Identical to -A.

* **-f** does full-format listing. This option can be combined with many other UNIX-style options to add additional columns. It also causes the command arguments to be printed. When used with -L, the NLWP (number of threads) and LWP (thread ID) columns will be added. See the c option, the format keyword args, and the format keyword comm.

* **-F** extra full format. See the -f option, which -F implies.

* **-l** long format. The **-y** option is often useful with this.

* **-y** Do not show flags; show rss in place of addr. This option can only be used with **-l**.

* **-j** jobs format

* **-H** show process hierarchy (forest)

### pstree - display a tree of processes

***pstree [options] [pid]|[user]***

pstree shows running processes as a tree. The tree is rooted  at  either pid  or init if pid is omitted. If a user name is specified, all process trees rooted at processes owned by that user are shown.

* **-p**     Show PIDs. PIDs are shown as decimal numbers in parentheses after each process name. -p implicitly disables compaction.

* **-u**     Show uid transitions(转变). Whenever the uid of a process differs  from the  uid of its parent, the new uid is shown in parentheses after the process name.

* **-a**     Show command line arguments. If the command line of a process  is swapped  out, that process is shown in parentheses. -a implicitly disables compaction.

* **-h**     Highlight  the current process and its ancestors. This is a no-op if the terminal doesn’t support highlighting or  if  neither  the current process nor any of its ancestors are in the subtree being shown.

* **-H**     Like -h, but highlight the specified process instead. Unlike with -h,  pstree fails when using -H if highlighting is not available.

* **-n**     Sort processes with the same ancestor by PID instead of by  name.(Numeric sort.)


### top - display Linux tasks

***top -hv | -abcHimMsS -d delay -n iterations -p pid [, pid ...]***

The  top  program provides a dynamic real-time view of a running system. It can display system summary information as well as  a  list  of  tasks currently  being  managed by the Linux kernel.

## w - Show who is logged on and what they are doing

***w - [husfiV] [user]***

w  displays  information about the users currently on the machine, and their processes.  The header shows, in this order,  the current time, how long the system has been running, how many users are currently logged on, and the system load averages for the past 1, 5, and 15 minutes.

The following entries are displayed for each user: login name, the tty name, the remote host, login time, idle time, JCPU, PCPU, and the command line of their  current process.

The  JCPU time is the time used by all processes attached to the tty.  It does not include past background jobs, but does include currently running background jobs.

The PCPU time is the time used by the current process, named in the "what" field.


## 杀死进程

###  kill - terminate a process

***kill [-s signal|-p] [--] pid...
       kill -l [signal]***

The  command kill sends the specified signal to the specified process or process group.  If no signal is specified, the TERM signal is sent.  The TERM  signal  will  kill  processes which do not catch this signal.  For other processes, it may be necessary to use the KILL (9)  signal,  since this signal cannot be caught.

* **pid...** Specify the list of processes that kill should signal.  Each pid can be one of five things:

              n      where n is larger than 0.  The process with pid n will be signaled.

              0      All processes in the current process group are signaled.

              -1     All processes with pid larger than 1 will be signaled.

              -n     where  n  is  larger  than 1.  All processes in process group n are signaled.  When an argument of the form ‘-n’ is given, and it is meant to denote a process group, either the signal must be specified first, or the argument must be preceded by a ‘--’ option, otherwise it will be taken as the  signal to send.

* **-s signal**   Specify the signal to send.  The signal may be given as a signal name or number.

* **-l**     Print a list of signal names.  These are found in /usr/include/linux/signal.h

```
# kill -l
 1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
 6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM
16) SIGSTKFLT	17) SIGCHLD	18) SIGCONT	19) SIGSTOP	20) SIGTSTP
21) SIGTTIN	22) SIGTTOU	23) SIGURG	24) SIGXCPU	25) SIGXFSZ
26) SIGVTALRM	27) SIGPROF	28) SIGWINCH	29) SIGIO	30) SIGPWR
31) SIGSYS	34) SIGRTMIN	35) SIGRTMIN+1	36) SIGRTMIN+2	37) SIGRTMIN+3
38) SIGRTMIN+4	39) SIGRTMIN+5	40) SIGRTMIN+6	41) SIGRTMIN+7	42) SIGRTMIN+8
43) SIGRTMIN+9	44) SIGRTMIN+10	45) SIGRTMIN+11	46) SIGRTMIN+12	47) SIGRTMIN+13
48) SIGRTMIN+14	49) SIGRTMIN+15	50) SIGRTMAX-14	51) SIGRTMAX-13	52) SIGRTMAX-12
53) SIGRTMAX-11	54) SIGRTMAX-10	55) SIGRTMAX-9	56) SIGRTMAX-8	57) SIGRTMAX-7
58) SIGRTMAX-6	59) SIGRTMAX-5	60) SIGRTMAX-4	61) SIGRTMAX-3	62) SIGRTMAX-2
63) SIGRTMAX-1	64) SIGRTMAX

# kill -l 15
TERM

# kill -l KILL
9

```


### killall - kill processes by name

***killall [-Z,--context pattern] [-e,--exact] [-g,--process-group] [-i,--interactive] [-q,--quiet] [-r,--regexp] [-s,--signal signal] [-u,--user user] [-v,--verbose]
       [-w,--wait] [-I,--ignore-case] [-V,--version] [--] name ...***

***killall -l***

killall sends a signal to all processes running any of the specified commands. If no signal name is specified, SIGTERM is sent.

Signals can be specified either by name (e.g. -HUP or -SIGHUP ) or by number (e.g. -1) or by option -s.

If the command name is not regular expression (option -r) and contains a slash (/), processes executing that particular file will be selected for killing, independent of their name.

killall  returns a zero return code if at least one process has been killed for each listed command, or no commands were listed and at least one process matched the -u and -Z search criteria. killall returns non-zero otherwise.

A killall process never kills itself (but may kill other killall processes).


OPTIONS
       -e, --exact
              Require an exact match for very long names. If a command name is longer than 15 characters, the full name may be unavailable (i.e. it  is  swapped  out).  In
              this  case,  killall  will kill everything that matches within the first 15 characters. With -e, such entries are skipped.  killall prints a message for each
              skipped entry if -v is specified in addition to -e,

       -I, --ignore-case
              Do case insensitive process name match.

       -g, --process-group
              Kill the process group to which the process belongs. The kill signal is only sent once per group, even if multiple processes belonging to  the  same  process
              group were found.

       -i, --interactive
              Interactively ask for confirmation before killing.

       -l, --list
              List all known signal names.

       -q, --quiet
              Do not complain if no processes were killed.

       -r, --regexp
              Interpret process name pattern as an extended regular expression.

       -s, --signal
              Send this signal instead of SIGTERM.

       -u, --user
              Kill only processes the specified user owns. Command names are optional.

       -v, --verbose
              Report if the signal was successfully sent.

       -V, --version
              Display version information.

       -w, --wait
              Wait for all killed processes to die. killall checks once per second if any of the killed processes still exist and only returns if none are left.  Note that
              killall may wait forever if the signal was ignored, had no effect, or if the process stays in zombie state.

       -Z, --context
              (SELinux Only) Specify security context: kill only processes having security context that match with given expended regular expression pattern. Must  precede
              other arguments on the command line. Command names are optional.

### pgrep, pkill - look up or signal processes based on name and other attributes

SYNOPSIS

       pgrep [-flvx] [-d delimiter] [-n|-o] [-P ppid,...] [-g pgrp,...]
            [-s sid,...] [-u euid,...] [-U uid,...] [-G gid,...]
            [-t term,...] [pattern]

       pkill [-signal] [-fvx] [-n|-o] [-P ppid,...] [-g pgrp,...]
            [-s sid,...] [-u euid,...] [-U uid,...] [-G gid,...]
            [-t term,...] [pattern]

DESCRIPTION

       pgrep  looks through the currently running processes and lists the process IDs which matches the selection criteria to stdout.  All the criteria have to match.  For example,

       pgrep -u root sshd

       will only list the processes called sshd AND owned by root.  On the other hand,

       pgrep -u root,daemon

       will list the processes owned by root OR daemon.

       pkill will send the specified signal (by default SIGTERM) to each process instead of listing them on stdout.

OPTIONS

       -d delimiter

              Sets the string used to delimit each process ID in the output (by default a newline).  (pgrep only.)

       -f     The pattern is normally only matched against the process name.  When -f is set, the full command line is used.

       -g pgrp,...

              Only match processes in the process group IDs listed.  Process group 0 is translated into pgrep’s or pkill’s own process group.

       -G gid,...
              Only match processes whose real group ID is listed.  Either the numerical or symbolical value may be used.

       -l     List the process name as well as the process ID. (pgrep only.)

       -n     Select only the newest (most recently started) of the matching processes.

       -o     Select only the oldest (least recently started) of the matching processes.

       -P ppid,...
              Only match processes whose parent process ID is listed.

       -s sid,...
              Only match processes whose process session ID is listed.  Session ID 0 is translated into pgrep’s or pkill’s own session ID.

       -t term,...
              Only match processes whose controlling terminal is listed.  The terminal name should be specified without the "/dev/" prefix.

       -u euid,...
              Only match processes whose effective user ID is listed.  Either the numerical or symbolical value may be used.

       -U uid,...
              Only match processes whose real user ID is listed.  Either the numerical or symbolical value may be used.

       -v     Negates the matching.

       -x     Only match processes whose name (or command line if -f is specified) exactly match the pattern.

       -signal
              Defines the signal to send to each matched process.  Either the numeric or the symbolic signal name can be used.  (pkill only.)

OPERANDS
       pattern
              Specifies an Extended Regular Expression for matching against the process names or command lines.

EXAMPLES
       Example 1: Find the process ID of the named daemon:

       unix$ pgrep -u root named

       Example 2: Make syslog reread its configuration file:

       unix$ pkill -HUP syslogd

       Example 3: Give detailed information on all xterm processes:

       unix$ ps -fp $(pgrep -d, -x xterm)

       Example 4: Make all netscape processes run nicer:

       unix$ renice +4 ‘pgrep netscape‘

EXIT STATUS
       0      One or more processes matched the criteria.

       1      No processes matched.

       2      Syntax error in the command line.

       3      Fatal error: out of memory etc.

NOTES
       The process name used for matching is limited to the 15 characters present in the output of /proc/pid/stat.  Use the -f option to match against the complete command line, /proc/pid/cmdline.

       The running pgrep or pkill process will never report itself as a match.

通过 -t 选项剔除某个用户：

```
# pkill -9 -t pts/1
```


## 进程优先级

### 查看进程优先级

ps 命令的 -el 选项可查看进程优先级：

```
# ps -el
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
4 S     0     1     0  0  80   0 -   726 -      ?        00:00:01 init
1 S     0     2     0  0  80   0 -     0 -      ?        00:00:00 kthreadd
1 S     0     3     2  0 -40   - -     0 -      ?        00:00:00 migration/0
1 S     0     4     2  0  80   0 -     0 -      ?        00:00:00 ksoftirqd/0
1 S     0     5     2  0 -40   - -     0 -      ?        00:00:00 stopper/0
1 S     0     6     2  0 -40   - -     0 -      ?        00:00:00 watchdog/0
1 S     0     7     2  0 -40   - -     0 -      ?        00:00:00 migration/1
1 S     0     8     2  0 -40   - -     0 -      ?        00:00:00 stopper/1
1 S     0     9     2  0  80   0 -     0 -      ?        00:00:00 ksoftirqd/1
1 S     0    10     2  0 -40   - -     0 -      ?        00:00:00 watchdog/1
5 S     0    11     2  0  80   0 -     0 -      ?        00:00:00 events/0
1 S     0    12     2  0  80   0 -     0 -      ?        00:00:03 events/1
1 S     0    13     2  0  80   0 -     0 -      ?        00:00:00 events/0
1 S     0    14     2  0  80   0 -     0 -      ?        00:00:00 events/1
1 S     0    15     2  0  80   0 -     0 -      ?        00:00:00 events_long/0
1 S     0    16     2  0  80   0 -     0 -      ?        00:00:00 events_long/1
1 S     0    17     2  0  80   0 -     0 -      ?        00:00:00 events_power_ef
1 S     0    18     2  0  80   0 -     0 -      ?        00:00:00 events_power_ef
```

PRI(Priority) 和 NI(Niceness) 都表示优先级，数字越小表示该进程的优先级越高，用户不能修改 PRI，只能修改 NI 的值。

PRI (最终值) = PRI(原始值) + NI

NI 值的范围是 -20 到 19，普通用户调整 NI 的范围是 0 到 19，而且只能调高 NI 不能减低。
只有 root 用户才能设定进程 NI 为负值，而且可以调整任何用户的进程。

### 修改进程优先级


nice - run a program with modified scheduling priority

***nice [OPTION] [COMMAND [ARG]...]***

Run  COMMAND  with  an adjusted niceness, which affects process scheduling.  With no COMMAND, print the current niceness.  Nicenesses range from -20 (most favorable scheduling) to 19 (least favorable).

    -n, --adjustment=N
        add integer N to the niceness (default 10)

NOTE: your shell may have its own version of nice, which usually supersedes the version described here.  Please refer to  your  shell’s  documentation  for  details about the options it supports.

## 后台进程管理

jobs
fg
bg
ctrl+z
& - 终端关闭，进程终止
nohup COMMAND & - 终端关闭，进程后台继续运行，程序的输出到 nohup.out 文件



## 参考

* [Chapter 4 Processes](http://www.tldp.org/LDP/tlk/kernel/processes.html)
