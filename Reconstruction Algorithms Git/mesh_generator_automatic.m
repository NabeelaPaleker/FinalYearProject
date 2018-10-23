%Generate a mesh with any number of circles and nodes per circle
%INPUTS: number of elements, number of circles, radius per circle, number of
%nodes, nodes per circle, injection currents

%INPUT: constants


clear;

boundary_node_multiplier1    = 1;
number_of_electrodes1        = 8;
nodes_per_circle1            = [number_of_electrodes1, 4, 1];
radius_per_circle1           = [10,5,0];
number_of_circles1           = 3;
number_of_nodes1             = 13;
number_of_elements1          = 16;

%Mesh Data 2
boundary_node_multiplier2    = 1;
number_of_electrodes2        = 16; %number of nodes on the outside  
nodes_per_circle2            = [number_of_electrodes2*boundary_node_multiplier2, 8, 1]; %nodes in each circle starting from outer circle
radius_per_circle2           = [10,6,0]; %radius of each circle corresponding to nodes_per_circle
number_of_circles2           = 3; 
number_of_nodes2             = 25; %total number of nodes 
number_of_elements2          = 32; %total number of elements formed by the nodes

boundary_node_multiplier3    =1;
number_of_electrodes3        = 16;
nodes_per_circle3            = [16,16, 16,16,16,16, 16,16,16, 1];
radius_per_circle3           = [10,9,8,7,6,5,4,3,2,0];
number_of_circles3           = 10;
number_of_nodes3             = 161-16;
number_of_elements3          = 272;

number_of_electrodes4        = 16;
nodes_per_circle4            = [number_of_electrodes4,16, 16,16,16, 16,1];
radius_per_circle4           = [10,9.5,8.5,7,5,3,0];
number_of_circles4           = 7;
number_of_nodes4             = 97;
number_of_elements4          = 176;

number_of_electrodes5        = 16;
nodes_per_circle5            = [number_of_electrodes4, 16,1];
radius_per_circle5           = [10,5,0];
number_of_circles5           = 3;
number_of_nodes5             = 33;
number_of_elements5          = 48;



number_of_electrodes6        = 16;
nodes_per_circle6            = [number_of_electrodes4, 32, 64, 64, 64, 64, 64, 64, 32,32,32,32,1];
radius_per_circle6           = 0.1*[10,9.9,9.5,9,8.5,8,7,6,5,4,3,2,0];
number_of_circles6           = 13;
number_of_nodes6             = 561;
number_of_elements6          = 1088;


number_of_electrodes6        = 16;
nodes_per_circle6            = [number_of_electrodes4, 16, 16, 32, 32, 16, 16, 16, 16,16,1];
radius_per_circle6           = 0.1*[10,9.7,9.2,8.4,8.1,7.8,7,6,5,3,0];
number_of_circles6           = 11;
number_of_nodes6             = 225-32;
number_of_elements6          = 368;







boundary_node_multiplier6=1;
number_of_electrodes6        = 16;
nodes_per_circle6            = [number_of_electrodes4*boundary_node_multiplier6, 32,32 , 32, 32, 32, 32, 32, 32,32,1];
radius_per_circle6           = 0.1*[10,9.5,9.2,8.5,7.5,6.5,5.5,4.5,3.5,2.5,0];
number_of_circles6           = 11;
number_of_nodes6             = 305;
number_of_elements6          = 592;



number_of_electrodes6        = 16;
nodes_per_circle6            = [number_of_electrodes4, 32, 64, 64, 64, 64, 64, 64, 32,32,32,32,1];
radius_per_circle6           = [10,9.9,9.5,9,8.5,8,7,6,5,4,3,2,0];
number_of_circles6           = 13;
number_of_nodes6             = 561;
number_of_elements6          = 1088;


