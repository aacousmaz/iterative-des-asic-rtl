`timescale 1ns / 1ns

module des_input_buffer(
    input wire clk,
    input wire load,
    input wire [31:0] din,
    output reg [63:0] dout
);

  // load 有效时，新输入放入高 32 位，原高 32 位移动到低 32 位。
  always @ (posedge clk)
	  begin
		  if(load)
				dout<={din,dout[63:32]};

	  end

endmodule
