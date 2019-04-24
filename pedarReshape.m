function reshapedArray = pedarReshape(array,index)
%pedarReshape reshaped 99 sensors to a 15 x 7 matrix w/ padding
%   Detailed explanation goes here
    reshapedDat = zeros(1,105);
    reshapedDat(2:6) = array(index,1:5);
    reshapedDat(8:97) = array(index,6:95);
    reshapedDat(100:103) = array(index,96:99);
    reshapedArray = reshape(reshapedDat,15,7);
    
end

