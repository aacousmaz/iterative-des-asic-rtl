`timescale 1ns / 1ns

module des_mux2_word(
    input wire sel,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

// sel=0 选择 a，sel=1 选择 b。
always@(sel or a or b)
      case(sel)
          1'b0: c=a;
          1'b1: c=b; 
          default: c=a;         
      endcase

endmodule

module des_mux3_word(
    input wire [1:0] sel,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    output reg [31:0] d
);

// sel=0/1/2 分别选择 a/b/c。
always@(sel or a or b or c)
      case(sel)
          2'd0: d=a;
          2'd1: d=b; 
          2'd2: d=c;
          default: d=a;         
      endcase

endmodule

module des_mux6_key(
    input wire [2:0] sel,
    input wire [27:0] a,
    input wire [27:0] b,
    input wire [27:0] c,
    input wire [27:0] d,
    input wire [27:0] e,
    input wire [27:0] f,
    output reg [27:0] g
);

// sel=0~5 分别选择 a~f，默认回到 a。
always@(*)
      case(sel)
          3'd0: g=a;
          3'd1: g=b; 
          3'd2: g=c;
          3'd3: g=d;
          3'd4: g=e; 
          3'd5: g=f;
          default: g=a;         
      endcase

endmodule

module des_key_register(
    input wire clk,
    input wire wen,
    input wire [27:0] din,
    output reg [27:0] dout
);

  // wen 有效时写入新数据，否则保持原值。
  always @ (posedge clk)
	  begin
		  if(wen)
				dout<=din;

	  end

endmodule

module des_word_register(
    input wire clk,
    input wire wen,
    input wire [31:0] din,
    output reg [31:0] dout
);

  // wen 有效时写入新数据，否则保持原值。
  always @ (posedge clk)
	  begin
		  if(wen)
				dout<=din;

	  end

endmodule
