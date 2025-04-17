`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amna Arshad Khan
// Create Date: 04/09/2025 12:52:25 PM
// Design Name: Top module
// Module Name: top_module
// Project Name: Design IP for FIR and magnitude calcualtion.
// Description: 
// This module is connecting the FIR module and magnitude module correctly to get the correct result.
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module
(   input wire clk,
    input wire rst,
    input wire start,
    input wire signed [15:0] I_in,  // In-phase input (e.g., sine wave)
    input wire signed [15:0] Q_in,  // Quadrature input
    output wire signed [15:0] Inphase_FIR,  // Filtered I output
    output wire signed [15:0] Qphase_FIR,
    output wire signed [15:0] magnitude,    // sqrt(I² + Q²)
    output wire signed [15:0] magnitude_FIR,    
    output wire done,
    output wire done_FIR
);

    // Instance of FIR for I_in
    fir #(.TAPS(9)) fir_inst (
        .clk(clk),
        .I_in(I_in),
        .Q_in(Q_in),
        .Inphase_FIR(Inphase_FIR),
        .Qphase_FIR(Qphase_FIR)
    );

    // Instance of IQ Magnitude Sqrt
    iq_magnitude_sqrt sqrt_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .I_in(I_in),  // Same I_in as FIR input
        .Q_in(Q_in),
        .magnitude(magnitude),
        .done(done)
    );
    
    // Instance of IQ Magnitude Sqrt after FIR filter
    iq_magnitude_sqrt sqrt_fir_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .I_in(Inphase_FIR),  // Same I_in as FIR input
        .Q_in(Qphase_FIR),
        .magnitude(magnitude_FIR),
        .done(done_FIR)
    );

endmodule