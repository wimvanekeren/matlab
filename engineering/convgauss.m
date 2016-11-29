function [yfilt,W]=convgauss(y,sigma,do_keepedges)
% sigma = standard deviation of gaussian fitler, measured in samples
% do_keepedges: convolve the endpoints with constant edge values to prevent
% drops at the edges of the filtered signal
%
% https://en.wikipedia.org/wiki/Window_function#Gaussian_window

if ~exist('do_keepedges','var')
    do_keepedges = 0;
end

do_transpose = 0;
if size(y,1)<size(y,2)
    y=y';
    do_transpose = 1;
end
nsig = size(y,2);
nsamp = size(y,1);

if sigma>0
    
    yfilt = nan(nsamp,nsig);
    for i=1:nsig
    
        N = floor(sigma*4);
        n=[0:N]';
        X = (n-(N)/2)./(sigma/2);
        w = exp(-0.5*X.^2);
        W = w/sum(w);

        if do_keepedges
            nstart = N/2;
            nend   = N/2;

            % extend signal with constant start/end values
            this_y2 = [y(1,i)*ones(nstart,1); y(:,i); y(end,1)*ones(nend,1)];

            % filter entire signal
            this_yfilt = conv(this_y2,W,'full');

            % grab correct central part
            yfilt(:,i) = this_yfilt(N+1:nsamp+2*N-N,:); 
        else
            yfilt(:,i) = conv(y(:,i),W,'same');
        end
    end
    
else % no filtering
    yfilt=y;
end

if do_transpose
    yfilt=yfilt';
end