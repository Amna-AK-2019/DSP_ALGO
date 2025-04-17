`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:53:13 PM
// Design Name: 
// Module Name: fir_tb
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

//module fir_tb();

//    parameter TAPS = 126;
//    parameter CLK_PERIOD = 10;

//    reg clk = 0;
//    reg reset;
//    reg signed [15:0] I_in, Q_in;
//    wire signed [15:0] Inphase_FIR, Qphase_FIR;

//    integer i;
//    real pi = 3.14159265;
//    real frequency = 1.0;
//    real sampling_rate = 100.0; // Hz
//    real t;

//    // Instantiate the FIR filter
//    fir #(.TAPS(TAPS)) uut (
//        .clk(clk),
//        .reset(reset),
//        .I_in(I_in),
//        .Q_in(Q_in),
//        .Inphase_FIR(Inphase_FIR),
//        .Qphase_FIR(Qphase_FIR)
//    );

//    // Clock generator
//    always #(CLK_PERIOD / 2) clk = ~clk;

//    // Test sequence
//    initial begin
//        // Dump waveform to VCD file
////        $dumpfile("fir_pipelined_tb.vcd");
////        $dumpvars(0, tb_fir_pipelined);

//        reset = 1;
//        I_in = 0;
//        Q_in = 0;
//        #(2 * CLK_PERIOD);

//        reset = 0;

//        // Feed sine and cosine wave values in Q15 format
//        for (i = 0; i < 500; i = i + 1) begin
//            t = i / sampling_rate;
//            I_in = $rtoi($sin(2 * pi * frequency * t) * 32767);  // Sine wave
//            Q_in = $rtoi($cos(2 * pi * frequency * t) * 32767);  // Cosine wave
//            #(CLK_PERIOD);
//        end

//        // Finish after sending all samples
//        #(10 * CLK_PERIOD);
//        $finish;
//    end

//endmodule


//q15 format
module fir_tb();

localparam CORDIC_CLK_PERIOD=2; // To create 500MHz CORDIC sampling clock
localparam FIR_CLK_PERIOD=10;   // To create 100MHz FIR lowpass filter sampling clock
localparam signed [15:0] PI_POS=16'h6488; // +pi in fixed point 1.2.13 (Q15 format)
localparam signed [15:0] PI_NEG=16'h9B78; // -pi in fixed point 1.2.13 (Q15 format)
localparam PHASE_INC_2MHz=200; // phase jump for 2MHz sine wave synthesis
localparam PHASE_INC_30MHz=3000; // phase jump for 30MHz sine wave synthesis

reg cordic_clk=1'b0;
reg fir_clk = 1'b0;
reg phase_tvalid=1'b0;
reg signed [15:0] phase_2MHz=0;  // 2MHz phase sweep in Q15 format
reg signed [15:0] phase_30MHz=0;  // 30MHz phase sweep in Q15 format

wire sincos_2MHz_tvalid;
wire signed [15:0] sin_2MHz, cos_2MHz;  // 2MHz sine/cosine in Q15 format
wire sincos_30MHz_tvalid;
wire signed [15:0] sin_30MHz, cos_30MHz;  // 30MHz sine/cosine in Q15 format

reg signed [15:0] noisy_signal = 0;  // Noisy signal = 2MHz sine + 30MHz sine, in Q15 format
wire signed [15:0] filtered_signal;  // Filtered signal in Q15 format

reg signed [15:0] noisy_cosine_signal = 0;  // Noisy signal for cosine in Q15 format
wire signed [15:0] filtered_cosine_signal;  // Filtered cosine signal in Q15 format

// Instantiate the CORDIC for generating sine and cosine signals
cordic_1 cordic_inst_0 (
    .aclk (cordic_clk),
    .s_axis_phase_tvalid (phase_tvalid),
    .s_axis_phase_tdata(phase_2MHz),
    .m_axis_dout_tvalid(sincos_2MHz_tvalid),
    .m_axis_dout_tdata({sin_2MHz, cos_2MHz})
);

cordic_1 cordic_inst_1 (
    .aclk (cordic_clk),
    .s_axis_phase_tvalid (phase_tvalid),
    .s_axis_phase_tdata(phase_30MHz),
    .m_axis_dout_tvalid(sincos_30MHz_tvalid),
    .m_axis_dout_tdata({sin_30MHz, cos_30MHz})
);

// Phase sweep for generating the sine and cosine waveforms
always @(posedge cordic_clk) begin
    phase_tvalid <= 1'b1;

    // Sweep phase to synthesize 2MHz sine wave (Q15 format)
    if (phase_2MHz + PHASE_INC_2MHz < PI_POS) begin
        phase_2MHz <= phase_2MHz + PHASE_INC_2MHz;
    end else begin
        phase_2MHz <= PI_NEG + (phase_2MHz + PHASE_INC_2MHz - PI_POS);
    end
    
    // Sweep phase to synthesize 30MHz sine wave (Q15 format)
    if (phase_30MHz + PHASE_INC_30MHz < PI_POS) begin
        phase_30MHz <= phase_30MHz + PHASE_INC_30MHz;
    end else begin
        phase_30MHz <= PI_NEG + (phase_30MHz + PHASE_INC_30MHz - PI_POS);
    end
end

// Create 500MHz Cordic clock
always begin
    cordic_clk = #(CORDIC_CLK_PERIOD / 2) ~cordic_clk;
end

// Create 100MHz FIR clock
always begin
    fir_clk = #(FIR_CLK_PERIOD / 2) ~fir_clk;
end

// Combine the noisy signals (2MHz sine + 30MHz sine)
// Noisy signal is resampled at 100MHz FIR sampling rate
always @(posedge fir_clk) begin
    // Sum the sine waves (scaled to Q15 format)
    noisy_signal <= (sin_2MHz + sin_30MHz) >>> 1;  // Average them for the noisy signal
    noisy_cosine_signal <= (cos_2MHz + cos_30MHz) >>> 1;  // Average the cosine waves
end

 //Instantiate the FIR filter for sine and cosine signals
fir fir_inst_sine (
    .clk(fir_clk),
    .noisy_signal(noisy_signal),
    .filtered_signal(filtered_signal)
);

fir fir_inst_cosine (
    .clk(fir_clk),
    .noisy_signal(noisy_cosine_signal),
    .filtered_signal(filtered_cosine_signal)
);


endmodule



