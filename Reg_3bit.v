module Reg_3bit(clk, rst, d, en, q);
input clk;
input rst;
input [2:0] d;
input en;
output reg [2:0] q;
	
	always @(posedge clk or posedge rst) begin
		if (rst) q <= 3'b0;
		else if (en) q <= d;
	end

endmodule 