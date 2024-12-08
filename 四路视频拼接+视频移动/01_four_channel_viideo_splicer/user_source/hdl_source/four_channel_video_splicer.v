/*
 * @Author: bit_stream 
 * @Date: 2024-12-07 16:02:48 
 * @Last Modified by: bit_stream
 * @Last Modified time: 2024-12-07 17:06:43
 */

module four_channel_viideo_splicer#(
    parameter AXI_DATA_WIDTH = 256,
    parameter AXI_ADDR_WIDTH = 29
)
(

	//ddr ip signal
    input   wire            O_axi_clk   ,
    input   wire            pll_locked  ,

    //uart ctrl signal
    
    //pll signal
	input	wire        clk_75m,
	input	wire        S_pll_lock,//pll ok
    //hdmi in siganl


	input	wire 			I0_clk		,
	input	wire 			I0_vtc_vs		,
	input	wire 			I0_vtc_data_valid,
	input	wire [31:0]		I0_vtc_data	,	

	input	wire 			I1_clk		,
	input	wire 			I1_vtc_vs		,
	input	wire 			I1_vtc_data_valid,
	input	wire [31:0]		I1_vtc_data	,	

	input	wire 			I2_clk		,
	input	wire 			I2_vtc_vs		,
	input	wire 			I2_vtc_data_valid,
	input	wire [31:0]		I2_vtc_data	,	

	input	wire 			I3_clk		,
	input	wire 			I3_vtc_vs		,
	input	wire 			I3_vtc_data_valid,
	input	wire [31:0]		I3_vtc_data	,	



	 //fdma signal
	output	wire [AXI_ADDR_WIDTH-1:  0]       fdma_waddr_split , 
	output	wire                              fdma_wareq_split , 
	output	wire [15: 0]                      fdma_wsize_split , 
	input	wire                              fdma_wbusy_split,
	output	wire [AXI_DATA_WIDTH-1 : 0]       fdma_wdata_split , 
	input	wire                             fdma_wvalid_split,

	
	output	wire [AXI_ADDR_WIDTH-1:  0]        fdma_raddr_split,  
    output	wire                               fdma_rareq_split,  
    output	wire [15: 0]                       fdma_rsize_split,                                
    input	wire                               fdma_rbusy_split, 			
    input	wire [AXI_DATA_WIDTH-1 : 0]        fdma_rdata_split, 
    input	wire                              fdma_rvalid_split, 

    //hdmi out siganl
	output	wire 			O_vtc_vs		,
	output	wire 			O_vtc_de_valid,
	output	wire [31:0]		O_vtc_data		
);



wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr_0;   //FDMA写通道地址
wire                             fdma_wareq_0;   //synthesis keep
wire [15: 0]                     fdma_wsize_0;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy_0;   //synthesis keep
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata_0;   //FDMA写数据
wire                            fdma_wvalid_0; //synthesis keep

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr_1;   //FDMA写通道地址
wire                             fdma_wareq_1;   //synthesis keep
wire [15: 0]                     fdma_wsize_1;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy_1;   //synthesis keep	
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata_1;   //FDMA写数据
wire                            fdma_wvalid_1;  //synthesis keep


wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr_2;   //FDMA写通道地址
wire                             fdma_wareq_2;  //synthesis keep
wire [15: 0]                     fdma_wsize_2;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy_2;   //synthesis keep	
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata_2;   //FDMA写数据
wire                            fdma_wvalid_2;  //synthesis keep

wire [AXI_ADDR_WIDTH-1:  0]      fdma_waddr_3;   //FDMA写通道地址
wire                             fdma_wareq_3;  //synthesis keep
wire [15: 0]                     fdma_wsize_3;   //FDMA写通道一次FDMA的传输大小                                       
wire                             fdma_wbusy_3;   //synthesis keep	
wire [AXI_DATA_WIDTH-1 : 0]      fdma_wdata_3;   //FDMA写数据
wire                            fdma_wvalid_3;  //synthesis keep









