module Traffic_lights (input clk, output out_state);

parameter state_green = 2'b00;
parameter state_yellow1 = 2'b01;
parameter state_yellow2 = 2'b10;
parameter state_red = 2'b11;

reg [1:0] state, next_state;

wire clk_second;

Clock_divider count (.clk(clk), .one_second (clk_second));

always @ (*)
begin
	next_state = state;
	case (state)
		state_green:
		if (clk_second)
			next_state = state_yellow1;
		state_yellow1:
		if (clk_second)
			next_state = state_red;
		state_yellow2:
		if (clk_second)
			next_state = state_green;
		state_red:
		if (clk_second)
			next_state = state_yellow2;
	endcase
end

always @ (posedge clk)
		state <= next_state;
		
assign out_state = state;
	
endmodule
