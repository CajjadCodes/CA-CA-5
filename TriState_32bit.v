module TriState_32bit(in, en, out);
input [31:0]in;
input en;
output [31:0]out;

	assign out = en ? in : 32'bz;

endmodule