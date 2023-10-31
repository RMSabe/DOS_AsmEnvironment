;Test 7: test CGA 2

_teststart:
        push word $
        jmp _cga_clearscreen
        times RETURN_MARGIN_CALLER nop

        push word 4
        push word $
        jmp _cga_settextpos_y
        times RETURN_MARGIN_CALLER nop

        push word CGA_TEXTCOLOR_YELLOW
        push word CGA_BKCOLOR_BLUE
        push word $
        jmp _cga_setcolor
        times RETURN_MARGIN_CALLER nop

        push word _teststr1
        push word $
        jmp _cga_printtextln
        times RETURN_MARGIN_CALLER nop

        push word 1
        push word $
        jmp _cga_setblinkenable
        times RETURN_MARGIN_CALLER nop

        push word _teststr2
        push word $
        jmp _cga_printtextln
        times RETURN_MARGIN_CALLER nop

        push word CGA_TEXTCOLOR_LTRED
        push word CGA_BKCOLOR_CYAN
        push word $
        jmp _cga_setcolor
        times RETURN_MARGIN_CALLER nop

        push word _teststr3
        push word $
        jmp _cga_printtextln
        times RETURN_MARGIN_CALLER nop

        push word 0
        push word $
        jmp _cga_setblinkenable
        times RETURN_MARGIN_CALLER nop

        push word _teststr4
        push word $
        jmp _cga_printtextln
        times RETURN_MARGIN_CALLER nop

        push word CGA_TEXTCOLOR_BLACK
        push word CGA_BKCOLOR_LTGRAY
        push word $
        jmp _cga_setcolor
        times RETURN_MARGIN_CALLER nop

        push word _teststr5
        push word $
        jmp _cga_printtextln
        times RETURN_MARGIN_CALLER nop

_testend:
        jmp _end

_teststr1: db 'This text should not be blinking', 0x0
_teststr2: db 'This text should be blinking', 0x0
_teststr3: db 'This text should also be blinking', 0x0
_teststr4: db 'But this text should not be blinking', 0x0
_teststr5: db 'This text neither', 0x0

