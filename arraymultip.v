module ArrayMultiplier (
  input clk, rst,
  input [15:0] operand_a,
  input [15:0] operand_b,
  output reg [31:0] result
);

  reg [31:0] temp_result;
  reg [15:0] i, j;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      temp_result <= 0;
    end else begin
      temp_result <= 0;
      for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
          if ((i + j) < 16) begin
            temp_result = temp_result + (operand_a[i] & operand_b[j]) << (i + j);
          end
        end
      end
//result <= temp_result;
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      result <= 0;
    end else begin
      result <= temp_result;
    end
  end

endmodule