`timescale 1ns / 1ps



module my_uart_top(clk,rst_n,rs232_rx,rs232_tx,test_pin,
						RST_LCD,lcd_e,lcd_rs,lcd_rw,lcd_db,
						rotary_a,rotary_b,press,data
						);
 
input clk; // 50MHz主时钟
input rst_n;  //低电平复位信号
input rs232_rx;   // RS232接收数据信号
output rs232_tx;  //  RS232发送数据信号
output[7:0] test_pin;

input RST_LCD;
    
output lcd_e;
output lcd_rs;
output lcd_rw;
output [7:0] lcd_db;

input rotary_a;
input rotary_b;
input press; 

output [2:0] data;

wire bps_start;   //接收到数据后，波特率时钟启动信号置位
wire clk_bps;     // clk_bps的高电平为接收或者发送数据位的中间采样点
wire[7:0] rx_data_in;   //接收数据寄存器，保存直至下一个数据来到
wire[7:0] rx_data_out;

wire rx_int_in,rx_int_out;  //接收数据中断信号,接收到数据期间始终为高电平
assign test_pin = rx_data_in;
assign lcd_db[3:0] = 1;	

//----------------------------------------------------


wire[127:0] line1_buffer;
wire[127:0] line2_buffer; 


combiner combiner1(
	.rotary_a(rotary_a),
	.rotary_b(rotary_b),
	.press(press),
	.RST_LCD(RST_LCD),
	.clk(clk),
	.rx_data_in(rx_data_in),
	.rx_int_in(rx_int_in),
	.line1_buffer(line1_buffer),
	.line2_buffer(line2_buffer),
	.rx_data_out(rx_data_out),
	.rx_int_out(rx_int_out),
	.data(data)
	);
	
	
lcd16x2_ctrl lcd16x2_01 (
	.clk(clk),
	.rst(RST_LED),
	.lcd_e(lcd_e),
	.lcd_rs(lcd_rs),
	.lcd_rw(lcd_rw),
	.lcd_db(lcd_db[7:4]),
	.line1_buffer(line1_buffer),
	.line2_buffer(line2_buffer)
	);	
	
speed_select      speed_select( .clk(clk), //波特率选择模块，接收和发送模块复用，不支持全双工通信
                                .rst_n(rst_n),
                                .bps_start(bps_start),
                                .clk_bps(clk_bps)
                                       );
 
my_uart_rx        my_uart_rx(       .clk(clk), //接收数据模块
                                       .rst_n(rst_n),
                                       .rs232_rx(rs232_rx),
                                       .clk_bps(clk_bps),
                                       .bps_start(bps_start),
                                       .rx_data(rx_data_in),
                                       .rx_int(rx_int_in)
                                       );
 
my_uart_tx        my_uart_tx(       .clk(clk), //发送数据模块
                                       .rst_n(rst_n),
                                       .clk_bps(clk_bps),
                                       .rx_data(rx_data_out),
                                       .rx_int(rx_int_out),
                                       .rs232_tx(rs232_tx),
                                       .bps_start(bps_start)
                                       );
 
endmodule