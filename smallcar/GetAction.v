//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		GetAction
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is a mode for judging miniCar's Action from the data
//							that HongWai mode received.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module GetAction	(
						clk_in,
						rst_n,
						Frame_Data,
						miniCarMode,
						mode_seg_en,
						Action
						);
						
input clk_in;
input rst_n;
input[7:0] Frame_Data;
output[1:0] miniCarMode;
output[2:0] mode_seg_en;
output[3:0] Action;

wire clk_in;
wire rst_n;
wire[7:0] Frame_Data;
reg[1:0] miniCarMode;
reg[1:0] mode_seg_en;
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
	begin
		Action <= Stop;
		miniCarMode <= 2'b00;//b11 test wangdongjian
	end
	else
		case(Frame_Data)
		8'h45:	
		begin
			Action <= Straight_Fast;
			miniCarMode <= 2'b00;	//	default control mode
			mode_seg_en <= 3'b010;	// default speed seg out 
		end
		8'h40:	if (miniCarMode == 2'b00)	Action <= Straight_Fast;	else	;
		8'h07:	if (miniCarMode == 2'b00)	Action <= Turn_Left;			else	;
		8'h09:	if (miniCarMode == 2'b00)	Action <= Turn_Right;		else	;
		8'h16:	if (miniCarMode == 2'b00)	Action <= sTurn_Left;		else	;
		8'h0D:	if (miniCarMode == 2'b00)	Action <= sTurn_Right;		else	;
		8'h43:	if (miniCarMode == 2'b00)	Action <= Reverse_Left;		else	;
		8'h44:	if (miniCarMode == 2'b00)	Action <= Reverse_Right;	else	;
		8'h19:	if (miniCarMode == 2'b00)	Action <= Retreat;			else	;
		8'h15:	if (miniCarMode == 2'b00)	Action <= Stop;				else	;
		8'h47:	Action <= Stop;		
		8'h42:	miniCarMode <= 2'b00;
		8'h52:	miniCarMode <= 2'b01;
		8'h4A:	miniCarMode <= 2'b10;
		8'h0C:	mode_seg_en <= 3'b011;
		8'h18:	mode_seg_en <= 3'b010;
		8'h5E:	mode_seg_en <= 3'b001;
		8'h5A:	mode_seg_en <= 3'b000; 
		default:	
		begin
			Action <= Stop;
			miniCarMode <= 2'b00;//b11 test wangdongjian
			mode_seg_en <= 3'b010;//000
		end
		endcase
end

endmodule
