//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		miniCarTop
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is a top file of all mode.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module miniCarTop	(
						clk_in,
						rst,
						
						ir_in,
						time_echo,
						tubeIn,
						DHT11_data,
						speed_pulse,
						
						sr_trig,
						DCDriver_IN,
						PWM,
						ring_signal,
						
						seg_cs,
						seg_db,
						
						Test
						);

input clk_in;					//	global input clock
input rst;						//	global reset signal
input[3:0] tubeIn;			//	Four tube signal for autoTracking
input ir_in;					// HongWai control input signal(PPM)
input[2:0] time_echo;		//	Two echo signal from ultrasonic sensor
inout DHT11_data;				//	Inout signal for DHT-11 sensor
input[1:0] speed_pulse;		// Two Speed pulse form speed sensor

output sr_trig;				//	Output trig signal for ultrasonic sensor
output[7:0] DCDriver_IN;	//	Output signal for L298N power mode IN1 ~ IN7
output[3:0] PWM;				//	Output signal for L298N power mode ENA ~ END
output ring_signal;			//	Output signal for alarm / red led
output[7:0] seg_cs;			// Output cs signal for 4-7 digital seg
output[7:0] seg_db;			//	Output db signal for 4-7 digital seg

wire rst_n;
assign rst_n = ~rst;			//	rst_n low effective

wire[3:0] Action;				//	miniCar Action for mode miniCarAction
wire[3:0] Action1;			//	miniCar Action for mode carConteol
wire[3:0] Action2;			//	miniCar Action for mode autoTracking
wire[3:0] Action3;			//	miniCar Action for mode avoidObject

//	create the clock signal that all mode need
wire clk_100M;
wire clk_10M;
wire clk_1M;
wire clk_10k;
createCLK	U0		(
						.clk_in(clk_in),
						.rst_n(rst_n),
						.clk_100M(clk_100M),
						.clk_10M(clk_10M),
						.clk_1M(clk_1M),
						.clk_10k(clk_10k)
						);			

//	Use & Link all modes
wire[1:0] miniCarMode;		
wire[2:0] mode_seg_en;
wire[7:0] Frame_Data;
carControl		U1	(
						.clk_in(clk_100M),
						.rst_n(rst_n),
						.ir_in(ir_in),
						.miniCarMode(miniCarMode),
						.mode_seg_en(mode_seg_en),
						.Action(Action1),
						.Frame_Data(Frame_Data)
						);	

autoTracking 	U2	(
						.clk_in(clk_100M),
						.rst_n(rst_n),
						.tubeIn(tubeIn),
						.Action(Action2)
						);

wire[31:0] distance_data;	
avoidObject		U3	(
						.clk_in(clk_1M),
						.rst_n(rst_n),
						.time_echo(time_echo),
						.sr_trig(sr_trig),
						.distance_data(distance_data),
						.Action(Action3)
						);
				
selectAction 	U4	(
						.clk_in(clk_100M),
						.rst_n(rst_n),
						.miniCarMode(miniCarMode),
						.Action1(Action1),
						.Action2(Action2),
						.Action3(Action3),
						.Action(Action)
						);
						
miniCarAction 	U5	(
						.clk_in(clk_10k),
						.rst_n(rst_n),
						.Action(Action),
						.DCDriver_IN(DCDriver_IN),
						.PWM(PWM)
						);
						
wire[31:0] temper_data;					
temperMode		U6	(
						.clk_in(clk_10M),
						.rst_n(rst_n),
						.DHT11_data(DHT11_data),
						.data_out(temper_data),
						.ring_signal_temper(ring_signal)
						);
						
wire[31:0] speed_data;			
getSpeed			U7	(
						.clk_in(clk_1M),
						.rst_n(rst_n),
						.speed_pulse(speed_pulse),
						.speed_data(speed_data)
						);				
						
						
segOUT 			U8	(
						.clk_in(clk_10k),
						.rst_n(rst_n),
						.mode_seg_en(mode_seg_en),
						.data_in_1(temper_data),
						.data_in_2(speed_data),
						.data_in_3(distance_data),						
						.seg_cs(seg_cs),
						.seg_db(seg_db),
						.Frame_Data(Frame_Data)
						);


output[3:0] Test;				//	Output signal for test(use led)
assign Test = tubeIn;	

endmodule
