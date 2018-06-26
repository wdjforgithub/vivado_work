//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		27/06/2014
// Project Name:		miniCar
// Module Name:		getTemperature
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		The function of this mode is get the temperature and humidiy
//							data.FSM.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module getTemperature(
							clk_in,
							rst_n,
							DHT11_data,
							sample_en,
							temperature,
							humidity,
							ring_signal_temper
							);
					
input clk_in;
input rst_n;
inout DHT11_data;
input sample_en;
output[7:0] temperature;
output[7:0] humidity;
output ring_signal_temper;

wire clk_in;
wire rst_n;
wire sample_en;
reg[7:0] temperature;
reg[7:0] humidity;
reg ring_signal_temper;

//	Get sample signal and use that signal in FSM
reg sample_en_reg1, sample_en_reg2;
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)	begin
		sample_en_reg1 <= 1'b0;
		sample_en_reg2 <= 1'b0;;
	end
	else	begin
		sample_en_reg1 <= sample_en;
		sample_en_reg2 <= sample_en_reg1;
	end
end
wire sample_pos_pulse = sample_en_reg1 & (~sample_en_reg2);

//	Get the posedge of DHT-11 data signal
reg data_reg1, data_reg2;
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)	begin
		data_reg1 <= 1'b0;
		data_reg2 <= 1'b0;;
	end
	else	begin
		data_reg1 <= DHT11_data;
		data_reg2 <= data_reg1;
	end
end
wire data_pos_pulse = data_reg1 & (~data_reg2);

//	The config of inout signal DHT-11 data
reg link = 0;
reg data_reg = 1;
assign DHT11_data		= link ? data_reg : 1'bz;

//	FSM
reg[39:0] get_data;
reg[2:0] state = 0;
parameter	IDLE 				= 3'b000,
				Start				= 3'b001,
				Master_Start	= 3'b010,
				Master_Delay	= 3'b011,
				DHT_Response	= 3'b100,
				Data_Ready		= 3'b101,
				Data_Receive	= 3'b110;
			
reg[31:0] cnt_delay;			// The count of delay
reg[5:0] cnt_rx;				//	The count of received data
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		get_data <= 40'd0;
		state <= IDLE;
	end
	else
	case(state)
	IDLE:
	begin
		link <= 1'b0;
		data_reg <= 1'b1;
		cnt_delay <= cnt_delay + 1'b1;
		if (cnt_delay == 32'd20000000)	begin
			cnt_delay <= 0;
			state <= Start;
		end
	end
	Start:
	begin
		if (sample_pos_pulse)	begin
			link <= 1'b1;
			data_reg <= 1'b0;
			state <= Master_Start;
		end
		else	;
	end
	Master_Start:			//	18ms
	begin	
		cnt_delay <= cnt_delay + 1'b1;
		if (cnt_delay == 32'd180000)	begin
			cnt_delay <= 32'd0;
			link <= 1'b0;
			data_reg <= 1'b1;
			state <= Master_Delay;
		end
	end
	Master_Delay:			//	40us
	begin
		cnt_delay <= cnt_delay + 1'b1;
		if (cnt_delay == 32'd400)	begin
			cnt_delay <= 32'd0;
			state <= DHT_Response;
		end
	end
	DHT_Response:
	begin
		if (data_pos_pulse)	begin
			get_data <= 40'd0;
			cnt_rx <= 6'd0;
			state <= Data_Ready;
		end
	end
	Data_Ready:
	begin
		if (data_pos_pulse)	begin
			cnt_delay <= 32'd0;
			state <= Data_Receive;
		end
	end
	Data_Receive:
	begin
		cnt_delay <= cnt_delay + 1'b1;
		if (cnt_delay == 32'd400)	begin
			cnt_delay <= 32'd0;
			cnt_rx <= cnt_rx + 1'b1;
			if (DHT11_data)
				get_data <= {get_data[38:0],1'b1};
			else
				get_data <= {get_data[38:0],1'b0};
			if (cnt_rx == 6'd39)	begin
				cnt_rx <= 6'd0;
				state <= Start;
			end
			else
				state <= Data_Ready;
		end				
	end
	default:		state <= IDLE;
	endcase
end

//	Get Data
always@(*)
begin
	if (state == Start)	begin
		temperature	<= get_data[23:16];
		humidity		<= get_data[39:32];
	end
end

//	create alarm signal if the temperature exceeds the threshold
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		ring_signal_temper <= 1'b0;
	else if (temperature > 8'd30)
		ring_signal_temper <= 1'b1;
	else
		ring_signal_temper <= 1'b0;
end


endmodule
