`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2025 00:45:29
// Design Name: 
// Module Name: key
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module key (
    input  wire       clk,
    input  wire       rst,
    input  wire       enable,
    input  wire [4:0] rounds,   // current round index (0..30)
    input  wire [79:0] key,
    output reg  [63:0] roundk    // registered round key
);

    reg [79:0] kreg;
    reg [79:0] rotated_key;
    reg [79:0] k2;
    reg [79:0] k3;
    wire [3:0] sbox_in;
    wire [3:0] sbox_out;

    
    sbox_1 key_sbox (
        .datain(sbox_in),
        .sbox_out(sbox_out)
    );

    assign sbox_in = rotated_key[79:76];

    
    always @(*) begin
        rotated_key = {kreg[18:0], kreg[79:19]};
        k2 = {sbox_out, rotated_key[75:0]};
        k3 = k2 ^ {60'b0, (rounds + 1), 15'b0};
    end

    always @(posedge clk) begin
        if (rst) begin
            kreg   <= key;           
            roundk <= key[79:16];     
        end else if (enable) begin
            kreg   <= k3;             
           
            roundk <= k3[79:16];
        end
    end

endmodule