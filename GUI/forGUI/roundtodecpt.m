% ------------------------------------------------------------- roundn(x,d)
%roundtodecpt(x,d) returns x rounded to d digits after first 0
%
%    e.g. if x=0.0001234 and d=1 -> y=0.0001
%         if x=0.0001234 and d=2 -> y=0.00012
% -------------------------------------------------------------------------

function y = roundtodecpt(x,d);

 j=1;
 while round(10^j*x)==0
     j=j+1;
 end
%j
    y = round(10^(j+d-1)*x)/10^(j+d-1);
   