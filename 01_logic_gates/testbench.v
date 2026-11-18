`timescale 1ns/1ps

module tb;
    reg a, b;
    wire y_and, y_or, y_not;
    integer errors;

    logic_gates dut(
        .a(a), .b(b),
        .y_and(y_and), .y_or(y_or), .y_not(y_not)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        $display("a b | AND OR NOT_a");

        a = 0; b = 0; #10;
        $display("%b %b |  %b   %b    %b", a, b, y_and, y_or, y_not);
        if ({y_and, y_or, y_not} !== 3'b001) errors = errors + 1;

        a = 0; b = 1; #10;
        $display("%b %b |  %b   %b    %b", a, b, y_and, y_or, y_not);
        if ({y_and, y_or, y_not} !== 3'b011) errors = errors + 1;

        a = 1; b = 0; #10;
        $display("%b %b |  %b   %b    %b", a, b, y_and, y_or, y_not);
        if ({y_and, y_or, y_not} !== 3'b010) errors = errors + 1;

        a = 1; b = 1; #10;
        $display("%b %b |  %b   %b    %b", a, b, y_and, y_or, y_not);
        if ({y_and, y_or, y_not} !== 3'b110) errors = errors + 1;

        if (errors == 0) $display("PASS: logic gates");
        else $display("FAIL: logic gates, errors=%0d", errors);
        $finish;
    end
endmodule
