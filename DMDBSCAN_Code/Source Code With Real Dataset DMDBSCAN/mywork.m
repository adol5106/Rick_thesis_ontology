function mywork()

clear;

%==========================================================================
% Load Data Set In Matrix and Initilize The Matrix

z=load ('iris.txt');                  % eta=0.00005    eps=3.5
z3=z;
z(:,5)=[];                            %used with iris dataset to remove coulmns number 5 from dataset which is for classification

% z=load ('haberman.data');                  % eta=0.0005    eps=4.3
% z3=z;
% z(:,4)=[];          %used with haberman dataset to remove coulmn number 4 from dataset which is for classification

% z=load ('glass.data');                    % eta=0.0005    eps=0.85
% z3=z;
% z(:,1)=[];                                %used with glass dataset to remove coulmns number 1 from dataset which is for index
% z(:,10)=[];                               %used with glass dataset to remove coulmns number 10(11 in origin dataset, becomes 10 after remove column number 1 of index) from dataset which is for classification

z1=z;
z2=z;
L=length(z(:,1));                     % size of dataset(# of rows)

testedbyeps=zeros(L,1);
no=1;

%==========================================================================
% Set Parameters For Proposed Method
MinPnts=3;

epslnvib1=7;
epslnvib2=7;
epslnvib3=7;

%==========================================================================
% Find Eps For k Points

DrawKDist(z);

%==========================================================================    
% Calculate Some Values As Described In Each Line
classvm=zeros(L,1);

[testedbyeps,classvm,type,Eps,no]=initialclusters(z1,MinPnts,epslnvib1,testedbyeps,classvm,no);       % apply initialclusters for the dataset  
dlmwrite('c:\classe1.txt',classvm);
[testedbyeps,classvm,type,Eps,no]=initialclusters(z1,MinPnts,epslnvib2,testedbyeps,classvm,no);       % apply initialclusters for the dataset  
dlmwrite('c:\classe2.txt',classvm);
[testedbyeps,classvm,type,Eps,no]=initialclusters(z1,MinPnts,epslnvib3,testedbyeps,classvm,no);       % apply initialclusters for the dataset  
dlmwrite('c:\classe3.txt',classvm);

classvm=sort(classvm,1);
cent=unique(classvm,'first');                   % find #of classes(clusters) returened by applying DBSCAN
    for i=1:length(classvm)
        if classvm(i)==0
            classvm(i)=length(cent)-1;          % any cluster assigned 0, then assign to it new class which equal the number of all clusters minus 1 that is, to avoid 0 index in the array
        end
    end 
cent=unique(classvm,'first');                   % find #of classes(clusters) returened by applying DBSCAN
coreno=length(cent);
classvm
%==========================================================================
% Using Our Proposed Algorithm with real DataSet
cent=unique(classvm,'rows')
cent1=unique(classvm,'first')
lc=length(cent1)
for i=1:lc                                         % classify each data point to its cluster
    dd=length(find(uint32(cent(1,:))==i));
    rsvm(i,1)=dd;
    rsvm(i,2)=i;
end
Class_Data_VMDVBSCAN=rsvm                          % display each data point with its cluster              
correct=0;
for i=1:L
    if classvm(i)==z3(i,5)                         % compare the resluted classifications with original classifications
        correct=correct+1;
    end
end
avg_index_VMDBSCAN=(correct/L)*100                 % claculate the average index error

% %==========================================================================
% % Using DBSCAN with real DataSet
% [classrds]=initialclusters(z2,MinPnts,epsln);       % apply initialclusters for the dataset
% cent=unique(classrds,'rows');
% cent1=unique(classrds,'first');
% lc=length(cent1);
% for i=1:lc                                          % classify each data point to its cluster
%     dd=length(find(uint32(cent(1,:))==i));
%     rsdb(i,1)=dd;
%     rsdb(i,2)=i;
% end
% Class_Data_DBSCAN=rsdb                              % display each data point with its cluster 
% correct=0;
% for i=1:L
%     if classrds(i)==z3(i,5)                         % compare the resluted classifications with original classifications
%         correct=correct+1;
%     end
% end
% avg_index_DBSCAN=(correct/L)*100                    % claculate the average index error

%==========================================================================
% Find Initial Clusters
function [testedbyeps,class,type,Eps,no]=initialclusters(x22,k,Eps,testedbyeps,class,no)
[m,n]=size(x22);
if nargin<3 || isempty(Eps) || Eps==0
   [Eps]=epsilon(x22,k)
end
x22=[[1:m]' x22];  %index rows
[m,n]=size(x22);
type=zeros(1,m);
% no=1;
touched=zeros(m,1);
%class=zeros(m);


for i=1:m
    if testedbyeps(i)==0 && touched(i)==0        
       ob=x22(i,:);
       D=dist(ob(2:n),x22(:,2:n));
       ind=find(D<=Eps);    
       if length(ind)>1 && length(ind)<k+1       
          type(i)=0;
          class(i)=0;
       end
       if length(ind)==1
          type(i)=-1;
          class(i)=-1;  
          touched(i)=1;
          testedbyeps(i)=Eps;
       end
       if length(ind)>=k+1; 
          type(i)=1;
          %testedbyeps(i)=Eps;
          class(ind)=ones(length(ind),1)*max(no);          
          while ~isempty(ind)
                ob=x22(ind(1),:);
                touched(ind(1))=1;
                testedbyeps(ind(1))=Eps;
                ind(1)=[];
                D=dist(ob(2:n),x22(:,2:n));
                i1=find(D<=Eps);     
                if length(i1)>1
                   class(i1)=no;
                   if length(i1)>=k+1;
                      type(ob(1))=1;
                      %testedbyeps(ob(1))=Eps;
                   else
                      type(ob(1))=0;
                      %testedbyeps(ob(1))=Eps;
                   end
                   for i=1:length(i1)
                       if touched(i1(i))==0
                          touched(i1(i))=1;
                          testedbyeps(i1(i))=Eps;
                          ind=[ind i1(i)];
                          class(i1(i))=no;
                       end                    
                   end
                end
          end
          no=no+1; 
       end
    end
end    


%==========================================================================
% Find The Radius
function [Eps]=epsilon(x,k)
[m,n]=size(x);
Eps=((prod(max(x)-min(x))*k*gamma(.5*n+1))/(m*sqrt(pi.^n))).^(1/n);

%==========================================================================
% Find The Distance
function [D]=dist(i,x)
[m,n]=size(x);
D=sqrt(sum((((ones(m,1)*i)-x).^2)'));
if n==1
   D=abs((ones(m,1)*i-x))';
end

function [eps1,eps2,eps3]=DrawKDist(xxx)
 
x=xxx(:,1);
y=xxx(:,2);

z(:,1)=x(:,1);
z(:,2)=y(:,1);

z2=z;

    L = length(z);
    min_dist = zeros(length(z),6); 
    d=zeros(length(z),length(z));  
 
for i = 1:L, 
         minval1 = 0;
         minval2 = 0;
         minval3 = 0;
        for j = 1:L,
           d(i,j)=sqrt((z(i,1)-z(j,1))^2+(z(i,2)-z(j,2))^2);
           if d(i,j)>0 && (minval1 == 0 || d(i,j) < minval1) %|| (minval1<minval2) || (minval1<minval3)
                minval1 = d(i,j);
                min_dist(i,1)= j;
                min_dist(i,2)= d(i,j);
           end
           if d(i,j)>0 && (minval2 == 0 || d(i,j) < minval2 && d(i,j) > minval1 && minval2>minval1) %|| ((minval2>minval1) && (minval2<minval3))
                minval2 = d(i,j);
                min_dist(i,3)= j;
                min_dist(i,4)= d(i,j);
           end
           if d(i,j)>0 && (minval3 == 0 || d(i,j) < minval3 && d(i,j) > minval1 && d(i,j) > minval2 && minval2>minval1 && minval3>minval1)
                minval3 = d(i,j);
                min_dist(i,5)= j;
                min_dist(i,6)= d(i,j);
           end            
        end 
end

ddd=mean(min_dist)
eee=std(min_dist)

eps1=ddd(1,2)+eee(1,2)
eps2=ddd(1,4)+eee(1,4)
eps3=ddd(1,6)+eee(1,6)


% eps1=std(min_dist);
        figure(100);
        plot(sort(min_dist(:,2)),'-');
        figure(101);
        plot(min_dist(:,2),'-');
        hold off;
        figure(102);
        plot(sort(min_dist(:,4)),'-');
        figure(103);
        plot(min_dist(:,4),'-');
        hold off;
        figure(104);
        plot(sort(min_dist(:,6)),'-');
        figure(105);
        plot(min_dist(:,6),'-');
        hold off;