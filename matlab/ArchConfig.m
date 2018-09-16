%% Configure all architecture parameters with which the hardware is generated.

% the bus system parameter are fixed, do not revised.
if ~exist('rAddrWidth'), rAddrWidth = 28; end
if ~exist('rDataWidth'), rDataWidth = 64; end
if ~exist('rReqWidth'), rReqWidth = 31; end
if ~exist('wAddrWidth'), wAddrWidth = 28; end
if ~exist('wDataWidth'), wDataWidth = 64; end
if ~exist('wMaskWidth'), wMaskWidth = 8; end
if ~exist('wReqWidth'), wReqWidth = wAddrWidth + wDataWidth + wMaskWidth + 6; end

% system achitecture parameters 
if ~exist('nBanks'), nBanks = 2; end
if ~exist('nRows'), nRows = 3; end
if ~exist('nCols'), nCols = 4; end
if ~exist('iWidth'), iWidth = 8; end
if ~exist('oWidth'), oWidth = 8; end
if ~exist('DFSM_MAX_nPERIOD'), DFSM_MAX_nPERIOD = 512; end
if ~exist('DFSM_MAX_nLMAC'), DFSM_MAX_nLMAC = 3*1024; end
if ~exist('DFSM_MAX_nSHFT'), DFSM_MAX_nSHFT = 3; end
if ~exist('SSP_MAX_nPeriod'),  SSP_MAX_nPeriod = 512*512; end
if ~exist('SSP_MAX_nData'), SSP_MAX_nData = nCols; end
if ~exist('QUABUF_MAX_nDATA'), QUABUF_MAX_nDATA = 1024; end % maximum depth of data
if ~exist('QUABUF_MAX_nCOL'),  QUABUF_MAX_nCOL = 3; end % fix to 3 (do not revised)
if ~exist('QUABUF_MAX_nPERIOD'),  QUABUF_MAX_nPERIOD = 64 * 1024; end
if ~exist('QUABUF_MAX_nREP'),  QUABUF_MAX_nREP = 1024; end
if ~exist('SINGBUF_MAX_nPERIOD'),  SINGBUF_MAX_nPERIOD = 64 * 1024; end
if ~exist('SINGBUF_MAX_nDATA'), SINGBUF_MAX_nDATA = 1024; end 

% session parameters
sess.mode_conv_mm = 0; % convolution
sess.featureSize = [6, 6, 8]; % [input_rows, input_cols, input_depth]
sess.weightSize = [16, 3, 3, 8]; % [output_depth, height, width input_depth]
sess.zero_pad = 1;
sess.horz_data_addr_base = 0/ceil(rDataWidth/iWidth);
sess.obli_data_addr_base = ceil(prod(sess.weightSize)/ceil(rDataWidth/iWidth));
sess.out_data_addr_base = sess.obli_data_addr_base + ceil(prod(sess.featureSize)/ceil(wDataWidth/oWidth));
sess.horz_data_addr_block_stride = sess.weightSize(1)/nBanks*sess.weightSize(3)*sess.weightSize(4)/ceil(wDataWidth/oWidth);
sess.horz_data_addr_block_num = nBanks * nRows;
sess.obli_data_addr_block_stride = sess.featureSize(2)*sess.featureSize(3)/ceil(wDataWidth/oWidth);
sess.obli_data_addr_block_num = nRows+nCols-1;
assert(sess.featureSize(3) == sess.weightSize(4));
assert(sess.featureSize(1) == nRows+nCols-1);
