.MODEL SMALL
.STACK 100H

.DATA

SVGA_Info STRUC
    Signature           dd ?        ; "VESA" if VESA BIOS
    VersionL            db ?        ; lower Version Number
    VersionH            db ?        ; higher Version Number
    OEMStringPtr        dd ?        ; pointer to description string
    CapableOf           dd ?        ; 32 flags of graphics card capabilities
    VidModePtr          dd ?        ; Pointer to list of available modes
    TotalMemory         dw ?        ; Memory available of card (in 64 kb blocks)
    OEMSoftwareVersion  dw ?        ; OEM software version
    VendorName          dd ?        ; pointer to vendor name
    ProductName         dd ?        ; pointer to product name
    ProductRevisionStr  dd ?        ; pointer to product revision string
    Reserved            db 512 DUP(?) ; OEM scratchpad - size in bytes: 256 (VBE 1.0 & 1.2), 
                                    ; 262 (VBE 1.1), 215 (VBE 2.0
SVGA_Info ENDS
svga_i SVGA_Info <>

SVGA_ModeInfo STRUC
    ModeAttributes      dw ?        ; mode attributes
    WinAAttributes      db ?        ; window A attributes
    WinBAttributes      db ?        ; window B attributes
    WinGranularity      dw ?        ; window granularity
    WinSize             dw ?        ; window size
    WinASegment         dw ?        ; window A start segment
    WinBSegment         dw ?        ; window B start segment
    WinFuncPtr          dd ?        ; pointer to window function
    BytesPerScanLine    dw ?        ; bytes per scan line
    XResolution         dw ?        ; horizontal resolution
    YResolution         dw ?        ; vertical resolution
    XCharSize           db ?        ; character cell width
    YCharSize           db ?        ; character cell height
    BitsPerPixel        db ?        ; bits per pixel
    NumberOfBanks       db ?        ; number of banks
    MemoryModel         db ?        ; memory model type
    BankSize            db ?        ; bank size in kb
    NumberOfImagePages  db ?        ; number of images
    Reserved1           db ?        ; reserved for page function
    RedMaskSize         db ?        ; size of direct color red mask in bits
    RedFieldPosition    db ?        ; bit position of LSB of red mask
    GreenMaskSize       db ?        ; size of direct color green mask in bits
    GreenFieldPosition  db ?        ; bit position of LSB of green mask
    BlueMaskSize        db ?        ; size of direct color blue mask in bits
    BlueFieldPosition   db ?        ; bit position of LSB of blue mask
    RsvdMaskSize        db ?        ; size of direct color reserved mask in bits
    DirectColorModeInfo db ?        ; Direct Color mode attributes
    Reserved2           db 216 DUP(?)   ; remainder of ModeInfoB
SVGA_ModeInfo ENDS
svga_mi SVGA_ModeInfo <>

    label1    DB 'SVGA Info_Signature: $'
    label2    DB 'SVGA Info_VersionL: $'
    label3    DB 'SVGA Info_VersionH: $'
    label4    DB 'SVGA Info_OEMStringPtr: $'
    label5    DB 'SVGA Mode Info_XResolution: $'
    label6    DB 'SVGA Mode Info_YResolution: $'
    label7    DB 'SVGA Mode Info_XCharSize: $'
    label8    DB 'SVGA Mode Info_YCharSize: $'
    label9    DB 'SVGA Mode Info_BitsPerPixel: $'
    label10    DB 'SVGA Mode Info_NumberOfBanks: $'
    label11    DB 'SVGA Mode Info_MemoryModel: $'


.CODE
    START:
    MAIN:
        mov ax, @data
        mov ds, ax
        mov es, ax

        mov ax, 4f00h
        mov di, OFFSET svga_i
        int 10h

        mov dx, OFFSET label1        ; prints SVGA signature 
        mov ah, 09
        int 21h

        mov cl, 4
        call puts2

        push 10d                     ; prints newline
        call putch

        mov dx, OFFSET label2        ; prints low res
        mov ah, 09
        int 21h        

        mov al, [di]
        xor ah, ah
        push ax
        call printint

        push 10d                     ; prints newline
        call putch

        mov dx, OFFSET label3        ; prints high res
        mov ah, 09
        int 21h               

        mov al, BYTE PTR[di+2h]
        xor ah, ah
        push ax
        call printint

        push 10d                     ; prints newline
        call putch

        mov dx, OFFSET label4        ; prints oemstringptr
        mov ah, 09
        int 21h  

        mov dx, WORD PTR[di+4h]
        push dx
        call printint

        push 10d                     ; prints newline
        call putch

        mov ax, 4f01h
        mov cx, 101h
        mov di, OFFSET svga_mi
        int 10h

        mov dx, OFFSET label5        ; prints x res
        mov ah, 09
        int 21h  

        mov dx, WORD PTR[di+12h]
        push dx
        call printint

        push 10d                     ; prints newline
        call putch

        mov dx, OFFSET label6        ; prints y res
        mov ah, 09
        int 21h  

        mov dx, WORD PTR[di+14h]
        push dx
        call printint

        push 10d                     ; prints newline
        call putch

        mov dx, OFFSET label7        ; prints x char size
        mov ah, 09
        int 21h  

        mov dl, [di+16h]
        mov dh, 0h
        push dx
        call printint

        push 10d                     ; prints newline
        call putch

        mov dx, OFFSET label8        ; prints y char size
        mov ah, 09
        int 21h  

        mov dl, [di+17h]
        mov dh, 0h
        push dx
        call printint

        push 10d                     ; prints newline
        call putch

        mov dx, OFFSET label9        ; prints depth
        mov ah, 09
        int 21h  

        mov dl, [di+18h]
        mov dh, 0h
        push dx
        call printint

        push 10d                     ; prints newline
        call putch

        mov dx, OFFSET label10       ; prints number of banks
        mov ah, 09
        int 21h  

        mov dl, [di+19h]
        mov dh, 0h
        push dx
        call printint

        push 10d                     ; prints newline
        call putch

        mov dx, OFFSET label11       ; prints number of banks
        mov ah, 09
        int 21h  

        mov dl, [di+1Ah]
        mov dh, 0h
        push dx
        call printint

        mov ah, 4ch                 ; return control to DOSBOX
        int 21h

    puts2:

    ; alternate print string method that seems to work better than
    ; my original

        mov dl, [di]                ; deferences pointer to char of string

        mov bl, dl                  ; prints character (same as body of 
        mov ah, 2                   ; putch), couldn't figure how to save
        int 21h                     ; return address on stack to call putch

        inc di                      ; increment pointer
        dec cl                      ; decrement counter
        cmp cl, 0                   ; if counter doesn't equal 0, loop
        jnz PUTS2        

        ret 6  
 

    getche:

        push ax
        mov ah, 01h
        int 21h
        mov dl, al
        pop ax
        ret


    putch:

        push ax
        push bx
        push dx

        mov bx, sp
        mov dx, ss:[bx+8]
        mov ah, 02h
        int 21h

        pop dx
        pop bx
        pop ax
        ret

    puts:

        push ax
        push bx
        push dx
        mov bx, sp
        mov bx, ss:[bx+8]         ; bx contains pointer to first char
      
        loop1:
            mov dx, [bx]
            cmp dl, 0h              ; compares dx with 0
            je endloop              ; if null-terminated

            push dx
            call putch
            pop dx

            add bx, 1               ; accounts for null char
            jmp loop1

        endloop:
            pop dx
            pop bx
            pop ax
            ret

    gets:

        push ax
        push bx
        push dx
        mov bx, sp
        mov bx, ss:[bx+8]         ; bx contains pointer to string

        getloop:
            call getche             ; dx holds new char
            mov [bx], dx            ; puts new char into string array
            add bx, 1               ; inc pointer
            cmp dl, 13d             ; if new char is enter/carriage return
            jnz getloop

        mov dx, 0h
        mov [bx], dx            ; null-terminates
        pop dx
        pop bx
        pop ax
        ret

    getInt:

        push dx
        call getche               ; dx holds new char
        sub dx, 48d               ; converts from char to int
        mov ax, dx                ; puts int into ax for return
        mov ah, 0h
        pop dx
        ret


    printInt:

        push ax
        push bx
        push cx
        mov bx, sp
        mov ax, ss:[bx+8]          ; int is in ax
        mov cx, 0h                 ; initialize counter

        convertintloop:

            mov dx, 0h
            mov bx, 0Ah              ; contains 10
            div bx                   ; dx = remainder, ax = quotient
            mov bx, ax               ; swaps ax, dx
            mov ax, dx
            mov dx, bx
            add ax, 30h              ; converts to ascii
            inc cx                   ; increment counter
            push ax

            mov ax, dx
            cmp ax, 0h               ; if quotient is 0, end
            jne convertintloop

        printloop:

            call putch
            pop ax                   ; take ax back off stack
            dec cx                   ; decrement counter
            cmp cx, 0h               ; if null, terminate
            jne printloop       

        pop cx
        pop bx
        pop ax
        ret

 END START
