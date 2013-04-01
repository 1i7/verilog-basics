

####################################################################
# Зажечь лампочку ассемблером
main:   .global main                // Помечаем метку main как глобальную

    # send 1 to pin8 (RD10)
    # Set pin8 (RD10) as output - set TRISD[10] bit to 1 - send 0x400 to TRISDCLR
    li     $t1, 1 << 10
    li     $t2, 0xBF8860C4 #TRISDCLR
    sw     $t1, 0 ($t2) 
    
    # Set value 1 to pin8 (RD10) - set PORTD[10] BIT TO 1 - send 0x400 to PORTDSET
    li     $t1, 1 << 10
    li     $t2, 0xBF8860D0 #PORTDSET
    sw     $t1, 0 ($t2) 

    /*
#include <p32xxxx.h>
    # send 1 to pin8 (RD10)
    # Set pin8 (RD10) as output - set TRISD[10] bit to 1 - send 0x200 to TRISDCLR

    li t1, 1 << 10
    la t2, TRISDCLR #0xBF8860C4 #TRISDCLR
    sw t1, 0 (t2) 
    
    # Set value 1 to pin8 (RD10) - set PORTD[10] BIT TO 1 - send 0x200 to PORTDSET
    li t1, 1 << 10
    la t2, PORTDSET #0xBF8860D0 #PORTDSET
    sw t1, 0 (t2) 
*/
