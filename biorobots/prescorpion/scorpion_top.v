module scorpion_top(input clk, input [0:0] sw, input danger, output reg [76:79] PIO,
output [0:0] ld);

assign ld[0] = danger;

wire [2:0] state;
parameter state_wait1=3'b000;
parameter state_retreat1=3'b001;
parameter state_wait2=3'b010;
parameter state_retreat2=3'b011;
parameter state_wait3=3'b100;
parameter state_attack=3'b101;
parameter state_dart=3'b110;

reg [1:0] action;
parameter action_wait=2'b00;
parameter action_retreat=2'b01;
parameter action_attack=2'b10;
parameter action_dart=2'b11;

scorpion scorp(.clk(clk), .reset(sw[0]), .danger(danger), .out_state(state));

always@(state)
 if (state==state_wait1 | state==state_wait2 | state==state_wait3) action=action_wait;
 else if (state==state_retreat1 | state==state_retreat2) action=action_retreat;
		else if (state==state_attack) action=action_attack;
		     else action=action_dart;
always@(*)
begin
 case(action)
 action_retreat:
 begin
  PIO [76]<=1;
  PIO [77]<=0;
  PIO [78]<=0;
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
  PIO [78]<=1;
  PIO [79]<=0;  
 end
 default:
 begin
 PIO [76] <=0;
  PIO [77:79] <=0;
  
 end
 endcase
end
endmodule
