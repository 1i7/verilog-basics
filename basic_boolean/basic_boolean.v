module basic_boolean(input a, input b, 
    output not_a, output not_b, output a_and_b,
    output a_or_b, output a_nand_b
    );

assign not_a = ~a; // NOT
assign not_b = ~b; // NOT
assign a_and_b = a & b; // AND
assign a_or_b = a | b; // OR
assign a_nand_b = ~(a & b); // NAND

endmodule
