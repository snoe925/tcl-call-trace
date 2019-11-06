Tracing TCL at multiple levels

Shannon Noe
FlightAware.com

https://github.com/snoe925/tcl-call-trace.git



## Ways to trace TCL

TclX cmdtrace

tclgdb = cmdtrace + strace / truss

CFLAGS=-DTCL_COMPILE_DEBUG configure ... make

proc re-definition / pure TCL

Debugger: gdb, lldb, etc ... with scripting

callgrind



How about gcc -finstrument-functions?



instrument-functions is a C compiler feature to add entry and exit callbacks into every C function
```
void __cyg_profile_func_enter(void *this_fn, void *call_site);
void __cyg_profile_func_exit(void *this_fn, void *call_site);
```



Unlike sample profiling we can get a full call trace of the program.



This can be combined with bytecode tracing.
```
0x4160e8 TclNRRunCallbacks at tclBasic.c:4436 from [0x419187 TclEvalObjEx at tclBasic.c:6027]
0x4eef8f TEBCresume at tclExecute.c:2101 from [0x41618a TclNRRunCallbacks at tclBasic.c:4461]
-bytecode-  0:  0 (0) push1 0   # "exit"
-bytecode-  0:  1 (2) push1 1   # "0"
-bytecode-  0:  2 (4) invokeStk1 2
0x415818 TclNREvalObjv at tclBasic.c:4206 from [0x4f400b TEBCresume at tclExecute.c:3052 (discriminator 6)]
0x415a4a EvalObjvCore at tclBasic.c:4233 from [0x41618a TclNRRunCallbacks at tclBasic.c:4461]
0x4151ad TclInterpReady at tclBasic.c:3852 from [0x415b15 EvalObjvCore at tclBasic.c:4251]
0x57eb33 Tcl_ResetResult at tclResult.c:912 from [0x4151dd TclInterpReady at tclBasic.c:3866]
0x57ed28 ResetObjResult at tclResult.c:976 from [0x57eb62 Tcl_ResetResult at tclResult.c:916]
0x4e5cc0 TclResetRewriteEnsemble at tclEnsemble.c:2059 from [0x415ba9 EvalObjvCore at tclBasic.c:4291]
0x4174a5 TEOV_LookupCmdFromObj at tclBasic.c:4867 from [0x415cb6 EvalObjvCore at tclBasic.c:4320]
0x56693a Tcl_GetCommandFromObj at tclObj.c:4133 from [0x417513 TEOV_LookupCmdFromObj at tclBasic.c:4875]
0x41603e Dispatch at tclBasic.c:4389 from [0x41618a TclNRRunCallbacks at tclBasic.c:4461]
0x4298ed Tcl_ExitObjCmd at tclCmdAH.c:1044 from [0x4160ca Dispatch at tclBasic.c:4426]
```


Sidebar a bit of the TCL interpreter
```
0x4160e8 TclNRRunCallbacks at tclBasic.c:4436 from [0x419187 TclEvalObjEx at tclBasic.c:6027]
```
```
4879  typedef struct NRE_callback {
4880      Tcl_NRPostProc *procPtr;
4881      ClientData data[4];
4882      struct NRE_callback *nextPtr;
4883  } NRE_callback;
4884  
4891  #define TclNRAddCallback(interp,postProcPtr,data0,data1,data2,data3) \
4892      do {								\
4893  	NRE_callback *_callbackPtr;					\
4894  	TCLNR_ALLOC((interp), (_callbackPtr));				\
4895  	_callbackPtr->procPtr = (postProcPtr);				\
4896  	_callbackPtr->data[0] = (ClientData)(data0);			\
4897  	_callbackPtr->data[1] = (ClientData)(data1);			\
4898  	_callbackPtr->data[2] = (ClientData)(data2);			\
4899  	_callbackPtr->data[3] = (ClientData)(data3);			\
4900  	_callbackPtr->nextPtr = TOP_CB(interp);				\
4901  	TOP_CB(interp) = _callbackPtr;					\
4902      } while (0)
```



Implementation

Grab TCL source
```
CFLAGS=-finstrument-functions configure --enable-symbols ...
```
Add the two callbacks in new C file
```
__cyg_profile_func_enter
__cyg_profile_func_exit
```



Implementation #2

The API is void * addresses to C functions.

We have trace, but need to use addr2line to decode to line numbers.

We need a way to convert addresses to lines in source files.



Goal: integrate file and line address decoding

Helpfully implemented by
https://github.com/EmilOhlsson/call-trace

This uses Binary File Descriptor library, libbfd.



Implementation #3

Bytecode or other specific tracing of TCL

Tracing of file open()'s
