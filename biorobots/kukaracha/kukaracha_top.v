module kukaracha_top (input clk, input sound, output reg [0:1] GPIO1_D);

parameter state_forward_wait = 3'b000;
parameter state_forward = 3'b001;
parameter state_forward_rest = 3'b010;
parameter state_back_wait = 3'b011;
parameter state_back = 3'b100;
parameter state_back_rest = 3'b101;

wire [2:0] state;

kukaracha kuk (.clk(clk), .sound(sound), .out_state(state));

reg [1:0] action;
parameter action_forward = 2'b00;
parameter action_wait = 2'b01;
parameter action_back = 2'b10;

always @ (state)
	if (state == state_forward)
		action = action_forward;
	else if (state == state_back)
		action = action_back;
	else
		action = action_wait;
		
always @ (*)
begin
	case (action)
		action_forward:
		begin
			GPIO1_D [0] <= 1;
			GPIO1_D [1] <= 0;
		end
		action_back:
		begin
			GPIO1_D [0] <= 0;
			GPIO1_D [1] <= 1;
		end
		action_wait:
		begin
			GPIO1_D [0:1] <= 0;
		end
	endcase
end
		
endmodule
