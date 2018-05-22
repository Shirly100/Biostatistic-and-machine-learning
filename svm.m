%Shirly Ohanona 314793910
%The answers are in the end of this file
%%

load ionosphere;
rng(1);
x_=X(1:254,:);% chose  the first 254 samples 
y_=Y(1:254,:);% takes the tags of  the first 254 samples 


test=[];
y_test=[];
training=[];
y_training=[];
idx = randperm(254);%generate random vector of size 254
for j=1:1:50
    test=[test;x_(idx(j),:)];%generate random test set in size 50
    y_test=[y_test;y_(idx(j),:)];
           
end

for j=51:1:254%generate the training test
    training=[training;x_(idx(j),:)];%taking random data. the size of the training set is 204->what is left after making the test set
    y_training=[y_training;y_(idx(j),:)];
        
        
end


%Training an SVM Classifier
SVMModel_radial = fitcsvm(training,y_training,'KernelFunction','rbf','Standardize',true,'ClassNames',{'b','g'});% radial kernel
SVMModel_gaussian = fitcsvm(training,y_training,'KernelFunction','gaussian','Standardize',true,'ClassNames',{'b','g'});  %gaussian kernel
SVMModel_linear = fitcsvm(training,y_training,'KernelFunction','linear','Standardize',true,'ClassNames',{'b','g'}); % linear kernel

%Classifying New Data with an SVM Classifier
[label_SVMModel_radial,score_SVMModel_radia] = predict(SVMModel_radial,test);
[label_SVMModel_gaussian,score_SVMModel_gaussian] = predict(SVMModel_gaussian,test);
[label_SVMModel_linear,score_SVMModel_linea] = predict(SVMModel_linear,test);

%checking which has the best performances 
right_results_r=0;
right_results_g=0;
right_results_l=0;
vec=[];
kernels={ 'radial' ,'gaussian','linear' };

for i=1:1:50
    if(strcmp(y_test(i,1) ,label_SVMModel_radial(i,1)))
        right_results_r=right_results_r+1;
        
    end
    if(strcmp(y_test(i,1) ,label_SVMModel_gaussian(i,1)))
       right_results_g=right_results_g+1;
        
    end
    if(strcmp(y_test(i,1) ,label_SVMModel_linear(i,1)))
        right_results_l=right_results_l+1;
        
    end
    
end
vec=[vec,right_results_r];
vec=[vec,right_results_g];
vec=[vec,right_results_l];
[max_num,max_idx] = max(vec(:));
for i=1:1:3
    if(max_idx==i)
        answer=[kernels{i},' kernel has the best performances because it predicts right ',num2str(vec(i)), ' from 50 samples'];
        disp(answer);
    end
end
%%

%compareing the performances to neural network.
t_train=zeros(2,204);
i=1;
for i=1:204%making the tags training set matrix
    if(strcmp(y_training(i,1) ,'g'))
       
        t_train(2,i)=1;
    elseif(strcmp(y_training(i,1) ,'b'))
        t_train(1,i)=1;
         
  
        
    end
end

t_test=zeros(2,50);
j=1;
for j=1:50%making the tags test set matrix
    if(strcmp(y_test(j,1) ,'g'))
       
        t_test(2,j)=1;
    elseif(strcmp( y_test(j,1) ,'b'))
        t_test(1,j)=1;
         
  
        
    end
end
sum_testY=0;
for i=1:100
    net = patternnet(10); % create a network with 10 neurons
    [net, tr]=train(net,training',t_train); 
    testY = net( test');% how the NN classified the test
    [c,cm] = confusion(t_test,testY); 
    nnResults=0;
    sum_testY=sum_testY+testY;%we want to calculate the average to find average performance
end
avg_testY=sum_testY/100;%calculates average
%checking results, compare results of the NN to the test set
for i=1:50
    if(t_test(1,i)>t_test(2,i)&&avg_testY(1,i)>avg_testY(2,i))
        nnResults=nnResults+1;
    elseif(t_test(1,i)<t_test(2,i)&&avg_testY(1,i)<avg_testY(2,i))
        nnResults=nnResults+1;
    end
end

answer=['The neural network predicted right ',num2str(nnResults), ' from 50 samples'];
disp(answer);

%{
output:
linear kernel has the best performances because it predicts right 40 from 50 samples
The neural network predicted right 42 from 50 samples

answers:
(I genareted the training and the test sets ,randomaly-> so the
outputs may be a little different in each running. I answered the question according to the
results that I got.)
why the linear kernel has the best performance:
The linear kernel tends to perform very well when the number of features is
large, here we had 34 feature and that is the reason that the linear kernel
gave the best results. (but the number of features is not larger than
the number of observations so I dont know why the linear kernel gave the best
results).
maybe the data is linearly separable and this is the reason of the good performance of the linear kernel.

according to the results, NN gave the best results.
NN is good for  multi dimensions data sets, so it worked well here. 
%}    
