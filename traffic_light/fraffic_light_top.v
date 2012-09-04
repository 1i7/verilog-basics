/**
 * Top module to test traffic light.
 */ 
module traffic_light_top(
    input clk,
	 output [0:2] ld
    );
	 
	 // enumerate state constants
	 parameter state_green = 2'b00;
	 parameter state_yellow1 = 2'b01;
	 parameter state_red = 2'b10;
	 parameter state_yellow2 = 2'b11;

    // current state value	 
	 wire [1:0] state;
	 
	 // connect "clk" and "state" wires to traffic light logic implementation
	 traffic_light lights(.clk(clk), .out_state(state));
	 
	 // display current state on output devices (lamps)
	 // for state_green switch on green lamp and switch off red and yellow,
	 // for state_yellow1 and state_yellow2 switch on yellow lamp and switch off green and red,
	 // for state_red switch on red lamp and swithc off green and yellow.
	 // 
	 // All actions are performed at on and the same moment - order does not make
	 // any sense.
	 
	 // "green" lamp
	 assign ld[0] = state == state_green ? 1 : 0;
	 // "yellow" lamp
	 assign ld[1] = (state == state_yellow1) | (state == state_yellow2) ? 1 : 0;
	 // "red" lamp
	 assign ld[2] = state == state_red ? 1 : 0;

endmodule
