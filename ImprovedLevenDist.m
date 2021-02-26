function D = ImprovedLevenDist(x,y)
% improved leven distance method,
% this can calculate the distance between two image array.
% 
% input?
%         x: source image
%         y: target image
% output:
%         D: leven distance
%
% coder: flyskymlf
% time: 2009.11.5
%
n=length(x);
m=length(y);
if n==0
    D=m;
    return;
end
if m==0
    D=n;
    return;
end
G=[,];
for j=0:n
    G(1,j+1)=j;% initialization
end
for i=0:m
    G(i+1,1)=i;% initialization
end
three=[];
% Iteration
for j=2:n+1
    for i=2:m+1
        if x(j-1)==y(i-1)
            cost=0;
        else
            cost=1;
        end
        three(1)=G(i-1,j)+1;
        three(2)=G(i,j-1)+1;
        three(3)=G(i-1,j-1)+cost;
        G(i,j)=min(three);
    end
end
D=G(m+1,n+1);