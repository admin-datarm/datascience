function [ y_out ] = laff_copy( x,y )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[m_x,n_x] = size( x )
y_out = zeros( m_x, 1)

for i=1:m_x
    y_out( i ) = x( i );
end

return
end

