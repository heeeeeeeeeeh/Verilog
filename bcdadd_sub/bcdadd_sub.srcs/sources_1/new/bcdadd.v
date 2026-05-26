module bcdadd (
    A,
    B,
    Cin,
    S,
    Cout
);
    input [3:0] A, B;
    input Cin;
    output reg [3:0] S;
    reg [4:0] Z;
    output reg Cout;
    
    always @(A, B, Cin) begin
        Z = A + B + Cin;
        if (Z < 10)     {Cout, S} = Z;
        else            {Cout, S} = Z + 6;
    end
endmodule
