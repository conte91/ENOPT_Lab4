function y=efficiencyError(c, x, y)
  VIN=12;
  VOUT=12;

  i=x;

  %Theoretical one
  eta=y;

  %Interpolated data
  Ploss=c(1)*x.^2+c(2)*x+c(3);
  Pout=VOUT*i;
  eta_interp=Pout./(Pout+Ploss);

  diff=eta_interp-eta;
  y=sum(diff.^2);
end
