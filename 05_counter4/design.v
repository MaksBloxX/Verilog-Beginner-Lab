`timescale 1ns/1ps

// Active-high synchronous reset. The four-bit count wraps after 15.
module counter4(
    input clk, reset,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (reset)
            count <= 4'b0000;
        else
            count <= count + 4'b0001;
    end
endmodule
