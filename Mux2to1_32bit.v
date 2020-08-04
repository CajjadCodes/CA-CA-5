module Mux2to1_32bit(inp0, inp1, sel, out);
input [31:0] inp0;
input [31:0] inp1;
input sel;
output [31:0] out;

	assign out = (sel == 1'b0)? inp0:
			(sel == 1'b1)? inp1:
			32'bz;
	
endmodule