number_of_electrodes7        = 16;
nodes_per_circle7            = [number_of_electrodes4, 16,16,1];
radius_per_circle7           = 0.1*[10,7,4,0];
number_of_circles7           = 4;
number_of_nodes7             = 81-16-16;
number_of_elements7          = 80;


boundary_node_multiplier8=4;
number_of_electrodes8        = 16;
nodes_per_circle8            = [number_of_electrodes8*boundary_node_multiplier8,60,56,52,48,44,40,36, 32,28,24,20, 16,12,8, 1];
radius_per_circle8           = [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0];
number_of_circles8           = 16;
number_of_nodes8             = 541;
number_of_elements8          = 1016;



boundary_node_multiplier9=4;
number_of_electrodes9        = 16;
nodes_per_circle9            = [number_of_electrodes9*boundary_node_multiplier9,64, 64,64,64,64, 64,32,16 ,8,1];
radius_per_circle9           = 0.2*[7,6.6,6.2,5.6,5,4.4,3.6,2.8,2,1,0];
number_of_circles9           = 11;
number_of_nodes9             = 505;
number_of_elements9          = 944;


boundary_node_multiplier10=7;
number_of_electrodes10        = 16;
nodes_per_circle10            = [number_of_electrodes10*boundary_node_multiplier10,108,104,100,96,92,88,84,80,76,72,68,64, 60,56,52,48,44,40,36,32,28,24, 20,16,12 ,8,1];
radius_per_circle10           = 1*[9,8.7,8.4,8.1,7.8, 7.5, 7.2, 6.9, 6.6, 6.3, 6, 5.7, 5.4, 5.1, 4.8, 4.5, 4.2, 3.9, 3.6, 3.3, 3, 2.7, 2.4, 2, 1.5, 1, 0.5,0];
number_of_circles10           = 28;
number_of_nodes10             = 1621;
number_of_elements10          = 3128;


boundary_node_multiplier11    = 5;
number_of_electrodes11        = 16;
nodes_per_circle11            = [number_of_electrodes11*boundary_node_multiplier11,76,72,68,64, 60,56,52,48,44,40,36,32,28,24, 20,16,12 ,8,1];
radius_per_circle11           = 1*[ 10, 9.5, 9, 8.5, 8, 7.5, 7, 6.5, 6, 5.5, 5, 4.5, 4, 3.5, 3, 2.5, 2, 1.4, 0.7, 0];
number_of_circles11           = 20;
number_of_nodes11             = 837;
number_of_elements11          = 1592;

boundary_node_multiplier12    = 3;
number_of_electrodes12        = 16;
nodes_per_circle12            = [48,44,40,36,32,28,24, 20,16,12 ,8,1];
radius_per_circle12           = 1*[ 6.875, 6.25, 5.625, 5, 4.375, 3.75, 3.125, 2.5, 1.875, 1.25, 0.625, 0];
number_of_circles12           = 12;
number_of_nodes12             = 309;
number_of_elements12          = 568;
%SELECT these values from constants


           %Select the radius per circle


%num_circles         = circles4          %Select the number of circles in the mesh



%number_of_circles         = circles5          %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes5;         %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements5;     %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes5;   %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle5  ;          %Select the nodes on each circle
radius_per_circle         = radius_per_circle5  ;         %Select the radius per circle



number_of_circles         = number_of_circles4;
number_of_nodes           = number_of_nodes4   ;      %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements4 ;    %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes4;   %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle4     ;       %Select the nodes on each circle
radius_per_circle         = radius_per_circle4;

number_of_circles         = number_of_circles7 ;         %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes7    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements7  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes7 ;  %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle7      ;      %Select the nodes on each circle
radius_per_circle         = radius_per_circle7;









boundary_node_multiplier = boundary_node_multiplier3;
number_of_circles         = number_of_circles3 ;         %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes3    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements3  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes3 ;  %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle3      ;      %Select the nodes on each circle
radius_per_circle         = radius_per_circle3 ;


























