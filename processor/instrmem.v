/**
 * Instruction memory - contains program instructions.
 */
module instrmem (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output [31:0] instr);
	 
	 // uncomment required module for test
	 instrmem_test_7segment_draw_8 instrmem_program(addr, instr);
	 //instrmem_test_7segment_draw_5 instrmem_program(addr, instr);
	 //instrmem_test_beq_input instrmem_program(addr, instr);
	 //instrmem_test_sw_lw instrmem_program(addr, instr);
	 //instrmem_test_input_4bits instrmem_program(addr, instr);	 
	 //instrmem_test_io_calc instrmem_program(addr, instr);
endmodule

/** 
 * Instruction memory - contains program instructions.
 * Plain instruction memory with not program loaded (not used for tests here).
 */
module instrmem_plain (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output [31:0] instr);
	 
	 // instruction memory data with loaded program instructions
    reg [31:0] ROM [63:0];
	 // addr is divided by 4 (just move away 2 lower bits) 
	 // as instr data chunks are word aligned (each word is 32bits)
	 assign instr = ROM[addr[31:2]]; // word aligned
endmodule

/** 
 * Instruction memory - contains program instructions.
 * Test 7-segment display output (v at 0xf000) - run the following program:
 *
 *     // put 11111111 value (8 with dot 'on') to s0 (switch on all display segments)
 *     addi $s0, $0, b0000000011111111
 *     // send value to video memory (7-segment display) device at 0xf000
 *     sw $s0, 0x0000f000 ($0)
 * 
 */
module instrmem_test_7segment_draw_8 (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output reg [31:0] instr);
	 
	 // hardcode program data - as soon as instruction memory is read-only,
	 // implement it in ROM-way
	 always @ (addr)
	     case (addr)
        32'h00000000: instr <= 32'b001000_00000_10000_0000000011111111; // addi $s0, $0, b0000000011111111
		  32'h00000004: instr <= 32'b101011_00000_10000_1111000000000000; // sw $s0, 0xf000 ($0)
		  
		  default: instr <= 0;

	     endcase
endmodule

/**
 * Instruction memory - contains program instructions.
 * Test 7-segment display output (v at 0xf000) - run the following program:
 *
 *     // put 11111111 (5 with dot off) value to s0 (switch on all display segments)
 *     addi $s0, $0, b0000000011100110
 *     // send value to video memory (7-segment display) device at 0xf000
 *     sw $s0, 0x0000f000 ($0)
 * 
 */
module instrmem_test_7segment_draw_5 (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output reg [31:0] instr);
	 
	 // hardcode program data - as soon as instruction memory is read-only,
	 // implement it in ROM-way
	 always @ (addr)
	     case (addr)
        32'h00000000: instr <= 32'b001000_00000_10000_0000000011100110; // addi $s0, $0, b0000000011100110
		  32'h00000004: instr <= 32'b101011_00000_10000_1111000000000000; // sw $s0, 0xf000 ($0)
		  
		  default: instr <= 0;

	     endcase
endmodule

/**
 * Instruction memory - contains program instructions.
 * Test 1-bit button switch input (bsf at 0xf008) and beq conditional branching
 * - run the following program:
 *
 *   loop:
 *     // load value from 1-bit input (button switch) device at 0xf008
 *     lw $s0, 0xf008 ($0)
 *     // go to 'display_0' if input bit is 0
 *     beq $s0, $0, display_0 // 0x0014
 *   display_1:
 *     // display "1" on 7-segment display (if input is 1)
 *     addi $s1, $0, b00011100
 *     sw $s1, 0xf000 ($0)
 *     // jump to beginning
 *     j loop // 0x0000
 *   display_0:
 *     // display "0" on 7-segment display (if input is 0)
 *     addi $s1, $0, b01111111
 *     sw $s1, 0xf000 ($0)
 *     // jump to beginning
 *     j loop // 0x0000
 */
module instrmem_test_beq_input (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output reg [31:0] instr);
	 
	 // hardcode program data - as soon as instruction memory is read-only,
	 // implement it in ROM-way
	 always @ (addr)
	     case (addr)
// loop:
        32'h00000000: instr <= 32'b100011_00000_10000_1111000000001000; // lw $s0, 0xf008 ($0)
		  32'h00000004: instr <= 32'b000100_10000_00000_0000000000010100; // beq $s0, $0, display_0 // 0x0014
