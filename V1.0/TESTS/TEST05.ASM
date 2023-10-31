;Test 5: test string comparison

TESTSTR1 equ _teststr1
TESTSTR2 equ _teststr4

_teststart:
        push word TESTSTR1
        push word $
        jmp _printtext
        times RETURN_MARGIN_CALLER nop

        mov di, word _textbuf
        mov [di], byte 0x20
        inc di
        mov [di], byte 0

        push word _textbuf
        push word $
        jmp _printtext
        times RETURN_MARGIN_CALLER nop

        push word TESTSTR2
        push word $
        jmp _printtext
        times RETURN_MARGIN_CALLER nop

        mov di, word _textbuf
        mov [di], byte 0x20
        inc di
        mov [di], byte 0

        push word _textbuf
        push word $
        jmp _printtext
        times RETURN_MARGIN_CALLER nop

        push word TESTSTR1
        push word TESTSTR2
        push word $
        jmp _compare_str
        times RETURN_MARGIN_CALLER nop

        mov di, word _textbuf

        test ax, word 1
        jz _result_false

        _result_true:
        mov [di], byte 0x31
        jmp _post_result

        _result_false:
        mov [di], byte 0x30

        _post_result:
        inc di
        mov [di], byte 0

        push word _textbuf
        push word $
        jmp _printtextln
        times RETURN_MARGIN_CALLER nop

_testend:
        jmp _end

_teststr1: db 'sum', 0x0
_teststr2: db 'sub', 0x0
_teststr3: db 'mult', 0x0
_teststr4: db 'sum', 0x0

