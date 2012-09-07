module scorpion(input clk, input reset, input danger, output [3:0] out_state);

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

reg [3:0] state, next_state;

wire clk_second;
reg clk_second_reset;
clock_divider timer(.clk(clk), .reset(clk_second_reset), .finish(clk_second));

always@(*)
begin
 clk_second_reset=0;
 next_state=state;
 case (state)
  state_sensor1:
    if(danger)
	 begin
	    clk_second_reset=1;
	    next_state=state_retreat1;
	 end
  state_retreat1:
    if(clk_second)
	 begin
    	 clk_second_reset=1;	 
	    next_state=state_wait1;
	 end
  state_wait1:
    if(clk_second)    
	    next_state=state_sensor2;
  state_sensor2:
    if(danger)
	 begin
	    clk_second_reset=1;
	    next_state=state_retreat2;
	 end
  state_retreat2:
    if(clk_second)
	 begin
    	 clk_second_reset=1;	 
	    next_state=state_wait2;
	 end
  state_wait2:
    if(clk_second)
	    next_state=state_sensor3;
  state_sensor3:
    if(danger)
	 begin
	    clk_second_reset=1;
	    next_state=state_attack;
	 end
  state_attack:
    if(clk_second)
	 begin
    	 clk_second_reset=1;	 
	    next_state=state_dart;
	 end
  state_dart:
    if(clk_second)
	    next_state=state_wait3;
  state_wait3:
    if(clk_second)
	    next_state=state_sensor1;
 endcase
end

always@(posedge clk, posedge reset)
    if(reset)
	     state <= state_sensor1;
	 else  state<=next_state;
 
assign out_state=state;

endmodule