wire [7:0] wbuf_sync_0,rbuf_sync_0;//用于切换帧缓存
wire [7:0] wbuf_sync_1,rbuf_sync_1;//用于切换帧缓存
wire [7:0] wbuf_sync_2,rbuf_sync_2;//用于切换帧缓存
wire [7:0] wbuf_sync_3,rbuf_sync_3;//用于切换帧缓存

//----对输入进来的数据打一拍

reg 		I0_vtc_vs_dly;
reg 		I0_vtc_data_valid_dly;
reg [31:0]	I0_vtc_data_dly;

always @(posedge I0_clk)begin
	I0_vtc_vs_dly 		  <= I0_vtc_vs;
	I0_vtc_data_valid_dly <= I0_vtc_data_valid;
	I0_vtc_data_dly       <= I0_vtc_data;
end

reg 		I1_vtc_vs_dly;
reg 		I1_vtc_data_valid_dly;
reg [31:0]	I1_vtc_data_dly;

always @(posedge I1_clk)begin
	I1_vtc_vs_dly 		  <= I1_vtc_vs;
	I1_vtc_data_valid_dly <= I1_vtc_data_valid;
	I1_vtc_data_dly       <= I1_vtc_data;
end

reg 		I2_vtc_vs_dly;
reg 		I2_vtc_data_valid_dly;
reg [31:0]	I2_vtc_data_dly;

always @(posedge I2_clk)begin
	I2_vtc_vs_dly 		  <= I2_vtc_vs;
	I2_vtc_data_valid_dly <= I2_vtc_data_valid;
	I2_vtc_data_dly       <= I2_vtc_data;
end

reg 		I3_vtc_vs_dly;
reg 		I3_vtc_data_valid_dly;
reg [31:0]	I3_vtc_data_dly;

always @(posedge I3_clk)begin
	I3_vtc_vs_dly 		  <= I3_vtc_vs;
	I3_vtc_data_valid_dly <= I3_vtc_data_valid;
	I3_vtc_data_dly       <= I3_vtc_data;
end


	

wire       	vs_data_sample_0; 
wire       	de_data_sample_0; 
wire  [31:0]wr_data_sample_0; 

//把视频从1280*720 缩放至 640*360

down_samping_2x2 #(
	.H_SIZE 	( 1280  ),
	.V_SIZE 	( 720  )
)
u0_down_samping_2x2
(
	.I_clk    	( I0_clk     ),
	.I_rst_n  	( S_pll_lock  ),
	.I_rgb_vs 	( I0_vtc_vs_dly  ),
	.I_rgb_de 	( I0_vtc_data_valid_dly  ),
	.I_rgb_data  ( I0_vtc_data_dly ),
	.O_rgb_vs 	( vs_data_sample_0  ),
	.O_rgb_de 	( de_data_sample_0  ),
	.O_rgb_data ( wr_data_sample_0  )
);



wire       	vs_data_sample_1;
wire       	de_data_sample_1;
wire  [31:0]wr_data_sample_1;


down_samping_2x2 #(
	.H_SIZE 	( 1280  ),
	.V_SIZE 	( 720  )
)
u1_down_samping_2x2
(
	.I_clk    	( I1_clk     ),
	.I_rst_n  	( S_pll_lock  ),
	.I_rgb_vs 	( I1_vtc_vs_dly  ),
	.I_rgb_de 	( I1_vtc_data_valid_dly  ),
	.I_rgb_data ( I1_vtc_data_dly ),
	.O_rgb_vs 	( vs_data_sample_1  ),
	.O_rgb_de 	( de_data_sample_1  ),
	.O_rgb_data ( wr_data_sample_1   )

);


wire       	vs_data_sample_2;
wire       	de_data_sample_2;
wire  [31:0]wr_data_sample_2;


down_samping_2x2 #(
	.H_SIZE 	( 1280  ),
	.V_SIZE 	( 720  )
)
u2_down_samping_2x2
(
	.I_clk    	( I2_clk     ),
	.I_rst_n  	( S_pll_lock  ),
	.I_rgb_vs 	( I2_vtc_vs_dly  ),
	.I_rgb_de 	( I2_vtc_data_valid_dly  ),
	.I_rgb_data ( I2_vtc_data_dly ),
	.O_rgb_vs 	( vs_data_sample_2  ),
	.O_rgb_de 	( de_data_sample_2  ),
	.O_rgb_data ( wr_data_sample_2   )

);


