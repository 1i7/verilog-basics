/**
 * Traffic light.
 */ 
module traffic_light(
    input clk,
	 output [1:0] out_state
    );

    // enumerate state constants
    parameter state_green = 2'b00;
	 parameter state_yellow1 = 2'b01;
	 parameter state_red = 2'b10;
	 parameter state_yellow2 = 2'b11;

    reg [1:0] state, next_state;
	 
	 // one second timer controls
	 wire timer_one_second;
	 reg timer_one_second_reset;
	 timer one_second(.clock(clk), .reset(timer_one_second_reset), 
	     .finish(timer_one_second));
		  
	 // parametrized module possible example - replace 
	 // default 25 value with 26, so timer would work 2 
	 // seconds instead of 1 (not used here)
	 // timer #(26) two_seconds(.clock(clk), .reset(timer_two_seconds_reset), 
	 //    .finish(timer_two_seconds));
	 	 	 
	 // detect next state depending on current state
    // and current clock - change state one time per second:
	 // green>yellow1>red>yello2>green>...
	 always @(*)
	 begin
	     // start timer if it was reset
	     timer_one_second_reset = 0;		  
		  // next state would not change by default
	     next_state = state;
	     case (state)
	         state_green:
				begin
				    if(timer_one_second)
					 begin
					     // arm timer to count one second
						  // before moving to the next state
						  timer_one_second_reset = 1;
						  // move to the next state
					     next_state = state_yellow1;
					 end
			   end
				state_yellow1:
				begin
				    if(timer_one_second)
					 begin
					     // arm timer to count one second
						  // before moving to the next state
						  timer_one_second_reset = 1;
						  // move to the next state
					     next_state = state_red;
					 end
			   end
		      state_red:
				begin
				    if(timer_one_second)
					 begin
					     // arm timer to count one second
						  // before moving to the next state
						  timer_one_second_reset = 1;
						  // move to the next state
					     next_state = state_yellow2;
					 end
				end
			   state_yellow2:
				begin
				    if(timer_one_second)
					 begin
					     // arm timer to count one second
						  // before moving to the next state
						  timer_one_second_reset = 1;
						  // move to the next state
					     next_state = state_green;
					 end
				end
	     endcase
	 end
	 
	 // change from current state to the next_state
	 // which was determined in the above always block
	 always @ (posedge clk)
	    state <= next_state;
		  
	 // provide output state value		  
    assign out_state = state;
endmodule
