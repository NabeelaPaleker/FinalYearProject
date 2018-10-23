function voltage_between_electrodes_208 = getVoltagesBetweenElectrodes208(num_electrodes, voltage_between_electrodes_rearranged)
 voltage_between_electrodes_208 = zeros(num_electrodes*(num_electrodes-3),1);
   
   for i=1:num_electrodes 
      k = 0; %used as an incrementing pointer to 208-value array
      %j does not include the first two and last values in each set 
      for j=3:1:(num_electrodes -1)
         k=k+1;
         %index is for 256-value array, voltage_between_electrodes_rearranged
         index  = (i-1)*(num_electrodes)+j;
         %index2 is for 208-value array, voltage_between_electrodes_208
         index2 = (i-1)*(num_electrodes -3)+k; 
         %place values 3 to 15 of each set of 16 into positions 1 to 13 of voltage_between_electrodes_208
         voltage_between_electrodes_208(index2) = voltage_between_electrodes_rearranged(index);
      end
   end
   

   end