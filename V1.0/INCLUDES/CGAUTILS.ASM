;DOS Assembly environment
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

CGA_COLOR_BLACK equ 0x0
CGA_COLOR_BLUE equ 0x1
CGA_COLOR_GREEN equ 0x2
CGA_COLOR_CYAN equ 0x3
CGA_COLOR_RED equ 0x4
CGA_COLOR_MAGENTA equ 0x5
CGA_COLOR_BROWN equ 0x6
CGA_COLOR_LTGRAY equ 0x7

CGA_TEXTCOLOR_BLACK equ CGA_COLOR_BLACK
CGA_TEXTCOLOR_BLUE equ CGA_COLOR_BLUE
CGA_TEXTCOLOR_GREEN equ CGA_COLOR_GREEN
CGA_TEXTCOLOR_CYAN equ CGA_COLOR_CYAN
CGA_TEXTCOLOR_RED equ CGA_COLOR_RED
CGA_TEXTCOLOR_MAGENTA equ CGA_COLOR_MAGENTA
CGA_TEXTCOLOR_BROWN equ CGA_COLOR_BROWN
CGA_TEXTCOLOR_LTGRAY equ CGA_COLOR_LTGRAY
CGA_TEXTCOLOR_DKGRAY equ 0x8
CGA_TEXTCOLOR_LTBLUE equ 0x9
CGA_TEXTCOLOR_LTGREEN equ 0xa
CGA_TEXTCOLOR_LTCYAN equ 0xb
CGA_TEXTCOLOR_LTRED equ 0xc
CGA_TEXTCOLOR_LTMAGENTA equ 0xd
CGA_TEXTCOLOR_YELLOW equ 0xe
CGA_TEXTCOLOR_WHITE equ 0xf

CGA_BKCOLOR_BLACK equ CGA_COLOR_BLACK
CGA_BKCOLOR_BLUE equ CGA_COLOR_BLUE
CGA_BKCOLOR_GREEN equ CGA_COLOR_GREEN
CGA_BKCOLOR_CYAN equ CGA_COLOR_CYAN
CGA_BKCOLOR_RED equ CGA_COLOR_RED
CGA_BKCOLOR_MAGENTA equ CGA_COLOR_MAGENTA
CGA_BKCOLOR_BROWN equ CGA_COLOR_BROWN
CGA_BKCOLOR_LTGRAY equ CGA_COLOR_LTGRAY

CGA_NCHARS equ 80
CGA_NLINES equ 25

;FUNCTION: start CGA mode (int 10h, ah 0h, al 3h)
;args (push order): return addr
_cga_startcga:
        mov ah, byte 0
        mov al, byte 3
        int 0x10

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: clear screen in CGA mode
;args (push order): return addr
_cga_clearscreen:
        mov bx, word 0xb800
        mov es, bx

        mov di, word 0x0

        _cga_clearscreen_loop:
        cmp di, word 0xfa0
        jae _cga_clearscreen_endloop
        mov [es:di], word 0
        add di, word 2
        jmp _cga_clearscreen_loop
        _cga_clearscreen_endloop:

        mov di, word _cga_npos
        mov [di], word 0

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: enable/disable text blinking
;WARNING: this does not affect previously written text
;args (push order): value (1 == blink | 0 == no blink), return addr
_cga_setblinkenable:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        xor ax, ax

        mov si, word _cga_ncolor
        mov al, byte [si]

        pop word bx
        test bx, word 0xffff
        jz _cga_setblinkenable_disable

        _cga_setblinkenable_enable:
        or al, byte 0x80
        jmp _cga_setblinkenable_l1

        _cga_setblinkenable_disable:
        and al, byte 0x7f

        _cga_setblinkenable_l1:
        mov [si], byte al

        _cga_setblinkenable_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: return blinking status (enabled/disabled)
;args (push order): return addr
;return value: ax (1 == enabled | 0 == disabled)
_cga_getblinkenable:
        xor cx, cx

        mov si, word _cga_ncolor
        mov cl, byte [si]

        test cl, byte 0x80
        jz _cga_getblinkenable_returnfalse

        _cga_getblinkenable_returntrue:
        mov ax, word 1
        jmp _cga_getblinkenable_return

        _cga_getblinkenable_returnfalse:
        xor ax, ax

        _cga_getblinkenable_return:
        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: set text color in CGA mode
;args (push order): color value, return addr
_cga_settextcolor:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, word cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        and bx, word 0xf

        mov si, word _cga_ncolor
        mov al, byte [si]

        and al, byte 0xf0
        or al, bl

        mov [si], byte al

        _cga_settextcolor_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: set background color in CGA mode
;args (push order): color value, return addr
_cga_setbkcolor:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        and bx, word 0x7
        shl bl, 4

        mov si, word _cga_ncolor
        mov al, byte [si]

        and al, byte 0x8f
        or al, bl

        mov [si], byte al

        _cga_setbkcolor_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: set color (text and background) in CGA mode
;args (push order): text color value, background color value, return addr
_cga_setcolor:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        and bx, word 0x7
        shl bl, 4

        pop word ax
        and ax, word 0xf

        or bl, al

        mov si, word _cga_ncolor
        mov al, byte [si]

        and al, byte 0x80
        or al, bl

        mov [si], byte al

        _cga_setcolor_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: set color byte in CGA mode (similar to set color, but is a single byte as argument)
;args (push order): color byte, return addr
_cga_setcolorbyte:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        and bx, word 0xff

        mov di, word _cga_ncolor
        mov [di], byte bl

        _cga_setcolorbyte_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: get current text color in CGA mode
