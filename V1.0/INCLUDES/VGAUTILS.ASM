;DOS Assembly environment
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

VGA_WIDTH equ 320
VGA_HEIGHT equ 200

;FUNCTION: start VGA mode
;args (push order): return addr
_vga_startvga:
        mov ah, byte 0
        mov al, byte 0x13
        int 0x10

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: clear screen in VGA mode
;args (push order): return addr
_vga_clearscreen:
        mov bx, word 0xa000
        mov es, bx
        mov di, word 0

        _vga_clearscreen_loop:
        cmp di, word 0xfa00
        jae _vga_clearscreen_endloop
        mov [es:di], byte 0
        inc di
        jmp _vga_clearscreen_loop
        _vga_clearscreen_endloop:

        pop word bx
        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: paint screen
;args (push order): pixel color, return addr
_vga_paintscreen:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word ax
        and ax, word 0xff

        mov bx, word 0xa000
        mov es, bx
        mov di, word 0

        _vga_paintscreen_loop:
        cmp di, word 0xfa00
        jae _vga_paintscreen_endloop
        mov [es:di], byte al
        inc di
        jmp _vga_paintscreen_loop
        _vga_paintscreen_endloop:

        _vga_paintscreen_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: paint a pixel on a given address
;args (push order): pixel color, pixel addr, return addr
_vga_paintpixel:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        cmp bx, word 0xfa00
        jae _vga_paintpixel_return

        mov ax, word 0xa000
        mov es, ax
        mov di, bx

        pop word ax
        and ax, word 0xff

        mov [es:di], byte al

        _vga_paintpixel_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: get current pixel color from a pixel address
;args (push order): pixel addr, return addr
;return value: ax (pixel color)
_vga_getpixelcolor:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        cmp bx, word 0xfa00
        jae _vga_getpixelcolor_return

        mov ax, word 0xa000
        mov es, ax
        mov di, bx

        xor ax, ax
        mov al, byte [es:di]

        _vga_getpixelcolor_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNCTION: paint pixel at coordinates (x, y)
;args (push order): pixel color, x position, y position, return addr
_vga_paintpixel_xy:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        cmp bx, word VGA_HEIGHT
        jae _vga_paintpixel_xy_return

        xor dx, dx
        mov ax, bx
        mov cx, word 0x140
        mul word cx

        pop word bx
        cmp bx, word VGA_WIDTH
        jae _vga_paintpixel_xy_return

        add ax, bx

        mov bx, word 0xa000
        mov es, bx
        mov di, ax

        pop word ax
        and ax, word 0xff

        mov [es:di], byte al

        _vga_paintpixel_xy_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

;FUNTION: get current pixel color at coordinates (x, y)
;args (push order): x position, y position, return addr
;return value: ax (pixel color)
_vga_getpixelcolor_xy:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        add di, cx
        pop word bx
        mov [di], word bx
        add cx, word 2
        mov [si], word cx

        pop word bx
        cmp bx, word VGA_HEIGHT
        jae _vga_getpixelcolor_xy_return

        xor dx, dx
        mov ax, bx
        mov cx, word 0x140
        mul word cx

        pop word bx
        cmp bx, word VGA_WIDTH
        jae _vga_getpixelcolor_xy_return

        add ax, bx

        mov bx, word 0xa000
        mov es, bx
        mov di, ax

        xor ax, ax
        mov al, byte [es:di]

        _vga_getpixelcolor_xy_return:
        mov si, word _stacklist_index
        mov di, word _stacklist
        mov cx, word [si]
        sub cx, word 2
        add di, cx
        mov bx, word [di]
        mov [si], word cx

        add bx, word RETURN_MARGIN_CALLEE
        jmp bx

