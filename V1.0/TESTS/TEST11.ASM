;Test 11: Test scan user input

_teststart:
        push word _test_entertextstr
        push word $
        jmp _printtext
        times RETURN_MARGIN_CALLER nop

        push word _textbuf
        push word $
        jmp _scantext
        times RETURN_MARGIN_CALLER nop

        push word _test_youenteredstr
        push word $
        jmp _printtext
        times RETURN_MARGIN_CALLER nop

        push word _textbuf
        push word $
        jmp _printtextln
        times RETURN_MARGIN_CALLER nop

_testend:
        jmp _end

_test_entertextstr: db 'Enter text: ', 0x0
_test_youenteredstr: db 'You entered: ', 0x0

