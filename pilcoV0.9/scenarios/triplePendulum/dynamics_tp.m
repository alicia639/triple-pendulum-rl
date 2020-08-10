%% dynamics_dp.m
% *Summary:* Implements ths ODE for simulating the double pendulum 
% dynamics, where an input torque can be applied to both links, 
% f1:torque at inner joint, f2:torque at outer joint
%
%    function dz = dynamics_dp(t, z, f1, f2)
%
%
% *Input arguments:*
%
%		t     current time step (called from ODE solver)
%   z     state                                                    [4 x 1]
%   f1    (optional): torque f1(t) applied to inner pendulum
%   f2    (optional): torque f2(t) applied to outer pendulum
%
% *Output arguments:*
%   
%   dz    if 4 input arguments:      state derivative wrt time
%         if only 2 input arguments: total mechanical energy
%
%   Note: It is assumed that the state variables are of the following order:
%         dtheta1:  [rad/s] angular velocity of inner pendulum
%         dtheta2:  [rad/s] angular velocity of outer pendulum
%         theta1:   [rad]   angle of inner pendulum
%         theta2:   [rad]   angle of outer pendulum
%
% A detailed derivation of the dynamics can be found in:
%
% M.P. Deisenroth: 
% Efficient Reinforcement Learning Using Gaussian Processes, Appendix C, 
% KIT Scientific Publishing, 2010.
%
%
% Copyright (C) 2008-2013 by
% Marc Deisenroth, Andrew McHutchon, Joe Hall, and Carl Edward Rasmussen.
%
% Last modified: 2013-03-08

function dz = dynamics_dp(t, z, f1, f2, f3)
%% Code
m1 = 0.5;  % [kg]     mass of 1st link
m2 = 0.5;  % [kg]     mass of 2nd link
m3 = 0.5;  % [kg]     mass of 3rd link
b1 = 0.0;  % [Ns/m]   coefficient of friction (1st joint)
b2 = 0.0;  % [Ns/m]   coefficient of friction (2nd joint)
b3 = 0.0;  % [Ns/m]   coefficient of friction (3rd joint)
l1 = 0.5;  % [m]      length of 1st pendulum
l2 = 0.5;  % [m]      length of 2nd pendulum
l3 = 0.5;  % [m]      length of 3rd pendulum
g  = 9.82; % [m/s^2]  acceleration of gravity
I1 = m1*l1^2/12;  % moment of inertia around pendulum midpoint (1st link)
I2 = m2*l2^2/12;  % moment of inertia around pendulum midpoint (2nd link)
I3 = m3*l3^2/12;  % moment of inertia around pendulum midpoint (3rd link) %%%%CHECK WITH PAPA

y1 = z(4);
y2 = z(1);
y3 = z(5);
y4 = z(2);
y5 = z(6);
y6 = z(3);

u1 = f1;
u2 = f2;
u3 = f3; % replace later

