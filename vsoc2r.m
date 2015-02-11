function voc=vsoc2r(b, x);
  vsoc=x;
  voc=b(1)*(exp(b(2)*vsoc))+b(3);
end
