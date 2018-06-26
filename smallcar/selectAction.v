//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		selectAction
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is a mux mode.
//							Select Action data according to miniCar mode.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module selectAction(
							clk_in,
							rst_n,
							miniCarMode,
							Action1,
							Action2,
							Action3,
							
							Action
							);
							
input clk_in;
input rst_n;
input[1:0] miniCarMode;
input[3:0] Action1;
input[3:0] Action2;
input[3:0] Action3;
output[3:0] Action;

wire clk_in;
wire rst_n;
wire[1:0] miniCarMode;
wire[3:0] Action1;
wire[3:0] Action2;
wire[3:0] Action3;
reg[3:0] Action;

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		Action <= 4'b1111;
	else
		case(miniCarMode)
		2'b00:	Action <= Action1;
		2'b01:	Action <= Action2;
		2'b10:	Action <= Action3;
		2'b11:	Action <= 4'b1111;
		endcase
end

endmodule