;args (push order): return addr
;return value: ax (text color value)
_cga_gettextcolor:
        mov si, word _cga_ncolor
        mov al, byte [si]
        and ax, word 0xf

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: get current background color in CGA mode
;args (push order): return addr
;return value: ax (background color value)
_cga_getbkcolor:
        mov si, word _cga_ncolor
        mov al, byte [si]
        shr al, 4
        and ax, word 0x7

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: get current color in CGA mode
;args (push order): return addr
;return value: ax (ah == background color value | al == text color value)
_cga_getcolor:
        mov si, word _cga_ncolor
        mov al, byte [si]
        mov bl, al

        shr bl, 4

        and ax, word 0xf
        and bx, word 0x7

        mov ah, bl

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: get current color byte in CGA mode
;args (push order): return addr
;return value: ax (color byte value)
_cga_getcolorbyte:
        mov si, word _cga_ncolor
        mov al, byte [si]
        and ax, word 0xff

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: set cursor horizontal position in CGA mode
;args (push order): position value, return addr
_cga_settextpos_x:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        mov si, word _cga_npos
        mov bx, word [si]

        xor dx, dx
        mov ax, bx
        mov cx, word 0xa0
        div word cx

        sub bx, dx

        pop word cx
        cmp cx, word CGA_NCHARS
        jae _cga_settextpos_x_return

        shl cx, 1

        add bx, cx
        mov [si], word bx

        _cga_settextpos_x_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: set cursor vertical position in CGA mode
;args (push order): position value, return addr
_cga_settextpos_y:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        cmp bx, word CGA_NLINES
        jae _cga_settextpos_y_return

        xor dx, dx
        mov ax, bx
        mov cx, word 0xa0
        mul word cx

        mov bx, ax

        mov si, word _cga_npos
        mov ax, word [si]

        xor dx, dx
        mov cx, word 0xa0
        div word cx

        add bx, dx

        mov [si], word bx

        _cga_settextpos_y_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: set cursor position in CGA mode
;args (push order): horizontal position, vertical position, return addr
_cga_settextpos:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word ax
        cmp ax, word CGA_NLINES
        jae _cga_settextpos_return

        xor dx, dx
        mov cx, word 0xa0
        mul word cx

        pop word bx
        cmp bx, word CGA_NCHARS
        jae _cga_settextpos_return

        shl bx, 1

        add ax, bx

        mov di, word _cga_npos
        mov [di], word ax

        _cga_settextpos_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: set position word value in CGA mode
;args (push order): position word value, return addr
_cga_setposword:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        cmp bx, word 0xfa0
        jae _cga_setposword_return

        mov di, word _cga_npos
        mov [di], word bx

        _cga_setposword_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: get current horizontal position in CGA mode
;args (push order): return addr
;return value: ax (horizontal position value)
_cga_gettextpos_x:
        mov si, word _cga_npos
        mov ax, word [si]

        xor dx, dx
        mov cx, word 0xa0
        div word cx

        mov ax, dx
        shr ax, 1
        and ax, word 0xff

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: get current vertical position in CGA mode
;args (push order): return addr
;return value: ax (vertical position value)
_cga_gettextpos_y:
        mov si, word _cga_npos
        mov ax, word [si]

        xor dx, dx
        mov cx, word 0xa0
        div word cx

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: get current position in CGA mode
;args (push order): return addr
;return value: ax (ah == vertical position | al == horizontal position)
_cga_gettextpos:
        mov si, word _cga_npos
        mov ax, word [si]

        xor dx, dx
        mov cx, word 0xa0
        div word cx

        shl ax, 8

        and dx, word 0xff
        shr dl, 1

        mov al, dl

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: get current position word value in CGA mode
;args (push order): return addr
;return value: ax (position word value)
_cga_getposword:
        mov si, word _cga_npos
        mov ax, word [si]

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: add a new line on cursor
;args (push order): return addr
_cga_addnewline:
        mov si, word _cga_npos
        mov bx, word [si]

        xor dx, dx
        mov ax, bx
        mov cx, word 0xa0
        div word cx

        sub bx, dx
        add bx, word 0xa0

        mov [si], word bx

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: print a text string in CGA mode
;args (push order): input text buffer addr, return addr
_cga_printtext:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        mov si, word _cga_npos
        mov cx, word [si]
        cmp cx, word 0xfa0
        jb _cga_printtext_noclear

        _cga_printtext_clearscreen:
        push word $
        jmp _cga_clearscreen
        times RETURN_MARGIN_CALLER nop

        _cga_printtext_noclear:

        mov bx, word 0xb800
        mov es, bx

        mov si, word _cga_npos
        mov di, word [si]

        mov si, word _cga_ncolor
        mov ah, byte [si]

        pop word bx
        mov si, bx

        _cga_printtext_loop:
        mov al, byte [si]
        cmp al, byte 0
        je _cga_printtext_endloop
        mov [es:di], word ax
        inc si
        add di, word 2
        jmp _cga_printtext_loop

        _cga_printtext_endloop:
        mov si, word _cga_npos
        mov [si], word di

        _cga_printtext_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: print a text string in CGA mode, add new line afterwards
;args (push order): input text buffer addr, return addr
_cga_printtextln:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        push word $
        jmp _cga_printtext
        times RETURN_MARGIN_CALLER nop

        push word $
        jmp _cga_addnewline
        times RETURN_MARGIN_CALLER nop

        _cga_printtextln_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

_cga_npos: dw 0x0
_cga_ncolor: db 0x0

