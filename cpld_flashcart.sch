EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CustomGGSymbols:GG_FrontPins J2
U 1 1 6098EBF6
P 6050 5800
F 0 "J2" H 6368 5850 50  0000 L CNN
F 1 "GG_FrontPins" H 5000 5800 50  0000 L CNN
F 2 "CustomGGFootprints:23PinGGPads" H 6050 5800 50  0001 C CNN
F 3 "~" H 6050 5800 50  0001 C CNN
	1    6050 5800
	1    0    0    -1  
$EndComp
$Comp
L MCU_Microchip_ATmega:ATmega4809-A U3
U 1 1 609D3E10
P 4300 2850
F 0 "U3" H 4300 1361 50  0000 C CNN
F 1 "ATmega4809-A" H 4300 1270 50  0000 C CNN
F 2 "Package_QFP:TQFP-48_7x7mm_P0.5mm" H 4300 2850 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/40002016A.pdf" H 4300 2850 50  0001 C CNN
	1    4300 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 1650 6300 1650
Wire Wire Line
	7150 1750 6250 1750
Wire Wire Line
	4900 1850 6200 1850
Wire Wire Line
	7150 1950 6150 1950
Wire Wire Line
	7150 2150 5800 2150
Wire Wire Line
	4900 2250 5750 2250
Wire Wire Line
	7150 2350 5700 2350
Wire Wire Line
	7150 2450 5650 2450
Wire Wire Line
	4900 2450 4900 2550
Wire Wire Line
	7150 2550 5600 2550
Wire Wire Line
	4950 2550 4950 2650
Wire Wire Line
	4950 2650 4900 2650
Wire Wire Line
	7150 2650 5550 2650
Wire Wire Line
	5000 2650 5000 2750
Wire Wire Line
	5000 2750 4900 2750
Wire Wire Line
	7150 2750 5500 2750
Wire Wire Line
	5050 2750 5050 2850
Wire Wire Line
	5050 2850 4900 2850
Wire Wire Line
	5100 2850 5100 2950
Wire Wire Line
	5100 2950 4900 2950
Wire Wire Line
	7150 2950 5900 2950
Wire Wire Line
	5150 2950 5150 3050
Wire Wire Line
	5150 3050 4900 3050
Wire Wire Line
	5200 3050 5200 3250
Wire Wire Line
	5200 3250 4900 3250
Wire Wire Line
	5250 3150 5250 3350
Wire Wire Line
	5250 3350 4900 3350
Wire Wire Line
	5300 3250 5300 3450
Wire Wire Line
	5300 3450 4900 3450
Wire Wire Line
	5350 3350 5350 3550
Wire Wire Line
	5350 3550 4900 3550
Wire Wire Line
	5400 3450 5400 3650
Wire Wire Line
	5400 3650 4900 3650
Wire Wire Line
	8350 1300 3600 1300
Wire Wire Line
	8350 1300 8350 1650
Wire Wire Line
	3550 1250 8400 1250
Wire Wire Line
	8400 1750 8350 1750
Wire Wire Line
	3500 1200 8450 1200
Wire Wire Line
	8450 1200 8450 1850
Wire Wire Line
	8450 1850 8350 1850
Wire Wire Line
	8350 1950 8500 1950
Wire Wire Line
	8500 1950 8500 1150
Wire Wire Line
	8500 1150 3450 1150
Wire Wire Line
	8350 2050 8550 2050
Wire Wire Line
	8550 1100 3400 1100
Wire Wire Line
	8550 1100 8550 2050
Wire Wire Line
	8350 2150 8600 2150
Wire Wire Line
	8600 2150 8600 1050
Wire Wire Line
	8600 1050 3350 1050
Wire Wire Line
	3600 3250 3700 3250
Wire Wire Line
	3600 1300 3600 3250
Wire Wire Line
	3550 3350 3700 3350
Wire Wire Line
	3550 1250 3550 3350
Wire Wire Line
	3500 3450 3700 3450
Wire Wire Line
	3500 1200 3500 3450
