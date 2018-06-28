//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		carControl
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is a mode for creating the miniCar action.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module carControl	(
					clk_in,
					rst_n,
					ir_in,
					miniCarMode,
					mode_seg_en,
					Frame_Data,//
					Action
					);
				
input clk_in;
input rst_n;
input ir_in;
output[1:0] miniCarMode;	//	The mode that miniCar worked (control & autoTracking & avoidObject)
output[2:0] mode_seg_en;	//	The EN signal of 4-7 digital seg
output[3:0] Action;			//	The Action of that mode
//
output[7:0] Frame_Data;

wire[7:0] Frame_Data;		//	The data that received based on FSM
HongWai		U1	(
					.clk_in(clk_in),
					.rst_n(rst_n),
					.ir_in(~ir_in),
					.frame_db(Frame_Data)
					);
				
GetAction	U2	(
					.clk_in(clk_in),
					.rst_n(rst_n),
					.Frame_Data(Frame_Data),
					.miniCarMode(miniCarMode),
					.mode_seg_en(mode_seg_en),
					.Action(Action)
					);

endmodule