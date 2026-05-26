module bcd (
    A,
    B,
    D,
    AddSub,
    Cout
);
  parameter integer N = 16;
  input [N-1:0] A, B;
  wire [N/4:0] C;
  reg [N-1:0] Bmux, Bnot;
  input AddSub;
  output [N-1:0] D;
  output Cout;
  genvar i;

  assign C[0] = AddSub;
  assign Cout = C[n/4];
  generate
    for (i = 0; i < N; i = i + 4) begin : g_compliment
      compliment stage (
          .X(B[i:i+3]),
          .Y(Bnot[i:i+3])
      );
    end
  endgenerate

  always @(B, Bnot, AddSub)
    if (!AddSub) Bmux = B;
    else Bmux = Bnot;

  generate
    for (i = 0; i < N; i = i + 4) begin : g_bcdadd
      bcdadd stage (
          A[i+3-:4],
          Bmux[i+3-:4],
          C[i/4],
          D[i+3-:4],
          C[i/4+1]
      );
    end
  endgenerate
endmodule
