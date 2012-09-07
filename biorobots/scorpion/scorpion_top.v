module scorpion_top(input clk, input [0:0] sw, input danger, output reg [76:79] PIO,
output [0:4] ld);

assign ld[0] = danger;

wire [3:0] state;
parameter state_sensor1=4'b0000;
parameter state_retreat1=4'b0001;
parameter state_wait1=4'b0010;
parameter state_sensor2=4'b0011;
parameter state_retreat2=4'b0100;
parameter state_wait2=4'b0101;
parameter state_sensor3=4'b0110;
parameter state_attack=4'b0111;
parameter state_dart=4'b1000;
parameter state_wait3=4'b1001;

reg [1:0] action;
parameter action_wait=2'b00;
parameter action_retreat=2'b01;
parameter action_attack=2'b10;
parameter action_dart=2'b11;

scorpion scorp(.clk(clk), .reset(sw[0]), .danger(danger), .out_state(state));

always@(state)
 if (state==state_retreat1 | state==state_retreat2) action=action_retreat;
		else if (state==state_attack) action=action_attack;
		     else if (state==state_dart) action=action_dart;
			       else action=action_wait;

assign ld[1] = action == action_wait ? 1 : 0;
assign ld[2] = action == action_retreat ? 1 : 0;
assign ld[3] = action == action_attack ? 1 : 0;
assign ld[4] = action == action_dart ? 1 : 0;
					 
					 
always@(*)
begin
 case(action) 
 action_retreat:
 begin
  PIO [76]<=1;
  PIO [77]<=0;
  PIO [78]<=1;
  PIO [79]<=0;
 end
 action_attack:
 begin
  PIO [76]<=0;
  PIO [77]<=1;
  PIO [78]<=0;
  PIO [79]<=1;
 end
 action_dart:
 begin
  PIO [76]<=0;
  PIO [77]<=0;
  PIO [78]<=0;
  PIO [79]<=0;  
 end
 default:
 begin
  PIO [76:79] <=0;
 end
 endcase
end
endmodule
