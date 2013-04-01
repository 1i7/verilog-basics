#include <p32xxxx.h>

void setup() {
    // режим вывода для pin8 (=RD10=PORTD[10])
    TRISDCLR = 1 << 10;

    // режим ввода для pin4 (=RF1=PORTF[1])
    TRISFSET = 1 << 1;

    // включить таймер
    T1CON = 0x8030;
}

int readButton() {
    if(PORTF | 1 << 1)
        return 1;
    else
        return 0;
}

void blink() {
    while(1) {
        // установить значение - включить лампочку
        PORTDSET = 1 << 10;

        // подождать
        TMR1 = 0;
        while(TMR1 < 0xffff) {            
        }

        // очистить значение - выключить лампочку
        PORTDCLR = 1 << 10;

        // подождать
        TMR1 = 0;
        while(TMR1 < 0xffff) {
        }	
	}
}

void on_off() {
    while(1) {
        if(readButton()) {
            // установить значение - включить лампочку
            PORTDSET = 1 << 10;
        } else {
            // очистить значение - выключить лампочку
            PORTDCLR = 1 << 10;
        }
    }
}

void main() {  
    setup();

    //blink();
    on_off();
}
