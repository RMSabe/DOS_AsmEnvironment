;DOS Assembly environment
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: wait for user input, load user input into text buffer
;args (push order): output text buffer addr, return addr
_scantext:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        mov di, bx

        _scantext_loop:
        mov ah, byte 0
        int 0x16
        cmp al, byte 0xd
        je _scantext_endloop
        mov [di], byte al
        mov ah, byte 0xe
        int 0x10
        inc di
        jmp _scantext_loop
        _scantext_endloop:

        mov [di], byte 0

        mov ah, byte 0xe
        mov al, byte 0xd
        int 0x10
        mov al, byte 0xa
        int 0x10

        _scantext_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: wait user input
;args (push order): return addr
_waitkeypress:
        mov ah, byte 0
        int 0x16

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: add a new line to standard output
;args (push order): return addr
_printnewline:
        mov ah, byte 0xe

        mov al, byte 0xd
        int 0x10

        mov al, byte 0xa
        int 0x10

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: print a text on standard output
;args (push order): input text buffer addr, return addr
_printtext:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        mov si, bx

        mov ah, 0xe

        _printtext_loop:
        mov al, byte [si]
        cmp al, byte 0
        je _printtext_endloop
        int 0x10
        inc si
        jmp _printtext_loop
        _printtext_endloop:

        _printtext_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: print text to standard output, add new line
;args (push order): input text buffer addr, return addr
_printtextln:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        push word $
        jmp _printtext
        times RETURN_MARGIN_CALLER nop

        push word $
        jmp _printnewline
        times RETURN_MARGIN_CALLER nop

        _printtextln_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: compare two text strings
;args (push order): input text1 buffer addr, input text2 buffer addr, return addr
;return value: ax (1 == equal | 0 == not equal)
_compare_str:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        mov si, bx

        pop word bx
        mov di, bx

        xor cx, cx
        xor dx, dx

        _compare_str_getlen1:
        mov al, byte [si]
        cmp al, byte 0
        je _compare_str_gotlen1
        inc si
        inc cx
        jmp _compare_str_getlen1
        _compare_str_gotlen1:

        sub si, cx

        _compare_str_getlen2:
        mov al, byte [di]
        cmp al, byte 0
        je _compare_str_gotlen2
        inc di
        inc dx
        jmp _compare_str_getlen2
        _compare_str_gotlen2:

        sub di, dx

        cmp cx, dx
        jne _compare_str_return_false

        xor cx, cx
        _compare_str_loop:
        cmp cx, dx
        jae _compare_str_endloop
        mov al, byte [si]
        mov bl, byte [di]
        cmp al, bl
        jne _compare_str_return_false
        inc si
        inc di
        inc cx
        jmp _compare_str_loop
        _compare_str_endloop:

        _compare_str_return_true:
        mov ax, word 1
        jmp _compare_str_return

        _compare_str_return_false:
        xor ax, ax

        _compare_str_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

