function write2file(data, filename)
%WRITE2FILE
fid = fopen(filename, 'w+');
for i = 1: size(data, 1)
    for j = 1: size(data, 2)
        fprintf(fid, '%d', double(data(i,j)));
    end
    fprintf(fid, '\n');
end
fclose(fid);
end

