%% Test Systolic Array
clear;
close all;
weight_path_root = 'D:/tmp/arthas/weights';
feature_path_root = 'D:/tmp/arthas/features';
batchnorm_path_root = 'D:/tmp/arthas/batchnorms';
weight_ensigpath = 'D:/tmp/arthas/w_in_en.dat';
feature_ensigpath = 'D:/tmp/arthas/f_in_en.dat';
batchnorm_ensigpath = 'D:/tmp/arthas/bn_in_en.dat';
outpath = 'D:/tmp/arthas/output';
featureSize = [6, 6, 8]; % [input_rows, input_cols, input_depth]
weightSize = [2, 3, 3, 8]; % [output_depth, height, widthm input_depth]
pad_size = 1;
nBanks = 2;
nRows = 3;
nCols = 4;
iWidth = 16;
oWidth = 33;
MAX_nPERIOD = 8;
MAX_nLMAC = 3*512*8;
MAX_nSHFT = 192;
CLK_PERIOD = 10;
PROCESSING_CYC = 2000;
assert(featureSize(3) == weightSize(4));
assert(featureSize(1) == nRows+nCols-1);

% weight data enable signal
nInputEnableCycles = weightSize(1)*weightSize(3)*weightSize(4)*(featureSize(2)-2*pad_size)/nBanks;
nInputCycles = round(nInputEnableCycles/(1));
enableSignals = zeros([nInputCycles, 1]);
enableSignals(randperm(nInputCycles, nInputEnableCycles)) = 1;
write2file(enableSignals, weight_ensigpath);

% feature data enable signal
nInputEnableCycles = (weightSize(3) + featureSize(2)-2*pad_size)*weightSize(4);
nInputCycles = round(nInputEnableCycles/(1));
enableSignals = zeros([nInputCycles, 1]);
enableSignals(randperm(nInputCycles, nInputEnableCycles)) = 1;
write2file(enableSignals, feature_ensigpath);

% batch norm data enable signal
nInputEnableCycles = weightSize(1)/nBanks;
nInputCycles = round(nInputEnableCycles/(1));
enableSignals = zeros([nInputCycles, 1]);
enableSignals(randperm(nInputCycles, nInputEnableCycles)) = 1;
write2file(enableSignals, batchnorm_ensigpath);


% weights
weights = randi([0, 2^iWidth-1], weightSize);
for i = 1: nBanks
    for j = 1: nRows
        data = weights((1:weightSize(1)/nBanks)+(i-1)*weightSize(1)/nBanks, j,:,:);
        data = repmat(data(:), [featureSize(2)-2*pad_size], 1);
        write2file(mat2bin(data(:), iWidth, 0), [weight_path_root, '_', num2str(i), '_', num2str(j), '.dat']);
    end
end

% features
features = randi([0, 2^iWidth-1], featureSize);
for i = 1: (nRows+nCols-1)
    data = [];
    for k = 0: (featureSize(2)-weightSize(3))
        tmp = features(i,(1:weightSize(3))+k,:);
        data = [data, tmp(:)];
    end
    write2file(mat2bin(data(:), iWidth, 0), [feature_path_root, '_', num2str(i), '.dat']);
end

% batch norm
batchnorm = randi([0, 2^52-1], [nBanks, weightSize(1)/nBanks]);
for i = 1: nBanks
    data = [];
    data = batchnorm(i);
    write2file(mat2bin(data(:), 2*oWidth, 0), [batchnorm_path_root, '_', num2str(i), '.dat']);
end
