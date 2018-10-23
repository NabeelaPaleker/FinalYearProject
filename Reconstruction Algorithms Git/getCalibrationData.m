function calibrationData = getCalibrationData()

M = dlmread('cal_12.txt');
calibrationData =transpose(M);
for i=1:208
    calibrationData(i)=calibrationData(i);
end 


end