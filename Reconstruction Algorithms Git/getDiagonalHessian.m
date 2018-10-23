function diagonalHessian = getDiagonalHessian(number_of_elements, H)
 diagonalHessian=H;
 for s=1:number_of_elements
     for t=1:number_of_elements
         if(s~=t)
             diagonalHessian(s,t)=0;
         end 
     end
 end 
end 