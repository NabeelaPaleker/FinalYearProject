function voltage_between_electrodes_rearranged = getVoltageBetweenElectrodesRearranged(num_electrodes,voltage_between_electrode_256)
voltage_between_electrodes_rearranged = zeros(num_electrodes*num_electrodes,1) ;


   m = 0; %used as a pointer to voltage_between_electrode_256 when wrapping around the set of values
   
   %i determines how many positions the i'th set of 16 values should be shifted
   for i = 1:num_electrodes
      %repeat for every j value in a set of 16 values
      for j = 1:num_electrodes
         %index used as incrementing pointer to each of 256 values in voltage_between_electrodes_rearranged
         index = (i-1)*num_electrodes+j;
         
         if(j <= (num_electrodes-i+1))
            m = 0;
            %shift position of the value in voltage_between_electrode_256 by i-1 if j is less than
            %or equal to the amount of values that need to be shifted up
            voltage_between_electrodes_rearranged(index) = voltage_between_electrode_256(index+(i-1));
         else
            %if j is more than the amount of values that must be shifted up, wrap around the 
            %i'th set of values to the beginning of the set to fill up the remaining 
            %values in voltage_between_electrodes_rearranged
            m = m+1;
            index2 = (i-1)*num_electrodes+m;
            voltage_between_electrodes_rearranged(index) = voltage_between_electrode_256(index2);
         end
      end
   end
% figure(12)
%plot(voltage_between_electrodes_rearranged)
end 