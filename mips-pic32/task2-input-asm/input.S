

####################################################################
# Зажечь лампочку по нажатию кнопки
main:   .global main                # Помечаем метку main как глобальную

    # Set pin4 (RF1) as input - set TRISF[1] bit to 1 - send 0x1 to TRISFCLR
    addi   $t1, $0, 1 << 1
    li     $t2, 0xBF886148 #TRISFSET
    sw     $t1, 0 ($t2)

    # Set pin8 (RD10) as output - set TRISD[10] bit to 1 - send 0x400 to TRISDCLR
    addi   $t1, $0, 1 << 10
    li     $t2, 0xBF8860C4 #TRISDCLR
    sw     $t1, 0 ($t2)  

loop:
    # Read value from pin4 (RF1) - get PORTF[1] value
    li     $t2, 0xBF886150 #PORTF
    lw     $t1, 0 ($t2)
    ext    $t3, $t1, 1, 1
    
    addi   $t4, $0, 1
    beq $t3, $t4, button_on

    # button is off
    # Set value 0 to pin8 (RD10) - set PORTD[10] BIT TO 1 - send 0x400 to PORTDSET
    addi   $t1, $0, 1 << 10
    li     $t2, 0xBF8860D4 #PORTDCLR
    sw     $t1, 0 ($t2) 

    j loop
button_on:
    # Set value 1 to pin8 (RD10) - set PORTD[10] BIT TO 1 - send 0x400 to PORTDSET
    addi   $t1, $0, 1 << 10
    li     $t2, 0xBF8860D0 #PORTDSET
    sw     $t1, 0 ($t2) 

    j loop
