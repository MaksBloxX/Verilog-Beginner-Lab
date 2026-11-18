`timescale 1ns/1ps

module tb;
    reg clk, reset, enable;
    reg [3:0] d;
    wire [3:0] q;
    integer errors;

    register4 dut(
        .clk(clk), .reset(reset), .enable(enable), .d(d), .q(q)
    );

    // A 10 ns clock period: rising edges at 5, 15, 25, ... ns.
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        errors = 0;
        reset = 1; enable = 1; d = 4'd15;

        // Check after the rising edge, allowing <= updates to complete.
        @(posedge clk); #1;
        if (q !== 4'd0) errors = errors + 1;
        $display("Reset overrides enable: q=%0d (expected 0)", q);

        // Change data and controls at falling edges to avoid clock-edge races.
        @(negedge clk);
        reset = 0; enable = 1; d = 4'd10;
        #1;
        if (q !== 4'd0) errors = errors + 1;
        @(posedge clk); #1;
        if (q !== 4'd10) errors = errors + 1;
        $display("Load 10: q=%0d (expected 10)", q);

        @(negedge clk);
        enable = 0; d = 4'd3;
        @(posedge clk); #1;
        if (q !== 4'd10) errors = errors + 1;
        $display("Hold: q=%0d (expected 10)", q);

        @(negedge clk);
        enable = 1;
        @(posedge clk); #1;
        if (q !== 4'd3) errors = errors + 1;
        $display("Load 3: q=%0d (expected 3)", q);

        @(negedge clk);
        reset = 1;
        #1;
        if (q !== 4'd3) errors = errors + 1;
        @(posedge clk); #1;
        if (q !== 4'd0) errors = errors + 1;
        $display("Synchronous reset: q=%0d (expected 0)", q);

        if (errors == 0) $display("PASS: register");
        else $display("FAIL: register, errors=%0d", errors);
        $finish;
    end
endmodule
