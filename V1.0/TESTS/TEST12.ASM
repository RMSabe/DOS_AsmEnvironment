;Test 12: Test wait key press

_teststart:
        push word _teststr
        push word $
        jmp _printtextln
        times RETURN_MARGIN_CALLER nop

        push word $
        jmp _waitkeypress
        times RETURN_MARGIN_CALLER nop

_testend:
        jmp _end

_teststr: db 'Press any key', 0x0

