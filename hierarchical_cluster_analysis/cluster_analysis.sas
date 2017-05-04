proc import datafile="I:\Dropbox\Qingyun-Zhang\Thesis-799A\data_querying_code\cluster_analysis\san_diego.dbf"
	out=sandiego_data replace;
run;

Proc Cluster Data=sandiego_data Method=Single 
	OutTree=TreeData std ccc pseudo;
	Var X Y;
	Id id;
Run;

GOptions Reset=Symbol Reset=Axis;
Proc GPlot Data=TreeData ;
 	Plot _HEIGHT_*_NCL_=1 / HAxis=Axis1;
	
 	*Axis1 Label=(A=90);
	Axis1 order=0 to 200 by 10;
 	Symbol1 C=Black V=Dot I=SplineS;
Run;


Proc Tree Data=TreeData VAxis=Axis1 out=clus_Data horizontal 
nclusters=18;
 	Id id;
 	Axis1 Label=(A=90);
	copy X Y;
Run;

Goptions Reset=Symbol Reset=Axis;
legend1 across=2 frame cframe=ligr label=none cborder=black 
       position=center value=(justify=center); 
axis1 label=(angle=90 rotate=0) minor=none; 
axis2 minor=none;  

proc gplot data=clus_Data; 
   plot Y*X=Cluster/cframe=ligr 
        legend=legend1 vaxis=axis1 haxis=axis2;  
		Symbol V=Dot I=none;
   title2 'Plot of Clusters by Hierarchical Cluster Analysis'; 
run;

