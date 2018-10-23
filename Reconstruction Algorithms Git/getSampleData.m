%Generate a mesh with any number of circles and nodes per circle
%INPUTS: number of elements, number of circles, radius per circle, number of
%nodes, nodes per circle, injection currents

%INPUT: constants
function [sample_data_208,voltage_between_electrodes_208_frames] = getSampleData()
number_of_electrodes1     = 8;
nodes1              = [number_of_electrodes1, 4, 1];
radius1             = [10, 5,0];
circles1            = 3;
numnodes1           = 13;
number_of_elements1       = 16;

number_of_electrodes2     = 16;
nodes2              = [16,8, 1];
radius2             = [10,6,0];
circles2            = 3;
numnodes2           = 25;
number_of_elements2       = 32;

number_of_electrodes3     = 16;
nodes3              = [16,16, 16,16,16,16, 16,16,16 1];
radius3             = 0.1*[10,9,8,7,6,5,4,3,2,0];
circles3            = 10;
numnodes3           = 161-16;
number_of_elements3       = 272;

number_of_electrodes4     = 16;
nodes4              = [number_of_electrodes4,16, 16,16,16, 16,1];
radius4             = [10,9.5,8.5,7,5,3,0];
circles4            = 7;
numnodes4           = 97;
number_of_elements4       = 176;

number_of_electrodes5     = 16;
nodes5              = [number_of_electrodes4, 16,1];
radius5             = [10,5,0];
circles5            = 3;
numnodes5           = 33;
number_of_elements5       = 48;

number_of_electrodes6        = 16;
nodes_per_circle6            = [number_of_electrodes4, 32, 64, 64, 64, 64, 64, 64, 32,32,32,32,1];
radius_per_circle6           = [10,9.9,9.5,9,8.5,8,7,6,5,4,3,2,0];
number_of_circles6           = 13;
number_of_nodes6             = 561;
number_of_elements6          = 1088;

number_of_electrodes7     = 16;
nodes7              = [number_of_electrodes4, 16,16,16,1];
radius7             = 0.1*[10,7,4,1,0];
circles7            = 5;
numnodes7           = 81-16;
number_of_elements7       = 112;



boundary_node_multiplier11    = 5;
number_of_electrodes11        = 16;
nodes_per_circle11            = [number_of_electrodes11*boundary_node_multiplier11,76,72,68,64, 60,56,52,48,44,40,36,32,28,24, 20,16,12 ,8,1];
radius_per_circle11           = 1*[ 9.5, 9, 8.5, 8, 7.5, 7, 6.5, 6, 5.5, 5, 4.5, 4, 3.5, 3, 2.5, 2, 1.5, 1, 0.5, 0];
number_of_circles11           = 20;
number_of_nodes11             = 837;
number_of_elements11          = 1592;

boundary_node_multiplier=1;
%SELECT these values from constants






         %Select the radius per circle


number_of_circles         = circles4      ;    %Select the number of circles in the mesh
num_nodes           = numnodes4     ;    %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements4  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes4  ; %Select the number of electrodes (also outer nodes)
nodes_per_circle    = nodes4     ;       %Select the nodes on each circle
radius_per_circle   = radius4    ;       %Select the radius per circle




number_of_circles         = circles5   ;       %Select the number of circles in the mesh
number_of_nodes           = numnodes5  ;       %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements5  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes5;   %Select the number of electrodes (also outer nodes)
nodes_per_circle    = nodes5     ;       %Select the nodes on each circle
radius_per_circle   = radius5   ;        %Select the radius per circle




number_of_circles         = circles2    ;      %Select the number of circles in the mesh
number_of_nodes           = numnodes2    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements2  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes2  ; %Select the number of electrodes (also outer nodes)
nodes_per_circle    = nodes2      ;      %Select the nodes on each circle
radius_per_circle   = radius2 ;


        %Select the radius per circle



