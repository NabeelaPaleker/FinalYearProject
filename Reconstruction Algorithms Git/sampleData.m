%Generate a mesh with any number of circles and nodes per circle
%INPUTS: number of elements, number of circles, radius per circle, number of
%nodes, nodes per circle, injection currents

%INPUT: constants
function sample_data_208 = getSampleData()
num_electrodes1     = 8;
nodes1              = [num_electrodes1, 4, 1];
radius1             = [10, 5,0];
circles1            = 3;
numnodes1           = 13;
num_elements1       = 16;

num_electrodes2     = 16;
nodes2              = [16,8, 1];
radius2             = [10,6,0];
circles2            = 3;
numnodes2           = 25;
num_elements2       = 32;
 
num_electrodes3     = 16;
nodes3              = [16,32, 16,16,16,16, 16,16,16 1]
radius3             = [10,9.5,9,8.5,8,7.5,7,5,3,0]
circles3            = 10
numnodes3           = 161
num_elements3       = 304

num_electrodes4     = 16
nodes4              = [num_electrodes4,16, 16,16,16, 16,1]
radius4             = [10,9.5,8.5,7,5,3,0]
circles4            = 7
numnodes4           = 97
num_elements4       = 176

%SELECT these values from constants
num_circles         = circles2          %Select the number of circles in the mesh
num_nodes           = numnodes2         %Select the total number of nodes (addition of nodes per circle)
num_elements        = num_elements2     %Select the number of elements (must be counted)
num_electrodes      = num_electrodes2   %Select the number of electrodes (also outer nodes)
nodes_per_circle    = nodes2            %Select the nodes on each circle
radius_per_circle   = radius2           %Select the radius per circle

 

%Define matrices and arrays 
globalNodeData      = zeros(num_nodes, 3)           %stores the node numbers and coordinates
circleNodeData      = zeros(num_nodes, num_circles) %may be unnecessary
elementData         = zeros (num_elements, 4)       %stores the nodes that make up each element 

sigma                 = zeros(num_elements, 1) %conduc
voltage_vector      = zeros(num_nodes*num_electrodes, 1)
delta               = zeros(num_elements, 1)
u_curve_single      = zeros(num_electrodes, 2)
electrode_node_voltages            = zeros(num_electrodes*(num_electrodes-3), 2)
node_currents       = zeros(num_nodes, 1)

%Define matrices that store a, b and c values for construction of element
%matrices
a1 = zeros(num_elements, 1)
a2 = zeros(num_elements, 1)
a3 = zeros(num_elements, 1)
b1 = zeros(num_elements, 1)
b2 = zeros(num_elements, 1)
b3 = zeros(num_elements, 1)
c1 = zeros(num_elements, 1)
c2 = zeros(num_elements, 1)
c3 = zeros(num_elements, 1)

%fill up resistivity value vector with 1s (initial conductivity/resistivity
%guess)
for i =1:num_elements
    sigma(i,1)=1
end
sigma(2)=2
sigma(10)=2
sigma(17)=2
sigma(19)=2
sigma(24)=2
sigma(27)=2
sigma(28)=2
sigma(30)=2
%fill up coordinates of nodes : loop around each circle putting nodes
%equally around a circle
[globalNodeData ,u_curve_single]= getNodeData(num_circles, nodes_per_circle, radius_per_circle)


%store the coordinates of the nodes 
x = globalNodeData(1:num_nodes, 2);
y = globalNodeData(1:num_nodes, 3);

%creates the mesh from the given nodes 
%tri stores an array of the points and and an array of the nodes that
%connect together
%ConnectivityList - size = num_elements, 3
tri=delaunayTriangulation(x,y);

%number the elements 
for i=1:num_elements
    
    elementData(i,1)=i;
end

%store list of nodes belonging to each element 
elementData(1:num_elements, 2:4)  = tri.ConnectivityList;

%plot the mesh grid
%figure(1)
%trimesh(tri.ConnectivityList,x,y,zeros(size(x)));

%fill up a, b, c and delta ,matrices
[a1,b1,c1,a2,b2,c2,a3,b3,c3,delta] = getABCDelta(num_elements,globalNodeData,elementData);

%assembly of element matrices
y_element=zeros(num_elements*3,3) ;

y_element=  getYelement(num_elements, sigma, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta);


