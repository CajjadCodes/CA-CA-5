module DCD_10bit(sel, out);
input [9:0]sel;
output reg[0:2**10-1]out;

	always@(sel) begin
		out = 2**10'b0;
		out[sel] = 1'b1;
	end

endmodule