if nargin == 5 % compute time derivatives %  change to Kane's method !!!!!

  dz = zeros(6,1);

  dz(4) = y2;
  dz(1) = (L2*L3*M2*u1 - L2*L3*M2*u2 + L2*L3*M3*u1 - L2*L3*M3*u2 - L1*L3*M2*u2*cos(y3) + L1*L3*M2*u3*cos(y3) - L1*L3*M3*u2*cos(y3) + L1*L3*M3*u3*cos(y3) - L2*L3*M3*u1*cos(y5)^2 + L2*L3*M3*u2*cos(y5)^2 + L1*L2^2*L3*M2^2*y2^2*sin(y3) + L1*L2^2*L3*M2^2*y4^2*sin(y3) - L1*L2*L3*M2^2*g*cos(y1) + (L1^2*L2*L3*M2^2*y2^2*sin(2*y3))/2 + L1*L2*M2*u3*sin(y3)*sin(y5) + L1*L2*M3*u3*sin(y3)*sin(y5) + L1*L3*M3*u2*cos(y3)*cos(y5)^2 - L1*L3*M3*u3*cos(y3)*cos(y5)^2 + L1*L2^2*L3*M2*M3*y2^2*sin(y3) + L1*L2^2*L3*M2*M3*y4^2*sin(y3) - L1*L2*L3*M1*M2*g*cos(y1) - L1*L2*L3*M1*M3*g*cos(y1) - L1*L2*L3*M2*M3*g*cos(y1) + 2*L1*L2^2*L3*M2^2*y2*y4*sin(y3) + (L1^2*L2*L3*M2*M3*y2^2*sin(2*y3))/2 - L1*L3*M3*u2*cos(y5)*sin(y3)*sin(y5) + L1*L3*M3*u3*cos(y5)*sin(y3)*sin(y5) + L1*L2*L3*M2^2*g*cos(y1)*cos(y3)^2 - L1*L2*L3*M2^2*g*cos(y3)*sin(y1)*sin(y3) + 2*L1*L2^2*L3*M2*M3*y2*y4*sin(y3) + L1*L2*L3*M2*M3*g*cos(y1)*cos(y3)^2 + L1*L2*L3*M1*M3*g*cos(y1)*cos(y5)^2 + L1*L2*L3^2*M2*M3*y2^2*cos(y5)*sin(y3) + L1*L2*L3^2*M2*M3*y4^2*cos(y5)*sin(y3) + L1*L2*L3^2*M2*M3*y6^2*cos(y5)*sin(y3) + 2*L1*L2*L3^2*M2*M3*y2*y4*cos(y5)*sin(y3) + 2*L1*L2*L3^2*M2*M3*y2*y6*cos(y5)*sin(y3) + 2*L1*L2*L3^2*M2*M3*y4*y6*cos(y5)*sin(y3) - L1*L2*L3*M2*M3*g*cos(y3)*sin(y1)*sin(y3))/(L1^2*L2*L3*(M2^2 - M2^2*cos(y3)^2 + M1*M2 + M1*M3 + M2*M3 - M2*M3*cos(y3)^2 - M1*M3*cos(y5)^2));
  dz(5) = y4;
  dz(2) = -(2*L1^2*L3*M1*u3 - 2*L1^2*L3*M1*u2 - 2*L1^2*L3*M2*u2 + 2*L2^2*L3*M2*u1 + 2*L1^2*L3*M2*u3 - L1^2*L3*M3*u2 - 2*L2^2*L3*M2*u2 + L2^2*L3*M3*u1 + L1^2*L3*M3*u3 - L2^2*L3*M3*u2 + L1*L2^2*M2*u3*cos(y3 - y5) + L1*L2^2*M3*u3*cos(y3 - y5) - L1^2*L2*M2*u3*cos(2*y3 + y5) - L1^2*L2*M3*u3*cos(2*y3 + y5) - L2^2*L3*M3*u1*cos(2*y5) + L2^2*L3*M3*u2*cos(2*y5) + L1^2*L3*M3*u2*cos(2*y3 + 2*y5) - L1^2*L3*M3*u3*cos(2*y3 + 2*y5) - L1*L2^2*M2*u3*cos(y3 + y5) - L1*L2^2*M3*u3*cos(y3 + y5) + 2*L1^2*L2*M1*u3*cos(y5) + L1^2*L2*M2*u3*cos(y5) + L1^2*L2*M3*u3*cos(y5) + 2*L1*L2^3*L3*M2^2*y2^2*sin(y3) + 2*L1^3*L2*L3*M2^2*y2^2*sin(y3) + 2*L1*L2^3*L3*M2^2*y4^2*sin(y3) - L1*L2*L3*M3*u1*cos(y3 + 2*y5) + 2*L1*L2*L3*M3*u2*cos(y3 + 2*y5) - L1*L2*L3*M3*u3*cos(y3 + 2*y5) + L1^2*L2*L3*M2^2*g*cos(y1 + y3) - L1*L2^2*L3*M2^2*g*cos(y1) - L1^2*L2*L3*M2^2*g*cos(y1 - y3) + L1*L2^2*L3*M2^2*g*cos(y1 + 2*y3) + 2*L1^2*L2^2*L3*M2^2*y2^2*sin(2*y3) + L1^2*L2^2*L3*M2^2*y4^2*sin(2*y3) + 2*L1*L2*L3*M2*u1*cos(y3) - 4*L1*L2*L3*M2*u2*cos(y3) + L1*L2*L3*M3*u1*cos(y3) + 2*L1*L2*L3*M2*u3*cos(y3) - 2*L1*L2*L3*M3*u2*cos(y3) + L1*L2*L3*M3*u3*cos(y3) + 2*L1^3*L2*L3*M1*M2*y2^2*sin(y3) + L1^3*L2*L3*M1*M3*y2^2*sin(y3) + 2*L1*L2^3*L3*M2*M3*y2^2*sin(y3) + 2*L1^3*L2*L3*M2*M3*y2^2*sin(y3) + 2*L1*L2^3*L3*M2*M3*y4^2*sin(y3) + 4*L1*L2^3*L3*M2^2*y2*y4*sin(y3) - (L1^2*L2*L3*M1*M3*g*cos(y1 + y3 + 2*y5))/2 - L1^3*L2*L3*M1*M3*y2^2*sin(y3 + 2*y5) + L1*L2^2*L3^2*M2*M3*y2^2*sin(y3 + y5) + L1*L2^2*L3^2*M2*M3*y4^2*sin(y3 + y5) + L1*L2^2*L3^2*M2*M3*y6^2*sin(y3 + y5) + L1^2*L2*L3*M1*M2*g*cos(y1 + y3) + (L1^2*L2*L3*M1*M3*g*cos(y1 + y3))/2 + L1^2*L2*L3*M2*M3*g*cos(y1 + y3) - 2*L1^2*L2*L3^2*M1*M3*y2^2*sin(y5) - L1^2*L2*L3^2*M2*M3*y2^2*sin(y5) - 2*L1^2*L2*L3^2*M1*M3*y4^2*sin(y5) - L1^2*L2*L3^2*M2*M3*y4^2*sin(y5) - 2*L1^2*L2*L3^2*M1*M3*y6^2*sin(y5) - L1^2*L2*L3^2*M2*M3*y6^2*sin(y5) - 2*L1*L2^2*L3*M1*M2*g*cos(y1) - L1*L2^2*L3*M1*M3*g*cos(y1) - L1*L2^2*L3*M2*M3*g*cos(y1) + (L1^2*L2*L3*M1*M3*g*cos(y1 - y3 - 2*y5))/2 + L1*L2^2*L3^2*M2*M3*y2^2*sin(y3 - y5) + L1^2*L2*L3^2*M2*M3*y2^2*sin(2*y3 + y5) + L1*L2^2*L3^2*M2*M3*y4^2*sin(y3 - y5) + L1^2*L2*L3^2*M2*M3*y4^2*sin(2*y3 + y5) + L1*L2^2*L3^2*M2*M3*y6^2*sin(y3 - y5) + L1^2*L2*L3^2*M2*M3*y6^2*sin(2*y3 + y5) - L1^2*L2*L3*M1*M2*g*cos(y1 - y3) - (L1^2*L2*L3*M1*M3*g*cos(y1 - y3))/2 - L1^2*L2*L3*M2*M3*g*cos(y1 - y3) + L1*L2^2*L3*M2*M3*g*cos(y1 + 2*y3) + (L1*L2^2*L3*M1*M3*g*cos(y1 - 2*y5))/2 + (L1*L2^2*L3*M1*M3*g*cos(y1 + 2*y5))/2 + 2*L1^2*L2^2*L3*M2*M3*y2^2*sin(2*y3) - L1^2*L2^2*L3*M1*M3*y2^2*sin(2*y5) + L1^2*L2^2*L3*M2*M3*y4^2*sin(2*y3) - L1^2*L2^2*L3*M1*M3*y4^2*sin(2*y5) + 2*L1^2*L2^2*L3*M2^2*y2*y4*sin(2*y3) + 4*L1*L2^3*L3*M2*M3*y2*y4*sin(y3) + 2*L1*L2^2*L3^2*M2*M3*y2*y4*sin(y3 + y5) + 2*L1*L2^2*L3^2*M2*M3*y2*y6*sin(y3 + y5) + 2*L1*L2^2*L3^2*M2*M3*y4*y6*sin(y3 + y5) - 4*L1^2*L2*L3^2*M1*M3*y2*y4*sin(y5) - 2*L1^2*L2*L3^2*M2*M3*y2*y4*sin(y5) - 4*L1^2*L2*L3^2*M1*M3*y2*y6*sin(y5) - 2*L1^2*L2*L3^2*M2*M3*y2*y6*sin(y5) - 4*L1^2*L2*L3^2*M1*M3*y4*y6*sin(y5) - 2*L1^2*L2*L3^2*M2*M3*y4*y6*sin(y5) + 2*L1*L2^2*L3^2*M2*M3*y2*y4*sin(y3 - y5) + 2*L1^2*L2*L3^2*M2*M3*y2*y4*sin(2*y3 + y5) + 2*L1*L2^2*L3^2*M2*M3*y2*y6*sin(y3 - y5) + 2*L1^2*L2*L3^2*M2*M3*y2*y6*sin(2*y3 + y5) + 2*L1*L2^2*L3^2*M2*M3*y4*y6*sin(y3 - y5) + 2*L1^2*L2*L3^2*M2*M3*y4*y6*sin(2*y3 + y5) + 2*L1^2*L2^2*L3*M2*M3*y2*y4*sin(2*y3) - 2*L1^2*L2^2*L3*M1*M3*y2*y4*sin(2*y5))/(L1^2*L2^2*L3*(M2^2 - M2^2*cos(2*y3) + 2*M1*M2 + M1*M3 + M2*M3 - M2*M3*cos(2*y3) - M1*M3*cos(2*y5)));
  dz(6) = y6;
  dz(3) = -(L1*L3^2*M3^2*u2 - L1*L2^2*M3^2*u3 - L1*L2^2*M2^2*u3 - L1*L3^2*M3^2*u3 - L2*L3^2*M3^2*u1*cos(y3) + L2*L3^2*M3^2*u2*cos(y3) - 2*L1*L2^2*M1*M2*u3 - 2*L1*L2^2*M1*M3*u3 + 2*L1*L3^2*M1*M3*u2 - 2*L1*L2^2*M2*M3*u3 - 2*L1*L3^2*M1*M3*u3 + 2*L1*L3^2*M2*M3*u2 - 2*L1*L3^2*M2*M3*u3 + L1*L2^2*M2^2*u3*cos(2*y3) + L1*L2^2*M3^2*u3*cos(2*y3) + L1*L3^2*M3^2*u2*sin(2*y3)*sin(2*y5) - L1*L3^2*M3^2*u3*sin(2*y3)*sin(2*y5) + L1*L2*L3*M3^2*u2*cos(y5) - 2*L1*L2*L3*M3^2*u3*cos(y5) - 2*L2*L3^2*M2*M3*u1*cos(y3) + 2*L2*L3^2*M2*M3*u2*cos(y3) - 2*L2^2*L3*M3^2*u1*sin(y3)*sin(y5) + 2*L2^2*L3*M3^2*u2*sin(y3)*sin(y5) + L2*L3^2*M3^2*u1*cos(2*y5)*cos(y3) - L2*L3^2*M3^2*u2*cos(2*y5)*cos(y3) + 2*L1*L2^2*M2*M3*u3*cos(2*y3) - L2*L3^2*M3^2*u1*sin(2*y5)*sin(y3) + L2*L3^2*M3^2*u2*sin(2*y5)*sin(y3) - L1*L3^2*M3^2*u2*cos(2*y3)*cos(2*y5) + L1*L3^2*M3^2*u3*cos(2*y3)*cos(2*y5) - L1*L2^2*L3^2*M2*M3^2*y2^2*sin(2*y3) - L1*L2^2*L3^2*M2^2*M3*y2^2*sin(2*y3) + 2*L1*L2^2*L3^2*M1*M3^2*y2^2*sin(2*y5) - L1*L2^2*L3^2*M2*M3^2*y4^2*sin(2*y3) - L1*L2^2*L3^2*M2^2*M3*y4^2*sin(2*y3) + 2*L1*L2^2*L3^2*M1*M3^2*y4^2*sin(2*y5) + L1*L2^2*L3^2*M1*M3^2*y6^2*sin(2*y5) + 2*L1*L2*L3*M1*M3*u2*cos(y5) - 4*L1*L2*L3*M1*M3*u3*cos(y5) + L1*L2*L3*M2*M3*u2*cos(y5) - 2*L1*L2*L3*M2*M3*u3*cos(y5) - 2*L2^2*L3*M2*M3*u1*sin(y3)*sin(y5) + 2*L2^2*L3*M2*M3*u2*sin(y3)*sin(y5) + 2*L1*L2*L3^3*M1*M3^2*y2^2*sin(y5) + 2*L1*L2^3*L3*M1*M3^2*y2^2*sin(y5) + L1*L2*L3^3*M2*M3^2*y2^2*sin(y5) + 2*L1*L2*L3^3*M1*M3^2*y4^2*sin(y5) + 2*L1*L2^3*L3*M1*M3^2*y4^2*sin(y5) + L1*L2*L3^3*M2*M3^2*y4^2*sin(y5) + 2*L1*L2*L3^3*M1*M3^2*y6^2*sin(y5) + L1*L2*L3^3*M2*M3^2*y6^2*sin(y5) - L1*L2*L3*M3^2*u2*cos(2*y3)*cos(y5) + 2*L1*L2*L3*M3^2*u3*cos(2*y3)*cos(y5) + L1*L2*L3*M3^2*u2*sin(2*y3)*sin(y5) - 2*L1*L2*L3*M3^2*u3*sin(2*y3)*sin(y5) - L1^2*L2*L3^2*M1*M3^2*y2^2*sin(y3) - 2*L1^2*L2*L3^2*M2*M3^2*y2^2*sin(y3) - 2*L1^2*L2*L3^2*M2^2*M3*y2^2*sin(y3) - 2*L1*L2^2*L3^2*M2*M3^2*y2*y4*sin(2*y3) - 2*L1*L2^2*L3^2*M2^2*M3*y2*y4*sin(2*y3) + 4*L1*L2^2*L3^2*M1*M3^2*y2*y4*sin(2*y5) + 2*L1*L2^2*L3^2*M1*M3^2*y2*y6*sin(2*y5) + 2*L1*L2^2*L3^2*M1*M3^2*y4*y6*sin(2*y5) + 2*L1*L2^3*L3*M1*M2*M3*y2^2*sin(y5) + 2*L1*L2^3*L3*M1*M2*M3*y4^2*sin(y5) - L1*L2*L3*M2*M3*u2*cos(2*y3)*cos(y5) + 2*L1*L2*L3*M2*M3*u3*cos(2*y3)*cos(y5) + 4*L1*L2*L3^3*M1*M3^2*y2*y4*sin(y5) + 4*L1*L2^3*L3*M1*M3^2*y2*y4*sin(y5) + 2*L1*L2*L3^3*M2*M3^2*y2*y4*sin(y5) + 4*L1*L2*L3^3*M1*M3^2*y2*y6*sin(y5) + 2*L1*L2*L3^3*M2*M3^2*y2*y6*sin(y5) + 4*L1*L2*L3^3*M1*M3^2*y4*y6*sin(y5) + 2*L1*L2*L3^3*M2*M3^2*y4*y6*sin(y5) + L1*L2*L3*M2*M3*u2*sin(2*y3)*sin(y5) - 2*L1*L2*L3*M2*M3*u3*sin(2*y3)*sin(y5) - L1*L2*L3^3*M2*M3^2*y2^2*cos(2*y3)*sin(y5) - L1*L2*L3^3*M2*M3^2*y2^2*sin(2*y3)*cos(y5) - L1*L2*L3^3*M2*M3^2*y4^2*cos(2*y3)*sin(y5) - L1*L2*L3^3*M2*M3^2*y4^2*sin(2*y3)*cos(y5) - L1*L2*L3^3*M2*M3^2*y6^2*cos(2*y3)*sin(y5) - L1*L2*L3^3*M2*M3^2*y6^2*sin(2*y3)*cos(y5) + 2*L1^2*L2^2*L3*M1*M3^2*y2^2*cos(y3)*sin(y5) - 2*L1^2*L2*L3^2*M1*M2*M3*y2^2*sin(y3) + L1*L2*L3^2*M1*M3^2*g*sin(y1)*sin(y3) + 2*L1*L2*L3^2*M2*M3^2*g*sin(y1)*sin(y3) + 2*L1*L2*L3^2*M2^2*M3*g*sin(y1)*sin(y3) + L1^2*L2*L3^2*M1*M3^2*y2^2*cos(2*y5)*sin(y3) + L1^2*L2*L3^2*M1*M3^2*y2^2*sin(2*y5)*cos(y3) - L1*L2*L3^2*M1*M3^2*g*cos(2*y5)*sin(y1)*sin(y3) - L1*L2*L3^2*M1*M3^2*g*sin(2*y5)*cos(y3)*sin(y1) + 4*L1*L2^3*L3*M1*M2*M3*y2*y4*sin(y5) + 2*L1^2*L2^2*L3*M1*M2*M3*y2^2*cos(y3)*sin(y5) - 2*L1*L2*L3^3*M2*M3^2*y2*y4*cos(2*y3)*sin(y5) - 2*L1*L2*L3^3*M2*M3^2*y2*y4*sin(2*y3)*cos(y5) - 2*L1*L2*L3^3*M2*M3^2*y2*y6*cos(2*y3)*sin(y5) - 2*L1*L2*L3^3*M2*M3^2*y2*y6*sin(2*y3)*cos(y5) - 2*L1*L2*L3^3*M2*M3^2*y4*y6*cos(2*y3)*sin(y5) - 2*L1*L2*L3^3*M2*M3^2*y4*y6*sin(2*y3)*cos(y5) - 2*L1*L2^2*L3*M1*M3^2*g*cos(y3)*sin(y1)*sin(y5) + 2*L1*L2*L3^2*M1*M2*M3*g*sin(y1)*sin(y3) - 2*L1*L2^2*L3*M1*M2*M3*g*cos(y3)*sin(y1)*sin(y5))/(L1*L2^2*L3^2*M3*(M2^2 - M2^2*cos(2*y3) + 2*M1*M2 + M1*M3 + M2*M3 - M2*M3*cos(2*y3) - M1*M3*cos(2*y5)));
  

else % compute total mechanical energy %Check
  dz = m1*l1^2*z(1)^2/8 + I1*z(1)^2/2 + m2/2*(l1^2*z(1)^2 ...
    + l2^2*z(2)^2/4 + l1*l2*z(1)*z(2)*cos(z(4)-z(5))) + I2*z(2)^2/2 ...
    + m1*g*l1*cos(z(4))/2 + m2*g*(l1*cos(z(4))+l2*cos(z(5))/2) ...
    + m3/2*(l1^2*z(1)^2 + l2^2*z(2)^2 + l3^2*z(3)^2/4 ...
    + l1*l2*z(1)*z(2)*cos(z(4)-z(5)) + l2*l3*z(2)*z(3)*cos(z(5)-z(6))... 
    + l1*l2*l3*z(1)*z(2)*z(3)*cos(z(4)-z(5)-z(6))) + I3*z(3)^2/2 ...
    + m3*g*(l1*cos(z(4)) + l2*cos(z(5)) + l3*cos(z(6))/2);
end
