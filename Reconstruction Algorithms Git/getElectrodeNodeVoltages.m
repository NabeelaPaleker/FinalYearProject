function [electrode_node_voltages,node_voltages]  = getElectrodeNodeVoltages(boundary_node_multiplier,number_of_electrodes,num_nodes,node_currents,Y)
%tic;
node_voltages             = zeros(num_nodes*number_of_electrodes, 16);
electrode_node_voltages    = zeros(number_of_electrodes*(number_of_electrodes-3), 1);
current =0.3;
node_currents = zeros(num_nodes, 16);

for i=1:number_of_electrodes
    
    %this for loop populates the two driving electrodes with + and -current and sets the others to 0 for the ith injection
    for j=1:number_of_electrodes*boundary_node_multiplier 
        
        %if the jth node represents the source electrode and i is not equal to the final electrode   
        if(((j+boundary_node_multiplier-1)/boundary_node_multiplier) ==i && i~= (number_of_electrodes*boundary_node_multiplier))
          node_currents(j,i)  =  current;
        end 
        %if the jth node represents the sink electrode (electrode adjacent to source electrode) and i is not equal to the final electrode 
        if(((j+boundary_node_multiplier-1)/boundary_node_multiplier)==(i+1))
          node_currents(j,i)  = -current; 
        end 
        
        %if the jth node is not the source or sink electrode 
        if((j+boundary_node_multiplier-1)/boundary_node_multiplier~=i && (j+boundary_node_multiplier-1)/boundary_node_multiplier~=(i+1))
          node_currents(j,i)  = 0; 
        end 
        
        %if the jth node is the last electrode , set j to be the source and the first node-electrode to be the sink (circular tank)
        if(i==number_of_electrodes  && (j+boundary_node_multiplier-1)/boundary_node_multiplier==i)
          node_currents(j,i)  =   current;
          node_currents(1,i)  =  -current;
        end 
    end 
end 
    
    
   % tic;
    
    node_voltages=(Y)\node_currents;
    %lower= chol(Y,'lower');
    %x=lower\node_currents;
    %node_voltages=(transpose(lower))\x;
    
    
   % y_time=toc;
    
    index1=(i-1)*num_nodes+1:(i-1)*num_nodes+num_nodes;
    index2=(i-1)*number_of_electrodes+1:(i-1)*number_of_electrodes+number_of_electrodes;
    index3=(i-1)*num_nodes+1:(i-1)*num_nodes+number_of_electrodes;
    
    
    

  % electrode_node_voltages( index2,1)= node_voltages(index3,1);
  
  
  
  
  
  
  %node_voltages=(Y)\node_currents; %solve for all the node voltages
  
  %the double for-loop extracts the 256 electrode voltages (16 electrode system) for the 16 injections 
   for i=1:number_of_electrodes
       k=1; %counter that increments whenever a new electrode voltage is found in the j-loop
       for j=1:number_of_electrodes*boundary_node_multiplier
           %the if statement checks if j corresponds to an electrode node
           if(rem((j+boundary_node_multiplier-1),boundary_node_multiplier)==0)
                %each injection and j-loop produces values for every
                %electrode - when i increments, the next set of electrode
                %values are found
                electrode_node_voltages((i-1)*number_of_electrodes+k)= node_voltages(j,i);
                k=k+1;
           end 
           
       end 
   end 
   
   
   
%loop_time=toc;
end 