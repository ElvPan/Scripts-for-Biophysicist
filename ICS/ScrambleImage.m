 

function [Scramble1] = ScrambleImage(im1,Bsize)
% Scamble blocks of Image
% Divide image into blocks approximately the size of the PSF (Bsize).

BlockNumber_K = size(im1,1)/Bsize;
BlockNumber_L= size(im1,2)/Bsize;


%--------
%1  2  3
%4  5  6 
%--------
%im1(K,L)
%When (K,L) = (1,1) BLOCK 1 is selected
%When (K,L) = (1,2) BLOCK 2 is selected
%When (K,L) = (2,1) BLOCK 4 is selected etc....



 
    BlockPerm = randperm(BlockNumber_K * BlockNumber_L);
    Scramble1 = zeros(size(im1));
    
    
    for itImage = 1:size(im1,3)
        for L = 1:BlockNumber_L;
            for K = 1:BlockNumber_K;
                NextBlockPerm = sub2ind([BlockNumber_K BlockNumber_L],K,L);    
                [i,j] = ind2sub([BlockNumber_K BlockNumber_L],BlockPerm(NextBlockPerm));
                Scramble1(K*Bsize-(Bsize-1):K*Bsize,L*Bsize-(Bsize-1):L*Bsize,itImage) = im1(i*Bsize-(Bsize-1):i*Bsize,j*Bsize-(Bsize-1):j*Bsize,itImage);
              
               
            end
        end
    end

