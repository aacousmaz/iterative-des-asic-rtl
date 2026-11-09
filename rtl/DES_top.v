`timescale 1ns / 1ns
module DES_top(
    input wire clk,
    input wire rst,
    input wire load,
    input wire keyexp_start,
    input wire encry_start,
    input wire decry_start,
    input wire [31:0] din,
    output wire [63:0] dout,
    output wire [1:0] state
);

  
  
  // key_ptext_ctext 由两个 32 位输入拼成，可作为密钥、明文或密文使用。
  wire [63:0] key_ptext_ctext;
  // round_key 为当前轮使用的 48 位 DES 子密钥。
  wire [47:0] round_key;
  wire reg0_wen,reg1_wen,reg2_wen,regL_wen,regR_wen,muxR_sel;
  wire [2:0] mux_sel;
  // pc1_key 为 DES PC-1 置换后的 56 位密钥，去除了 8 位奇偶校验位。
  wire [55:0] pc1_key;
  wire [1:0] muxL_sel;


des_input_buffer des_input_buffer(clk,load,din,key_ptext_ctext);
// PC-1 初始密钥置换：从 64 位原始密钥中选出 56 位有效密钥。
localparam [335:0] map_pc1_key = {
    6'd7, 6'd15, 6'd23, 6'd31, 6'd39, 6'd47, 6'd55, 6'd63,
    6'd6, 6'd14, 6'd22, 6'd30, 6'd38, 6'd46, 6'd54, 6'd62,
    6'd5, 6'd13, 6'd21, 6'd29, 6'd37, 6'd45, 6'd53, 6'd61,
    6'd4, 6'd12, 6'd20, 6'd28, 6'd1, 6'd9, 6'd17, 6'd25,
    6'd33, 6'd41, 6'd49, 6'd57, 6'd2, 6'd10, 6'd18, 6'd26,
    6'd34, 6'd42, 6'd50, 6'd58, 6'd3, 6'd11, 6'd19, 6'd27,
    6'd35, 6'd43, 6'd51, 6'd59, 6'd36, 6'd44, 6'd52, 6'd60
};
genvar bit_pc1_key;
generate
    for (bit_pc1_key = 0; bit_pc1_key < 56; bit_pc1_key = bit_pc1_key + 1) begin : perm_pc1_key
        localparam [5:0] SRC = map_pc1_key[6 * (55 - bit_pc1_key) +: 6];
        assign pc1_key[55 - bit_pc1_key] = key_ptext_ctext[SRC];
    end
endgenerate
// des_key_schedule 产生每一轮的 48 位子密钥。
des_key_schedule des_key_schedule(clk,reg0_wen,reg1_wen,reg2_wen,mux_sel,pc1_key,round_key);
// des_datapath 复用同一套 Feistel 轮函数完成加密和解密。
des_datapath des_datapath(clk,regL_wen,regR_wen,muxL_sel,muxR_sel,key_ptext_ctext,round_key,dout);
// des_controller 产生整个系统的时序控制信号。
des_controller des_controller(clk,rst,keyexp_start,encry_start,decry_start,reg0_wen,reg1_wen,reg2_wen,mux_sel,regL_wen,regR_wen,muxL_sel,muxR_sel,state);

endmodule
