module seven_driver(
    input value,
	 output [0:7] segments
    );

	 // value=true - 7
	 // value=false - 5
	 
	 // common anode display: 1 = OFF, 0 = ON
	 
	 assign segments[0] = value ? 1 : 1;
	 assign segments[1] = value ? 1 : 0;
	 assign segments[2] = value ? 0 : 0;
	 assign segments[3] = value ? 0 : 0;
	 assign segments[4] = value ? 0 : 1;
	 assign segments[5] = value ? 0 : 0;
	 assign segments[6] = value ? 1 : 0;
	 assign segments[7] = value ? 1 : 0;

endmodule

