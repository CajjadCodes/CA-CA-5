module Reg_32bit(clk, rst, d, en, q);
input clk;
input rst;
input [31:0] d;
input en;
output reg [31:0] q;
	
	always @(posedge clk or posedge rst) begin
		if (rst) q <= 32'b0;
		else if (en) q <= d;
	end

endmodule 