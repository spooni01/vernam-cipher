; Autor reseni: Adam Ližičiar xlizic00

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
                .data
login:          .asciiz "xlizic00"  ; sem doplnte vas login
cipher:         .space  17          ; misto pro zapis sifrovaneho loginu
cipherkey1:     .word   12          ; pismeno L, pozicia od zaciatku
cipherkey2:     .word   9           ; pismeno I, pozicia od zaciatku
poscnt:         .word   0           ; counting position of adress from start

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize "funkce" print_string)

; CODE SEGMENT
; registers: 
; r19 - cipher
; r12 - cipher key
; r29 - position counter
; r26 - login
; r0
; r4 - string for terminal
.text
main:
    ; Save variables to data
    lb r29, poscnt(r0) 
    lb r12, cipherkey2(r0) 

     
    ; Get address of original string
    ; for cycle:
    lb r26, login(r29) 
    ; todo: check, if number in not of ascii
    ; compare r26, if is not greater than some number: if it is, then sub from r26 some number
    add r26, r26, r12
    sb r26, login(r29)
    addi r29, r29, 1
    ; todo: compare if char is not equal to number, if not, do for cycle again 


    ; Add or sub cipher key
    ; Save it to cipher and add 1 to address
    ; Do it while character is not '\0'

    daddi   r4, r0, login  ; vozrovy vypis: adresa login: do r4
    jal     print_string    ; vypis pomoci print_string - viz nize
    
    syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
    sw      r4, params_sys5(r0)
    daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
    syscall 5   ; systemova procedura - vypis retezce na terminal
    jr      r31 ; return - r31 je urcen na return address
