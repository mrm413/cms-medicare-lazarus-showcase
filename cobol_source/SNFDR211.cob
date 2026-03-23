000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID.          SNFDR211.
000300*AUTHOR.                 CMS.
000400*
000500******************************************************************
000600*REMARKS.
000700******************************************************************
000800*REMARKS. (CENTERS FOR MEDICARE AND MEDICAID SERVICES)
000900***         - NATIONAL SNF PRICER EFFECTIVE OCT 1, 2020
001000***         - SNF PRICER REFERS TO A PROGRAM WHICH WILL
001100***           CALCULATE THE MEDICARE RATE UPON WHICH THE
001200***           PDPM SNF PPS PAYMENT IS MADE. PRICER USES THE
001300***           HIPPS CODE, REGION IND & AIDS ADD-ON-IND
001400***           TO CALCULATE THE HCPPS RATES.
001500***--------------------------------------------------------****
001600***--------------------------------------------------------****
001700*     SNFDR211   EFFECTIVE OCT 1, 2020
001800*         ****-------------------------------------------****
001900*       -- >>                                          << --
002000*       -- >>    ** PROD ** VERSION                    << --
002100*       -- >>                                          << --
002200*       -- >>  UPDATED LOGIC TO FIX SPECIAL WAGE INDEX << --
002300*       -- >>  ERROR - 11/13/2020                      << --
001500***--------------------------------------------------------****
001600***--------------------------------------------------------****
001700*     SNFDR210   EFFECTIVE OCT 1, 2020
001800*         ****-------------------------------------------****
001900*       -- >>                                          << --
002000*       -- >>    ** PROD ** VERSION                    << --
002100*       -- >>                                          << --
002200*       -- >>  SUPP WAGE IND DATA ADDED TO I-O RECORD  << --
002300*       -- >>       LOGIC CHANGES AS OF 08/10/2020     << --
002400*         ****-------------------------------------------****
002500*                USE CBSA FILE WITH FY 2021 VALUES WITH
002600*         ****-------------------------------------------****
002700*                SNF DRIVER - SNFDR210
002800*                CALL ** PROD ** PRICER MODULE, SNFPR210
002900*         ****-------------------------------------------****
003000*         ****-------------------------------------------****
003100*                SNF PRICER - SNFPR210
003200*                USE PAYMENT RATES FOR FY2021
003300*****------------------------------------------------------****
003400***--------------------------------------------------------****
003500*     SNFDR21B   EFFECTIVE OCT 1, 2020
003600*         ****-------------------------------------------****
003700*       -- >>                                          << --
003800*       -- >>    ** BETA ** VERSION FOR TESTING ONLY   << --
003900*       -- >>                                          << --
004000*       -- >>  SUPP WAGE IND DATA ADDED TO I-O RECORD  << --
004100*       -- >>    NO LOGIC CHANGES AS OF 6/5/2020       << --
004200*         ****-------------------------------------------****
004300*                USE CBSA FILE WITH FY 2020 VALUES WITH
004400*                DUPLICATE ENTRIES FOR FY 2021.B
004500*         ****-------------------------------------------****
004600*                SNF DRIVER - SNFDR21B
004700*                CALL ** BETA ** PRICER MODULE, SNFPR21B
004800*         ****-------------------------------------------****
004900*                SNF PRICER - SNFPR21B
005000*         ****-------------------------------------------****
005100*                SNF PRICER - SNFPR21B
005200*                USE PAYMENT RATES FOR FY2020
005300***--------------------------------------------------------****
005350***--------------------------------------------------------****
005400*     SNFDR205   SNF PRICER - SNFPR205
005500*                REVISE REMAPPING OF NTA WHEN AIDS ADD-ON IND
005600*                IS SET TO 'Y'. 'B20' = PRINCIPLE DX CODE.
005700***--------------------------------------------------------****
005800***--------------------------------------------------------****
005900*     SNFDR204   EFFECTIVE OCT 1, 2019
006000*                REVISE HIPPS VALIDITY CHECK TO PROCESS THE
006100*                DEFAULT-HIPPS-CODE = 'ZZZZZ'
006200***--------------------------------------------------------****
006300***--------------------------------------------------------****
006400*     SNFDR202   EFFECTIVE OCT 1, 2019
006500*                RETURN CODES RTC=80  SNF-PDPM-UNITS = ZERO AND
006600*                RTC=90 INVALID HIPPS CODE WERE REPLACED WITH
006700*                RTC=20 INVALID RATE COMPONENT
006800***--------------------------------------------------------****
006900***--------------------------------------------------------****
007000*     SNFDR200   EFFECTIVE OCT 1, 2019
007100*                USE CBSA FILE FOR FY2020
007200*                SNF DRIVER - SNFDR200
007300*                PDPM SCREENING OF INPUT
007400*                RETURN ERROR RTC IF INPUT HAS ERRORS
007500*
007600***--------------------------------------------------------****
007700***--------------------------------------------------------****
007800*     SNFDR20B   EFFECTIVE OCT 1, 2019
007900*                BETA VERSION FOR FY2020 USE FOR TESTING ONLY
008000*                USE CBSA FILE WITH FY 2019 VALUES WITH
008100*                DUPLICATE ENTRIES FOR FY 2020
008200*                SNF DRIVER - SNFDR20B
008300*                USE PAYMENT RATES FOR FY2020
008400*                VARIABLE PER DIEM LOGIC ADDED
008500*                PDPM PAYMENT CODING
008600*                RETURN ERROR RTC IF INPUT HAS ERRORS
008700***--------------------------------------------------------****
008800 DATE-COMPILED.
008900 ENVIRONMENT DIVISION.
009000
009100 CONFIGURATION                   SECTION.
009200 SOURCE-COMPUTER.                IBM-370.
009300 OBJECT-COMPUTER.                IBM-370.
009400
009500 INPUT-OUTPUT SECTION.
009600 FILE-CONTROL.
009700 DATA DIVISION.
009800 FILE SECTION.
009900
010000 WORKING-STORAGE SECTION.
010100 77  W-STORAGE-REF               PIC X(49)  VALUE
010200     'SNF D R I V E R   - W O R K I N G   S T O R A G E'.
010300 01  SNFDR-VERSION               PIC X(09)     VALUE 'SNFDR21.0'.
010400 01  SNFPR210                    PIC X(08)     VALUE 'SNFPR210'.
010410 01  SNFPR205                    PIC X(08)     VALUE 'SNFPR205'.
010500 01  WS-WI-PCT-DECREASE-FY2021   PIC S9(01)V9(02) VALUE -0.05.
010600 01  WS-WI-PCT-ADJ-FY2021        PIC 9(01)V9(02)  VALUE 0.95.
010700 01  HOLD-SNF-CBSA.
010800     05  HOLD-SNF-CBSA-1ST       PIC XXX    VALUE SPACES.
010900     05  HOLD-SNF-CBSA-2ND       PIC XX     VALUE SPACES.
011000
011300
011400*******************************************************
011500*    PASSED TO SNFPR PROGRAM CLAIMS                   *
011600*         FOR CLAIMS ON OR AFTER  10/01/2005          *
011700*******************************************************
011800 01  CBSA-WAGE-INDEX-RECORD.
011900     02  CBSA-WIR-CBSA         PIC X(05).
012000     02  CBSA-WIR-EFFDATE      PIC X(08).
012100     02  CBSA-WIR-AREA-WAGEIND PIC 9(02)V9(04).
012200
012300 LINKAGE SECTION.
012400
012500*-------------------------------------------------------------*
012600*     SNF300P  COPYBOOK CONTAINS THE PAYMENT RATES            *
012700*   IN VARIABLE FORMAT TO COMPLETE THE SNF PRICING            *
012800*     << ONLY AVAILABLE FROM FY2016 FORWARD >>                *
012900* NATIONAL SNF RECORD FORMAT PASSED TO SNFPR PROGRAM          *
013000*          (PRIOR YEAR RATES ARE HARD CODED)                  *
013100*-------------------------------------------------------------*
013200*
013300 COPY SNF300P.
013400
013500
013600
013700*******************************************************
013800*    RETURNED BY SNFPR PROGRAM                        *
013900*******************************************************
014000
014100 01  HOLD-VARIABLES.
014200     02  HOLD-VAR-DATA.
014300         05  REGION-IND        PIC X.
014400         05  QRP-IND           PIC X.
014500         05  AIDS-ADD-ON-IND   PIC X.
014600         05  AREA-WAGE-INDEX   PIC 9(01)V9(04).
014700         05  IP-RATE           PIC 9(03)V9(02).
014800         05  GS-RATE           PIC 9(02)V9(02).
014900     02  SNFPR-VERSION         PIC X(09).
015000
015100 01  CBSA-WI-TABLE.
015200     05  T-CBSA-DATA        OCCURS 8000
015300                           INDEXED BY MA1 MA2 MA3.
015400         10  T-CBSA            PIC X(05).
015500         10  T-CBSA-EFFDATE    PIC X(08).
015600         10  T-CBSA-WAGEIND    PIC 9(02)V9(04).
015700
015800 PROCEDURE  DIVISION USING SNF-DATA
015900                           HOLD-VARIABLES
016000                           CBSA-WI-TABLE.
016100
016200 0000-MAINLINE  SECTION.
016300
016400     PERFORM 0100-PROCESS-RECORDS
016500        THRU 0100-EXIT.
016600
016700     GOBACK.
016800
016900
017000 0100-PROCESS-RECORDS.
017100
017200     MOVE ALL '0'              TO SNF-PAY-RTC
017300                                  CBSA-WAGE-INDEX-RECORD
017400                                  HOLD-VAR-DATA.
017500
017600
017700*******************************************************
017800*    MSA-RELATED DATE EDIT - LEGACY                   *
017900*******************************************************
018000
018100     IF SNF-THRU-DATE < 19980701
018200        MOVE '40'              TO SNF-RTC
018300        GO TO 0100-EXIT.
018400
018500     MOVE SNF-CBSA             TO HOLD-SNF-CBSA.
018600
018700     IF SNF-CBSA-RURAL
018800        MOVE SPACES            TO HOLD-SNF-CBSA-1ST
018900     END-IF.
019000
019100
019200*******************************************************
019300*          SET REGION-IND TO RURAL OR URBAN           *
019400*******************************************************
019500
019700     IF SNF-CBSA-RURAL
019800        MOVE 'R'               TO REGION-IND
019900     ELSE
020000        MOVE 'U'               TO REGION-IND
020100     END-IF.
020200
020300
020400*******************************************************
020500*                 GET CBSA WAGE INDEX                 *
020600*******************************************************
020700
020800     PERFORM 1900-SELECT-CBSA-WAGE-INDEX
020900        THRU 1900-EXIT.
021000
021100     IF SNF-RTC NOT = '00'
021200        GO TO 0100-EXIT.
021300
021400
021500*******************************************************
021600*      CALL PRICING MODULE BASED ON THROUGH DATE      *
021700*******************************************************
021800
021900*-----------------------------------------------------*
022000*    PRICE FY 2021 CLAIMS                             *
022100*-----------------------------------------------------*
022200     IF SNF-THRU-DATE > 20200930
022300        CALL SNFPR210 USING SNF-DATA
022400                            HOLD-VARIABLES
022500                            CBSA-WAGE-INDEX-RECORD
022600     END-IF.
022700
022800*-----------------------------------------------------*
022900*    PRICE FY 2020 CLAIMS                             *
023000*-----------------------------------------------------*
023100     IF SNF-THRU-DATE > 20190930 AND
023200        SNF-THRU-DATE < 20201001
023300        CALL SNFPR205 USING SNF-DATA
023400                            HOLD-VARIABLES
023500                            CBSA-WAGE-INDEX-RECORD
023600     END-IF.
023700
023800 0100-EXIT.  EXIT.
023900
024000
024100
024200
024300*******************************************************
024400*           SELECT WAGE INDEX TO BE USED              *
024500*******************************************************
024600
024700 1900-SELECT-CBSA-WAGE-INDEX.
024800*-----------------------------------------------------*
024900*     VALIDATE SPECIAL WAGE INDEX CRITERIA            *
025000*-----------------------------------------------------*
025100
025200     IF  SNF-SPEC-WI-IND = 'Y'
025300         MOVE '1'              TO SNF-SPEC-WI-IND.
025400
025500     IF  SNF-SPEC-WI-IND = '1'
025600         AND SNF-SPEC-WI-X NOT NUMERIC
025700         MOVE '30'             TO SNF-RTC
025800         GO TO 1900-EXIT.
025900
026000*-----------------------------------------------------*
026100*     IF SPECIAL WAGE INDEX CRITERIA ARE GOOD         *
026200*             APPLY SPECIAL WAGE INDEX                *
026300*          "IN LIEU" OF CBSA WAGE INDEX               *
026400*-----------------------------------------------------*
026500
026600     IF  SNF-SPEC-WI-IND = '1' AND
026700         SNF-SPEC-WI-X NUMERIC AND
026800         SNF-SPEC-WI-X > 0
026900         MOVE SNF-CBSA         TO CBSA-WIR-CBSA
027000         MOVE '20051001'       TO CBSA-WIR-EFFDATE
027100         MOVE SNF-SPEC-WI      TO CBSA-WIR-AREA-WAGEIND
027200         GO TO 1900-EXIT.
027300
027400
027500*** --------------------------------------------------------------
027600*** SEARCH THE CBSA WAGE INDEX FILE FOR THE CLAIM'S CBSA
027700*** --------------------------------------------------------------
027800     PERFORM 2000-READ-CBSA-FILE
027900        THRU 2000-EXIT.
028000
028100     IF SNF-RTC NOT = '00'
028200         GO TO 0100-EXIT.
028300
028400
028500*** --------------------------------------------------------------
028600*** SEARCH THE CBSA WAGE INDEX TABLE FOR THE WAGE INDEX EFFECTIVE
028700*** FOR THE CLAIM THRU DATE
028800*** --------------------------------------------------------------
028900     PERFORM 2010-SELECT-CURRENT-WAGE-INDEX
029000        THRU 2010-EXIT
029100             VARYING MA2 FROM MA1 BY 1
029200             UNTIL T-CBSA (MA2) NOT = HOLD-SNF-CBSA.
029300
029400     IF  CBSA-WIR-AREA-WAGEIND NOT > 0
029500         MOVE '30' TO SNF-RTC
029600         GO TO 1900-EXIT
029700     END-IF.
029800
029900
030000*** --------------------------------------------------------------
030100*** SUPPLEMENTAL WAGE INDEX VALIDATION CHECK FOR FY 2021 AND LATER
030200*** IF THE INDICATOR IS '1' AND THE SUPP WI IS 0 OR SPACES, RTC=30
030300*** --------------------------------------------------------------
030400     IF SNF-THRU-DATE > 20200930   AND
030500        SNF-SUPP-WI-IND-PRIOR-YEAR AND
030600        (SNF-SUPP-WI NOT > 0 OR SNF-SUPP-WI NOT NUMERIC)
030700           MOVE '30'    TO SNF-RTC
030800           GO TO 1900-EXIT
030900     END-IF.
031000
031100
031200*** --------------------------------------------------------------
031300*** APPLY 5% CAP ON WAGE INDEX DECREASES STARTING FY 2021
031400*** --------------------------------------------------------------
031500     IF SNF-THRU-DATE > 20200930   AND
031600        SNF-SUPP-WI-IND-PRIOR-YEAR AND
031700        SNF-SUPP-WI > 0
031800           PERFORM 2020-CAP-WAGE-INDEX-DECREASE
031900              THRU 2020-EXIT
032000     END-IF.
032100
032200
032300 1900-EXIT.
032400     EXIT.
032500
032600
032700******************************************************************
032800* SEARCH FOR THE CLAIM CBSA IN THE CBSA WAGE INDEX TABLE         *
032900******************************************************************
033000 2000-READ-CBSA-FILE.
033100     SET MA1                   TO 1.
033200
033300     SEARCH T-CBSA-DATA VARYING MA1
033400            AT END
033500               MOVE '30'       TO SNF-RTC
033600               GO TO 2000-EXIT
033700            WHEN T-CBSA (MA1) = HOLD-SNF-CBSA
033800               SET MA2         TO MA1.
033900
034000 2000-EXIT.
034100     EXIT.
034200
034300
034400******************************************************************
034500* SELECT THE WAGE INDEX EFFECTIVE FOR THE CLAIM THRU DATE        *
034600* FROM THE CBSA WAGE INDEX TABLE                                 *
034700******************************************************************
034800 2010-SELECT-CURRENT-WAGE-INDEX.
034900
035000     IF SNF-THRU-DATE NOT < T-CBSA-EFFDATE (MA2)
035100        MOVE T-CBSA         (MA2)
035200                               TO CBSA-WIR-CBSA
035300        MOVE T-CBSA-EFFDATE (MA2)
035400                               TO CBSA-WIR-EFFDATE
035500        MOVE T-CBSA-WAGEIND (MA2)
035600                               TO CBSA-WIR-AREA-WAGEIND.
035700
035800 2010-EXIT.
035900     EXIT.
036000
036100
036200******************************************************************
036300* APPLY 5% CAP ON WAGE INDEX DECREASES                           *
036400******************************************************************
036500 2020-CAP-WAGE-INDEX-DECREASE.
036600
036700*** --------------------------------------------------------------
036800*** IF WAGE INDEX DECREASED MORE THAN 5%, WI = 95% 0F PRIOR YR WI
036900*** (PRIOR YEAR WI IS THE SUPPLEMENTAL WI)
037000*** --------------------------------------------------------------
037100     IF ((CBSA-WIR-AREA-WAGEIND - SNF-SUPP-WI) / SNF-SUPP-WI)
037200        < WS-WI-PCT-DECREASE-FY2021
037300           COMPUTE CBSA-WIR-AREA-WAGEIND ROUNDED =
037400                   (SNF-SUPP-WI *  WS-WI-PCT-ADJ-FY2021)
037500           END-COMPUTE
037600     END-IF.
037700
037800
037900 2020-EXIT.
038000     EXIT.
038100
038200**---------------------------------------------********
038300*****        LAST STATEMENT               *************
038400**---------------------------------------------********
