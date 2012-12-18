/**
 * MIPS processor top module - connect clock
 * and i/o devices for testing:
 * 8 button switches to input 7bit values and 
 * 8 leds just to hightlight button switches positions,
 * 7segment display ports.
 */
module mips_top(input clk,

    input bsf,
	 input [3:0] bs,
	 
	 output [7:0] v,
	 
	 output ldf,
	 output [3:0] ld);
    
	 // Instruction memory
	 wire [31:0] pc;
	 // instruction value 
	 wire [31:0] instr;
	 instrmem instrmem(pc, instr);
	 
	 // use leds just to hightlight button switches values
	 assign ldf = bsf;
	 assign ld = bs;
	 
	 // Data memory
	 wire dmem_we;
	 wire [31:0] dmem_addr;
	 wire [31:0] dmem_wd;
	 wire [31:0] dmem_rd;
	 datamem dmem(clk, dmem_we, dmem_addr, dmem_wd, dmem_rd,		  
		  bs, bsf, v);
	 
	 // Processor core
	 mips mips(clk, 
	     pc, instr, 
		  dmem_we, dmem_addr, dmem_wd, dmem_rd);
endmodule
