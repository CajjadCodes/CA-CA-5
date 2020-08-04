module TriState_3bit(in, en, out);
input [2:0]in;
input en;
output [2:0]out;

	assign out = en ? in : 3'bz;

endmodule