boundary_node_multiplier  = boundary_node_multiplier2;
number_of_circles         = number_of_circles2   ;       %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes2      ;   %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements2    ; %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes2   ;%Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle2        ;    %Select the nodes on each circle
radius_per_circle         = radius_per_circle2;











boundary_node_multiplier  = boundary_node_multiplier1;
number_of_circles         = number_of_circles1   ;       %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes1      ;   %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements1    ; %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes1   ;%Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle1        ;    %Select the nodes on each circle
radius_per_circle         = radius_per_circle1;






boundary_node_multiplier = boundary_node_multiplier6
number_of_circles         = number_of_circles6 ;         %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes6    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements6  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes6 ;  %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle6      ;      %Select the nodes on each circle
radius_per_circle         = radius_per_circle6;









boundary_node_multiplier = boundary_node_multiplier9
number_of_circles         = number_of_circles9 ;         %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes9    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements9  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes9 ;  %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle9      ;      %Select the nodes on each circle
radius_per_circle         = radius_per_circle9;







boundary_node_multiplier = boundary_node_multiplier10
number_of_circles         = number_of_circles10 ;         %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes10    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements10  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes10 ;  %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle10      ;      %Select the nodes on each circle
radius_per_circle         = radius_per_circle10;







boundary_node_multiplier = boundary_node_multiplier8
number_of_circles         = number_of_circles8 ;         %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes8    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements8  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes8 ;  %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle8      ;      %Select the nodes on each circle
radius_per_circle         = radius_per_circle8;


boundary_node_multiplier = boundary_node_multiplier12
number_of_circles         = number_of_circles12 ;         %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes12    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements12  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes12 ;  %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle12      ;      %Select the nodes on each circle
radius_per_circle         = radius_per_circle12;




boundary_node_multiplier  = boundary_node_multiplier11
number_of_circles         = number_of_circles11 ;         %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes11    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements11  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes11 ;  %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle11      ;      %Select the nodes on each circle
radius_per_circle         = radius_per_circle11;
%Define matrices and arrays 

circleNodeData            = zeros(number_of_nodes, number_of_circles) ;%may be unnecessary
elementData               = zeros (number_of_elements, 4) ;      %stores the nodes that make up each element 

sigma                     = zeros(number_of_elements, 1) ;%conduc

node_currents              = zeros(number_of_nodes, number_of_electrodes);




%Define matrices that store a, b and c values for construction of element
%matrices


%fill up resistivity value vector with 1s (initial conductivity/resistivity
%guess)
for i =1:number_of_elements
    sigma(i,1)=1.5;
end

%fill up coordinates of nodes : loop around each circle putting nodes
%equally around a circle
[globalNodeData ]= getNodeData(number_of_circles, number_of_nodes, nodes_per_circle, radius_per_circle);


%store the coordinates of the nodes 
x = globalNodeData(1:number_of_nodes, 2);
y = globalNodeData(1:number_of_nodes, 3);

%creates the mesh from the given nodes 
%tri stores an array of the points and and an array of the nodes that
%connect together
%ConnectivityList - size = number_of_elements, 3
tri=delaunayTriangulation(x,y);

%number the elements 
for i=1:number_of_elements
    
    elementData(i,1)=i;
end

%store list of nodes belonging to each element 
elementData(1:number_of_elements, 2:4)  = tri.ConnectivityList;
elementDataTemp = zeros(number_of_elements, 4);
%reorder the elementData 
k=1;
for i =1:number_of_nodes 
    for j = 1:number_of_elements
        if(elementData(j,2)==i || elementData(j,3)==i || elementData(j,4)==i)
            elementDataTemp(k, 2:4)= elementData(j, 2:4);
            elementData(j, 2:4)= [0 0 0];
            k=k+1;
        end 
    end 
end 
k=1;
elementData=elementDataTemp;


%plot the mesh grid
figure(1)
trimesh(tri.ConnectivityList,x,y,zeros(size(x)));
 title('Generated Mesh');
