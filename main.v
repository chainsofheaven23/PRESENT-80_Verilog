`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2025 23:39:40
// Design Name: 
// Module Name: main
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


module present_top (
    input  wire       clk,
    input  wire       rst,
    input  wire       enable,
    input  wire [63:0] plaintext,
    input  wire [79:0] key_in,
    output reg  [63:0] ciphertext,
    output reg         done
);

    // ROUNDS fixed to 31 (hard-coded)
    // datapath / control
    reg  [63:0] state;
    wire [63:0] after_addkey;  // combinational: state ^ current_round_key
    wire [63:0] sbox_out;
    wire [63:0] p_layer_out;
    wire [63:0] round_key_from_keymod;
    reg  [4:0]  round_count;

    // instantiate key module (named port mapping is safest)
    key key_sched (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .rounds(round_count),
        .key(key_in), // BUG FIX 1: Port name corrected from .key_in
        .roundk(round_key_from_keymod)
    );

    // AddRoundKey (uses registered round_key_from_keymod)
    assign after_addkey = state ^ round_key_from_keymod;

    // 16 S-Boxes (manual)
    sbox_1 s0  (.datain(after_addkey[ 3: 0]), .sbox_out(sbox_out[ 3: 0]));
    sbox_1 s1  (.datain(after_addkey[ 7: 4]), .sbox_out(sbox_out[ 7: 4]));
    sbox_1 s2  (.datain(after_addkey[11: 8]), .sbox_out(sbox_out[11: 8]));
    sbox_1 s3  (.datain(after_addkey[15:12]), .sbox_out(sbox_out[15:12]));
    sbox_1 s4  (.datain(after_addkey[19:16]), .sbox_out(sbox_out[19:16]));
    sbox_1 s5  (.datain(after_addkey[23:20]), .sbox_out(sbox_out[23:20]));
    sbox_1 s6  (.datain(after_addkey[27:24]), .sbox_out(sbox_out[27:24]));
    sbox_1 s7  (.datain(after_addkey[31:28]), .sbox_out(sbox_out[31:28]));
    sbox_1 s8  (.datain(after_addkey[35:32]), .sbox_out(sbox_out[35:32]));
    sbox_1 s9  (.datain(after_addkey[39:36]), .sbox_out(sbox_out[39:36]));
    sbox_1 s10 (.datain(after_addkey[43:40]), .sbox_out(sbox_out[43:40]));
    sbox_1 s11 (.datain(after_addkey[47:44]), .sbox_out(sbox_out[47:44]));
    sbox_1 s12 (.datain(after_addkey[51:48]), .sbox_out(sbox_out[51:48]));
    sbox_1 s13 (.datain(after_addkey[55:52]), .sbox_out(sbox_out[55:52]));
    sbox_1 s14 (.datain(after_addkey[59:56]), .sbox_out(sbox_out[59:56]));
    sbox_1 s15 (.datain(after_addkey[63:60]), .sbox_out(sbox_out[63:60]));

    // P-layer (use your p_layer module; port names must match)
    p_layer p_inst (
        .data_in(sbox_out),
        .data_out(p_layer_out)
    );

    // control: run 31 rounds (hard-coded)
    always @(posedge clk) begin
        if (rst) begin
            state       <= plaintext;    // load plaintext on reset
            round_count <= 0;
            done        <= 0;
            ciphertext  <= 64'h0;
        end else if (enable && !done) begin
            if (round_count < 31) begin
                // normal round: state <- P(S(state xor round_key))
                state <= p_layer_out;
                round_count <= round_count + 1;
            end else begin
                // final whitening (after 31 rounds)
                ciphertext <= state ^ round_key_from_keymod;
                done <= 1;
            end
        end
    end

endmodule

