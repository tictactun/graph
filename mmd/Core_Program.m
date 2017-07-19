%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Please feel free to contact hzhou@stat.wisc.edu %%%%%%
%%% if you have questions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Description of the code:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Xsource,Xtarget: row: sample size, column:dimension %%
%%% We allow Xsource*WS+bs,Xtarget*WT+bt for transformation %%%%%
%%% If Transformation_On_Target = 'No', just Xtarget %%%%%
%%% Max_out_iter: We alternate optimize (WS,bs) and (WT,bt) %%%%%
%%% Max_in_iter: We alternate optimize WS and bs, or WT and bt  %%%%%
%%% Max_intercept_iter: We use gradient descent to optimize bs,bt %%%%
%%% Max_Matrix_iter: Iterations for WS or WT optimization %%%%%
%%% WS_optimize/WT_optimize: 'Mani_Eucli':gradient descent %%%%%%
%%% 'Mani_Stief':gradient descent on Stiefiel manifold %%%%%%%%%%
%%% 'SGD': stochastic gradient descent, don't suggest it unless %%%%
%%% sample size extremly high %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% d:size(WS,2),size(WT,2), the dimension of projection subspace %%%
%%% Objective function value would be printed on windows after each step%%
%%% Researchers can see it gradually decreases %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% some comments code + Test Accuracy here can run officedata set %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% We have "Generate data", "Set up Parameters", "Optimization" %%%%
%%% "Test Accuracy","Hypothesis Testing" %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Researchers can feel free to change them depending on your projects %%
%%% The code here run an example presented in Simple_Simulation_1 %%%
%%% It doesn't have Test Accuracy task. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% It's performance can be measured by estimated WS,bs and pvalue %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Generate data %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---Here, we assume xsource, xtarget have same dimension----------------%
%---Xsource(n,D), n is number of samples, D is dimension----------------%
global Xsource Ysource Xtarget Ytarget XA bA XB sigma transXA
%Office_data
load ../source/dataX.mat dataX 
load ../source/dataY.mat dataY
nAvai = ceil(0.4 * size(dataX, 1));
coeff = pca(dataX);
% X2 = dataX * coeff(:, 1:2);
Xsource = dataX * coeff;
Xtarget = dataY(1:nAvai, :);

