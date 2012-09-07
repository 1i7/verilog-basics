module kukaracha (input clk, input sound, output [2:0]out_state);

parameter state_forward_wait = 3'b000;
parameter state_forward = 3'b001;
parameter state_forward_rest = 3'b010;
parameter state_back_wait = 3'b011;
parameter state_back = 3'b100;
parameter state_back_rest = 3'b101;

reg [2:0] state, next_state;

wire clk_second;
reg sec_reset;

Clock_divider count (.clk(clk), .reset(sec_reset), .finish (clk_second));

always @ (*)
begin
	sec_reset = 0;
	next_state = state;
	case (state)
		state_forward:
		if (clk_second)
		begin
			sec_reset = 1;
			next_state = state_forward_rest;
			end
		state_forward_rest:
		if (clk_second)
			next_state = state_back_wait;
		state_back_wait:
		if (sound)
		begin
			sec_reset = 1;
			next_state = state_back;
		end
		state_back:
		if (clk_second)
		begin
		sec_reset = 1;
			next_state = state_back_rest;
			end
		state_back_rest:
		if (clk_second)
			next_state = state_forward_wait;
		state_forward_wait:
		if (sound)
		begin
			sec_reset = 1;
			next_state = state_forward;
		end
	endcase
end

always @ (posedge clk)
		state <= next_state;
		
assign out_state = state;
	
endmodule