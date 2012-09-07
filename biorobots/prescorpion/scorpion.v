module scorpion(input clk, input reset, input danger, output out_state);

parameter state_wait1=3'b000;
parameter state_retreat1=3'b001;
parameter state_wait2=3'b010;
parameter state_retreat2=3'b011;
parameter state_wait3=3'b100;
parameter state_attack=3'b101;
parameter state_dart=3'b110;

reg [2:0] state, next_state;

wire clk_second;
reg clk_second_reset;
clock_divider timer(.clk(clk), .reset(clk_second_reset), .finish(clk_second));

always@(*)
begin
 clk_second_reset=0;
 next_state=state;
 case (state)
  state_wait1:
   if(danger)
	begin
	    clk_second_reset=1;
	    next_state=state_retreat1;
	end
  state_retreat1:
   if(clk_second)
	    next_state=state_wait2;
  state_wait2:
   if(danger)
	begin
	    clk_second_reset=1;
	    next_state=state_retreat2;
	end
  state_retreat2:
   if(clk_second)
	   next_state=state_wait3;
  state_wait3:
   if(danger)
	begin
	    clk_second_reset=1;
	    next_state=state_attack;
	end
  state_attack:
   if(clk_second)
	    next_state=state_dart;
  state_dart:
   if(clk_second)
	   next_state=state_wait1;
 endcase
end
always@(posedge clk, posedge reset)
    if(reset)
	     state <= state_wait1;
	 else  state<=next_state;
 
assign out_state=state;

endmodule
