;DOS Assembly environment
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: convert 16bit unsigned integer into text
;args (push order): input value, output text buffer addr, return addr
_loadstr_dec_u16:
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

        pop word bx

        xor dx, dx
        mov ax, bx
        mov cx, word 10000
        div word cx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov bx, dx
        xor dx, dx
        mov ax, bx
        mov cx, word 1000
        div word cx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov bx, dx
        xor dx, dx
        mov ax, bx
        mov cx, word 100
        div word cx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov bx, dx
        xor dx, dx
        mov ax, bx
        mov cx, word 10
        div word cx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov ax, dx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov [di], byte 0

        _loadstr_dec_u16_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: convert 16bit signed integer into text
;args (push order): input value, output text buffer addr, return addr
_loadstr_dec_s16:
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

        pop word bx
        test bx, word 0x8000
        jz _loadstr_dec_s16_pos

        _loadstr_dec_s16_neg:
        mov [di], byte 0x2d
        inc di
        not bx
        inc bx

        _loadstr_dec_s16_pos:
        push word bx
        push word di
        push word $
        jmp _loadstr_dec_u16
        times RETURN_MARGIN_CALLER nop

        _loadstr_dec_s16_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: convert 32bit unsigned integer into text
;WARNING: only compatible with i386 and above
;args (push order): input value (32bit), output text buffer addr, return addr
_loadstr_dec_u32:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, word cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        mov di, bx

        pop dword ebx

        xor edx, edx
        mov eax, ebx
        mov ecx, dword 1000000000
        div dword ecx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov ebx, edx
        xor edx, edx
        mov eax, ebx
        mov ecx, dword 100000000
        div dword ecx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov ebx, edx
        xor edx, edx
        mov eax, ebx
        mov ecx, dword 10000000
        div dword ecx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov ebx, edx
        xor edx, edx
        mov eax, ebx
        mov ecx, dword 1000000
        div dword ecx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov ebx, edx
        xor edx, edx
        mov eax, ebx
        mov ecx, dword 100000
        div dword ecx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov ebx, edx
        xor edx, edx
        mov eax, ebx
        mov ecx, dword 10000
        div dword ecx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov ebx, edx
        xor edx, edx
        mov eax, ebx
        mov ecx, dword 1000
        div dword ecx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov ebx, edx
        xor edx, edx
        mov eax, ebx
        mov ecx, dword 100
        div dword ecx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov ebx, edx
        xor edx, edx
        mov eax, ebx
        mov ecx, dword 10
        div dword ecx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov eax, edx
        mov ah, byte 0
        add al, byte 0x30
        mov [di], byte al
        inc di

        mov [di], byte 0

        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx

        _loadstr_dec_u32_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: convert 32bit signed integer into text
;WARNING: only compatible with i386 and above
;args (push order): input value (32bit), output text buffer addr, return addr
_loadstr_dec_s32:
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

        pop dword ebx
        test ebx, dword 0x80000000
        jz _loadstr_dec_s32_pos

        _loadstr_dec_s32_neg:
        mov [di], byte 0x2d
        inc di
        not ebx
        inc ebx

        _loadstr_dec_s32_pos:
        push dword ebx
        push word di
        push word $
        jmp _loadstr_dec_u32
        times RETURN_MARGIN_CALLER nop

        _loadstr_dec_s32_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

