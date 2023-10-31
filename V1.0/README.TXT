This project uses a specific calling convention:
All arguments are pushed into the stack before jumping to a routine/function.
Return address should always be the last argument.

RETURN_MARGIN_CALLER and RETURN_MARGIN_CALLEE: these are a "landing area" used when jumping back from callee functions/routines to caller functions/routines.
Their purpose is to prevent repeating or skipping instructions in the caller function/routine.

_stacklist and _stacklist_index: _stacklist is a memory space used as a parallel stack. It's meant to be used by the callee routine/function to temporarily store arguments if necessary.
All values pushed into _stacklist should be popped out of _stacklist before jumping back to the caller function/routine.
_stacklist_index is an index value pointing to the next free space in the _stacklist buffer.
Every time a value is pushed into/popped out of _stacklist, the value of _stacklist_index must be updated.

Assembler instructions:
I used NASM to assemble the code.
Input file is just MAIN.ASM
Output format should be raw binary
Output file extension should be .COM

Example: NASM MAIN.ASM -f bin -o RUN.COM

Author: Rafael Sabe
Email: rafaelmsabe@gmail.com
