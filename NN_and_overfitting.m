%Shirly Ohanona 314793910
%%
load fisheriris
x=meas';
x_3=x(1:3,:);%taking only the first three features
t=zeros(3,150);
i=1;
for i=1:150%making the tags matrix
    if(strcmp(species(i,1) ,'versicolor'))
       
        t(2,i)=1;
    elseif(strcmp(species(i,1) ,'setosa'))
        t(1,i)=1;
         
    elseif(strcmp(species(i,1) ,'virginica'))
        t(3,i)=1;
        
    end
end




e=[];
size=[];
for i = 1:1:25%making 25 attempts to find the optimal number of neurons
    net.trainParam.showWindow = 0;
    net = patternnet(i); %trying differents numbers of neurons
    [net, tr]=train(net,x_3,t); 
  %  nntraintool
    
    testX = x_3(:,tr.testInd);
    testT = t(:,tr.testInd); 
    testY = net(testX);
    
    [c,cm] = confusion(testT,testY); 
    
    e = [e,c];%vector of error rates
    size=[size,i];
end

error=100;
place=0;
for i=1:1:25
    if(e(i)<error)
        error=e(i);%finding the smollest error
        place=i;
    end
end
disp('The optimal number of neurons:');
disp(size(place));
disp('===============================================================================')

%%

load fisheriris 
sp=categorical(species);
x1=meas(51:150,1:3); %the first three features of the Iris dataset, for virginica and versicolor only. 
t1=sp(51:150,:);


F1scores=[];
pscores=[];
Rscores=[];
for i = 1:1:50 %running 50 times to find the averages
    test=[];
    type={};
    training=[];
    t_training=[];
    %making randomly test sets
    idx = randperm(100);%random vector of numbers 1-100
    for j=1:1:30
        test=[test;x1(idx(j),:)];%taking random data. the size of the test set is 30
        if(idx(j)<=50)%the first 50 are versicolors and the other are virginicas
        
            type{end+1}='versicolor';
        else
            
            type{end+1}='virginica';
        end
        
    end
    
    %creating the training set
    for j=31:1:100
        training=[training;x1(idx(j),:)];%taking random data. the size of the training set is 70->what is left after making the test set
        t_training=[t_training;t1(idx(j),:)];
        
        
    end
    
    [B,dev] = mnrfit(training,t_training);
    evaluation = mnrval(B,test);
    e = evaluation(:,2)>evaluation(: ,3);
    TP=0;
    FN=0;
    FP=0;
    TN=0;
    for k=1:1:30
        if(e(k,:)==1 && strcmpi(type{k},'versicolor'))
            TP=TP+1;
        elseif(e(k,:)==0 && strcmpi(type{k},'versicolor'))
            FN=FN+1;
        elseif(e(k,:)==1 && strcmpi(type{k},'virginica'))
             FP=FP+1;
        elseif(e(k,:)==0 && strcmpi(type{k},'virginica'))
             TN=TN+1;
        end
    end
   
    Precision = TP/(TP+FP);
    Recall = TP/(TP+FN);
    F1 = 2 * Recall * Precision / (Recall + Precision);
    F1scores=[F1scores;F1];
    pscores=[pscores; Precision];
    Rscores=[Rscores;Recall];


end

sumP=0;
sumF1=0;
sumR=0;

for i = 1:1:50
    sumP=sumP+pscores(i,1);
    sumR=sumR+Rscores(i,1);
    sumF1=sumF1+ F1scores(i,1);
end
%finding the average precision, recall and F1 scores
AvgF1= sumF1/50;
AvgP=sumP/50;
AvgR=sumR/50;


disp('The average F1 is: ');
disp(AvgF1);
disp('-------------------------')
disp('The average precision is: ');
disp(AvgP);
disp('-------------------------')
disp('The average recall is: ' );
disp(AvgR)

%%

%{

The all output:
The optimal number of neurons:
      10   //an example

===============================================================================
The average F1 is: 
     0.9148

-------------------------
The average precision is: 
    0.9264

-------------------------
The average recall is: 
    0.9178


%}



