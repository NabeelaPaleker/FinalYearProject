/**
  ******************************************************************************
  * File Name          : main.c
  * Description        : Main program body
  ******************************************************************************
  * This notice applies to any and all portions of this file
  * that are not between comment pairs USER CODE BEGIN and
  * USER CODE END. Other portions of this file, whether 
  * inserted by the user or by software development tools
  * are owned by their respective copyright owners.
  *
  * Copyright (c) 2018 STMicroelectronics International N.V. 
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without 
  * modification, are permitted, provided that the following conditions are met:
  *
  * 1. Redistribution of source code must retain the above copyright notice, 
  *    this list of conditions and the following disclaimer.
  * 2. Redistributions in binary form must reproduce the above copyright notice,
  *    this list of conditions and the following disclaimer in the documentation
  *    and/or other materials provided with the distribution.
  * 3. Neither the name of STMicroelectronics nor the names of other 
  *    contributors to this software may be used to endorse or promote products 
  *    derived from this software without specific written permission.
  * 4. This software, including modifications and/or derivative works of this 
  *    software, must execute solely and exclusively on microcontroller or
  *    microprocessor devices manufactured by or for STMicroelectronics.
  * 5. Redistribution and use of this software other than as permitted under 
  *    this license is void and will automatically terminate your rights under 
  *    this license. 
  *
  * THIS SOFTWARE IS PROVIDED BY STMICROELECTRONICS AND CONTRIBUTORS "AS IS" 
  * AND ANY EXPRESS, IMPLIED OR STATUTORY WARRANTIES, INCLUDING, BUT NOT 
  * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
  * PARTICULAR PURPOSE AND NON-INFRINGEMENT OF THIRD PARTY INTELLECTUAL PROPERTY
  * RIGHTS ARE DISCLAIMED TO THE FULLEST EXTENT PERMITTED BY LAW. IN NO EVENT 
  * SHALL STMICROELECTRONICS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
  * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
  * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
  * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
  * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "stm32f4xx_hal.h"
#include "usb_device.h"

/* USER CODE BEGIN Includes */
#include "usbd_cdc_if.h"
#include <assert.h>

/*NOTES:
 * FIXED:
 * I have not yet added code to prevent an overflow from occurring (this should be done in the usbd_cdc_if.c file
 * When running the code, it behaved strangely at times and inconsistently as well. After much debugging, I decided to make most of my variables static
 * because I realised that addresses of variables may have been getting mixed up. However, I cannot make the  receivedData[] array static because its length
 * needs to change whenever new data is read.*/


/* USER CODE END Includes */

/* Private variables ---------------------------------------------------------*/
ADC_HandleTypeDef hadc1;
ADC_HandleTypeDef hadc2;
DMA_HandleTypeDef hdma_adc1;
DMA_HandleTypeDef hdma_adc2;

/* USER CODE BEGIN PV */

/* Private variables ---------------------------------------------------------*/

//static const uint32_t len;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_DMA_Init(void);
static void MX_ADC1_Init(void);
static void MX_ADC2_Init(void);

/* USER CODE BEGIN PFP */
/* Private function prototypes -----------------------------------------------*/

//functions used in alphabetical order
static void calibrateChannels();
void captureFrame();					//when the command is "start", a frame will be captured
void captureMultipleFrames();
void captureSingleFrame();

static void adcTest();
static void executeCommand();					//after checking for a new command, execute the stored command
static void getNumFrames();
uint16_t hex_to_bin(uint8_t received_byte);
void incrementBufferOfLengths();		//after reading a block (command or sequence table) increment the pointer to the size of the block
void newSequenceTable();						//updates the sequence table when a new one arrives
void processCommand(); 					//Determines which command was send through from the PC side
int readBlock();						//reads a block of data (sequence table) based on its length and stores in receivedData[]
void receiveCommand();					//main function that checks for new commands before executing a command
void strobeHigh();						//Strobes the instrument high for to sample on the high current pulse
void strobeLow();						//Strobes the instrument low for to sample on the low current pulse

//get and set functions
uint8_t getCommand();
void setCommand(uint8_t command);
int getSequenceTableLength();
void setSequenceTableLength(int s);

//functions not used
void LED_off();							//turns BLUE LED off
void LED_on();							//turns BLUE LED on
void delay_micro(uint32_t N );			//Creates a delay specified in microseconds by the parameter



					//old echo function
void insert_bit(uint16_t* reg_mask,uint16_t* reg,uint16_t bit_X_in_reg,uint8_t nibble,uint16_t bit_Y_in_nibble);

/* USER CODE END PFP */

/* USER CODE BEGIN 0 */

//					BUFFER STATUS VALUES					//

#define Data_Available_To_Read	1		//indicates that there is still data to read i.e. pRead != pAdded
#define No_Data_To_Read	2				//indicates that there is no data to read i.e. pRead = pAdded
#define Buffer_Full	3

#define End_Of_Block  35 //The end of a block of data is signalled by a "#" character
#define End_Of_Buffer  2048


//						TOMO COMMANDS						//
#define startTomo 0
#define stopTomo 1
#define updateSequenceTable 2
#define doNothing 3
#define captureNFrames 4
#define captureOneFrame 5
#define junk 6
#define test_ADC 7
#define calibrate 8

