`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 02:56:15 PM
// Design Name: 
// Module Name: top_module_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  In this test bench sine In-phase values and cosine Quardrature Phase Values are given by user to verify the funtionality of the modules.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module_tb;
// Declare signals for the testbench
    reg clk;
    reg rst;
    reg start;
    reg signed [15:0] I_in;  // Input for sine wave (Q15 format)
    reg signed [15:0] Q_in;  // Input for cosine wave (Q15 format)
    wire signed [15:0] Inphase_FIR;  // Output for FIR filter (Inphase)
    wire signed [15:0] Qphase_FIR;   // Output for FIR filter (Qphase)
    wire [15:0] magnitude;  // Output for magnitude
    wire done;  // Signal to indicate the operation is done
    // Declare arrays for sine and cosine wave values (Q15 format)
    reg signed [15:0] sine_wave [0:15];
    reg signed [15:0] cosine_wave [0:15];
    integer i;

    // Instantiate the top module
    top_module uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .I_in(I_in),
        .Q_in(Q_in),
        .Inphase_FIR(Inphase_FIR),
        .Qphase_FIR(Qphase_FIR),
        .magnitude(magnitude),
        .done(done)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    // Initialize inputs and sine/cosine wave values
    initial begin
        // Initialize clock and reset signals
        clk = 0;
        rst = 1;
        start = 0;
        I_in = 0;
        Q_in = 0;

        // Initialize sine wave values in Q15 format
        sine_wave[0] = 16'sd0;
        sine_wave[1] = 16'sd12539;
        sine_wave[2] = 16'sd23170;
        sine_wave[3] = 16'sd30273;
        sine_wave[4] = 16'sd32767;
        sine_wave[5] = 16'sd30273;
        sine_wave[6] = 16'sd23170;
        sine_wave[7] = 16'sd12539;
        sine_wave[8] = 16'sd0;
        sine_wave[9] = -16'sd12539;
        sine_wave[10] = -16'sd23170;
        sine_wave[11] = -16'sd30273;
        sine_wave[12] = -16'sd32768;
        sine_wave[13] = -16'sd30273;
        sine_wave[14] = -16'sd23170;
        sine_wave[15] = -16'sd12539;

        // Initialize cosine wave values in Q15 format
        cosine_wave[0]  = 16'sd32767;
        cosine_wave[1]  = 16'sd30273;
        cosine_wave[2]  = 16'sd23170;
        cosine_wave[3]  = 16'sd12539;
        cosine_wave[4]  = 16'sd0;
        cosine_wave[5]  = -16'sd12539;
        cosine_wave[6]  = -16'sd23170;
        cosine_wave[7]  = -16'sd30273;
        cosine_wave[8]  = -16'sd32768;
        cosine_wave[9]  = -16'sd30273;
        cosine_wave[10] = -16'sd23170;
        cosine_wave[11] = -16'sd12539;
        cosine_wave[12] = 16'sd0;
        cosine_wave[13] = 16'sd12539;
        cosine_wave[14] = 16'sd23170;
        cosine_wave[15] = 16'sd30273;

        // Wait a few cycles for reset
        repeat (5) @(posedge clk);
        rst = 0;

        // Apply input samples one-by-one
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            I_in <= sine_wave[i];
            Q_in <= cosine_wave[i];
            start <= 1;

            @(posedge clk);
            start <= 0;

            // Wait one clock for FIR to update
            @(posedge clk);
            $display("Time: %0t | I_in = %d | Q_in = %d | Inphase_FIR = %d | Qphase_FIR = %d | Magnitude = %d | Done = %b",
                      $time, I_in, Q_in, Inphase_FIR, Qphase_FIR, magnitude, done);


        end

        // Let output settle
        repeat (20) begin
            @(posedge clk);
        end

        $finish;
    end
endmodule