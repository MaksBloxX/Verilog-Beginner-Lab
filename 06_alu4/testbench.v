`timescale 1ns/1ps

module tb;
    reg [3:0] a, b;
    reg [1:0] op;
    wire [3:0] result;
    integer errors;

    alu4 dut(.a(a), .b(b), .op(op), .result(result));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        a = 4'd6; b = 4'd3;

        op = 2'b00; #10;
        $display("6 + 3 = %0d (expected 9)", result);
        if (result !== 4'd9) errors = errors + 1;

        op = 2'b01; #10;
        $display("6 - 3 = %0d (expected 3)", result);
        if (result !== 4'd3) errors = errors + 1;

        op = 2'b10; #10;
        $display("6 AND 3 = %0d (expected 2)", result);
        if (result !== 4'd2) errors = errors + 1;

        op = 2'b11; #10;
        $display("6 OR 3 = %0d (expected 7)", result);
        if (result !== 4'd7) errors = errors + 1;

        a = 4'd15; b = 4'd1; op = 2'b00; #10;
        $display("15 + 1 = %0d (expected 0 in four bits)", result);
        if (result !== 4'd0) errors = errors + 1;

        a = 4'd3; b = 4'd5; op = 2'b01; #10;
        $display("3 - 5 = %0d (expected 14 in unsigned four bits)", result);
        if (result !== 4'd14) errors = errors + 1;

        if (errors == 0) $display("PASS: ALU");
        else $display("FAIL: ALU, errors=%0d", errors);
        $finish;
    end
endmodule
