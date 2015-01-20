function voc=vsoc2voc(b, x);
  vsoc=x;
  voc=b(1)*(e.^(b(2)*vsoc))+b(3)*vsoc.^4+b(4)*vsoc.^3+b(5)*vsoc.^2+b(6)*vsoc+b(7);
end
