`timescale 1ns/1ps

module tb;
    reg a, b, cin;
    wire sum, cout;
    integer i, errors;
    reg [1:0] expected;

    full_adder dut(
        .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        $display("a b cin | cout sum");
        // i = 0 to 7 covers every combination of three input bits.
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i;
            #10;
            // Zero extension preserves the carry in this reference sum.
            expected = {1'b0, a} + {1'b0, b} + {1'b0, cin};
            $display("%b %b  %b  |   %b   %b", a, b, cin, cout, sum);
            if ({cout, sum} !== expected) errors = errors + 1;
        end
        if (errors == 0) $display("PASS: full adder");
        else $display("FAIL: full adder, errors=%0d", errors);
        $finish;
    end
endmodule
