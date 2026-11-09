`timescale 1ns / 1ns
module DES_top_tb;

  wire [63:0] dout;
  wire [1:0] state;
  reg clk,rst,load,keyexp_start,encry_start,decry_start;
  reg [31:0] din;
DES_top DES_top(clk,rst,load,keyexp_start,encry_start,decry_start,din,dout,state);
// 备用实例化写法：DES_top DES_top(din,dout,clk,rst,load,keyexp_start,encry_start,decry_start,);
// 时钟产生：周期 10 ns。				   
initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
end
	
initial 
	begin		     	
		    // 初始状态下不装载数据，也不启动任何运算。
		    rst=1;
		    load=0;
		    keyexp_start=0;
		    encry_start=0;
		    decry_start=0;		    		    
		#2  rst=0;		// 测试低有效复位
		#20 rst=1;
		    load=1;// 装载密钥低 32 位
		    //din=32'h7793_84db;
		    din=32'h89abcdef;
		                             
  		#10 load=1;// 装载密钥高 32 位
		    //din=32'h7139_9aed;
		  		din=32'h01234567;
		  				     
		#10 load=0;
		    keyexp_start=1;// 启动密钥扩展
		#10 keyexp_start=0;    
		
		#170 load=1;// 装载明文低 32 位
		     //din=32'h7574_6572;
		     din=32'h89abcde7;                         
  		#10 load=1;// 装载明文高 32 位
		    //din=32'h636f_6d70;
		    din=32'h01234567;
		
    #10 load=0;
		    encry_start=1;// 启动加密
		#10 encry_start=0;
    
    #180 load=1;// 装载密文低 32 位
		     din=32'h6a5ed31d;
		#10 load=1;// 装载密文高 32 位
		    din=32'hc9574425;
		
    #10 load=0;
		    decry_start=1;// 启动解密
		#10 decry_start=0;
          		    		
		#180 $finish;		
	end

// 以下信号用于测试平台中的 DES 软件参考模型，方便和硬件模块输出进行比对。
reg [27:0] C0,D0,C1,D1,C2,D2,C3,D3,C4,D4,C5,D5,C6,D6,C7,D7,C8,D8,C9,D9,C10,D10,C11,D11,C12,D12,C13,D13,C14,D14,C15,D15,C16,D16;
reg [1:56] E1,E2,E3,E4,E5,E6,E7,E8,E9,E10,E11,E12,E13,E14,E15,E16;
reg [47:0] ROUND1_KEY,ROUND2_KEY,ROUND3_KEY,ROUND4_KEY,ROUND5_KEY,ROUND6_KEY,ROUND7_KEY,ROUND8_KEY,ROUND9_KEY,ROUND10_KEY,
           ROUND11_KEY,ROUND12_KEY,ROUND13_KEY,ROUND14_KEY,ROUND15_KEY,ROUND16_KEY;
reg [1:64] PTEXT,IP;
reg [1:32] L0,R0,L1,R1,L2,R2,L3,R3,L4,R4,L5,R5,L6,R6,L7,R7,L8,R8,L9,R9,L10,R10,L11,R11,L12,R12,L13,R13,L14,R14,L15,R15,L16,R16;
reg [1:48] XOR_1,XOR_2,XOR_3,XOR_4,XOR_5,XOR_6,XOR_7,XOR_8,XOR_9,XOR_10,XOR_11,XOR_12,XOR_13,XOR_14,XOR_15,XOR_16;
reg [1:32] SBOX_1,SBOX_2,SBOX_3,SBOX_4,SBOX_5,SBOX_6,SBOX_7,SBOX_8,SBOX_9,SBOX_10,SBOX_11,SBOX_12,SBOX_13,SBOX_14,SBOX_15,SBOX_16;
reg [1:64] ROUND16_RESULT,CTEXT;

// 测试平台参考 S1 盒：6 位输入查表得到 4 位输出。
function [3:0] sbox1;
  input[5:0] in;
  reg [3:0] out;
    begin
      case(in)
          6'h00: out=4'd14;
          6'h01: out=4'd0;
          6'h02: out=4'd4;
          6'h03: out=4'd15;
          6'h04: out=4'd13;
          6'h05: out=4'd7;
          6'h06: out=4'd1;
          6'h07: out=4'd4;
          6'h08: out=4'd2;
          6'h09: out=4'd14;
          6'h0a: out=4'd15;
          6'h0b: out=4'd2;
          6'h0c: out=4'd11;
          6'h0d: out=4'd13;
          6'h0e: out=4'd8;
          6'h0f: out=4'd1;
          6'h10: out=4'd3;
          6'h11: out=4'd10;
          6'h12: out=4'd10;
          6'h13: out=4'd6;
          6'h14: out=4'd6;
          6'h15: out=4'd12;
          6'h16: out=4'd12;
          6'h17: out=4'd11;
          6'h18: out=4'd5;
          6'h19: out=4'd9;
          6'h1a: out=4'd9;
          6'h1b: out=4'd5;
          6'h1c: out=4'd0;
          6'h1d: out=4'd3;
          6'h1e: out=4'd7;
          6'h1f: out=4'd8;
          6'h20: out=4'd4;
          6'h21: out=4'd15;
          6'h22: out=4'd1;
          6'h23: out=4'd12;
          6'h24: out=4'd14;
          6'h25: out=4'd8;
          6'h26: out=4'd8;
          6'h27: out=4'd2;
          6'h28: out=4'd13;
          6'h29: out=4'd4;
          6'h2a: out=4'd6;
          6'h2b: out=4'd9;
          6'h2c: out=4'd2;
          6'h2d: out=4'd1;
          6'h2e: out=4'd11;
          6'h2f: out=4'd7;
          6'h30: out=4'd15;
          6'h31: out=4'd5;
          6'h32: out=4'd12;
          6'h33: out=4'd11;
          6'h34: out=4'd9;
          6'h35: out=4'd3;
          6'h36: out=4'd7;
          6'h37: out=4'd14;
          6'h38: out=4'd3;
          6'h39: out=4'd10;
          6'h3a: out=4'd10;
          6'h3b: out=4'd0;
          6'h3c: out=4'd5;
          6'h3d: out=4'd6;
          6'h3e: out=4'd0;
          6'h3f: out=4'd13;
          default: out=4'd0;
      endcase
      sbox1=out;
    end   
endfunction

// 测试平台参考 S2 盒。
function [3:0] sbox2;
  input[5:0] in;
  reg [3:0] out;
    begin
      case(in)
          6'h00: out=4'd15;
          6'h01: out=4'd3;
          6'h02: out=4'd1;
          6'h03: out=4'd13;
          6'h04: out=4'd8;
          6'h05: out=4'd4;
          6'h06: out=4'd14;
          6'h07: out=4'd7;
          6'h08: out=4'd6;
          6'h09: out=4'd15;
          6'h0a: out=4'd11;
          6'h0b: out=4'd2;
          6'h0c: out=4'd3;
          6'h0d: out=4'd8;
          6'h0e: out=4'd4;
          6'h0f: out=4'd14;
          
          6'h10: out=4'd9;
          6'h11: out=4'd12;
          6'h12: out=4'd7;
          6'h13: out=4'd0;
          6'h14: out=4'd2;
          6'h15: out=4'd1;
          6'h16: out=4'd13;
          6'h17: out=4'd10;
          6'h18: out=4'd12;
          6'h19: out=4'd6;
          6'h1a: out=4'd0;
          6'h1b: out=4'd9;
          6'h1c: out=4'd5;
          6'h1d: out=4'd11;
          6'h1e: out=4'd10;
          6'h1f: out=4'd5;
          
          6'h20: out=4'd0;
          6'h21: out=4'd13;
          6'h22: out=4'd14;
          6'h23: out=4'd8;
          6'h24: out=4'd7;
          6'h25: out=4'd10;
          6'h26: out=4'd11;
          6'h27: out=4'd1;
          6'h28: out=4'd10;
          6'h29: out=4'd3;
          6'h2a: out=4'd4;
          6'h2b: out=4'd15;
          6'h2c: out=4'd13;
          6'h2d: out=4'd4;
          6'h2e: out=4'd1;
          6'h2f: out=4'd2;
          
          6'h30: out=4'd5;
          6'h31: out=4'd11;
          6'h32: out=4'd8;
          6'h33: out=4'd6;
          6'h34: out=4'd12;
          6'h35: out=4'd7;
          6'h36: out=4'd6;
          6'h37: out=4'd12;
          6'h38: out=4'd9;
          6'h39: out=4'd0;
          6'h3a: out=4'd3;
          6'h3b: out=4'd5;
          6'h3c: out=4'd2;
          6'h3d: out=4'd14;
          6'h3e: out=4'd15;
          6'h3f: out=4'd9;
          default: out=4'd0;
      endcase
      sbox2=out;
    end   
endfunction

// 测试平台参考 S3 盒。
function [3:0] sbox3;
  input[5:0] in;
  reg [3:0] out;
    begin
      case(in)
          6'h00: out=4'd10;
          6'h01: out=4'd13;
          6'h02: out=4'd0;
          6'h03: out=4'd7;
          6'h04: out=4'd9;
          6'h05: out=4'd0;
          6'h06: out=4'd14;
          6'h07: out=4'd9;
          6'h08: out=4'd6;
          6'h09: out=4'd3;
          6'h0a: out=4'd3;
          6'h0b: out=4'd4;
          6'h0c: out=4'd15;
          6'h0d: out=4'd6;
          6'h0e: out=4'd5;
          6'h0f: out=4'd10;
          
          6'h10: out=4'd1;
          6'h11: out=4'd2;
          6'h12: out=4'd13;
          6'h13: out=4'd8;
          6'h14: out=4'd12;
          6'h15: out=4'd5;
          6'h16: out=4'd7;
          6'h17: out=4'd14;
          6'h18: out=4'd11;
          6'h19: out=4'd12;
          6'h1a: out=4'd4;
          6'h1b: out=4'd11;
          6'h1c: out=4'd2;
          6'h1d: out=4'd15;
          6'h1e: out=4'd8;
          6'h1f: out=4'd1;
          
          6'h20: out=4'd13;
          6'h21: out=4'd1;
          6'h22: out=4'd6;
          6'h23: out=4'd10;
          6'h24: out=4'd4;
          6'h25: out=4'd13;
          6'h26: out=4'd9;
          6'h27: out=4'd0;
          6'h28: out=4'd8;
          6'h29: out=4'd6;
          6'h2a: out=4'd15;
          6'h2b: out=4'd9;
          6'h2c: out=4'd3;
          6'h2d: out=4'd8;
          6'h2e: out=4'd0;
          6'h2f: out=4'd7;
          
          6'h30: out=4'd11;
          6'h31: out=4'd4;
          6'h32: out=4'd1;
          6'h33: out=4'd15;
          6'h34: out=4'd2;
          6'h35: out=4'd14;
          6'h36: out=4'd12;
          6'h37: out=4'd3;
          6'h38: out=4'd5;
          6'h39: out=4'd11;
          6'h3a: out=4'd10;
          6'h3b: out=4'd5;
          6'h3c: out=4'd14;
          6'h3d: out=4'd2;
          6'h3e: out=4'd7;
          6'h3f: out=4'd12;
          default: out=4'd0;
      endcase
      sbox3=out;
  end   
endfunction

// 测试平台参考 S4 盒。
function [3:0] sbox4;
  input[5:0] in;
  reg [3:0] out;
    begin
      case(in)
          6'h00: out=4'd7;
          6'h01: out=4'd13;
          6'h02: out=4'd13;
          6'h03: out=4'd8;
          6'h04: out=4'd14;
          6'h05: out=4'd11;
          6'h06: out=4'd3;
          6'h07: out=4'd5;
          6'h08: out=4'd0;
          6'h09: out=4'd6;
          6'h0a: out=4'd6;
          6'h0b: out=4'd15;
          6'h0c: out=4'd9;
          6'h0d: out=4'd0;
          6'h0e: out=4'd10;
          6'h0f: out=4'd3;
          
          6'h10: out=4'd1;
          6'h11: out=4'd4;
          6'h12: out=4'd2;
          6'h13: out=4'd7;
          6'h14: out=4'd8;
          6'h15: out=4'd2;
          6'h16: out=4'd5;
          6'h17: out=4'd12;
          6'h18: out=4'd11;
          6'h19: out=4'd1;
          6'h1a: out=4'd12;
          6'h1b: out=4'd10;
          6'h1c: out=4'd4;
          6'h1d: out=4'd14;
          6'h1e: out=4'd15;
          6'h1f: out=4'd9;
          
          6'h20: out=4'd10;
          6'h21: out=4'd3;
          6'h22: out=4'd6;
          6'h23: out=4'd15;
          6'h24: out=4'd9;
          6'h25: out=4'd0;
          6'h26: out=4'd0;
          6'h27: out=4'd6;
          6'h28: out=4'd12;
          6'h29: out=4'd10;
          6'h2a: out=4'd11;
          6'h2b: out=4'd1;
          6'h2c: out=4'd7;
          6'h2d: out=4'd3;
          6'h2e: out=4'd13;
          6'h2f: out=4'd8;
          
          6'h30: out=4'd15;
          6'h31: out=4'd9;
          6'h32: out=4'd1;
          6'h33: out=4'd4;
          6'h34: out=4'd3;
          6'h35: out=4'd5;
          6'h36: out=4'd14;
          6'h37: out=4'd11;
          6'h38: out=4'd5;
          6'h39: out=4'd12;
          6'h3a: out=4'd2;
          6'h3b: out=4'd7;
          6'h3c: out=4'd8;
          6'h3d: out=4'd2;
          6'h3e: out=4'd4;
          6'h3f: out=4'd14;
          default: out=4'd0;
      endcase
      sbox4=out;
    end   
endfunction

// 测试平台参考 S5 盒。
function [3:0] sbox5;
  input[5:0] in;
  reg [3:0] out;
    begin
      case(in)
          6'h00: out=4'd2;
          6'h01: out=4'd14;
          6'h02: out=4'd12;
          6'h03: out=4'd11;
          6'h04: out=4'd4;
          6'h05: out=4'd2;
          6'h06: out=4'd1;
          6'h07: out=4'd12;
          6'h08: out=4'd7;
          6'h09: out=4'd4;
          6'h0a: out=4'd10;
          6'h0b: out=4'd7;
          6'h0c: out=4'd11;
          6'h0d: out=4'd13;
          6'h0e: out=4'd6;
          6'h0f: out=4'd1;
          
          6'h10: out=4'd8;
          6'h11: out=4'd5;
          6'h12: out=4'd5;
          6'h13: out=4'd0;
          6'h14: out=4'd3;
          6'h15: out=4'd15;
          6'h16: out=4'd15;
          6'h17: out=4'd0;
          6'h18: out=4'd13;
          6'h19: out=4'd3;
          6'h1a: out=4'd0;
          6'h1b: out=4'd9;
          6'h1c: out=4'd14;
          6'h1d: out=4'd8;
          6'h1e: out=4'd9;
          6'h1f: out=4'd6;
          
          6'h20: out=4'd4;
          6'h21: out=4'd11;
          6'h22: out=4'd2;
          6'h23: out=4'd8;
          6'h24: out=4'd1;
          6'h25: out=4'd12;
          6'h26: out=4'd11;
          6'h27: out=4'd7;
          6'h28: out=4'd10;
          6'h29: out=4'd1;
          6'h2a: out=4'd13;
          6'h2b: out=4'd14;
          6'h2c: out=4'd7;
          6'h2d: out=4'd2;
          6'h2e: out=4'd8;
          6'h2f: out=4'd13;
          
          6'h30: out=4'd15;
          6'h31: out=4'd6;
          6'h32: out=4'd9;
          6'h33: out=4'd15;
          6'h34: out=4'd12;
          6'h35: out=4'd0;
          6'h36: out=4'd5;
          6'h37: out=4'd9;
          6'h38: out=4'd6;
          6'h39: out=4'd10;
          6'h3a: out=4'd3;
          6'h3b: out=4'd4;
          6'h3c: out=4'd0;
          6'h3d: out=4'd5;
          6'h3e: out=4'd14;
          6'h3f: out=4'd3;
          default: out=4'd0;
      endcase
      sbox5=out;
  end   
endfunction

// 测试平台参考 S6 盒。
function [3:0] sbox6;
  input[5:0] in;
  reg [3:0] out;
    begin
      case(in)
          6'h00: out=4'd12;
          6'h01: out=4'd10;
          6'h02: out=4'd1;
          6'h03: out=4'd5;
          6'h04: out=4'd10;
          6'h05: out=4'd4;
          6'h06: out=4'd15;
          6'h07: out=4'd2;
          6'h08: out=4'd9;
          6'h09: out=4'd7;
          6'h0a: out=4'd2;
          6'h0b: out=4'd12;
          6'h0c: out=4'd6;
          6'h0d: out=4'd9;
          6'h0e: out=4'd8;
          6'h0f: out=4'd5;
          
          6'h10: out=4'd0;
          6'h11: out=4'd6;
          6'h12: out=4'd13;
          6'h13: out=4'd1;
          6'h14: out=4'd3;
          6'h15: out=4'd13;
          6'h16: out=4'd4;
          6'h17: out=4'd14;
          6'h18: out=4'd14;
          6'h19: out=4'd0;
          6'h1a: out=4'd7;
          6'h1b: out=4'd11;
          6'h1c: out=4'd5;
          6'h1d: out=4'd3;
          6'h1e: out=4'd11;
          6'h1f: out=4'd8;
          
          6'h20: out=4'd9;
          6'h21: out=4'd4;
          6'h22: out=4'd14;
          6'h23: out=4'd3;
          6'h24: out=4'd15;
          6'h25: out=4'd2;
          6'h26: out=4'd5;
          6'h27: out=4'd12;
          6'h28: out=4'd2;
          6'h29: out=4'd9;
          6'h2a: out=4'd8;
          6'h2b: out=4'd5;
          6'h2c: out=4'd12;
          6'h2d: out=4'd15;
          6'h2e: out=4'd3;
          6'h2f: out=4'd10;
          
          6'h30: out=4'd7;
          6'h31: out=4'd11;
          6'h32: out=4'd0;
          6'h33: out=4'd14;
          6'h34: out=4'd4;
          6'h35: out=4'd1;
          6'h36: out=4'd10;
          6'h37: out=4'd7;
          6'h38: out=4'd1;
          6'h39: out=4'd6;
          6'h3a: out=4'd13;
          6'h3b: out=4'd0;
          6'h3c: out=4'd11;
          6'h3d: out=4'd8;
          6'h3e: out=4'd6;
          6'h3f: out=4'd13;
          default: out=4'd0;
      endcase
      sbox6=out;
  end   
endfunction

// 测试平台参考 S7 盒。
function [3:0] sbox7;
  input[5:0] in;
  reg [3:0] out;
    begin
      case(in)
          6'h00: out=4'd4;
          6'h01: out=4'd13;
          6'h02: out=4'd11;
          6'h03: out=4'd0;
          6'h04: out=4'd2;
          6'h05: out=4'd11;
          6'h06: out=4'd14;
          6'h07: out=4'd7;
          6'h08: out=4'd15;
          6'h09: out=4'd4;
          6'h0a: out=4'd0;
          6'h0b: out=4'd9;
          6'h0c: out=4'd8;
          6'h0d: out=4'd1;
          6'h0e: out=4'd13;
          6'h0f: out=4'd10;
          
          6'h10: out=4'd3;
          6'h11: out=4'd14;
          6'h12: out=4'd12;
          6'h13: out=4'd3;
          6'h14: out=4'd9;
          6'h15: out=4'd5;
          6'h16: out=4'd7;
          6'h17: out=4'd12;
          6'h18: out=4'd5;
          6'h19: out=4'd2;
          6'h1a: out=4'd10;
          6'h1b: out=4'd15;
          6'h1c: out=4'd6;
          6'h1d: out=4'd8;
          6'h1e: out=4'd1;
          6'h1f: out=4'd6;
          
          6'h20: out=4'd1;
          6'h21: out=4'd6;
          6'h22: out=4'd4;
          6'h23: out=4'd11;
          6'h24: out=4'd11;
          6'h25: out=4'd13;
          6'h26: out=4'd13;
          6'h27: out=4'd8;
          6'h28: out=4'd12;
          6'h29: out=4'd1;
          6'h2a: out=4'd3;
          6'h2b: out=4'd4;
          6'h2c: out=4'd7;
          6'h2d: out=4'd10;
          6'h2e: out=4'd14;
          6'h2f: out=4'd7;
          
          6'h30: out=4'd10;
          6'h31: out=4'd9;
          6'h32: out=4'd15;
          6'h33: out=4'd5;
          6'h34: out=4'd6;
          6'h35: out=4'd0;
          6'h36: out=4'd8;
          6'h37: out=4'd15;
          6'h38: out=4'd0;
          6'h39: out=4'd14;
          6'h3a: out=4'd5;
          6'h3b: out=4'd2;
          6'h3c: out=4'd9;
          6'h3d: out=4'd3;
          6'h3e: out=4'd2;
          6'h3f: out=4'd12;
          default: out=4'd0;
      endcase
      sbox7=out;
    end   
endfunction

// 测试平台参考 S8 盒。
function [3:0] sbox8;
  input[5:0] in;
  reg [3:0] out;
    begin
      case(in)
          6'h00: out=4'd13;
          6'h01: out=4'd1;
          6'h02: out=4'd2;
          6'h03: out=4'd15;
          6'h04: out=4'd8;
          6'h05: out=4'd13;
          6'h06: out=4'd4;
          6'h07: out=4'd8;
          6'h08: out=4'd6;
          6'h09: out=4'd10;
          6'h0a: out=4'd15;
          6'h0b: out=4'd3;
          6'h0c: out=4'd11;
          6'h0d: out=4'd7;
          6'h0e: out=4'd1;
          6'h0f: out=4'd4;
          
          6'h10: out=4'd10;
          6'h11: out=4'd12;
          6'h12: out=4'd9;
          6'h13: out=4'd5;
          6'h14: out=4'd3;
          6'h15: out=4'd6;
          6'h16: out=4'd14;
          6'h17: out=4'd11;
          6'h18: out=4'd5;
          6'h19: out=4'd0;
          6'h1a: out=4'd0;
          6'h1b: out=4'd14;
          6'h1c: out=4'd12;
          6'h1d: out=4'd9;
          6'h1e: out=4'd7;
          6'h1f: out=4'd2;
          
          6'h20: out=4'd7;
          6'h21: out=4'd2;
          6'h22: out=4'd11;
          6'h23: out=4'd1;
          6'h24: out=4'd4;
          6'h25: out=4'd14;
          6'h26: out=4'd1;
          6'h27: out=4'd7;
          6'h28: out=4'd9;
          6'h29: out=4'd4;
          6'h2a: out=4'd12;
          6'h2b: out=4'd10;
          6'h2c: out=4'd14;
          6'h2d: out=4'd8;
          6'h2e: out=4'd2;
          6'h2f: out=4'd13;
          
          6'h30: out=4'd0;
          6'h31: out=4'd15;
          6'h32: out=4'd6;
          6'h33: out=4'd12;
          6'h34: out=4'd10;
          6'h35: out=4'd9;
          6'h36: out=4'd13;
          6'h37: out=4'd0;
          6'h38: out=4'd15;
          6'h39: out=4'd3;
          6'h3a: out=4'd3;
          6'h3b: out=4'd5;
          6'h3c: out=4'd5;
          6'h3d: out=4'd6;
          6'h3e: out=4'd8;
          6'h3f: out=4'd11;
          default: out=4'd0;
      endcase
      sbox8=out; 
    end  
endfunction

// DES E 扩展函数：把 32 位 R 半部扩展为 48 位，供其与轮密钥异或。
function [1:48] EXP;
  input[1:32] in;
  EXP={in[32],in[1],in[2],in[3],in[4],in[5],
       in[4],in[5],in[6],in[7],in[8],in[9],
       in[8],in[9],in[10],in[11],in[12],in[13],
       in[12],in[13],in[14],in[15],in[16],in[17],
       in[16],in[17],in[18],in[19],in[20],in[21],
       in[20],in[21],in[22],in[23],in[24],in[25],
       in[24],in[25],in[26],in[27],in[28],in[29],
       in[28],in[29],in[30],in[31],in[32],in[1]};   
endfunction

// DES P 置换函数：对 S 盒输出的 32 位结果重新排列，增强扩散效果。
function [1:32] P;
  input[1:32] in;
  P={in[16],in[7],in[20],in[21],
     in[29],in[12],in[28],in[17],
     in[1],in[15],in[23],in[26],
     in[5],in[18],in[31],in[10],
     in[2],in[8],in[24],in[14],
     in[32],in[27],in[3],in[9],
     in[19],in[13],in[30],in[6],
     in[22],in[11],in[4],in[25]};   
endfunction

initial
  begin
    // 参考密钥扩展：根据 DES 轮移位表生成 16 组 48 位轮密钥。
    C0=28'hec991bb;
    D0=28'hb4588e7;
    C1={C0[26:0],C0[27]};
    D1={D0[26:0],D0[27]};
    E1={C1,D1};
    ROUND1_KEY ={E1[14],E1[17],E1[11],E1[24],E1[1],E1[5],
               E1[3],E1[28],E1[15],E1[6],E1[21],E1[10],
               E1[23],E1[19],E1[12],E1[4],E1[26],E1[8],
               E1[16],E1[7],E1[27],E1[20],E1[13],E1[2],
               E1[41],E1[52],E1[31],E1[37],E1[47],E1[55],
               E1[30],E1[40],E1[51],E1[45],E1[33],E1[48],
               E1[44],E1[49],E1[39],E1[56],E1[34],E1[53],
               E1[46],E1[42],E1[50],E1[36],E1[29],E1[32]};
    C2={C1[26:0],C1[27]};
    D2={D1[26:0],D1[27]};
    E2={C2,D2};
    ROUND2_KEY ={E2[14],E2[17],E2[11],E2[24],E2[1],E2[5],
               E2[3],E2[28],E2[15],E2[6],E2[21],E2[10],
               E2[23],E2[19],E2[12],E2[4],E2[26],E2[8],
               E2[16],E2[7],E2[27],E2[20],E2[13],E2[2],
               E2[41],E2[52],E2[31],E2[37],E2[47],E2[55],
               E2[30],E2[40],E2[51],E2[45],E2[33],E2[48],
               E2[44],E2[49],E2[39],E2[56],E2[34],E2[53],
               E2[46],E2[42],E2[50],E2[36],E2[29],E2[32]};
    C3={C2[25:0],C2[27:26]};
    D3={D2[25:0],D2[27:26]};
    E3={C3,D3};
    ROUND3_KEY ={E3[14],E3[17],E3[11],E3[24],E3[1],E3[5],
               E3[3],E3[28],E3[15],E3[6],E3[21],E3[10],
               E3[23],E3[19],E3[12],E3[4],E3[26],E3[8],
               E3[16],E3[7],E3[27],E3[20],E3[13],E3[2],
               E3[41],E3[52],E3[31],E3[37],E3[47],E3[55],
               E3[30],E3[40],E3[51],E3[45],E3[33],E3[48],
               E3[44],E3[49],E3[39],E3[56],E3[34],E3[53],
               E3[46],E3[42],E3[50],E3[36],E3[29],E3[32]};
    C4={C3[25:0],C3[27:26]};
    D4={D3[25:0],D3[27:26]};
    E4={C4,D4};
    ROUND4_KEY ={E4[14],E4[17],E4[11],E4[24],E4[1],E4[5],
               E4[3],E4[28],E4[15],E4[6],E4[21],E4[10],
               E4[23],E4[19],E4[12],E4[4],E4[26],E4[8],
               E4[16],E4[7],E4[27],E4[20],E4[13],E4[2],
               E4[41],E4[52],E4[31],E4[37],E4[47],E4[55],
               E4[30],E4[40],E4[51],E4[45],E4[33],E4[48],
               E4[44],E4[49],E4[39],E4[56],E4[34],E4[53],
               E4[46],E4[42],E4[50],E4[36],E4[29],E4[32]};
    C5={C4[25:0],C4[27:26]};
    D5={D4[25:0],D4[27:26]};
    E5={C5,D5};
    ROUND5_KEY ={E5[14],E5[17],E5[11],E5[24],E5[1],E5[5],
               E5[3],E5[28],E5[15],E5[6],E5[21],E5[10],
               E5[23],E5[19],E5[12],E5[4],E5[26],E5[8],
               E5[16],E5[7],E5[27],E5[20],E5[13],E5[2],
               E5[41],E5[52],E5[31],E5[37],E5[47],E5[55],
               E5[30],E5[40],E5[51],E5[45],E5[33],E5[48],
               E5[44],E5[49],E5[39],E5[56],E5[34],E5[53],
               E5[46],E5[42],E5[50],E5[36],E5[29],E5[32]};
    C6={C5[25:0],C5[27:26]};
    D6={D5[25:0],D5[27:26]};
    E6={C6,D6};
    ROUND6_KEY ={E6[14],E6[17],E6[11],E6[24],E6[1],E6[5],
               E6[3],E6[28],E6[15],E6[6],E6[21],E6[10],
               E6[23],E6[19],E6[12],E6[4],E6[26],E6[8],
               E6[16],E6[7],E6[27],E6[20],E6[13],E6[2],
               E6[41],E6[52],E6[31],E6[37],E6[47],E6[55],
               E6[30],E6[40],E6[51],E6[45],E6[33],E6[48],
               E6[44],E6[49],E6[39],E6[56],E6[34],E6[53],
               E6[46],E6[42],E6[50],E6[36],E6[29],E6[32]};
    C7={C6[25:0],C6[27:26]};
    D7={D6[25:0],D6[27:26]};
    E7={C7,D7};
    ROUND7_KEY ={E7[14],E7[17],E7[11],E7[24],E7[1],E7[5],
               E7[3],E7[28],E7[15],E7[6],E7[21],E7[10],
               E7[23],E7[19],E7[12],E7[4],E7[26],E7[8],
               E7[16],E7[7],E7[27],E7[20],E7[13],E7[2],
               E7[41],E7[52],E7[31],E7[37],E7[47],E7[55],
               E7[30],E7[40],E7[51],E7[45],E7[33],E7[48],
               E7[44],E7[49],E7[39],E7[56],E7[34],E7[53],
               E7[46],E7[42],E7[50],E7[36],E7[29],E7[32]};
    C8={C7[25:0],C7[27:26]};
    D8={D7[25:0],D7[27:26]};
    E8={C8,D8};
    ROUND8_KEY ={E8[14],E8[17],E8[11],E8[24],E8[1],E8[5],
               E8[3],E8[28],E8[15],E8[6],E8[21],E8[10],
               E8[23],E8[19],E8[12],E8[4],E8[26],E8[8],
               E8[16],E8[7],E8[27],E8[20],E8[13],E8[2],
               E8[41],E8[52],E8[31],E8[37],E8[47],E8[55],
               E8[30],E8[40],E8[51],E8[45],E8[33],E8[48],
               E8[44],E8[49],E8[39],E8[56],E8[34],E8[53],
               E8[46],E8[42],E8[50],E8[36],E8[29],E8[32]};
    C9={C8[26:0],C8[27]};
    D9={D8[26:0],D8[27]};
    E9={C9,D9};
    ROUND9_KEY ={E9[14],E9[17],E9[11],E9[24],E9[1],E9[5],
               E9[3],E9[28],E9[15],E9[6],E9[21],E9[10],
               E9[23],E9[19],E9[12],E9[4],E9[26],E9[8],
               E9[16],E9[7],E9[27],E9[20],E9[13],E9[2],
               E9[41],E9[52],E9[31],E9[37],E9[47],E9[55],
               E9[30],E9[40],E9[51],E9[45],E9[33],E9[48],
               E9[44],E9[49],E9[39],E9[56],E9[34],E9[53],
               E9[46],E9[42],E9[50],E9[36],E9[29],E9[32]};
    C10={C9[25:0],C9[27:26]};
    D10={D9[25:0],D9[27:26]};
    E10={C10,D10};
    ROUND10_KEY ={E10[14],E10[17],E10[11],E10[24],E10[1],E10[5],
               E10[3],E10[28],E10[15],E10[6],E10[21],E10[10],
               E10[23],E10[19],E10[12],E10[4],E10[26],E10[8],
               E10[16],E10[7],E10[27],E10[20],E10[13],E10[2],
               E10[41],E10[52],E10[31],E10[37],E10[47],E10[55],
               E10[30],E10[40],E10[51],E10[45],E10[33],E10[48],
               E10[44],E10[49],E10[39],E10[56],E10[34],E10[53],
               E10[46],E10[42],E10[50],E10[36],E10[29],E10[32]};
    C11={C10[25:0],C10[27:26]};
    D11={D10[25:0],D10[27:26]};
    E11={C11,D11};
    ROUND11_KEY ={E11[14],E11[17],E11[11],E11[24],E11[1],E11[5],
               E11[3],E11[28],E11[15],E11[6],E11[21],E11[10],
               E11[23],E11[19],E11[12],E11[4],E11[26],E11[8],
               E11[16],E11[7],E11[27],E11[20],E11[13],E11[2],
               E11[41],E11[52],E11[31],E11[37],E11[47],E11[55],
               E11[30],E11[40],E11[51],E11[45],E11[33],E11[48],
               E11[44],E11[49],E11[39],E11[56],E11[34],E11[53],
               E11[46],E11[42],E11[50],E11[36],E11[29],E11[32]};
    C12={C11[25:0],C11[27:26]};
    D12={D11[25:0],D11[27:26]};
    E12={C12,D12};
    ROUND12_KEY ={E12[14],E12[17],E12[11],E12[24],E12[1],E12[5],
               E12[3],E12[28],E12[15],E12[6],E12[21],E12[10],
               E12[23],E12[19],E12[12],E12[4],E12[26],E12[8],
               E12[16],E12[7],E12[27],E12[20],E12[13],E12[2],
               E12[41],E12[52],E12[31],E12[37],E12[47],E12[55],
               E12[30],E12[40],E12[51],E12[45],E12[33],E12[48],
               E12[44],E12[49],E12[39],E12[56],E12[34],E12[53],
               E12[46],E12[42],E12[50],E12[36],E12[29],E12[32]};
    C13={C12[25:0],C12[27:26]};
    D13={D12[25:0],D12[27:26]};
    E13={C13,D13};
    ROUND13_KEY ={E13[14],E13[17],E13[11],E13[24],E13[1],E13[5],
               E13[3],E13[28],E13[15],E13[6],E13[21],E13[10],
               E13[23],E13[19],E13[12],E13[4],E13[26],E13[8],
               E13[16],E13[7],E13[27],E13[20],E13[13],E13[2],
               E13[41],E13[52],E13[31],E13[37],E13[47],E13[55],
               E13[30],E13[40],E13[51],E13[45],E13[33],E13[48],
               E13[44],E13[49],E13[39],E13[56],E13[34],E13[53],
               E13[46],E13[42],E13[50],E13[36],E13[29],E13[32]};
    C14={C13[25:0],C13[27:26]};
    D14={D13[25:0],D13[27:26]};
    E14={C14,D14};
    ROUND14_KEY ={E14[14],E14[17],E14[11],E14[24],E14[1],E14[5],
               E14[3],E14[28],E14[15],E14[6],E14[21],E14[10],
               E14[23],E14[19],E14[12],E14[4],E14[26],E14[8],
               E14[16],E14[7],E14[27],E14[20],E14[13],E14[2],
               E14[41],E14[52],E14[31],E14[37],E14[47],E14[55],
               E14[30],E14[40],E14[51],E14[45],E14[33],E14[48],
               E14[44],E14[49],E14[39],E14[56],E14[34],E14[53],
               E14[46],E14[42],E14[50],E14[36],E14[29],E14[32]};
    C15={C14[25:0],C14[27:26]};
    D15={D14[25:0],D14[27:26]};
    E15={C15,D15};
    ROUND15_KEY ={E15[14],E15[17],E15[11],E15[24],E15[1],E15[5],
               E15[3],E15[28],E15[15],E15[6],E15[21],E15[10],
               E15[23],E15[19],E15[12],E15[4],E15[26],E15[8],
               E15[16],E15[7],E15[27],E15[20],E15[13],E15[2],
               E15[41],E15[52],E15[31],E15[37],E15[47],E15[55],
               E15[30],E15[40],E15[51],E15[45],E15[33],E15[48],
               E15[44],E15[49],E15[39],E15[56],E15[34],E15[53],
               E15[46],E15[42],E15[50],E15[36],E15[29],E15[32]};
    C16={C15[26:0],C15[27]};
    D16={D15[26:0],D15[27]};
    E16={C16,D16};
    ROUND16_KEY ={E16[14],E16[17],E16[11],E16[24],E16[1],E16[5],
               E16[3],E16[28],E16[15],E16[6],E16[21],E16[10],
               E16[23],E16[19],E16[12],E16[4],E16[26],E16[8],
               E16[16],E16[7],E16[27],E16[20],E16[13],E16[2],
               E16[41],E16[52],E16[31],E16[37],E16[47],E16[55],
               E16[30],E16[40],E16[51],E16[45],E16[33],E16[48],
               E16[44],E16[49],E16[39],E16[56],E16[34],E16[53],
               E16[46],E16[42],E16[50],E16[36],E16[29],E16[32]};
    // 参考加密：使用上面生成的 16 组轮密钥逐轮展开 DES Feistel 网络。
    PTEXT=64'h636f_6d70_7574_6572;
    // IP 初始置换，把明文重排后拆成 L0 和 R0。
    IP={PTEXT[58],PTEXT[50],PTEXT[42],PTEXT[34],PTEXT[26],PTEXT[18],PTEXT[10],PTEXT[2],
        PTEXT[60],PTEXT[52],PTEXT[44],PTEXT[36],PTEXT[28],PTEXT[20],PTEXT[12],PTEXT[4],
        PTEXT[62],PTEXT[54],PTEXT[46],PTEXT[38],PTEXT[30],PTEXT[22],PTEXT[14],PTEXT[6],
        PTEXT[64],PTEXT[56],PTEXT[48],PTEXT[40],PTEXT[32],PTEXT[24],PTEXT[16],PTEXT[8],
        PTEXT[57],PTEXT[49],PTEXT[41],PTEXT[33],PTEXT[25],PTEXT[17],PTEXT[9],PTEXT[1],
        PTEXT[59],PTEXT[51],PTEXT[43],PTEXT[35],PTEXT[27],PTEXT[19],PTEXT[11],PTEXT[3],
        PTEXT[61],PTEXT[53],PTEXT[45],PTEXT[37],PTEXT[29],PTEXT[21],PTEXT[13],PTEXT[5],
        PTEXT[63],PTEXT[55],PTEXT[47],PTEXT[39],PTEXT[31],PTEXT[23],PTEXT[15],PTEXT[7]};
    L0=IP[1:32];
    R0=IP[33:64];
    // 以下每一轮执行：L(i)=R(i-1)，R(i)=L(i-1) xor P(S(E(R(i-1)) xor K(i)))。
    L1=R0;
    XOR_1=EXP(R0)^ROUND1_KEY;
    SBOX_1={sbox1(XOR_1[1:6]),sbox2(XOR_1[7:12]),sbox3(XOR_1[13:18]),sbox4(XOR_1[19:24]),sbox5(XOR_1[25:30]),sbox6(XOR_1[31:36]),sbox7(XOR_1[37:42]),sbox8(XOR_1[43:48])};
    R1=L0^P(SBOX_1);
    
    L2=R1;
    XOR_2=EXP(R1)^ROUND2_KEY;
    SBOX_2={sbox1(XOR_2[1:6]),sbox2(XOR_2[7:12]),sbox3(XOR_2[13:18]),sbox4(XOR_2[19:24]),sbox5(XOR_2[25:30]),sbox6(XOR_2[31:36]),sbox7(XOR_2[37:42]),sbox8(XOR_2[43:48])};
    R2=L1^P(SBOX_2);
    
    L3=R2;
    XOR_3=EXP(R2)^ROUND3_KEY;
    SBOX_3={sbox1(XOR_3[1:6]),sbox2(XOR_3[7:12]),sbox3(XOR_3[13:18]),sbox4(XOR_3[19:24]),sbox5(XOR_3[25:30]),sbox6(XOR_3[31:36]),sbox7(XOR_3[37:42]),sbox8(XOR_3[43:48])};
    R3=L2^P(SBOX_3);
    
    L4=R3;
    XOR_4=EXP(R3)^ROUND4_KEY;
    SBOX_4={sbox1(XOR_4[1:6]),sbox2(XOR_4[7:12]),sbox3(XOR_4[13:18]),sbox4(XOR_4[19:24]),sbox5(XOR_4[25:30]),sbox6(XOR_4[31:36]),sbox7(XOR_4[37:42]),sbox8(XOR_4[43:48])};
    R4=L3^P(SBOX_4);
    
    L5=R4;
    XOR_5=EXP(R4)^ROUND5_KEY;
    SBOX_5={sbox1(XOR_5[1:6]),sbox2(XOR_5[7:12]),sbox3(XOR_5[13:18]),sbox4(XOR_5[19:24]),sbox5(XOR_5[25:30]),sbox6(XOR_5[31:36]),sbox7(XOR_5[37:42]),sbox8(XOR_5[43:48])};
    R5=L4^P(SBOX_5);
    
    L6=R5;
    XOR_6=EXP(R5)^ROUND6_KEY;
    SBOX_6={sbox1(XOR_6[1:6]),sbox2(XOR_6[7:12]),sbox3(XOR_6[13:18]),sbox4(XOR_6[19:24]),sbox5(XOR_6[25:30]),sbox6(XOR_6[31:36]),sbox7(XOR_6[37:42]),sbox8(XOR_6[43:48])};
    R6=L5^P(SBOX_6);
    
    L7=R6;
    XOR_7=EXP(R6)^ROUND7_KEY;
    SBOX_7={sbox1(XOR_7[1:6]),sbox2(XOR_7[7:12]),sbox3(XOR_7[13:18]),sbox4(XOR_7[19:24]),sbox5(XOR_7[25:30]),sbox6(XOR_7[31:36]),sbox7(XOR_7[37:42]),sbox8(XOR_7[43:48])};
    R7=L6^P(SBOX_7);
    
    L8=R7;
    XOR_8=EXP(R7)^ROUND8_KEY;
    SBOX_8={sbox1(XOR_8[1:6]),sbox2(XOR_8[7:12]),sbox3(XOR_8[13:18]),sbox4(XOR_8[19:24]),sbox5(XOR_8[25:30]),sbox6(XOR_8[31:36]),sbox7(XOR_8[37:42]),sbox8(XOR_8[43:48])};
    R8=L7^P(SBOX_8);
    
    L9=R8;
    XOR_9=EXP(R8)^ROUND9_KEY;
    SBOX_9={sbox1(XOR_9[1:6]),sbox2(XOR_9[7:12]),sbox3(XOR_9[13:18]),sbox4(XOR_9[19:24]),sbox5(XOR_9[25:30]),sbox6(XOR_9[31:36]),sbox7(XOR_9[37:42]),sbox8(XOR_9[43:48])};
    R9=L8^P(SBOX_9);
    
    L10=R9;
    XOR_10=EXP(R9)^ROUND10_KEY;
    SBOX_10={sbox1(XOR_10[1:6]),sbox2(XOR_10[7:12]),sbox3(XOR_10[13:18]),sbox4(XOR_10[19:24]),sbox5(XOR_10[25:30]),sbox6(XOR_10[31:36]),sbox7(XOR_10[37:42]),sbox8(XOR_10[43:48])};
    R10=L9^P(SBOX_10);
    
    L11=R10;
    XOR_11=EXP(R10)^ROUND11_KEY;
    SBOX_11={sbox1(XOR_11[1:6]),sbox2(XOR_11[7:12]),sbox3(XOR_11[13:18]),sbox4(XOR_11[19:24]),sbox5(XOR_11[25:30]),sbox6(XOR_11[31:36]),sbox7(XOR_11[37:42]),sbox8(XOR_11[43:48])};
    R11=L10^P(SBOX_11);
    
    L12=R11;
    XOR_12=EXP(R11)^ROUND12_KEY;
    SBOX_12={sbox1(XOR_12[1:6]),sbox2(XOR_12[7:12]),sbox3(XOR_12[13:18]),sbox4(XOR_12[19:24]),sbox5(XOR_12[25:30]),sbox6(XOR_12[31:36]),sbox7(XOR_12[37:42]),sbox8(XOR_12[43:48])};
    R12=L11^P(SBOX_12);
    
    L13=R12;
    XOR_13=EXP(R12)^ROUND13_KEY;
    SBOX_13={sbox1(XOR_13[1:6]),sbox2(XOR_13[7:12]),sbox3(XOR_13[13:18]),sbox4(XOR_13[19:24]),sbox5(XOR_13[25:30]),sbox6(XOR_13[31:36]),sbox7(XOR_13[37:42]),sbox8(XOR_13[43:48])};
    R13=L12^P(SBOX_13);
    
    L14=R13;
    XOR_14=EXP(R13)^ROUND14_KEY;
    SBOX_14={sbox1(XOR_14[1:6]),sbox2(XOR_14[7:12]),sbox3(XOR_14[13:18]),sbox4(XOR_14[19:24]),sbox5(XOR_14[25:30]),sbox6(XOR_14[31:36]),sbox7(XOR_14[37:42]),sbox8(XOR_14[43:48])};
    R14=L13^P(SBOX_14);
    
    L15=R14;
    XOR_15=EXP(R14)^ROUND15_KEY;
    SBOX_15={sbox1(XOR_15[1:6]),sbox2(XOR_15[7:12]),sbox3(XOR_15[13:18]),sbox4(XOR_15[19:24]),sbox5(XOR_15[25:30]),sbox6(XOR_15[31:36]),sbox7(XOR_15[37:42]),sbox8(XOR_15[43:48])};
    R15=L14^P(SBOX_15);
    
    XOR_16=EXP(R15)^ROUND16_KEY;
    SBOX_16={sbox1(XOR_16[1:6]),sbox2(XOR_16[7:12]),sbox3(XOR_16[13:18]),sbox4(XOR_16[19:24]),sbox5(XOR_16[25:30]),sbox6(XOR_16[31:36]),sbox7(XOR_16[37:42]),sbox8(XOR_16[43:48])};
    L16=L15^P(SBOX_16);
    R16=R15;
    
    // 第 16 轮后合并左右半部，再执行 IP 逆置换得到密文参考值。
    ROUND16_RESULT={L16,R16};
    CTEXT={ROUND16_RESULT[40],ROUND16_RESULT[8],ROUND16_RESULT[48],ROUND16_RESULT[16],ROUND16_RESULT[56],ROUND16_RESULT[24],ROUND16_RESULT[64],ROUND16_RESULT[32],
           ROUND16_RESULT[39],ROUND16_RESULT[7],ROUND16_RESULT[47],ROUND16_RESULT[15],ROUND16_RESULT[55],ROUND16_RESULT[23],ROUND16_RESULT[63],ROUND16_RESULT[31],
           ROUND16_RESULT[38],ROUND16_RESULT[6],ROUND16_RESULT[46],ROUND16_RESULT[14],ROUND16_RESULT[54],ROUND16_RESULT[22],ROUND16_RESULT[62],ROUND16_RESULT[30],
           ROUND16_RESULT[37],ROUND16_RESULT[5],ROUND16_RESULT[45],ROUND16_RESULT[13],ROUND16_RESULT[53],ROUND16_RESULT[21],ROUND16_RESULT[61],ROUND16_RESULT[29],
           ROUND16_RESULT[36],ROUND16_RESULT[4],ROUND16_RESULT[44],ROUND16_RESULT[12],ROUND16_RESULT[52],ROUND16_RESULT[20],ROUND16_RESULT[60],ROUND16_RESULT[28],
           ROUND16_RESULT[35],ROUND16_RESULT[3],ROUND16_RESULT[43],ROUND16_RESULT[11],ROUND16_RESULT[51],ROUND16_RESULT[19],ROUND16_RESULT[59],ROUND16_RESULT[27],
           ROUND16_RESULT[34],ROUND16_RESULT[2],ROUND16_RESULT[42],ROUND16_RESULT[10],ROUND16_RESULT[50],ROUND16_RESULT[18],ROUND16_RESULT[58],ROUND16_RESULT[26],
           ROUND16_RESULT[33],ROUND16_RESULT[1],ROUND16_RESULT[41],ROUND16_RESULT[9],ROUND16_RESULT[49],ROUND16_RESULT[17],ROUND16_RESULT[57],ROUND16_RESULT[25]};
    
  end
endmodule
