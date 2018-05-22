%Shirly Ohanona 314793910
%%
load hospital;
X = [hospital.Age hospital.Weight];
% building a tree to predict the blood pressure (first value) as a function of age and weight

Mdl = fitrtree(X,hospital.BloodPressure(:,1));
view(Mdl,'mode','graph');
%%
%Evaluate the tree performances using the training and a cross validation (CV) set
cvrtree1 = crossval(Mdl);
cvloss1 = kfoldLoss(cvrtree1);
resuberror1=resubLoss(Mdl);
x=['The error rate of the cv is: ',num2str(cvloss1), ' The error rate of the training is ',num2str(resuberror1)];
disp(x);
%%    

%Prune the tree until pruning parameter = 2 and evaluate the performances 

for i=0:1:2
    Mdl = fitrtree(X,hospital.BloodPressure(:,1));
    tree = prune(Mdl,'Level',i);% pruning levels 0,1,2
    view(tree,'mode','graph')
    cvrtree2 = crossval(tree);
    cvloss2 = kfoldLoss(cvrtree2);
    resuberror2=resubLoss(tree);
    x=['The error rate of the cv in prunning size ',num2str(i),' is: ',num2str(cvloss2),' The error rate of the training is ',num2str(resuberror2)];
    disp(x);
    
   
end
%%
%Ploting a graph of performance as a function of pruning, both for the training and the CV sets (in one graph)
resuberror=zeros(13,1);
err = zeros(13,1);
prune_level=zeros(13,1);
Y=hospital.BloodPressure(:,1);
for n=1:13
    prune_level(n)=n;
    Mdl = fitrtree(X,Y);
    t  = prune(Mdl,'Level',n);
    cvrtree3 = crossval(t);
    err(n) = kfoldLoss(cvrtree3);
   resuberror(n)=resubLoss(t);
    
end

figure
hold on
plot(prune_level, resuberror,'b');
plot(prune_level, err,'r');
xlabel('pruning level');
ylabel('error');
title('performance as a function of pruning')
legend('training','cv sets')






