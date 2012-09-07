module Clock_divider
#(parameter delay_bit = 25)
(input clk, input reset, output finish);

reg [delay_bit:0] counter;

always @ (posedge clk)
	if (reset)
		counter <= 0;
	else if (!counter [delay_bit])
		counter <= counter + 1;
		
assign finish = counter [delay_bit];

endmodule
