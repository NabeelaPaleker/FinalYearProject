function voltage_between_electrodes_208 = getVoltagesBetweenElectrodes208_OneLine(boundary_node_multiplier,number_of_electrodes,number_of_elements, number_of_nodes, sigma_new, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta,elementData,node_currents)
   y_element= ( getYelement(number_of_elements, sigma_new, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta));
   Y = (getYmatrix(number_of_elements,number_of_nodes, elementData, y_element));
   [electrode_node_voltages,voltage_vector]  = (getElectrodeNodeVoltages(boundary_node_multiplier,number_of_electrodes,number_of_nodes,node_currents,Y));
   voltage_between_electrodes = getVoltageBetweenElectrodes(number_of_electrodes,electrode_node_voltages);
   voltage_between_electrodes_rearranged =  getVoltageBetweenElectrodesRearranged(number_of_electrodes,voltage_between_electrodes);
   voltage_between_electrodes_208 = 1*getVoltagesBetweenElectrodes208(number_of_electrodes, voltage_between_electrodes_rearranged);
   
end 