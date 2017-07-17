global Xsource Ysource Xtarget Ytarget
src = 'Caltech10';
tgt = 'webcam';

%--------------------I. prepare data--------------------------------------
load(['data/' src '_SURF_L10.mat']);     % source domain
fts = fts ./ repmat(sum(fts,2),1,size(fts,2));
Xr = zscore(fts,1);
clear fts
Yr = labels;           clear labels

load(['data/' tgt '_SURF_L10.mat']);     % target domain
fts = fts ./ repmat(sum(fts,2),1,size(fts,2));
Xt = zscore(fts,1);
clear fts
Yt = labels;            clear labels

fprintf('\nsource (%s) --> target (%s):\n', src, tgt);
[~,tmp] = princomp([Xr;Xt],'econ');
Xr2 = tmp(1:size(Xr,1),:);
Xt2 = tmp(size(Xr,1)+1:end,:);

if size(Xr2,1)>100
    pos_r = randperm(size(Xr2,1),100);
    Xr2 = Xr2(pos_r,:);
    Yr = Yr(pos_r,:);
end
if size(Xt2,1)>100
    pos_t = randperm(size(Xt2,1),100);
    Xt2 = Xt2(pos_t,:);
    Yt = Yt(pos_t,:);
end

Xsource = Xr2;
Ysource = Yr;
Xtarget = Xt2;
Ytarget = Yt;

