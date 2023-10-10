module sha256_S0 (
          input wire [31:0] x,
          output wire [31:0] S0
          );

      assign S0 = ({x[1:0], x[31:2]} ^ {x[12:0], x[31:13]} ^ {x[21:0], x[31:22]});

      endmodule