Wire Wire Line
	3450 3550 3700 3550
Wire Wire Line
	3450 1150 3450 3550
Wire Wire Line
	3400 3650 3700 3650
Wire Wire Line
	3400 1100 3400 3650
Wire Wire Line
	3350 3750 3700 3750
Wire Wire Line
	3350 1050 3350 3750
Wire Wire Line
	8350 2250 8650 2250
Wire Wire Line
	8650 1000 3300 1000
Wire Wire Line
	3300 1000 3300 3850
Wire Wire Line
	3300 3850 3450 3850
Wire Wire Line
	8650 1000 8650 2250
Wire Wire Line
	8350 2350 8700 2350
Wire Wire Line
	8700 2350 8700 950 
Wire Wire Line
	8700 950  3250 950 
Wire Wire Line
	3250 950  3250 3950
Wire Wire Line
	3250 3950 3400 3950
Wire Wire Line
	7150 3650 5450 3650
Wire Wire Line
	5450 3750 5150 3750
$Comp
L Connector:Micro_SD_Card J1
U 1 1 60AA0038
P 1700 3450
F 0 "J1" H 1650 4167 50  0000 C CNN
F 1 "Micro_SD_Card" H 1650 4076 50  0000 C CNN
F 2 "" H 2850 3750 50  0001 C CNN
F 3 "http://katalog.we-online.de/em/datasheet/693072010801.pdf" H 1700 3450 50  0001 C CNN
	1    1700 3450
	1    0    0    -1  
$EndComp
$Comp
L Regulator_Linear:AP2112K-3.3 U2
U 1 1 60AAE27F
P 1850 1000
F 0 "U2" H 1850 1342 50  0000 C CNN
F 1 "AP2112K-3.3" H 1850 1251 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-5" H 1850 1325 50  0001 C CNN
F 3 "https://www.diodes.com/assets/Datasheets/AP2112.pdf" H 1850 1100 50  0001 C CNN
	1    1850 1000
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2150 900  2300 900 
Wire Wire Line
	4300 900  4300 1350
Wire Wire Line
	7750 1550 7750 1350
Wire Wire Line
	7750 1350 4400 1350
Connection ~ 4300 1350
Wire Wire Line
	4300 1350 4300 1450
Wire Wire Line
	2150 1000 2150 900 
Connection ~ 2150 900 
Wire Wire Line
	3700 1950 3000 1950
Wire Wire Line
	3000 1950 3000 5300
Wire Wire Line
	2950 5350 2950 2050
Wire Wire Line
	2950 2050 3700 2050
Wire Wire Line
	2900 5400 2900 2150
Wire Wire Line
	2900 2150 3700 2150
Wire Wire Line
	2850 5600 2850 2250
Wire Wire Line
	2850 2250 3700 2250
Wire Wire Line
	2800 5650 2800 2350
Wire Wire Line
	2800 2350 3700 2350
Wire Wire Line
	3700 1850 2750 1850
Wire Wire Line
	2750 1850 2750 5050
Wire Wire Line
	2750 5050 5350 5050
Wire Wire Line
	6350 5450 6350 5500
Wire Wire Line
	5850 5500 6350 5500
Connection ~ 6350 5500
Wire Wire Line
	6350 5500 6350 5550
Wire Wire Line
	500  900  500  3450
Wire Wire Line
	500  3450 800  3450
Wire Wire Line
	1850 1300 1850 1700
Connection ~ 4300 4250
Wire Wire Line
	3100 4050 3100 4200
Wire Wire Line
	2500 4050 3100 4050
Wire Wire Line
	800  3650 600  3650
Wire Wire Line
	600  3650 600  4200
Wire Wire Line
	600  4200 3100 4200
Connection ~ 3100 4200
Wire Wire Line
	3100 4200 3100 4250
NoConn ~ 800  3150
NoConn ~ 800  3850
$Comp
L Device:C C2
U 1 1 60CE6209
P 2300 1050
F 0 "C2" H 2415 1096 50  0000 L CNN
F 1 "1u X7R" H 2415 1005 50  0000 L CNN
F 2 "" H 2338 900 50  0001 C CNN
F 3 "~" H 2300 1050 50  0001 C CNN
	1    2300 1050
	1    0    0    -1  
