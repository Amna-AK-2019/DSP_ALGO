`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Amna Arshad Khan
// Create Date: 04/08/2025 10:23:21 AM
// Design Name: Magnitude calculator Test Bench 
// Module Name: tb_iq_magnitude_sqrt
// Description: 
// This is performing different test cases to verify magnitude calculator IP is giving us the same and accurate results.
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


////TEST BENCH
//module tb_iq_magnitude_sqrt;
    // Inputs
//    reg clk; 
//    reg rst; 
//    reg start; 
//    reg [15:0] I_in; 
//    reg [15:0] Q_in;
   // Outputs
//    wire [15:0] magnitude; 
//    wire done;
 
  // Instantiate the DUT (Design Under Test)
//    iq_magnitude_sqrt uut (
//        .clk(clk),
//        .rst(rst),
//        .start(start),
//        .I_in(I_in),
//        .Q_in(Q_in), 
//        .magnitude(magnitude),
//        .done(done)
//    );

// Clock generation
//    always #5 clk = ~clk;  // 100 MHz clock (period = 10 ns)

//initial begin
//        // Initialize inputs
//        clk = 0; 
//        rst = 1; 
//        start = 0; 
//        I_in = 0; 
//        Q_in = 0; // Reset pulse
//        #20;
//        rst = 0;
// --- Test Case 1: I = 3, Q = 4 (Expect magnitude = 5) ---
//        I_in = 3; Q_in = 4;
//        #10 start = 1;
//        #10 start = 0;
// Wait for done
//        wait (done == 1);
//        $display("Test 1: I=3, Q=4 => magnitude=%d (Expected: 5)", magnitude);
// --- Test Case 2: I = 6, Q = 8 (Expect magnitude = 10) ---
//        #20;
//        I_in = 6; Q_in = 8;
//        #10 start = 1;
//        #10 start = 0;
//wait (done == 1);
//        $display("Test 2: I=6, Q=8 => magnitude=%d (Expected: 10)", magnitude);
// --- Test Case 2: I = 123, Q = 456 (Expect magnitude = 10) ---
//        #20;
//        I_in = 123; Q_in = 456;
//        #10 start = 1;
//        #10 start = 0;
//wait (done == 1);
//        $display("Test 2: I=123, Q=456 => magnitude=%d (Expected: 472.29)", magnitude);
        // --- Done ---
//        #50;
//        $finish;
//    end
//endmodule

//using for loop to test multiple cases.
//`timescale 1ns / 1ps

//module tb_iq_magnitude_sqrt;

//    // Inputs
//    reg clk;
//    reg rst;
//    reg start;
//    reg [15:0] I_in;
//    reg [15:0] Q_in;

//    // Outputs
//    wire [15:0] magnitude;
//    wire done;

//    // Instantiate the DUT
//    iq_magnitude_sqrt uut (
//        .clk(clk),
//        .rst(rst),
//        .start(start),
//        .I_in(I_in),
//        .Q_in(Q_in),
//        .magnitude(magnitude),
//        .done(done)
//    );

//    // Clock generation (100 MHz)
//    always #5 clk = ~clk;

//    // Test vectors
//    reg [15:0] I_values [0:9];
//    reg [15:0] Q_values [0:9];
//    reg [15:0] expected_mag [0:9];

//    integer i;

//    initial begin
//        // Initialize
//        clk = 0;
//        rst = 1;
//        start = 0;
//        I_in = 0;
//        Q_in = 0;

//        // Reset pulse
//        #20 rst = 0;

//        // Populate test cases
//        I_values[0] = 3;     Q_values[0] = 4;     expected_mag[0] = 5;
//        I_values[1] = 6;     Q_values[1] = 8;     expected_mag[1] = 10;
//        I_values[2] = 0;     Q_values[2] = 0;     expected_mag[2] = 0;
//        I_values[3] = 1;     Q_values[3] = 0;     expected_mag[3] = 1;
//        I_values[4] = 0;     Q_values[4] = 1;     expected_mag[4] = 1;
//        I_values[5] = 255;   Q_values[5] = 0;     expected_mag[5] = 255;
//        I_values[6] = 123;   Q_values[6] = 456;   expected_mag[6] = 472; // approx
//        I_values[7] = 1000;  Q_values[7] = 1000;  expected_mag[7] = 1414;
//        I_values[8] = 30000; Q_values[8] = 40000; expected_mag[8] = 50000;
//        I_values[9] = 500;   Q_values[9] = 1500;  expected_mag[9] = 1581;

//        // Loop through test cases
//        for (i = 0; i < 10; i = i + 1) begin
//            #20;
//            I_in = I_values[i];
//            Q_in = Q_values[i];

//            #10 start = 1;
//            #10 start = 0;

//            wait (done == 1);
//            $display("Test %0d: I=%d, Q=%d => Magnitude=%d (Expected: ~%d)",
//                      i+1, I_values[i], Q_values[i], magnitude, expected_mag[i]);
//        end

//        // Finish simulation
//        #50;
//        $finish;
//    end

//endmodule



//////SIGNED FRACTIONS (FIXED POINT)
//module tb_iq_magnitude_sqrt;

//    // Inputs
//    reg clk;
//    reg rst;
//    reg start;
//    reg signed [15:0] I_in;
//    reg signed [15:0] Q_in;

//    // Outputs
//    wire [15:0] magnitude;
//    wire done;

//    // Instantiate DUT
//    iq_magnitude_sqrt uut (
//        .clk(clk),
//        .rst(rst),
//        .start(start),
//        .I_in(I_in),
//        .Q_in(Q_in),
//        .magnitude(magnitude),
//        .done(done)
//    );

