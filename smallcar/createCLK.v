//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		27/06/2014
// Project Name:		miniCar
// Module Name:		createCLK
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is a mode for creating clock that the system need.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module createCLK	(
						clk_in,
						rst_n,
						clk_100M,
						clk_10M,
						clk_1M,
						clk_10k
						);
						
input clk_in;
input rst_n;
output clk_100M;
output clk_10M;
output clk_1M;
output clk_10k;

divFrequence	D1	(
						.clk_in(clk_in),
						.rst_n(rst_n),
						.divConstant(12'd10),
						.clk_out(clk_10M)
						);

divFrequence	D2	(
						.clk_in(clk_in),
						.rst_n(rst_n),
						.divConstant(12'd100),
						.clk_out(clk_1M)
						);
						
divFrequence	D3	(
						.clk_in(clk_1M),
						.rst_n(rst_n),
						.divConstant(12'd100),
						.clk_out(clk_10k)
						);
						
assign clk_100M = clk_in;

endmodule
