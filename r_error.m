function rerror=r_error(b, x, y)
  vsoc=x;
  r=vsoc2r(b,x);
  diff=y-r;
  rerror=sum(diff.^2);
end
