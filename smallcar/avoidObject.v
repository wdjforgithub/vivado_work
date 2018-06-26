//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		avoidObject
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is a mode for using three ultrasonic sensor to judge
//							whether there hava a object in the front way and get the
//							distance between miniCar and object.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module avoidObject(
						clk_in,
						rst_n,
						time_echo,
						sr_trig,
						distance_data,
						Action
						);
				
input clk_in;
input rst_n;
input[2:0] time_echo;

output sr_trig;
output[3:0] Action;
output[31:0] distance_data;

reg sr_trig;
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

//	create BCD count clock. In this clock, a period for about 1cm
wire clk_avoid;			
divFrequence	U8	(
						.clk_in(clk_in),
						.rst_n(rst_n),
						.divConstant(12'd58),
						.clk_out(clk_avoid)
						);
						
wire[15:0] BCD_distancd_data;
getBCDDistData	U9	(
						.clk_in(clk_avoid),
						.rst_n(rst_n),
						.time_echo(time_echo[2]),
						.sr_data(BCD_distancd_data)
						);	
//	The output distance data(BCD) to 4-7 seg					
assign distance_data = {16'hFFFF,BCD_distancd_data};

//	create the trig signal that ultrasonic sensor need (12us)		
reg[15:0] cnt_trig;
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		cnt_trig <= 16'd0;
		sr_trig <= 1'b0;
	end
	else
		if (cnt_trig == 16'hFFFF)
		begin
			cnt_trig <= 16'd0;
			sr_trig <= 1'b1;
		end
		else if (cnt_trig == 16'd12)
		begin
			cnt_trig <= cnt_trig + 1'b1;
			sr_trig <= 1'b0;
		end
		else
			cnt_trig <= cnt_trig + 1'b1;		
end
						
wire[15:0] sr_data2;	//	Front
wire[15:0] sr_data1;	//	Left
wire[15:0] sr_data0;	//	Right
getDistanceData	U1	(
						.clk_in(clk_in),
						.rst_n(rst_n),
						.time_echo(time_echo[2]),
						.sr_data(sr_data2)
						);	
						
getDistanceData	U2	(
						.clk_in(clk_in),
						.rst_n(rst_n),
						.time_echo(time_echo[1]),
						.sr_data(sr_data1)
						);	
						
getDistanceData	U3	(
						.clk_in(clk_in),
						.rst_n(rst_n),
						.time_echo(time_echo[0]),
						.sr_data(sr_data0)
						);	


parameter distance_1 = 16'd1300;		//	17cm
parameter distance_2 = 16'd2500;		//	42.5cm
reg[5:0] isObject;
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		isObject <= 6'b00_00_00;			// init for reset
	else
	begin
		if (sr_data2 <= distance_1)
		begin
			if (sr_data1 <= distance_2 && sr_data0 > distance_2)
				isObject <= 6'b01_10_00;	//	need to reverse right
			else if (sr_data1 > distance_2 && sr_data0 <= distance_2)
				isObject <= 6'b01_00_10;	// need to reverse left
			else
				isObject <= 6'b01_11_11;	//	need to reverse_left/right
		end
		else if (sr_data2 <= distance_2)
		begin
			if (sr_data1 <= distance_2 && sr_data0 <= distance_2)
				isObject <= 6'b10_10_10;	// need to reverse
			else if (sr_data1 <= distance_2 && sr_data0 > distance_2)
				isObject <= 6'b10_10_00;	//	need to turn right
			else if (sr_data1 > distance_2 && sr_data0 <= distance_2)
				isObject <= 6'b10_00_10;	//	need to turn left
			else
				isObject <= 6'b10_00_00;	//	need to turn left/right
		end
		else
			isObject <= 6'b00_11_11;
	end
end

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		Action <= Stop;
	else
		case(isObject)
		6'b00_11_11:	Action <= Straight_Fast;
		
		6'b01_10_00:	Action <= Reverse_Right;
		6'b01_00_10:	Action <= Reverse_Left;
		6'b01_11_11:	Action <= Reverse_Left;
		
		6'b10_10_10:	Action <= Reverse_Left;
		6'b10_10_00:	Action <= sTurn_Right;
		6'b10_10_10:	Action <= sTurn_Left;
		6'b10_00_00:	Action <= sTurn_Left;
		default:			Action <= Straight_Norm;//Stop
		endcase
end

endmodule
