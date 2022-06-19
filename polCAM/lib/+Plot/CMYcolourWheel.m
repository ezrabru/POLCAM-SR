%Name:          CMYcolourWheel.m
%Description:   Generates an N level colourwheel that is periodic
%Author:    Kevin O'Holleran
%Notes:    

function map = CMYcolourWheel(N)

   % Generates an CMY colour wheel mapap
    n3 = round(N/3);
    map = zeros(N,3);
    for i = 0:(n3-1)
        map(i+1,1) = 1;
        map(i+1,2) = i/n3;
        map(i+1,3) = 1-i/n3;
    end
    for i = 0:(n3-1)
        map(i+n3+1,1) = 1-i/n3;
        map(i+n3+1,2) = 1;
        map(i+n3+1,3) = i/n3;
    end
    diff = N - (2*n3);
    for i = 0:(diff-1)
        map(i+2*n3+1,1) = i/n3;
        map(i+2*n3+1,2) = 1-i/n3;
        map(i+2*n3+1,3) = 1;
    end
    
end