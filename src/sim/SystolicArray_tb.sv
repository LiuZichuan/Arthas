`timescale 1ns / 1ps
module SystolicArray_tb();
	parameter nBanks = 2;
	parameter nCols = 4;
	parameter nRows = 3;
	parameter iWidth = 16;
	parameter oWidth = 33;
	parameter MAX_nPERIOD = 8;
	parameter MAX_nLMAC = 12288;
	parameter MAX_nSHFT = 192;
	parameter CLK_PERIOD = 10;
	parameter PROCESSING_CYC = 2000;
	parameter CONF_REG_LEN = 25;
	parameter dfsm_config_nPreiod = 2;
	parameter dfsm_config_nLMAC = 9;
	parameter dfsm_config_nSHFT = 3;
	parameter dfsm_config_bit = 8390915;
	// inputs
	reg clk, rst, start, in_en, pe_config_load, dfsm_config_en, dfsm_config;
	reg pe_config_1_1;
	reg pe_config_1_2;
	reg pe_config_1_3;
	reg pe_config_2_1;
	reg pe_config_2_2;
	reg pe_config_2_3;
	reg [15:0] weight_1_1;
	reg [15:0] weight_1_2;
	reg [15:0] weight_1_3;
	reg [15:0] weight_2_1;
	reg [15:0] weight_2_2;
	reg [15:0] weight_2_3;
	reg [15:0] feature_1;
	reg [15:0] feature_2;
	reg [15:0] feature_3;
	reg [15:0] feature_4;
	reg [15:0] feature_5;
	reg [15:0] feature_6;

	// outputs
	wire [32:0] dout;
	wire [32:0] dout_1_1;
	wire [32:0] dout_1_2;
	wire [32:0] dout_1_3;
	wire [32:0] dout_1_4;
	wire [32:0] dout_2_1;
	wire [32:0] dout_2_2;
	wire [32:0] dout_2_3;
	wire [32:0] dout_2_4;
	wire dout_en_1;
	wire dout_en_2;
	wire dout_en_3;
	wire dout_en_4;

	// clk
	always #(CLK_PERIOD/2) clk = ~clk;

	reg processing;
	integer inEnId;
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
	integer outputId_1_1;
	integer outputId_1_2;
	integer outputId_1_3;
	integer outputId_1_4;
	integer outputId_2_1;
	integer outputId_2_2;
	integer outputId_2_3;
	integer outputId_2_4;

	initial begin
		clk = 0; rst = 0; in_en = 0; start = 0; processing = 0;
		pe_config_load = 0; dfsm_config_en = 0; dfsm_config = 0;
		feature_1 = 0;
		feature_2 = 0;
		feature_3 = 0;
		feature_4 = 0;
		feature_5 = 0;
		feature_6 = 0;
		weight_1_1 = 0;
		weight_1_2 = 0;
		weight_1_3 = 0;
		weight_2_1 = 0;
		weight_2_2 = 0;
		weight_2_3 = 0;
		pe_config_1_1 = 1;
		pe_config_1_2 = 1;
		pe_config_1_3 = 1;
		pe_config_2_1 = 1;
		pe_config_2_2 = 1;
		pe_config_2_3 = 1;
		inEnId = $fopen("D:/tmp/arthas/in_en.dat", "r");
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
		outputId_1_1 = $fopen("D:/tmp/arthas/output_1_1.rst", "wt");
		outputId_1_2 = $fopen("D:/tmp/arthas/output_1_2.rst", "wt");
		outputId_1_3 = $fopen("D:/tmp/arthas/output_1_3.rst", "wt");
		outputId_1_4 = $fopen("D:/tmp/arthas/output_1_4.rst", "wt");
		outputId_2_1 = $fopen("D:/tmp/arthas/output_2_1.rst", "wt");
		outputId_2_2 = $fopen("D:/tmp/arthas/output_2_2.rst", "wt");
		outputId_2_3 = $fopen("D:/tmp/arthas/output_2_3.rst", "wt");
		outputId_2_4 = $fopen("D:/tmp/arthas/output_2_4.rst", "wt");
		force U.fsm_1.configs[24:0] = 25'd8390915;
		force U.fsm_2.configs[24:0] = 25'd8390915;
		force U.fsm_3.configs[24:0] = 25'd8390915;
		force U.fsm_4.configs[24:0] = 25'd8390915;
		force U.bank_1.p_1_1.active = 1;
		force U.bank_1.p_1_2.active = 1;
		force U.bank_1.p_1_3.active = 1;
		force U.bank_1.p_1_4.active = 1;
		force U.bank_1.p_2_1.active = 1;
		force U.bank_1.p_2_2.active = 1;
		force U.bank_1.p_2_3.active = 1;
		force U.bank_1.p_2_4.active = 1;
		force U.bank_1.p_3_1.active = 1;
		force U.bank_1.p_3_2.active = 1;
		force U.bank_1.p_3_3.active = 1;
		force U.bank_1.p_3_4.active = 1;
		force U.bank_2.p_1_1.active = 1;
		force U.bank_2.p_1_2.active = 1;
		force U.bank_2.p_1_3.active = 1;
		force U.bank_2.p_1_4.active = 1;
		force U.bank_2.p_2_1.active = 1;
		force U.bank_2.p_2_2.active = 1;
		force U.bank_2.p_2_3.active = 1;
		force U.bank_2.p_2_4.active = 1;
		force U.bank_2.p_3_1.active = 1;
		force U.bank_2.p_3_2.active = 1;
		force U.bank_2.p_3_3.active = 1;
		force U.bank_2.p_3_4.active = 1;
		#(10*CLK_PERIOD)
		rst = 1; start = 1;
		#(CLK_PERIOD)
		start = 0;
		processing = 1;
		# (PROCESSING_CYC*CLK_PERIOD)
		processing = 0;
		$fclose(inEnId);
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
		$fclose(outputId_1_1);
		$fclose(outputId_1_2);
		$fclose(outputId_1_3);
		$fclose(outputId_1_4);
		$fclose(outputId_2_1);
		$fclose(outputId_2_2);
		$fclose(outputId_2_3);
		$fclose(outputId_2_4);
	end
	
	reg in_en_rd;
	integer status;
	always@(posedge clk) begin
		if(~rst) begin
			in_en <= 0;
			feature_1 <= 0;
			feature_2 <= 0;
			feature_3 <= 0;
			feature_4 <= 0;
			feature_5 <= 0;
			feature_6 <= 0;
			weight_1_1 <= 0;
			weight_1_2 <= 0;
			weight_1_3 <= 0;
			weight_2_1 <= 0;
			weight_2_2 <= 0;
			weight_2_3 <= 0;
		end
		else begin
			if (processing && !$feof(inEnId)) begin
				status = $fscanf(inEnId, "%b\n", in_en_rd);
				in_en <= in_en_rd;
				if (in_en_rd) begin
					status = $fscanf(featureId_1, "%b\n", feature_1);
					status = $fscanf(featureId_2, "%b\n", feature_2);
					status = $fscanf(featureId_3, "%b\n", feature_3);
					status = $fscanf(featureId_4, "%b\n", feature_4);
					status = $fscanf(featureId_5, "%b\n", feature_5);
					status = $fscanf(featureId_6, "%b\n", feature_6);
					status = $fscanf(weightId_1_1, "%b\n", weight_1_1);
					status = $fscanf(weightId_1_2, "%b\n", weight_1_2);
					status = $fscanf(weightId_1_3, "%b\n", weight_1_3);
					status = $fscanf(weightId_2_1, "%b\n", weight_2_1);
					status = $fscanf(weightId_2_2, "%b\n", weight_2_2);
					status = $fscanf(weightId_2_3, "%b\n", weight_2_3);
				end
				else begin
					feature_1 <= 0;
					feature_2 <= 0;
					feature_3 <= 0;
					feature_4 <= 0;
					feature_5 <= 0;
					feature_6 <= 0;
					weight_1_1 <= 0;
					weight_1_2 <= 0;
					weight_1_3 <= 0;
					weight_2_1 <= 0;
					weight_2_2 <= 0;
					weight_2_3 <= 0;
				end
			end
		end
	end

	always@(posedge clk) begin
		if (dout_en_1) begin
			$fwrite(outputId_1_1,"%b\n", dout_1_1);
		end
	end

	always@(posedge clk) begin
		if (dout_en_2) begin
			$fwrite(outputId_1_2,"%b\n", dout_1_2);
		end
	end

	always@(posedge clk) begin
		if (dout_en_3) begin
			$fwrite(outputId_1_3,"%b\n", dout_1_3);
		end
	end

	always@(posedge clk) begin
		if (dout_en_4) begin
			$fwrite(outputId_1_4,"%b\n", dout_1_4);
		end
	end

	always@(posedge clk) begin
		if (dout_en_1) begin
			$fwrite(outputId_2_1,"%b\n", dout_2_1);
		end
	end

	always@(posedge clk) begin
		if (dout_en_2) begin
			$fwrite(outputId_2_2,"%b\n", dout_2_2);
		end
	end

	always@(posedge clk) begin
		if (dout_en_3) begin
			$fwrite(outputId_2_3,"%b\n", dout_2_3);
		end
	end

	always@(posedge clk) begin
		if (dout_en_4) begin
			$fwrite(outputId_2_4,"%b\n", dout_2_4);
		end
	end

	SystolicArray # (.iWidth(iWidth), .oWidth(oWidth), .nBanks(nBanks), .nRows(nRows), .nCols(nCols), .MAX_nPERIOD(MAX_nPERIOD), .MAX_nLMAC(MAX_nLMAC), .MAX_nSHFT(MAX_nSHFT)) U (.clk(clk), .rst(rst), .in_en(in_en), .start(start), .pe_config_1_1(pe_config_1_1), .pe_config_1_2(pe_config_1_2), .pe_config_1_3(pe_config_1_3), .pe_config_2_1(pe_config_2_1), .pe_config_2_2(pe_config_2_2), .pe_config_2_3(pe_config_2_3), .weight_1_1(weight_1_1), .weight_1_2(weight_1_2), .weight_1_3(weight_1_3), .weight_2_1(weight_2_1), .weight_2_2(weight_2_2), .weight_2_3(weight_2_3), .feature_1(feature_1), .feature_2(feature_2), .feature_3(feature_3), .feature_4(feature_4), .feature_5(feature_5), .feature_6(feature_6), .dout_1_1(dout_1_1), .dout_1_2(dout_1_2), .dout_1_3(dout_1_3), .dout_1_4(dout_1_4), .dout_2_1(dout_2_1), .dout_2_2(dout_2_2), .dout_2_3(dout_2_3), .dout_2_4(dout_2_4), .dout_en_1(dout_en_1), .dout_en_2(dout_en_2), .dout_en_3(dout_en_3), .dout_en_4(dout_en_4), .dfsm_config_en(dfsm_config_en), .dfsm_config(dfsm_config), .pe_config_load(pe_config_load));

endmodule