// display_1:
		  32'h00000008: instr <= 32'b001000_00000_10001_0000000000011100; // addi $s1, $0, b00011100
		  32'h0000000c: instr <= 32'b101011_00000_10001_1111000000000000; // sw $s1, 0xf000 ($0)
		  32'h00000010: instr <= 32'b000010_00000000000000000000000000;   // j loop // 0x0000
// display_0:
		  32'h00000014: instr <= 32'b001000_00000_10001_0000000001111111; // addi $s1, $0, b01111111
		  32'h00000018: instr <= 32'b101011_00000_10001_1111000000000000; // sw $s1, 0xf000 ($0)
		  32'h0000001c: instr <= 32'b000010_00000000000000000000000000;   // j loop // 0x0000
		  default: instr <= 0;

	     endcase
endmodule

/** 
 * Instruction memory - contains program instructions.
 * Test sw (store word) and lw (load word) instructions - 
 * store bitwise representation of "5" digit for 7segment display
 * to memory, then load it from memory to register, 
 * then display loaded value on 7segment display:
 *
 *   addi $s0, $0, b0000000011100110		  
 *   sw $s0, 0 ($0)
 *   lw $s1, 0 ($0) 
 *   sw $s1, 0xf000 ($0)
 */
module instrmem_test_sw_lw (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output reg [31:0] instr);
	 	 
	 // hardcode program data - as soon as instruction memory is read-only,
	 // implement it in ROM-way
	 always @ (addr)
	     case (addr)
		  32'h00000000: instr <= 32'b001000_00000_10000_0000000011100110; // addi $s0, $0, b0000000011100110		  
		  32'h00000004: instr <= 32'b101011_00000_10000_0000000000000000; // sw $s0, 0 ($0)
		  32'h00000008: instr <= 32'b100011_00000_10001_0000000000000000; // lw $s1, 0 ($0) 
		  32'h0000000c: instr <= 32'b101011_00000_10001_1111000000000000; // sw $s1, 0xf000 ($0)
		  
		  default: instr <= 0;

	     endcase
endmodule

/** 
 * Instruction memory - contains program instructions.
 * Test 4-bit button switch input (bs at 0xf004) - switch on/off
 * 7-segment 4 minor leds with 4 button switch values - 
 * run the following program:
 *
 *   loop:
 *     lw $s1, 0xf004 ($0) 
 *	    sw $s1, 0xf000 ($0)
 *	    j loop
 */
module instrmem_test_input_4bits (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output reg [31:0] instr);
	 	 
	 // hardcode program data - as soon as instruction memory is read-only,
	 // implement it in ROM-way
	 always @ (addr)
	     case (addr)
// loop:
		  32'h00000000: instr <= 32'b100011_00000_10001_1111000000000100; // lw $s1, 0xf004 ($0) 
		  32'h00000004: instr <= 32'b101011_00000_10001_1111000000000000; // sw $s1, 0xf000 ($0)
		  32'h00000008: instr <= 32'b000010_00000000000000000000000000;   // j loop // 0x0000
		  
		  default: instr <= 0;

	     endcase
endmodule

/* 
 * Instruction memory - contains program instructions.
 */
module instrmem_test_io_calc (
	 /* read address */
	 input [31:0] addr, 
	 /* instruction value */
	 output reg [31:0] instr);
	 	 
	 // hardcode program data - as soon as instruction memory is read-only,
	 // implement it in ROM-way
	 always @ (addr)
	     case (addr)
// ####################################################################
// # Ввести два числа, выставленных рычагами на плате в 2 ячейки памяти.
// # Первое значение устанавливается на 4хбитных рычагах при
// # значении 1битного рычага 1, затем вводится в память при переключении 
// # 1битного рычага из 1 в 0.
// # После этого второе значение устанавливается на этих же 4хбитных рычагах
// # при значении 1битного рычага 0, затем вводится в память
// # при переключении 1битного рычага из 0 в 1.
// # После этого выполняется сложение двух введенных значений и результат
// # отображается на 7мисегментном дисплее.
// 
//      # Ввод 1го значения
//      # ввод произойдет при bsf=0 (1битный рычаг ввода по адресу 0xf008)
// loop:
        32'h00000000: instr <= 32'b001000_00000_01000_0000000000000000; //        addi $t0, $0, 0 
// enter_1st:
//      # загрузить в $s0 значение рычага bsf (0 или 1)
        32'h00000004: instr <= 32'b100011_00000_10000_1111000000001000; //        lw $s0, 0xf008 ($0)
//		  # если рычаг =0, переходим к считыванию 4хбитного значения
        32'h00000008: instr <= 32'b000100_10000_01000_0000000000010000; //        beq $s0, $t0, enter_1st_finish