$EndComp
Connection ~ 2300 900 
Wire Wire Line
	1850 1300 2300 1300
Wire Wire Line
	2300 1300 2300 1200
Connection ~ 1850 1300
$Comp
L Device:C C1
U 1 1 60CE6634
P 1150 1050
F 0 "C1" H 1265 1096 50  0000 L CNN
F 1 "1u X7R" H 1265 1005 50  0000 L CNN
F 2 "" H 1188 900 50  0001 C CNN
F 3 "~" H 1150 1050 50  0001 C CNN
	1    1150 1050
	1    0    0    -1  
$EndComp
Connection ~ 1150 900 
Wire Wire Line
	1150 900  950  900 
Wire Wire Line
	1150 1300 1150 1200
Wire Wire Line
	1150 900  1550 900 
Wire Wire Line
	1150 1300 1850 1300
Connection ~ 6300 1650
Wire Wire Line
	6300 1650 4900 1650
Wire Wire Line
	6250 1750 6250 5200
Connection ~ 6250 1750
Wire Wire Line
	6250 1750 4900 1750
Wire Wire Line
	6200 5150 6200 1850
Connection ~ 6200 1850
Wire Wire Line
	6200 1850 7150 1850
Wire Wire Line
	6150 1950 6150 5100
Connection ~ 6150 1950
Wire Wire Line
	6150 1950 4900 1950
Connection ~ 5800 2150
Wire Wire Line
	5800 2150 4900 2150
Connection ~ 5750 2250
Wire Wire Line
	5750 2250 7150 2250
Wire Wire Line
	5850 4900 5700 4900
Connection ~ 5700 2350
Wire Wire Line
	5700 2350 4900 2350
Wire Wire Line
	5850 6200 5650 6200
Wire Wire Line
	5650 6200 5650 2450
Connection ~ 5650 2450
Wire Wire Line
	5650 2450 4900 2450
Wire Wire Line
	5600 6150 5600 2550
Connection ~ 5600 2550
Wire Wire Line
	5600 2550 4950 2550
Wire Wire Line
	5850 5900 5550 5900
Wire Wire Line
	5550 5900 5550 2650
Connection ~ 5550 2650
Wire Wire Line
	5550 2650 5000 2650
Wire Wire Line
	5850 6100 5500 6100
Wire Wire Line
	5500 6100 5500 2750
Connection ~ 5500 2750
Wire Wire Line
	5500 2750 5050 2750
Wire Wire Line
	7150 2850 5850 2850
Wire Wire Line
	5450 3650 5450 3750
Wire Wire Line
	6350 4850 5450 4850
Wire Wire Line
	5450 3800 5850 3800
Wire Wire Line
	5850 3800 5850 2850
Connection ~ 5850 2850
Wire Wire Line
	5850 2850 5100 2850
Wire Wire Line
	5400 6250 5400 3900
Wire Wire Line
	5400 3900 5900 3900
Wire Wire Line
	5900 3900 5900 2950
Connection ~ 5900 2950
Wire Wire Line
	5900 2950 5150 2950
Wire Wire Line
	4900 2050 5950 2050
Wire Wire Line
	5350 5050 5350 3950
Wire Wire Line
	5350 3950 5950 3950
Wire Wire Line
	5950 3950 5950 2050
Connection ~ 5350 5050
Connection ~ 5950 2050
Wire Wire Line
	5950 2050 7150 2050
Wire Wire Line
	7750 1550 6350 1550
Wire Wire Line
	6350 1550 6350 4750
Connection ~ 7750 1550
Wire Wire Line
	8400 1250 8400 1750
Wire Wire Line
	4400 1450 4400 1350
Connection ~ 4400 1350
Wire Wire Line
	4400 1350 4300 1350
Wire Wire Line
	5850 6500 4900 6500
Wire Wire Line
	4900 6500 4900 3950
