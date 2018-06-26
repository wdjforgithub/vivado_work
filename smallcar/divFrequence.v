//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		divFrequence
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This mode is created to divide the frequence of clock signal.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None				
//
//////////////////////////////////////////////////////////////////////////////////
module divFrequence	(
							clk_in,
							rst_n,
							divConstant,
							clk_out
							);

input clk_in;
input rst_n;
input[11:0] divConstant;
output clk_out;

wire clk_in;
wire rst_n;
wire[11:0] divConstant;					//	Input of constant of divide
reg clk_out;

reg[11:0] cnt;
reg[11:0] N;
always@(*)
	N <= {1'b0,divConstant[11:1]};	// N = divConstant / 2

//	create the output signal(clk_out)	
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		clk_out <= 1'b0;
		cnt <= 12'd1;
	end
	else
		if (cnt < N)
			cnt <= cnt + 1'b1;
		else if (cnt == N)
		begin
			clk_out <= ~clk_out;
			cnt <= 12'b1;
		end
		else
			;
end

endmodule