%fill up a, b, c and delta ,matrices
[a1,b1,c1,a2,b2,c2,a3,b3,c3,delta] = getABCDelta(number_of_elements,globalNodeData,elementData);



%assembly of element matrices
 
voltage_between_electrodes_208 = getVoltagesBetweenElectrodes208_OneLine(boundary_node_multiplier,number_of_electrodes,number_of_elements, number_of_nodes, sigma, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta,elementData,node_currents);
forward_time=1;
figure(4)
plot(voltage_between_electrodes_208);
title('Predicted U-Curve Voltages from initial guess of conductivity distribution (homogeneous)');
%xlabel('Measurement Number');
% ylabel('Voltage Value');
 %axis([- 212 0 0.02] );


figure(2)
subplot(6,1,1) 

plot(voltage_between_electrodes_208)
 title('Predicted U-Curves from initial guess');
 xlabel('Measurement Number');
 ylabel('Voltage (V)');
 %axis([0 208 0 1]);
 
 

 
%Jacobian = getJacobian(boundary_node_multiplier,number_of_electrodes,number_of_elements, number_of_nodes, sigma, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta,elementData,node_currents,voltage_between_electrodes_208);



%find neighbours
n1=1;
n2=2;
n3=3;
neighbours = n2;

if(neighbours==n1)
    neighbouring_elements = zeros(number_of_elements, number_of_elements);

    for i=1:number_of_elements
        for j=2:4
            for k=1:number_of_elements
                if((elementData(k,2)==elementData(i,j) || elementData(k,3)==elementData(i,j)|| elementData(k,4)==elementData(i,j)) && k~=i)
                    neighbouring_elements(i, k)=k;
                end 
            end 

        end 
    end 

end

if(neighbours==n2)
    
    %neighbouring_elements contains a non-zero value for every neighbouring element
    neighbouring_elements = zeros(number_of_elements, number_of_elements);

    for i=1:number_of_elements %check neighbours of each element
        for k=1:number_of_elements %check if each element is a neighbour to element i
        	
            nodes=0;
            
            for j=2:4 %iterate through each node of element i to compare the node to the nodes of element k
                if((elementData(k,2)==elementData(i,j) || elementData(k,3)==elementData(i,j)|| elementData(k,4)==elementData(i,j)) && k~=i )
                    nodes=nodes+1; %if element k contains a node in element i, increase nodes by 1 
                end 
            end 
            
            if(nodes == 2) %if nodes equals 2, then element k shares an edge with element i
                neighbouring_elements(i, k) = k; %indicate that element k is a neighbour of element i with a non-zero value
            end
            
        end 
    end 
    
    
    
end 

if(neighbours==n3)
      neighbouring_elements = zeros(number_of_elements, number_of_elements);
    
    for i=1:number_of_elements
        radius=1;
        if(i>512+256)
           % radius=0.7;
        end 
        x1=globalNodeData(elementData(i, 2),2);
        x2=globalNodeData(elementData(i, 3),2);
        x3=globalNodeData(elementData(i, 4),2);
        y1=globalNodeData(elementData(i, 2),3);
        y2=globalNodeData(elementData(i, 3),3);
        y3=globalNodeData(elementData(i, 4),3);
        x_centre_c=(x1+x2+x3)/3;
        y_centre_c =(y1+y2+y3)/3;
        
        for j=1:number_of_elements
            x1=globalNodeData(elementData(j, 2),2);
            x2=globalNodeData(elementData(j, 3),2);
            x3=globalNodeData(elementData(j, 4),2);
            y1=globalNodeData(elementData(j, 2),3);
            y2=globalNodeData(elementData(j, 3),3);
            y3=globalNodeData(elementData(j, 4),3);
            x_centre_e=(x1+x2+x3)/3;
            y_centre_e =(y1+y2+y3)/3;
            
            d= ((x_centre_c-x_centre_e)^2+(y_centre_c-y_centre_e)^2)^(1/2);
            if(d<radius)
                neighbouring_elements(i, j)=j;
            end 
        end 
    end 
