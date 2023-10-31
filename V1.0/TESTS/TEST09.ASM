;Test 9: Test VGA 2
;WARNING: This test routine will make the screen blink in different colors, following the VGA color palette.
;If you have any history of seizures of epilepsy, make sure to set TEST_DELAYTIME_LOOP to a relatively high value, to avoid fast screen blinking.

TEST_NCYCLELIMIT equ 1

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

        xor ax, ax
        mov si, word _test_ncolor
        mov al, byte [si]

        push word ax
        push word $
        jmp _vga_paintscreen
        times RETURN_MARGIN_CALLER nop

        push word TEST_DELAYTIME_LOOP
        push word $
        jmp _delay_long
        times RETURN_MARGIN_CALLER nop

        mov si, word _test_ncolor
        xor ax, ax
        mov al, byte [si]
        cmp al, byte 0xff
        je _testloop_l1

        jmp _testloop_l2

        _testloop_l1:
        mov di, word _test_ncycle
        mov cx, word [di]
        inc cx
        mov [di], word cx

        _testloop_l2:
        inc al
        mov [si], byte al

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

_test_ncycle: dw 0
_test_ncolor: db 0