NoConn ~ 5850 4700
Wire Wire Line
	3100 4250 4300 4250
Wire Wire Line
	3700 2450 3150 2450
Wire Wire Line
	3150 2450 3150 4800
Wire Wire Line
	7150 3850 7050 3850
Wire Wire Line
	7050 3850 7050 4050
Wire Wire Line
	7050 4050 7750 4050
Wire Wire Line
	7750 4050 7750 4250
Wire Wire Line
	4900 3850 5100 3850
Wire Wire Line
	6950 3850 6950 3950
Wire Wire Line
	6950 3950 7150 3950
NoConn ~ 6350 6650
NoConn ~ 6350 6550
NoConn ~ 6350 6450
NoConn ~ 6350 6350
NoConn ~ 5850 6600
Wire Wire Line
	5750 2250 5750 4950
Wire Wire Line
	5800 2150 5800 5000
Wire Wire Line
	2800 5650 5200 5650
Wire Wire Line
	4300 4250 7050 4250
Wire Wire Line
	6350 4950 5750 4950
Wire Wire Line
	6350 6250 5400 6250
Wire Wire Line
	6350 6150 5600 6150
$Comp
L CPLD_Microchip:ATF1502AS-xAx44 U5
U 1 1 609877A7
P 8300 5400
F 0 "U5" H 8300 6581 50  0000 C CNN
F 1 "ATF1502AS-xAx44" H 8300 6490 50  0000 C CNN
F 2 "Package_QFP:TQFP-44_10x10mm_P0.8mm" H 8300 6850 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-0995-CPLD-ATF1502AS(L)-Datasheet.pdf" H 8300 6850 50  0001 C CNN
	1    8300 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	3150 4800 5150 4800
Wire Wire Line
	2950 5350 3450 5350
Wire Wire Line
	3000 5300 3400 5300
Wire Wire Line
	2900 5400 5300 5400
Wire Wire Line
	2850 5600 5250 5600
Wire Wire Line
	5450 3800 5450 4850
Wire Wire Line
	5700 2350 5700 4900
Wire Wire Line
	6300 5250 6350 5250
Wire Wire Line
	6350 5150 6200 5150
$Comp
L CustomGGSymbols:GG_BackPins J3
U 1 1 6098C0B1
P 6550 5750
F 0 "J3" H 6968 5750 50  0000 L CNN
F 1 "GG_BackPins" H 6968 5659 50  0000 L CNN
F 2 "CustomGGFootprints:22PinGGPads" H 6550 5750 50  0001 C CNN
F 3 "~" H 6550 5750 50  0001 C CNN
	1    6550 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	8900 4800 8950 4800
Wire Wire Line
	8950 4800 8950 4350
Wire Wire Line
	8950 4350 6650 4350
Wire Wire Line
	6650 5250 6350 5250
Connection ~ 6350 5250
Wire Wire Line
	6650 4350 6650 5250
Wire Wire Line
	6700 5200 6700 4300
Wire Wire Line
	6700 4300 9000 4300
Wire Wire Line
	9000 4300 9000 4700
Wire Wire Line
	9000 4700 8900 4700
Wire Wire Line
	5850 5200 6250 5200
Connection ~ 6250 5200
Wire Wire Line
	6250 5200 6700 5200
Wire Wire Line
	6350 5150 6750 5150
Wire Wire Line
	6750 5150 6750 4200
Wire Wire Line
	6750 4200 9050 4200
Wire Wire Line
	9050 4200 9050 4600
Wire Wire Line
	9050 4600 8900 4600
Connection ~ 6350 5150
Wire Wire Line
	7700 4700 6800 4700
Wire Wire Line
	6800 4700 6800 5100
Wire Wire Line
	5850 5100 6150 5100
Connection ~ 6150 5100
Wire Wire Line
	6150 5100 6800 5100
Wire Wire Line
	6300 5250 6300 1650
Wire Wire Line
	5350 5050 6350 5050
Wire Wire Line
	7700 4800 6850 4800
Wire Wire Line
	6850 5050 6350 5050
