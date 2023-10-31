;DOS Assembly environment
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

RETURN_MARGIN_CALLER equ 0x10
RETURN_MARGIN_CALLEE equ 0xc
STACKLIST_SIZE equ 8
TEXTBUF_SIZE equ 32

org 0x0100
bits 16

_start:
        push word _startstr
        push word $
        jmp _printtextln
        times RETURN_MARGIN_CALLER nop

        jmp _main

_end:
        push word _endstr
        push word $
        jmp _printtextln
        times RETURN_MARGIN_CALLER nop

        mov ah, 0x4c
        mov al, 0x00
        int 0x21

_main:
;Insert main routine here

        jmp _end

_stacklist_index: dw 0x0

_stacklist:
times STACKLIST_SIZE dw 0x0

_textbuf:
times TEXTBUF_SIZE db 0x0

%include "INCLUDES/TIME.ASM"
%include "INCLUDES/USERIO.ASM"
%include "INCLUDES/INTTOSTR.ASM"
%include "INCLUDES/CGAUTILS.ASM"
%include "INCLUDES/VGAUTILS.ASM"

_startstr: db 'Started', 0x0
_endstr: db 'Terminated', 0x0
