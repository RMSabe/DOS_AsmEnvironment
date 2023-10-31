;Test 3: print unsigned 32bit integer value
;WARNING: only compatible with i386 and above

NUM32_START equ 0
NUM32_STOP equ 200
DELAYTIME32 equ 0x08000000

_teststart:
        mov di, word _num32
        mov [di], dword NUM32_START

_testloop:
        mov si, word _num32
        mov ecx, dword [si]
        cmp ecx, dword NUM32_STOP
        jae _testend

        push dword ecx
        push word _textbuf
        push word $
        jmp _loadstr_dec_u32
        times RETURN_MARGIN_CALLER nop

        push word _textbuf
        push word $
        jmp _printtextln
        times RETURN_MARGIN_CALLER nop

        push dword DELAYTIME32
        push word $
        jmp _delay32
        times RETURN_MARGIN_CALLER nop

        mov si, word _num32
        mov ecx, dword [si]
        inc ecx
        mov [si], dword ecx

        jmp _testloop

_testend:
        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx

        jmp _end

_num32: dd 0