Connection ~ 6350 5050
Wire Wire Line
	5800 5000 5850 5000
Connection ~ 5850 5000
Wire Wire Line
	5850 5000 7700 5000
Wire Wire Line
	6850 4800 6850 5050
Wire Wire Line
	7700 5200 6900 5200
Wire Wire Line
	6900 5200 6900 4950
Wire Wire Line
	6900 4950 6350 4950
Connection ~ 6350 4950
Wire Wire Line
	7700 5300 6950 5300
Wire Wire Line
	6950 5300 6950 4900
Wire Wire Line
	6950 4900 5850 4900
Connection ~ 5850 4900
Wire Wire Line
	5850 6200 7650 6200
Wire Wire Line
	7650 6200 7650 5400
Wire Wire Line
	7650 5400 7700 5400
Connection ~ 5850 6200
Wire Wire Line
	6350 6150 7600 6150
Wire Wire Line
	7600 6150 7600 5500
Wire Wire Line
	7600 5500 7700 5500
Connection ~ 6350 6150
Wire Wire Line
	5850 6100 7500 6100
Wire Wire Line
	7500 6100 7500 5700
Wire Wire Line
	7500 5700 7700 5700
Connection ~ 5850 6100
Wire Wire Line
	6350 4850 7450 4850
Wire Wire Line
	7450 4850 7450 5800
Wire Wire Line
	7450 5800 7700 5800
Connection ~ 6350 4850
Wire Wire Line
	5850 5900 7350 5900
Wire Wire Line
	7350 5900 7350 5600
Wire Wire Line
	7350 5600 7700 5600
Connection ~ 5850 5900
Wire Wire Line
	7700 5900 7450 5900
Wire Wire Line
	7450 5900 7450 6250
Wire Wire Line
	7450 6250 6350 6250
Connection ~ 6350 6250
Wire Wire Line
	5850 6300 7400 6300
Wire Wire Line
	7400 6300 7400 6000
Wire Wire Line
	7400 6000 7700 6000
Wire Wire Line
	7700 6100 7550 6100
Wire Wire Line
	7550 6100 7550 6050
Wire Wire Line
	7550 6050 6350 6050
Wire Wire Line
	5350 5300 5350 7050
Wire Wire Line
	5350 7050 7650 7050
Wire Wire Line
	7650 7050 7650 6250
Wire Wire Line
	7650 6250 7700 6250
Wire Wire Line
	7700 6250 7700 6200
Connection ~ 5350 5300
Wire Wire Line
	5350 5300 5850 5300
Wire Wire Line
	6350 5350 7250 5350
Wire Wire Line
	7250 5350 7250 6350
Wire Wire Line
	7250 6350 7700 6350
Wire Wire Line
	7700 6350 7700 6300
Connection ~ 6350 5350
Wire Wire Line
	5300 5400 5300 7100
Wire Wire Line
	5300 7100 8900 7100
Wire Wire Line
	8900 7100 8900 6300
Connection ~ 5300 5400
Wire Wire Line
	5300 5400 5850 5400
Wire Wire Line
	5250 5600 5250 7150
Wire Wire Line
	5250 7150 8950 7150
Wire Wire Line
	8950 7150 8950 6200
Wire Wire Line
	8950 6200 8900 6200
Connection ~ 5250 5600
Wire Wire Line
	5250 5600 5850 5600
Wire Wire Line
	5200 5650 5200 7200
Wire Wire Line
	5200 7200 9000 7200
Connection ~ 5200 5650
Wire Wire Line
	5200 5650 6350 5650
Wire Wire Line
	9000 6000 8900 6000
Wire Wire Line
	9000 6000 9000 7200
Wire Wire Line
	5150 4800 5150 7250
Wire Wire Line
	5150 7250 9050 7250
Wire Wire Line
	9050 7250 9050 5900
Wire Wire Line
	9050 5900 8900 5900
Connection ~ 5150 4800
Wire Wire Line
	5150 4800 5850 4800
Wire Wire Line
	6350 5950 5100 5950