wire       	vs_data_sample_3;
wire       	de_data_sample_3;
wire  [31:0]wr_data_sample_3;





down_samping_2x2 #(
	.H_SIZE 	( 1280  ),
	.V_SIZE 	( 720  )
)
u3_down_samping_2x2
(
	.I_clk    	( I3_clk     ),
	.I_rst_n  	( S_pll_lock  ),
	.I_rgb_vs 	( I3_vtc_vs_dly  ),
	.I_rgb_de 	( I3_vtc_data_valid_dly  ),
	.I_rgb_data ( I3_vtc_data_dly ),
	.O_rgb_vs 	( vs_data_sample_3  ),
	.O_rgb_de 	( de_data_sample_3  ),
	.O_rgb_data ( wr_data_sample_3   )

);




// outports wire

wire [15:0] 	O_wr_data_sample_0;

wr_width_convert u0_wr_width_convert(
	.I_wr_data       	( wr_data_sample_0        ),
	.O_wr_data       	( O_wr_data_sample_0        )
);

wire [15:0]I_rd_data_0;

rd_width_convert u0_rd_width_convert(
	.O_rd_data       	( O_vtc_data        ),
	.I_rd_data       	( I_rd_data_0        )
);



//--------第一路视频 降采样后的数据读写DDR-------------
uidbuf# (
.VIDEO_ENABLE(1'b1),  
.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

.W_BUFDEPTH(1024),
.W_DATAWIDTH(16),
.W_BASEADDR(0),  
.W_DSIZEBITS(25),
.W_XSIZE(640), 
.W_XSTRIDE(1280),
.W_YSIZE(360),
.W_XDIV(1),
.W_BUFSIZE(3),

.R_BUFDEPTH(2048), 
.R_DATAWIDTH(16),
.R_BASEADDR(0),
.R_DSIZEBITS(25),
.R_XSIZE(1280),
.R_XSTRIDE(1280),
.R_YSIZE(720), 
.R_XDIV(1),
.R_BUFSIZE(3)
)
uidbuf_u0
(
.I_ui_clk(O_axi_clk),
.I_ui_rstn(pll_locked ),

.I_W_FS(vs_data_sample_0),
.I_W_clk(I0_clk),
.I_W_wren(de_data_sample_0),
.I_W_data(O_wr_data_sample_0), 
.O_W_sync_cnt(wbuf_sync_0),
.I_W_buf(wbuf_sync_0),
.O_W_full(),

.I_R_FS(O_vtc_vs),
.I_R_clk(clk_75m),
.I_R_rden(O_vtc_de_valid),
.O_R_data(I_rd_data_0),
.O_R_sync_cnt(),
.I_R_buf(rbuf_sync_0),
.O_R_empty(),
       
.O_fdma_waddr(  fdma_waddr_0)  ,
.O_fdma_wareq(  fdma_wareq_0)  ,
.O_fdma_wsize(  fdma_wsize_0)  ,                                     
.I_fdma_wbusy(  fdma_wbusy_0)  ,			
.O_fdma_wdata(  fdma_wdata_0)  ,
.I_fdma_wvalid(fdma_wvalid_0),
.O_fdma_raddr(  fdma_raddr_split)  ,
.O_fdma_rareq(  fdma_rareq_split)  ,
.O_fdma_rsize(  fdma_rsize_split)  ,                                     
.I_fdma_rbusy(  fdma_rbusy_split)  ,			
.I_fdma_rdata(  fdma_rdata_split)	 ,
.I_fdma_rvalid(fdma_rvalid_split)
 ); 

//设置3帧缓存，读延迟写1帧
uisetvbuf#(
.BUF_DELAY(1),
.BUF_LENTH(3)
)
uisetvbuf_u0
(
.I_bufn(wbuf_sync_0),
.O_bufn(rbuf_sync_0)
);   




