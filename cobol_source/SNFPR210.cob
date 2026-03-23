000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID.      SNFPR210.
000300*AUTHOR.                 CMS.
000400*
000600*
001500***--------------------------------------------------------****
000700*REMARKS. (CENTERS FOR MEDICARE AND MEDICAID SERVICES)
000800***         - NATIONAL SNF PRICER EFFECTIVE OCT 1, 2020
000900***         - SNF PRICER REFERS TO A PROGRAM WHICH WILL
001000***           CALCULATE THE MEDICARE RATE UPON WHICH THE
001100***           PDPM SNF PPS PAYMENT IS MADE. PRICER USES THE
001200***           HIPPS CODE, REGION IND & AIDS ADD-ON-IND
001300***           TO CALCULATE THE HCPPS RATES.
001500***--------------------------------------------------------****
001500***--------------------------------------------------------****
001600*     SNFPR210   EFFECTIVE OCT 1, 2020
001500*         ****-------------------------------------------****
001700*       -- >>                                           << --
001700*       -- >>    ** PROD ** VERSION **                  << --
001700*       -- >>                                           << --
001700*       -- >>  SUPPL WAGE IND DATA ADDED TO I-O RECORD  << --
001700*       -- >>       LOGIC CHANGES AS OF 8/7/2020        << --
001700*       -- >>                                           << --
001700*       -- >>   COMPILE WITH REVISED I-O RECORD LAYOUT  << --
001700*       -- >>                                           << --
001500*         ****-------------------------------------------****
001900*                SNF DRIVER - SNFDR210
001700*                USE CBSA FILE WITH FY 2021 VALUES
001500*         ****-------------------------------------------****
001900*                SNF DRIVER - SNFDR210
001800*                CALL ** PROD ** PRICER MODULE, SNFPR210
001500*         ****-------------------------------------------****
001500*         ****-------------------------------------------****
001900*                SNF PRICER - SNFPR210
001800*                USE PAYMENT RATES FOR FY2021
001500***--------------------------------------------------------****
001500***--------------------------------------------------------****
001600*     SNFPR21B   EFFECTIVE OCT 1, 2020
001500*         ****-------------------------------------------****
001700*       -- >>                                           << --
001700*       -- >>    ** BETA ** VERSION FOR TESTING ONLY    << --
001700*       -- >>                                           << --
001700*       -- >>  SUPPL WAGE IND DATA ADDED TO I-O RECORD  << --
001700*       -- >>    NO LOGIC CHANGES AS OF 6/5/2020        << --
001700*       -- >>                                           << --
001700*       -- >>   COMPILE WITH REVISED I-O RECORD LAYOUT  << --
001700*       -- >>                                           << --
001500*         ****-------------------------------------------****
001900*                SNF DRIVER - SNFDR21B
001700*                USE CBSA FILE WITH FY 2020 VALUES WITH
001800*                DUPLICATE ENTRIES FOR FY 2021.B
001500*         ****-------------------------------------------****
001900*                SNF DRIVER - SNFDR21B
001800*                CALL ** BETA ** PRICER MODULE, SNFPR21B
001500*         ****-------------------------------------------****
001900*                SNF PRICER - SNFPR21B
001800*                USE PAYMENT RATES FOR FY2020
001500*****------------------------------------------------------****
001500*****------------------------------------------------------****
001900*     SNFPR205   SNF PRICER - SNFPR205
001600*                EFFECTIVE OCT 1, 2019
002200*                REVISE REMAPPING OF NTA WHEN AIDS ADD-ON IND
002200*                IS SET TO 'Y'. 'B20' = PRINCIPLE DX CODE.
001500***--------------------------------------------------------****
001500***--------------------------------------------------------****
001600*     SNFPR204   EFFECTIVE OCT 1, 2019
002200*                REVISE HIPPS VALIDITY CHECK TO PROCESS THE
002200*                DEFAULT-HIPPS-CODE = 'ZZZZZ'
001500***--------------------------------------------------------****
001600*     SNFPR202   EFFECTIVE OCT 1, 2019
002200*                RETURN CODES RTC=80  SNF-PDPM-UNITS = ZERO AND
002200*                RTC=90 INVALID HIPPS CODE WERE REPLACED WITH
002200*                RTC=20 INVALID RATE COMPONENT
001500***--------------------------------------------------------****
001600*     SNFPR200   EFFECTIVE OCT 1, 2019
001700*                USE CBSA FILE FOR FY2020
001800*                USE PAYMENT RATES FOR FY2020
001900*                SNF DRIVER - SNFDR200
002000*                VARIABLE PER DIEM LOGIC ADDED
002100*                PDPM PAYMENT CODING
002200*                RETURN ERROR RTC IF INPUT HAS ERRORS
001500***--------------------------------------------------------****
001600*     SNFPR20B   EFFECTIVE OCT 1, 2019
001700*                BETA VERSION FOR FY2020 USE FOR TESTING ONLY
001700*                USE CBSA FILE WITH FY 2019 VALUES WITH
001800*                DUPLICATE ENTRIES FOR FY 2020
001900*                SNF DRIVER - SNFDR20B
001800*                USE PAYMENT RATES FOR FY2020
001900*                SNF DRIVER - SNFDR20B
002000*                VARIABLE PER DIEM LOGIC ADDED
002100*                PDPM PAYMENT CODING
002200*                RETURN ERROR RTC IF INPUT HAS ERRORS
001500***--------------------------------------------------------****
002400 DATE-COMPILED.
002500 ENVIRONMENT DIVISION.
002600 CONFIGURATION SECTION.
002700 SOURCE-COMPUTER.            IBM-370.
002800 OBJECT-COMPUTER.            IBM-370.
002900 INPUT-OUTPUT  SECTION.
003000 FILE-CONTROL.
003100
003200 DATA DIVISION.
003300 FILE SECTION.
003400
003500 WORKING-STORAGE SECTION.
003600 01  W-STORAGE-REF                  PIC X(46)  VALUE
003700     'SNFPR210   - W O R K I N G   S T O R A G E'.
003800 01  CAL-VERSION                    PIC X(09) VALUE 'SNFPR21.0'.
003900 01  PX1                            PIC S9(04) COMP SYNC.
004000 01  DX1                            PIC S9(04) COMP SYNC.
004200
004300*****-------------------------------------------------*******
004400*           VARIABLE-PER-DIEM-ADJUSTMENT-FACTORS
004500*        [APPLY TO ONLY 3 COMPONENTS - PT / OT / NTA]
004600*****-------------------------------------------------*******
004700*
004800 COPY VPDTAB.
004900*
005000*01  VARIABLE-PER-DIEM-TABLE.
005100*****--------------------------------------------************
005200*****--------------------------------------------************
005300*****----  END VARIABLE PER DIEM  TABLE  --------************
005400*****--------------------------------------------************
005500*
005600*****--------------------------------------------************
005700 01  DEFAULT-HIPPS-CODING.
005800*****--------------------------------------------************
005900     05 DEFAULT-HIPPS-CODE          PIC XXXXX  VALUE 'ZZZZZ'.
006000     05 REPLACEMENT-HIPPS-CODE      PIC XXXXX  VALUE 'PAYF1'.
006100*****--------------------------------------------************
005600*****--------------------------------------------************
005700 01  LABOR-NLABOR-PERCENT.
005800*****--------------------------------------------************
005900     05 PERCENT-2021-LABOR          PIC 9V9999 VALUE 0.7130.
006000     05 PERCENT-2021-NLABOR         PIC 9V9999 VALUE 0.2870.
006100*****--------------------------------------------************
006200*   HOLDING AREA FOR CAPTURED RATES FROM
006300*      PRICING COMPONENT
006400*****--------------------------------------------************
006500
006600 01  HIPPS-PER-DIEM-COMPONENTS.
006700*****-------------------------------------------------*******
006800     05 HIPPS-PT-RATE-COMP          PIC 999V99.
006900     05 HIPPS-OT-RATE-COMP          PIC 999V99.
007000     05 HIPPS-SLP-RATE-COMP         PIC 999V99.
007100     05 HIPPS-NURSE-RATE-COMP       PIC 999V99.
007200     05 HIPPS-NTA-RATE-COMP         PIC 999V99.
007300     05 HIPPS-NCM-RATE-COMP         PIC 999V99.
007400*
007500*****-------------------------------------------------*******
007600 01  WS-PER-DIEM-SUBTOTALS.
007700*****-------------------------------------------------*******
007800     05 WS-PT-OT-FEE                PIC 999V99.
007900     05 WS-PT-OT-UTIL               PIC 999V99.
008000     05 WS-NTA-UTIL                 PIC 999V99.
008100     05 WS-PT-OT-PORTION            PIC 9(6)V99.
008200     05 WS-NTA-PORTION              PIC 9(6)V99.
008300     05 WS-NURS-SLP-NCM-PORTION     PIC 9(6)V99.
008400*
008500*****-------------------------------------------------*******
008600**   05 HIPPS-PER-DIEM-SUM          PIC 999V99.
008700*****-------------------------------------------------*******
008800
008900 01  NON-CASE-MIX-RATES.
009000*****-------------------------------------------------*******
009100     05 URBAN-NCM-COMP-2021         PIC 999V99 VALUE 096.85.
009200     05 URBAN-QRP-NCM-COMP-2021     PIC 999V99 VALUE 094.96.
009300     05 RURAL-NCM-COMP-2021         PIC 999V99 VALUE 098.64.
009400     05 RURAL-QRP-NCM-COMP-2021     PIC 999V99 VALUE 096.72.
009500
009600*****-------------------------------------------------*******
009700*****-------------------------------------------------*******
009800 01  DAY-OF-STAY                    PIC 999.
009900 01  HIPPS-PER-DIEM-SUM             PIC 9(06)V99 VALUE 0.
010000 01  LABOR-PORTION                  PIC 9(06)V99 VALUE 0.
010100 01  NON-LABOR-PORTION              PIC 9(06)V99 VALUE 0.
010200 01  LABOR-ADJUSTED                 PIC 9(06)V99 VALUE 0.
010300 01  NON-LABOR-ADJUSTED             PIC 9(06)V99 VALUE 0.
010400 01  TOTAL-LABOR-ADJ-RATE           PIC 9(06)V99 VALUE 0.
010500 01  TOTAL-CALC-PAYMENT-RATE        PIC 9(06)V99 VALUE 0.
010600 01  INIT-PAYMENT-RATE              PIC 9(06)V99 VALUE 0.
010700 01  TOT-PDPM-CASEMIX-PERDIEM       PIC 9(06)V99 VALUE 0.
010800*****-------------------------------------------------*******
010900 01  WS-TOTAL-DAYS             PIC 9(3).
011000 01  DAYS-TO-100               PIC 9(3).
011100 01  TOTAL-DAYS                PIC 9(3).
011200 01  SUB2                      PIC 9(3).
011300 01  CURRENT-DAYS              PIC 9(3).
011400**----------------------------------------------------*******
011500**----------------------------------------------------*******
011600 01  VBP-ADJ-PYMT-RATE         PIC 9(06)V99 VALUE 0.
011700 01  INITIAL-PAYMENT-RATE      PIC 9(06)V99 VALUE 0.
011800
011900
012000
012100 01  HLD-PRICE-FROM-DATE.
012200     10  HLD-PRICE-FROM-CC     PIC XX.
012300     10  HLD-PRICE-FROM-YY     PIC XX.
012400     10  HLD-PRICE-FROM-MMDD   PIC XXXX.
012500
012600 01  HLD-PRICE-THRU-DATE.
012700     10  HLD-PRICE-THRU-CC     PIC XX.
012800     10  HLD-PRICE-THRU-YY     PIC XX.
012900     10  HLD-PRICE-THRU-MMDD   PIC XXXX.
013000
013100**----------------------------------------------------*******
013200**   VERIFY THAT EACH HIPPS CHAR IS WITHIN PRESET VALUES  ***
013300**----------------------------------------------------*******
013400 01  WK-HIPPS-CODE.
013500     10  WK-HIPPS-TRANSLATE.
013600         15  HIPPS-CHAR-1       PIC X.
013700             88  VALID-HIPPS-PT-OT        VALUE "A" THRU "P".
013800
013900         15  HIPPS-CHAR-2       PIC X.
014000             88  VALID-HIPPS-SLP          VALUE "A" THRU "L".
014100
014200         15  HIPPS-CHAR-3       PIC X.
014300             88  VALID-HIPPS-NURSING      VALUE "A" THRU "Y".
014400
014500         15  HIPPS-CHAR-4       PIC X.
014600             88  VALID-HIPPS-NTA          VALUE "A" THRU "F".
014700             88  NTA-AIDS-ADD-ON-A        VALUE "A" THRU "D".
014800             88  NTA-AIDS-ADD-ON-B        VALUE "E".
014800             88  NTA-AIDS-ADD-ON-C        VALUE "F".
014900
015000         15  HIPPS-CHAR-5       PIC X.
015100             88  VALID-HIPPS-ASSESS-LEVEL VALUE "0" THRU "1".
015200
015700     10  HLD-RATE-RTC.
015800         15  HLD-PAYMENT-RATE       PIC 9(06)V99.
015900         15  HLD-RTC                PIC 99.
016000*
016100     10  HLD-VBP-DATA.
016200         15  HLD-VBP-MULTIPLIER     PIC S9V9(11).
016300         15  HLD-VBP-PAY-DIFF       PIC S9(06)V9(02).
016400*
016500     10  HLD-PDPM-DATA.
016600         15  ACTIVE                 PIC 99.
016700         15  PRIOR-DAYS             PIC 999.
016800
015300*
015400     10  HLD-SPEC-WI-IND       PIC X.
015500     10  HLD-SPEC-WI           PIC 9(02)V9(04).
015600*
016900     10  HLD-LOOP-DATA.
017000         15 START-DAY-LOOP     PIC 999.
017100         15 STOP-DAY-LOOP      PIC 999.
017200*
017300         15 VPD-FACT-COUNT         PIC 999.
017400         15 EACH-DAY-COUNT         PIC 999.
017500
017600
017700
017800*---------------------------------------------------------------*
017900**>>  START OF URBAN RATE COPYBOOKS FOR FY2021 <<**
018000*---------------------------------------------------------------*
018100
018200
018300*****-------------------------------------------------******
018400*01 HIPPS-1-URBAN-COMPONENTS - PT/OT
018500*****- ----------------------------------------------*******
018600 COPY URBPTO21.
018700*****- ----------------------------------------------****
018800*01 HIPPS-2-URBAN-COMPONENTS - SLP
018900*****- ----------------------------------------------****
019000 COPY URBSLP21.
019100*****------------------------------------------------****
019200*01 HIPPS-3-URBAN-COMPONENTS - NURSING
019300*****- ----------------------------------------------****
019400 COPY URBNUR21.
019500*****-----------------------------------------------*****
019600*****------------------------------------------------****
019700*01 HIPPS-4-URBAN-COMPONENTS - NTA
019800*****-----------------------------------------------*****
019900 COPY URBNTA21.
020000**--------------------------------------------------*****
020100
020200*-------------------------------------------------------*
020300***>>  END OF URBAN RATE COPYBOOKS FOR FY2021  <<**
020400*-------------------------------------------------------*
020500*********************************************************
020600*-------------------------------------------------------*
020700***>>  START OF RURAL RATE COPYBOOKS FOR FY2021  <<**
020800*-------------------------------------------------------*
020900
021000*****----------------------------------------------******
021100*****----------------------------------------------******
021200*01 HIPPS-1-RURAL-COMPONENTS - PT/OT
021300*****- --------------------------------------------******
021400 COPY RURPTO21.
021500*****- ----------------------------------------------****
021600*01 HIPPS-2-RURAL-COMPONENTS. - SLP
021700*****- ---------------------------------------------*****
021800 COPY RURSLP21.
021900*****- ---------------------------------------------*****
022000*****-----------------------------------------------*****
022100*01 HIPPS-3-RURAL-COMPONENTS - NURSING
022200*****----------------------------- -----------------*****
022300 COPY RURNUR21.
022400*****-----------------------------------------------*****
022500*****-----------------------------------------------*****
022600*01 HIPPS-4-RURAL-COMPONENTS - NTA
022700*****-----------------------------------------------*****
022800 COPY RURNTA21.
022900*-------------------------------------------------------*
023000***>>  END OF RURAL RATE COPYBOOKS FOR FY2021  <<**
023100*-------------------------------------------------------*
023200
023300
023400*-------------------------------------------------------*
023500****>>  END OF RATE COMPONENTS  FOR FY2021.0 <<******
023600*-------------------------------------------------------*
023700
023800*-------------------------------------------------------*
023900*------------>>  END OF WORKING STORGE  <<--------------*
024000*-------------------------------------------------------*
024100
024200 LINKAGE SECTION.
024300***************************************************************
024400*                 * * * * * * * * *                           *
024500***************************************************************
024600***************************************************************
024700*    THIS DATA IS CALCULATED BY THIS SNFPR  SUBROUTINE        *
024800*    AND PASSED BACK TO THE CALLING PROGRAM                   *
024900*            RETURN CODE VALUES (SNF-RTC)                     *
025000*                                                             *
025100*            SNF-RTC                                          *
025200*              00 = PDPM GROUP RATE RETURNED                  *
025300*                                                             *
025400*            SNF-RTC   NO RATE RETURNED                       *
025500*                                                             *
025600*              20 = INVALID RATE COMPONENT                    *
025700*                                                             *
025800*              30 = INVALID MSA OR CBSA OR WAGE INDEX         *
025900*                                                             *
026000*              40 = THRU DATE < JULY 1 1998 OR INVALID        *
026100*                                                             *
026200*              50 = INVALID FEDERAL BLEND FOR THAT YEAR       *
026300*                                                             *
026400*              60 = INVALID FEDERAL BLEND                     *
026500*                                                             *
026600*              61 = FEDERAL BLEND = 0 AND                     *
026700*                   SNF THRU DATE < JAN 1, 2000               *
026800*                                                             *
026900*              70 = VBP-MULTIPLIER = ZEROES                   *
027000*                                                             *
027100*              20 = PDPM-UNITS = ZEROES                       *
027200*                                                             *
027300*              20 = INVALID-HIPPS-CODE                        *
027400*                                                             *
027600***************************************************************
027700*-------------------------------------------------------------*
027800*     SNF300P  COPYBOOK CONTAINS THE SNF INPUT LAYOUT         *
027900*   IN VARIABLE FORMAT TO COMPLETE THE HOSPICE PRICING        *
028000*   TIONAL SNF RECORD FORMAT PASSED TO SNFPR PROGRAM          *
028100*                                                             *
028200*-------------------------------------------------------------*
028300*
028400 COPY SNF300P.
028500
028600 01  HOLD-VARIABLES.
028700     02  HOLD-VAR-DATA.
028800         05  REGION-IND              PIC X.
028900         05  QRP-IND                 PIC X.
029000         05  AIDS-ADD-ON-IND         PIC X.
029100         05  AREA-WAGE-INDEX         PIC 9(01)V9(04).
029200         05  IP-RATE                 PIC 9(03)V9(02).
029300         05  GS-RATE                 PIC 9(02)V9(02).
029400     02  SNFPR-VERSION               PIC X(09).
029500
029600 01  CBSA-WAGE-INDEX-RECORD.
029700     02  HOLD-CBSA-WIR-DATA.
029800         05  CBSA-WIR-CBSA            PIC X(05).
029900         05  CBSA-WIR-EFFDATE         PIC X(08).
030000         05  CBSA-WIR-AREA-WAGEIND    PIC 9(02)V9(04).
030100
030200 PROCEDURE DIVISION  USING SNF-DATA
030300                     HOLD-VARIABLES
030400                     CBSA-WAGE-INDEX-RECORD.
030500
030600***************************************************************
030700*    PROCESSING:                                              *
030800*        -  WILL PROCESS ALL PDPM SNF FOR FY2021              *
030900*                STARTING OCT 1, 2020                        *
031000***************************************************************
031100
031200     PERFORM 0200-MAINLINE-CONTROL.
031300
031400
031500     GOBACK.
031600
031700 0200-MAINLINE-CONTROL.
031800
031900
032000     MOVE ALL '0'              TO HLD-RATE-RTC.
032100
032200     MOVE CAL-VERSION          TO SNFPR-VERSION.
032300
032400     MOVE ZEROS TO    WS-PT-OT-UTIL
032500                      WS-PT-OT-PORTION
032600                      WS-NTA-UTIL
032700                      WS-NTA-PORTION
032800                      WS-NURS-SLP-NCM-PORTION
032900                      DAYS-TO-100
033000                      TOTAL-DAYS
033100                      TOT-PDPM-CASEMIX-PERDIEM
033200                      TOTAL-CALC-PAYMENT-RATE
033300                      LABOR-PORTION
033400                      LABOR-ADJUSTED
033500                      NON-LABOR-PORTION
033600                      NON-LABOR-ADJUSTED
033700                      TOTAL-LABOR-ADJ-RATE.
033800
033900     MOVE 1 TO      SUB2.
034000
034100     IF  SNF-RTC = 00
034400
034200         PERFORM 300-DEFAULT-HIPPS-CHECK
034300            THRU 300-EXIT
034400
034200         PERFORM 400-VALIDATE-SNF-INPUT
034300            THRU 400-EXIT.
034400
046800
046900 300-DEFAULT-HIPPS-CHECK.
034600
034700*------------------------------------------------------
034800*------------------------------------------------------
051800*   DEFAULT HIPPS CODE CHECK                          *
035000*------------------------------------------------------
035000*------------------------------------------------------
035200
035300     MOVE SNF-HIPPS-CODE       TO WK-HIPPS-CODE.
035600
051700*-----------------------------------------------------*
035100*------------------------------------------------------
035900*   IF WK-HIPPS-CODE = 'ZZZZZ'                        *
035900*      REPLACE WITH 'PAYF1'                           *
035900*              TO SELECT RATING COMPONENTS            *
051900*-----------------------------------------------------*
051700*-----------------------------------------------------*
03A300
036400
036400     IF WK-HIPPS-CODE = DEFAULT-HIPPS-CODE
036400
036400        MOVE REPLACEMENT-HIPPS-CODE
036400                               TO WK-HIPPS-CODE
037000     GO TO 300-EXIT.
037100
052000*-----------------------------------------------------*
035700*------------------------------------------------------
035800*   VALIDATE HIPPS CODE                               *
035900*       ALL 5 CHARACTERS HAVE PRESET VALUES           *
036000*       IF ANY CHARACTER DOES NOT MEET CRITERIA       *
036100*       RETURN TO DRIVER WITH RTC = 20                *
036200*------------------------------------------------------
036300
036400     IF NOT (VALID-HIPPS-PT-OT)   OR
036500        NOT (VALID-HIPPS-SLP)     OR
036600        NOT (VALID-HIPPS-NURSING) OR
036700        NOT (VALID-HIPPS-NTA)     OR
036800        NOT (VALID-HIPPS-ASSESS-LEVEL)
036900         MOVE '20'             TO SNF-RTC
037000     GO TO 300-EXIT.
037100
052600
052700****--------------------------------------------------------------
052800*
052700****--------------------------------------------------------------
052900 300-EXIT.    EXIT.
053000     EXIT.
053100
034500 400-VALIDATE-SNF-INPUT.
037200*------------------------------------------------------
037300*   THE VBP-MULTIPLIER MUST NOT BE = 0                *
037400*------------------------------------------------------
037500
037800     IF VBP-MULTIPLIER = ZEROES
037900        MOVE '70'              TO SNF-RTC
038000     END-IF.
038100
038200*------------------------------------------------------
038300*   THE PDPM-UNITS MUST NOT BE = 0                    *
038400*------------------------------------------------------
038500
038600     IF SNF-PDPM-UNITS = ZEROES
038700        MOVE '20'              TO SNF-RTC
038800     END-IF.
038900
039000*-------------------------------------------------------*
039100*---------->>  'FROM DATE' & 'THRU DATE'      <<--------*
039200*---------->>   CANNOT SPAN FISCAL YEARS      <<--------*
039300*---------->>  THIS EDIT WILL MAKE SURE       <<--------*
039400*--------->>     THE CLAIM DOES NOT           <<--------*
039500*--------->>     SPAN FISCAL YEARS            <<--------*
039600*-------->>  IF THRU MM=10 + THRU DD=00          -------*
039700*--------->>      SET MMDD = 1001             <<--------*
039800*-------------------------------------------------------*
039900
040000     MOVE SNF-THRU-DATE        TO HLD-PRICE-THRU-DATE.
040100     MOVE SNF-FROM-DATE        TO HLD-PRICE-FROM-DATE.
040200
040300     IF HLD-PRICE-THRU-MMDD = '1001' AND
040400        HLD-PRICE-FROM-DATE < HLD-PRICE-THRU-DATE
040500        MOVE '0930'            TO HLD-PRICE-THRU-MMDD.
040600
040700*-------------------------------------------------------*
040800*--------->>     END FISCAL YR SPAN EDIT  <<--------*
040900*-------------------------------------------------------*
041000
041100     IF SNF-RTC NOT = 00
041200            GO TO 400-EXIT.
041300
041400**************************************>> YEARCHANGE 2020.0 ***
041500
041600     IF HLD-PRICE-THRU-DATE > 20190930
041700        MOVE CBSA-WIR-AREA-WAGEIND
041800                               TO AREA-WAGE-INDEX.
041900
042300        PERFORM 450-SET-INDICATORS
042400           THRU 450-EXIT.
042500
042600        PERFORM 500-DAYS-IN-STAY-LOGIC
042700           THRU 500-EXIT.
042800
042900        PERFORM 600-CAPTURE-RATE-COMPONENTS
043000           THRU 600-EXIT.
043100*
043200
043300        COMPUTE SUB2 = SUB2 + PRIOR-DAYS.
043400        COMPUTE TOTAL-DAYS = CURRENT-DAYS + PRIOR-DAYS.
043500
043600        PERFORM 6000-DAYS-LOOP-ROUTINE
043700           THRU 6000-EXIT VARYING
043800           VX1 FROM SUB2 BY 1 UNTIL
043900           VX1 > TOTAL-DAYS.
044000
044100*
044200        PERFORM 700-CALC-UNADJUSTED-RATE
044300           THRU 700-EXIT.
044400
044500        PERFORM 1000-APPLY-VBP-MULTIPLIER
044600           THRU 1000-EXIT.
044700
034400
044800**************YEARCHANGE 2021.0 *******************************
044900
045000
046600 400-EXIT.
046700     EXIT.
046800
046900 450-SET-INDICATORS.
047000
047100*-------------------------------------------------------*
047200
047300***************************************************************
047400*     PAYMENT RATE CALCULATION PROCCESS EFFECTIVE OCT.1, 2019
047500***************************************************************
047600
047700*-----------------------------------------------------*
047800*   AIDS-ADD-ON-IND ONLY APPLIES TO NURSING RATES     *
047900*------------------------------------------------------
048000*------------------------------------------------------
048100*   SET AIDS ADD-ON IND                               *
048200*            IF INDICATED BY PRIN DX CODE -OR-        *
048300*                                 OTHER DX CODES      *
048400*------------------------------------------------------
048500     IF 'B20   ' = SNF-PRIN-DIAG-CODE   OR
048600                   SNF-OTHER-DIAG-CODE2 OR
048700                   SNF-OTHER-DIAG-CODE3 OR
048800                   SNF-OTHER-DIAG-CODE4 OR
048900                   SNF-OTHER-DIAG-CODE5 OR
049000                   SNF-OTHER-DIAG-CODE6 OR
049100                   SNF-OTHER-DIAG-CODE7 OR
049200                   SNF-OTHER-DIAG-CODE8 OR
049300                   SNF-OTHER-DIAG-CODE9  OR
049400                   SNF-OTHER-DIAG-CODE10 OR
049500                   SNF-OTHER-DIAG-CODE11 OR
049600                   SNF-OTHER-DIAG-CODE12 OR
049700                   SNF-OTHER-DIAG-CODE13 OR
049800                   SNF-OTHER-DIAG-CODE14 OR
049900                   SNF-OTHER-DIAG-CODE15 OR
050000                   SNF-OTHER-DIAG-CODE16 OR
050100                   SNF-OTHER-DIAG-CODE17 OR
050200                   SNF-OTHER-DIAG-CODE18 OR
050300                   SNF-OTHER-DIAG-CODE19 OR
050400                   SNF-OTHER-DIAG-CODE20 OR
050500                   SNF-OTHER-DIAG-CODE21 OR
050600                   SNF-OTHER-DIAG-CODE22 OR
050700                   SNF-OTHER-DIAG-CODE23 OR
050800                   SNF-OTHER-DIAG-CODE24 OR
050900                   SNF-OTHER-DIAG-CODE25
051000*
051100         MOVE 'Y'          TO AIDS-ADD-ON-IND
051200     ELSE
051300         MOVE 'N'          TO AIDS-ADD-ON-IND
051400     END-IF.
051500
051600*-----------------------------------------------------*
051700*-----------------------------------------------------*
051800*   SNF-FED-BLEND =1 SET QRP IND TO Y                 *
051900*------------------------------------------------------
052000*------------------------------------------------------
052100     IF SNF-FED-BLEND = 1
052200         MOVE 'Y'          TO QRP-IND
052300     ELSE
052400         MOVE 'N'          TO QRP-IND
052500     END-IF.
052600
052700****--------------------------------------------------------------
052800*
052900 450-EXIT.    EXIT.
053000     EXIT.
053100
053200 500-DAYS-IN-STAY-LOGIC.
053300
053400
053500      MOVE SNF-PDPM-UNITS       TO CURRENT-DAYS.
053600      MOVE SNF-PDPM-PRIOR-DAYS  TO PRIOR-DAYS.
053700
053800*     IF CURRENT-DAYS > 100
053900*        MOVE '20'              TO SNF-RTC
054000*     END-IF.
054100
054200 500-EXIT.
054300     EXIT.
054400
054500
054600 600-CAPTURE-RATE-COMPONENTS.
054700
054800*-------------------------------------------------------*
054900*-- RATE COMPONENTS SELECTION DONE ONCE-----------------*
055000*-------------------------------------------------------*
055100*--  PRIMARY INDICATOR = REGION-IND   ------------------*
055200*-------------------------------------------------------*
055300
055400*-------------------------------------------------------*
055500*---------->>  HIPPS CHARACTER 1              <<--------*
055600*--------->>   PT & OT RATES                  <<--------*
055700*-------------------------------------------------------*
055800
055900      IF REGION-IND = 'U'
056000         PERFORM 2000-GET-URBAN-PT-OT-RATES
056100            THRU 2000-EXIT
056200      ELSE
056300         PERFORM 3000-GET-RURAL-PT-OT-RATES
056400            THRU 3000-EXIT
056500      END-IF.
056600
056700*-------------------------------------------------------*
056800*---------->>  HIPPS CHARACTER 2              <<--------*
056900*--------->>       SLP RATES                  <<--------*
057000*-------------------------------------------------------*
057100
057200      IF REGION-IND = 'U'
057300         PERFORM 2200-GET-URBAN-SLP-RATES
057400            THRU 2200-EXIT
057500      ELSE
057600         PERFORM 3200-GET-RURAL-SLP-RATES
057700            THRU 3200-EXIT
057800      END-IF.
057900
058000*-------------------------------------------------------*
058100*---------->>  HIPPS CHARACTER 3              <<--------*
058200*--------->>   NURSING RATES              <<--------*
058300*-------------------------------------------------------*
058400
058500      IF REGION-IND = 'U'
058600         PERFORM 2300-GET-URBAN-NUR-RATES
058700            THRU 2300-EXIT
058800      ELSE
058900         PERFORM 3300-GET-RURAL-NUR-RATES
059000            THRU 3300-EXIT
059100      END-IF.
059200
059300*-------------------------------------------------------*
059400*---------->>  HIPPS CHARACTER 4              <<--------*
059500*--------->>   NTA (NON-THERAPUTIC ANCILLARY)    -------*
059600*-------------------------------------------------------*
059700
059800      IF REGION-IND = 'U'
059900         PERFORM 2400-GET-URBAN-NTA-RATES
060000            THRU 2400-EXIT
060100      ELSE
060200         PERFORM 3400-GET-RURAL-NTA-RATES
060300            THRU 3400-EXIT
060400      END-IF.
060500
060600*-------------------------------------------------------*
060700*---------->>  LAST RATE COMPONENT (ALL HIPPS)<--------*
060800*--------->>   NON-CASE-MIXED                    -------*
060900*-------------------------------------------------------*
061000
061100      IF REGION-IND = 'U'
061200         PERFORM 2500-GET-URBAN-NCM-RATES
061300            THRU 2500-EXIT
061400      ELSE
061500         PERFORM 3500-GET-RURAL-NCM-RATES
061600            THRU 3500-EXIT
061700      END-IF.
061800
061900
062000 600-EXIT.
062100     EXIT.
062200
062300****************************************************************
062400**  THIS PARAGRAPH WILL CALCULATE THE TOTAL UNADJUSTED RATE   **
062500**  FOR THE NUMBER OF PDPM UNITS ON THE CLAIM.  IT SUMS THE   **
062600**  APPROPRIATE PT AND OT RATES AND MULTIPLIES IT BY THE      **
062700**  TOTAL NUMBER OF UTILIZATION DAYS FROM THE 6000 PARAGRAPH  **
062800**  TO GET THE PT/OT PORTION.  SIMILARLY, THE NTA RATE IS     **
062900**  MULTIPLIED BY THE NTA UTILIZATION DAYS FROM THE 6000      **
063000**  PARAGRAPH TO GET THE NTA PORTION.  THE APPROPRIATE NURSE  **
063100**  SLP AND NCM RATES ARE SUMMED AND MULTIPLIED BY THE PDPM   **
063200**  UNITS FROM THE CLAIM TO GET THE NURSE, SLP AND NCM        **
063300**  PORTION.  ALL 3 PORTIONS ARE ADDED TOGETHER TO GET THE    **
063400**  TOTAL CASE MIX PER DIEM.  THE WAGE INDEX, LABOR AND       **
063500**  NON-LABOR ADJUSTMENTS ARE APPLIED TO THIS AMOUNT TO GIVE  **
063600**  TOTAL ADJUSTED AMOUNT.                                    **
063700****************************************************************
063800
063900 700-CALC-UNADJUSTED-RATE.
064000
065400
046000****--------***-----------**
046000****--------*** PT-OT FEE **
046000****--------***-----------**
046000****--------*
045800****--------*STEP # 1
046000****--------*
064000
064100     COMPUTE WS-PT-OT-FEE ROUNDED =
064200             HIPPS-PT-RATE-COMP + HIPPS-OT-RATE-COMP.
064300
064300
065400
046000****--------***---------------**
046000****--------*** PT-OT PORTION **
046000****--------***---------------**
046000****--------*
045800****--------*STEP # 2
046000****--------*
064900
064400     COMPUTE WS-PT-OT-PORTION ROUNDED =
064500             WS-PT-OT-FEE * WS-PT-OT-UTIL.
064900
064600
065400
046000****--------***---------------**
046000****--------*** NTA PORTION    **
046000****--------***---------------**
046000****--------*
046000****--------*
045800****--------*STEP # 3
046000****--------*
064900
064700     COMPUTE WS-NTA-PORTION ROUNDED =
064800             HIPPS-NTA-RATE-COMP * WS-NTA-UTIL.
064900
064900
046000****        ***----------------------------**
046000****--------*** NURS SLP NCM NTA PORTION   **
046000****--------***----------------------------**
046000****--------*
046000****--------***----------------*
045800****--------***    STEP # 4    *
046000****--------***----------------*
064900
065000     COMPUTE WS-NURS-SLP-NCM-PORTION ROUNDED =
065100             (HIPPS-NURSE-RATE-COMP +
065200              HIPPS-SLP-RATE-COMP +
065300              HIPPS-NCM-RATE-COMP) * CURRENT-DAYS.
064900
064900
065400
046000****--------***------------------**
046000****--------*** CASEMIX PER DIEM **
046000****--------***------------------**
045800****--------*STEP # 5
045800****--------*
065900
065500     COMPUTE TOT-PDPM-CASEMIX-PERDIEM =
065600             (WS-PT-OT-PORTION +
065700              WS-NTA-PORTION +
065800              WS-NURS-SLP-NCM-PORTION).
065900
064600
046000****--------***----------------*
046000****--------*** LABOR PORTION  *
046000****--------***----------------*
046000****--------*
045800****--------*STEP # 6
064600
066000     COMPUTE LABOR-PORTION ROUNDED =
066100             (TOT-PDPM-CASEMIX-PERDIEM * PERCENT-2021-LABOR).
066200
064600
046000****--------***-----------------*
046000****--------*** LABOR ADJUSTED  *
046000****--------***-----------------*
045800****--------*STEP # 7
045800****--------*
066200
066300     COMPUTE LABOR-ADJUSTED ROUNDED =
066400             (LABOR-PORTION * AREA-WAGE-INDEX).
066200
066500
046000****--------***--------------------*
046000****--------*** NON LABOR PORTION  *
046000****--------***--------------------*
045800****--------*STEP # 8
066500
066600     COMPUTE NON-LABOR-PORTION ROUNDED =
066700             (TOT-PDPM-CASEMIX-PERDIEM * PERCENT-2021-NLABOR).
066500
066800
046000****--------***-----------------*
046000****--------*** LABOR ADJ RATE  *
046000****--------***-----------------*
045800****--------*STEP # 9
066800
066900     COMPUTE TOTAL-LABOR-ADJ-RATE ROUNDED =
067000             (LABOR-ADJUSTED + NON-LABOR-PORTION).
C45900
067100
066800
046000****--------***-------------------*
046000****--------*** TOT CALC PAYMENT  *
046000****--------***-------------------*
045800****--------*STEP # 10
045900
067200     COMPUTE TOTAL-CALC-PAYMENT-RATE ROUNDED =
067300             TOTAL-LABOR-ADJ-RATE.
045900
066800
067400
069800 700-EXIT.
069900     EXIT.
070000
070100 1000-APPLY-VBP-MULTIPLIER.
070200*
070300****------------------------------------------------------
070400*------->> VBP LOGIC PERFORMED ONCE <<------*
070500****------------------------------------------------------
070600*
064000
066800
046000****--------***-------------------*
046000****--------*** SNF PAYMENT RATE -*
046000****--------***-------------------*
045800****--------*STEP # 11
064000
070700     COMPUTE SNF-PAYMENT-RATE ROUNDED =
070800             VBP-MULTIPLIER *  TOTAL-CALC-PAYMENT-RATE.
064000
070900*
046000**-----------**---------------*
046000****--------*** VBP PAY DIFF -*
046000****--------***---------------*
045800****--------*STEP # 12
064000
071000     COMPUTE VBP-PAY-DIFF ROUNDED =
071100             SNF-PAYMENT-RATE - TOTAL-CALC-PAYMENT-RATE.
071200
071200
071300 1000-EXIT.
071400     EXIT.
071500*
034400
053100
071600
071700 2000-GET-URBAN-PT-OT-RATES.
071800*-------------------------------------------------------*
071900*-------------------------------------------------------*
072000* >>>>> DETERMINE WHICH 2 OF 4 RATES TO ASSIGN
072100* >>>>> BASED ON QRP INDICATOR
072200* >>>>> PDPM-RATE-PT-U   &  PDPM-RATE-OT-U
072300* >>>>>                 -OR-
072400* >>>>> PDPM-QRATE-PT-U  &  PDPM-QRATE-OT-U
072500*-------------------------------------------------------*
072600*
072700        SET PDPM-PTOT-IDX-U TO 1.
072800
072900        SEARCH PDPM-PTOT-DATA2-U VARYING PDPM-PTOT-IDX-U
073000           AT END
073100              MOVE '20'       TO SNF-RTC
073200           GO TO 2000-EXIT
073300           WHEN PDPM-PTOT-GROUP-U (PDPM-PTOT-IDX-U) = HIPPS-CHAR-1
073400*
073500              PERFORM 2010-PICK-URBAN-PT-OT
073600                 THRU 2010-EXIT
073700      END-SEARCH.
073800*
073900 2000-EXIT.
074000      EXIT.
074100
074200 2010-PICK-URBAN-PT-OT.
074300*
074400****----------------------------------------------
074500*
074600      IF QRP-IND = 'Y'
074700          MOVE PDPM-QRATE-PT-U (PDPM-PTOT-IDX-U)
074800                               TO HIPPS-PT-RATE-COMP
074900          MOVE PDPM-QRATE-OT-U (PDPM-PTOT-IDX-U)
075000                               TO HIPPS-OT-RATE-COMP
075100      ELSE
075200          MOVE PDPM-RATE-PT-U (PDPM-PTOT-IDX-U)
075300                               TO HIPPS-PT-RATE-COMP
075400          MOVE PDPM-RATE-OT-U (PDPM-PTOT-IDX-U)
075500                               TO HIPPS-OT-RATE-COMP
075600      END-IF.
076100*
076200 2010-EXIT.
076300      EXIT.
076400
076500 2200-GET-URBAN-SLP-RATES.
076600*  SLP
076700*--  SECONDARY INDICATOR = QRP-IND   ----------------*
076800
076900****----------------------------------------------
077000* >>>>> DETERMINE WHICH OF 2 RATES TO ASSIGN
077100* >>>>> BASED ON QRP INDICATOR
077200* >>>>> PDPM-RATE-SLP-U  -OR-  PDPM-QRATE-SLP-U
077300****----------------------------------------------
077400        SET PDPM-SLP-IDX-U TO 1.
077500
077600        SEARCH PDPM-SLP-DATA2-U VARYING PDPM-SLP-IDX-U
077700           AT END
077800              MOVE '20'       TO SNF-RTC
077900           GO TO 2200-EXIT
078000            WHEN PDPM-SLP-GROUP-U (PDPM-SLP-IDX-U) = HIPPS-CHAR-2
078100*
078200              PERFORM 2210-PICK-URBAN-SLP
078300                 THRU 2210-EXIT
078400*
078500      END-SEARCH.
078600*
078700 2200-EXIT.
078800      EXIT.
078900
079000 2210-PICK-URBAN-SLP.
079100
079200      IF QRP-IND = 'Y'
079300          MOVE PDPM-QRATE-SLP-U (PDPM-SLP-IDX-U)
079400                               TO HIPPS-SLP-RATE-COMP
079500      ELSE
079600          MOVE PDPM-RATE-SLP-U (PDPM-SLP-IDX-U)
079700                               TO HIPPS-SLP-RATE-COMP
079800      END-IF.
079900
080200 2210-EXIT.
080300      EXIT.
080400
080500
080600 2300-GET-URBAN-NUR-RATES.
080700
080800*----------------------------------------------------*
080900*--  SECONDARY INDICATOR = QRP-IND   ----------------*
081000*----------------------------------------------------*
081100*
081200*----------------------------------------------------*
081300*--  TERTIARY INDICATOR = AIDS-IND   ----------------*
081400*----------------------------------------------------*
081500* >>>>> DETERMINE WHICH OF 4 RATES TO ASSIGN
081600* >>>>> BASED ON QRP INDICATOR
081700* >>>>> BASED ON QRP INDICATOR  & AIDS-IN OR COMBO
081800* >>>>> PDPM-RATE-NUR-U     -OR-
081900* >>>>> PDPM-ARATE-NUR-U    -OR-
082000*
082100*----------------------------------------------------*
082200*--  OR COMBO INDICATOR = QRP-IND & AIDS-IND   ------*
082300*----------------------------------------------------*
082400*
082500* >>>>> PDPM-QRATE-NUR-U    -OR-
082600*
082700*----------------------------------------------------*
082800*--  TERTIARY INDICATOR = AIDS-IND   ----------------*
082900*----------------------------------------------------*
083000* >>>>> PDPM-AQRATE-NUR-U
083100* >>>>>
083200        SET PDPM-NURS-IDX-U TO 1.
083300
083400        SEARCH PDPM-NURS-DATA2-U VARYING PDPM-NURS-IDX-U
083500           AT END
083600              MOVE '20'       TO SNF-RTC
083700           GO TO 2300-EXIT
083800           WHEN PDPM-NURS-GROUP-U (PDPM-NURS-IDX-U) = HIPPS-CHAR-3
083900
084000              PERFORM 2310-PICK-URBAN-NURS
084100                 THRU 2310-EXIT
084200
084300        END-SEARCH.
084400
084800 2300-EXIT.
084900      EXIT.
085000
085100 2310-PICK-URBAN-NURS.
085200
085300      IF QRP-IND = 'Y'
085400          MOVE PDPM-QRATE-NUR-U (PDPM-NURS-IDX-U)
085500                               TO HIPPS-NURSE-RATE-COMP.
085600
085700      IF QRP-IND = 'Y' AND AIDS-ADD-ON-IND = 'Y'
085800          MOVE PDPM-AQ-RATE-NUR-U (PDPM-NURS-IDX-U)
085900                               TO HIPPS-NURSE-RATE-COMP
086000          GO TO 2310-EXIT.
086100
086200      IF QRP-IND = 'N'
086300          MOVE PDPM-RATE-NUR-U (PDPM-NURS-IDX-U)
086400                               TO HIPPS-NURSE-RATE-COMP.
086500
086600      IF QRP-IND = 'N' AND AIDS-ADD-ON-IND = 'Y'
086700          MOVE PDPM-ARATE-NUR-U (PDPM-NURS-IDX-U)
086800                               TO HIPPS-NURSE-RATE-COMP
086900          GO TO 2310-EXIT.
087000
087100 2310-EXIT.
087200      EXIT.
087300
087400 2400-GET-URBAN-NTA-RATES.
087500* >>>>>
087600* >>>>> DETERMINE WHICH OF 2 RATES TO ASSIGN
087700* >>>>> BASED ON QRP INDICATOR
087800* >>>>> PDPM-RATE-NTA-U  -OR-  PDPM-QRATE-NTA-U
087900* >>>>>
088000        SET PDPM-NTA-IDX-U TO 1.
088100
088200        IF AIDS-ADD-ON-IND = "Y" AND NTA-AIDS-ADD-ON-A
088300           MOVE "A" TO HIPPS-CHAR-4
088400        ELSE
088500            IF AIDS-ADD-ON-IND = "Y" AND NTA-AIDS-ADD-ON-B
088600               MOVE "B" TO HIPPS-CHAR-4
088400            ELSE
088500                IF AIDS-ADD-ON-IND = "Y" AND NTA-AIDS-ADD-ON-C
088600                   MOVE "C" TO HIPPS-CHAR-4
088700        END-IF.
088800
088900        SEARCH PDPM-NTA-DATA2-U VARYING PDPM-NTA-IDX-U
089000           AT END
089100              MOVE '20'       TO SNF-RTC
089200           GO TO 2400-EXIT
089300            WHEN PDPM-NTA-GROUP-U (PDPM-NTA-IDX-U) = HIPPS-CHAR-4
089400
089500              PERFORM 2410-PICK-URBAN-NTA
089600                 THRU 2410-EXIT
089700
089800        END-SEARCH.
089900
090000 2400-EXIT.
090100      EXIT.
090200
090300 2410-PICK-URBAN-NTA.
090400
090500      IF QRP-IND = 'Y'
090600          MOVE PDPM-QRATE-NTA-U (PDPM-NTA-IDX-U)
090700                               TO HIPPS-NTA-RATE-COMP
090800      ELSE
090900          MOVE PDPM-RATE-NTA-U (PDPM-NTA-IDX-U)
091000                               TO HIPPS-NTA-RATE-COMP
091100      END-IF.
091200
091500 2410-EXIT.
091600      EXIT.
091700
091800 2500-GET-URBAN-NCM-RATES.
091900******--------------------------------------------------
092000* >>>>> DETERMINE WHICH OF 2 RATES TO ASSIGN
092100* >>>>> URBAN-NCM-COMP-2021  -OR-  URBAN-QRP-NCM-COMP-2021
092200******--------------------------------------------
092300
092400      IF QRP-IND = 'Y'
092500          MOVE URBAN-QRP-NCM-COMP-2021
092600                               TO HIPPS-NCM-RATE-COMP
092700      ELSE
092800          MOVE URBAN-NCM-COMP-2021
092900                               TO HIPPS-NCM-RATE-COMP
093000      END-IF.
093300*
093400 2500-EXIT.
093500      EXIT.
093600
093700
093800 3000-GET-RURAL-PT-OT-RATES.
093900******---------------------------------------------
094000* >>>>> DETERMINE WHICH 2 OF 4 RATES TO ASSIGN
094100* >>>>> BASED ON QRP INDICATOR
094200* >>>>> PDPM-RATE-PT-R   &  PDPM-RATE-OT-R
094300* >>>>>                 -OR-
094400* >>>>> PDPM-QRATE-PT-R  &  PDPM-QRATE-OT-R
094500******---------------------------------------------
094600*-------------------------------------------------------*
094700*
094800        SET PDPM-PTOT-IDX-R TO 1.
094900
095000        SEARCH PDPM-PTOT-DATA2-R VARYING PDPM-PTOT-IDX-R
095100           AT END
095200              MOVE '20'       TO SNF-RTC
095300           GO TO 3000-EXIT
095400           WHEN PDPM-PTOT-GROUP-R (PDPM-PTOT-IDX-R) = HIPPS-CHAR-1
095500*
095600              PERFORM 3010-PICK-RURAL-PT-OT
095700                 THRU 3010-EXIT
095800      END-SEARCH.
095900*
096000
096100 3000-EXIT.
096200     EXIT.
096300
096400 3010-PICK-RURAL-PT-OT.
096500****----------------------------------------------
096600*
096700
096800      IF QRP-IND = 'Y'
096900          MOVE PDPM-QRATE-PT-R (PDPM-PTOT-IDX-R)
097000                               TO HIPPS-PT-RATE-COMP
097100          MOVE PDPM-QRATE-OT-R (PDPM-PTOT-IDX-R)
097200                               TO HIPPS-OT-RATE-COMP
097300      ELSE
097400          MOVE PDPM-RATE-PT-R (PDPM-PTOT-IDX-R)
097500                               TO HIPPS-PT-RATE-COMP
097600          MOVE PDPM-RATE-OT-R (PDPM-PTOT-IDX-R)
097700                               TO HIPPS-OT-RATE-COMP
097800      END-IF.
098300*
098400
098500 3010-EXIT.
098600      EXIT.
098700
098800
098900 3200-GET-RURAL-SLP-RATES.
099000****----------------------------------------------
099100* >>>>> DETERMINE WHICH OF 2 RATES TO ASSIGN
099200* >>>>> PDPM-RATE-SLP-R  -OR-  PDPM-QRATE-SLP-R
099300****----------------------------------------------
099400        SET PDPM-SLP-IDX-R TO 1.
099500
099600        SEARCH PDPM-SLP-DATA2-R VARYING PDPM-SLP-IDX-R
099700           AT END
099800              MOVE '20'       TO SNF-RTC
099900           GO TO 3200-EXIT
100000            WHEN PDPM-SLP-GROUP-R (PDPM-SLP-IDX-R) = HIPPS-CHAR-2
100100*
100200              PERFORM 3210-PICK-RURAL-SLP
100300                 THRU 3210-EXIT
100400*
100500        END-SEARCH.
100600*
100700 3200-EXIT.
100800      EXIT.
100900
101000
101100 3210-PICK-RURAL-SLP.
101200
101300      IF QRP-IND = 'Y'
101400          MOVE PDPM-QRATE-SLP-R  (PDPM-SLP-IDX-R)
101500                               TO HIPPS-SLP-RATE-COMP
101600      ELSE
101700          MOVE PDPM-RATE-SLP-R (PDPM-SLP-IDX-R)
101800                               TO HIPPS-SLP-RATE-COMP
101900      END-IF.
102200*
102300 3210-EXIT.
102400      EXIT.
102500
102600
102700 3300-GET-RURAL-NUR-RATES.
102800
102900*******------------------------------------------------
103000* >>>>> DETERMINE WHICH OF 4 RATES TO ASSIGN
103100* >>>>> BASED ON QRP INDICATOR
103200* >>>>> BASED ON QRP INDICATOR  & AIDS-IN OR COMBO
103300* >>>>> PDPM-RATE-NUR-R     -OR-
103400* >>>>> PDPM-ARATE-NUR-R    -OR-
103500* >>>>> PDPM-QRATE-NUR-R    -OR-
103600* >>>>> PDPM-AQRATE-NUR-R
103700*******------------------------------------------------
103800        SET PDPM-NURS-IDX-R TO 1.
103900
104000        SEARCH PDPM-NURS-DATA2-R VARYING PDPM-NURS-IDX-R
104100           AT END
104200              MOVE '20'       TO SNF-RTC
104300           GO TO 3300-EXIT
104400           WHEN PDPM-NURS-GROUP-R (PDPM-NURS-IDX-R) = HIPPS-CHAR-3
104500
104600              PERFORM 3310-PICK-RURAL-NURS
104700                 THRU 3310-EXIT
104800
104900        END-SEARCH.
105000
105100
105200 3300-EXIT.
105300      EXIT.
105400
105500 3310-PICK-RURAL-NURS.
105600
105700      IF QRP-IND = 'Y'
105800          MOVE PDPM-QRATE-NURS-R (PDPM-NURS-IDX-R)
105900                               TO HIPPS-NURSE-RATE-COMP.
106000
106100      IF QRP-IND = 'Y' AND AIDS-ADD-ON-IND = 'Y'
106200          MOVE PDPM-AQRATE-NURS-R (PDPM-NURS-IDX-R)
106300                               TO HIPPS-NURSE-RATE-COMP
106400          GO TO 3310-EXIT.
106500
106600      IF QRP-IND = 'N'
106700          MOVE PDPM-RATE-NURS-R (PDPM-NURS-IDX-R)
106800                               TO HIPPS-NURSE-RATE-COMP.
106900
107000      IF QRP-IND = 'N' AND AIDS-ADD-ON-IND = 'Y'
107100          MOVE PDPM-ARATE-NURS-R (PDPM-NURS-IDX-R)
107200                               TO HIPPS-NURSE-RATE-COMP
107300          GO TO 3310-EXIT.
107400
107700 3310-EXIT.
107800      EXIT.
107900
108000 3400-GET-RURAL-NTA-RATES.
108100
108200*******-----------------------------------------------
108300* >>>>> DETERMINE WHICH OF 2 RATES TO ASSIGN
108400* >>>>> BASED ON QRP INDICATOR
108500* >>>>> PDPM-RATE-NTA-R  -OR-  PDPM-QRATE-NTA-R
108600*******-----------------------------------------------
108700*
108800*
108900        SET PDPM-NTA-IDX-R TO 1.
109000
109100        IF AIDS-ADD-ON-IND = "Y" AND NTA-AIDS-ADD-ON-A
109200           MOVE "A" TO HIPPS-CHAR-4
109300        ELSE
109400        IF AIDS-ADD-ON-IND = "Y" AND NTA-AIDS-ADD-ON-B
109500           MOVE "B" TO HIPPS-CHAR-4
088400            ELSE
088500                IF AIDS-ADD-ON-IND = "Y" AND NTA-AIDS-ADD-ON-C
088600                   MOVE "C" TO HIPPS-CHAR-4
109600        END-IF.
109700
109800        SEARCH PDPM-NTA-DATA2-R VARYING PDPM-NTA-IDX-R
109900           AT END
110000              MOVE '20'       TO SNF-RTC
110100           GO TO 3400-EXIT
110200            WHEN PDPM-NTA-GROUP-R (PDPM-NTA-IDX-R) = HIPPS-CHAR-4
110300*
110400              PERFORM 3410-PICK-RURAL-NTA
110500                 THRU 3410-EXIT
110600      END-SEARCH.
110700*
110800 3400-EXIT.
110900      EXIT.
111000
111100*
111200 3410-PICK-RURAL-NTA.
111300
111400      IF QRP-IND = 'Y'
111500          MOVE PDPM-QRATE-NTA-R (PDPM-NTA-IDX-R)
111600                               TO HIPPS-NTA-RATE-COMP
111700      ELSE
111800          MOVE PDPM-RATE-NTA-R (PDPM-NTA-IDX-R)
111900                               TO HIPPS-NTA-RATE-COMP
112000      END-IF.
112300*
112400
112500 3410-EXIT.
112600      EXIT.
112700
112800 3500-GET-RURAL-NCM-RATES.
112900* >>>>>
113000* >>>>> DETERMINE WHICH OF 2 RATES TO ASSIGN
113100* >>>>> BASED ON QRP INDICATOR
113200* >>>>> RURAL-NCM-COMP-2021  -OR-  RURAL-QRP-NCM-COMP-2021
113300* >>>>>
113400
113500      IF QRP-IND = 'Y'
113600          MOVE RURAL-QRP-NCM-COMP-2021
113700                               TO HIPPS-NCM-RATE-COMP
113800      ELSE
113900          MOVE RURAL-NCM-COMP-2021
114000                               TO HIPPS-NCM-RATE-COMP
114100      END-IF.
114400*
114500 3500-EXIT.
114600      EXIT.
114700*******-----------------------------------------------
114800*
114900*******-----------------------------------------------
115000  6000-DAYS-LOOP-ROUTINE.
115100
115200     COMPUTE WS-PT-OT-UTIL ROUNDED =
115300             WS-PT-OT-UTIL + VPD-PT-OT-FACT (VX1).
115400
115500     COMPUTE WS-NTA-UTIL ROUNDED =
115600             WS-NTA-UTIL + VPD-NTA-FACT (VX1).
115700
115800 6000-EXIT.
115900      EXIT.
