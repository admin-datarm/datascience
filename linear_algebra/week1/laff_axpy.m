function [ y_out ] = laff_axpy( alpha,x ,y )
%laff axpy

[m_x,n_x] = size( x )
[m_y,n_y] = size( y )
if (m_x ~= 1 & n_x~= 1 ) | ( m_y ~= 1 & n_y ~= 1 )
    y_out = 'FAILED';
    return 
end
if (m_x * n_x ~= m_y * n_y)
    y_out = 'FAILED'
    return
end
if ~isscalar (alpha)
    y_out = 'FAILED';
    return
end

% implementation ...

y_out = y;
return
end

