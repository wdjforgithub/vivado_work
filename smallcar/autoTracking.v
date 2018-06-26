//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		autoTracking
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is a mode for judging four tube sensor input, and then
//							output the Action signal.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module autoTracking(
							clk_in,
							rst_n,
							tubeIn,
							Action
							);
input clk_in;
input rst_n;
input[3:0] tubeIn;

output[3:0] Action;

wire clk_in;
wire rst_n;
wire[3:0] tubeIn;
reg[3:0] Action;

parameter	Straight_Slow	= 4'h1,	//	run straight
				Straight_Norm	= 4'h2,	//	run straight
				Straight_Fast	= 4'h3,	//	run straight
				Turn_Left		= 4'h4,	//	turn left
				Turn_Right		= 4'h5,	//	turn right
				sTurn_Left 		= 4'h6,	//	quickly turn left
				sTurn_Right		= 4'h7,	//	quickly turn right
				Reverse_Left	= 4'h8,	//	revese from left
				Reverse_Right	= 4'h9,	//	revese from right
				Retreat			= 4'hA,	//	go back
				Accelerate 		= 4'hB,	//	speed up
				Decelerate		= 4'hC,	//	slow down
				Stop				= 4'hF;	//	stop

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		Action[3:0] <= Stop;
	else
		case(tubeIn)
		4'b0100:		Action <= Straight_Slow;
		4'b1000:		Action <= sTurn_Left;
		4'b0010:		Action <= sTurn_Right;
		4'b0011:		Action <= sTurn_Right;
		4'b1100:		Action <= sTurn_Left;//Reverse_Left;
		4'b1111:		Action <= Stop;
		default:		Action <= Action;
		endcase
end

endmodule