wire [15:0] 	O_wr_data_sample_1;

wr_width_convert u1_wr_width_convert(
	.I_wr_data       	( wr_data_sample_1        ),
	.O_wr_data       	( O_wr_data_sample_1        )
);



//--------第二路视频 降采样后的数据读写DDR-------------
uidbuf_only_w# (
.VIDEO_ENABLE(1'b1),  
.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

.W_BUFDEPTH(1024),
.W_DATAWIDTH(16),
.W_BASEADDR(1280),  
.W_DSIZEBITS(25),
.W_XSIZE(640), 
.W_XSTRIDE(1280),
.W_YSIZE(360), //  占用的地址空间大小为640*360*2=460,800,目前的地址使用到921,600
.W_XDIV(1),
.W_BUFSIZE(3)
)
uidbuf_u1
(
.I_ui_clk(O_axi_clk),
.I_ui_rstn(pll_locked),

.I_W_FS(vs_data_sample_1),
.I_W_clk(I1_clk),
.I_W_wren(de_data_sample_1),
.I_W_data(O_wr_data_sample_1), 
.O_W_sync_cnt(wbuf_sync_1),
.I_W_buf(wbuf_sync_1),
.O_W_full(),

.O_fdma_waddr(  fdma_waddr_1)  ,
.O_fdma_wareq(  fdma_wareq_1)  ,
.O_fdma_wsize(  fdma_wsize_1)  ,                                     
.I_fdma_wbusy(  fdma_wbusy_1)  ,			
.O_fdma_wdata(  fdma_wdata_1)  ,
.I_fdma_wvalid(fdma_wvalid_1)
 ); 






wire [15:0] 	O_wr_data_sample_2;

wr_width_convert u2_wr_width_convert(
	.I_wr_data       	( wr_data_sample_2        ),
	.O_wr_data       	( O_wr_data_sample_2        )
);




//--------第三路视频 降采样后的数据读写DDR-------------
uidbuf_only_w# (
.VIDEO_ENABLE(1'b1),  
.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

.W_BUFDEPTH(1024),//写FIFO 的实际深度为W_BUFDEPTH*2 
.W_DATAWIDTH(16),
.W_BASEADDR(921600),  
.W_DSIZEBITS(25),
.W_XSIZE(640), 
.W_XSTRIDE(1280),
.W_YSIZE(360), //  占用的地址空间大小为640*360*2=460,800,目前的地址使用到1,382,400
.W_XDIV(1),
.W_BUFSIZE(3)

)
uidbuf_u2
(
.I_ui_clk(O_axi_clk),
.I_ui_rstn(pll_locked),
.I_W_FS(vs_data_sample_2),
.I_W_clk(I2_clk),
.I_W_wren(de_data_sample_2),
.I_W_data(O_wr_data_sample_2), 
.O_W_sync_cnt(wbuf_sync_2),
.I_W_buf(wbuf_sync_2),
.O_W_full(),

       
.O_fdma_waddr(  fdma_waddr_2)  ,
.O_fdma_wareq(  fdma_wareq_2)  ,
.O_fdma_wsize(  fdma_wsize_2)  ,                                     
.I_fdma_wbusy(  fdma_wbusy_2)  ,			
.O_fdma_wdata(  fdma_wdata_2)  ,
.I_fdma_wvalid(fdma_wvalid_2)
 ); 





wire [15:0] 	O_wr_data_sample_3;

wr_width_convert u3_wr_width_convert(
	.I_wr_data       	( wr_data_sample_3        ),
	.O_wr_data       	( O_wr_data_sample_3        )
);




//--------第四路视频 降采样后的数据读写DDR-------------

uidbuf_only_w# (
.VIDEO_ENABLE(1'b1),  
.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),

