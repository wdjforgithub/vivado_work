//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		HongWai
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is a mode that use FSM to receive PPM data.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module HongWai(
					clk_in,
					rst_n,
					ir_in,
					frame_db
					);
input clk_in;
input rst_n;
input ir_in;
output[7:0] frame_db;

wire clk_in;
wire rst_n;
wire ir_in;
reg[7:0] frame_db;


reg[15:0] irda_data;
reg[31:0] get_data;
reg[5:0] data_cnt;
reg error_flag;

//	Three reg signal, we only use 
reg irda_reg0;
reg irda_reg1;	
reg irda_reg2;
wire irda_change;
wire irda_pos_pulse;
wire irda_neg_pulse;
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		irda_reg0 <= 1'b0;
		irda_reg1 <= 1'b0;
		irda_reg2 <= 1'b0;
	end
	else
	begin
		irda_reg0 <= ir_in;
		irda_reg1 <= irda_reg0;
		irda_reg2 <= irda_reg1;
	end
end
assign irda_change = irda_pos_pulse | irda_neg_pulse;
assign irda_pos_pulse = (~irda_reg2) & irda_reg1;
assign irda_neg_pulse = irda_reg2 & (~irda_reg1);



//对0.56ms采样16次，0.56ms/16 = 35us
//clk_in T = 10ns
//35000 / 10 = 3500
//在设计中我们利用了两个counter，一个counter用于计3500次时钟主频；
//一个counter用于计算分频之后，同一种电平所scan到的点数，这个点数最后会用来判断
//是leader的9ms 还是4.5ms，或是数据的 0 还是 1。
reg[11:0] counter;
reg[8:0] counter2;
wire check_9ms;	//**		9 / 0.56 * 16
wire check_4ms;
wire low;
wire high;

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		counter <= 12'b0;
	else if (irda_change)
		counter <= 12'b0;
	else if (counter == 12'd3500)
		counter <= 12'b0;
	else
		counter <= counter + 1'b1;
end

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		counter2 <= 9'b0;
	else if (irda_change)
		counter2 <= 9'b0;
	else if (counter == 12'd3500)
		counter2 <= counter2 + 1'b1;
	else
		;
end

//为增加稳定性，取一个范围
assign check_9ms = (counter2 > 217) & (counter2 < 297);	//257 
assign check_4ms = (counter2 > 88) & (counter2 < 168);	//128
assign low = (counter2 > 6) & (counter2 < 26);				//16
assign high = (counter2 > 38) & (counter2 < 58);			//48

//------------------------------------------------------------
//状态机
reg[2:0] current_state;
reg[2:0] next_state;
parameter	IDLE			=	3'b000,
				LEADER_9		=	3'b001,
				LEADER_4		=	3'b010,
				DATA_STATE	=	3'b100;

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		current_state <= IDLE;
	else
		current_state <= next_state;
end

always@(*)
begin
	next_state = IDLE;
	case (current_state)
	IDLE:
	begin
	if (irda_reg1)////////////////////////////
		next_state = LEADER_9;
	else
		next_state = IDLE;
	end
	LEADER_9:
	begin
		if (irda_neg_pulse)
		begin
			if (check_9ms)
				next_state = LEADER_4;
			else
				next_state = IDLE;
		end
		else
			next_state = LEADER_9;
	end
	LEADER_4:
	begin
		if (irda_pos_pulse)
		begin
			if (check_4ms)
				next_state = DATA_STATE;
			else
				next_state = IDLE;
		end
		else
			next_state = LEADER_4;
	end
	DATA_STATE:
	begin
		if ((data_cnt == 6'd32) & irda_reg2 & irda_reg1)
			next_state = IDLE;
		else if (error_flag)
			next_state = IDLE;
		else
			next_state = DATA_STATE;
	end
	default:
		next_state = IDLE;
	endcase
end



//////////
reg FrameDval;
always@(*)
begin
	if (current_state == DATA_STATE)
	begin
		if ((data_cnt == 6'd32) & irda_reg2 & irda_reg1)
			FrameDval = 1'b1;
		else if (error_flag)
			FrameDval = 1'b0;
		else
			FrameDval = 1'b0;
	end
	else
		FrameDval = 1'b0;
end

wire FrameDval1;
assign FrameDval1 = FrameDval;

reg[7:0] tempData;
always@(posedge FrameDval1 or negedge rst_n)
begin
	if (!rst_n)
		tempData <= 8'b0;
	else
		tempData <= {get_data[8],get_data[9],get_data[10],get_data[11],
						get_data[12],get_data[13],get_data[14],get_data[15]};	
end





always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		data_cnt <= 6'b0;
		get_data <= 32'b0;
		error_flag <= 1'b0;
	end
	else if(current_state == IDLE)
	begin
		data_cnt <= 6'b0;
		get_data <= 32'b0;
		error_flag <= 1'b0;
	end
	else if (current_state == DATA_STATE)
	begin
		if (irda_neg_pulse)  // low 0.56ms check		///////////////////////////////////////////
		begin
			if (!low)  //error
				error_flag <= 1'b1;
		end
		else if (irda_pos_pulse)  //check 0.56ms/1.68ms data 0/1	//////////////////
		begin
			if (low)
				get_data[0] <= 1'b0;
			else if (high)
				get_data[0] <= 1'b1;
			else
				error_flag <= 1'b1;
			get_data[31:1] <= get_data[30:0];
			data_cnt <= data_cnt + 1'b1;
		end
	end
	else
		;
end


always@(*)
begin
	frame_db <= tempData[7:0];	
end



endmodule

