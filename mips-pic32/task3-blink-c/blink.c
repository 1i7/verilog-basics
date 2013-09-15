#include <p32xxxx.h>
/**
 * Помигать лампочкой на пине pic32 RD10 (chipKIT #8).
 */

/**
 * Настраиваем пины ввода-вывода и таймер.
 */
void setup() {
    // режим вывода для RD10 - установить бит PORTD[10] в 0
    TRISDCLR = 1 << 10;

    // включить таймер
    T1CON = 0x8030;
}

/**
 * Запуск бесконечного цикла с миганием.
 */
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

void main() {  
    setup();

    blink();
}
