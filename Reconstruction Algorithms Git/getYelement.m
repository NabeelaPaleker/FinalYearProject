function y_element=  getYelement(number_of_elements,sigma, a1,b1,c1,a2,b2,c2,a3,b3,c3,delta)
    y_element=zeros(number_of_elements*3,3); %initialisation of element matrices
    %k and l are counters
    k=1;
    l=1;
    while k<= number_of_elements*3
        %the calculation of the element matrix follows the equations in
        %Webster
        y_element(k,1)  = (b1(l)^2+c1(l)^2)*sigma(l)/(4*delta(l));
        y_element(k,2)  = (b2(l)*b1(l)+c2(l)*c1(l))*sigma(l)/(4*delta(l));
        y_element(k,3)  = (b3(l)*b1(l)+c3(l)*c1(l))*sigma(l)/(4*delta(l));

        y_element(k+1,1)= (b2(l)*b1(l)+c2(l)*c1(l))*sigma(l)/(4*delta(l));
        y_element(k+1,2)= (b2(l)^2+c2(l)^2)*sigma(l)/(4*delta(l));
        y_element(k+1,3)= (b3(l)*b2(l)+c3(l)*c2(l))*sigma(l)/(4*delta(l));

        y_element(k+2,1)= (b3(l)*b1(l)+c3(l)*c1(l))*sigma(l)/(4*delta(l));
        y_element(k+2,2)= (b3(l)*b2(l)+c3(l)*c2(l))*sigma(l)/(4*delta(l));
        y_element(k+2,3)= (b3(l)^2+c3(l)^2)*sigma(l)/(4*delta(l));
    
        %k is incremented by three to move to the next block of 9 entries
        %(3 rows, 3 columns) for the next element
        %l is incremented by one to access the next element's ABC and Delta
        %parameters
        k=k+3;
        l=l+1;
    end
end 
