module Comparator_3bit(A, B, equal);
input [2:0] A;
input [2:0] B;
output equal;

	assign equal = (A == B)? 1'b1: 1'b0;

endmodule 