// Three simple logic gates. y_not is the inverse of a.
`timescale 1ns/1ps

module logic_gates(
    input a, b,
    output y_and, y_or, y_not
);
    assign y_and = a & b;
    assign y_or  = a | b;
    assign y_not = ~a;
endmodule
