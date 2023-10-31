;Test 8: test VGA 1

TEST_COLOR1 equ 0x9
TEST_COLOR2 equ 0xa
TEST_COLOR3 equ 0xc
TEST_COLOR4 equ 0xe

TEST_XPOS_START equ 20
TEST_XPOS_STOP equ 300
TEST_YPOS_START equ 20
TEST_YPOS_STOP equ 180

TEST_DELAYTIME_START equ 0xe000
TEST_DELAYTIME_LOOP equ 0x0010
TEST_DELAYTIME_END equ 0xe000

_teststart:
        push word $
        jmp _vga_startvga
        times RETURN_MARGIN_CALLER nop

        mov si, word _test_xpos
        mov di, word _test_ypos

        mov [si], word TEST_XPOS_START
        mov [di], word TEST_YPOS_START

        push word TEST_DELAYTIME_START
        push word $
        jmp _delay_long
        times RETURN_MARGIN_CALLER nop

_testloop:
        mov si, word _test_ypos
        mov dx, word [si]
        cmp dx, word TEST_YPOS_STOP
        jae _testend

        mov si, word _test_xpos
        mov cx, word [si]

        xor ax, ax

        cmp dx, word 100
        jae _testloop_paint3

        cmp cx, word 160
        jae _testloop_paint2

        _testloop_paint1:
        mov al, byte TEST_COLOR1
        jmp _testloop_l1

        _testloop_paint2:
        mov al, byte TEST_COLOR2
        jmp _testloop_l1

        _testloop_paint3:
        cmp cx, word 160
        jae _testloop_paint4
        mov al, byte TEST_COLOR3
        jmp _testloop_l1

        _testloop_paint4:
        mov al, byte TEST_COLOR4

        _testloop_l1:
        push word ax
        push word cx
        push word dx
        push word $
        jmp _vga_paintpixel_xy
        times RETURN_MARGIN_CALLER nop

        push word TEST_DELAYTIME_LOOP
        push word $
        jmp _delay_long
        times RETURN_MARGIN_CALLER nop

        mov si, word _test_xpos
        mov cx, word [si]
        cmp cx, word TEST_XPOS_STOP
        jae _testloop_l2

        inc cx
        jmp _testloop_l3

        _testloop_l2:
        mov cx, word TEST_XPOS_START
        mov di, word _test_ypos
        mov dx, word [di]
        inc dx
        mov [di], word dx

        _testloop_l3:
        mov [si], word cx

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