end 

real=1;
sample=2;
data= 1;

single_frame=1;
multiple_frames=2;
reconstruction_mode=1;

number_of_frames =1;

if(data==sample)
[voltage_measurements_208,sample_frames] = getSampleData();

figure(2)
subplot(6,1,2) 
plot(voltage_measurements_208)
 title('U-curves of Simulated Measurements');
  xlabel('Measurement Number');
 ylabel('Voltage (V)');
end 


if(data==real)


    calibrationData=getCalibrationData();

    calibrationGains = zeros(208,1);

    for i=1:208
       calibrationGains(i)= voltage_between_electrodes_208(i)/calibrationData(i);
       % calibrationGains(i)= 0.00005;
    end 
    
    for i=1:208
        %calibrationGains(i)= 1;
    end 

    calibratedCurves=zeros(208,1);
    for i=1:208
        calibratedCurves(i)=calibrationData(i)*calibrationGains(i);
    end

    figure(2)
    subplot(6,1,4) 
    plot(calibrationData)
     title('U Curves used for calibration');
        figure(2)
    subplot(6,1,6) 
    plot(calibrationGains)
     title('Calibration gains');
     
     

     [realData, realDataFrames] = getRealData();
     voltage_measurements_208= realData;
     for i=1:208
       voltage_measurements_208(i)=voltage_measurements_208(i)*calibrationGains(i);
     end
   % if(reconstruction_mode==multiple_frames)
        for i=1:number_of_frames
            for j=1:208
                realDataFrames(j,i)=realDataFrames(j,i)*calibrationGains(j);
            end 
        end 
        
        sample_frames=realDataFrames;
    %end 
   
    figure(2)
    subplot(6,1,2) 
    plot(realData)
    title('U-curves of Real Data');
     xlabel('Measurement Number');
 ylabel('Voltage (V)');
 
 
    figure(2)
    subplot(6,1,3) 
    plot(voltage_measurements_208)
    title('U-curves of Real Calibrated Data');
     xlabel('Measurement Number');
 ylabel('Voltage (V)');
end 

 

%sigma_new = Jacobian*voltage_measurements_208;
sigma_new= zeros(number_of_elements, 1);
%L = 1*(eye([number_of_elements number_of_elements]));
S=zeros(number_of_elements ,number_of_elements);
k=0;

%iterate through each row of neighbouring_elements
for i=1:number_of_elements 
   %find the centroid of element i
   x_centre_i = 0; %reset centroid to 0
   y_centre_i = 0; %reset centroid to 0
   for k = 2:4
      %add x and y coordinates of vertices of element i
      x   =  globalNodeData(elementData(i, k),2);
      y   =  globalNodeData(elementData(i, k),3);
      x_centre_i  =  x_centre_i+x;
      y_centre_i  =  y_centre_i+y;
   end 
   %find centroid of element i by dividing sum of coordinates by 3
   x_centre_i  =  (x_centre_i)/3;
   y_centre_i  =  (y_centre_i)/3;

   for j=1:number_of_elements
      %if column j is non-zero in row i, then element j is a neighbour
      if(neighbouring_elements(i,j)~=0 && j~=i)
         %find the centroid of element j
         x_centre_j = 0; %reset centroid to 0
         y_centre_j = 0; %reset centroid to 0
         for k = 2:4
             %add x and y coordinates of vertices of element j
             x   =  globalNodeData(elementData(j, k),2);
             y   =  globalNodeData(elementData(j, k),3);
             x_centre_j  =  x_centre_j+x;
             y_centre_j  =  y_centre_j+y;
         end 
         %find centroid of element j by dividing sum of coordinates by 3
         x_centre_j  =  (x_centre_j)/3;
         y_centre_j  =  (y_centre_j)/3;

         %find the distance (squared) between element i and j
         d_squared = (x_centre_i-x_centre_j)^2+(y_centre_i-y_centre_j)^2;

         S(i,j) =  S(i,j) -1/d_squared; %add -1/d^2 to S matrix
         S(i,i) =  S(i,i) +1/d_squared; %add 1/d^2 to S matrix
      end 
   end  
