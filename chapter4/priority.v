module encode (
    W,
    Y,
    Z
);
  parameter int N = 4;
  input [N-1:0] W;
  output reg [N-1:0] Y;
  output reg Z;

  always @(N) begin
    Y = 0;
    Z = 0;
    for (int i = N - 1; i >= 0; i--) begin
      if (W[i]) begin
        Y = i;
        Z = 1;
        break;
      end
    end
  end
endmodule
