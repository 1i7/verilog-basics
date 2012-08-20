// RS latch test top module
module rs_latch_top(
    input [72:73] pio,
    output [0:1] ld
    );
	 
    // RS Latch
    rs_latch rs (.r(pio[72]), .s(pio[73]),
            .q(ld[0]), .not_q(ld[1]));	 
endmodule


// D latch test top module
module d_latch_top(
    input [0:0] sw,
    input [72:72] pio,
    output [0:1] ld
    );

    d_latch d (.clk(sw[0]), .d(pio[72]),
            .q(ld[0]), .not_q(ld[1]));
endmodule

// D flip-flop test top module
module d_flip_flop_top(
    input [0:0] sw,
    input [72:72] pio,
    output [0:1] ld
    );

    d_flip_flop d (.clk(sw[0]), .d(pio[72]),
            .q(ld[0]), .not_q(ld[1]));
endmodule

// 4-bit register with 4 D flip-flops test top module
module d_4bit_register_top(
    input [0:0] sw,
    input [72:75] pio,
    output [0:3] ld
    );

    d_flip_flop d1 (.clk(sw[0]), .d(pio[72]), .q(ld[3]));
    d_flip_flop d2 (.clk(sw[0]), .d(pio[73]), .q(ld[2]));
	 d_flip_flop d3 (.clk(sw[0]), .d(pio[74]), .q(ld[1]));
	 d_flip_flop d4 (.clk(sw[0]), .d(pio[75]), .q(ld[0]));

endmodule
