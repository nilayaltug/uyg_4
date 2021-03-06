	LIST P=16F877A
	#INCLUDE <P16F877A.INC>
	__CONFIG H'3F31'
	SAYICI1 EQU 0X20
	SAYICI2 EQU 0X21
	ADRESH_YEDEK EQU 0X22
	ADRESL_YEDEK EQU 0X23

	ORG 0X000
	GOTO ANA_METOT
	ORG 0X004
	GOTO KESME_METOT

KESME_METOT
	BTFSS PIR1,ADIF
	RETFIE
	BCF PIR1,ADIF

	BANKSEL ADRESH
	MOVF ADRESH,W
	BANKSEL ADRESH_YEDEK
	MOVWF ADRESH_YEDEK
	CALL ADRESH_ISLEM

	BANKSEL ADRESL
	MOVF ADRESL,W
	BANKSEL ADRESL_YEDEK
	MOVWF ADRESL_YEDEK
	CALL ADRESL_ISLEM
	MOVF ADRESL_YEDEK,W
	ANDLW B'00111111'
	ADDWF ADRESH_YEDEK,W

	BANKSEL PORTB
	MOVWF PORTB
	CALL GECIKME
	BSF ADCON0,GO
	CALL GECIKME

	RETFIE

ADRESH_ISLEM
	RRF ADRESH_YEDEK,F
	RRF ADRESH_YEDEK,F
	RRF ADRESH_YEDEK,F
	RETURN

ADRESL_ISLEM
	RRF ADRESL_YEDEK,F
	RRF ADRESL_YEDEK,F
	RETURN

ANA_METOT
	BANKSEL TRISA
	MOVLW 0XFF
	MOVWF TRISA
	CLRF TRISB
	
	MOVLW B'10000000'
	MOVWF ADCON1

	BANKSEL PORTA
	MOVLW 0XFF
	MOVWF PORTA
	CLRF PORTB

	BANKSEL ADCON0
	MOVLW B'11000001'
	MOVWF ADCON0
	CALL GECIKME
	BANKSEL ADCON0

	BANKSEL INTCON
	MOVLW B'11000000'
	MOVWF INTCON
	BANKSEL INTCON

	BANKSEL PIE1
	BSF PIE1,ADIE
	BANKSEL PIE1

	BANKSEL PIR1
	BCF PIR1,ADIF
	BANKSEL PIR1

DONUSTURME_METOT
	BSF ADCON0,GO
	CALL GECIKME

KONTROL
	GOTO KONTROL

GECIKME
	MOVLW 0XA0
	MOVWF SAYICI1

TEKRAR1
	MOVLW 0XA0
	MOVWF SAYICI2

TEKRAR2
	DECFSZ SAYICI2,F
	GOTO TEKRAR2
	DECFSZ SAYICI1,F
	GOTO TEKRAR1
	RETURN

END

