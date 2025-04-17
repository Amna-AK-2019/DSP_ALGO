`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amna Arshad Khan
// Create Date: 04/08/2025 10:23:21 AM
// Design Name: Magnitude calculator
// Module Name: iq_magnitude_sqrt
// Project Name: Design IP for FIR and magnitude calcualtion.
// Description: 
// It is an IP for calculating the magnitude of Inphase (I-Phase) and Quardrature (Q-Phase) components.It take 16 bits inputs which then get square and
// add up and make 32 bits , but when we take the square root of the sum it again gives us 16 bits output.
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//IQ MAGNITUDE Q0.15 fixed-point SIGNED
module iq_magnitude_sqrt (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire signed [15:0] I_in,  // Q0.15 fixed-point signed
    input  wire signed [15:0] Q_in,  // Q0.15 fixed-point signed
    output wire [15:0] magnitude,    // Q0.15 fixed-point signed
    output wire        done
);

    // Step 1: Square I and Q (Q0.15 * Q0.15 = Q0.30)
    wire signed [31:0] I_sq = I_in * I_in;
    wire signed [31:0] Q_sq = Q_in * Q_in;

    // Step 2: Sum of squares (still in Q0.30)
    wire  [32:0] sum_squares = I_sq + Q_sq;   //unsigned 33 bits---32 bits for addition and the sum we will get, 33rd bit is for overflo/carry
    
    //===========overflow/carry logic==========//
    // Truncate or saturate before passing to CORDIC if needed
    wire [31:0] sum_squares_trunc = sum_squares[31:0]; // Truncate
    // or
     //wire [31:0] sum_squares_safe = (sum_squares[32] ==  1'b1) ? 32'h7FFFFFFF : sum_squares[31:0];

    //===========shifting logic==========//
//    // Step 3: Shift right by 14 to bring back to Q0.30 before sqrt
//   // NOTE: Skipping >>15 because CORDIC expects full Q0.30 scale and handles sqrt accordingly

//    wire [31:0] sum_squares_q14 = sum_squares >>> 15;



    // Step 4: Call CORDIC or square root unit
    wire [15:0] sqrt_out;
    wire        sqrt_valid;

    cordic_0 cordic_sqrt_inst (
        .aclk(clk),
        .s_axis_cartesian_tvalid(start),
        .s_axis_cartesian_tdata(sum_squares_trunc), // Input to CORDIC: Q0.30
        .m_axis_dout_tvalid(sqrt_valid),
        .m_axis_dout_tdata(sqrt_out)              // Output: Q0.15
    );

    assign magnitude = sqrt_out;
    assign done = sqrt_valid;

endmodule


