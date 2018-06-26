//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		27/06/2014
// Project Name:		miniCar
// Module Name:		temperMode
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is DHT-11 mode. It can get temperature and humidity data
//							based on FSM.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module temperMode	(
						clk_in,
						rst_n,
						DHT11_data,
						data_out,
						ring_signal_temper
						);
				
input clk_in;
input rst_n;
inout DHT11_data;
output[31:0] data_out;
output ring_signal_temper;

wire sample_en;
createEn			U1	(
						.clk_in(clk_in),
						.rst_n(rst_n),
						.sample_en(sample_en)
						);
						
wire[7:0] temperature;
wire[7:0] humidity;
getTemperature	U2	(
						.clk_in(clk_in),
						.rst_n(rst_n),
						.DHT11_data(DHT11_data),
						.sample_en(sample_en),
						.temperature(temperature),
						.humidity(humidity),
						.ring_signal_temper(ring_signal_temper)
						);
				
wire[31:0] data_all;
wire[1:0] h1, h2;		
bin2BCD			B1	(
						.A(humidity),
						.TENS_ONES(data_all[31:24]),
						.HUNDREDS(h1)
						);
				
bin2BCD			B2	(
						.A(temperature),
						.TENS_ONES(data_all[15:8]),
						.HUNDREDS(h2)
						);
						
assign data_out = {8'hFF,data_all[15:8],8'hFF,data_all[31:24]};

endmodule

