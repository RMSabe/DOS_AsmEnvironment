;Test 6: test CGA 1

TEST_NCYCLELIMIT equ 8

TEST_DELAYTIME_START equ 0x2000
TEST_DELAYTIME_LOOP equ 0x0400
TEST_DELAYTIME_END equ 0x2000

_teststart:
        push word $
        jmp _cga_clearscreen
        times RETURN_MARGIN_CALLER nop

        push word TEST_DELAYTIME_START
        push word $
        jmp _delay_long
        times RETURN_MARGIN_CALLER nop

_testloop:
        mov si, word _test_ncount
        mov cx, word [si]
        cmp cx, word TEST_NCYCLELIMIT
        jae _testend

        xor ax, ax
        mov si, word _test_ncolor
        mov al, byte [si]

        push word ax
        push word $
        jmp _cga_setcolorbyte
        times RETURN_MARGIN_CALLER nop

        push word _teststr
        push word $
        jmp _cga_printtextln
        times RETURN_MARGIN_CALLER nop

        push word TEST_DELAYTIME_LOOP
        push word $
        jmp _delay_long
        times RETURN_MARGIN_CALLER nop

        mov si, word _test_ncolor
        mov al, byte [si]
        cmp al, byte 0x7f
        jae _testloop_l1

        inc al
        jmp _testloop_l2

        _testloop_l1:
        xor al, al
        mov di, word _test_ncount
        mov cx, word [di]
        inc cx
        mov [di], word cx

        _testloop_l2:
        mov [si], byte al

        jmp _testloop

_testend:
        push word TEST_DELAYTIME_END
        push word $
        jmp _delay_long
        times RETURN_MARGIN_CALLER nop

        jmp _end

_test_ncount: dw 0x0
_test_ncolor: db 0x0
_teststr: db 'Hello There', 0x0

