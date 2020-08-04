module Cache(clk, rst, adr, WriteDataBlock, Write, ReadData, HMbar);
input clk;
input rst;
input [14:0]adr;
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
	
	wire WriteEn [0:2**10-1];
	wire VOut [0:2**10-1];
	wire [2:0] TagOut [0:2**10-1];
	wire [31:0] W3Out [0:2**10-1];
	wire [31:0] W2Out [0:2**10-1];
	wire [31:0] W1Out [0:2**10-1];
	wire [31:0] W0Out [0:2**10-1];


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

			assign WriteEn[i] = Sel[i] & Write;
	
			Reg_1bit V_reg(
				.clk(clk),
				.rst(rst),
				.d(VInBus),
				.en(WriteEn[i]),
				.q(VOut[i])
			);

			TriState_1bit V_tri(
				.in(VOut[i]),
				.en(Sel[i]),
				.out(VOutBus)
			);

			Reg_3bit Tag_reg(
				.clk(clk),
				.rst(rst),
				.d(TagInBus),
				.en(WriteEn[i]),
				.q(TagOut[i])
			);

			TriState_3bit Tag_tri(
				.in(TagOut[i]),
				.en(Sel[i]),
				.out(TagOutBus)
			);

			Reg_32bit W3_reg(
				.clk(clk),
				.rst(rst),
				.d(W3InBus),
				.en(WriteEn[i]),
				.q(W3Out[i])
			);

			TriState_32bit W3_tri(
				.in(W3Out[i]),
				.en(Sel[i]),
				.out(W3OutBus)
			);
			
			Reg_32bit W2_reg(
				.clk(clk),
				.rst(rst),
				.d(W2InBus),
				.en(WriteEn[i]),
				.q(W2Out[i])
			);

			TriState_32bit W2_tri(
				.in(W2Out[i]),
				.en(Sel[i]),
				.out(W2OutBus)
			);

			Reg_32bit W1_reg(
				.clk(clk),
				.rst(rst),
				.d(W1InBus),
				.en(WriteEn[i]),
				.q(W1Out[i])
			);

			TriState_32bit W1_tri(
				.in(W1Out[i]),
				.en(Sel[i]),
				.out(W1OutBus)
			);

			Reg_32bit W0_reg(
				.clk(clk),
				.rst(rst),
				.d(W0InBus),
				.en(WriteEn[i]),
				.q(W0Out[i])
			);

			TriState_32bit W0_tri(
				.in(W0Out[i]),
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

	Mux4to1_32bit read_data_mux(
		.inp0(W0OutBus),
		.inp1(W1OutBus),
		.inp2(W2OutBus),
		.inp3(W3OutBus),
		.sel(WOf),
		.out(ReadData)
	);		

endmodule
