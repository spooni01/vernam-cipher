; Autor reseni: Adam Ližičiar xlizic00

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
                .data
login:          .asciiz "xlizic00"  ; sem doplnte vas login
cipher:         .space  17          ; misto pro zapis sifrovaneho loginu
cipherkey1:     .word   12          ; letter L, value from begin of ASCII 'a', for even (2,4,...)
cipherkey2:     .word   9           ; letter I, value from begin of ASCII 'a', for odd (1,3,...)
poscnt:         .word   0           ; counting position of adress from start
asciiCharStart: .word   97          ; number of 'a' in Ascii table
asciiCharEnd:   .word   122         ; number of 'z' in Ascii table
oddOrEven:      .word   0           ; '0' for even position, '1' for odd position
zero:           .word   0           ; Value '0'
params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize "funkce" print_string)
; registers: r19 r12 r29 r26 r0 r4 

; CODE SEGMENT
.text
main:
    lb r29, poscnt(r0) 

    ; For cycle will go through the string until it hits a number
    for_cycle:
        lb r26, login(r29) ; Get address of original string

        ; Compare if char is not equal to number
        lb r19, asciiCharStart(r0) 
        sub r26, r26, r19
        bgez r26, continue  ; If int of char is more than 0, continue, else end cycle because the input char is not alfanumeric
        j end_for_cycle

        continue:
        add r26, r26, r19 ; Add value of asciiCharStart back, because in previous comparsition it was changed
        
        ; Check if is odd or even position
        lb r19, oddOrEven(r0)
        lb r4, zero(r0)
        bne r19, r4, isOdd

        ; Add cipher key to char and move position counter to next cell
        isEven:
            ; Change even to odd
            addi r19, r19, 1
            sb r19, oddOrEven(r0)

            ;  Load cipher key
            lb r12, cipherkey1(r0)

            ; Check if r26 is not bigger than Ascii
            add r26, r26, r12      
            lb r4, asciiCharEnd(r0)
            sub r4, r26, r4
            bgez r4, jumpToStartOfAscii 
            b storeRegister
            jumpToStartOfAscii:
            lb r4, asciiCharEnd(r0)
            sub r26, r26, r4
            lb r4, asciiCharStart(r0)
            add r26, r26, r4
            addi r26, r26, -1
            b storeRegister

        isOdd:
            ; Change odd to even
            addi r19, r19, -1
            sb r19, oddOrEven(r0)

            ;  Load cipher key
            lb r12, cipherkey2(r0) 

            ; Check if r26 is not smaller than Ascii
            sub r26, r26, r12
            lb r4, asciiCharStart(r0)
            sub r4, r26, r4
            bgez r4, storeRegister
            lb r4, asciiCharEnd(r0)
            add r26, r26, r4
            lb r4, asciiCharStart(r0)
            sub r26, r26, r4
            addi r26, r26, 1
            b storeRegister

        storeRegister:
        sb r26, cipher(r29)
        addi r29, r29, 1

        ; Jump to start of for cycle
        b for_cycle  
    end_for_cycle:

    ; Print result
    daddi   r4, r0, cipher 
    jal     print_string  
    
    syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
    sw      r4, params_sys5(r0)
    daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
    syscall 5   ; systemova procedura - vypis retezce na terminal
    jr      r31 ; return - r31 je urcen na return address
