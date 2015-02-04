function DATA=markolab_smooth(DATA,ORDER)
%
% OUTPUT=markolab_smooth(DATA,ORDER) 
%
% Takes a matrix of data and smooths each column 
% with a basic moving average filter (ORDER=number
% of samples in moving average)
%


[nsamples,ntrials]=size(DATA);
kernel=ones(1,ORDER)/ORDER;

DATA=filter(kernel,1,DATA);
