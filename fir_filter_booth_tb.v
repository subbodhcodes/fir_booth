module tb_fir_booth;

reg [3:0] in_signal;  // 4-bit input signal
reg clk = 0;
reg rstn = 0;
reg en = 0;
wire [3:0] out_signal; // 4-bit output signal

// Clock generation with a period of 10 time units
always #5 clk = ~clk;

integer cnt = 0;

// Increment counter at each clock edge
always @(posedge clk) cnt = cnt + 1;

// Generate input signal based on the counter
always @(*) begin
    if (en == 1 && cnt[2:0] == 3'b111) begin
        #1;
        in_signal = cnt[3:0]; // 4-bit input
    end
end

// Instantiate the DUT (Device Under Test)
fir_filter_booth dut (
    .a(in_signal),
    .b(out_signal),
    .clk(clk),
    .rstn(rstn)
);

initial begin
    // Initialize reset and enable signals
    rstn = 0;
    #100;
    rstn = 1;
    en = 1;
    #10000;
    $finish;
end

// Monitor changes to input and output signals
initial
    $monitor("Input signal = %d, out_signal = %d", in_signal, out_signal);

// Record simulation data
initial begin
    $recordfile("test.trn");
    $recordvars();
end

endmodule
