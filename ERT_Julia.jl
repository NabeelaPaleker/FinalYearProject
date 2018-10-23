#ERT_Julia.jl
#Julia script to test STM32F4 ERT system
#Nabeela Paleker September 2018

include("ERT_Modules.jl")
@time using SerialPorts   # Serial port library (Python-based)

#@time using GR
#plot_type="gr"

@time using PyPlot  #On Windows, don't forget to type ENV["MPLBACKEND"]="qt4agg" before running script.
plot_type="pyplot"


#***************************************************************************
# ********************* MAIN CODE STARTS HERE ***************************
#***************************************************************************


println("\n\n******* Starting ERT_Julia.jl ******* \n\n")

println("\nOpening virtual COM port")
comport  = "COM4:" #Select the COM port 
baudrate = 9600   #Select the baudrate - not used for USB

#Open the virtual COM port but display an error message if it fails
s = try
		SerialPort(comport,baudrate)  #Open virtual COM port and store it to variable s
	catch
		error("\n\nCould not open virtual COM port - Restart ERT_Julia.jl and the C code")
	end

println("Clearing junk bytes in virtual COM port buffer")
junk = readavailable(s)  # Clear out any junk data in buffer
println("Junk bytes:",junk)


println("Uploading sequence table")
file_name_sequence_table = "testtable.txt"  #file containing sequence table

#hex_string is obtained by a function written before for previous work
#hex_string contains the bytes of the sequence table in order 
hex_string = ERT_Modules.Read_sequence_table_file(file_name_sequence_table) 

write(s, "2#")   #Command to update sequence table
ack = read(s,1); #read byte sent from the STM32F4 to acknowledge command
println(ack)     #print the acknowledge byte "A"

write(s, hex_string*"#") #write the sequence table with a "#" at the end
read(s, 1)  	 #read byte sent from the STM32F4 to acknowledge command
println(ack)     #print the acknowledge byte "A"

junk = readavailable(s)   # Clear out any old data
println("Junk Bytes:",(junk))


########## Calibrate here ##########
yes = 1;
no  = 0;
cal = yes;

println("Calibrating")
write(s, "8#");
ack = read(s,1) #read an acknowledge byte
calibration_offsets = read(s,32);
println("junk:")
println(readavailable(s))
calibration_array = Array{UInt16}(16)
c = Vector{UInt8}(calibration_offsets)       # Convert string to UInt8 bytes
for i = 1:16 
	#convert offsets to 16 bit values by joining two bytes
	calibration_array[i]=c[2*i]*256 + c[2*i-1]#Convert to UInt16 ADC samples
end
println("plotting offsets")
plot(calibration_array)

########### ENTER NUMBER OF FRAMES HERE ###########



number_of_ADC_values       = 16*16  # Specify number (=16*16)of samples in a frame
number_of_u_curve_values   = 16*(16-3)   # 208 = reduced number after discarding those involving injection electrodes

# Define arrays and variables (so that they are still visible outside the for loop at the REPL command line)
raw_ADC_samples                              =  Array{UInt16}(number_of_ADC_values)
fixed_order_ADC_samples                      =  Array{UInt16}(number_of_ADC_values)
voltage_between_electrodes_rearranged        =  Array{UInt16}(number_of_ADC_values)
voltage_between_electrodes_208               =  Array{UInt16}(number_of_u_curve_values)


speed_info                                  =  0
capture_one_frame_time                      =  0


# These arrays are used to calculate mean and standard deviation statistics
sum_of_measurements_squared = zeros(number_of_u_curve_values)
sum_of_all_measurements = zeros(number_of_u_curve_values)




n=1   # Frame counter in loop
update_rate_ave = 0


if plot_type=="gr"
   figure(size=(1200,800))   # Create a wide window for plot
end
if plot_type=="pyplot"  #Don't forget to type ENV["MPLBACKEND"]="qt4agg" before running script.
   #ENV["MPLBACKEND"]="qt4agg"
   ##close("all")
   figure(1,figsize=(12,8))   # 12 inches by 5 inches
end

############# TIMING TEST
#println("\n\n Doing a quick timing test to see how long it takes to poll the instrument for one frame (averaged over 10 frames):")
#time_frames()
#time_frames()
#println("\n\n Test complete")
####################


t0 = time()  # Start timer

dbg=false  # Set to true if you want to display debug messages at the standard output (REPL)

println("\nEnter number of frames to capture: ")
number_of_frames = 	try
						parse(Int, readline());
					catch
						10   # Default is 10
					end