//    // Clock generation
//    always #5 clk = ~clk;

//    // Convert Q1.14 fixed-point to float for display
//    real mag_out;

//    initial begin
//        clk = 0;
//        rst = 1;
//        start = 0;
//        I_in = 0;
//        Q_in = 0;

//        #20 rst = 0;

//        // Test Case 1: I=3.0, Q=4.0 -> magnitude=5.0
//        I_in = 16'sd24576;  // Q1.14 representation
//        Q_in = 16'sd27852;
//        #10 start = 1;
//        #10 start = 0;
//        wait (done == 1);
//        mag_out = $itor(magnitude) / 16384;
//        $display("Test 1: I=3, Q=4 => magnitude=%d----mag_out=%.2f (Expected: 5.0))", magnitude, mag_out);
       

////        // Test Case 2: I=6.0, Q=8.0 -> magnitude=10.0
////        #20;
////        I_in = 6 * 16384;
////        Q_in = 8 * 16384;
////        #10 start = 1;
////        #10 start = 0;
////        wait (done == 1);
////        mag_out = $itor(magnitude) / 16384.0;
////        $display("Test 2: I=6, Q=8 => magnitude=%f (Expected: 10.0)", mag_out);

//        #50 $finish;
//    end
//endmodule

//q0.15 format 
//module tb_iq_magnitude_sqrt;

//    // Inputs
//    reg clk;
//    reg rst;
//    reg start;
//    reg signed [15:0] I_in;
//    reg signed [15:0] Q_in;

//    // Outputs
//    wire [15:0] magnitude;
//    wire done;

//    // Instantiate the Unit Under Test (UUT)
//    iq_magnitude_sqrt uut (
//        .clk(clk),
//        .rst(rst),
//        .start(start),
//        .I_in(I_in),
//        .Q_in(Q_in),
//        .magnitude(magnitude),
//        .done(done)
//    );

//    // Clock generation
//    always #5 clk = ~clk;

//    real mag_out;

//    initial begin
//        clk = 0;
//        rst = 1;
//        start = 0;
//        I_in = 0;
//        Q_in = 0;

//        #20 rst = 0;

//        // Test Case 1: I = 3.0, Q = 4.0 -> magnitude = 5.0
//        I_in = 16'sd98304;  // 3.0 * 32768 (Q0.15)
//        Q_in = 16'sd13107; // 4.0 * 32768 (Q0.15)
//        #10 start = 1;
//        #10 start = 0;
//        wait (done == 1);
//        mag_out = $itor(magnitude) / 32768.0;
//        $display("Test 1: I=3, Q=4 => magnitude=%d ---- mag_out=%.2f (Expected: 5.0)", magnitude, mag_out);

//        #50 $finish;
//    end
//endmodule


//handling of overflow and carry
module tb_iq_magnitude_sqrt;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg signed [15:0] I_in;
    reg signed [15:0] Q_in;

    // Outputs
    wire [15:0] magnitude;
    wire [31:0] sum_squares_safe;
    wire [32:0] sum_squares;
    wire done;

    // Instantiate DUT
    iq_magnitude_sqrt uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .I_in(I_in),
        .Q_in(Q_in),
        .magnitude(magnitude),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Convert Q0.15 fixed-point to float for display
    real mag_out;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        I_in = 0;
        Q_in = 0;

        #20 rst = 0;

        // Test Case 1: Overflow - I=1.0, Q=1.0 -> magnitude > 1.0
        I_in = 16'sd32767;  // Q0.15 representation for 1.0
        Q_in = 16'sd32767;  // Q0.15 representation for 1.0
        #10 start = 1;
        #10 start = 0;
        wait (done == 1);
        mag_out = $itor(magnitude) / 32768.0;
        $display("Test 1: I=1.0, Q=1.0 => magnitude=%d----mag_out=%.2f (Expected overflow behavior)", magnitude, mag_out);

        // Test Case 2: I=0.75, Q=0.75 -> magnitude < 1.0
        I_in = 16'sd24576;  // Q0.15 representation for 0.75
        Q_in = 16'sd24576;  // Q0.15 representation for 0.75
        #10 start = 1;
        #10 start = 0;
        wait (done == 1);
        mag_out = $itor(magnitude) / 32768.0;
        $display("Test 2: I=0.75, Q=0.75 => magnitude=%d----mag_out=%.2f (Expected: sqrt(0.75^2 + 0.75^2))", magnitude, mag_out);

        // Test Case 3: Maximum overflow (I=0.99, Q=0.99) -> magnitude > 1.0
        I_in = 16'sd32000;  // Q0.15 representation for 0.99
        Q_in = 16'sd32000;  // Q0.15 representation for 0.99
        #10 start = 1;
        #10 start = 0;
        wait (done == 1);
        mag_out = $itor(magnitude) / 32768.0;
        $display("Test 3: I=0.99, Q=0.99 => magnitude=%d----mag_out=%.2f (Expected overflow behavior)", magnitude, mag_out);
        
        I_in = 16'sd10000;  // 3.0 * 32768 (Q0.15)
        Q_in = 16'sd20000; // 4.0 * 32768 (Q0.15)
        #10 start = 1;
        #10 start = 0;
        wait (done == 1);
        mag_out = $itor(magnitude) / 32768.0;
        $display("Test 1: I=3.0, Q=4.0 => magnitude=%d----mag_out=%.2f (Expected overflow behavior)", magnitude, mag_out);


$display("sum_squares: %h, sum_squares[32]: %b, sum_squares_safe: %h", sum_squares, sum_squares[32], sum_squares_safe);

        #50 $finish;
    end
endmodule
