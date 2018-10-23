
function voltage_between_electrodes_208_func = getVoltagesBetweenElectrodes(num_electrodes, num_nodes, node_currents, Y)
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


voltage_between_electrodes=zeros(num_electrodes*num_electrodes,1)
for i=1:num_electrodes
    for j=1:num_electrodes
    if(j~=num_electrodes)
    voltage_between_electrodes((i-1)*num_electrodes+j,1)=electrode_node_voltages((i-1)*num_electrodes+j+1)-electrode_node_voltages((i-1)*num_electrodes+j);
    else
         voltage_between_electrodes((i-1)*num_electrodes+j,1)=electrode_node_voltages((i-1)*num_electrodes+1)-electrode_node_voltages((i-1)*num_electrodes+j);
    end
   
    end
end 

voltage_between_electrodes_rearranged = zeros(num_electrodes*num_electrodes,1) ;

   m=0;

   for i=1:16
      for j=1:16
         index =(i-1)*16+j;

         index3= index+(i-1);
         if(j<=(16-i+1))
            m =0;

            voltage_between_electrodes_rearranged(index) = voltage_between_electrodes(index+(i-1));
         else
            m=m+1;
            index2 = (i-1)*16+m;

            voltage_between_electrodes_rearranged(index)= voltage_between_electrodes(index2);
         end
      end
   end
   k=0;

   voltage_between_electrodes_208_func = zeros(num_electrodes*(num_electrodes-3),1);

   for i=1:16
      k=0;
      for j=3:1:15
         k=k+1;
         index = (i-1)*16+j;
         index2=((i-1)*13+k);
         voltage_between_electrodes_208_func(index2) =voltage_between_electrodes_rearranged(index);
      end
   end
   
   

   end