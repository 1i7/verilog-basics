/**
 * Data memory. I/o devices are mapped to
 * addresses starting from 0x0000f000.
 *
 * v (7segment display "video memory") is mapped to word at 0x0000f000,
 * bs (array of button switches) is mapped to word at 0x0000f004,
 * bsf (single button switch) is mapped to word at 0x0000f008.
 *
 * @param clk - clock
 *
 * @param we - write enabled flag
 * @param addr - access address for read/write
 * @param wd - write data
 * @param rd - read data
 *
 * @param bs - button switch input device
 * @param bsf - buttons switch flag input device
 * @param v - 7-segment output device ("video")
 */
module datamem (input clk,
    input we, input [31:0] addr, 
	 input [31:0] wd, 
	 output [31:0] rd,
	 
	 /* Handle basic i/o */
	 input [31:0] bs, input bsf, output [31:0] v);

    // data memory array
	 reg [31:0] RAM [63:0];
	 
	 // handle basic i/o - map some memory addresses to external devices:
	 reg [31:0] video;
	 
	 // write data to RAM if we (write enabled) is '1'
	 always @(posedge clk)
	     if(we) 
		  begin 
		      if(addr == 32'h0000f000)
				    video <= wd;
				else
		          RAM[addr[31:2]] <= wd; 
		  end		  
	 
	 // bs (array of button switches), bsf (single button switch flag)
	 assign rd = addr == 32'h0000f004 ? bs : (addr == 32'h0000f008 ? bsf : RAM[addr[31:2]]);
	 // and v (7segment display "video memory")	 
	 assign v = ~video; // invert value for common anode display
endmodule 

/**
 * Plain data memory block (not used in the default example).
 */
module datamem_plain (input clk,
    input we, input [31:0] addr, 
	 input [31:0] wd, 
	 output [31:0] rd);

    // data memory array
	 reg [31:0] RAM [63:0];
	 
	 // write data to RAM if we (write enabled) is '1'
	 always @(posedge clk)
	     if(we) RAM[addr[31:2]] <= wd;
	 
	 // read data from RAM
	 assign rd = RAM[addr[31:2]]; // word aligned - divide addr by 4 (just remove last 2 bits)
	 
endmodule
