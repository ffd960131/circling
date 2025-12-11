%% ekf_estimate.m
% State-space model + EKF likelihood maximization

clear; clc; close all;
rng(0); % Reproducible random seed

%% -------------------------
% Load observations (positions)
% --------------------------
if ~isfile('traj1_1.mat')
    error('traj1_1.mat not found');
end
load('traj1_1.mat','x','y','th','v','dt');

%M=20;
M = size(x,2);

x1  = 2*(x  - min(x(:)))  / (max(x(:))  - min(x(:)))  - 1;
y1  = 2*(y  - min(y(:)))  / (max(y(:))  - min(y(:)))  - 1;
th1 = 2*(th - min(th(:))) / (max(th(:)) - min(th(:))) - 1;
v1  = 2*(v  - min(v(:)))  / (max(v(:))  - min(v(:)))  - 1;

for i = 1:M
    x  = x1(:,M);
    y  = y1(:,M);
    th = th1(:,M);
    v  = v1(:,M);

    %x=mean(x,2);
    %y=mean(y,2);
    %th=mean(th,2);
    %v=mean(v,2);

    % Use only position as observation (can be extended to include theta)
    obs = [x(:), y(:)]';   % 2 x T
    T = size(obs,2);
    time = (0:T-1)' * dt;

    %% -------------------------
    % Parameterization: parameter vector theta_par to estimate
    % Recommended: [omega, beta, sigx, sigy, sigv, kappa, v0, lambda]
    % --------------------------
    % Initial guess (modifiable)
    p0.omega  = 0.0;
    p0.beta   = 0.2;
    p0.sigx   = 0.05;
    p0.sigy   = 0.05;
    p0.sigv   = 0.05;
    p0.kappa  = 0.3;
    p0.v0     = 1.0;
    p0.lambda = 1.0;

    % Convert parameters to vector (log-transform more stable for variance terms)
    % Parameter vector z = [omega, log(beta), log(sigx), log(sigy), log(sigv), kappa, v0, lambda]
    z0 = [ p0.omega, log(p0.beta), log(p0.sigx), log(p0.sigy), log(p0.sigv), p0.kappa, p0.v0, p0.lambda ]';

    %% Optimization settings
    opts = optimoptions('fminunc','Algorithm','quasi-newton','Display','iter', ...
                        'MaxFunctionEvaluations',1e4,'MaxIterations',1e3);

    % Objective function: negative log-likelihood (EKF)
    negloglik = @(z) ekf_negloglik(z, obs, dt);

    [z_hat, fval, exitflag, output] = fminunc(negloglik, z0, opts);

    %% Parse estimated parameters and save
    est.omega  = z_hat(1);
    est.beta   = exp(z_hat(2));
    est.sigx   = exp(z_hat(3));
    est.sigy   = exp(z_hat(4));
    est.sigv   = exp(z_hat(5));
    est.kappa  = z_hat(6);
    est.v0     = z_hat(7);
    est.lambda = z_hat(8);

    est.negloglik = fval;
    est.exitflag  = exitflag;
    est.output    = output;

    %% Diagnostics: run EKF with estimated parameters, plot residuals and filtered trajectory
    [logL, xs_filt, Ps, innovs, Sigs] = ekf_forward(z_hat, obs, dt);

    innovsx(:,i) = innovs(1,:);
    innovsy(:,i) = innovs(2,:);
end

innovsx = mean(innovsx,2);
innovsy = mean(innovsy,2);
innovs  = [innovsx, innovsy]';

% Plot: observations vs filtered mean
figure;
plot(obs(1,:), obs(2,:), '.','MarkerSize',6); hold on;
plot(xs_filt(1,:), xs_filt(2,:), '-','LineWidth',1.5);
xlabel('X'); ylabel('Y'); axis equal;
title('Observation vs. EKF filtering estimation');

% Plot: innovations (observation - predicted observation)
figure;
subplot(2,1,1);
plot(time(2:end), innovs(1,:));
ylabel('innov_x');
title('EKF innovation');
subplot(2,1,2);
plot(time(2:end), innovs(2,:));
ylabel('innov_y'); xlabel('t (s)');

save('est_params_1_1.mat','est','z_hat','xs_filt','time','innovs');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Local functions in this script: ekf_negloglik, ekf_forward, f_state_predict,
% log_mvnpdf, biasU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function nll = ekf_negloglik(z, obs, dt)
    % Take parameter vector z and return negative log-likelihood (EKF approximation)
    % z = [omega, log(beta), log(sigx), log(sigy), log(sigv), kappa, v0, lambda]
    try
        [logL, ~, ~, ~, ~] = ekf_forward(z, obs, dt);
        nll = -logL;
        if ~isfinite(nll), nll = 1e12; end
    catch ME
        warning('EKF failed during likelihood evaluation: %s', ME.message);
        nll = 1e12;
    end
end