//      # ждать рычага =0 бесконечно до победного
        32'h0000000c: instr <= 32'b000010_00000000000000000000000100;   //        j enter_1st 
// enter_1st_finish:
//      # загрузить текущее значение рычагов bs (4 бита по адресу 0xf004) в память по адресу 0x00000000
        32'h00000010: instr <= 32'b100011_00000_10001_1111000000000100; //        lw $s1, 0xf004 ($0)
        32'h00000014: instr <= 32'b101011_00000_10001_0000000000000000; //        sw $s1, 0 ($0) 
// 
//      # Ввод 2го значения
//      # ввод произойдет при bsf=1 (1битный рычаг ввода по адресу 0xf008)
        32'h00000018: instr <= 32'b001000_00000_01000_0000000000000001; //        addi $t0, $0, 1
// enter_2nd:
//      # загрузить в $s0 значение рычага bsf (0 или 1)
        32'h0000001c: instr <= 32'b100011_00000_10000_1111000000001000; //        lw $s0, 0xf008 ($0)
//		  # если рычаг =1, переходим к считыванию 4хбитного значения
        32'h00000020: instr <= 32'b000100_10000_01000_0000000000101000; //        beq $s0, $t0, enter_2nd_finish
//      # ждать рычага =1 бесконечно до победного
        32'h00000024: instr <= 32'b000010_00000000000000000000011100;   //        j enter_2nd 
// enter_2nd_finish:
//      # загрузить текущее значение рычагов bs (4 бита по адресу 0xf004) в память по адресу 0x00000004
        32'h00000028: instr <= 32'b100011_00000_10001_1111000000000100; //        lw $s1, 0xf004 ($0)
        32'h0000002c: instr <= 32'b101011_00000_10001_0000000000000100; //        sw $s1, 4 ($0)
// 
// ####################################################################
// # Сложить введенные числа
//      # Загрузить введенные значения из памяти в регистры
        32'h00000030: instr <= 32'b100011_00000_10000_0000000000000000; //        lw $s0, 0 ($0)
        32'h00000034: instr <= 32'b100011_00000_10001_0000000000000100; //        lw $s1, 4 ($0)
//     
//      # Получить результат сложения: $s2 = $s0+$s1
        32'h00000038: instr <= 32'b000000_10000_10001_10010_00000_100000; //      add $s2, $s0, $s1
//     
//      # Сохранить результат в память по адресу 0x00000008
        32'h0000003c: instr <= 32'b101011_00000_10010_0000000000001000; //        sw $s2, 8 ($0)
//     
// ####################################################################
// # Отобразить результат на 7мисегментном дисплее 
// # (соответственно для простоты значение должно быть <=9, иначе покажет 'E' - Error)
//     
//      # Загрузить результат из памяти по адресу 0x00000008
        32'h00000040: instr <= 32'b100011_00000_10011_0000000000001000; //        lw $s3, 8 ($0)
		  //32'h00000040: instr <= 32'b100011_00000_10011_0000000000000000; //        lw $s3, 8 ($0)
		  //32'h00000040: instr <= 32'b001000_00000_10011_0000000000000000;
//     
//      # Определить текущее значение - загрузим в $s4 значение, которое поймет драйвер 7мисегментного дисплея
//      # (побитовое включение сегментов, нужно установить правильные значения 8ми младших битов регистра $v).
//      # Уникальны 1е три команды для одного значения, остальное на 99% копипаста
// 
//      # значение 0
        32'h00000044: instr <= 32'b001000_00000_10100_0000000001110111; //        addi $s4, $0, 16'b00000000 01110111
//      # $t0 = константа "0"
        32'h00000048: instr <= 32'b001000_00000_01000_0000000000000000; //        addi $t0, $0, 0       
//      # результат равен "0" - можно отображать
        32'h0000004c: instr <= 32'b000100_10011_01000_0000000011000000; //        beq $s3, $t0, display 
//     
//      # значение 1
        32'h00000050: instr <= 32'b001000_00000_10100_0000000000010100; //        addi $s4, $0, 16'b00000000 00010100
//      # $t0 = константа "1"
        32'h00000054: instr <= 32'b001000_00000_01000_0000000000000001; //        addi $t0, $0, 1       
//      # результат равен "1" - можно отображать
        32'h00000058: instr <= 32'b000100_10011_01000_0000000011000000; //        beq $s3, $t0, display 
