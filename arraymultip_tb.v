module arraymultip_tb;
reg clk, rst;
reg [15:0] operand_a;
reg [15:0] operand_b;
wire [31:0] result;
ArrayMultiplier a1(clk,rst,operand_a,operand_b,result);
//clk = 0;
always #5 clk = ~clk;
initial begin
#10 rst = 1;
#10
rst = 0;
operand_a = 16'b1111111111111111;
operand_b = 16'b1111111111111111;
end
endmodule

