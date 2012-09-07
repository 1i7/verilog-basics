module trafic_lights(input clk, input food, output o_state);
parameter rest=3'b000, head_going_o=3'b001, head_going_i=3'b100, 
head_out=3'b010, body_roll_going=3'b111;
reg [2:0] state, next_state, reset;
wire clk_second;
timer count(.clk(clk), .reset(reset), .finish(clk_second));
always @(*)
	begin
		reset=0;
		next_state=state;
		case (state)
			rest:
				if(food)
					begin
						reset=1;
						next_state=head_going_o;
					end
			head_going_o:
				if(clk_second)
					next_state=head_out;
			head_going_i:
				if(clk_second)
					next_state=rest;
			head_out:
				if(food)
					begin
						reset=1;
						next_state=body_roll_going;
					end
				else
					begin
						reset=1;
						next_state=head_going_i;
					end
			body_roll_going:
				if(clk_second)
					next_state=head_out;
		endcase
	end
always @(posedge clk)
	state<=next_state;
assign o_state=state;
endmodule