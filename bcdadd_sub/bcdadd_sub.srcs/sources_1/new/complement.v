`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/25/2026 08:58:10 PM
// Design Name:
// Module Name: complement
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module complement (
    X,
    Y
);
  parameter integer N = 4;
  input [N-1:0] X;
  output reg [N-1:0] Y;

  always @(X) Y = 9 - X;
endmodule
