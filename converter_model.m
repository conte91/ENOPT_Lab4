conv=load('converter_curve.txt');
%Curve was created with x log axis
conv(:,1)=10.^conv(:,1);
%data was in mA
conv(:,1)=conv(:,1)/1000;
conv(:,2)=conv(:,2)/100;
x_interp= min(conv(:,1)):0.1:max(conv(:,+1));
%Contains a cap-n table by row
%cap n
%cap2 n2
%cap3 n3
interp=[x_interp' interp1(conv(:,1), conv(:,2), x_interp)'];


figure;
grid on;
semilogx(interp(:,1), interp(:,2));
title('Interpolated data of converter model', 'Fontname', 'DejaVu', 'FontSize', 16);
xlabel('Load current(A)', 'FontName', 'DejaVu', 'FontSize', 12);
ylabel('Efficiency', 'FontName', 'DejaVu', 'FontSize', 12);
grid on

%Interpolate equation for Ploss(I)
p0=[1 1 1];
handle=@(c) efficiencyError(c, conv(:,1), conv(:,2));
p=fminsearch(handle, p0);
c=p;

x=[min(conv(:,1)):0.001:max(conv(:,1))];
y=feval('c2Eta', p, x);
figure;
grid on;
semilogx(x, y, conv(:,1), conv(:,2));
title('Measured vs. fitted eta curve @12V', 'Fontname', 'DejaVu', 'FontSize', 16);
xlabel('Output current (A)', 'FontName', 'DejaVu', 'FontSize', 12);
ylabel('Efficiency', 'FontName', 'DejaVu', 'FontSize', 12);

x=[min(conv(:,1)):0.001:max(conv(:,1))];
y=feval('c2PLoss', p, x);
figure;
grid on;
semilogx(x, y);
title('Resulting Ploss curve @12V', 'Fontname', 'DejaVu', 'FontSize', 16);
xlabel('Output current (A)', 'FontName', 'DejaVu', 'FontSize', 12);
ylabel('Power loss', 'FontName', 'DejaVu', 'FontSize', 12);

