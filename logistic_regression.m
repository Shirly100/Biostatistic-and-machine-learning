%Shirly Ohanona 314793910

load hospital;
diastolic=70;
flag=0;
for systolic=110:10:130%will check 3 different thresholds
    data_bloodPressure = categorical(hospital.BloodPressure(1:90,1) >systolic & hospital.BloodPressure(1:90,2) >diastolic);
    sp = nominal(data_bloodPressure);%change the value of the bloodPressure to number (1/2)
    sp = double(sp);
    s = categorical(hospital.Sex);%change sex to category
    sd = dummyvar(s);
    
    
    data = [sd hospital.Age hospital.Weight hospital.Smoker];
    mat=data(1:90,:);
    test=data(91:100,:);%the data test of the model
    [B,dev] = mnrfit(mat,sp);
    x = mnrval(B,test);

    count=0;
    i=0;
    for n = 91:1:100%checks if the model is right for the data test
        i=i+1;
        if(hospital.BloodPressure(n,1) >systolic && hospital.BloodPressure(n,2) >diastolic)
            if(x(i,2)>x(i,1))%x_first column->false  x_second colmn ->true
                count=count+1;
            end
        elseif(hospital.BloodPressure(n,1) <systolic || hospital.BloodPressure(n,2) <diastolic)
            if(x(i,1)>x(i,2))
                count=count+1;
            end
        end
    end
    if(systolic==110)
        c1=num2str(count);
        sentance1= [c1,' of 10 correct results.'];
        if(count>flag)
            flag=count;
            conclusion='Conclusion: the model predicts better the results for blood pressure 110/70';
        end
    elseif(systolic==120)
        c2=num2str(count);
        sentance2= [c2,' of 10 correct results.'];
        if(count>flag)
            flag=count;
            conclusion='Conclusion: the model predicts better the results for blood pressure 120/80';
        end
    elseif(systolic==130)
        c3=num2str(count);
        sentance3= [c3,' of 10 correct results.'];
        if(count>flag)
            flag=count;
            conclusion='Conclusion: the model predicts better the results for blood pressure 130/90';
        end
    end
    
    diastolic=diastolic+10;
end


 
 fprintf('\n')
 disp( 'For the threshold 110/70:')
 disp(sentance1)
 disp('==========================')
 disp( 'For the threshold 120/80:')
 disp(sentance2)
 disp('==========================')
 disp( 'For the threshold 130/90:')
 disp(sentance3)
 disp('==========================')
 disp(conclusion)


