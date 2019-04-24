function reshapedArray = pedarReshape(array,index)
%pedarReshape reshaped 99 sensors to a 15 x 7 matrix w/ padding
%   Detailed explanation goes here

    %Fixed below
    reshapedDat = zeros(1,105);
    reshapedDat(3:6) = array(index,99:-1:96);
    reshapedDat(9:98) = array(index,95:-1:6);
    reshapedDat(100:104) = array(index,5:-1:1);
    reshapedArray = reshape(reshapedDat,15,7);
    reshapedArray = reshapedArray';
    
end