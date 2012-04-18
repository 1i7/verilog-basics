module seven_driver_basys2(
    input [0:0] sw,
	 output [72:79] pio
    );
	 
seven_driver driver57(.value(sw[0]), .segments(pio));

endmodule