number_of_circles         = circles7    ;      %Select the number of circles in the mesh
number_of_nodes           = numnodes7     ;    %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements7  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes7 ; %Select the number of electrodes (also outer nodes)
nodes_per_circle    = nodes7      ;      %Select the nodes on each circle
radius_per_circle   = radius7;


number_of_circles         = circles3       ;   %Select the number of circles in the mesh
number_of_nodes           = numnodes3      ;   %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements3   ;  %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes3  ; %Select the number of electrodes (also outer nodes)
nodes_per_circle    = nodes3       ;     %Select the nodes on each circle
radius_per_circle   = radius3  ;





number_of_circles         = circles2    ;      %Select the number of circles in the mesh
number_of_nodes           = numnodes2    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements2  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes2;   %Select the number of electrodes (also outer nodes)
nodes_per_circle    = nodes2    ;        %Select the nodes on each circle
radius_per_circle   = radius2  ;         %Select the radius per circle




number_of_circles         = number_of_circles6 ;         %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes6    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements6  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes6 ;  %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle6      ;      %Select the nodes on each circle
radius_per_circle         = radius_per_circle6;

boundary_node_multiplier = boundary_node_multiplier11
number_of_circles         = number_of_circles11 ;         %Select the number of circles in the mesh
number_of_nodes           = number_of_nodes11    ;     %Select the total number of nodes (addition of nodes per circle)
number_of_elements        = number_of_elements11  ;   %Select the number of elements (must be counted)
number_of_electrodes      = number_of_electrodes11 ;  %Select the number of electrodes (also outer nodes)
nodes_per_circle          = nodes_per_circle11      ;      %Select the nodes on each circle
radius_per_circle         = radius_per_circle11;


%Define matrices and arrays 
globalNodeData      = zeros(number_of_nodes, 3);           %stores the node numbers and coordinates
circleNodeData      = zeros(number_of_nodes, number_of_circles); %may be unnecessary
elementData         = zeros (number_of_elements, 4)  ;     %stores the nodes that make up each element 

sigma                 = zeros(number_of_elements, 1); %conduc
voltage_vector      = zeros(number_of_nodes*number_of_electrodes, 1);
delta               = zeros(number_of_elements, 1);
u_curve_single      = zeros(number_of_electrodes, 2);
electrode_node_voltages            = zeros(number_of_electrodes*(number_of_electrodes-3), 2);
node_currents       = zeros(number_of_nodes, 1);

%Define matrices that store a, b and c values for construction of element
%matrices
a1 = zeros(number_of_elements, 1);
a2 = zeros(number_of_elements, 1);
a3 = zeros(number_of_elements, 1);
b1 = zeros(number_of_elements, 1);
b2 = zeros(number_of_elements, 1);
b3 = zeros(number_of_elements, 1);
c1 = zeros(number_of_elements, 1);
c2 = zeros(number_of_elements, 1);
c3 = zeros(number_of_elements, 1);

%fill up resistivity value vector with 1s (initial conductivity/resistivity
%guess)


number_of_frames = 1;
voltage_between_electrodes_208_frames = zeros(number_of_electrodes*(number_of_electrodes-3), number_of_frames);

for i =1:number_of_elements
   sigma(i,1)=1.5;
end


%sigma(2,1)=1.1

%for i =1:513+255
    %sigma(i,1)=5;
%end
%fill up coordinates of nodes : loop around each circle putting nodes
%equally around a circle
[globalNodeData ]= getNodeData(number_of_circles, number_of_nodes,nodes_per_circle, radius_per_circle);


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
%figure(1)
%trimesh(tri.ConnectivityList,x,y,zeros(size(x)));
%figure(8)
%trimesh(tri.ConnectivityList,x,y,1:1:number_of_nodes);
%fill up a, b, c and delta ,matrices
[a1,b1,c1,a2,b2,c2,a3,b3,c3,delta] = getABCDelta(number_of_elements,globalNodeData,elementData);

