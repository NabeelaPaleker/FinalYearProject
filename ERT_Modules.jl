
module ERT_Modules
export Read_sequence_table_file, Rearrange_to_fix_PCB_wiring_error,Remove_measurements_involving_injection_electrodes,Reorder_to_get_U_curves,Reorder_to_get_U_curves_new

function Read_sequence_table_file(file_name)

   # This function reads the sequence table from an ascii text file and converts the information into a string containing only the hex characters.
   # AJW & NB 2018-06-20
   # Read sequence table from the ASCII sequence table file
   # Store in one long string s.

   debug=false   # if set to true, then error messages are printed

   if debug
      println("\nReading sequence table text file: ",file_name)
   end

   file = open(file_name)
   text = readstring(file)
   close(file)

   # Parse string text, extracting the hex bytes and converting them into various formats for transmission to a microcontroller or other usage
   # Currently all data sent to the microntroller is ascii text.
   # Maybe later a binary format could be used.


   N_bytes = length(text)

   if debug
      println("Text file contains ",N_bytes," ASCII characters")
      println("Extracting binary bytes from the hex data")
      println("Displaying: \$HEX DEC CHAR\n\n")
   end

   # hex_string is a string containing only the sequence of hex characters.
   # result_UInt8  = array of UInt8 bytes hopefully in the format for the write command (may be used in the future, but currently the Julia serial port library can only transmit ASCII strings properly; binary not functional)
   # result_bytes_in_string_format = string of ascii bytes in the format for the write command

   n = 1  # Loop counter

   result_bytes_in_string_format = ""
   result_hex_string = ""
   result_UInt8 = UInt8[]

   byte_string_format =""
   while n<=N_bytes
      if text[n]=='$'
         hex_text = text[n+1:n+2]   #Extract two hex characters
         result_hex_string = result_hex_string*hex_text # Append to hex_string

         # Convert hex_text to UInt8 for other purposes
         byte_array = hex2bytes(hex_text)
         byte = byte_array[1]
         byte_UInt8 = UInt8(byte)
         push!(result_UInt8,byte_UInt8)# Apend to array of UInt8

         # Convert to a single character in string format
         byte_string_format = @sprintf("%c",byte)
         result_bytes_in_string_format = result_bytes_in_string_format * byte_string_format  # Append character to the string

         if debug
            print("\$",hex_text)
            print(" ",byte," ")
            print(" ",byte_UInt8," ")
            #print(@sprintf("%c",byte))
            print(byte_string_format)
            print(",  ")
         end

         n=n+3   # Increment by 3 to next position in text_string
      else
         n=n+1   #
      end
   end


   if debug
      println("\n\nExtracted ",length(result_bytes_in_string_format)," bytes to write to the microcontroller")
      println("\n\nExtracted ",length(result_hex_string)," hex characters (nibbles) to write to the microcontroller")
      println("\n\nhex_string:   ",result_hex_string)
   end

   return result_hex_string   # Currently only the hex string is returned
end

function Rearrange_to_fix_PCB_wiring_error(array)

   #Function to fix incorrect order of ADC lines on Bill's PCB Version 1.
   # Alternatively, I could put a solder type DB25 onto the ribbon cable and re-order there.
   #
   # Currently, the wiring is as follows:
   #    Amp chan: 1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16
   #     STM reg: C0 C1 C2 C3 A0 A1 A2 A2 A4 A5 A6 A7 C4 C5 B0 B1
   # STM ADC num: 10 11 12 13 0  1  2  3  4  5  6  7  14 15 8  9
   #
   # Note: this function has been carefully checked and does the right thing.

   Nsamples = length(array)
   Ninjections = Int(Nsamples/16)   # There are 16 channels
   #println(Ninjections)

   a = Array{UInt16}(Nsamples) # Create output array

   for n=0:Ninjections-1

      offset=Int(n*16)

      PA0 = array[1+offset]   #ADC0
      PA1 = array[2+offset]   #ADC1
      PA2 = array[3+offset]   #ADC2
      PA3 = array[4+offset]   #ADC3
      PA4 = array[5+offset]   #ADC4
      PA5 = array[6+offset]   #ADC5
      PA6 = array[7+offset]   #ADC6
      PA7 = array[8+offset]   #ADC7
      PB0 = array[9+offset]   #ADC8
      PB1 = array[10+offset]   #ADC9
      PC0 = array[11+offset]   #ADC10
      PC1 = array[12+offset]   #ADC11
      PC2 = array[13+offset]   #ADC12
      PC3 = array[14+offset]   #ADC13
      PC4 = array[15+offset]   #ADC14
      PC5 = array[16+offset]   #ADC15

      a[1+offset] = PC0
      a[2+offset] = PC1
      a[3+offset] = PC2
      a[4+offset] = PC3
      a[5+offset] = PA0
      a[6+offset] = PA1
      a[7+offset] = PA2
      a[8+offset] = PA3
      a[9+offset] = PA4
      a[10+offset] = PA5
      a[11+offset] = PA6
      a[12+offset] = PA7
      a[13+offset] = PC4
      a[14+offset] = PC5
      a[15+offset] = PB0
      a[16+offset] = PB1
   end
   return a
end



function Remove_measurements_involving_injection_electrodes(array)

   #the following double for loop converts a 256-element array #into a 208-element array which represents all the #measurements except the ones that come from the injection #electrodes. The resulting array is still in a u-curve

   Nsamples = length(array)
   Nframes = Nsamples/16

   arrFinal = Array{UInt16}(UInt16(Nframes*(16-3))) # Create output array (size 208)

      for i=1:16
         k=0;
         for j=3:1:(15)
            k=k+1;
            index = (i-1)*(16)+j;
            index2=(i-1)*(13)+k;
            arrFinal[index2] =array[index];
         end
      end
         return(arrFinal)

end


function Reorder_to_get_U_curves(arr)   # DOES THIS WORK??? CHECK AJW

   #the following double for loop shifts the ADC values around #such that the first ADC value in a block of 16 is the value #sampled nearest to the injection electrode
   #the shift that happens depends on the injection electrode #represented by i
   println("*********************** old ************************")
   Nsamples = length(arr)
   arrTemp = Array{UInt16}(Nsamples) # Create output array

   m=0;

   for i=1:16
      for j=1:16
         index =(i-1)*16+j

         index3= index+(i-1)
         if(j<=(16-i+1))
            m =0;

            arrTemp[index] = arr[index+(i-1)]
         else
            m=m+1;
            index2 = (i-1)*16+m;

            arrTemp[index] = arr[index2]
         end
      end
   end
   k=0;

   return(arrTemp)
end




function Reorder_to_get_U_curves_new(arr)
   #the following double for loop shifts the ADC values around #such that the first ADC value in a block of 16 is the value #sampled nearest to the injection electrode
   #the shift that happens depends on the injection electrode #represented by i

   Nsamples = length(arr)
   arrTemp = Array{UInt16}(Nsamples) # Create output array

   for i=1:16    # injection number  (injection pairs 0F 10 21 .. FE)
      for ch=1:16   # Amplifier/ADC channel number 1..16
         arrTemp[ Int( (i-1)*16 + ch )] = arr[Int( (i-1)*16 + mod( (ch-1)-(i-1),16) +1 )]
         # This is not how I thought it should be implemented - maybe I'm tired.
      end
   end
   return(arrTemp)
end














end
