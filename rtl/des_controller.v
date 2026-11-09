`timescale 1ns / 1ns
module des_controller(
    input wire clk,
    input wire rst,
    input wire keyexp_start,
    input wire encry_start,
    input wire decry_start,
    output wire reg0_wen,
    output wire reg1_wen,
    output wire reg2_wen,
    output reg [2:0] mux_sel,
    output wire regL_wen,
    output wire regR_wen,
    output wire [1:0] muxL_sel,
    output wire muxR_sel,
    output reg [1:0] state
);


// state 为当前状态，next_state 为组合逻辑计算出的下一状态。
reg [1:0] next_state;
wire keyexp_end,encrypt_end,decrypt_end;
// 5 位计数器用于覆盖 DES 的 16 轮运算，counter==16 表示本次流程结束。
reg [4:0] counter;

parameter IDLE=2'd0,KEYEXP=2'd1,ENCRYPT=2'd2,DECRYPT=2'd3;
          
// 异步低有效复位；复位后回到空闲态。
always @ (posedge clk or negedge rst)
	  if(!rst)
				state<=IDLE;
		else 
				state<=next_state;
	
// 根据启动信号和结束标志切换状态。
always @ (*)
    case(state)
        IDLE: if(keyexp_start == 1) 
			            next_state = KEYEXP;
					    else if(encry_start == 1)
					        next_state = ENCRYPT;
					    else if(decry_start == 1)
					        next_state = DECRYPT;
					    else
					        next_state = IDLE; 
        KEYEXP: if(keyexp_end == 1) 
			              next_state = IDLE;
					      else
					          next_state = KEYEXP;
        ENCRYPT: if(encrypt_end == 1) 
			              next_state = IDLE;
					       else
					          next_state = ENCRYPT;
        DECRYPT: if(decrypt_end == 1) 
			              next_state = IDLE;
					       else
					          next_state = DECRYPT;
        default: next_state = IDLE;
    endcase

// 非空闲状态下计满 16 轮，计满后自动清零。
always @ (posedge clk or negedge rst)
	  if(!rst)
				counter<=5'd0;
		else if((state!=IDLE)&(counter[4]==1'b0))// 计数值小于 16
				counter<=counter+1'b1;
		else if(counter[4]==1'b1)// 计数值达到或超过 16
		    counter<=5'd0;
		else
		    counter<=counter;   
// 三种流程都以 16 轮计数结束。
assign keyexp_end=(counter==5'd16);
assign encrypt_end=keyexp_end;
assign decrypt_end=keyexp_end;

// 密钥扩展寄存器与加解密左右半部寄存器的写使能。
assign reg0_wen=(state==KEYEXP)&(counter==5'd0);
assign reg1_wen=((state==KEYEXP)&(counter!=5'd0))|(((state==ENCRYPT)|(state==DECRYPT))&(counter!=5'd16));
assign reg2_wen=(state==KEYEXP)&(counter==5'd16);
assign regL_wen=(state==ENCRYPT)|(state==DECRYPT);
assign regR_wen=regL_wen & (counter!=5'd16);
// 轮函数输入选择：第 0 轮取 IP 结果，中间轮取上一轮结果，第 16 轮输出前交换左右半部。
assign muxL_sel=(counter==5'd0) ? 2'd0 : ((counter==5'd16) ? 2'd2 : 2'd1);
assign muxR_sel=(counter==5'd0) ? 1'b0 : 1'b1;

// mux_sel 控制 des_key_schedule 中 C/D 半密钥的循环移位方向和位数。
always @ (*)
    case(state)
        KEYEXP:  case(counter) 
			              5'd1:mux_sel = 3'd0;
			              5'd2,
			              5'd9,
			              5'd16:mux_sel = 3'd1;
			              default: mux_sel = 3'd2;
			           endcase
        ENCRYPT: case(counter) 
			              5'd0:mux_sel = 3'd0;
			              5'd1,
			              5'd8,
			              5'd15:mux_sel = 3'd1;
			              default: mux_sel = 3'd2;
			           endcase
				DECRYPT: case(counter) 
			              5'd0:mux_sel = 3'd3;
			              5'd1,
			              5'd8,
			              5'd15:mux_sel = 3'd4;
			              default: mux_sel = 3'd5;
			           endcase
        default: mux_sel = 3'd0;
    endcase

endmodule
