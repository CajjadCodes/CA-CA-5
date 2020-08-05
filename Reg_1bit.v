module Reg_1bit(clk, rst, d, en, q);
input clk;
input rst;
input d;
input en;
output reg q;
	
	always @(posedge clk or posedge rst) begin
		if (rst) q <= 1'b0;
		else if (en) q <= d;
	end

endmodule 
