module sha256_S1 (
          input wire [31:0] x,
          output wire [31:0] S1
          );

      assign S1 = ({x[5:0], x[31:6]} ^ {x[10:0], x[31:11]} ^ {x[24:0], x[31:25]});

      endmodule