//     
//      # значение 2
        32'h0000005c: instr <= 32'b001000_00000_10100_0000000010110011; //        addi $s4, $0, 16'b00000000 10110011
//      # $t0 = константа "2"
        32'h00000060: instr <= 32'b001000_00000_01000_0000000000000010; //        addi $t0, $0, 2       
//      # результат равен "2" - можно отображать
        32'h00000064: instr <= 32'b000100_10011_01000_0000000011000000; //        beq $s3, $t0, display 
//     
//      # значение 3
        32'h00000068: instr <= 32'b001000_00000_10100_0000000010110110; //        addi $s4, $0, 16'b00000000 10110110
//      # $t0 = константа "3"
        32'h0000006c: instr <= 32'b001000_00000_01000_0000000000000011; //        addi $t0, $0, 3       
//      # результат равен "3" - можно отображать
        32'h00000070: instr <= 32'b000100_10011_01000_0000000011000000; //        beq $s3, $t0, display 
//     
//      # значение 4
        32'h00000074: instr <= 32'b001000_00000_10100_0000000011010100; //        addi $s4, $0, 16'b00000000 11010100
//      # $t0 = константа "4"
        32'h00000078: instr <= 32'b001000_00000_01000_0000000000000100; //        addi $t0, $0, 4
//      # результат равен "4" - можно отображать
        32'h0000007c: instr <= 32'b000100_10011_01000_0000000011000000; //        beq $s3, $t0, display 
//     
//      # значение 5
        32'h00000080: instr <= 32'b001000_00000_10100_0000000011100110; //        addi $s4, $0, 16'b00000000 11100110
//      # $t0 = константа "5"
        32'h00000084: instr <= 32'b001000_00000_01000_0000000000000101; //        addi $t0, $0, 5
//      # результат равен "5" - можно отображать
        32'h00000088: instr <= 32'b000100_10011_01000_0000000011000000; //        beq $s3, $t0, display 
//     
//      # значение 6
        32'h0000008c: instr <= 32'b001000_00000_10100_0000000011100111; //        addi $s4, $0, 16'b00000000 11100111
//      # $t0 = константа "6"
        32'h00000090: instr <= 32'b001000_00000_01000_0000000000000110; //        addi $t0, $0, 6       
//      # результат равен "6" - можно отображать
        32'h00000094: instr <= 32'b000100_10011_01000_0000000011000000; //        beq $s3, $t0, display 
//     
//      # значение 7
        32'h00000098: instr <= 32'b001000_00000_10100_0000000000110100; //        addi $s4, $0, 16'b00000000 00110100
//      # $t0 = константа "7"
        32'h0000009c: instr <= 32'b001000_00000_01000_0000000000000111; //        addi $t0, $0, 7       
//      # результат равен "7" - можно отображать
        32'h000000a0: instr <= 32'b000100_10011_01000_0000000011000000; //        beq $s3, $t0, display 
//     
//      # значение 8
        32'h000000a4: instr <= 32'b001000_00000_10100_0000000011110111; //        addi $s4, $0, 16'b00000000 11110111
//      # $t0 = константа "8"
        32'h000000a8: instr <= 32'b001000_00000_01000_0000000000001000; //        addi $t0, $0, 8       
//      # результат равен "8" - можно отображать
        32'h000000ac: instr <= 32'b000100_10011_01000_0000000011000000; //        beq $s3, $t0, display 
//     
//      # значение 9
        32'h000000b0: instr <= 32'b001000_00000_10100_0000000011110110; //        addi $s4, $0, 16'b00000000 11110110
//      # $t0 = константа "9"
        32'h000000b4: instr <= 32'b001000_00000_01000_0000000000001001; //        addi $t0, $0, 9       
//      # результат равен "9" - можно отображать
        32'h000000b8: instr <= 32'b000100_10011_01000_0000000011000000; //        beq $s3, $t0, display 
//     
//      # не подошел ни один вариант - значение E (Error)
        32'h000000bc: instr <= 32'b001000_00000_10100_0000000011101011; //        addi $s4, $0, 16'b00000000 11101011
// 
//      # Отобразить результат - отправить значение из регистра $s4 в "видеопамять" (7мисегментный дисплей)
//      # по адресу 0xf000
// display:
        32'h000000c0: instr <= 32'b101011_00000_10100_1111000000000000; //        sw $s4, 0xf000 ($0)
// 
//      # Зациклим в начало
        32'h000000c4: instr <= 32'b000010_00000000000000000000000000; //        j loop 
		  default: instr <= 0;

	     endcase
endmodule
