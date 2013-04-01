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
	 
	 wire bsf_debounced;
	 debounce_bsf debounce_bsf(clk, bsf, bsf_debounced);
	 
	 // use leds just to hightlight button switches values
	 assign ldf = bsf;
	 assign ld = bs;
	 
	 // Data memory
	 wire dmem_we;
	 wire [31:0] dmem_addr;
	 wire [31:0] dmem_wd;
	 wire [31:0] dmem_rd;
	 datamem dmem(clk, dmem_we, dmem_addr, dmem_wd, dmem_rd,		  
		  bs, bsf_debounced, v);
	 
	 // Processor core
	 mips mips(clk, 
	     pc, instr, 
		  dmem_we, dmem_addr, dmem_wd, dmem_rd);
endmodule

module timer
#(parameter delay_bit = 23)
(
    input clock,
    input reset,
    output finish
    );

    reg [delay_bit:0] counter;

    always @(posedge clock, posedge reset)
    begin
        if (reset)
            counter <= 0;
        else if (!counter [delay_bit])
            counter <= counter + 1;
    end

    assign finish = counter [delay_bit];

endmodule

module debounce_bsf(input clk, input bsf, output reg bsf_debounced);

    	// part second timer controls
    wire timer_part_second;
    reg timer_part_second_reset;
    timer part_second(.clock(clk), .reset(timer_part_second_reset),
        .finish(timer_part_second));
		  
	 reg next_bsf;

    always @(*)
    begin
        // start timer if it was reset
        timer_part_second_reset = 0;	
        if(timer_part_second)
		  begin
		      timer_part_second_reset = 1;
		      next_bsf = bsf;
		  end
	 end
	 
	 always @ (posedge clk)
        bsf_debounced <= next_bsf;
endmodule