function [logL, xs_filt, Ps, innovs, Sigs] = ekf_forward(z, obs, dt)
    % EKF forward filtering: returns log-likelihood, filtered means xs_filt,
    % covariances Ps, innovation sequence innovs, and innovation covariances Sigs.
    % z as above
    % obs: 2 x T
    T = size(obs,2);

    % Parse parameters
    omega  = z(1);
    beta   = exp(z(2));
    sigx   = exp(z(3));
    sigy   = exp(z(4));
    sigv   = exp(z(5));
    kappa  = z(6);
    v0     = z(7);
    lambda = z(8);

    % Observation noise R: can be adjusted if sensor noise is known
    R = diag([sigx^2, sigy^2]);  % Empirically set to same order; can also be estimated

    % Process noise Q: 4x4 diagonal (based on discretization)
    Q = diag([sigx^2, sigy^2, beta^2, sigv^2]);

    % Initial state (based on first observation)
    x0 = obs(1,1); y0 = obs(2,1);
    th0 = 0; v0_init = v0;
    s_prev = [x0; y0; th0; v0_init];             % 4x1
    P_prev = diag([0.1, 0.1, (pi/4)^2, 0.5]);    % Initial covariance

    xs_filt = zeros(4,T);
    Ps      = zeros(4,4,T);
    innovs  = zeros(2,T-1);
    Sigs    = zeros(2,2,T-1);

    logL = 0;

    for k = 1:T-1
        % 1) Prediction (using deterministic part of state transition)
        [s_pred, F] = f_state_predict(s_prev, omega, kappa, v0, lambda, dt);
        % Discrete process noise linearization: Qd ≈ Q*dt
        Qd = Q * dt;

        P_pred = F * P_prev * F' + Qd;

        % 2) Observation prediction
        % Observation function h(s) = [x; y]
        H = [1 0 0 0; 0 1 0 0]; % Jacobian of h
        z_pred = H * s_pred;

        % 3) Innovation and Kalman gain
        yk = obs(:,k+1);            % Actual observation at time k+1
        innov = yk - z_pred;
        S = H * P_pred * H' + R;

        % Numerical stabilization: ensure S is positive definite
        [~,p_chol] = chol(S);
        if p_chol ~= 0
            S = S + 1e-6 * eye(size(S));
        end

        K = P_pred * H' / S;

        % 4) Update
        s_upd = s_pred + K * innov;
        P_upd = (eye(4) - K*H) * P_pred;

        % Store
        xs_filt(:,k+1) = s_upd;
        Ps(:,:,k+1)    = P_upd;
        innovs(:,k)    = innov;
        Sigs(:,:,k)    = S;

        % 5) Accumulate log-likelihood (multivariate Gaussian)
        % p(yk | y0:k-1) ~ N(z_pred, S)
        logL = logL + log_mvnpdf(innov, zeros(size(innov)), S);

        % Propagate filter
        s_prev = s_upd;
        P_prev = P_upd;
    end

    % Include prior contribution? Typically not for MLE.
    % If you need the estimate at the first time step:
    xs_filt(:,1) = [x0; y0; th0; v0_init];
    Ps(:,:,1)    = P_prev;
end

function [s_pred, F] = f_state_predict(s, omega, kappa, v0, lambda, dt)
    % Compute deterministic prediction at next step and state Jacobian F = df/ds
    % s = [x; y; th; v]
    x  = s(1); y = s(2); th = s(3); v = s(4);

    % Implementation of bias term b(x,y) (consistent with U in simulate_ghosts)
    [Ux, Uy] = biasU(x,y);
    tperp = [-sin(th), cos(th)];
    bias = lambda * (tperp(1)*Ux + tperp(2)*Uy);

    % First predict theta_{k+1} deterministically (no process noise here)
    thp = th + (omega + bias) * dt;
    vp  = v - kappa*(v - v0) * dt;
    xp  = x + vp * cos(thp) * dt;
    yp  = y + vp * sin(thp) * dt;

    s_pred = [xp; yp; wrapToPi(thp); vp];

    % Linearized Jacobian F = ∂f/∂s  (4x4)
    % Derivatives require bias partials w.r.t x, y, th.
    % bias = lambda * tperp * gradU, where tperp depends on th.
    % For robustness, compute partials numerically (finite differences).
    eps = 1e-6;
    F = zeros(4,4);
    for i = 1:4
        ds = zeros(4,1); ds(i) = eps;
        s2 = s + ds;
        x2 = s2(1); y2 = s2(2); th2 = s2(3); v2 = s2(4);
        [Ux2, Uy2] = biasU(x2,y2);
        tperp2 = [-sin(th2), cos(th2)];
        bias2 = lambda * (tperp2(1)*Ux2 + tperp2(2)*Uy2);
        thp2 = th2 + (omega + bias2) * dt;
        vp2  = v2 - kappa*(v2 - v0) * dt;
        xp2  = x2 + vp2 * cos(thp2) * dt;
        yp2  = y2 + vp2 * sin(thp2) * dt;
        s_pred2 = [xp2; yp2; wrapToPi(thp2); vp2];
        F(:,i) = (s_pred2 - s_pred) / eps;
    end
end

function ll = log_mvnpdf(x, mu, S)
    % Log-density of multivariate Gaussian (x is a column vector)
    d = numel(x);
    xmu = x - mu;
    % Use Cholesky for numerical stability
    [U,p] = chol(S);
    if p == 0
        sol = U'\(U\xmu);
        ll = -0.5*(xmu'*sol) - sum(log(diag(U))) - 0.5*d*log(2*pi);
    else
        % S is not positive definite (penalize)
        ll = -1e6;
    end
end

function [Ux, Uy] = biasU(x,y)
    % Gradient of the potential function U, consistent with simulate_ghosts
    % For numerical stability, use analytic chain rule
    r = sqrt( (x-5).^2 + (y-5).^2 );
    sigma = 0.4;
    % U(r) = exp(- (r - 2)^2 / (2*sigma^2))
    Ur = exp(- (r - 2).^2 / (2*sigma^2));
    % dU/dr = Ur * ( - (r-2) / sigma^2 )
    dUdr = Ur .* ( - (r - 2) / (sigma^2) );
    if r == 0
        Ux = 0; Uy = 0;
    else
        Ux = dUdr * (x-5) / r;
        Uy = dUdr * (y-5) / r;
    end
end