//						BUFFER SIZES					//
#define End_Of_BuffReceive  2048
#define End_Of_BuffLengths  4
#define bufferSize 2048


//						USB AND ADC VALUES					//
#define NumADCChannels 16
#define NumBytesPerChannel 2

//			FRAME DELAYS				//
#define settle_delay 2
#define sample_delay 6
#define after_sample_delay 2
#define swap_electrodes_delay 2

//static variables

//used variables in alphabetical order
static const acknowledge = 'A';
static uint16_t ADC_Value[16];				//stores ADC values after sampling
static uint16_t calibrationOffsets[16];
static uint16_t calibrationOffsetsAveraged[16];
static uint16_t ADC_Values[256];
volatile static uint8_t 	commandByte= doNothing;		//determines which command should be executed
static uint8_t frameCounter=0;
static uint8_t	len=0;						//stores length of incoming data
static uint8_t	number_of_injections;				//determines number of injections for capturing frame
static uint8_t numFrames;
static uint8_t hexbin=0;

static volatile uint8_t	receivedData[bufferSize];  	// make an array to receive data - the maximum size is the size of the buffer
static int sequence_table_length =0;


//unused variables
static uint16_t ADC_Value_Store[769];


static uint8_t	commandPrevious= doNothing;
static uint8_t 	* pointerToBuffer;
static int rcount=0;
static int ccount=0;
static int scount=0;


///////                               Variables for Conversions                                    /////////////
static const uint8_t I_ON_OFF = 0x00;      //(register: D0)
static const uint8_t STR_HI = 0x01;        //(register: D1)
const uint8_t STR_LO = 0x02;        //(register: D2)
const uint8_t I_CLAMP = 0x03;       //(register: D3)
const uint8_t LAYERMUX_EN = 0x06;   //(register: D6)

const uint8_t S_FRAME = 0x08;   	//(register: D8)  (signals start of frame)
const uint8_t SE_FRAME = 0x0A;  		//(register: D10) (signals end of frame)

// Temporary variables used to hold the register
uint16_t Breg_forward_current;
uint16_t Breg_reverse_current;
uint16_t Ereg_forward_current;
uint16_t Ereg_reverse_current;
uint16_t Ereg_sense_layer;


uint16_t Creg ;
uint16_t Dreg ;
uint16_t Ereg;

// The register masks below store which bits are relevant
// It is important to initialize these to zero
uint16_t Breg_mask = 0x0000;
uint16_t Creg_mask = 0x0000;
uint16_t Dreg_mask = 0x0000;
uint16_t Ereg_mask = 0x0000;
uint16_t Ereg_sense_layer_mask = 0x0000;

uint16_t Breg_forward_current_array[128];	//Choose sink and source for high current
uint16_t Breg_reverse_current_array[128];	//choose sink and source for low current
uint16_t Ereg_forward_current_array[128];	//forward current layer select
uint16_t Ereg_reverse_current_array[128];	//reverse current layer select
uint16_t Ereg_sense_layer_array[128];


//Note: the array is unnecessary/redundant because the masks remain the same.
//uint16_t Breg_mask_array[128];
//uint16_t Ereg_mask_array[128];
//uint16_t Ereg_sense_layer_mask_array[128];


/* USER CODE END 0 */

int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration----------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_ADC1_Init();
  MX_USB_DEVICE_Init();
  MX_ADC2_Init();

  /* USER CODE BEGIN 2 */

  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
  /* USER CODE END WHILE */

  /* USER CODE BEGIN 3 */

	receiveCommand();


  }
  /* USER CODE END 3 */

}

