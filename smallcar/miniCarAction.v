//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		miniCarAction
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is a driver for L298N power mode.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module miniCarAction	(
							clk_in,
							rst_n,
							Action,
							
							DCDriver_IN,
							PWM
							);
						
input clk_in;
input rst_n;
input[3:0] Action;
output[7:0] DCDriver_IN;
output[3:0] PWM;

wire clk_in;
wire rst_n;
wire[3:0] Action;
reg[7:0] DCDriver_IN;
reg[3:0] PWM;

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

//	The mark space ratio of left cycle and right cycle.
reg[7:0] PWM_Left_Mark_Space_Ratio;
reg[7:0] PWM_Right_Mark_Space_Ratio;

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		DCDriver_IN[7:0] = 8'b0000_0000;
		PWM_Left_Mark_Space_Ratio  <= 8'd0;
		PWM_Right_Mark_Space_Ratio <= 8'd0;
	end
	else
		case(Action)
		Straight_Slow:	//轮子正转，左右占空比均为50%
		begin
			DCDriver_IN[7:0] = 8'b1010_1010;
			PWM_Left_Mark_Space_Ratio  <= 8'd50;
			PWM_Right_Mark_Space_Ratio <= 8'd50;
		end
		Straight_Norm:	//轮子正转，左右占空比均为70%
		begin
			DCDriver_IN[7:0] = 8'b1010_1010;
			PWM_Left_Mark_Space_Ratio  <= 8'd70;
			PWM_Right_Mark_Space_Ratio <= 8'd70;
		end
		Straight_Fast:	//轮子正转，左右占空比均为99%
		begin
			DCDriver_IN[7:0] = 8'b1010_1010;
			PWM_Left_Mark_Space_Ratio  <= 8'd99;
			PWM_Right_Mark_Space_Ratio <= 8'd99;
		end
		Turn_Left:	//左侧轮子转速慢，右侧转速快，实现左转
		begin
			DCDriver_IN[7:0] = 8'b1010_1010;
			PWM_Left_Mark_Space_Ratio  <= 8'd60;//0
			PWM_Right_Mark_Space_Ratio <= 8'd90; //60
		end
		Turn_Right:	//右侧轮子转速慢，左侧转速快，实现右转
		begin
			DCDriver_IN[7:0] = 8'b1010_1010;
			PWM_Left_Mark_Space_Ratio  <= 8'd60; //60
			PWM_Right_Mark_Space_Ratio <= 8'd0; //0
		end
		sTurn_Left:	//左侧轮子转速很慢，右侧转速快，实现急左转
		begin
			DCDriver_IN[7:0] = 8'b1010_1010;
			PWM_Left_Mark_Space_Ratio  <= 8'd0;
			PWM_Right_Mark_Space_Ratio <= 8'd90;
		end
		sTurn_Right:	//右侧轮子转速很慢，左侧转速快，实现急右转
		begin
			DCDriver_IN[7:0] = 8'b1010_1010;
			PWM_Left_Mark_Space_Ratio  <= 8'd90;
			PWM_Right_Mark_Space_Ratio <= 8'd0;
		end
		Reverse_Left:		//左侧轮子反转，右侧轮子正传，实现反转
		begin
			DCDriver_IN[7:0] = 8'b0110_0110;
			PWM_Left_Mark_Space_Ratio  <= 8'd90;
			PWM_Right_Mark_Space_Ratio <= 8'd90;
		end
		Reverse_Right:		//右侧轮子反转，左侧轮子正传，实现反转
		begin
			DCDriver_IN[7:0] = 8'b1001_1001;
			PWM_Left_Mark_Space_Ratio  <= 8'd90;
			PWM_Right_Mark_Space_Ratio <= 8'd90;
		end
		Retreat:		//轮子反转
		begin
			DCDriver_IN[7:0] = 8'b0101_0101;
			PWM_Left_Mark_Space_Ratio  <= 8'd90;
			PWM_Right_Mark_Space_Ratio <= 8'd90;
		end
		Stop:
		begin
			DCDriver_IN[7:0] = 8'b0000_0000;
			PWM_Left_Mark_Space_Ratio  <= 8'd0;
			PWM_Right_Mark_Space_Ratio <= 8'd0;
		end
		default:	
		begin
			DCDriver_IN[7:0] = 8'b1010_1010;
			PWM_Left_Mark_Space_Ratio  <= 8'd50;
			PWM_Right_Mark_Space_Ratio <= 8'd50;
		end
		endcase
end


wire PWM_Left;
wire PWM_Right;

PWM	U1	(
			.clk_in(clk_in),
			.rst_n(rst_n),
			.PWM_Mark_Space_Ratio(PWM_Left_Mark_Space_Ratio),
			.PWM_Signal(PWM_Left)
			);
			
PWM	U2	(
			.clk_in(clk_in),
			.rst_n(rst_n),
			.PWM_Mark_Space_Ratio(PWM_Right_Mark_Space_Ratio),
			.PWM_Signal(PWM_Right)
			);
			
			
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		PWM[3:0] <= 4'b0000;
	else
	begin
		PWM[3] <= PWM_Left;
		PWM[2] <= PWM_Right;
		PWM[1] <= PWM_Left;
		PWM[0] <= PWM_Right;		
	end
end			


endmodule