%assembly of element matrices



x_centre=-4;
y_centre=-4;
radius=2;

for q=1:number_of_elements
    n=1;
    for r=2:4
        x_n=globalNodeData(elementData(q,r),2);
        y_n=globalNodeData(elementData(q,r),3);
        
        d= sqrt((x_centre-x_n)^2+(y_centre-y_n)^2);
        if(d<radius && n==1)
            sigma(q)=0.9;
            n=0;
        end 
    end 
end 


for m=1:number_of_frames
    
for i =1:number_of_elements
   sigma(i,1) = 2+2*0*rand(); %fill mesh with uniform conductivity
end

x_centre = -0; %select x coordinate of centre of object
y_centre = -0; %select y coordinate of centre of object
radius   =  3;  %select radius of object
%check if any element falls within chosen radius of centre of object
for q=1:number_of_elements
    %obtain coordinates of element q
    x1 = globalNodeData(elementData(q, 2),2);
    x2 = globalNodeData(elementData(q, 3),2);
    x3 = globalNodeData(elementData(q, 4),2);
    y1 = globalNodeData(elementData(q, 2),3);
    y2 = globalNodeData(elementData(q, 3),3);
    y3 = globalNodeData(elementData(q, 4),3);
    %obtain centroid of element q
    x_centre_e = (x1+x2+x3)/3;
    y_centre_e = (y1+y2+y3)/3;
    %find distance between element q and object centre 
    d= sqrt((x_centre-x_centre_e)^2+(y_centre-y_centre_e)^2);
    %if distance is less than radius, element q belongs to "object"
    if( d < radius )
        sigma(q) = 0.5+0.5*0*rand(); %set conductivity to 0.9 
    end 
end 
     
    y_element=zeros(number_of_elements*3,3) ;

    y_element=  getYelement(number_of_elements, sigma, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta);


    Y = zeros(number_of_nodes, number_of_nodes);
    Y = getYmatrix(number_of_elements,number_of_nodes, elementData, y_element);


    [electrode_node_voltages,voltage_vector]  = getElectrodeNodeVoltages(boundary_node_multiplier,number_of_electrodes,number_of_nodes,node_currents,Y);



    voltage_between_electrodes = getVoltageBetweenElectrodes(number_of_electrodes,electrode_node_voltages);


     voltage_between_electrodes_rearranged = getVoltageBetweenElectrodesRearranged(number_of_electrodes,voltage_between_electrodes);

       voltage_between_electrodes_208 = zeros(number_of_electrodes*(number_of_electrodes-3),1);

       for i=1:16
          k=0;
          for j=3:1:15
             k=k+1;
             index = (i-1)*16+j;
             index2=((i-1)*13+k);
             voltage_between_electrodes_208(index2) =voltage_between_electrodes_rearranged(index);
          end
       end
    sample_data_208=1*voltage_between_electrodes_208;
    
    for j=1:208
       sample_data_208(j)=sample_data_208(j)+sample_data_208(j)*rand*0;
    end 
    
    voltage_between_electrodes_208_frames(1:208, m)=sample_data_208;
    
    figure(3)
     colormap(gray)
   subplot(1, number_of_frames, m);
    plot(1:1)
    hold
    for i=1:number_of_elements
        x_tri= [globalNodeData(elementData(i,2),2),globalNodeData(elementData(i,3),2),globalNodeData(elementData(i,4),2)];
        y_tri= [globalNodeData(elementData(i,2),3),globalNodeData(elementData(i,3),3),globalNodeData(elementData(i,4),3)];
      
        fill(x_tri,y_tri, sigma(i), 'LineStyle','none');

    end
    hold
    
     caxis([0.3 2.5])
     caxis manual
     title(strcat('Simulated Image '));
    % colorbar
pause(0.01)
     %colorbar('Limits', [0 2])
end 
sample_data_208= voltage_between_electrodes_208_frames(1:208, 1);
end