.W_BUFDEPTH(1024),
.W_DATAWIDTH(16),
.W_BASEADDR(922880),  
.W_DSIZEBITS(25),
.W_XSIZE(640), 
.W_XSTRIDE(1280),
.W_YSIZE(360), //  占用的地址空间大小为640*360*2,目前的地址使用到1,843,200
.W_XDIV(1),
.W_BUFSIZE(3)
)
uidbuf_u3
(
.I_ui_clk(O_axi_clk),
.I_ui_rstn(pll_locked),
.I_W_FS(vs_data_sample_3),
.I_W_clk(I3_clk),
.I_W_wren(de_data_sample_3),
.I_W_data(O_wr_data_sample_3), 
.O_W_sync_cnt(wbuf_sync_3),
.I_W_buf(wbuf_sync_3),
.O_W_full(),

       
.O_fdma_waddr(  fdma_waddr_3)  ,
.O_fdma_wareq(  fdma_wareq_3)  ,
.O_fdma_wsize(  fdma_wsize_3)  ,                                     
.I_fdma_wbusy(  fdma_wbusy_3)  ,			
.O_fdma_wdata(  fdma_wdata_3)  ,
.I_fdma_wvalid(fdma_wvalid_3)
 ); 








uidbufw_interconnect #(
.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH)
)
 u_uidbufw_interconnect(
	.ui_clk        	( O_axi_clk         ),
	.ui_rstn       	( pll_locked),
	.fdma_waddr_1  	(  fdma_waddr_0   ),
	.fdma_wareq_1  	(  fdma_wareq_0   ),
	.fdma_wsize_1  	(  fdma_wsize_0   ),
	.fdma_wbusy_1  	(  fdma_wbusy_0   ),
	.fdma_wdata_1  	(  fdma_wdata_0   ),
	.fdma_wvalid_1 	( fdma_wvalid_0  ),
	.fdma_waddr_2  	(  fdma_waddr_1   ),
	.fdma_wareq_2  	(  fdma_wareq_1   ),
	.fdma_wsize_2  	(  fdma_wsize_1   ),
	.fdma_wbusy_2  	(  fdma_wbusy_1   ),
	.fdma_wdata_2  	(  fdma_wdata_1   ),
	.fdma_wvalid_2 	( fdma_wvalid_1  ),
	.fdma_waddr_3  	(  fdma_waddr_2   ),
	.fdma_wareq_3  	(  fdma_wareq_2   ),
	.fdma_wsize_3  	(  fdma_wsize_2   ),
	.fdma_wbusy_3  	(  fdma_wbusy_2   ),
	.fdma_wdata_3  	(  fdma_wdata_2   ),
	.fdma_wvalid_3 	( fdma_wvalid_2  ),
	.fdma_waddr_4  	(  fdma_waddr_3   ),
	.fdma_wareq_4  	(  fdma_wareq_3   ),
	.fdma_wsize_4  	(  fdma_wsize_3   ),
	.fdma_wbusy_4  	(  fdma_wbusy_3   ),
	.fdma_wdata_4  	(  fdma_wdata_3   ),
	.fdma_wvalid_4 	( fdma_wvalid_3  ),
	.fdma_waddr    	(  fdma_waddr_split  ),
	.fdma_wareq    	(  fdma_wareq_split  ),
	.fdma_wsize    	(  fdma_wsize_split  ),
	.fdma_wbusy    	(  fdma_wbusy_split  ),
	.fdma_wdata    	(  fdma_wdata_split  ),
	.fdma_wvalid   	( fdma_wvalid_split    )
);




uivtc#(
	.H_ActiveSize  	( 1280            ),
	.H_FrameSize   	( 1280+110+40+220 ),
	.H_SyncStart   	( 1280+110         ),
	.H_SyncEnd     	( 1280+110+40      ),
	.V_ActiveSize  	( 720             ),
	.V_FrameSize   	( 720+5+5+20      ),
	.V_SyncStart   	( 720+5           ),
	.V_SyncEnd     	( 720+5+5         )
)
 u_uivtc
(
	.I_vtc_rstn    	    ( S_pll_lock          	),
	.I_vtc_clk     	    ( clk_75m           	),
	.O_vtc_vs      	    ( O_vtc_vs      		),
	.O_vtc_de_valid     ( O_vtc_de_valid     )
);



















endmodule