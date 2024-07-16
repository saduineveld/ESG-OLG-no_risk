function cal_OLG_T2_v3()
% 2 period life cycle model

% cal2: set L1 & L2, such that L_sum = 1 & K/L = KL_targ
% cal3: L2 = 0, adjust beta such that K/L = KL_targ

%% 0. SETTINGS
restoredefaultpath;
clear RESTOREDEFAULTPATH_EXECUTED;
clc;
close all;
dbstop if error

addpath ../mod_fun;


%% 1. PARAMETERS & STEADY STATE
par.TT          = 2;% number of periods
if par.TT ~= 2
    error('Only use two period model')
end

par.alpha       = 0.36;          % coefficient on capital in production function
%par.beta        = 0.985;         % discount rate

par.nu          = 2;            % risk aversion
par.L1_bar          = 1; % Labor supply period 1, period 2
par.L2_bar          = 0;

par.Z_bar        = 1;

par.k1 = 0;

%% Calibration
% Number of years per period:
par.T_lng = 40;

par.delta       = 1-0.9^par.T_lng;% depreciation of capital

par.trg.r_yearly    = 1.04;%/0.96;
par.trg.r_bar       = par.trg.r_yearly^par.T_lng;

par.trg.KL          = fun_KL_targ(par,par.trg.r_bar);
par.trg.K_sum       = par.trg.KL/(par.L1_bar + par.L2_bar);

par.ini.beta0 = 1/par.trg.r_bar;
par.opt.acc = 1e-12;
par.opt.options = optimoptions(@fsolve,'FunctionTolerance',par.opt.acc,'OptimalityTolerance',par.opt.acc,'StepTolerance',par.opt.acc,'Display','off');
[par.beta,RES.residual,RES.ex_fl] = fsolve(@(beta)res_cal3(par,beta),par.ini.beta0,par.opt.options);

if RES.ex_fl < 1
    error('No proper solution found')
end
clear ex_fl

[R_bar,w_bar] = gr_marg_prod(par,par.Z_bar,par.trg.KL);
R_bar
r_bar = R_bar + 1 - par.delta
[c1,k2,c2] = ana_sol_T2(par,par.trg.r_bar,w_bar);

%Check if KL is correct:
par.trg.KL
KL_act = k2/(par.L1_bar + par.L2_bar)

SS.W_bar    = w_bar;
SS.c1       = c1;
SS.k2       = k2;
SS.c2       = c2;
SS.yy       = gr_prod_firm(par,par.Z_bar,SS.k2,par.L1_bar+par.L2_bar);
clear w_bar r_bar c1 k2 c2;


save olg_T2_cal3;



end

%% Residual calibration
function [RES] = res_cal3(par,beta)

par.beta = beta;

[~,w_bar] = gr_marg_prod(par,par.Z_bar,par.trg.KL);

[c1,k2,c2] = ana_sol_T2(par,par.trg.r_bar,w_bar);

RES = log(par.k1 + k2) - log(par.trg.K_sum);

end

%% 
function [KL_targ] = fun_KL_targ(par,r_targ)

R_targ = r_targ + par.delta - 1;

KL_targ = (R_targ/(par.alpha*par.Z_bar))^(1/(par.alpha-1));

end

%% Analytical solution (using recursive method)
function [c1,k2,c2] = ana_sol_T2(par,r_bar,w_bar)

y1 = r_bar*par.k1 + w_bar*par.L1_bar;

c1 = ( r_bar*y1 + w_bar*par.L2_bar ) / ((par.beta*r_bar)^(1/par.nu) + r_bar);

k2 = y1 - c1;

c2 = r_bar*k2 + w_bar*par.L2_bar;

end

