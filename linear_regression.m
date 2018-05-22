%Shirly Ohanona 314793910
%Malki Aker 316301191
%=========================================================================================================================================================================================
load hospital;
dsa = dataset(hospital.Age,hospital.Weight,hospital.Smoker,hospital.BloodPressure(:,2),'VarNames',{'Age','Weight','Smoker','BloodPressure_diastolic'});%create a database

%=========================================================================================================================================================================================
lm = fitlm(dsa);

%=========================================================================================================================================================================================

%{
question 4 from the presentation-not home work
T=[0 0 0 0;1 0 0 0;0 1 0 0;0 0 1 0;3 0 0 0; 0 3 0 0; 1 0 1 0];
ml=fitlm(dsa,T);
%}

%=========================================================================================================================================================================================

combos = combntns([0 0 0 1 1 1 2 2 2 3 3 3 4 4 4 5 5 5 6 6 6 ],3);%generate a matrix of 3 columns with all the combination of (0,6)
matrix = [combos zeros(size(combos,1),1)];%add a columns of zeroes to the matrix (for the Y value-> diastolic blood pressure)
Explict_Model = unique(matrix,'rows');%delete the duplicates rows (combos add duplicates rows). Explict_Model is the final matrix to find the linear model
ml2=fitlm(dsa,Explict_Model);%find the linear model
%=========================================================================================================================================================================================
