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
  reg [N-1:0] Bmux;
  wire [N-1:0] Bnot;
  input AddSub;
  output [N-1:0] D;
  output Cout;
  genvar i;

  assign C[0] = AddSub;
  assign Cout = C[N/4];
  generate
    for (i = 0; i < N; i = i + 4) begin : g_compliment
      complement stage (
          .X(B[i+3-:4]),
          .Y(Bnot[i+3-:4])
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
