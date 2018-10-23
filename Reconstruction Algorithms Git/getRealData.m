function [realData, realDataFrames] = getRealData()
   number_of_electrodes = 16;

   M = dlmread('edge_12.txt'); %read each value into a row array 
   realData=transpose(M); %transform into a column array 
   number_of_frames = 1; %number of frames to read from text file
   realDataFrames= zeros(208, number_of_frames)
   m=max(realData);
   k=1; %counter that increments after each value is read 
   for i=1:number_of_frames %store this number of frame
      %read in 208 values for column i 
       for j=1:number_of_electrodes*(number_of_electrodes-3)
           %convert ADC values to a fraction of 3 volts and store in column i
           realDataFrames(j,i)=realData(k);
           if(realData(k)>1000)
              k=k;
           end 
              
           k=k+1; %increment counter
       end 
   end 
   %store the first frame into a column array for single frame reconstruction
   realData = realDataFrames(1:number_of_electrodes*(number_of_electrodes-3),1);
end