Wire Wire Line
	5100 5950 5100 7300
Wire Wire Line
	5100 7300 9100 7300
Wire Wire Line
	9100 7300 9100 5800
Wire Wire Line
	9100 5800 8900 5800
Wire Wire Line
	6350 5850 5050 5850
Wire Wire Line
	5050 5850 5050 7350
Wire Wire Line
	5050 7350 9150 7350
Wire Wire Line
	9150 7350 9150 5700
Wire Wire Line
	9150 5700 8900 5700
Wire Wire Line
	8900 5500 10200 5500
Wire Wire Line
	10200 5500 10200 3050
Wire Wire Line
	10150 3150 10150 5400
Wire Wire Line
	10150 5400 8900 5400
Wire Wire Line
	8900 5300 10100 5300
Wire Wire Line
	10100 5300 10100 3250
Wire Wire Line
	10050 3350 10050 5100
Wire Wire Line
	10050 5100 8900 5100
Wire Wire Line
	8900 5000 10000 5000
Wire Wire Line
	10000 5000 10000 3450
Wire Wire Line
	7050 4250 7050 6500
Wire Wire Line
	7050 6500 8300 6500
Connection ~ 7050 4250
Wire Wire Line
	7050 4250 7750 4250
$Comp
L Connector:Conn_01x10_Female J4
U 1 1 612C02E9
P 10650 4300
F 0 "J4" H 10678 4276 50  0000 L CNN
F 1 "Conn_01x10_Female" H 10678 4185 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x05_P2.54mm_Vertical_SMD" H 10650 4300 50  0001 C CNN
F 3 "~" H 10650 4300 50  0001 C CNN
	1    10650 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	10450 3900 9200 3900
Wire Wire Line
	9200 3900 9200 6100
Wire Wire Line
	9200 6100 8900 6100
$Comp
L Device:D D1
U 1 1 612E8AB0
P 8600 3900
F 0 "D1" H 8600 4117 50  0000 C CNN
F 1 "D" H 8600 4026 50  0000 C CNN
F 2 "" H 8600 3900 50  0001 C CNN
F 3 "~" H 8600 3900 50  0001 C CNN
	1    8600 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	8750 3900 8750 1550
Wire Wire Line
	8750 1550 7750 1550
Wire Wire Line
	8450 3900 8300 3900
Wire Wire Line
	8300 3900 8300 4400
Wire Wire Line
	10450 4000 9250 4000
Wire Wire Line
	9250 4000 9250 4800
Wire Wire Line
	9250 6500 8300 6500
Connection ~ 8300 6500
Wire Wire Line
	10450 4100 9100 4100
Wire Wire Line
	9100 4100 9100 5600
Wire Wire Line
	9100 5600 8900 5600
Wire Wire Line
	10450 4200 9300 4200
Wire Wire Line
	9300 4200 9300 4400
Wire Wire Line
	9300 4400 8300 4400
Connection ~ 8300 4400
Wire Wire Line
	10450 4300 9350 4300
Wire Wire Line
	9350 4300 9350 3800
Wire Wire Line
	9350 3800 8200 3800
Wire Wire Line
	8200 3800 8200 4450
Wire Wire Line
	8200 4450 7600 4450
Wire Wire Line
	7600 4450 7600 5100
Wire Wire Line
	7600 5100 7700 5100
Wire Wire Line
	10450 4700 9400 4700
Wire Wire Line
	9400 4700 9400 3750
Wire Wire Line
	9400 3750 8150 3750
Wire Wire Line
	8150 3750 8150 4400
Wire Wire Line
	8150 4400 7550 4400
Wire Wire Line
	7550 4400 7550 4600
Wire Wire Line
	7550 4600 7700 4600
Wire Wire Line
	10450 4800 9250 4800
Connection ~ 9250 4800
Wire Wire Line
	9250 4800 9250 6500
NoConn ~ 10450 4400
NoConn ~ 10450 4500
NoConn ~ 10450 4600
Wire Wire Line
	7150 3350 10050 3350
Wire Wire Line
	7150 3350 5350 3350
