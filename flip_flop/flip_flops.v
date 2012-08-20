/**
 * RS latch
 */
module rs_latch(
    input r, input s,
    output q, output not_q
    );

    assign q = ~(r | not_q);
    assign not_q = ~(s | q);

endmodule

/**
 * D latch
 */
module d_latch(
    input clk, input d,
    output q, output not_q
    );

    wire r, s;

    assign r = clk & ~d;
    assign s = clk & d;

    rs_latch rs(.r(r), .s(s), .q(q), .not_q(not_q));

endmodule

/**
 * D flip-flop
 */
module d_flip_flop(
    input clk, input d,
    output q, output not_q
    );

    wire n1;

    // master
    d_latch l1 (.clk(~clk), .d(d), .q(n1));

    // slave
    d_latch l2 (.clk(clk), .d(n1), .q(q), .not_q(not_q));

endmodule

