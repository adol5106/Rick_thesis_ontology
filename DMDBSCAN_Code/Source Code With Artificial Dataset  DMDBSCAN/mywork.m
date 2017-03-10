function mywork()

clear;

%==========================================================================
% Load Data Set In Matrix and Initilize The Matrix
load www.txt;                   % load dataset eta=0.0005    esp=11.8
x=www(:,:);                     

% load 'moon5noise.txt';          % eta=0.0005  epslon DBSCAN=8
% x=moon5noise(:,:);

% load 'twomoon.txt';             % eta=0.005
% x=twomoon(:,:);


L=length(x);                      % size of dataset(# of rows)
z1=x;
z2=x;
z3=x;
densnc=zeros(L,2);
densc=zeros(L);

%==========================================================================
% Set Parameters For Proposed Method
eta=0.005;
T=L*10;
iteration_loop=3;
epsln=11.8;
MinPnts=5;

%==========================================================================
%Start The proposed Method
for xxx=1:iteration_loop            % start looping

%==========================================================================
% Find out the density function for each data point in the data set    
    for j=1:L
        sumdncj=0;    
        for k=1:L
            d1=sqrt((z1(j,1)-z1(k,1))^2+(z1(j,2)-z1(k,2))^2);     % calculate the density function for each point in its cluster
            sumdncj=sumdncj+d1;
        end
        densnc(j,2)=sumdncj;                                          % density for each point with clustering    
        densnc(j,1)=j;
    end       

%==========================================================================    
% Calculate Some Values As Described In Each Line
[class]=initialclusters(z1,MinPnts,epsln);       % apply initialclusters for the dataset
class=sort(class,1);
cent=unique(class,'first');                   % find #of classes(clusters) returened by applying DBSCAN
    for i=1:length(class)
        if class(i)==0
            class(i)=length(cent)-1;          % any cluster assigned 0, then assign to it new class which equal the number of all clusters minus 1 that is, to avoid 0 index in the array
        end
    end 
cent=unique(class,'first');                   % find #of classes(clusters) returened by applying DBSCAN
coreno=length(cent);
core=zeros(coreno,2);                         % initilize the original core clusters matrix

%==========================================================================
% Find out the core and its density function in each cluster
    for j=1:L
        sumcj=0;
        c=class(j);
        for k=1:find(uint32(class(:))==c)
            d2=sqrt((z1(j,1)-z1(k,1))^2+(z1(j,2)-z1(k,2))^2);        % calculate the density function for each point in its cluster
            sumcj=sumcj+d2;
        end
        densc(j)=sumcj;                                              % density for each point with clustering    
        if c>0
            if core(c,1)>densc(j) || core(c,1)==0                    % find each core and its index the dataset, then save them in new matrix core.
                core(c,1)=densc(j);                                  % density value for the core point
                core(c,2)=j;                                         % index for the core point in the original dataset                
            end
        end
    end
    
%==========================================================================
% Test if the clusters need to be merged
% That is, if density of any point with its core cluster is greater than
% the density function of that point with other core, if so, merge.
    for r=1:L
        ww=0;
        ww1=0;
        c=class(r);
        if (c > 0)
            ww=abs(densnc(r)-core(c,1));                    % diff between the tested point and its core cluster
            for s=1:length(core)-1
                if c ~= core(s,2)
                    ww1=abs(densnc(r)-core(s,1));           % diff between the tested point and all other cores cluster
                    if ww1<=ww
                        for i = 1:L,
                            if class(i) == s
                                segma=exp((-i/T));          % for reduction rate, as iterations increades, then reduce the effect of vibration                        
                                z1(i,:)= z1(i,:)+eta*(z1(s,:)-z1(i,:))*(exp((-1/2*segma^2)));   % move point to new location according to the vibration rate
                            else
                                z1(i,:)=z1(i,:);            % no moving for the point if it does not belong to the cluster which be tested
                            end 
                        end
                    end
                end
            end
        end
    end  
end

%==========================================================================
% Draw the clusters on plot - before apply any algorithm
close all;
q = figure;
set(q,'name','Before Proposed Any Algorithm','numbertitle','off')
hold on
plot(x(:,1),x(:,2),'r.','MarkerSize',5)            

%==========================================================================
% Draw the clusters on plot - before apply our proposed algorithm
[old_class]=initialclusters(x,MinPnts,epsln);
f = figure;
set(f,'name','Based On DBSCAN Algorithm','numbertitle','off')
hold on
tt=  max((unique(old_class))); 
colors1={'r.' 'k.' 'b.' 'y.' 'm.' 'c.' 'r*' 'g*' 'b*' 'm*' 'c*' 'k*' 'rx' 'gx' 'bx' 'mx' 'g*'};
colors2={'r+' 'k+' 'm+' 'y*' 'b+' 'g+' 'rs' 'gs' 'bs' 'ys' 'ms' 'cs' 'ks' 'rd' 'ys' 'gd' 'bd' 'kd' 'md' 'y+'};
colors3={'rv' 'gv' 'yv' 'cv' 'kv' 'mv' 'bv' 'rs' 'gs' 'bs' 'ms' 'cs' 'ks' 'cd' 'yd' 'cx' 'kx' 'yx' 'yv'};
for i=1:tt
    for j=1:size(z2,1)
        if old_class(j)==i
            if i<=floor(tt/3)
                plot(z2(j,1),z2(j,2),colors3{i},'MarkerSize',5);
            elseif i>=floor(2*tt/3)
                plot(z2(j,1),z2(j,2),colors1{i-floor(2*tt/3)+1},'MarkerSize',5);
            else
                plot(z2(j,1),z2(j,2),colors2{i-floor(tt/3)+1},'MarkerSize',5); 
            end
        end
    end
end

%==========================================================================
% Draw the clusters on plot - after apply our proposed algorithm
h = figure;
set(h,'name','After Proposed Our Algorithm','numbertitle','off')
hold on;
tt=  max((unique(class))); 
colors1={'r.' 'k.' 'b.' 'y.' 'm.' 'c.' 'r*' 'g*' 'b*' 'm*' 'c*' 'k*' 'rx' 'gx' 'bx' 'mx' 'g*'};
colors2={'r+' 'k+' 'm+' 'y*' 'b+' 'g+' 'rs' 'gs' 'bs' 'ys' 'ms' 'cs' 'ks' 'rd' 'ys' 'gd' 'bd' 'kd' 'md' 'y+'};
colors3={'rv' 'gv' 'yv' 'cv' 'kv' 'mv' 'bv' 'rs' 'gs' 'bs' 'ms' 'cs' 'ks' 'cd' 'yd' 'cx' 'kx' 'yx' 'yv'};
for i=1:tt
    for j=1:size(z3,1)
        if class(j)==i
            if i<=floor(tt/3)
                plot(z3(j,1),z3(j,2),colors3{i},'MarkerSize',5);
            elseif i>=floor(2*tt/3)
                plot(z3(j,1),z3(j,2),colors1{i-floor(2*tt/3)+1},'MarkerSize',5);
            else
                plot(z3(j,1),z3(j,2),colors2{i-floor(tt/3)+1},'MarkerSize',5); 
            end
        end
    end
end

% for i=1:length(core)
%     if core(i,2)~=0
%         plot(z3(core(i,2),1),z3(core(i,2),2),'O','MarkerSize',8)      % to plot each cnetroid
%     end
% end

%==========================================================================
% Find Initial Clusters
function [class]=initialclusters(x,k,Eps)
[m,n]=size(x);
if nargin<3 || isempty(Eps) || Eps == 0
   [Eps]=epsilon(x,k)
end
x=[[1:m]' x];  % index rows
[m,n]=size(x);
type=zeros(1,m);
no=1;
touched=zeros(m,1);
for i=1:m
    if touched(i)==0;
       ob=x(i,:);
       D=dist(ob(2:n),x(:,2:n));
       ind=find(D<=Eps);    
       if length(ind)>1 && length(ind)<k+1       
          type(i)=0;
          class(i)=0;
       end
       if length(ind)==1
          type(i)=-1;
          class(i)=-1;  
          touched(i)=1;
       end
       if length(ind)>=k+1; 
          type(i)=1;
          class(ind)=ones(length(ind),1)*max(no);          
          while ~isempty(ind)
                ob=x(ind(1),:);
                touched(ind(1))=1;
                ind(1)=[];
                D=dist(ob(2:n),x(:,2:n));
                i1=find(D<=Eps);     
                if length(i1)>1
                   class(i1)=no;
                   if length(i1)>=k+1;
                      type(ob(1))=1;
                   else
                      type(ob(1))=0;
                   end
                   for i=1:length(i1)
                       if touched(i1(i))==0
                          touched(i1(i))=1;
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