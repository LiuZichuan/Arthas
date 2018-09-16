`timescale 1ns / 1ps
module SystolicArray_v2_tb();
	parameter CLK_PERIOD = 10;
	parameter PROCESSING_CYC = 2000;
	parameter nBanks = 2;
	parameter nCols = 4;
	parameter nRows = 3;
	parameter iWidth = 16;
	parameter oWidth = 33;
	parameter DFSM_MAX_nPERIOD = 512;
	parameter DFSM_MAX_nLMAC = 3072;
	parameter DFSM_MAX_nSHFT = 3;
	parameter SSP_MAX_nPeriod = 262144;
	parameter QUABUF_MAX_nDATA = 1024;
	parameter QUABUF_MAX_nCOL = 3;
	parameter QUABUF_MAX_nPERIOD = 65536;
	parameter QUABUF_MAX_nREP = 1024;
	parameter SINGBUF_MAX_nDATA = 1024;
	parameter SINGBUF_MAX_nPERIOD = 65536;

	localparam SSP_MAX_nData = nCols;
	localparam DFSM_CONFIGBIT_WIDTH = $clog2(DFSM_MAX_nPERIOD) + $clog2(DFSM_MAX_nLMAC) + $clog2(DFSM_MAX_nSHFT);
	localparam SSP_CONFIGBIT_WIDTH = $clog2(SSP_MAX_nData) + $clog2(SSP_MAX_nPeriod);
	localparam QUABUF_CONFIGBIT_WIDTH = $clog2(QUABUF_MAX_nDATA) + $clog2(QUABUF_MAX_nCOL) + $clog2(QUABUF_MAX_nREP) + $clog2(QUABUF_MAX_nPERIOD);
	localparam SINGBUF_CONFIGBIT_WIDTH = $clog2(SINGBUF_MAX_nDATA) + $clog2(SINGBUF_MAX_nPERIOD);
	localparam MODE_CONV = 0; localparam MODE_MM = 1;

	// inputs
	logic clk, clk_mem, rst, start,  mode_conv_mm, isac, isrelu, isbn, w_in_en, f_in_en, bn_in_en;
	logic [DFSM_CONFIGBIT_WIDTH-1:0] dfsm_config;
	logic [SSP_CONFIGBIT_WIDTH-1:0] ssp_config;
	logic [QUABUF_CONFIGBIT_WIDTH-1:0] quabuf_config;
	logic [SINGBUF_CONFIGBIT_WIDTH-1:0] singbuf_config;
	logic pe_config_1_1;
	logic pe_config_1_2;
	logic pe_config_1_3;
	logic pe_config_2_1;
	logic pe_config_2_2;
	logic pe_config_2_3;
	logic [15:0] data_horz_1_1;
	logic [15:0] data_horz_1_2;
	logic [15:0] data_horz_1_3;
	logic [15:0] data_horz_2_1;
	logic [15:0] data_horz_2_2;
	logic [15:0] data_horz_2_3;
	logic [15:0] data_obli_1;
	logic [15:0] data_obli_2;
	logic [15:0] data_obli_3;
	logic [15:0] data_obli_4;
	logic [15:0] data_obli_5;
	logic [15:0] data_obli_6;
	logic [65:0] data_bn_1;
	logic [65:0] data_bn_2;

	// outputs
	logic [32:0] dout_1;
	logic [32:0] dout_2;
	logic dout_en_1;
	logic dout_en_2;
	logic data_obli_wrdy_1;
	logic data_obli_wrdy_2;
	logic data_obli_wrdy_3;
	logic data_obli_wrdy_4;
	logic data_obli_wrdy_5;
	logic data_obli_wrdy_6;
	logic data_horz_wrdy_1_1;
	logic data_horz_wrdy_1_2;
	logic data_horz_wrdy_1_3;
	logic data_horz_wrdy_2_1;
	logic data_horz_wrdy_2_2;
	logic data_horz_wrdy_2_3;
	logic data_bn_wrdy_1;
	logic data_bn_wrdy_2;

	// clk
	always #(CLK_PERIOD/2) clk = ~clk;

	reg processing;
	integer wInEnId;
	integer fInEnId;
	integer bnInEnId;
	integer featureId_1;
	integer featureId_2;
	integer featureId_3;
	integer featureId_4;
	integer featureId_5;
	integer featureId_6;
	integer weightId_1_1;
	integer weightId_1_2;
	integer weightId_1_3;
	integer weightId_2_1;
	integer weightId_2_2;
	integer weightId_2_3;
	integer batchnormId_1;
	integer batchnormId_2;
	integer outputId_1;
	integer outputId_2;
	integer nWread;
	integer nFread;
	integer nBNread;

	initial begin
		clk = 0; rst = 0; clk_mem = 0; start = 0; processing = 0; nWread = 0; nFread = 0; nBNread = 0;
		dfsm_config = 65635;
		quabuf_config = 38'd206225543176;
		ssp_config = 12;
		singbuf_config = 4097;
		mode_conv_mm = 0;
		isac = 1;
		isrelu = 1;
		isbn = 1;
		pe_config_1_1 = 1;
		pe_config_1_2 = 1;
		pe_config_1_3 = 1;
		pe_config_2_1 = 1;
		pe_config_2_2 = 1;
		pe_config_2_3 = 1;
		data_obli_1 = 0;
		data_obli_2 = 0;
		data_obli_3 = 0;
		data_obli_4 = 0;
		data_obli_5 = 0;
		data_obli_6 = 0;
		data_horz_1_1 = 0;
		data_horz_1_2 = 0;
		data_horz_1_3 = 0;
		data_horz_2_1 = 0;
		data_horz_2_2 = 0;
		data_horz_2_3 = 0;
		data_bn_1 = 0;
		data_bn_2 = 0;
		wInEnId = $fopen("D:/tmp/arthas/w_in_en.dat", "r");
		fInEnId = $fopen("D:/tmp/arthas/f_in_en.dat", "r");
		bnInEnId = $fopen("D:/tmp/arthas/bn_in_en.dat", "r");
		weightId_1_1 = $fopen("D:/tmp/arthas/weights_1_1.dat", "r");
		weightId_1_2 = $fopen("D:/tmp/arthas/weights_1_2.dat", "r");
		weightId_1_3 = $fopen("D:/tmp/arthas/weights_1_3.dat", "r");
		weightId_2_1 = $fopen("D:/tmp/arthas/weights_2_1.dat", "r");
		weightId_2_2 = $fopen("D:/tmp/arthas/weights_2_2.dat", "r");
		weightId_2_3 = $fopen("D:/tmp/arthas/weights_2_3.dat", "r");
		featureId_1 = $fopen("D:/tmp/arthas/features_1.dat", "r");
		featureId_2 = $fopen("D:/tmp/arthas/features_2.dat", "r");
		featureId_3 = $fopen("D:/tmp/arthas/features_3.dat", "r");
		featureId_4 = $fopen("D:/tmp/arthas/features_4.dat", "r");
		featureId_5 = $fopen("D:/tmp/arthas/features_5.dat", "r");
		featureId_6 = $fopen("D:/tmp/arthas/features_6.dat", "r");
		batchnormId_1 = $fopen("D:/tmp/arthas/batchnorms_1.dat", "r");
		batchnormId_2 = $fopen("D:/tmp/arthas/batchnorms_2.dat", "r");
		outputId_1 = $fopen("D:/tmp/arthas/output_1.rst", "wt");
		outputId_2 = $fopen("D:/tmp/arthas/output_2.rst", "wt");
		#(10*CLK_PERIOD)
		rst = 1; start = 1;
		#(CLK_PERIOD)
		start = 0;
		processing = 1;
		# (PROCESSING_CYC*CLK_PERIOD)
		processing = 0;
		$fclose(wInEnId);
		$fclose(fInEnId);
		$fclose(weightId_1_1);
		$fclose(weightId_1_2);
		$fclose(weightId_1_3);
		$fclose(weightId_2_1);
		$fclose(weightId_2_2);
		$fclose(weightId_2_3);
		$fclose(featureId_1);
		$fclose(featureId_2);
		$fclose(featureId_3);
		$fclose(featureId_4);
		$fclose(featureId_5);
		$fclose(featureId_6);
		$fclose(batchnormId_1);
		$fclose(batchnormId_2);
		$fclose(outputId_1);
		$fclose(outputId_2);
	end
	

	reg w_in_en_rd;
	reg f_in_en_rd;
	reg bn_in_en_rd;
	reg [65:0] data_bn_rd_1;
	reg [65:0] data_bn_rd_2;

	reg [15:0] data_obli_rd_1;
	reg [15:0] data_obli_rd_2;
	reg [15:0] data_obli_rd_3;
	reg [15:0] data_obli_rd_4;
	reg [15:0] data_obli_rd_5;
	reg [15:0] data_obli_rd_6;

	reg [16:0] data_horz_rd_1_1;
	reg [16:0] data_horz_rd_1_2;
	reg [16:0] data_horz_rd_1_3;
	reg [16:0] data_horz_rd_2_1;
	reg [16:0] data_horz_rd_2_2;
	reg [16:0] data_horz_rd_2_3;

	integer status;

	always@(posedge clk) begin
		if(~rst) begin
			w_in_en <= 0;
			data_horz_1_1 <= 0;
			data_horz_1_2 <= 0;
			data_horz_1_3 <= 0;
			data_horz_2_1 <= 0;
			data_horz_2_2 <= 0;
			data_horz_2_3 <= 0;
		end
		else begin
			if (data_horz_wrdy_1_1 & data_horz_wrdy_1_2 & data_horz_wrdy_1_3 & data_horz_wrdy_2_1 & data_horz_wrdy_2_2 & data_horz_wrdy_2_3 & processing && !$feof(wInEnId)) begin
				status = $fscanf(wInEnId, "%b\n", w_in_en_rd);
				w_in_en <= w_in_en_rd;
				nWread = nWread + 1;
				if (w_in_en_rd) begin
					status = $fscanf(weightId_1_1, "%b\n", data_horz_rd_1_1);
					status = $fscanf(weightId_1_2, "%b\n", data_horz_rd_1_2);
					status = $fscanf(weightId_1_3, "%b\n", data_horz_rd_1_3);
					status = $fscanf(weightId_2_1, "%b\n", data_horz_rd_2_1);
					status = $fscanf(weightId_2_2, "%b\n", data_horz_rd_2_2);
					status = $fscanf(weightId_2_3, "%b\n", data_horz_rd_2_3);
					data_horz_1_1 <= data_horz_rd_1_1;
					data_horz_1_2 <= data_horz_rd_1_2;
					data_horz_1_3 <= data_horz_rd_1_3;
					data_horz_2_1 <= data_horz_rd_2_1;
					data_horz_2_2 <= data_horz_rd_2_2;
					data_horz_2_3 <= data_horz_rd_2_3;
				end
				else begin
					data_horz_1_1 <= 0;
					data_horz_1_2 <= 0;
					data_horz_1_3 <= 0;
					data_horz_2_1 <= 0;
					data_horz_2_2 <= 0;
					data_horz_2_3 <= 0;
				end
			end
			else begin
				w_in_en <= 0;
			end
		end
	end

	always@(posedge clk) begin
		if(~rst) begin
			f_in_en <= 0;
			data_obli_1 <= 0;
			data_obli_2 <= 0;
			data_obli_3 <= 0;
			data_obli_4 <= 0;
			data_obli_5 <= 0;
			data_obli_6 <= 0;
		end
		else begin
			if (data_obli_wrdy_1 & data_obli_wrdy_2 & data_obli_wrdy_3 & data_obli_wrdy_4 & data_obli_wrdy_5 & data_obli_wrdy_6 & processing && !$feof(fInEnId)) begin
				status = $fscanf(fInEnId, "%b\n", f_in_en_rd);
				f_in_en <= f_in_en_rd;
				nFread = nFread + 1;
				if (f_in_en_rd) begin
					status = $fscanf(featureId_1, "%b\n", data_obli_rd_1);
					status = $fscanf(featureId_2, "%b\n", data_obli_rd_2);
					status = $fscanf(featureId_3, "%b\n", data_obli_rd_3);
					status = $fscanf(featureId_4, "%b\n", data_obli_rd_4);
					status = $fscanf(featureId_5, "%b\n", data_obli_rd_5);
					status = $fscanf(featureId_6, "%b\n", data_obli_rd_6);
					data_obli_1 <= data_obli_rd_1;
					data_obli_2 <= data_obli_rd_2;
					data_obli_3 <= data_obli_rd_3;
					data_obli_4 <= data_obli_rd_4;
					data_obli_5 <= data_obli_rd_5;
					data_obli_6 <= data_obli_rd_6;
				end
				else begin
					data_obli_1 <= 0;
					data_obli_2 <= 0;
					data_obli_3 <= 0;
					data_obli_4 <= 0;
					data_obli_5 <= 0;
					data_obli_6 <= 0;
				end
			end
			else begin
				f_in_en <= 0;
			end
		end
	end

	always@(posedge clk) begin
		if(~rst) begin
			bn_in_en <= 0;
			data_bn_1 <= 0;
			data_bn_2 <= 0;
		end
		else begin
			if (data_bn_wrdy_1 & data_bn_wrdy_2 & processing && !$feof(bnInEnId)) begin
				status = $fscanf(bnInEnId, "%b\n", bn_in_en_rd);
				bn_in_en <= bn_in_en_rd;
				nBNread = nBNread + 1;
				if (bn_in_en_rd) begin
					status = $fscanf(batchnormId_1, "%b\n", data_bn_rd_1);
					status = $fscanf(batchnormId_2, "%b\n", data_bn_rd_2);
					data_bn_1 <= data_bn_rd_1;
					data_bn_2 <= data_bn_rd_2;
				end
				else begin
					data_bn_1 <= 0;
					data_bn_2 <= 0;
				end
			end
			else begin
				bn_in_en <= 0;
			end
		end
	end

	always@(posedge clk) begin
		if (dout_en_1) begin
			$fwrite(outputId_1,"%b\n", dout_1);
		end
	end

	always@(posedge clk) begin
		if (dout_en_2) begin
			$fwrite(outputId_2,"%b\n", dout_2);
		end
	end

	SystolicArray_v2 # (.iWidth(iWidth), .oWidth(oWidth), .nBanks(nBanks), .nRows(nRows), .nCols(nCols), .DFSM_MAX_nPERIOD(DFSM_MAX_nPERIOD), .DFSM_MAX_nLMAC(DFSM_MAX_nLMAC), .DFSM_MAX_nSHFT(DFSM_MAX_nSHFT), .SSP_MAX_nPeriod(SSP_MAX_nPeriod), .QUABUF_MAX_nDATA(QUABUF_MAX_nDATA), .QUABUF_MAX_nCOL(QUABUF_MAX_nCOL), .QUABUF_MAX_nPERIOD(QUABUF_MAX_nPERIOD), .QUABUF_MAX_nREP(QUABUF_MAX_nREP), .SINGBUF_MAX_nPeriod(SINGBUF_MAX_nPERIOD), .SINGBUF_MAX_nDATA(SINGBUF_MAX_nDATA)) U (.clk(clk), .clk_mem(clk), .rst(rst), .start(start), .mode_conv_mm(mode_conv_mm), .isac(isac), .isrelu(isrelu), .isbn(isbn), .pe_config_1_1(pe_config_1_1), .pe_config_1_2(pe_config_1_2), .pe_config_1_3(pe_config_1_3), .pe_config_2_1(pe_config_2_1), .pe_config_2_2(pe_config_2_2), .pe_config_2_3(pe_config_2_3), .data_horz_1_1(data_horz_1_1), .data_horz_1_2(data_horz_1_2), .data_horz_1_3(data_horz_1_3), .data_horz_2_1(data_horz_2_1), .data_horz_2_2(data_horz_2_2), .data_horz_2_3(data_horz_2_3), .data_horz_in_en_1_1(w_in_en), .data_horz_in_en_1_2(w_in_en), .data_horz_in_en_1_3(w_in_en), .data_horz_in_en_2_1(w_in_en), .data_horz_in_en_2_2(w_in_en), .data_horz_in_en_2_3(w_in_en), .data_obli_1(data_obli_1), .data_obli_2(data_obli_2), .data_obli_3(data_obli_3), .data_obli_4(data_obli_4), .data_obli_5(data_obli_5), .data_obli_6(data_obli_6), .data_obli_in_en_1(f_in_en), .data_obli_in_en_2(f_in_en), .data_obli_in_en_3(f_in_en), .data_obli_in_en_4(f_in_en), .data_obli_in_en_5(f_in_en), .data_obli_in_en_6(f_in_en), .data_horz_wrdy_1_1(data_horz_wrdy_1_1), .data_horz_wrdy_1_2(data_horz_wrdy_1_2), .data_horz_wrdy_1_3(data_horz_wrdy_1_3), .data_horz_wrdy_2_1(data_horz_wrdy_2_1), .data_horz_wrdy_2_2(data_horz_wrdy_2_2), .data_horz_wrdy_2_3(data_horz_wrdy_2_3), .data_obli_wrdy_1(data_obli_wrdy_1), .data_obli_wrdy_2(data_obli_wrdy_2), .data_obli_wrdy_3(data_obli_wrdy_3), .data_obli_wrdy_4(data_obli_wrdy_4), .data_obli_wrdy_5(data_obli_wrdy_5), .data_obli_wrdy_6(data_obli_wrdy_6), .dout_1(dout_1), .dout_2(dout_2), .dout_en_1(dout_en_1), .dout_en_2(dout_en_2), .data_bn_1(data_bn_1), .data_bn_2(data_bn_2), .data_bn_we_1(bn_in_en), .data_bn_we_2(bn_in_en), .data_bn_wrdy_1(data_bn_wrdy_1), .data_bn_wrdy_2(data_bn_wrdy_2), .dfsm_config(dfsm_config), .ssp_config(ssp_config), .quabuf_config(quabuf_config), .singbuf_config(singbuf_config));

endmodule