n = 1; #counter for while loop
while(n < = number_of_frames)

   tic()  #start timer for one frame capture
   
   write(s, "5#")  #Send command to capture one frame
   ack = read(s, 1); #read byte sent from the STM32F4 to acknowledge command
 
   voltage_measurements = read(s, 513);  #read voltage measurements from port

   capture_one_frame_time = toq(); #stop timer and store time for one frame
   capture_frequency = 1/capture_one_frame_time
  
   junk = readavailable(s) # Clear out any old data
   println("Junk Bytes:",(junk)) 

   r = Vector{UInt8}(voltage_measurements) #Convert string to UInt8 bytes
   for i = 1:number_of_ADC_values
	   #Convert UInt8 bytes to UInt16 by combining two bytes at a time
       raw_ADC_samples[i]=r[2*i]*256 + r[2*i-1] 
   end
	#Rearrange raw ADC samples to compensate for incorrect wiring
   fixed_order_ADC_samples = ERT_Modules.Rearrange_to_fix_PCB_wiring_error(raw_ADC_samples);
	#Rearrange fixed order ADC samples to get U-Curves
   voltage_between_electrodes_rearranged =  ERT_Modules.Reorder_to_get_U_curves_new(fixed_order_ADC_samples)
	#Throw away measurements involving injection electrodes
   voltage_between_electrodes_208 = ERT_Modules.Remove_measurements_involving_injection_electrodes(voltage_between_electrodes_rearranged)
 
 

	if(cal==no)
	
	
	f = open("data.txt","a") #open empty text file to write to
	for m = 1:208 
	   #write measurement to text file with a space after
	   write(f, string(float(voltage_between_electrodes_208[m])))
	   write(f," ")
	end
	
	
	write(f, "\n\n")
	close(f)
	sleep(1)
	end
   # println("length(arr) ",length(arr))
   # println("length(voltage_between_electrodes_rearranged) ",length(voltage_between_electrodes_rearranged))
   # println("length(fixed_order_ADC_samples) ",length(fixed_order_ADC_samples))
   # println("length(voltage_between_electrodes_208) ",length(voltage_between_electrodes_208))
   # println("typeof(voltage_between_electrodes_rearranged)",typeof(voltage_between_electrodes_rearranged))

   #array_to_plot = fixed_order_ADC_samples


   #  title("Raw ADC data");


   #Create a string for adding to the plot
   speed_info = ("N =$(n)   Screen updates: $(round(update_rate_ave,0)) fps    Capture rate (1 frame): $(round(capture_frequency,0)) fps")

   number_of_electrodes = 16   # Can reduce to 1 to plot just 1 U-curve
   x_axis_range=1:number_of_electrodes*number_of_electrodes
   #x_axis_range=1:16

   if plot_type=="pyplot"
      clf()
      y_axis_limit = 4095
      subplot(2,1,1)
      x_axis_range = 1:number_of_electrodes*number_of_electrodes
      plot(x_axis_range,voltage_between_electrodes_rearranged[x_axis_range],".-"); ylim([0,y_axis_limit]);
      ylabel("U-Curves:2 56 Measurements")
      xlabel("Measurement Number");
      subplot(2,1,2)
      x_axis_range=1:(number_of_electrodes-3)*number_of_electrodes
      plot(x_axis_range,voltage_between_electrodes_208[x_axis_range],".-"); ylim([0,y_axis_limit-2000]);
      ylabel("U-Curves: 208 Measurements");
      xlabel("Measurement Number");

      sleep(0.0001)   # Must put in a pause to force screep update on PyPlot (not needed for GR)
   end



   # On the fly stats running totals
   sum_of_measurements_squared = sum_of_measurements_squared + Float64.(voltage_between_electrodes_208).^2;
   sum_of_all_measurements     = sum_of_all_measurements + Float64.(voltage_between_electrodes_208);

   time_total=time()-t0
   update_rate_ave=1/(time_total/n)


   #   end

   n=n+1
end

println("\n\ntime_to_capture_1_frame: $capture_one_frame_time seconds")
println("\n\n",speed_info)

time_total=time()-t0
update_rate_ave=1/(time_total/n)

println("\n\nFrame rate (averaged) = $(update_rate_ave) fps")

# Save figure as a png file into current directory  (currently only works properly on subplots for Pyplot not GR)
if plot_type=="pyplot"
   savefig("output_plots.png")
end


# Do statistics
println("\n\n Calculating mean and standard deviation and plotting them")
Average_of_all_measurments = sum_of_all_measurements/number_of_frames;

#f=open("data.txt","w")
#writedlm("data.txt" ,Average_of_all_measurments, " ");
#write(f,"\n")
#close(f)

Average_of_all_squared_measurements = sum_of_measurements_squared/number_of_frames;


Standard_deviation = sqrt.(Average_of_all_squared_measurements - Average_of_all_measurments.^2);




if plot_type=="pyplot"  #Don't forget to type ENV["MPLBACKEND"]="qt4agg" before running script.
   figure(2,figsize=(12,4))   # 12 inches by 5 inches
   clf()
   subplot(2,1,1)
   title("Average of $number_of_frames captured frames"); plot(Average_of_all_measurments,".-");
   ylabel("ADC value")
   #xlabel("Measurement number")
   subplot(2,1,2)
   title("Standard Deviation of Every Measurement"); plot(Standard_deviation,".-");
   ylabel("ADC value")
   xlabel("Measurement number")
   savefig("output_statistics.png")


end



if(cal==yes)
   f=open("cal.txt","w")

   for m=1:208
      write(f, string(float(Average_of_all_measurments[m])))
      write(f," ")
   end
   write(f, " \n")
   close(f)


end
println("\n\nClosing USB Virtual Com Port")
close(s)  # Close serial port
