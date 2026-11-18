`timescale 1ns/1ps

module tb;
    reg clk, reset;
    wire [3:0] count;
    integer i, errors;
    reg [3:0] expected;

    counter4 dut(.clk(clk), .reset(reset), .count(count));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        reset = 1;
        @(posedge clk); #1;
        if (count !== 4'd0) errors = errors + 1;
        $display("Reset: count=%0d", count);

        @(negedge clk);
        reset = 0;
        for (i = 1; i <= 18; i = i + 1) begin
            @(posedge clk); #1;
            expected = i % 16;
            $display("Clock %0d: count=%0d (expected %0d)", i, count, expected);
            if (count !== expected) errors = errors + 1;
        end

        // Reset must wait for a rising clock edge.
        @(negedge clk);
        reset = 1;
        #1;
        if (count !== 4'd2) errors = errors + 1;
        @(posedge clk); #1;
        if (count !== 4'd0) errors = errors + 1;

        if (errors == 0) $display("PASS: counter");
        else $display("FAIL: counter, errors=%0d", errors);
        $finish;
    end
endmodule
