`timescale 1ns / 1ns

module des_datapath(
    input wire clk,
    input wire regL_wen,
    input wire regR_wen,
    input wire [1:0] muxL_sel,
    input wire muxR_sel,
    input wire [63:0] din,
    input wire [47:0] round_key,
    output wire [63:0] dout
);


  // din_ip 为初始置换 IP 后的数据，result 为 16 轮后的左右半部组合。
  wire [63:0] din_ip,result;
  wire [31:0] regL_out,regR_out,next_R,regL_in,regR_in,P_out,SBOX_out;
  wire [47:0] E_out,XOR_out;
  wire [3:0] sbox0_out,sbox1_out,sbox2_out,sbox3_out,sbox4_out,sbox5_out,sbox6_out,sbox7_out;
  
  // 单轮 Feistel 电路被重复使用 16 次，通过寄存器保存每一轮的 L/R 结果。
  localparam [383:0] map_din_ip = {
    6'd6, 6'd14, 6'd22, 6'd30, 6'd38, 6'd46, 6'd54, 6'd62,
    6'd4, 6'd12, 6'd20, 6'd28, 6'd36, 6'd44, 6'd52, 6'd60,
    6'd2, 6'd10, 6'd18, 6'd26, 6'd34, 6'd42, 6'd50, 6'd58,
    6'd0, 6'd8, 6'd16, 6'd24, 6'd32, 6'd40, 6'd48, 6'd56,
    6'd7, 6'd15, 6'd23, 6'd31, 6'd39, 6'd47, 6'd55, 6'd63,
    6'd5, 6'd13, 6'd21, 6'd29, 6'd37, 6'd45, 6'd53, 6'd61,
    6'd3, 6'd11, 6'd19, 6'd27, 6'd35, 6'd43, 6'd51, 6'd59,
    6'd1, 6'd9, 6'd17, 6'd25, 6'd33, 6'd41, 6'd49, 6'd57
};
genvar bit_din_ip;
generate
    for (bit_din_ip = 0; bit_din_ip < 64; bit_din_ip = bit_din_ip + 1) begin : perm_din_ip
        localparam [5:0] SRC = map_din_ip[6 * (63 - bit_din_ip) +: 6];
        assign din_ip[63 - bit_din_ip] = din[SRC];
    end
endgenerate
  des_mux3_word muxL(muxL_sel,din_ip[63:32],regR_out,next_R,regL_in);// 选择左半部寄存器输入
  des_mux2_word muxR(muxR_sel,din_ip[31:0],next_R,regR_in); // 选择右半部寄存器输入
  des_word_register regL(clk,regL_wen,regL_in,regL_out);// 左 32 位寄存器，保存当前轮 L
  des_word_register regR(clk,regR_wen,regR_in,regR_out);// 右 32 位寄存器，保存当前轮 R
  localparam [287:0] map_E_out = {
    6'd0, 6'd31, 6'd30, 6'd29, 6'd28, 6'd27, 6'd28, 6'd27,
    6'd26, 6'd25, 6'd24, 6'd23, 6'd24, 6'd23, 6'd22, 6'd21,
    6'd20, 6'd19, 6'd20, 6'd19, 6'd18, 6'd17, 6'd16, 6'd15,
    6'd16, 6'd15, 6'd14, 6'd13, 6'd12, 6'd11, 6'd12, 6'd11,
    6'd10, 6'd9, 6'd8, 6'd7, 6'd8, 6'd7, 6'd6, 6'd5,
    6'd4, 6'd3, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0, 6'd31
};
genvar bit_E_out;
generate
    for (bit_E_out = 0; bit_E_out < 48; bit_E_out = bit_E_out + 1) begin : perm_E_out
        localparam [5:0] SRC = map_E_out[6 * (47 - bit_E_out) +: 6];
        assign E_out[47 - bit_E_out] = regR_out[SRC];
    end
endgenerate
  // E 扩展结果与当前轮密钥异或，作为 8 个 S 盒的输入。
  assign XOR_out=E_out^round_key;
  des_sbox_1 sbox0(XOR_out[47:42],sbox0_out);// S 盒非线性替换
  des_sbox_2 sbox1(XOR_out[41:36],sbox1_out);
  des_sbox_3 sbox2(XOR_out[35:30],sbox2_out);
  des_sbox_4 sbox3(XOR_out[29:24],sbox3_out);
  des_sbox_5 sbox4(XOR_out[23:18],sbox4_out);
  des_sbox_6 sbox5(XOR_out[17:12],sbox5_out);
  des_sbox_7 sbox6(XOR_out[11:6],sbox6_out);
  des_sbox_8 sbox7(XOR_out[5:0],sbox7_out);
  // 8 个 S 盒各输出 4 位，拼成 32 位。
  assign SBOX_out={sbox0_out,sbox1_out,sbox2_out,sbox3_out,sbox4_out,sbox5_out,sbox6_out,sbox7_out};
  localparam [191:0] map_P_out = {
    6'd16, 6'd25, 6'd12, 6'd11, 6'd3, 6'd20, 6'd4, 6'd15,
    6'd31, 6'd17, 6'd9, 6'd6, 6'd27, 6'd14, 6'd1, 6'd22,
    6'd30, 6'd24, 6'd8, 6'd18, 6'd0, 6'd5, 6'd29, 6'd23,
    6'd13, 6'd19, 6'd2, 6'd26, 6'd10, 6'd21, 6'd28, 6'd7
};
genvar bit_P_out;
generate
    for (bit_P_out = 0; bit_P_out < 32; bit_P_out = bit_P_out + 1) begin : perm_P_out
        localparam [5:0] SRC = map_P_out[6 * (31 - bit_P_out) +: 6];
        assign P_out[31 - bit_P_out] = SBOX_out[SRC];
    end
endgenerate
  // Feistel 轮更新：下一轮右半部 = 当前左半部 xor F(当前右半部, 轮密钥)。
  assign next_R=regL_out^P_out;
  assign result={regL_out,regR_out};
  localparam [383:0] map_dout = {
    6'd24, 6'd56, 6'd16, 6'd48, 6'd8, 6'd40, 6'd0, 6'd32,
    6'd25, 6'd57, 6'd17, 6'd49, 6'd9, 6'd41, 6'd1, 6'd33,
    6'd26, 6'd58, 6'd18, 6'd50, 6'd10, 6'd42, 6'd2, 6'd34,
    6'd27, 6'd59, 6'd19, 6'd51, 6'd11, 6'd43, 6'd3, 6'd35,
    6'd28, 6'd60, 6'd20, 6'd52, 6'd12, 6'd44, 6'd4, 6'd36,
    6'd29, 6'd61, 6'd21, 6'd53, 6'd13, 6'd45, 6'd5, 6'd37,
    6'd30, 6'd62, 6'd22, 6'd54, 6'd14, 6'd46, 6'd6, 6'd38,
    6'd31, 6'd63, 6'd23, 6'd55, 6'd15, 6'd47, 6'd7, 6'd39
};
genvar bit_dout;
generate
    for (bit_dout = 0; bit_dout < 64; bit_dout = bit_dout + 1) begin : perm_dout
        localparam [5:0] SRC = map_dout[6 * (63 - bit_dout) +: 6];
        assign dout[63 - bit_dout] = result[SRC];
    end
endgenerate
  
endmodule
