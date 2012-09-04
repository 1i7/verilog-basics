/**
 * Divides 25MHz clock to one second.
 */ 
module clock_divider(
    input clk,
    output one_second
    );

    reg [25:0] counter;

    // count up on each positive clock
    always @(posedge clk)
            counter <= counter + 1;

    // one second signal would be emitted when 
	 // 26th bit of the counter would become "1"
    assign one_second = counter[25];
endmodule