Connection ~ 7150 3350
Wire Wire Line
	7150 3150 10150 3150
Wire Wire Line
	7150 3150 5250 3150
Connection ~ 7150 3150
Wire Wire Line
	10200 3050 7150 3050
Wire Wire Line
	7150 3050 5200 3050
Connection ~ 7150 3050
Wire Wire Line
	10100 3250 7150 3250
Wire Wire Line
	7150 3250 5300 3250
Connection ~ 7150 3250
Wire Wire Line
	10000 3450 7150 3450
Wire Wire Line
	7150 3450 5400 3450
Connection ~ 7150 3450
Connection ~ 7750 4050
$Comp
L Memory_Flash:SST39SF040 U4
U 1 1 60988EE4
P 7750 2850
F 0 "U4" H 7750 4331 50  0000 C CNN
F 1 "SST39SF040" H 7750 4240 50  0000 C CNN
F 2 "Package_SO:TSOP-I-32_11.8x8mm_P0.5mm" H 7750 3150 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/25022B.pdf" H 7750 3150 50  0001 C CNN
	1    7750 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5150 4800 5150 3750
Connection ~ 5150 3750
Wire Wire Line
	5150 3750 4900 3750
Wire Wire Line
	5100 5950 5100 3850
Connection ~ 5100 5950
Connection ~ 5100 3850
Wire Wire Line
	5100 3850 6950 3850
Wire Wire Line
	3400 5300 3400 3950
Connection ~ 3400 5300
Wire Wire Line
	3400 5300 5350 5300
Connection ~ 3400 3950
Wire Wire Line
	3400 3950 3700 3950
Wire Wire Line
	3450 5350 3450 3850
Connection ~ 3450 5350
Wire Wire Line
	3450 5350 6350 5350
Connection ~ 3450 3850
Wire Wire Line
	3450 3850 3700 3850
$Comp
L Logic_LevelTranslator:TXB0104PW U1
U 1 1 60A4F48C
P 1550 2050
F 0 "U1" H 1550 1261 50  0000 C CNN
F 1 "TXB0104PW" H 1550 1170 50  0000 C CNN
F 2 "Package_SO:TSSOP-14_4.4x5mm_P0.65mm" H 1550 1300 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/txb0104.pdf" H 1660 2145 50  0001 C CNN
	1    1550 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	800  3250 550  3250
Wire Wire Line
	550  3250 550  1750
Wire Wire Line
	550  1750 1150 1750
Wire Wire Line
	1150 1950 600  1950
Wire Wire Line
	600  1950 600  3350
Wire Wire Line
	600  3350 800  3350
Wire Wire Line
	800  3550 650  3550
Wire Wire Line
	650  3550 650  2150
Wire Wire Line
	650  2150 1150 2150
Wire Wire Line
	1150 2350 700  2350
Wire Wire Line
	700  2350 700  3750
Wire Wire Line
	700  3750 800  3750
Wire Wire Line
	3700 2650 2350 2650
Wire Wire Line
	2350 2650 2350 1750
Wire Wire Line
	2350 1750 1950 1750
Wire Wire Line
	3700 2750 2300 2750
Wire Wire Line
	2300 2750 2300 1950
Wire Wire Line
	2300 1950 1950 1950
Wire Wire Line
	1950 2150 2250 2150
Wire Wire Line
	2250 2150 2250 2850
Wire Wire Line
	2250 2850 3700 2850
Wire Wire Line
	3700 2950 2600 2950
Wire Wire Line
	2600 2950 2600 2350
Wire Wire Line
	2600 2350 1950 2350
Wire Wire Line
	1450 1350 950  1350
Wire Wire Line
	950  1350 950  900 
Connection ~ 950  900 
Wire Wire Line
	950  900  500  900 
Wire Wire Line
	2300 900  2650 900 
Wire Wire Line
	1650 1350 2650 1350
Wire Wire Line
	2650 1350 2650 900 
Connection ~ 2650 900 
Wire Wire Line
	2650 900  4300 900 
$EndSCHEMATC
