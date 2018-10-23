function Y = getYmatrix(number_of_elements,number_of_nodes, elementData, y_element)
Y = zeros(number_of_nodes, number_of_nodes); %initialise the master matrix Y

for i =1:number_of_elements %each element has a 3x3 y_element entry representing a value for each of its node pairs
   for j=1:3 %iterate through the rows of y_element
       for k=1:3 %iterate through the columns of y_element
           
           r= elementData(i, j+1);  %r is the node belonging to y_element's 3x3 at row j
           c = elementData(i, k+1); %c is the node belonging to y_element's 3x3 at column k
           
           if(r==number_of_nodes && c==number_of_nodes)
               Y(r,c)= 1; %the last node that is generated is set as the reference node with a diagonal value of 1
           else
               if (r==number_of_nodes || c ==number_of_nodes)
                   Y(r,c)= 0; %all entries corresponding to the reference node has a value of 0 except the diagonal entry
               else 
                   Y(r,c)= Y(r,c)+ y_element((i-1)*3+j, k); %Other nodes: add the entry of y_element to the corresponding entry in Y
               end 
           end 
           
       end
   end
   
end
end 
