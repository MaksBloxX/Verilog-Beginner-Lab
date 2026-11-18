`timescale 1ns/1ps

module tb;
    reg a, b, sel;
    wire y;
    integer errors;

    mux2 dut(.a(a), .b(b), .sel(sel), .y(y));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        $display("a b sel | y");

        a = 0; b = 1; sel = 0; #10;
        $display("%b %b  %b  | %b", a, b, sel, y);
        if (y !== 1'b0) errors = errors + 1;

        sel = 1; #10;
        $display("%b %b  %b  | %b", a, b, sel, y);
        if (y !== 1'b1) errors = errors + 1;

        a = 1; b = 0; sel = 0; #10;
        $display("%b %b  %b  | %b", a, b, sel, y);
        if (y !== 1'b1) errors = errors + 1;

        sel = 1; #10;
        $display("%b %b  %b  | %b", a, b, sel, y);
        if (y !== 1'b0) errors = errors + 1;

        a = 0; b = 0; sel = 0; #10;
        if (y !== 1'b0) errors = errors + 1;
        sel = 1; #10;
        if (y !== 1'b0) errors = errors + 1;

        a = 1; b = 1; sel = 0; #10;
        if (y !== 1'b1) errors = errors + 1;
        sel = 1; #10;
        if (y !== 1'b1) errors = errors + 1;

        if (errors == 0) $display("PASS: multiplexer");
        else $display("FAIL: multiplexer, errors=%0d", errors);
        $finish;
    end
endmodule
