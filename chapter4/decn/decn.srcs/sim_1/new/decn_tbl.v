`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2026 09:15:17 AM
// Design Name: 
// Module Name: decn_tbl
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


module decn_tbl(
    Y
    );
    output [0:15] Y;
    decn tut(4'b1101, 1'b1, Y); 
endmodule
