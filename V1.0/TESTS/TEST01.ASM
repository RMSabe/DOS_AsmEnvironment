;Test 1: print unsigned 16bit integer value

NUM16_START equ 0
NUM16_STOP equ 200
DELAYTIME equ 0x0800

_teststart:
        mov di, word _num16
        mov [di], word NUM16_START

_testloop:
        mov si, word _num16
        mov cx, word [si]
        cmp cx, word NUM16_STOP
        jae _testend

        push word cx
        push word _textbuf
        push word $
        jmp _loadstr_dec_u16
        times RETURN_MARGIN_CALLER nop

        push word _textbuf
        push word $
        jmp _printtextln
        times RETURN_MARGIN_CALLER nop

        push word DELAYTIME
        push word $
        jmp _delay_long
        times RETURN_MARGIN_CALLER nop

        mov si, word _num16
        mov cx, word [si]
        inc cx
        mov [si], word cx

        jmp _testloop

_testend:
        jmp _end

_num16: dw 0

