; *****************************************
; *         BOOTLOADER START POINT        *
; *****************************************
[bits 16]                   ; Every x86 compatible processor boot-up in real mode (16-bits)

; On the addresses from 0x0000 to 0x7bff there are the BIOS data structures and routines

[org 0x7c00]                ; Move the location pointer to the boot address
; In order to load a larger kernel you must load it above the 1MB barrier
; That's a TODO task :) (I need to know how to activate the A20 gate :p)
KERNEL_OFFSET equ 0x1000    ; Address where to load the kernel (small kernel)

; mov [BOOT_DRIVE], dl        ; Load the address of the boot drive
mov bp, 0x9000              ; Se the base pointer to
mov sp, bp                  ; Set the stack pointer to the base pointer

mov ah, 00h                 ; Prepare to VGA Mode
mov al, 03h                 ; Enable mode text with resolution 80x25
int 10h                     ; Call to the service

mov ah, 02h                 ; Configure the cursor
mov bh, 00h                 ; Set the page 0
mov dh, 00h                 ; Move the cursor to row 0
mov dl, 00h                 ; Move the cursor to col 0
int 10h

xor ax, ax                  ; Zeroing ax register
mov es, ax                  ; Set the start index of the string
mov ah, 13h                 ; Set to write an string
mov al, 01h                 ; Set the write mode
mov bl, 0ah                 ; Set foreground as green
mov bh, 00h                 ;
mov cx, [MSG_LENGTH]        ; Set the length of the string
mov dh, 00h                 ; Set the row
mov dl, 00h                 ; Set the col
mov bp, WELCOME_MSG
int 10h

xor bx, bx
mov ah, 13h
mov al, 01h
mov es, bx
mov bl, 0eh
mov dh, 01h
mov dl, 00h
mov cx, [BMSG_LENGTH]
mov bp, BOOT_MESSAGE
int 10h


;mov ah, 42h                 ; Prepare to read disk bytes
;int 13h

WELCOME_MSG  db "Hello, world!"
MSG_LENGTH   dw $-WELCOME_MSG
BOOT_MESSAGE db "Booting kernel..."
BMSG_LENGTH  dw $-BOOT_MESSAGE

; Magic numbers
times 510 - ($ - $$) db 0   ; Set the padding
dw 0xAA55                   ; Write the magic number
