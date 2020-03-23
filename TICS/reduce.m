% This function downsize a m*n matrix to a (m/thr)*(n/thr) matrix taking the
% mean of thr*thr pixels from the m*n matrix for 1 pixel in the (m/thr)*(n/thr) matrix
%
% i.e. reduce the matrix by a threshold (thr) factor.


function small = reduce(raw, factor);

[row,col,len] = size(raw);

diff_col = rem(col,factor);                  % add diff_col colomn
if diff_col>0
    diff_col = factor - diff_col;
    raw(:,col+1:(col + diff_col)) = fliplr(raw(:,(col - diff_col+1):col));
end


[row,col,len]=size(raw);
diff_row = rem(row,factor);                 % add diff_row row
if diff_row>0
    diff_row = factor - diff_row;
    raw(row+1:(row + diff_row),:) = flipud(raw((row - diff_row+1):row,:));
end


fun = inline('mean2(x)');
h = waitbar(0,'Downsampling...');
small = zeros(size(raw,1)/factor, size(raw,2)/factor, size(raw,3));
for i = 1:size(raw,3)
    small(:,:,i) = blkproc(raw(:,:,i), [factor factor], fun);       % pad with zeros if necessary
    waitbar(i/size(raw,3),h)
end
close(h)