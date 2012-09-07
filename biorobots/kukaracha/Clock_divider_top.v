module Clock_divider_top(input clk, output [0:2] ld);

parameter state_green = 2'b00;
parameter state_yellow1 = 2'b01;
parameter state_yellow2 = 2'b10;
parameter state_red = 2'b11;

wire [0:1] state;

Traffic_lights lights (.clk(clk), .out_state(state));

assign ld [0] = state == state_green ? 1:0;
assign ld [1] = (state == state_yellow1) | (state == state_yellow2) ? 1:0;
assign ld [2] = state == state_red ? 1:0;

endmodule
