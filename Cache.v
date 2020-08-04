module Cache(clk, rst, adr, WriteDataBlock, Write, ReadData, HMbar);
input clk;
input rst;
input [15:0]adr;
input [127:0]WriteDataBlock;
input Write;
output [31:0]ReadData;
output HMbar;

	wire [2:0]Tag;
	wire [9:0]Index;
	wire [1:0]WOf;
	wire [0:2**10-1]Sel;
	wire VInBus,VOutBus;
	wire [2:0]TagInBus, TagOutBus;
	wire [31:0]W3InBus, W3OutBus, W2InBus, W2OutBus, W1InBus, W1OutBus, W0InBus, W0OutBus;

	assign Tag = adr[14:12];
	assign Index = adr[11:2];
	assign WOf = adr[1:0];
	assign VInBus = Write;
	assign TagInBus = Tag;
	assign W3InBus = WriteDataBlock[127:96];
	assign W2InBus = WriteDataBlock[95:64];
	assign W1InBus = WriteDataBlock[63:32];
	assign W0InBus = WriteDataBlock[31:0];

	DCD_10bit index_decoder(
		.sel(Index),
		.out(Sel)
	);

	genvar i;
	generate
		for(i = 0; i < 2 ** 10; i = i + 1) begin
			Reg_1bit V_reg(
				.clk(clk),
				.rst(rst),
				.d(VInBus),
				.en(Write),
				.q(VOut)
			);

			TriState_1bit V_tri(
				.in(VOut),
				.en(Sel[i]),
				.out(VOutBus)
			);

			Reg_3bit Tag_reg(
				.clk(clk),
				.rst(rst),
				.d(TagInBus),
				.en(Write),
				.q(TagOut)
			);

			TriState_3bit Tag_tri(
				.in(TagOut),
				.en(Sel[i]),
				.out(TagOutBus)
			);

			Reg_32bit W3_reg(
				.clk(clk),
				.rst(rst),
				.d(W3InBus),
				.en(Write),
				.q(W3Out)
			);

			TriState_32bit W3_tri(
				.in(W3Out),
				.en(Sel[i]),
				.out(W3OutBus)
			);
			
			Reg_32bit W2_reg(
				.clk(clk),
				.rst(rst),
				.d(W2InBus),
				.en(Write),
				.q(W2Out)
			);

			TriState_32bit W2_tri(
				.in(W2Out),
				.en(Sel[i]),
				.out(W2OutBus)
			);

			Reg_32bit W1_reg(
				.clk(clk),
				.rst(rst),
				.d(W1InBus),
				.en(Write),
				.q(W1Out)
			);

			TriState_32bit W1_tri(
				.in(W1Out),
				.en(Sel[i]),
				.out(W1OutBus)
			);

			Reg_32bit W0_reg(
				.clk(clk),
				.rst(rst),
				.d(W0InBus),
				.en(Write),
				.q(W0Out)
			);

			TriState_32bit W0_tri(
				.in(W0Out),
				.en(Sel[i]),
				.out(W0OutBus)
			);
		end
	endgenerate

	wire Tag_equal;
	Comparator_3bit Tag_comparator(
		.A(TagInBus),
		.B(TagOutBus),
		.equal(Tag_equal)
	);

	assign HMbar = VOutBus & Tag_equal;

	Mux4to1_32bit(
		.inp0(W0OutBus),
		.inp1(W1OutBus),
		.inp2(W2OutBus),
		.inp3(W3OutBus),
		.sel(WOf),
		.out(ReadData)
	);		

endmodule
