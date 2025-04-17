`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amna Arshad Khan
// Create Date: 04/09/2025 12:52:25 PM
// Design Name: Finite Impulse Resposne Filter Design 
// Module Name: fir
// Project Name: Design IP for FIR and magnitude calcualtion.
// Description: 
// Thus is the FIR filter PIPELINED module.
// In this the sum is taking 4 cycles to calculate as it is divided into the 4 stages for the calculations, where as when it do the product it takes 1 cycle to do the multiplication.
// The TAPS are 126 (different for every filter) for the 16 FIR filters.
// The I and Q sample will go parallely in the FIR filters and with them then it will calcualte the output of the FIR filter.
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//NEW FIR FILTER WITH I AND Q COMPONENTS WITH 9 TAP
module fir #(
    parameter TAPS = 9  // Number of FIR filter taps
)(
    input clk,  // Sampling clock
    input signed [15:0] I_in,  // In-phase signal (sine-like), Q15 format
    input signed [15:0] Q_in,  // Quadrature-phase signal (sine-like), Q15 format
    output signed [15:0] Inphase_FIR, // Filtered I_in output, Q15 format
    output signed [15:0] Qphase_FIR  // Quadrature-phase signal (sine-like), Q15 format
);

integer i, j;

// FIR coefficients in Q15
reg signed [15:0] coeff [0:TAPS-1] = {16'h04F6, 16'h0AE4, 16'h1089, 16'h1496, 16'h160F, 16'h1496, 16'h1089, 16'h0AE4, 16'h04F6};

// Delay lines for I and Q channels
reg signed [15:0] delayed_signal_I [0:TAPS-1];
reg signed [15:0] delayed_signal_Q [0:TAPS-1];

// Product arrays for I and Q channels
reg signed [31:0] prod_I [0:TAPS-1];
reg signed [31:0] prod_Q [0:TAPS-1];

// Sum stages for I channel
reg signed [32:0] sum_0_I [0:4];
reg signed [33:0] sum_1_I [0:2];
reg signed [34:0] sum_2_I [0:1];
reg signed [35:0] sum_3_I;

// Sum stages for Q channel
reg signed [32:0] sum_0_Q [0:4];
reg signed [33:0] sum_1_Q [0:2];
reg signed [34:0] sum_2_Q [0:1];
reg signed [35:0] sum_3_Q;

// Delay update for I and Q channels
always @(posedge clk) begin
    delayed_signal_I[0] <= I_in;
    delayed_signal_Q[0] <= Q_in;
    for (i = TAPS-1; i > 0; i = i - 1) begin
        delayed_signal_I[i] <= delayed_signal_I[i - 1];
        delayed_signal_Q[i] <= delayed_signal_Q[i - 1];
    end
end

// Multiply for I and Q channels
always @(posedge clk) begin
    for (j = 0; j < TAPS; j = j + 1) begin
        prod_I[j] <= delayed_signal_I[j] * coeff[j];
        prod_Q[j] <= delayed_signal_Q[j] * coeff[j];
    end
end

// Stage-wise accumulation for I channel
always @(posedge clk) begin
    sum_0_I[0] <= prod_I[0] + prod_I[1];
    sum_0_I[1] <= prod_I[2] + prod_I[3];
    sum_0_I[2] <= prod_I[4] + prod_I[5];
    sum_0_I[3] <= prod_I[6] + prod_I[7];
    sum_0_I[4] <= prod_I[8];
end

always @(posedge clk) begin
    sum_1_I[0] <= sum_0_I[0] + sum_0_I[1];
    sum_1_I[1] <= sum_0_I[2] + sum_0_I[3];
    sum_1_I[2] <= sum_0_I[4];
end

always @(posedge clk) begin
    sum_2_I[0] <= sum_1_I[0] + sum_1_I[1];
    sum_2_I[1] <= sum_1_I[2];
end

always @(posedge clk) begin
    sum_3_I <= sum_2_I[0] + sum_2_I[1];
end

// Stage-wise accumulation for Q channel
always @(posedge clk) begin
    sum_0_Q[0] <= prod_Q[0] + prod_Q[1];
    sum_0_Q[1] <= prod_Q[2] + prod_Q[3];
    sum_0_Q[2] <= prod_Q[4] + prod_Q[5];
    sum_0_Q[3] <= prod_Q[6] + prod_Q[7];
    sum_0_Q[4] <= prod_Q[8];
end

always @(posedge clk) begin
    sum_1_Q[0] <= sum_0_Q[0] + sum_0_Q[1];
    sum_1_Q[1] <= sum_0_Q[2] + sum_0_Q[3];
    sum_1_Q[2] <= sum_0_Q[4];
end

always @(posedge clk) begin
    sum_2_Q[0] <= sum_1_Q[0] + sum_1_Q[1];
    sum_2_Q[1] <= sum_1_Q[2];
end

always @(posedge clk) begin
    sum_3_Q <= sum_2_Q[0] + sum_2_Q[1];
end

// Convert back to Q15
assign Inphase_FIR = $signed(sum_3_I[35:14]);
assign Qphase_FIR = $signed(sum_3_Q[35:14]);

endmodule

