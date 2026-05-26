module decn (
    W,
    E,
    Y
);
  parameter integer N = 4;
  input [N-1:0] W;
  input E;
  output reg [2**N-1:0] Y;
  integer i;

  always @(W, E) for (i = 0; i < 2 ** N; i = i + 1) Y[i] = E & (W == i);

endmodule