/** System Clock Configuration
*/
void SystemClock_Config(void)
{

  RCC_OscInitTypeDef RCC_OscInitStruct;
  RCC_ClkInitTypeDef RCC_ClkInitStruct;

    /**Configure the main internal regulator output voltage 
    */
  __HAL_RCC_PWR_CLK_ENABLE();

  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

    /**Initializes the CPU, AHB and APB busses clocks 
    */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 4;
  RCC_OscInitStruct.PLL.PLLN = 168;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 7;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Initializes the CPU, AHB and APB busses clocks 
    */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure the Systick interrupt time 
    */
  HAL_SYSTICK_Config(HAL_RCC_GetHCLKFreq()/1000);

    /**Configure the Systick 
    */
  HAL_SYSTICK_CLKSourceConfig(SYSTICK_CLKSOURCE_HCLK);

  /* SysTick_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(SysTick_IRQn, 0, 0);
}

/* ADC1 init function */
static void MX_ADC1_Init(void)
{

  ADC_ChannelConfTypeDef sConfig;

    /**Configure the global features of the ADC (Clock, Resolution, Data Alignment and number of conversion) 
    */
  hadc1.Instance = ADC1;
  hadc1.Init.ClockPrescaler = ADC_CLOCK_SYNC_PCLK_DIV4;
  hadc1.Init.Resolution = ADC_RESOLUTION_12B;
  hadc1.Init.ScanConvMode = ENABLE;
  hadc1.Init.ContinuousConvMode = ENABLE;
  hadc1.Init.DiscontinuousConvMode = DISABLE;
  hadc1.Init.ExternalTrigConvEdge = ADC_EXTERNALTRIGCONVEDGE_NONE;
  hadc1.Init.ExternalTrigConv = ADC_SOFTWARE_START;
  hadc1.Init.DataAlign = ADC_DATAALIGN_RIGHT;
  hadc1.Init.NbrOfConversion = 16;
  hadc1.Init.DMAContinuousRequests = ENABLE;
  hadc1.Init.EOCSelection = ADC_EOC_SINGLE_CONV;
  if (HAL_ADC_Init(&hadc1) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_0;
  sConfig.Rank = 1;
  sConfig.SamplingTime = ADC_SAMPLETIME_3CYCLES;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_1;
  sConfig.Rank = 2;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_2;
  sConfig.Rank = 3;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_3;
  sConfig.Rank = 4;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_4;
  sConfig.Rank = 5;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_5;
  sConfig.Rank = 6;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_6;
  sConfig.Rank = 7;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_7;
  sConfig.Rank = 8;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_8;
  sConfig.Rank = 9;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_9;
  sConfig.Rank = 10;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_10;
  sConfig.Rank = 11;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_11;
  sConfig.Rank = 12;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_12;
  sConfig.Rank = 13;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_13;
  sConfig.Rank = 14;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_14;
  sConfig.Rank = 15;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_15;
  sConfig.Rank = 16;
  if (HAL_ADC_ConfigChannel(&hadc1, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

}

/* ADC2 init function */
static void MX_ADC2_Init(void)
{

  ADC_ChannelConfTypeDef sConfig;

    /**Configure the global features of the ADC (Clock, Resolution, Data Alignment and number of conversion) 
    */
  hadc2.Instance = ADC2;
  hadc2.Init.ClockPrescaler = ADC_CLOCK_SYNC_PCLK_DIV4;
  hadc2.Init.Resolution = ADC_RESOLUTION_12B;
  hadc2.Init.ScanConvMode = ENABLE;
  hadc2.Init.ContinuousConvMode = ENABLE;
  hadc2.Init.DiscontinuousConvMode = DISABLE;
  hadc2.Init.ExternalTrigConvEdge = ADC_EXTERNALTRIGCONVEDGE_NONE;
  hadc2.Init.ExternalTrigConv = ADC_SOFTWARE_START;
  hadc2.Init.DataAlign = ADC_DATAALIGN_RIGHT;
  hadc2.Init.NbrOfConversion = 16;
  hadc2.Init.DMAContinuousRequests = ENABLE;
  hadc2.Init.EOCSelection = ADC_EOC_SINGLE_CONV;
  if (HAL_ADC_Init(&hadc2) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_0;
  sConfig.Rank = 1;
  sConfig.SamplingTime = ADC_SAMPLETIME_3CYCLES;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_1;
  sConfig.Rank = 2;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_2;
  sConfig.Rank = 3;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_3;
  sConfig.Rank = 4;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_4;
  sConfig.Rank = 5;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_5;
  sConfig.Rank = 6;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_6;
  sConfig.Rank = 7;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_7;
  sConfig.Rank = 8;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_8;
  sConfig.Rank = 9;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_9;
  sConfig.Rank = 10;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_10;
  sConfig.Rank = 11;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_11;
  sConfig.Rank = 12;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_12;
  sConfig.Rank = 13;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_13;
  sConfig.Rank = 14;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_14;
  sConfig.Rank = 15;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

    /**Configure for the selected ADC regular channel its corresponding rank in the sequencer and its sample time. 
    */
  sConfig.Channel = ADC_CHANNEL_15;
  sConfig.Rank = 16;
  if (HAL_ADC_ConfigChannel(&hadc2, &sConfig) != HAL_OK)
  {
    _Error_Handler(__FILE__, __LINE__);
  }

}

/** 
  * Enable DMA controller clock
  */
static void MX_DMA_Init(void) 
{
  /* DMA controller clock enable */
  __HAL_RCC_DMA2_CLK_ENABLE();

  /* DMA interrupt init */
  /* DMA2_Stream0_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(DMA2_Stream0_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(DMA2_Stream0_IRQn);
  /* DMA2_Stream2_IRQn interrupt configuration */
  HAL_NVIC_SetPriority(DMA2_Stream2_IRQn, 0, 0);
  HAL_NVIC_EnableIRQ(DMA2_Stream2_IRQn);

}

/** Configure pins as 
        * Analog 
        * Input 
        * Output
        * EVENT_OUT
        * EXTI
     PB10   ------> I2S2_CK
     PC7   ------> I2S3_MCK
     PC10   ------> I2S3_CK
     PC12   ------> I2S3_SD
     PB6   ------> I2C1_SCL
     PB9   ------> I2C1_SDA
*/
static void MX_GPIO_Init(void)
{

  GPIO_InitTypeDef GPIO_InitStruct;

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOE_CLK_ENABLE();
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOH_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();
  __HAL_RCC_GPIOD_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOE, CS_I2C_SPI_Pin|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6 
                          |GPIO_PIN_7|GPIO_PIN_8|GPIO_PIN_9|GPIO_PIN_10 
                          |GPIO_PIN_11|GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14 
                          |GPIO_PIN_15, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_11|GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14 
                          |GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_7|GPIO_PIN_8, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOD, GPIO_PIN_8|GPIO_PIN_10|LD4_Pin|LD3_Pin 
                          |LD5_Pin|LD6_Pin|GPIO_PIN_0|GPIO_PIN_1 
                          |GPIO_PIN_2|GPIO_PIN_3|Audio_RST_Pin|GPIO_PIN_6, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOC, GPIO_PIN_6|GPIO_PIN_8, GPIO_PIN_RESET);

  /*Configure GPIO pins : CS_I2C_SPI_Pin PE4 PE5 PE6 
                           PE7 PE8 PE9 PE10 
                           PE11 PE12 PE13 PE14 
                           PE15 */
  GPIO_InitStruct.Pin = CS_I2C_SPI_Pin|GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6 
                          |GPIO_PIN_7|GPIO_PIN_8|GPIO_PIN_9|GPIO_PIN_10 
                          |GPIO_PIN_11|GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14 
                          |GPIO_PIN_15;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOE, &GPIO_InitStruct);

  /*Configure GPIO pin : BOOT1_Pin */
  GPIO_InitStruct.Pin = BOOT1_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(BOOT1_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pin : CLK_IN_Pin */
  GPIO_InitStruct.Pin = CLK_IN_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  GPIO_InitStruct.Alternate = GPIO_AF5_SPI2;
  HAL_GPIO_Init(CLK_IN_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pins : PB11 PB12 PB13 PB14 
                           PB4 PB5 PB7 PB8 */
  GPIO_InitStruct.Pin = GPIO_PIN_11|GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14 
                          |GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_7|GPIO_PIN_8;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /*Configure GPIO pins : PD8 PD10 LD4_Pin LD3_Pin 
                           LD5_Pin LD6_Pin PD0 PD1 
                           PD2 PD3 Audio_RST_Pin PD6 */
  GPIO_InitStruct.Pin = GPIO_PIN_8|GPIO_PIN_10|LD4_Pin|LD3_Pin 
                          |LD5_Pin|LD6_Pin|GPIO_PIN_0|GPIO_PIN_1 
                          |GPIO_PIN_2|GPIO_PIN_3|Audio_RST_Pin|GPIO_PIN_6;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);

  /*Configure GPIO pins : PC6 PC8 */
  GPIO_InitStruct.Pin = GPIO_PIN_6|GPIO_PIN_8;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

  /*Configure GPIO pins : I2S3_MCK_Pin I2S3_SCK_Pin I2S3_SD_Pin */
  GPIO_InitStruct.Pin = I2S3_MCK_Pin|I2S3_SCK_Pin|I2S3_SD_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  GPIO_InitStruct.Alternate = GPIO_AF6_SPI3;
  HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

  /*Configure GPIO pin : OTG_FS_OverCurrent_Pin */
  GPIO_InitStruct.Pin = OTG_FS_OverCurrent_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(OTG_FS_OverCurrent_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pins : Audio_SCL_Pin Audio_SDA_Pin */
  GPIO_InitStruct.Pin = Audio_SCL_Pin|Audio_SDA_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_AF_OD;
  GPIO_InitStruct.Pull = GPIO_PULLUP;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  GPIO_InitStruct.Alternate = GPIO_AF4_I2C1;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /*Configure GPIO pin : MEMS_INT2_Pin */
  GPIO_InitStruct.Pin = MEMS_INT2_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_EVT_RISING;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(MEMS_INT2_GPIO_Port, &GPIO_InitStruct);

}

/* USER CODE BEGIN 4 */

static void adcTest(){
	HAL_ADC_Start_DMA(&hadc1,ADC_Value_Store, NumADCChannels); 			//Sample all 16 ADC channels and store to ADC_Value using the DMA
	delay_micro(100);
	CDC_Transmit_FS(&ADC_Value_Store[0], 65);
	delay_micro(100);
	setCommand(stopTomo);
}

static void calibrateChannels(){
	int number_of_frames = 500;

	for(int i=0;i<number_of_frames;i++){
	strobeLow(); //strobe sample and hold
	
	delay_micro(10); //delay of 10uS
	
	strobeHigh(); //strobe sample and hold
	
	delay_micro(80); //delay to allow ADC and DMA action to complete
	HAL_ADC_Start_DMA(&hadc2,calibrationOffsets, NumADCChannels);

	delay_micro(10000);
	HAL_ADC_Stop_DMA(&hadc2);
	
	for(int j=0;j<16;j++){
		calibrationOffsetsAveraged[j]=(calibrationOffsetsAveraged[j]+calibrationOffsets[j]);
	}
	}
	for(int i=0;i<16;i++){
		calibrationOffsetsAveraged[i]=calibrationOffsetsAveraged[i]/number_of_frames;
	}
   CDC_Transmit_FS(calibrationOffsetsAveraged, 33);


setCommand(doNothing);
}

void captureFrame(){
	int ind=0;
	int counter=0;
	GPIOD -> ODR |= (1<<SE_FRAME);					//Indicate start of frame (SE_FRAME=1)
	GPIOD -> ODR |= (1<<S_FRAME);					//Indicate start of frame (S_FRAME=1)
	delay_micro(10);								//Generate pulse for 10us
	GPIOD -> ODR &=~ (1<<S_FRAME);					//End 10us pulse indicating start of frame (S_FRAME=0)


	//Next two lines: writes out bits that indicate which layers are used for sensing
	GPIOE -> ODR &=~ Ereg_sense_layer_mask;			//clear the bits that need to be changed and leave others unchanged
	GPIOE -> ODR |= Ereg_sense_layer_array[0];      //OR in the bits that need to go from 0 to 1

	//Do the injections - number_of_injections was determine by the last sequence table uploaded
//	for(int j=0;j<numFrames;j++){

    /* Disable interrupts - I am not sure if this actually works - must test with toggling a bit*/
    //__disable_irq();


	for(int i=0;i<number_of_injections;i++){

		delay_micro(20);
		// These two below should happen simultaneously to maximize speed
		strobeHigh(); 		//strobe high and low to clear sample and hold
	    delay_micro(3);
		strobeLow();
		delay_micro(150);

		//Write to the pins to select electrodes for forward current direction
		GPIOE-> ODR &=~ Ereg_mask;						//clear the bits that need to be changed and leave others unchanged
		GPIOE-> ODR |=  Ereg_forward_current_array[i];	//OR in the bits that need to go from 0 to 1
		GPIOB-> ODR &=~ Breg_mask;						//clear the bits that need to be changed and leave others unchanged
		GPIOB-> ODR |=  Breg_forward_current_array[i];	//OR in the bits that need to go from 0 to 1

		//Turn on current by making line I_ON_OFF (D0) low
		GPIOD -> ODR & =~ (1<<I_ON_OFF);				//Turn current on (I_ON_OFF = 0)
		delay_micro(settle_delay);						//settle_delay (2us) to allow amplifiers to stabilise
		//Sample&Hold for forward current
		strobeLow();
		delay_micro(after_sample_delay);				//short delay before switching current off
		GPIOD -> ODR |= (1<<I_ON_OFF);					//Turn current off (I_ON_OFF = 1)

		//Write to the pins to select electrodes for reverse current direction
		GPIOE-> ODR &=~ Ereg_mask;						//clear the bits that need to be changed and leave others unchanged
		GPIOE-> ODR |=  Ereg_reverse_current_array[i];	//OR in the bits that need to go from 0 to 1
		GPIOB-> ODR &= ~Breg_mask;						//clear the bits that need to be changed and leave others unchanged
		GPIOB-> ODR |=  Breg_reverse_current_array[i];	//OR in the bits that need to go from 0 to 1

		delay_micro(swap_electrodes_delay);  // Currently 3us

		//Turn current on (I_ON_OFF = 0)
		GPIOD -> ODR &=~ (1<<I_ON_OFF);					//Turn current on (I_ON_OFF = 0)
		delay_micro(settle_delay);					    // settle_delay (2us) to allow amplifiers to stabilise
		//Sample&Hold for reverse current
		strobeHigh();
		delay_micro(after_sample_delay);				//short delay before switching current off

		//Turn current off (I_ON_OFF = 1)
		GPIOD -> ODR |= (1<<I_ON_OFF);					//Turn current off (I_ON_OFF = 1)

	//	GPIOD -> ODR &=~ (1<<I_CLAMP);					//set clamp to ground - unused

		delay_micro(50); // Inserting a 50us delay to allow DMA to complete transfer

		HAL_ADC_Start_DMA(&hadc1, ADC_Value, NumADCChannels);  //Sample all 16 ADC channels and store to ADC_Value using the DMA
		

		// Copy converted ADC values into the correct place in the buffer
		
		for(int j = 0; j < number_of_injections; j++){
		
			ind =i*number_of_injections +j; //obtain index to store one ADC value
			//subtract calibration offset and store
			ADC_Value_Store[ind] = ADC_Value[j] - calibrationOffsetsAveraged[j];  
		}

		//}

	}  // end of injection loop


	CDC_Transmit_FS(&ADC_Value_Store[0], 513);	//Transmit entire frame to Julia (16 ADC Values*16 injections)
	

	GPIOD -> ODR &=~ (1<<SE_FRAME);  //Indicate end of Frame (SE_FRAME=0)
	commandByte= stopTomo;			 //After one frame, stop the capturing
}

void captureMultipleFrames(){
	frameCounter=0;
	for(int j=0;j<numFrames;j++){
		captureFrame();
	}

	setCommand(stopTomo);

}

 void captureSingleFrame(){
	captureFrame();
	setCommand(stopTomo);
}

inline void delay_micro(uint32_t N){
//Delay =  N*7/168E6Hz = N*41.6667e-9
// For a 1us delay, put N=24
//conclusion: for loop overhead takes 6 clock cycles and NOP one more cycle.
//Discovery Board
//conclusion: clock is 168MHz - implies one clock cycle is 5.952... ns

//Used an oscilloscope to measure the period, calculated the frequency based on the number of NOPs used
//with no for loop, only delay function overheads and while loop in main function code
//100 NOPs, measured a clock frequency of 159MHz - NOP takes 6.26ns
//1000 NOPS, measured clock frequency is 166MHz - NOP takes 6.02ns
	N=N*24;
	for(uint32_t j=0;j<N; j++){
			asm("NOP");
	}

}

static void executeCommand(){
//If statements check which command is stored in commandByte
	if(getCommand()==startTomo){ 				//Initiates continuous frame capturing until a "stopTomo" command is received

	}
	else if(getCommand()==stopTomo){				//Stops instrument from capturing frames
		//do nothing
	}
	else if(getCommand()==doNothing){ 			//Does nothing, infinite while loop will just keep on checking for data
		//do nothing
	}
	else if(getCommand()==updateSequenceTable){	//Goes to newSequenceTable to check if a table has been sent and updates it
		newSequenceTable();

		scount++;
	}
	else if(getCommand()==captureNFrames){
		getNumFrames();
	}
	else if(getCommand()==captureOneFrame){
		captureSingleFrame();
		CDC_Transmit_FS(&acknowledge, 1); //confirm that command was stored
		ccount++;
	}
	else if (getCommand()==junk){
		setCommand(stopTomo);
	}
	else if(getCommand()==test_ADC){
		adcTest();
	}
	else if(getCommand()==calibrate){
		calibrateChannels();
	}
}

 static void getNumFrames(){
//	len=(*(getBuffLengths()+pLengthToRead)); //get the length of the data that must be read

	if((getStatus() ==Data_Available_To_Read) && len!=0){ //if data is available to read
		 	 numFrames=0;
			pointerToBuffer=getBufferReceived(); //pointer to the beginning of the buffer with data
			readBlock();
			incrementBufferOfLengths();

			for(int i=0;i<len;i++){
				hexbin= hex_to_bin(receivedData[i]);
				for(int j=0;j<i;j++){
					hexbin=10*hexbin;
				}
				numFrames=numFrames+ hexbin;
			}

			commandByte= startTomo;
	}

}

 uint16_t hex_to_bin(uint8_t received_byte){
// Converts a hex ascii byte to an uint16_t binary number
	uint16_t value;
	if (received_byte >= 'A')
		{value = received_byte-'A'+10;}			//for values A to F
	else
		{value = received_byte-'0';}			//for values 0 to 9

	return value;
}



 void insert_bit(uint16_t* reg_mask,uint16_t* reg,uint16_t bit_X_in_reg,uint8_t nibble,uint16_t bit_Y_in_nibble) {
	// This function does two things:
	// (1) insert bit_Y_in_nibble from nibble into position bit_X_in_reg in reg
	// (2) Also write bit_num_in_reg high in the Ereg_mask (which marks which bits are relevant)

	// UInt16* reg_mask (output)
	// UInt16* reg (output)
	// bit_X_in_reg (input)
	// nibble (input)
	// bit_Y_in_nibble (input)

		uint16_t reg_mask_out;
		uint16_t reg_out;
	   // Copy bit
	   if (nibble & (1<<bit_Y_in_nibble)) {  // If bit_num_in_nibble of nibble is 1 then make bitX of reg high
	      reg_out = *reg | (1<<bit_X_in_reg);}
	   else
	   { reg_out = *reg & ~(1<<bit_X_in_reg); }   // else make bitX of reg low


	   // Set bitX of the mask to high
	   reg_mask_out = *reg_mask | (1<<bit_X_in_reg);

	   // Store values
	   *reg = reg_out;
	   *reg_mask = reg_mask_out	;
}

 void LED_off(){
	  GPIOD->ODR &=~( 0b1000000000000000);

}

 void LED_on(){
	 GPIOD->ODR |= 0b1000000000000000;

}

 void newSequenceTable(){
	// This function
	// (1) reads in the length of a block of data,
	// (2) determines if it's a sequence table then processes the sequence table to fill up the E and B register arrays
	// NOTE: The sequence table is in ASCII HEX format; in must be converted to binary nibbles (each nibble stored in a uint8_t

	/*read in sequence table*/


	if(getRearPointer()!=getFrontPointer()){ //if data is available to read
		setCommand(doNothing);
		//delay_micro(500);
	pointerToBuffer=getBufferReceived(); //pointer to the beginning of the buffer with data
	//readBlock();


	/*At this point, everything after this seems to get optimised out */

	//delay_micro(500);
	number_of_injections = readBlock()/6;
	//CDC_Transmit_FS(receivedData[0], 1);
//delay_micro(500);

	/*conversion from sequence table to correct registers */
	uint8_t  nibble1,nibble2,nibble3,nibble4,nibble5,nibble6, byte1,byte2, byte3;
	int i=0;  // index for receivedData
	int n=0;  // injection number

	while( n < number_of_injections ){      //

		// Note there are 6 nibbles for each current injection [describes as "BYTE1,  BYTE2 and BYTE3" in MST 2006 paper, page 6)

		i=n*6;  // point to correct position in the receivedData array (which stores a block of data)
		nibble1 = hex_to_bin( receivedData[i] );   // F(70)->15
		nibble2 = hex_to_bin( receivedData[i+1] );   // 0(48)->0
		nibble3 = hex_to_bin( receivedData[i+2] );
		nibble4 = hex_to_bin( receivedData[i+3] );
		nibble5 = hex_to_bin( receivedData[i+4] );
		nibble6 = hex_to_bin( receivedData[i+5] );


		Breg_forward_current=0;
		Breg_reverse_current=0;
		Ereg_reverse_current=0;
		Ereg_forward_current=0;

		// byte1 = nibble1+10*nibble2;
		//  byte2= nibble3+10*nibble4;
		// byte3 = nibble5+10*nibble6;

		// Process first two nibbles (described as BYTE1 in the MST paper) //
		// Do Current Drive layer selection
		// call  function insert_bit(UInt16* reg_mask,UInt16* reg,bit_num_in_reg,nibble,bit_num_in_nibble)
		//   insert bitY from nibble1 into position bitX in variable Ereg //

		// SET UP Ereg_forward_current  i.e. for forward current injection


		// Do Current Drive layer source (3 bits; select 1 of 8 layers)  //
		insert_bit(&Ereg_mask,&Ereg_forward_current,13, nibble1,0);
		insert_bit(&Ereg_mask,&Ereg_forward_current,14, nibble1,1);
		insert_bit(&Ereg_mask,&Ereg_forward_current,15, nibble1,2);

		// Do Current Drive layer sink (3 bits; select 1 of 8 layers)

		insert_bit(&Ereg_mask,&Ereg_forward_current,10, nibble2,0);
		insert_bit(&Ereg_mask,&Ereg_forward_current,11, nibble2,1);
		insert_bit(&Ereg_mask,&Ereg_forward_current,12, nibble2,2);

		// SET UP Ereg_reverse_current  i.e. for reverse current injection


		// Do Current Drive layer source (3 bits; select 1 of 8 layers)  //
		insert_bit(&Ereg_mask,&Ereg_reverse_current,13, nibble2,0);
		insert_bit(&Ereg_mask,&Ereg_reverse_current,14, nibble2,1);
		insert_bit(&Ereg_mask,&Ereg_reverse_current,15, nibble2,2);

		// Do Current Drive layer sink (3 bits; select 1 of 8 layers)

		insert_bit(&Ereg_mask,&Ereg_reverse_current,10, nibble1,0);
		insert_bit(&Ereg_mask,&Ereg_reverse_current,11, nibble1,1);
		insert_bit(&Ereg_mask,&Ereg_reverse_current,12, nibble1,2);

		// Process next two nibbles (described as BYTE2 in the MST paper) //


		// SET UP Breg_forward_current  i.e. for forward current injection

		// Do current source-electrode selection  (4 bits; selects 1 of 16 electrodes)
		insert_bit(&Breg_mask,&Breg_forward_current,11, nibble3,0);
		insert_bit(&Breg_mask,&Breg_forward_current,12, nibble3,1);
		insert_bit(&Breg_mask,&Breg_forward_current,13, nibble3,2) ;
		insert_bit(&Breg_mask,&Breg_forward_current,14, nibble3,3);

		// Do current sink-electrode selection (4 bits; selects 1 of 16 electrodes)

		insert_bit(&Breg_mask,&Breg_forward_current,4, nibble4,0);
		insert_bit(&Breg_mask,&Breg_forward_current,5, nibble4,1);
		insert_bit(&Breg_mask,&Breg_forward_current,7, nibble4,2) ;  // (Note: bit B6 is not used)
		insert_bit(&Breg_mask,&Breg_forward_current,8, nibble4,3);

		// SET UP Breg_reverse_current  i.e. for reverse current injection (swap electrodes)

		// Do current source-electrode selection  (4 bits; selects 1 of 16 electrodes)
		insert_bit(&Breg_mask,&Breg_reverse_current,11, nibble4,0);
		insert_bit(&Breg_mask,&Breg_reverse_current,12, nibble4,1);
		insert_bit(&Breg_mask,&Breg_reverse_current,13, nibble4,2) ;
		insert_bit(&Breg_mask,&Breg_reverse_current,14, nibble4,3);

		// Do current sink-electrode selection (4 bits; selects 1 of 16 electrodes)

		insert_bit(&Breg_mask,&Breg_reverse_current,4, nibble3,0);
		insert_bit(&Breg_mask,&Breg_reverse_current,5, nibble3,1);
		insert_bit(&Breg_mask,&Breg_reverse_current,7, nibble3,2) ;  // (Note: bit B6 is not used)
		insert_bit(&Breg_mask,&Breg_reverse_current,8, nibble3,3);



		// Process next two nibbles (described as BYTE3 in the MST paper) //
		// Do Sense Layer Selection for non-inverting Vin (3 bits; selects 1 of 8)
		insert_bit(&Ereg_sense_layer_mask,&Ereg_sense_layer,7, nibble5,0);
		insert_bit(&Ereg_sense_layer_mask,&Ereg_sense_layer,8, nibble5,1);
		insert_bit(&Ereg_sense_layer_mask,&Ereg_sense_layer,9, nibble5,2) ; 				 // (Note: bit 6 is not used)

		// Do Sense Layer Selection for inverting Vin (3 bits; selects 1 of 8)
		insert_bit(&Ereg_sense_layer_mask,&Ereg_sense_layer,4, nibble6,0);
		insert_bit(&Ereg_sense_layer_mask,&Ereg_sense_layer,5, nibble6,1);
		insert_bit(&Ereg_sense_layer_mask,&Ereg_sense_layer,6, nibble6,2) ;  				// (Note: bit 6 is not used)

		// NOW STORE IN THE ARRAY
		Breg_forward_current_array[n]=Breg_forward_current;  		// for forward current
		Breg_reverse_current_array[n]=Breg_reverse_current ; 		// for reverse current

		Ereg_forward_current_array[n]=Ereg_forward_current ;        // for layer selections
		Ereg_reverse_current_array[n]=Ereg_reverse_current ;        // for layer selections

		Ereg_sense_layer_array[n]= Ereg_sense_layer;

		//Note: the array is unnecessary/redundant because the masks remain the same.
	    //Breg_mask_array[n]=Breg_mask;
		//Ereg_mask_array[n]=Ereg_mask;
		//Ereg_sense_layer_mask_array[n]= Ereg_sense_layer_mask;

		n++;  // increment injection number
	}



	CDC_Transmit_FS(&acknowledge, 1); //confirm that command was stored
}

}

//this function reads in a sequence table from the queue and returns the length of the sequence table
 int readBlock(){
	int i=0; //initialise counter for adding to the receivedData array
	volatile int end_of_block = 0; //either a 1 or 0 to indicate end of a block
	volatile int receivedByte = 0; //stores one received byte at a time
	sequence_table_length 	  = 0; //increments for each  iteration of the loop to count the size of the sequence table

	while(end_of_block ==0){ //while a "#" character has not been found

		receivedByte = *(pointerToBuffer + getFrontPointer()); //obtain the byte where the front pointer points to
		receivedData[i] = receivedByte; //store one byte of the sequence table in the receivedData array
		i++; //increment the pointer to read next byte

		setFrontPointer(getFrontPointer()+1); //increment the front pointer
		if(getFrontPointer() == (End_Of_BuffReceive)){
			setFrontPointer(0); //if the front pointer reaches the end of the queue, set it to 0
		}
		if(getRearPointer() == getFrontPointer()){
			setStatus(No_Data_To_Read); //if the front pointer equals the rear pointer, set status to No_Data_To_Read
		}
		if(receivedByte == End_Of_Block){ //if the received byte is a "#", set end_of_block to 1 to exit while loop
			end_of_block=1;
		}
		else{
			sequence_table_length++; //increment sequence table length if not at the end of the table
		}
	}
	return sequence_table_length; //return the length of the sequence table

}
//this function processes an incoming command, sets command byte with setCommand and increments the front pointer
void receiveCommand(){

	//if data is available to read and the next block of data is not a sequence table
	if(getStatus() == Data_Available_To_Read && getCommand() != updateSequenceTable){ 	
		
			pointerToBuffer = getBufferReceived(); //pointer to beginning of the queue that stores incoming data
			
			receivedData[0] = *(pointerToBuffer + getFrontPointer()); //store next byte in queue using front pointer
			setCommand(hex_to_bin(receivedData[0])); //set command to received byte after converting to binary value

			setFrontPointer(getFrontPointer()+1); //increment the front pointer by 1 byte
			if(getFrontPointer() == (End_Of_BuffReceive)){
				setFrontPointer(0); //if the end of the queue is reached, set the pointer back to 0
			}
			if(getRearPointer() == getFrontPointer())	{
				setStatus(No_Data_To_Read); //if the front and rear pointers are equal, there is no data to read 
			}
			else{
				setFrontPointer(getFrontPointer()+1); //increment the pointer again for the end of command byte (#)
				if(getFrontPointer()==(End_Of_BuffReceive)){
					setFrontPointer(0);
				}
				if(getRearPointer()==getFrontPointer()) //if there is no data to read, set status to No_Data_To_Read
					setStatus(No_Data_To_Read);
				}
			}
	}
	executeCommand(); //execute whichever command is stored currently
}

/*Strobe the S/H (line "STR_HI") for the forward current direction  (*/
 void strobeHigh(){
	GPIOD -> ODR |= (1<<STR_HI);	// raise strobe line
	delay_micro(sample_delay);		// sample_delay   (wait >=6us for S/H to acquire)
	GPIOD -> ODR &=~ (1<<STR_HI);	// bring strobe line low again

}

/*Strobe the S/H (line "STR_LO") for the reverse current direction  (*/
void strobeLow(){
	GPIOD -> ODR |= (1<<STR_LO);	// raise strobe line
	delay_micro(sample_delay);		// sample_delay   (wait >=6us for S/H to acquire)
	GPIOD -> ODR &=~ (1<<STR_LO);	// bring strobe line low again

}


/*							GET and SET Commands						*/
 uint8_t getCommand(){
	return commandByte;
}
 void setCommand(uint8_t command){
	commandByte=(command);
	CDC_Transmit_FS(&acknowledge, 1);
}

 int getSequenceTableLength(){
	return sequence_table_length;
}


 void setSequenceTableLength(int s){
	sequence_table_length=s;
}
/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @param  None
  * @retval None
  */
void _Error_Handler(char * file, int line)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  while(1) 
  {
  }
  /* USER CODE END Error_Handler_Debug */ 
}

#ifdef USE_FULL_ASSERT

/**
   * @brief Reports the name of the source file and the source line number
   * where the assert_param error has occurred.
   * @param file: pointer to the source file name
   * @param line: assert_param error line source number
   * @retval None
   */
void assert_failed(uint8_t* file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
    ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */

}

#endif

/**
  * @}
  */ 

/**
  * @}
*/ 

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
