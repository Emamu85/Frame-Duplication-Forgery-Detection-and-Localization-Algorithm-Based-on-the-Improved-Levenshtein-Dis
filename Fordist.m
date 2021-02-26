%% Calculation of distance between arrays
% Improved Levenshtein Distance method.
% It can be used to calculate the Leven distance between two given array, 
% the original Levenshtein Distance algorithm is design to calculate the 
% distance between two string.
% The main idea of coping with the array is the same with the string
%   Function ImprovedLevenDist(x,y) is intended for calculation of distance
% between two arrays x and y.It computes Levenshtein. Levenshtein distance 
% is the minimal quantity of number substitutions, deletions and 
% insertions for transformation of
% array x into array y. 
%% DESCRIPTION - for strings
% *d=strdist(r)* computes numel(r); *d=strdist(r,b)* computes Levenshtein
% distance between r and b. If b is empty string then d=numel(r);
% *d=strdist(r,b,krk)* computes both Levenshtein and editor distance when
% krk=2. *d=strdist(r,b,krk,cas)*  computes
% a distance in accordance with krk and cas.If cas>0 then case is ignored. 
%% EXAMPLE
% d1 - Levenstein distance
clc
a=[1 2 0 5 4];
b=[1 2 3 5 4];
d1=ImprovedLevenDist(a,b)


