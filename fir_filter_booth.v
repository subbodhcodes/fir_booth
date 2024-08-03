module booth_new(
    input signed [3:0] A,  
    input signed [3:0] B,    
    output reg signed [7:0] Z    
);

    reg signed [8:0] P;
    reg signed [4:0] M, M_neg;
    reg [4:0] Q; 
    integer i;

    always @* begin
        M = {A[3], A};
        M_neg = -M; 
        Q = {B, 1'b0}; 
        P = 9'b0;
        for (i = 0; i < 4; i = i + 1) begin
            case (Q[1:0])
                2'b10: P = P + {M_neg, 4'b0};
                2'b01: P = P + {M, 4'b0}; 
            endcase
            P = P >>> 1; 
            Q = Q >> 1;
        end

        Z = P[7:0]; 
    end

endmodule


module fir_filter(
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
wire signed [7:0] sum, sum1, sum2, sum3, sum4, sum5; // Intermediate sum with sufficient width
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

// module instantiation
booth_new booth1 (.A(f1), .B(c1), .Z(sum1));
booth_new booth2 (.A(f2), .B(c2), .Z(sum2));
booth_new booth3 (.A(f3), .B(c3), .Z(sum3));
booth_new booth4 (.A(f4), .B(c4), .Z(sum4));
booth_new booth5 (.A(f5), .B(c5), .Z(sum5));


//assign sum = (f1 * c1) + (f2 * c2) + (f3 * c3) + (f4 * c4) + (f5 * c5);

assign sum = sum1 + sum2 + sum3 + sum4 + sum5;

// Compute the normalization factor
assign norm = sum / (5 * avg);

// Ensure the output fits in 4 bits
assign b = norm[3:0];

endmodule
