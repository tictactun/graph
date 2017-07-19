global Xsource Ysource Xtarget Ytarget
[~, accy_predict_target_knn] = my_kernel_knn(Xsource, Ysource, Xtarget, Ytarget);
[~, accy_predict_source_knn] = my_kernel_knn(Xtarget, Ytarget, Xsource, Ysource);
% 
% D = dist2(Xsource,Xtarget);
% gamma = 1/(median(D(D~=0)));
% gamma1 = 1/mean(D(D~=0));
% gamma2 = 1/(2*mean(D(D~=0)));
% gamma3 = 1/(4*mean(D(D~=0)));
% gammaArr=[1e-1 1e-2 1e-3 1e-4 gamma gamma1 gamma2 gamma3];
% reg=[1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 1 1e+1 1e+2 1e+3 1e+4 1e+5 1e+6];
% accy_predict_target_deg2_seq=zeros(1,length(gammaArr)*length(reg));
% accy_predict_source_deg2_seq=zeros(1,length(gammaArr)*length(reg));
% c=1;
% for i=1:length(gammaArr)
%     for j=1:length(reg)
%         t=templateSVM('KernelFunction','polynomial','PolynomialOrder',2,'KernelScale',1./sqrt(gammaArr(i)),'BoxConstraint',reg(j));
%         SVM=fitcecoc(Xsource,Ysource,'Learners',t);
%         label_predict=predict(SVM,Xtarget);
%         accy_predict_target_deg2_seq(c)=sum(label_predict==Ytarget)/length(Ytarget)*100;
%         SVM=fitcecoc(Xtarget,Ytarget,'Learners',t);
%         label_predict=predict(SVM,Xsource);
%         accy_predict_source_deg2_seq(c)=sum(label_predict==Ysource)/length(Ysource)*100;
%         c=c+1;
%     end
% end
% accy_predict_target_deg2=max(accy_predict_target_deg2_seq);
% accy_predict_source_deg2=max(accy_predict_source_deg2_seq);

% accy_predict_target_deg4_seq=zeros(1,length(gammaArr)*length(reg));
% accy_predict_source_deg4_seq=zeros(1,length(gammaArr)*length(reg));
% c=1;
% for i=1:length(gammaArr)
%     for j=1:length(reg)
%         t=templateSVM('KernelFunction','polynomial','PolynomialOrder',4,'KernelScale',1./sqrt(gammaArr(i)),'BoxConstraint',reg(j));
%         SVM=fitcecoc(Xsource,Ysource,'Learners',t);
%         label_predict=predict(SVM,Xtarget);
%         accy_predict_target_deg4_seq(c)=sum(label_predict==Ytarget)/length(Ytarget)*100;
%         SVM=fitcecoc(Xtarget,Ytarget,'Learners',t);
%         label_predict=predict(SVM,Xsource);
%         accy_predict_source_deg4_seq(c)=sum(label_predict==Ysource)/length(Ysource)*100;
%         c=c+1;
%     end
% end
% accy_predict_target_deg4=max(accy_predict_target_deg4_seq);
% accy_predict_source_deg4=max(accy_predict_source_deg4_seq);
% 
% accy_predict_target_exp_seq=zeros(1,length(gammaArr)*length(reg));
% accy_predict_source_exp_seq=zeros(1,length(gammaArr)*length(reg));
% c=1;
% for i=1:length(gammaArr)
%     for j=1:length(reg)
%         t=templateSVM('KernelFunction','gaussian','KernelScale',1./sqrt(gammaArr(i)),'BoxConstraint',reg(j));
%         SVM=fitcecoc(Xsource,Ysource,'Learners',t);
%         label_predict=predict(SVM,Xtarget);
%         accy_predict_target_exp_seq(c)=sum(label_predict==Ytarget)/length(Ytarget)*100;
%         SVM=fitcecoc(Xtarget,Ytarget,'Learners',t);
%         label_predict=predict(SVM,Xsource);
%         accy_predict_source_exp_seq(c)=sum(label_predict==Ysource)/length(Ysource)*100;
%         c=c+1;
%     end
% end
% accy_predict_target_exp=max(accy_predict_target_exp_seq);
% accy_predict_source_exp=max(accy_predict_source_exp_seq);

moveS=norm(WS-eye(size(WS)),'fro');
moveT=norm(WT-eye(size(WT)),'fro');
fprintf([src 'to' tgt '1NN mean accuracy: %2.2f%%\n\n'], accy_predict_target_knn*100);
fprintf([tgt 'to' src '1NN mean accuracy: %2.2f%%\n\n'], accy_predict_source_knn*100);
% fprintf([src 'to' tgt 'Degree 2 SVM mean accuracy: %2.2f%%\n\n'], accy_predict_target_deg2);
% fprintf([tgt 'to' src 'Degree 2 SVM mean accuracy: %2.2f%%\n\n'], accy_predict_source_deg2);
% fprintf([src 'to' tgt 'Degree 4 SVM mean accuracy: %2.2f%%\n\n'], accy_predict_target_deg4);
% fprintf([tgt 'to' src 'Degree 4 SVM mean accuracy: %2.2f%%\n\n'], accy_predict_source_deg4);
% fprintf([src 'to' tgt 'Gaussian SVM mean accuracy: %2.2f%%\n\n'], accy_predict_target_exp);
% fprintf([tgt 'to' src 'Gaussian SVM mean accuracy: %2.2f%%\n\n'], accy_predict_source_exp);