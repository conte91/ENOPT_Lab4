function voc=vsoc2r(b, x);
  vsoc=x;
  voc=b(1)*(e.^(b(2)*vsoc))+b(3);
end
