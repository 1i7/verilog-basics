/**
 * Top module to test clock divider - 
 * blink lamp with 1 second period.
 */
module clock_divider_top(
    input clk,
	 output [0:0] ld
    );
    clock_divider count(.clk(clk), .one_second(ld[0]));
endmodule
