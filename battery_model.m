upper_current=0.145;
lower_current=1.440;

upper=load('upper_curve.txt');
lower=load('lower_curve.txt');

%Contains a cap-voc table by row
%cap vcc
%cap2 vcc2
%cap3 vcc3
x_interp_upper= 0:0.1:max(upper(:,+1));
upper_interp=[x_interp_upper' interp1(upper(:,1), upper(:,2), x_interp_upper)'];

x_interp_lower= 0:0.1:max(lower(:,+1));
lower_interp=[x_interp_lower' interp1(lower(:,1), lower(:,2), x_interp_lower)'];

%Obtain data in a different number of points
max_interp_value=min(max(upper(:,1)), max(lower(:,1)));
min_interp_value=max(min(upper(:,1)), min(lower(:,1)));

%Taglia il vettore
upper_interp=upper_interp(find( upper_interp(:,1)>min_interp_value), :);
upper_interp=upper_interp(find( upper_interp(:,1)<max_interp_value), :);

lower_interp=lower_interp(find( lower_interp(:,1)>min_interp_value), :);
lower_interp=lower_interp(find( lower_interp(:,1)<max_interp_value), :);

%Normalize the vector
divide_by=max_interp_value-min_interp_value;
upper_interp(:,1)=upper_interp(:,1)/divide_by;
lower_interp(:,1)=lower_interp(:,1)/divide_by;

figure
hold on
plot(upper_interp(:,1), upper_interp(:,2))
plot(lower_interp(:,1), lower_interp(:,2))
title('Interpolated data of discharge curves', 'Fontname', 'DejaVu', 'FontSize', 16);
xlabel('Normalized charge', 'FontName', 'DejaVu', 'FontSize', 12);
ylabel('Voc', 'FontName', 'DejaVu', 'FontSize', 12);
Rs=[];
for i=1:length(upper_interp(:,1))
  Vbc1=lower_interp(i,2);
  Ibc1=lower_current;
  Vbc2=upper_interp(i,2);
  Ibc2=upper_current;
  R=(Vbc2-Vbc1)/(Ibc1-Ibc2);
  Voc=Vbc1+R*Ibc1;

  %Build a Cap-R-V table
  Rs=[Rs;lower_interp(i,1) R Voc];
end


%Interpolate equation for VSoc
x=[min(Rs(:,1)):0.001:max(Rs(:,1))];
p0=[1 1 1 1 1 1 1];
handle=@(b) vsoc_error(b, Rs(:,1), Rs(:,3));
p=fminsearch(handle, p0);
p1=p;
x=[min(Rs(:,1)):0.001:max(Rs(:,1))];
y=feval('vsoc2voc', p, x);
figure;
plot(x, y, Rs(:,1), Rs(:,3));
title('Measured vs. fitted VSOC curve', 'Fontname', 'DejaVu', 'FontSize', 16);
xlabel('Normalized charge', 'FontName', 'DejaVu', 'FontSize', 12);
ylabel('VSOC', 'FontName', 'DejaVu', 'FontSize', 12);

%Interpolate equation for R
x=[min(Rs(:,1)):0.001:max(Rs(:,1))];
p0=[1 1 1];
handle=@(b) r_error(b, Rs(:,1), Rs(:,2));
p=fminsearch(handle, p0);
p2=p;
x=[min(Rs(:,1)):0.001:max(Rs(:,1))];
y=feval('vsoc2r', p, x);
figure;
plot(x, y, Rs(:,1), Rs(:,2));
title('Measured vs. fitted R curve', 'Fontname', 'DejaVu', 'FontSize', 16);
xlabel('Normalized charge', 'FontName', 'DejaVu', 'FontSize', 12);
ylabel('R', 'FontName', 'DejaVu', 'FontSize', 12);

b1=p1;
b2=p2;
b=[b1 b2];