Y = zeros(num_nodes, num_nodes);
Y = getYmatrix(num_elements,num_nodes, elementData, y_element);


[electrode_node_voltages,voltage_vector]  = getElectrodeNodeVoltages(num_electrodes,num_nodes,node_currents,Y)



voltage_between_electrodes = getVoltageBetweenElectrodes(num_electrodes,electrode_node_voltages);


 voltage_between_electrodes_rearranged = getVoltageBetweenElectrodesRearranged(num_electrodes,voltage_between_electrodes)
   
   voltage_between_electrodes_208 = zeros(num_electrodes*(num_electrodes-3),1);

   for i=1:16
      k=0;
      for j=3:1:15
         k=k+1;
         index = (i-1)*16+j;
         index2=((i-1)*13+k);
         voltage_between_electrodes_208(index2) =voltage_between_electrodes_rearranged(index);
      end
   end
   
   
   figure(2)
plot(voltage_between_electrodes_208)

figure(3)
%trisurf(tri.ConnectivityList,x,y,voltage_vector(1:num_nodes, 1));

sensitivity_matrix=zeros( num_elements,num_electrodes*(num_electrodes-3));

voltage_between_electrodes_208_delta = zeros(num_electrodes*(num_electrodes-3),1);
for i=1:num_elements
    del = 0.00001;
    sigma(i)= sigma(i)+del;
    y_element=  getYelement(num_elements, sigma, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta);
    Y = getYmatrix(num_elements,num_nodes, elementData, y_element);
    voltage_between_electrodes_208_delta =getVoltagesBetweenElectrodes208(num_electrodes, num_nodes, node_currents, Y);
    
    
    for j =1:(num_electrodes*(num_electrodes-3))
    sensitivity_matrix(i,j)= (voltage_between_electrodes_208_delta(j,1)-voltage_between_electrodes_208(j,1))/del;
    
    end 
end

figure(3)
plot(1:1)
hold
for i=1:num_elements
    X= [globalNodeData(tri.ConnectivityList(i,1),2),globalNodeData(tri.ConnectivityList(i,2),2),globalNodeData(tri.ConnectivityList(i,3),2)];
    Y= [globalNodeData(tri.ConnectivityList(i,1),3),globalNodeData(tri.ConnectivityList(i,2),3),globalNodeData(tri.ConnectivityList(i,3),3)];
    fill(X,Y, sigma(i))
    
end
hold

sampleData = getSampleData();
sigma_new = sensitivity_matrix*sampleData;
y_element=  getYelement(num_elements, sigma_new, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta);
Y = getYmatrix(num_elements,num_nodes, elementData, y_element);

voltage_between_electrodes=zeros(num_electrodes*num_electrodes,1)
for i=1:num_electrodes
    for j=1:num_electrodes
        if(j==i && i~=num_electrodes)
          node_currents(j,1)=0.1;
        end 
        if(j==(i+1))
          node_currents(j,1)=-0.1; 
        end 
        if(j~=i && j~=(i+1))
          node_currents(j,1)=0; 
        end 
        if(i==num_electrodes  && j==i)
          node_currents(j,1)=0.1;
          node_currents(1,1)=-0.1;
        end 
    end 
    index1=(i-1)*num_nodes+1:(i-1)*num_nodes+num_nodes;
    index2=(i-1)*num_electrodes+1:(i-1)*num_electrodes+num_electrodes;
    index3=(i-1)*num_nodes+1:(i-1)*num_nodes+num_electrodes;
    voltage_vector(index1,1) = Y^-1*node_currents;
    electrode_node_voltages( index2,1)= voltage_vector(index3,1);
end 
 
figure(4)
trisurf(tri.ConnectivityList,x,y,voltage_vector(1:num_nodes, 1));

figure(5)
plot(1:1)
hold
for i=1:num_elements
    X= [globalNodeData(tri.ConnectivityList(i,1),2),globalNodeData(tri.ConnectivityList(i,2),2),globalNodeData(tri.ConnectivityList(i,3),2)];
    Y= [globalNodeData(tri.ConnectivityList(i,1),3),globalNodeData(tri.ConnectivityList(i,2),3),globalNodeData(tri.ConnectivityList(i,3),3)];
    fill(X,Y, sigma_new(i))
    
end
hold
sample_data_208=voltage_between_electrodes_208;

end