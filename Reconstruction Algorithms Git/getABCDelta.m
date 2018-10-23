function [a1,b1,c1,a2,b2,c2,a3,b3,c3,delta] = getABCDelta(number_of_elements,globalNodeData, elementData)
a1 = zeros(number_of_elements, 1);
a2 = zeros(number_of_elements, 1);
a3 = zeros(number_of_elements, 1);
b1 = zeros(number_of_elements, 1);
b2 = zeros(number_of_elements, 1);
b3 = zeros(number_of_elements, 1);
c1 = zeros(number_of_elements, 1);
c2 = zeros(number_of_elements, 1);
c3 = zeros(number_of_elements, 1);
delta = zeros(number_of_elements, 1);
for i =1:number_of_elements
    %extract the x and y coordinates - elementData determines the node
    %number for element i and globalNodeData produces the coordinates for
    %that node 
    x1= globalNodeData(elementData(i,2),2);
    x2= globalNodeData(elementData(i,3),2);
    x3= globalNodeData(elementData(i,4),2);
    y1= globalNodeData(elementData(i,2),3);
    y2= globalNodeData(elementData(i,3),3);
    y3= globalNodeData(elementData(i,4),3);

    %a1, b1, c1, a2, b2, c2, a3, b3, c3, delta are calculated using the equation
    %in Webster 
    a1(i,1)= x2*y3-x3*y2;
    b1(i,1)= y2-y3;
    c1(i,1)= x3-x2;
    
    a2(i,1)= x3*y1-x1*y3;
    b2(i,1)= y3-y1;
    c2(i,1)= x1-x3;
    
    a3(i,1)= x1*y2-x2*y1;
    b3(i,1)= y1-y2;
    c3(i,1)= x2-x1;
    
    delta(i,1) = (a1(i,1)+ a2(i,1)+a3(i,1))/2 ;
end
end
