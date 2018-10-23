function voltage_between_electrodes_256 = getVoltageBetweenElectrodes(number_of_electrodes,electrode_node_voltages)
    
    %voltage_between_electrodes_256 stores the voltage across each pair of electrodes for each injection
    voltage_between_electrodes_256  =  zeros(number_of_electrodes*number_of_electrodes,1); %initialisation 
   
    %double for-loop to iterate through 16*16 electrode node voltage values for 16 electrodes
    
    for i=1:number_of_electrodes %iterate for each injection
        
        for j=1:number_of_electrodes %iterate for each electrode
            
            index1  = (i-1)*number_of_electrodes+j; %index for position in voltage_between_electrodes_256
            index2  = (i-1)*number_of_electrodes+j; %index for position in electrode_node_voltages

            if(j~=number_of_electrodes) 
                %subtract electrode node voltage j from electrode node voltage j+1
                voltage_between_electrodes_256(index1,1) = electrode_node_voltages(index2+1)-electrode_node_voltages(index2);
                
            else  
                %subtract electrode node voltage j from electrode node voltage 1
                voltage_between_electrodes_256(index1,1) = electrode_node_voltages((i-1)*number_of_electrodes+1)-electrode_node_voltages(index2);
            end
            
        end
    end  
end 

