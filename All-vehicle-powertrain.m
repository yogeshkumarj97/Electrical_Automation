close all
clear
Cd=0.65;
Cr=0.015;
g=9.81;
rw= 0.295;
m=1500;
load('C:\NEDC.mat')
t = velocity.Time;
y = velocity.Data*(1000/3600);
% %  1.VELOCITY PROFILE
figure,   plot(t,y);
 grid on; 
 xlabel('Time (s)'); 
 ylabel('Vechicle speed(m/s)');

% %  2. ACCELERATION PROFILE
N= length(t);
for k=1:N-1
  
    dyx(k)= (y(k+1)-y(k))/ (t(k+1)-t(k));
    
end
dyx = [dyx 0];
figure, plot(t,dyx);
 xlabel('Time(s)'); 
 ylabel('Acceleration(m/s^2)');

% % 3. ACCELERATING FORCE PROFILE
for p=1:N
    Fd(p)=Cd*(y(p).^2)+(Cr*m*g*sign(y(p)));
    Fw(p)=m*dyx(p)+Fd(p);


end
figure,  plot(t,Fw);
 grid on;
 xlabel('Time(s)');
 ylabel('Wheel Force Fw(N)');

% % 4. max wheel angular velocity and Torque of wheel
 Ym = 150;
 cr= 5/18;
 a = (100*cr)/8;
Wwm = (Ym.*cr)/rw
 Fdm = 500;
 Fwm = (m*a)+Fdm;
 Twm = Fwm*rw

% %  5. Motor Spped Profile
  wM = (y/rw)*8;
figure,  plot(t,wM);
 grid on;
 xlabel('Time(s)');
 ylabel('Motor speed ω_M(rad/sec)');

% %  6.a Motor Torque profile
 
 Tm = (Fw*rw)/8;
figure,    plot(t,Tm);
    grid on;
    xlabel('Time(s)');
    ylabel('Motor Torque T_M(Nm)');

% %   6.b Power profile
  Pm = Tm'.*wM;
figure,   plot(t,Pm);
   grid on;
   xlabel('Time(s)');
   ylabel('Power p_M(Watts)');

% % Max angular velocity and Torque of motor
Wmm = Wwm*8
Tmm = Twm/8

% % Effective Torque of motor
tc = t(end);
wN = (4000*2*pi)/60;
for k = 1:N
if abs(wM(k)) < wN

TI(k) = Tm(k).^2;
else

TI(k) = Pm(k).^2/wN.^2;
end
end

TM_ef = sqrt(trapz(t,TI)/tc)