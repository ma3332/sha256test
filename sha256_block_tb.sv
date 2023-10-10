module sha256_block_tb;

reg input_valid = 0;

wire output_valid_256;
wire [255:0] H_out_256;
sha256_block sha256_block (
    .clk(clk), .rst(rst), .M_in(M_sha256_abc),
    .input_valid(input_valid),
    .H_out(H_out_256),
    .output_valid(output_valid_256)
);


// the "abc" test vector, padded
wire [23:0] M_sha256_abc;
assign M_sha256_abc = 24'h616263;

// driver

reg [31:0] ticks = 0;
reg clk = 1'b0;
reg rst = 1'b0;

initial begin
  $display("starting");
  tick;
  input_valid = 1'b1;
  tick;
  input_valid = 1'b0;
  repeat (90) begin
    tick;
  end
  $display("done");
  $finish;
end

task tick;
begin
  #1;
  ticks = ticks + 1;
  clk = 1;
  #1;
  clk = 0;
end
endtask

endmodule