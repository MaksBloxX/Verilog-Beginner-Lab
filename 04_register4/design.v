`timescale 1ns/1ps

// Active-high synchronous reset. Reset has priority over enable.
module register4(
    input clk, reset, enable,
    input [3:0] d,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else if (enable)
            q <= d;
        // With enable = 0, q keeps its previous value.
    end
endmodule