end 


for i=1:number_of_elements
    k=0;
    for j=1:number_of_elements
        if(neighbouring_elements(i,j)~=0)
            k=k+1;
        end 
    end 
  %  S(i,i)=S(i,i)*k;
end 
k=0;

M = (eye([number_of_elements number_of_elements]));



%J=Jacobian;

a=0.00000001;
b=0.0000;
v=2;

error_p =  0.5*transpose(voltage_measurements_208-voltage_between_electrodes_208)*(voltage_measurements_208-voltage_between_electrodes_208);
   CostFunction= error_p+0.5*a^2*transpose(S*(sigma_new-sigma))*(S*(sigma_new-sigma));  

number_of_iterations=1;


C = zeros(number_of_iterations, 1);
E = zeros(number_of_iterations, 1);
sigma_new=sigma;
e_i=0.5*transpose(voltage_measurements_208-voltage_between_electrodes_208)*(voltage_measurements_208-voltage_between_electrodes_208);





sigma_new_multiple_frames= zeros(number_of_elements, number_of_frames);

if(reconstruction_mode==multiple_frames)
      
     Jacobian = getJacobian(boundary_node_multiplier,number_of_electrodes,number_of_elements, number_of_nodes, sigma, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta,elementData,node_currents,voltage_between_electrodes_208);
     J=Jacobian;
     
    for k=1:number_of_frames
        voltage_measurements_208=sample_frames(1:208,k);
        figure(11)
        subplot(5,6,k)
        plot(voltage_measurements_208)
        title(int2str(k))
        sigma_new=sigma;
          voltage_between_electrodes_208_updated=voltage_between_electrodes_208;
        for i=1:number_of_iterations

            E(i)=error_p;
            C(i)=CostFunction;
            if(number_of_iterations>1)
                Jacobian = getJacobian(boundary_node_multiplier,number_of_electrodes,number_of_elements, number_of_nodes, sigma_new, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta,elementData,node_currents,voltage_between_electrodes_208);
                J=Jacobian;
            end 
            
            %calculation of change in conductivity 
            delta_sigma_new   =  (inv(transpose(J)*J+2*a*S))*(transpose(J)*(voltage_measurements_208-voltage_between_electrodes_208_updated));
            %update conductivity values by adding the change in conductivity to the current value
            sigma_new   =  sigma_new + delta_sigma_new; 
            
            

            voltage_between_electrodes_208_updated = getVoltagesBetweenElectrodes208_OneLine(boundary_node_multiplier,number_of_electrodes,number_of_elements, number_of_nodes, sigma_new, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta,elementData,node_currents);
            figure(2)
            subplot(4,1,3) 
            plot(voltage_between_electrodes_208_updated)
            title('New U-curves from Forward Model using Using estimated conductivity');
             xlabel('Measurement Number');
            ylabel('Voltage (V)');
            
            error =  0.5*transpose(voltage_measurements_208-voltage_between_electrodes_208_updated)*(voltage_measurements_208-voltage_between_electrodes_208_updated);

            error_p=error;

            E(i)=error;
        end 
        sigma_new_multiple_frames(1:number_of_elements, k)=sigma_new;
    end 


    for i=1:number_of_frames
            pause(0.01)
            
            
            figure(5) %Open a new figure
            colormap(gray); %choose the color map
           
            subplot(1,5 ,i);
            plot(1:1); %start an empty plot 
            hold; %hold the plot to allow all elements to be plotted separately
            for j = 1:number_of_elements
                %obtain the x and y coordinates of the three vertices of the triangular element j 
                x_tri= [globalNodeData(elementData(j,2),2),globalNodeData(elementData(j,3),2),globalNodeData(elementData(j,4),2)];
                y_tri= [globalNodeData(elementData(j,2),3),globalNodeData(elementData(j,3),3),globalNodeData(elementData(j,4),3)];
                %fill function plots triangle given by x_tri and y_tri and shades it with a value equal to the conductivity of the element
                fill(x_tri,y_tri, sigma_new_multiple_frames(j,i),'LineStyle','none' ); 
            end
            hold; %release the hold 
            
           if(max(sigma_new_multiple_frames(1:number_of_elements,i))-min(sigma_new_multiple_frames(1:number_of_elements,i))<1)
            caxis([0 2.3])
            caxis manual
           else
              caxis auto
           end 
           title(strcat('Reconstructed Image : ', ' ',int2str(i)));
            colorbar;

    end 
