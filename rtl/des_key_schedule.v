`timescale 1ns / 1ns

module des_key_schedule(
    input wire clk,
    input wire reg0_wen,
    input wire reg1_wen,
    input wire reg2_wen,
    input wire [2:0] mux_sel,
    input wire [55:0] pc1_key,
    output wire [47:0] round_key
);


  // reg0 保存初始 C0/D0，reg1 保存当前轮 C/D，reg2 保存最终 C16/D16 供解密反向使用。
  wire [27:0] reg0_L_out,reg0_R_out,reg1_L_out,reg1_R_out,reg2_L_out,reg2_R_out,reg1_L_in,reg1_R_in;
  
  // PC-1 已在顶层完成，这里把 56 位结果拆为左半部 C0 和右半部 D0。
  des_key_register reg0_L(clk,reg0_wen,pc1_key[55:28],reg0_L_out);
  des_key_register reg0_R(clk,reg0_wen,pc1_key[27:0],reg0_R_out);
  
  // mux_sel 含义：
  // 0：由 C0/D0 左循环移位 1 位，产生第 1 轮密钥状态。
  // 1：由当前 C/D 左循环移位 1 位，对应 DES 第 2、9、16 轮等单移位轮。
  // 2：由当前 C/D 左循环移位 2 位，对应 DES 其余双移位轮。
  // 3：直接装载保存的 C16/D16，作为解密第一轮的起点。
  // 4：由当前 C/D 右循环移位 1 位，用于解密轮密钥倒序生成。
  // 5：由当前 C/D 右循环移位 2 位，用于解密轮密钥倒序生成。
  des_mux6_key mux_L(mux_sel,{reg0_L_out[26:0],reg0_L_out[27]},{reg1_L_out[26:0],reg1_L_out[27]},{reg1_L_out[25:0],reg1_L_out[27:26]},reg2_L_out,{reg1_L_out[0],reg1_L_out[27:1]},{reg1_L_out[1:0],reg1_L_out[27:2]},reg1_L_in);
  des_mux6_key mux_R(mux_sel,{reg0_R_out[26:0],reg0_R_out[27]},{reg1_R_out[26:0],reg1_R_out[27]},{reg1_R_out[25:0],reg1_R_out[27:26]},reg2_R_out,{reg1_R_out[0],reg1_R_out[27:1]},{reg1_R_out[1:0],reg1_R_out[27:2]},reg1_R_in);
  
  // reg1 在每一轮更新为本轮 C/D，round_key 直接由 reg1 当前值经 PC-2 组合产生。
  des_key_register reg1_L(clk,reg1_wen,reg1_L_in,reg1_L_out);
  des_key_register reg1_R(clk,reg1_wen,reg1_R_in,reg1_R_out);
  
  // 密钥扩展完成第 16 轮时保存 C16/D16，后续解密可从末轮密钥状态倒推。
  des_key_register reg2_L(clk,reg2_wen,reg1_L_in,reg2_L_out);
  des_key_register reg2_R(clk,reg2_wen,reg1_R_in,reg2_R_out);
  
  // PC-2 压缩置换：从当前 56 位 C/D 中选出并重排 48 位，形成本轮子密钥。
  wire [55:0] key_halves = {reg1_L_out, reg1_R_out};
localparam [287:0] map_round_key = {
    6'd42, 6'd39, 6'd45, 6'd32, 6'd55, 6'd51, 6'd53, 6'd28,
    6'd41, 6'd50, 6'd35, 6'd46, 6'd33, 6'd37, 6'd44, 6'd52,
    6'd30, 6'd48, 6'd40, 6'd49, 6'd29, 6'd36, 6'd43, 6'd54,
    6'd15, 6'd4, 6'd25, 6'd19, 6'd9, 6'd1, 6'd26, 6'd16,
    6'd5, 6'd11, 6'd23, 6'd8, 6'd12, 6'd7, 6'd17, 6'd0,
    6'd22, 6'd3, 6'd10, 6'd14, 6'd6, 6'd20, 6'd27, 6'd24
};
genvar bit_round_key;
generate
    for (bit_round_key = 0; bit_round_key < 48; bit_round_key = bit_round_key + 1) begin : perm_round_key
        localparam [5:0] SRC = map_round_key[6 * (47 - bit_round_key) +: 6];
        assign round_key[47 - bit_round_key] = key_halves[SRC];
    end
endgenerate
  
endmodule
