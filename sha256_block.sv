module sha256_block (
    input clk, rst,
    input [23:0] M_in,
    input input_valid,
    output [255:0] H_out,
    output output_valid
    );
reg [6:0] round;
wire [31:0] a_in = 32'h6A09E667, b_in = 32'hBB67AE85, c_in = 32'h3C6EF372, d_in = 32'hA54FF53A;
wire [31:0] e_in = 32'h510E527F, f_in = 32'h9B05688C, g_in = 32'h1F83D9AB, h_in = 32'h5BE0CD19;
reg [31:0] a_q, b_q, c_q, d_q, e_q, f_q, g_q, h_q;
wire [31:0] a_d, b_d, c_d, d_d, e_d, f_d, g_d, h_d;
wire [31:0] W_tm2, W_tm15, s1_Wtm2, s0_Wtm15, Wj, Kj;
wire [511:0] M_in_padder;

assign H_out = {
    a_in + a_q, b_in + b_q, c_in + c_q, d_in + d_q, e_in + e_q, f_in + f_q, g_in + g_q, h_in + h_q
};
assign output_valid = round == 64;

always @(posedge clk)
begin
    if (input_valid) begin
        a_q <= a_in; b_q <= b_in; c_q <= c_in; d_q <= d_in;
        e_q <= e_in; f_q <= f_in; g_q <= g_in; h_q <= h_in;
        round <= 0;
    end else begin
        a_q <= a_d; b_q <= b_d; c_q <= c_d; d_q <= d_d;
        e_q <= e_d; f_q <= f_d; g_q <= g_d; h_q <= h_d;
        round <= round + 1;
    end
end

sha256_round sha256_round (
    .Kj(Kj), .Wj(Wj),
    .a_in(a_q), .b_in(b_q), .c_in(c_q), .d_in(d_q),
    .e_in(e_q), .f_in(f_q), .g_in(g_q), .h_in(h_q),
    .a_out(a_d), .b_out(b_d), .c_out(c_d), .d_out(d_d),
    .e_out(e_d), .f_out(f_d), .g_out(g_d), .h_out(h_d)
);

sha256_s0_1 sha256_s0_1 (.x(W_tm15), .s0(s0_Wtm15));
sha256_s1_1 sha256_s1_1 (.x(W_tm2), .s1(s1_Wtm2));

W_machine #(.WORDSIZE(32)) W_machine (
    .clk(clk),
    .M(M_in_padder), .M_valid(input_valid),
    .W_tm2(W_tm2), .W_tm15(W_tm15),
    .s1_Wtm2(s1_Wtm2), .s0_Wtm15(s0_Wtm15),
    .W(Wj)
);

sha256_K_machine sha256_K_machine (
    .clk(clk), .rst(input_valid), .K(Kj)
);

sha_padder #(.MSG_SIZE(24), .PADDED_SIZE(512)) sha_padder (
    .message(M_in), .padded(M_in_padder)
);

endmodule
