`timescale 1ns / 1ps



module my_uart_top(clk,rst_n,rs232_rx,rs232_tx,test_pin,
						RST_LCD,lcd_e,lcd_rs,lcd_rw,lcd_db,
						rotary_a,rotary_b,press,data
						);
 
input clk; // 50MHz��ʱ��
input rst_n;  //�͵�ƽ��λ�ź�
input rs232_rx;   // RS232���������ź�
output rs232_tx;  //  RS232���������ź�
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

wire bps_start;   //���յ����ݺ󣬲�����ʱ�������ź���λ
wire clk_bps;     // clk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м������
wire[7:0] rx_data_in;   //�������ݼĴ���������ֱ����һ����������
wire[7:0] rx_data_out;

wire rx_int_in,rx_int_out;  //���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ
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
	
speed_select      speed_select( .clk(clk), //������ѡ��ģ�飬���պͷ���ģ�鸴�ã���֧��ȫ˫��ͨ��
                                .rst_n(rst_n),
                                .bps_start(bps_start),
                                .clk_bps(clk_bps)
                                       );
 
my_uart_rx        my_uart_rx(       .clk(clk), //��������ģ��
                                       .rst_n(rst_n),
                                       .rs232_rx(rs232_rx),
                                       .clk_bps(clk_bps),
                                       .bps_start(bps_start),
                                       .rx_data(rx_data_in),
                                       .rx_int(rx_int_in)
                                       );
 
my_uart_tx        my_uart_tx(       .clk(clk), //��������ģ��
                                       .rst_n(rst_n),
                                       .clk_bps(clk_bps),
                                       .rx_data(rx_data_out),
                                       .rx_int(rx_int_out),
                                       .rs232_tx(rs232_tx),
                                       .bps_start(bps_start)
                                       );
 
endmodule