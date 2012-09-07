module top(input clk, input chip_i, output [0:1] roll, output [0:1] head);
parameter action_head_i=3'b100, action_head_o=3'b001, action_rolling=3'b010;
wire [3:0]state;
reg [1:0] action_head_i, action_head_o, action_rolling;
trafic_lights t_lights(.clk(clk), .food(chip_i), .o_state(state));
endmodule