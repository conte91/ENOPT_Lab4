function y=c2Eta(c, x)
  VIN=12;
  VOUT=12;
  i=x;

  %Interpolated data
  Ploss=c(1)*x.^2+c(2)*x+c(3);
  Pout=VOUT*i;
  y=Pout./(Pout+Ploss);

end
