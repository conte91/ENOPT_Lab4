function vocerror=vsoc_error(b, x, y)
  vsoc=x;
  voc=vsoc2voc(b,x);
  diff=y-voc;
  vocerror=sum(diff.^2);
end
