function [globalNodeData]= getNodeData(num_circles,number_of_nodes, nodes_per_circle, radius_per_circle)

    globalNodeData  =  zeros(number_of_nodes, 3);  %stores the node numbers and coordinates of each node 
    
    n=1; %counter to keep track of node number
    for i =1:num_circles %generate nodes for each circle in a separate iteration
        for j = 1:nodes_per_circle(i) %generate the amount of nodes defined for the circle
            
            globalNodeData(n, 1) = n; %number the global nodes
            
            %all nodes have an equal angle between them determined by the
            %number of nodes in the circle - angle is incremented by
            %2*pi/(nodes in the circle) for each node
            
            globalNodeData(n, 2) = radius_per_circle(i)*cos(  (j-1)*2*pi/nodes_per_circle(i)  ); %set the x coordinate of the node
            globalNodeData(n, 3) = radius_per_circle(i)*sin(  (j-1)*2*pi/nodes_per_circle(i)  ); %set the y coordinate of the node
            
            n=n+1; %increment the global node number
   
        end
    end
end
