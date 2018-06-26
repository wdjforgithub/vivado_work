//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		PWM
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is PWM mode.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module PWM	(
				clk_in,
				rst_n,
				PWM_Mark_Space_Ratio,
				
				PWM_Signal
				);
				
input clk_in;
input rst_n;
input[7:0] PWM_Mark_Space_Ratio;
output PWM_Signal;

wire clk_in;
wire rst_n;
wire[7:0] PWM_Mark_Space_Ratio;
reg PWM_Signal;

wire clk;
reg[7:0] cnt;

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		PWM_Signal <= 1'b0;
	else
	begin
		if (cnt < PWM_Mark_Space_Ratio)
			PWM_Signal <= 1'b1;
		else
			PWM_Signal <= 1'b0;
	end
end

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		cnt <= 1'b0;
	else if (cnt < 99)
		cnt <= cnt + 1'b1;
	else
		cnt <= 1'b0;
end

endmodule

