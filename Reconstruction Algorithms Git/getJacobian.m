function Jacobian = getJacobian(boundary_node_multiplier,number_of_electrodes,number_of_elements, number_of_nodes, sigma, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta,elementData,node_currents,voltage_between_electrodes_208)

 Jacobian=zeros(number_of_electrodes*(number_of_electrodes-3),number_of_elements); %initialisation of Jacobian matrix

for i=1:number_of_elements %compute forward model for every element in the matrix 
  
    del =0.01*sigma(i); 
    sigma(i)   = sigma(i)+del; %vary the conductivity of element i by 1%
    y_element  = getYelement(number_of_elements, sigma, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta); %obtain new y_element array
    sigma(i)   = sigma(i)-del; %reset the conductivity of the element to its previous state
    
    %next 4 lines - assemble master matrix, get electrode node voltages, rearrange to get 256 voltage values
    Y                                         =  getYmatrix(number_of_elements,number_of_nodes, elementData, y_element); 
    [electrode_node_voltages,voltage_vector]  =  getElectrodeNodeVoltages(boundary_node_multiplier,number_of_electrodes,number_of_nodes,node_currents,Y);
    voltage_between_electrodes_256            =  getVoltageBetweenElectrodes(number_of_electrodes,electrode_node_voltages);
    voltage_between_electrodes_rearranged     =  getVoltageBetweenElectrodesRearranged(number_of_electrodes,voltage_between_electrodes_256);
    
    %obtain 208 voltage values with changed conductivity of element i
    voltage_between_electrodes_208_delta = getVoltagesBetweenElectrodes208(number_of_electrodes, voltage_between_electrodes_rearranged);

    %repeat for all 208 voltage values 
    for j =1:(number_of_electrodes*(number_of_electrodes-3))
            %subtract initial voltage value j of the u-curves from new voltage value j and divide by del to get partial derivative
            Jacobian(j,i)= (voltage_between_electrodes_208_delta(j,1)-voltage_between_electrodes_208(j,1))/del;
    end 
end

end 