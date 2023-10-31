;DOS Assembly environment
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: delay hold execution for a short time
;args (push order): delay time, return addr
_delay_short:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        xor cx, cx

        _delay_short_loop:
        cmp cx, bx
        jae _delay_short_endloop
        inc cx
        jmp _delay_short_loop
        _delay_short_endloop:

        _delay_short_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: hold execution for a long time
;args (push order): delay time, return addr
_delay_long:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        xor cx, cx

        _delay_long_loopout:
        cmp cx, bx
        jae _delay_long_loopoutend
        xor ax, ax
        _delay_long_loopin:
        cmp ax, word 0xffff
        je _delay_long_endloopin
        inc ax
        jmp _delay_long_loopin
        _delay_long_endloopin:
        inc cx
        jmp _delay_long_loopout
        _delay_long_loopoutend:

        _delay_long_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: hold execution for a time
;WARNING: only compatible with i386 and above
;args (push order): delay time (32bit), return addr
_delay32:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop dword ebx
        xor ecx, ecx

        _delay32_loop:
        cmp ecx, ebx
        jae _delay32_endloop
        inc ecx
        jmp _delay32_loop
        _delay32_endloop:

        xor ebx, ebx
        xor ecx, ecx

        _delay32_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

