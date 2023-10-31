;Test 10: Test VGA 3

TEST_NCYCLELIMIT equ 4

TEST_DELAYTIME_START equ 0xe000
TEST_DELAYTIME_LOOP equ 0x0400
TEST_DELAYTIME_END equ 0xe000

_teststart:
        push word $
        jmp _vga_startvga
        times RETURN_MARGIN_CALLER nop

        push word TEST_DELAYTIME_START
        push word $
        jmp _delay_long
        times RETURN_MARGIN_CALLER nop

_testloop:
        mov si, word _test_ncycle
        mov cx, word [si]
        cmp cx, word TEST_NCYCLELIMIT
        jae _testend
        
        xor cx, cx
        mov si, word _test_xpos
        mov [si], word cx

        _testloop_l1:
        xor ax, ax
        mov si, word _test_ncolor
        mov al, byte [si]

        mov si, word _test_xpos
        mov di, word _test_ypos
        mov cx, word [si]
        mov dx, word [di]

        push word ax
        push word cx
        push word dx
        push word $
        jmp _vga_paintpixel_xy
        times RETURN_MARGIN_CALLER nop

        mov si, word _test_xpos
        mov cx, word [si]
        cmp cx, word VGA_WIDTH
        jae _testloop_l2
        inc cx
        mov [si], word cx
        jmp _testloop_l1

        _testloop_l2:

        push word TEST_DELAYTIME_LOOP
        push word $
        jmp _delay_long
        times RETURN_MARGIN_CALLER nop

        xor ax, ax
        mov si, word _test_ncolor
        mov al, byte [si]
        inc al
        mov [si], byte al

        mov di, word _test_ypos
        mov dx, word [di]
        cmp dx, word VGA_HEIGHT
        jae _testloop_l3

        inc dx
        jmp _testloop_l4

        _testloop_l3:
        xor dx, dx
        mov si, word _test_ncycle
        mov bx, word [si]
        inc bx
        mov [si], word bx

        _testloop_l4:
        mov [di], word dx

        jmp _testloop

_testend:
        push word TEST_DELAYTIME_END
        push word $
        jmp _delay_long
        times RETURN_MARGIN_CALLER nop

        push word $
        jmp _cga_startcga
        times RETURN_MARGIN_CALLER nop

        jmp _end

_test_xpos: dw 0
_test_ypos: dw 0
_test_ncycle: dw 0
_test_ncolor: db 0