% Simple_Simulation_1 %% I use sigma=1, use the commented sigma for real data
D = size(Xsource,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Set up Parameters %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---Here, we consider transformation W_S*xsource+b_s, W_T*xtarget+b_t---%
%---Set up projection dimension for W_S,W_T
%d = getGFKDim(Xsource,Xtarget);
d = size(Xtarget,2);

%---Set up 'No' means no transformation on xtarget----------------------%
Transformation_On_Target = 'No';

%---Set up 'SGD' for stochastic gradient descent, 'Mani_Eucli' for------%
%---gradient descent,'Mani_Stief',gradient descent on Stiefel Manifold--%
WS_optimize = 'Mani_Eucli';
WT_optimize = 'Mani_Eucli'; %Don't have to set if Tran.On.Tar. is 'No'--%

%---Set up inside max_iter and outside max_iter-------------------------%
%---When we optimize two transformations, we iteratively optimize one---%
%---condition on the other for Max_in_iter, we do Max_out_iter for epoch%
%---In each inside loop, we iteratively optimize stiefel matrix and-----%
%---intercept-----------------------------------------------------------%

Max_in_iter = 12;
Max_out_iter = 1; %Set to 1 if Tran.On.Tar. is 'No'------------%
Max_intercept_iter = 6;
Max_Matrix_iter = 8;

%---Set up tuning parameter for Gaussian kernel, default is median dist-%
AllDistance=dist2(Xtarget,Xtarget);
sigma=median(AllDistance(AllDistance~=0)); %% Use this for your real data
%sigma = 1; %% This constant setting is just for Simple_Simulation_1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Optimization %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WS = eye(D,d);
bs = zeros(1,d); %---zeros for intercept --------------------%
WT = eye(d,d);
bt = zeros(1,d); %---zeros for intercept --------------------%

for epoch = 1:Max_out_iter
tic
%---Here, we transform XA to XB ----------------------------------------%
    for inside_iter = 1:Max_in_iter  
        XB = (Xtarget*WT+ones(size(Xtarget,1),1)*bt);
        if Max_intercept_iter>0
        if strcmp(WS_optimize,'Mani_Stief') || strcmp(WS_optimize,'Mani_Eucli') || strcmp(WS_optimize,'SGD')
        %---Optimization on b is convex, dim is d compared to W's Dd----%
        %---We always use gradient descent to solve this easy problem---%
            transXA = Xsource*WS;
            problem.M = euclideanfactory(d,1);
            problem.cost = @Fintercept;
            problem.egrad = @dFintercept;
            options.maxiter = Max_intercept_iter;
            options.verbosity = 0;
            bs = conjugategradient(problem,bs,options);  
        end
        end
        
        XA = Xsource; bA = bs;   
        if strcmp(WS_optimize,'Mani_Stief') || strcmp(WS_optimize,'Mani_Eucli')
            if strcmp(WS_optimize,'Mani_Stief')
                problem.M = stiefelfactory(D,d);
            elseif strcmp(WS_optimize,'Mani_Eucli')
                problem.M = euclideanfactory(D,d);
            end
            problem.cost = @F;
            problem.egrad = @dF;
            options.maxiter = Max_Matrix_iter;
            options.verbosity = 2;
            WS = conjugategradient(problem,WS,options); %Can use steepestdescent%
        elseif strcmp(WS_optimize,'SGD')
            problemSGD.M = 'Eucli'; %Set up 'Stief', then SGD is on Stiefiel manifold%
            problemSGD.cost = @F;%Define a subset type FSGD is sample size too high
            problemSGD.egrad = @dFSGD;
            problemSGD.batch = 5;
            problemSGD.stepsize = @SGDstepsize;
            optionsSGD.maxiter = Max_Matrix_iter;
            optionsSGD.subsetS = 20;
            WS = SGD(problemSGD,WS,optionsSGD);
        end
    end
toc
tic
if strcmp(Transformation_On_Target,'Yes')
%---Here, we transform XA to XB ----------------------------------------%
    for inside_iter = 1:Max_in_iter  
        XB = (Xsource*WS+ones(size(Xsource,1),1)*bs);
        if Max_intercept_iter>0
        if strcmp(WT_optimize,'Mani_Stief') || strcmp(WT_optimize,'Mani_Eucli') || strcmp(WT_optimize,'SGD')
            transXA = Xtarget*WT;
            problem.M = euclideanfactory(d,1);
            problem.cost = @Fintercept;
            problem.egrad = @dFintercept;
            options.maxiter = Max_intercept_iter;
            options.verbosity = 0;
            bt = conjugategradient(problem,bt,options);
        end
        end
        
        XA = Xtarget; bA = bt;
        if strcmp(WT_optimize,'Mani_Stief') || strcmp(WT_optimize,'Mani_Eucli')
            if strcmp(WT_optimize,'Mani_Stief')
                problem.M = stiefelfactory(D,d);
            elseif strcmp(WT_optimize,'Mani_Eucli')
                problem.M = euclideanfactory(D,d);
            end
            problem.cost = @F;
            problem.egrad = @dF;
            options.maxiter = Max_Matrix_iter;
            options.verbosity = 2;
            WT = conjugategradient(problem,WT,options); %Can use steepestdescent%
        elseif strcmp(WT_optimize,'SGD')
            problemSGD.M = 'Stief'; %Set up 'Stief', then SGD is on Stiefiel manifold%
            problemSGD.cost = @F;%Define a subset type FSGD is sample size too high
            problemSGD.egrad = @dFSGD;
            problemSGD.batch = 5;
            problemSGD.stepsize = @SGDstepsize;
            optionsSGD.maxiter = Max_Matrix_iter;
            optionsSGD.subsetS = 20;
            WT = SGD(problemSGD,WT,optionsSGD);
        end
    end
end
toc
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Test Accuracy %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xsource = Xsource*WS+ones(size(Xsource,1),1)*bs;
Xtarget = Xtarget*WT+ones(size(Xtarget,1),1)*bt;

%Test_Accuracy

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Hypothesis testing %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hypothesis_testing

save Xs.mat Xsource

