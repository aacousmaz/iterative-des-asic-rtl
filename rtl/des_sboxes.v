`timescale 1ns / 1ns

module des_sbox_1(input wire [5:0] in, output reg [3:0] out);
    // Entry 0 occupies the least significant nibble.
    localparam [255:0] LUT = {
        64'hd0650aa3e739bc5f,
        64'h7b12964d288ec1f4,
        64'h87305995bcc66aa3,
        64'h18db2fe2417df40e
    };

    always @* begin
        case (^in)
            1'b0, 1'b1: out = LUT[{in, 2'b00} +: 4];
            default: out = 4'd0;
        endcase
    end
endmodule

module des_sbox_2(input wire [5:0] in, output reg [3:0] out);
    // Entry 0 occupies the least significant nibble.
    localparam [255:0] LUT = {
        64'h9fe25309c67c68b5,
        64'h214df43a1ba78ed0,
        64'h5ab5906cad1207c9,
        64'he4832bf67e48d13f
    };

    always @* begin
        case (^in)
            1'b0, 1'b1: out = LUT[{in, 2'b00} +: 4];
            default: out = 4'd0;
        endcase
    end
endmodule

module des_sbox_3(input wire [5:0] in, output reg [3:0] out);
    // Entry 0 occupies the least significant nibble.
    localparam [255:0] LUT = {
        64'hc72e5ab53ce2f14b,
        64'h70839f6809d4a61d,
        64'h18f2b4cbe75c8d21,
        64'ha56f43369e0970da
    };

    always @* begin
        case (^in)
            1'b0, 1'b1: out = LUT[{in, 2'b00} +: 4];
            default: out = 4'd0;
        endcase
    end
endmodule

module des_sbox_4(input wire [5:0] in, output reg [3:0] out);
    // Entry 0 occupies the least significant nibble.
    localparam [255:0] LUT = {
        64'he42872c5be53419f,
        64'h8d371bac6009f63a,
        64'h9fe4ac1bc5287241,
        64'h3a09f66053be8dd7
    };

    always @* begin
        case (^in)
            1'b0, 1'b1: out = LUT[{in, 2'b00} +: 4];
            default: out = 4'd0;
        endcase
    end
endmodule

module des_sbox_5(input wire [5:0] in, output reg [3:0] out);
    // Entry 0 occupies the least significant nibble.
    localparam [255:0] LUT = {
        64'h3e5043a6950cf96f,
        64'hd827ed1a7bc182b4,
        64'h698e903d0ff30558,
        64'h16db7a47c124bce2
    };

    always @* begin
        case (^in)
            1'b0, 1'b1: out = LUT[{in, 2'b00} +: 4];
            default: out = 4'd0;
        endcase
    end
endmodule

module des_sbox_6(input wire [5:0] in, output reg [3:0] out);
    // Entry 0 occupies the least significant nibble.
    localparam [255:0] LUT = {
        64'hd68b0d617a14e0b7,
        64'ha3fc5892c52f3e49,
        64'h8b35b70ee4d31d60,
        64'h5896c2792f4a51ac
    };

    always @* begin
        case (^in)
            1'b0, 1'b1: out = LUT[{in, 2'b00} +: 4];
            default: out = 4'd0;
        endcase
    end
endmodule

module des_sbox_7(input wire [5:0] in, output reg [3:0] out);
    // Entry 0 occupies the least significant nibble.
    localparam [255:0] LUT = {
        64'hc23925e0f8065f9a,
        64'h7ea7431c8ddbb461,
        64'h6186fa25c7593ce3,
        64'had18904f7eb20bd4
    };

    always @* begin
        case (^in)
            1'b0, 1'b1: out = LUT[{in, 2'b00} +: 4];
            default: out = 4'd0;
        endcase
    end
endmodule

module des_sbox_8(input wire [5:0] in, output reg [3:0] out);
    // Entry 0 occupies the least significant nibble.
    localparam [255:0] LUT = {
        64'hb865533f0d9ac6f0,
        64'hd28eac4971e41b27,
        64'h279ce005be6359ca,
        64'h417b3fa684d8f21d
    };

    always @* begin
        case (^in)
            1'b0, 1'b1: out = LUT[{in, 2'b00} +: 4];
            default: out = 4'd0;
        endcase
    end
endmodule