end 




  tic;
if(reconstruction_mode == single_frame)
    voltage_measurements_208=sample_frames(1:208,1);
    sigma_new=sigma;
    
            error =  0.5*transpose(voltage_measurements_208-voltage_between_electrodes_208)*(voltage_measurements_208-voltage_between_electrodes_208);
            CostFunction = error+a*transpose(sigma_new)*S*sigma_new;
       
    for i=1:number_of_iterations

            
     

            Jacobian = getJacobian(boundary_node_multiplier,number_of_electrodes,number_of_elements, number_of_nodes, sigma_new, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta,elementData,node_currents,voltage_between_electrodes_208);
            J=Jacobian;
            H=transpose(J)*J;
            
            delta_sigma_new = (inv(H+2*a*S))*(transpose(J)*(voltage_measurements_208-voltage_between_electrodes_208));

            sigma_new= sigma_new+delta_sigma_new; 
            
             pause(0.01)
             
           
            figure(5) %Open a new figure
            colormap(gray); %choose the color map
            %subplot(1, number_of_iterations, i);
            plot(1:1); %start an empty plot 
            hold; %hold the plot to allow all elements to be plotted separately
            for j = 1:number_of_elements
                %obtain the x and y coordinates of the three vertices of the triangular element j 
                x_tri = [globalNodeData(elementData(j,2),2),globalNodeData(elementData(j,3),2),globalNodeData(elementData(j,4),2)];
                y_tri = [globalNodeData(elementData(j,2),3),globalNodeData(elementData(j,3),3),globalNodeData(elementData(j,4),3)];
                %fill function plots triangle given by x_tri and y_tri and shades it with a value equal to the conductivity of the element
                fill(x_tri,y_tri, sigma_new(j),'LineStyle','none' );
            end
            hold; %release the hold 
            title(strcat('Iteration : ',int2str(i)));
            colorbar;
            caxis([0 2.3])
            caxis manual
           
            voltage_between_electrodes_208 = getVoltagesBetweenElectrodes208_OneLine(boundary_node_multiplier,number_of_electrodes,number_of_elements, number_of_nodes, sigma_new, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta,elementData,node_currents);
            figure(2)
            subplot(6,1,5) 
            plot(voltage_between_electrodes_208)
            title('New Predicted U-curves Using New Conductivity');
            pause(0.001);
            error =  0.5*transpose(voltage_measurements_208-voltage_between_electrodes_208)*(voltage_measurements_208-voltage_between_electrodes_208);
            CostFunction = error+a*transpose(sigma_new)*S*sigma_new;
         
            
            E(i)=error;
            C(i)=CostFunction;



    end 
end 

 iteration_time=toc;
figure(7)
subplot(2,1,1)
plot(C)
ylabel('Cost Function Value');
xlabel('Iteration Number')
figure(7)
subplot(2,1,2)
plot(E)
ylabel('Square Error');
xlabel('Iteration Number')
%clear;
%t_time=toc;

