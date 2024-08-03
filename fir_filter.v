module fir_filter (
    input signed [3:0] a,  // 4-bit input
    output signed [3:0] b, // 4-bit output
    input clk,
    input rstn
);

parameter avg = 4'b0100;  // Use appropriate average value for 4-bit
parameter c1 = avg; // Coefficients for the filter taps
parameter c2 = avg;
parameter c3 = avg;
parameter c4 = avg;
parameter c5 = avg;

// Registers to hold the previous values of the input signal
reg signed [3:0] f1;
reg signed [3:0] f2;
reg signed [3:0] f3;
reg signed [3:0] f4;
reg signed [3:0] f5;

// Internal signals for the weighted sum and normalization
wire signed [7:0] sum; // Intermediate sum with sufficient width
wire signed [7:0] norm; // Normalized result

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        f1 <= 4'b0;
        f2 <= 4'b0;
        f3 <= 4'b0;
        f4 <= 4'b0;
        f5 <= 4'b0;
    end
    else begin
        f1 <= a;
        f2 <= f1;
        f3 <= f2;
        f4 <= f3;
        f5 <= f4;
    end
end

// Compute the weighted sum


assign sum = (f1 * c1) + (f2 * c2) + (f3 * c3) + (f4 * c4) + (f5 * c5);



// Compute the normalization factor
assign norm = sum / (5 * avg);

// Ensure the output fits in 4 bits
assign b = norm[3:0];

endmodule
