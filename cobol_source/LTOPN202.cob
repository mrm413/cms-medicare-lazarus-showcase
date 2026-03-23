000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. LTOPN202.
000300*AUTHOR.     CENTERS FOR MEDICARE AND MEDICAID SERVICES
000400*REMARKS.    - OPENS THE PROV FILE, MSAX FILE, CBSAX FILE, AND
000500*              IPPS CBSAX FILE
000600*            - FINDS PROV RECORD FOR THE GIVEN BILL TO BE
000700*              PASSED TO THE LTDRV___ MODULE
000800*            - LOADS THE MSAX, CBSAX, & IPPS CBSAX TABLES
000900*            - CALLS THE LTDRV___ MODULE
001000 DATE-COMPILED.
001100****************************************************************
001200*                                                              *
001300*   THIS SUBROUTINE IS FURNISHED BY THE CENTERS FOR MEDICARE   *
001400*   AND MEDICAID SERVICES.                                     *
001500*   IT IS TO BE USED AS AN AID IN IMPLEMENTING PROSPECTIVE     *
001600*   PAYMENT FOR LONG TERM CARE HOSPITALS.                      *
001700*   THE RESPONSIBILITY FOR INSTALLING, MODIFYING, TESTING,     *
001800*   MAINTAINING, AND VERIFYING THE ACCURACY OF THIS PROGRAM    *
001900*   IS THAT OF THE USER.                                       *
002000*                  *  *  *  *  *  *  *  *                      *
002100*   ONCE GROUPED THE PROSPECTIVE PAYMENT SUBROUTINE IS CALLED  *
002200*   TO CALCULATE THE TOTAL PAYMENT PRIOR TO DEDUCTIBLE,        *
002300*   CO-INSURANCE, AND CASES WHERE MEDICARE IS SECONDARY PAYOR. *
002400*   THE PROGRAM WILL:                                          *
002500*       1. LOAD THE TABLES USED TO CALCULATE PPS.              *
002600*       2. PASS BACK RETURN CODES.                             *
002700*                                                              *
002800*                  *  *  *  *  *  *  *  *                      *
002900*   THIS SUBROUTINE CALCULATES THE PROVIDER SPECIFIC           *
003000*   ELEMENTS ON A PROVIDER BREAK, THEREFORE IT WILL RUN FASTER *
003100*   WHEN BILLS ARE BATCHED BY PROVIDER.                        *
003200*                  *  *  *  *  *  *  *  *                      *
003300*                                                              *
003400*                                                              *
003500*--------------------------------------------------------------*
003600*   CHANGE LOG.                                                *
003700*--------------------------------------------------------------*
003800*                                                              *
003900*   04/07/2005 - AT THE REQUEST OF FISS, LTDRV___ MODIFIED TO  *
004000*                ONLY READ INPUT DATA AND LOAD TABLES FOR THE  *
004100*                PROVIDER SPECIFIC FILE & WAGE INDEX FILE      *
004200*                IT STILL RECEIVES THE BILL & PPS RECORDS      *
004300*                                                              *
004400*--------------------------------------------------------------*
004500*                                                              *
004600*   04/20/2005 - EFFECTIVE JULY 1, 2005, CBSA (CORE-BASED      *
004700*                STATISTICAL AREA) IS USED IN PLACE OF MSA     *
004800*                (METROPOLITAN STATISTICAL AREA), THE PROGRAM  *
004900*                DETERMINES WHETHER TO USE THE CBSA WAGE INDEX *
005000*                FILE OR MSA WAGE INDEX FILE BASED ON THE BILL *
005100*                DISCHARGE DATE                                *
005200*                                                              *
005300*--------------------------------------------------------------*
005400*                                                              *
005500*   05/02/2005 - ADDED PSF FIELDS - SPECIAL PAY INDICATOR &    *
005600*                SPECIAL WAGE INDEX                            *
005700*                                                              *
005800*--------------------------------------------------------------*
005900*                                                              *
006000*   01/17/2006 - MODIFIED FOR 1ST CICS PACKAGE RELEASE;        *
006100*                TO BE RELEASED APRIL 1, 2006                  *
006200*                                                              *
006300*--------------------------------------------------------------*
006400*                                                              *
006500*   01/19/2006 - PROGRAM NAME CHANGED FROM LTDRV___ TO LTOPN___*
006600*                                                              *
006700*--------------------------------------------------------------*
006800*                                                              *
006900*   05/02/2006 - ADD IPPS CBSA WAGE INDEX TABLE TO THE PROGRAM *
007000*                FOR SHORT STAY PROVISION #4 - STORE & LOAD    *
007100*                                                              *
007200*--------------------------------------------------------------*
007300*                                                              *
007400*   06/19/2006 - CHANGE VERSION FROM 07.0 TO 07.1              *
007500*                                                              *
007600*--------------------------------------------------------------*
007700*                                                              *
007800*   08/09/2006 - UPDATE FOR OCTOBER 2006 VERSION 07.3          *
007900*                                                              *
008000*--------------------------------------------------------------*
008100*                                                              *
008200*   09/06/2006 - UPDATE FOR OCTOBER 2006 VERSION 07.4          *
008300*                                                              *
008400*--------------------------------------------------------------*
008500*                                                              *
008600*   11/16/2006 - CREATED VERSION 07.5 FOR OCTOBER 2006         *
008700*                DUE TO CORRECTION OF THE IME                  *
008800*                MULTIPLIER USED IN THE 4TH SSO                *
008900*                PROVISION (IPPS PORTION), IPPS WAGE INDEX     *
009000*                CHANGE, & REMOVAL OF PPS-RTC 23               *
009100*                                                              *
009200*--------------------------------------------------------------*
009300*                                                              *
009400*   12/28/2006 - CREATED VERSION 07.6 FOR OCTOBER 2006         *
009500*                DUE TO CBSA SIZE LOGIC CORRECTION             *
009600*                ** THIS VERSION WAS NOT RELEASED **           *
009700*                                                              *
009800*--------------------------------------------------------------*
009900*                                                              *
010000*   05/03/2007 - UPDATE FOR JULY 2007 VERSION 08.0             *
010100*                                                              *
010200*--------------------------------------------------------------*
010300*                                                              *
010400*   08/13/2007 - UPDATE FOR OCTOBER 2007 VERSION 08.1          *
010500*                                                              *
010600*--------------------------------------------------------------*
010700*                                                              *
010800*   08/23/2007 - UPDATE FOR OCTOBER 2007 VERSION 08.2          *
010900*                (FOR REVISED IPPS RATES & WAGE INDEX TABLE)   *
011000*                                                              *
011100*--------------------------------------------------------------*
011200*                                                              *
011300*   09/14/2007 - UPDATE FOR OCTOBER 2007 VERSION 08.3          *
011400*                (FOR REVISED IPPS RATES & WAGE INDEX TABLE)   *
011500*                                                              *
011600*--------------------------------------------------------------*
011700*                                                              *
011800*   09/28/2007 - UPDATE FOR OCTOBER 2007 VERSION 08.4          *
011900*                (FOR REVISED IPPS RATES)                      *
012000*                                                              *
012100*--------------------------------------------------------------*
012200*                                                              *
012300*   12/27/2007 - UPDATE FOR OCTOBER 2007 VERSION 08.5          *
012400*                (FOR REVISED SHORT STAY OUTLIER LOGIC)        *
012500*                                                              *
012600*--------------------------------------------------------------*
012700*                                                              *
012800*   02/06/2008 - UPDATE FOR OCTOBER 2007 VERSION 08.6          *
012900*                (FOR REVISED STANDARD FEDERAL RATE &          *
013000*                 FIXED LOSS AMOUNT FOR APRIL 2008)            *
013100*                                                              *
013200*--------------------------------------------------------------*
013300*                                                              *
013400*   05/08/2008 - CREATED VERSION 09.0 FOR JULY 2008            *
013500*                (FOR NEW RATE YEAR 2009, STILL FY 2008)       *
013600*                                                              *
013700*--------------------------------------------------------------*
013800*                                                              *
013900*   05/19/2008 - CREATED VERSION 09.1 FOR JULY 2008            *
014000*                REVISED IPPS PUERTO RICO RATES                *
014100*                EFFECTIVE RETROACTIVE TO 10/01/2007           *
014200*                                                              *
014300*--------------------------------------------------------------*
014400*                                                              *
014500*   08/11/2008 - CREATED VERSION 09.2 FOR OCTOBER 2008         *
014600*                (FOR RATE YEAR 2009, FY 2009)                 *
014700*                ADDED FIELD P-VAL-BASED-PURCH-SCORE TO THE    *
014800*                PSF (TO BE USED IN IPPS 01/01/2008).          *
014900*                                                              *
015000*--------------------------------------------------------------*
015100*                                                              *
015200*   09/09/2008 - CREATED VERSION 09.3 FOR OCTOBER 2008         *
015300*                (FOR RATE YEAR 2009, FY 2009)                 *
015400*                                                              *
015500*--------------------------------------------------------------*
015600*                                                              *
015700*   02/17/2009 - CREATED VERSION 09.4 FOR OCTOBER 2008         *
015800*                (FOR RATE YEAR 2009, FY 2009)                 *
015900*                                                              *
016000*--------------------------------------------------------------*
016100*                                                              *
016200*   05/18/2009 - CREATED VERSION 09.5 FOR JUNE 3 - SEPT 30 2009*
016300*                (FOR RATE YEAR 2009, FY 2009)                 *
016400*                                                              *
016500*--------------------------------------------------------------*
016600*                                                              *
016700*   08/05/2009 - CREATED VERSION 10.0 FOR OCTOBER 2009         *
016800*                (FOR RATE YEAR 2010, FY 2010)                 *
016900*                                                              *
017000*--------------------------------------------------------------*
017100*                                                              *
017200*   09/03/2009 - CREATED VERSION 10.1 FOR OCTOBER 2009         *
017300*                (FOR RATE YEAR 2010, FY 2010)                 *
017400*                                                              *
017500*--------------------------------------------------------------*
017600*                                                              *
017700*   11/11/2009 - CREATED VERSION 10.2 FOR OCTOBER 2009         *
017800*                (FOR RATE YEAR 2010, FY 2010)                 *
017900*                                                              *
018000*--------------------------------------------------------------*
018100*                                                              *
018200*   04/07/2010 - CREATED VERSION 10.3 FOR OCTOBER 2009         *
018300*                (FOR RATE YEAR 2010, FY 2010)                 *
018400*                                                              *
018500*--------------------------------------------------------------*
018600*                                                              *
018700*   04/19/2010 - CREATED VERSION 10.4 FOR OCTOBER 2009         *
018800*                (FOR RATE YEAR 2010, FY 2010)                 *
018900*                                                              *
019000*--------------------------------------------------------------*
019100*                                                              *
019200*   08/04/2010 - CREATED VERSION 11.0 FOR OCTOBER 2010         *
019300*                (FOR RATE YEAR 2011, FY 2011)                 *
019400*                                                              *
019500*--------------------------------------------------------------*
019600*                                                              *
019700*   10/20/2010 - CREATED VERSION 11.1 FOR OCTOBER 2010         *
019800*                (FOR RATE YEAR 2011, FY 2011)                 *
019900*                ALLOWS DATES OF SERVICE OLDER THAN 5 YEARS    *
020000*--------------------------------------------------------------*
020100*                                                              *
020200*   08/01/2011 - CREATED VERSION 12.0 FOR OCTOBER 2011         *
020300*                (FOR RATE YEAR 2012, FY 2012)                 *
020400*                                                              *
020500*--------------------------------------------------------------*
020600*                                                              *
020700*   08/31/2011 - CREATED VERSION 12.1 FOR OCTOBER 2011         *
020800*                (FOR RATE YEAR 2012, FY 2012)                 *
020900*                                                              *
021000*--------------------------------------------------------------*
021100*                                                              *
021200*   10/28/2011 - CREATED VERSION 12.2 FOR OCTOBER 2011         *
021300*                (FOR RATE YEAR 2012, FY 2012)                 *
021400*                                                              *
021500*--------------------------------------------------------------*
021600*                                                              *
021700*   12/09/2011 - CREATED VERSION 12.3 FOR OCTOBER 2011         *
021800*                (FOR RATE YEAR 2012, FY 2012)                 *
021900*                                                              *
022000*--------------------------------------------------------------*
022100*                                                              *
022200*   07/31/2012 - CREATED VERSION 13.0 FOR OCTOBER 2012         *
022300*                (FOR RATE YEAR 2013, FY 2013)                 *
022400*                                                              *
022500*--------------------------------------------------------------*
022600*                                                              *
022700*   07/31/2012 - CREATED VERSION 13.0 FOR OCTOBER 2012         *
022800*                (FOR RATE YEAR 2013, FY 2013)                 *
022900*                                                              *
023000*--------------------------------------------------------------*
023100*                                                              *
023200*   11/16/2012 - IN VERSION 13.0 OF THE LTCH PPS PRICER        *
023300*                CHANGED "T-CBSA-DATA  OCCURS 0 TO 4000 TIMES" *
023400*                     TO "T-CBSA-DATA  OCCURS 0 TO 7000 TIMES" *
023500*                FOR IPPS-CBSA-WI-TABLE IN RESPONSE TO         *
023600*                HPAR CR8041H2 (R41212).  NO VERSION NUMBERS   *
023700*                CHANGED AND ONLY MODULES LTDRV130 AND         *
023800*                LTOPN130 CHANGED AS DESCRIBED ABOVE.          *
023900*                                                              *
024000*--------------------------------------------------------------*
024100*                                                              *
024200*   08/12/2013 - CREATED VERSION 14.0 FOR OCTOBER 2013         *
024300*                (FOR RATE YEAR 2014, FY 2014)                 *
024400*              - ADDED HOSPITAL QUALITY INDICATOR TO PSF       *
024500*                                                              *
024600*--------------------------------------------------------------*
024700*                                                              *
024800*   09/04/2013 - CREATED VERSION 14.1                          *
024900*              - INCORPORATED CHANGES TO LTCH AND IPPS WAGE    *
025000*                INDEX TABLES                                  *
025100*                                                              *
025200*                                                              *
025300*--------------------------------------------------------------*
025400*                                                              *
025500*   08/07/2014 - CREATED VERSION 15.0                          *
025600*                                                              *
025700*--------------------------------------------------------------*
025800*                                                              *
025900*   09/03/2014 - CREATED VERSION 15.1                          *
026000*                                                              *
026100*   11/20/2014 - CREATED VERSION 15.2                          *
026200*                                                              *
026300*   03/20/15 - VERSION 15.3 CREATED TO ADD NEW DATA NAMES      *
026400*                                                              *
026500*   06/29/15 - VERSION 16.B CREATED TO TEST UPDATED LOGIC      *
026600*                                                              *
026700*   08/05/15 - VERSION 16.0 CREATED TO TEST UPDATED LOGIC      *
026800*                                                              *
026900*   11/25/15 - VERSION 16.C CREATED TO TEST UPDATED INTERFACE  *
027000*              (BILL-NEW-DATA - ADDED COST REPORT DAYS) &      *
027100*              LOGIC                                           *
027200*                                                              *
027300*   12/11/15 - VERSION 16.1 CREATED TO IMPLEMENT CR9401 4-1-16 *
027400*                                                              *
027500*   01/08/16 - VERSION 16.2                                    *
027600*                                                              *
027700* 5-23-16 - VERSION 17.B
027800* 6-7-16 CHANGED THE SEARCH OF THE PSF FROM A BINARY TO A
027900* SEQUENTIAL SEARCH
028000* 7-18-16 - VERSION 17.0
028100* 8-8-17 - VERSION 18.0
028200* 9-21-17 - VERSION 18.1
028300* 10-5-17 - VERSION 18.2
028400* 2-8-18 = VERSION 18.3
028500* 7-30-18 - VERSION 19.0
028600* 8-1-19 - VERSION 20.0
028700*      CHANGED "T-CBSA-DATA  OCCURS 0 TO 7000 TIMES"
028800*           TO "T-CBSA-DATA  OCCURS 0 TO 10000 TIMES"
028900*      FOR IPPS-CBSA-WI-TABLE
029000* 3-4-20 - VERSION 20.B FOR TESTING
029100* 4-7-20 - VERSION 20.2 COVID-19
      *
029200****************************************************************
029300
029400 ENVIRONMENT DIVISION.
029500 CONFIGURATION SECTION.
029600 SOURCE-COMPUTER.            IBM-370.
029700 OBJECT-COMPUTER.            IBM-370.
029800 INPUT-OUTPUT  SECTION.
029900 FILE-CONTROL.
030000
030100     SELECT PROV-FILE ASSIGN       TO  UT-S-PPSPROV
030200            FILE STATUS IS PROV-STAT.
030300     SELECT CBSAX-FILE ASSIGN      TO  UT-S-PPSCBSAX
030400            FILE STATUS IS CBSAX-STAT.
030500     SELECT IPPS-CBSAX-FILE ASSIGN TO  UT-S-IPCBSAX
030600            FILE STATUS IS IPPS-CBSAX-STAT.
030700     SELECT MSAX-FILE ASSIGN       TO  UT-S-PPSMSAX
030800            FILE STATUS IS MSAX-STAT.
030900
031000 DATA DIVISION.
031100 FILE SECTION.
031200
031300 FD  PROV-FILE
031400     RECORDING MODE IS F
031500     LABEL RECORDS ARE STANDARD
031600     BLOCK CONTAINS 0 RECORDS.
031700 01  PROV-REC.
031800     05  PROV-PART1                 PIC X(80).
031900     05  PROV-PART2                 PIC X(80).
032000     05  PROV-PART3                 PIC X(80).
032100
032200 FD  CBSAX-FILE
032300     RECORDING MODE IS F
032400     LABEL RECORDS ARE STANDARD
032500     BLOCK CONTAINS 0 RECORDS.
032600***************************************************************
032700*    THIS RECORD IS SUPPLIED BY CMS AND CONTAINS              *
032800*    THE WAGE INDEX FOR THE STATES (RURAL) AND CBSA'S (URBAN).*
032900***************************************************************
033000 01  CBSAX-REC.
033100     05  X-CBSA-X.
033200         10  M-BLANK                PIC X(03).
033300         10  M-STATE                PIC 9(02).
033400     05  X-CBSA REDEFINES X-CBSA-X  PIC 9(05).
033500     05  FILLER                     PIC X(01).
033600     05  XE-DATE-C.
033700         10  XE-C-CC                PIC 9(02).
033800         10  XE-C-YY                PIC 9(02).
033900         10  XE-C-MM                PIC 9(02).
034000         10  XE-C-DD                PIC 9(02).
034100     05  FILLER                     PIC X(01).
034200     05  X-WAGE-INDEX1-C            PIC S9(02)V9(04).
034300     05  FILLER                     PIC X(01).
034400     05  X-WAGE-INDEX2-C            PIC S9(02)V9(04).
034500     05  FILLER                     PIC X(01).
034600     05  X-WAGE-INDEX3-C            PIC S9(02)V9(04).
034700     05  FILLER                     PIC X(01).
034800     05  X-STATE-CBSA-NAME          PIC X(39).
034900     05  FILLER                     PIC X(05).
035000
035100 FD  IPPS-CBSAX-FILE
035200     RECORDING MODE IS F
035300     LABEL RECORDS ARE STANDARD
035400     BLOCK CONTAINS 0 RECORDS.
035500***************************************************************
035600*    THIS RECORD IS SUPPLIED BY CMS AND CONTAINS THE IPPS     *
035700*    WAGE INDEX FOR THE STATES (RURAL) AND CBSA'S (URBAN).    *
035800***************************************************************
035900 01  F-IPPS-CBSA-REC.
036000     05  F-CBSA.
036100         10  F-CBSA-BLANK                PIC X(03).
036200         10  F-CBSA-STATE                PIC 9(02).
036300     05  F-CBSA9  REDEFINES F-CBSA       PIC 9(05).
036400     05  F-CBSA-SIZE             PIC X(01).
036500     05  F-CBSA-EFF-DATE.
036600         10  F-CBSA-CC           PIC 9(02).
036700         10  F-CBSA-YY           PIC 9(02).
036800         10  F-CBSA-MM           PIC 9(02).
036900         10  F-CBSA-DD           PIC 9(02).
037000     05  FILLER                  PIC X(01).
037100     05  F-CBSA-WAGE-INDX1       PIC S9(02)V9(04).
037200     05  FILLER                  PIC X(01).
037300     05  F-CBSA-WAGE-INDX2       PIC S9(02)V9(04).
037400     05  FILLER                  PIC X(01).
037500     05  F-CBSA-STATE-NAME       PIC X(50).
037600     05  FILLER                  PIC X(01).
037700
037800 FD  MSAX-FILE
037900     RECORDING MODE IS F
038000     LABEL RECORDS ARE STANDARD
038100     BLOCK CONTAINS 0 RECORDS.
038200***************************************************************
038300*    THIS RECORD IS SUPPLIED BY CMS AND CONTAINS              *
038400*    THE WAGE INDEX FOR THE STATES (RURAL) AND MSA'S (URBAN). *
038500***************************************************************
038600 01  MSAX-REC.
038700     05  X-MSA-X.
038800         10  M-BLANK                PIC X(02).
038900         10  M-STATE                PIC 9(02).
039000     05  X-MSA REDEFINES X-MSA-X    PIC 9(04).
039100     05  FILLER                     PIC X(01).
039200     05  XE-DATE-M.
039300         10  XE-M-CC                PIC 9(02).
039400         10  XE-M-YY                PIC 9(02).
039500         10  XE-M-MM                PIC 9(02).
039600         10  XE-M-DD                PIC 9(02).
039700     05  FILLER                     PIC X(01).
039800     05  X-WAGE-INDEX1-M            PIC S9(02)V9(04).
039900     05  FILLER                     PIC X(01).
040000     05  X-WAGE-INDEX2-M            PIC S9(02)V9(04).
040100     05  FILLER                     PIC X(01).
040200     05  X-WAGE-INDEX3-M            PIC S9(02)V9(04).
040300     05  FILLER                     PIC X(01).
040400     05  X-STATE-MSA-NAME           PIC X(44).
040500     05  FILLER                     PIC X(01).
040600
040700 WORKING-STORAGE SECTION.
040800 77  W-STORAGE-REF                  PIC X(48) VALUE
040900     'L T O P N _ _ _ - W O R K I N G   S T O R A G E'.
041000 01  OPN-VERSION                    PIC X(05) VALUE '020.B'.
041100 01  LTDRV202                       PIC X(08) VALUE 'LTDRV202'.
041200 01  TABLES-LOADED-SW               PIC 9(01) VALUE 0.
041300 01  EOF-SW                         PIC 9(01) VALUE 0.
041400
041500*****************************************************
041600* PROVIDER RECORD THAT CAN BE PASSED IN FROM THE    *
041700* USER                                              *
041800*****************************************************
041900 01  W-PROV-NEW-HOLD.
042000     02  W-PROV-NEWREC-HOLD1.
042100         05  W-P-NEW-NPI10.
042200             10  W-P-NEW-NPI8             PIC X(08).
042300             10  W-P-NEW-NPI-FILLER       PIC X(02).
042400         05  W-P-NEW-PROVIDER-OSCAR-NO.
042500             10  W-P-NEW-STATE            PIC 9(02).
042600             10  W-P-NEW-STATE-X REDEFINES
042700                 W-P-NEW-STATE            PIC X(02).
042800             10  FILLER                   PIC X(04).
042900         05  W-P-NEW-DATE-DATA.
043000             10  W-P-NEW-EFF-DATE.
043100                 15  W-P-NEW-EFF-DT-CC    PIC 9(02).
043200                 15  W-P-NEW-EFF-DT-YY    PIC 9(02).
043300                 15  W-P-NEW-EFF-DT-MM    PIC 9(02).
043400                 15  W-P-NEW-EFF-DT-DD    PIC 9(02).
043500             10  W-P-NEW-FY-BEGIN-DATE.
043600                 15  W-P-NEW-FY-BEG-DT-CC PIC 9(02).
043700                 15  W-P-NEW-FY-BEG-DT-YY PIC 9(02).
043800                 15  W-P-NEW-FY-BEG-DT-MM PIC 9(02).
043900                 15  W-P-NEW-FY-BEG-DT-DD PIC 9(02).
044000             10  W-P-NEW-REPORT-DATE.
044100                 15  W-P-NEW-REPORT-DT-CC PIC 9(02).
044200                 15  W-P-NEW-REPORT-DT-YY PIC 9(02).
044300                 15  W-P-NEW-REPORT-DT-MM PIC 9(02).
044400                 15  W-P-NEW-REPORT-DT-DD PIC 9(02).
044500             10  W-P-NEW-TERMINATION-DATE.
044600                 15  W-P-NEW-TERM-DT-CC   PIC 9(02).
044700                 15  W-P-NEW-TERM-DT-YY   PIC 9(02).
044800                 15  W-P-NEW-TERM-DT-MM   PIC 9(02).
044900                 15  W-P-NEW-TERM-DT-DD   PIC 9(02).
045000         05  W-P-NEW-WAIVER-CODE          PIC X(01).
045100             88  W-P-NEW-WAIVER-STATE       VALUE 'Y'.
045200         05  W-P-NEW-INTER-NO             PIC X(05).
045300         05  W-P-NEW-PROVIDER-TYPE        PIC X(02).
045400         05  W-P-NEW-CURRENT-CENSUS-DIV   PIC X(01).
045500         05  W-P-NEW-MSA-DATA.
045600             10  W-P-NEW-CHG-CODE-INDEX    PIC X.
045700             10  W-P-NEW-GEO-LOC-MSA        PIC X(04) JUST RIGHT.
045800             10  W-P-NEW-WAGE-INDEX-LOC-MSA PIC X(04) JUST RIGHT.
045900             10  W-P-NEW-STAND-AMT-LOC-MSA  PIC X(04) JUST RIGHT.
046000             10  W-P-NEW-STAND-AMT-LOC-MSA9
046100       REDEFINES W-P-NEW-STAND-AMT-LOC-MSA.
046200                 15  W-P-NEW-RURAL-1ST.
046300                     20  W-P-NEW-STAND-RURAL  PIC XX.
046400                 15  W-P-NEW-RURAL-2ND        PIC XX.
046500         05  W-P-NEW-SOL-COM-DEP-HOSP-YR PIC XX.
046600         05  W-P-NEW-LUGAR               PIC X.
046700         05  W-P-NEW-TEMP-RELIEF-IND     PIC X.
046800         05  W-P-NEW-FED-PPS-BLEND-IND   PIC X.
046900         05  FILLER                      PIC X(05).
047000     02  W-PROV-NEWREC-HOLD2.
047100         05  W-P-NEW-VARIABLES.
047200             10  W-P-NEW-FAC-SPEC-RATE     PIC  X(07).
047300             10  W-P-NEW-COLA              PIC  X(04).
047400             10  W-P-NEW-INTERN-RATIO      PIC  X(05).
047500             10  W-P-NEW-BED-SIZE          PIC  X(05).
047600             10  W-P-NEW-CCR               PIC  X(04).
047700             10  W-P-NEW-CMI               PIC  X(05).
047800             10  W-P-NEW-SSI-RATIO         PIC  X(04).
047900             10  W-P-NEW-MEDICAID-RATIO    PIC  X(04).
048000             10  W-P-NEW-PPS-BLEND-YR-IND  PIC  X(01).
048100             10  W-P-NEW-PRUP-UPDTE-FACTOR PIC  9(01)V9(05).
048200             10  W-P-NEW-DSH-PERCENT       PIC  V9(04).
048300             10  W-P-NEW-FYE-DATE.
048400                 15  W-P-NEW-FYE-CC        PIC 99.
048500                 15  W-P-NEW-FYE-YY        PIC 99.
048600                 15  W-P-NEW-FYE-MM        PIC 99.
048700                 15  W-P-NEW-FYE-DD        PIC 99.
048800         05  W-P-NEW-SPECIAL-PAY-IND       PIC X(01).
048900         05  W-P-NEW-HOSP-QUAL-IND         PIC X(01).
049000         05  W-P-NEW-GEO-LOC-CBSAX         PIC X(05).
049100         05  W-P-NEW-GEO-LOC-CBSA9 REDEFINES
049200                         W-P-NEW-GEO-LOC-CBSAX PIC 9(05).
049300         05  W-P-NEW-GEO-LOC-CBSA-AST REDEFINES
049400                         W-P-NEW-GEO-LOC-CBSAX.
049500             10 W-P-NEW-GEO-LOC-CBSA-1ST   PIC X.
049600             10 W-P-NEW-GEO-LOC-CBSA-2ND   PIC X.
049700             10 W-P-NEW-GEO-LOC-CBSA-3RD   PIC X.
049800             10 W-P-NEW-GEO-LOC-CBSA-4TH   PIC X.
049900             10 W-P-NEW-GEO-LOC-CBSA-5TH   PIC X.
050000         05  FILLER                        PIC X(10).
050100         05  W-P-NEW-SPECIAL-WAGE-INDEX    PIC 9(02)V9(04).
050200     02  W-PROV-NEWREC-HOLD3.
050300         05  W-P-NEW-PASS-AMT-DATA.
050400             10  W-P-NEW-PASS-AMT-CAPITAL    PIC X(06).
050500             10  W-P-NEW-PASS-AMT-DIR-MED-ED PIC X(06).
050600             10  W-P-NEW-PASS-AMT-ORGAN-ACQ  PIC X(06).
050700             10  W-P-NEW-PASS-AMT-PLUS-MISC  PIC X(06).
050800         05  W-P-NEW-CAPI-DATA.
050900             15  W-P-NEW-CAPI-PPS-PAY-CODE   PIC X.
051000             15  W-P-NEW-CAPI-HOSP-SPEC-RATE PIC X(6).
051100             15  W-P-NEW-CAPI-OLD-HARM-RATE  PIC X(6).
051200             15  W-P-NEW-CAPI-NEW-HARM-RATIO PIC X(5).
051300             15  W-P-NEW-CAPI-CSTCHG-RATIO   PIC X(04).
051400             15  W-P-NEW-CAPI-NEW-HOSP       PIC X.
051500             15  W-P-NEW-CAPI-IME            PIC X(05).
051600             15  W-P-NEW-CAPI-EXCEPTIONS     PIC X(6).
051700             15  W-P-VAL-BASED-PURCH-SCORE   PIC X(4).
051800             15  P-LTCH-DPP-ADJ              PIC S9(09)V99.
051900         05  FILLER                          PIC X(07).
052000
052100
052200***************************************************************
052300* FILE STATUS VARIABLES                                       *
052400***************************************************************
052500 01  PROV-STAT.
052600     02  PROV-STAT1          PIC X.
052700     02  PROV-STAT2          PIC X.
052800
052900 01  MSAX-STAT.
053000     02  MSAX-STAT1          PIC X.
053100     02  MSAX-STAT2          PIC X.
053200
053300 01  CBSAX-STAT.
053400     02  CBSAX-STAT1         PIC X.
053500     02  CBSAX-STAT2         PIC X.
053600
053700 01  IPPS-CBSAX-STAT.
053800     02  IPPS-CBSAX-STAT1    PIC X.
053900     02  IPPS-CBSAX-STAT2    PIC X.
054000
054100***************************************************************
054200* CBSA WAGE INDEX TABLE                                       *
054300***************************************************************
054400 01  CBSA-WI-TABLE.
054500     05  C-CBSA-DATA  OCCURS 0 TO 7000 TIMES
054600                      DEPENDING ON CBSA-CNT
054700                      ASCENDING KEY IS CBSAX-CBSA
054800                      INDEXED BY CU1 CU2.
054900         10  CBSAX-CBSA         PIC X(05).
055000         10  CBSAX-EFF-DATE     PIC X(08).
055100         10  CBSAX-WAGE-INDEX1  PIC S9(02)V9(04).
055200         10  CBSAX-WAGE-INDEX2  PIC S9(02)V9(04).
055300         10  CBSAX-WAGE-INDEX3  PIC S9(02)V9(04).
055400
055500***************************************************************
055600* IPPS CBSA WAGE INDEX TABLE                                  *
055700***************************************************************
055800 01  IPPS-CBSA-WI-TABLE.
055900     05  T-CBSA-DATA  OCCURS 0 TO 10000 TIMES
056000                      DEPENDING ON IPPS-CBSA-CNT
056100                      ASCENDING KEY IS T-CBSA
056200                      INDEXED BY MA1 MA2 MA3.
056300         10  T-CBSA             PIC X(5).
056400         10  T-CBSA-SIZE        PIC X(01).
056500         10  T-CBSA-EFF-DATE    PIC X(08).
056600         10  T-CBSA-WAGE-INDX1  PIC S9(02)V9(04).
056700         10  T-CBSA-WAGE-INDX2  PIC S9(02)V9(04).
056800
056900***************************************************************
057000* MSA WAGE INDEX TABLE                                        *
057100***************************************************************
057200 01  MSA-WI-TABLE.
057300     05  M-MSA-DATA   OCCURS 0 TO 4000 TIMES
057400                      DEPENDING ON MSA-CNT
057500                      ASCENDING KEY IS MSAX-MSA
057600                      INDEXED BY MU1 MU2.
057700         10  MSAX-MSA          PIC X(4).
057800         10  MSAX-EFF-DATE     PIC X(08).
057900         10  MSAX-WAGE-INDEX1  PIC S9(02)V9(04).
058000         10  MSAX-WAGE-INDEX2  PIC S9(02)V9(04).
058100         10  MSAX-WAGE-INDEX3  PIC S9(02)V9(04).
058200
058300***************************************************************
058400* RECORD COUNT VARIABLES                                      *
058500***************************************************************
058600 01  WORK-COUNTERS.
058700     05  CBSA-CNT              PIC 9(5) VALUE ZERO.
058800     05  MSA-CNT               PIC 9(5) VALUE ZERO.
058900     05  PROV-CNT              PIC 9(5) VALUE ZERO.
059000     05  IPPS-CBSA-CNT         PIC 9(5) VALUE ZERO.
059100
059200***************************************************************
059300*    THE PROVIDER SPECIFIC INFORMATION TABLE IS INITIALLY     *
059400*    SET TO OCCUR 2400 TIMES. THIS NUMBER SHOULD BE ADJUSTED  *
059500*    BY THE USER TO REFLECT THE NUMBER OF PROVIDER RECORDS    *
059600*    PLUS EXPANSION. EACH ENTRY COSTS 240 BYTES OF MEMORY.    *
059700*    THIS FILE MUST BE IN PROVIDER NUMBER, EFFECTIVE-DATE     *
059800*    SEQUENCE.                                                *
059900***************************************************************
060000 01  PROV-TABLE.
060100     05  PROV-ENTRIES       OCCURS 0 TO 2400 TIMES
060200                            DEPENDING ON PROV-CNT
060300                            ASCENDING KEY IS PROV-NO
060400                            INDEXED BY PX1.
060500         10  PROV-DATA1.
060600             15  PROV-NPI10.
060700                 20  PROV-NPI8       PIC X(08).
060800                 20  PROV-NPI-FILLER PIC X(02).
060900             15  PROV-NO             PIC X(06).
061000             15  PROV-EFF-DATE       PIC X(08).
061100             15  FILLER              PIC X(56).
061200
061300 01  PROV-DATA-2.
061400     05  PROV-ENTRIES2      OCCURS 0 TO 2400 TIMES
061500                            DEPENDING ON PROV-CNT
061600                            INDEXED BY PD2.
061700         10  PROV-DATA2              PIC X(80).
061800
061900 01  PROV-DATA-3.
062000     05  PROV-ENTRIES3      OCCURS 0 TO 2400 TIMES
062100                            DEPENDING ON PROV-CNT
062200                            INDEXED BY PD3.
062300         10  PROV-DATA3              PIC X(80).
062400
062500
062600**************************************************************
062700*      THIS IS THE PROV-RECORD THAT WILL BE PASSED TO        *
062800*      THE LTDRV___ PROGRAM                                  *
062900**************************************************************
063000 01  PROV-NEW-HOLD.
063100     02  PROV-NEWREC-HOLD1.
063200         05  P-NEW-NPI10.
063300             10  P-NEW-NPI8             PIC X(08).
063400             10  P-NEW-NPI-FILLER       PIC X(02).
063500         05  P-NEW-PROVIDER-NO.
063600             10  P-NEW-STATE            PIC 9(02).
063700             10  P-NEW-STATE-X REDEFINES
063800                 P-NEW-STATE            PIC X(02).
063900             10  FILLER                 PIC X(04).
064000         05  P-NEW-DATE-DATA.
064100             10  P-NEW-EFF-DATE.
064200                 15  P-NEW-EFF-DT-CC    PIC 9(02).
064300                 15  P-NEW-EFF-DT-YY    PIC 9(02).
064400                 15  P-NEW-EFF-DT-MM    PIC 9(02).
064500                 15  P-NEW-EFF-DT-DD    PIC 9(02).
064600             10  P-NEW-FY-BEGIN-DATE.
064700                 15  P-NEW-FY-BEG-DT-CC PIC 9(02).
064800                 15  P-NEW-FY-BEG-DT-YY PIC 9(02).
064900                 15  P-NEW-FY-BEG-DT-MM PIC 9(02).
065000                 15  P-NEW-FY-BEG-DT-DD PIC 9(02).
065100             10  P-NEW-REPORT-DATE.
065200                 15  P-NEW-REPORT-DT-CC PIC 9(02).
065300                 15  P-NEW-REPORT-DT-YY PIC 9(02).
065400                 15  P-NEW-REPORT-DT-MM PIC 9(02).
065500                 15  P-NEW-REPORT-DT-DD PIC 9(02).
065600             10  P-NEW-TERMINATION-DATE.
065700                 15  P-NEW-TERM-DT-CC   PIC 9(02).
065800                 15  P-NEW-TERM-DT-YY   PIC 9(02).
065900                 15  P-NEW-TERM-DT-MM   PIC 9(02).
066000                 15  P-NEW-TERM-DT-DD   PIC 9(02).
066100         05  P-NEW-WAIVER-CODE          PIC X(01).
066200             88  P-NEW-WAIVER-STATE       VALUE 'Y'.
066300         05  P-NEW-INTER-NO             PIC 9(05).
066400         05  P-NEW-PROVIDER-TYPE        PIC X(02).
066500         05  P-NEW-CURRENT-CENSUS-DIV   PIC 9(01).
066600         05  P-NEW-CURRENT-DIV   REDEFINES
066700                    P-NEW-CURRENT-CENSUS-DIV   PIC 9(01).
066800         05  P-NEW-MSA-DATA.
066900             10  P-NEW-CHG-CODE-INDEX       PIC X.
067000             10  P-NEW-GEO-LOC-MSAX         PIC X(04) JUST RIGHT.
067100             10  P-NEW-GEO-LOC-MSA9   REDEFINES
067200                             P-NEW-GEO-LOC-MSAX  PIC 9(04).
067300             10  P-NEW-GEO-LOC-MSA-AST REDEFINES
067400                             P-NEW-GEO-LOC-MSAX.
067500                 15  P-NEW-GEO-MSA-1ST    PIC X.
067600                 15  P-NEW-GEO-MSA-2ND    PIC X.
067700                 15  P-NEW-GEO-MSA-3RD    PIC X.
067800                 15  P-NEW-GEO-MSA-4TH    PIC X.
067900             10  P-NEW-WAGE-INDEX-LOC-MSA   PIC X(04) JUST RIGHT.
068000             10  P-NEW-STAND-AMT-LOC-MSA    PIC X(04) JUST RIGHT.
068100             10  P-NEW-STAND-AMT-LOC-MSA9
068200                   REDEFINES P-NEW-STAND-AMT-LOC-MSA.
068300                 15  P-NEW-RURAL-1ST.
068400                     20  P-NEW-STAND-RURAL  PIC XX.
068500                         88  P-NEW-STD-RURAL-CHECK VALUE '  '.
068600                 15  P-NEW-RURAL-2ND        PIC XX.
068700         05  P-NEW-SOL-COM-DEP-HOSP-YR PIC XX.
068800                 88  P-NEW-SCH-YRBLANK    VALUE   '  '.
068900                 88  P-NEW-SCH-YR82       VALUE   '82'.
069000                 88  P-NEW-SCH-YR87       VALUE   '87'.
069100         05  P-NEW-LUGAR                    PIC X.
069200         05  P-NEW-TEMP-RELIEF-IND          PIC X.
069300         05  P-NEW-FED-PPS-BLEND-IND        PIC X.
069400         05  FILLER                         PIC X(05).
069500     02  PROV-NEWREC-HOLD2.
069600         05  P-NEW-VARIABLES.
069700             10  P-NEW-FAC-SPEC-RATE     PIC  9(05)V9(02).
069800             10  P-NEW-COLA              PIC  9(01)V9(03).
069900             10  P-NEW-INTERN-RATIO      PIC  9(01)V9(04).
070000             10  P-NEW-BED-SIZE          PIC  9(05).
070100             10  P-NEW-CCR               PIC  9(01)V9(03).
070200             10  P-NEW-CMI               PIC  9(01)V9(04).
070300             10  P-NEW-SSI-RATIO         PIC  V9(04).
070400             10  P-NEW-MEDICAID-RATIO    PIC  V9(04).
070500             10  P-NEW-PPS-BLEND-YR-IND  PIC  X(01).
070600             10  P-NEW-PRUP-UPDTE-FACTOR PIC  9(01)V9(05).
070700             10  P-NEW-DSH-PERCENT       PIC  V9(04).
070800             10  P-NEW-FYE-DATE.
070900                 15  P-NEW-FYE-CC        PIC 99.
071000                 15  P-NEW-FYE-YY        PIC 99.
071100                 15  P-NEW-FYE-MM        PIC 99.
071200                 15  P-NEW-FYE-DD        PIC 99.
071300         05  P-NEW-SPECIAL-PAY-IND         PIC X(01).
071400         05  FILLER                        PIC X(01).
071500         05  P-NEW-GEO-LOC-CBSAX           PIC X(05) JUST RIGHT.
071600         05  P-NEW-GEO-LOC-CBSA9 REDEFINES
071700                       P-NEW-GEO-LOC-CBSAX PIC 9(05).
071800         05  P-NEW-GEO-LOC-CBSA-AST REDEFINES
071900                       P-NEW-GEO-LOC-CBSAX.
072000             10 P-NEW-GEO-LOC-CBSA-1ST     PIC X.
072100             10 P-NEW-GEO-LOC-CBSA-2ND     PIC X.
072200             10 P-NEW-GEO-LOC-CBSA-3RD     PIC X.
072300             10 P-NEW-GEO-LOC-CBSA-4TH     PIC X.
072400             10 P-NEW-GEO-LOC-CBSA-STH     PIC X.
072500         05  FILLER                        PIC X(10).
072600         05  P-NEW-SPECIAL-WAGE-INDEX      PIC 9(02)V9(04).
072700     02  PROV-NEWREC-HOLD3.
072800         05  P-NEW-PASS-AMT-DATA.
072900             10  P-NEW-PASS-AMT-CAPITAL    PIC 9(04)V99.
073000             10  P-NEW-PASS-AMT-DIR-MED-ED PIC 9(04)V99.
073100             10  P-NEW-PASS-AMT-ORGAN-ACQ  PIC 9(04)V99.
073200             10  P-NEW-PASS-AMT-PLUS-MISC  PIC 9(04)V99.
073300         05  P-NEW-CAPI-DATA.
073400             15  P-NEW-CAPI-PPS-PAY-CODE   PIC X.
073500             15  P-NEW-CAPI-HOSP-SPEC-RATE PIC 9(04)V99.
073600             15  P-NEW-CAPI-OLD-HARM-RATE  PIC 9(04)V99.
073700             15  P-NEW-CAPI-NEW-HARM-RATIO PIC 9(01)V9999.
073800             15  P-NEW-CAPI-CSTCHG-RATIO   PIC 9V999.
073900             15  P-NEW-CAPI-NEW-HOSP       PIC X.
074000             15  P-NEW-CAPI-IME            PIC 9V9999.
074100             15  P-NEW-CAPI-EXCEPTIONS     PIC 9(04)V99.
074200         05  FILLER                        PIC X(22).
074300
074400
074500***************************************************************
074600 LINKAGE SECTION.
074700***************************************************************
074800
074900***************************************************************
075000*      THIS IS THE BILL-RECORD THAT IS PASSED TO THIS PROGRAM *
075100*      AND WILL BE PASSED TO PROGRAM LTDRV___                 *
075200***************************************************************
075300 01  BILL-NEW-DATA.
075400     05  B-NPI10.
075500         10  B-NPI8                   PIC X(08).
075600         10  B-NPI-FILLER             PIC X(02).
075700     05  B-PROVIDER-NO                PIC X(06).
075800     05  B-PATIENT-STATUS             PIC X(02).
075900     05  B-DRG-CODE                   PIC X(03).
076000     05  B-LOS                        PIC 9(03).
076100     05  B-COV-DAYS                   PIC 9(03).
076200     05  B-LTR-DAYS                   PIC 9(02).
076300     05  B-CST-RPT-DAYS               PIC 9(03).
076400     05  B-DISCHARGE-DATE.
076500         10  B-DISCHG-CC              PIC 9(02).
076600         10  B-DISCHG-YY              PIC 9(02).
076700         10  B-DISCHG-MM              PIC 9(02).
076800         10  B-DISCHG-DD              PIC 9(02).
076900     05  B-COV-CHARGES                PIC 9(07)V9(02).
077000     05  B-SPEC-PAY-IND               PIC X(01).
077100     05  B-REVIEW-CODE                PIC 9(02).
077200     05  B-DIAGNOSIS-CODE-TABLE.
077300         10  B-DIAGNOSIS-CODE         PIC X(07) OCCURS 25 TIMES
077400                                      INDEXED BY IDX-DIAG.
077500     05  B-PROCEDURE-CODE-TABLE.
077600         10 B-PROCEDURE-CODE          PIC X(07) OCCURS 25 TIMES
077700                                      INDEXED BY IDX-PROC.
077800     05  B-LTCH-DPP-INDICATOR-SW      PIC X.
077900         88 B-LTCH-DPP-ADJUSTMENT     VALUE 'Y'.
078000     05  FILLER                       PIC X(19).
078100
078200**************************************************************
078300*      THIS IS THE PPS DATA THAT IS PASSED TO THIS PROGRAM   *
078400*      AND WILL BE PASSED TO PROGRAM LTDRV___                *
078500**************************************************************
078600 01  PPS-DATA-ALL.
078700     05  PPS-RTC                      PIC X(02).
078800     05  PPS-CHRG-THRESHOLD           PIC 9(07)V9(02).
078900     05  PPS-DATA.
079000         10  PPS-MSA                  PIC X(04).
079100         10  PPS-WAGE-INDEX           PIC 9(02)V9(04).
079200         10  PPS-AVG-LOS              PIC 9(02)V9(01).
079300         10  PPS-RELATIVE-WGT         PIC 9(01)V9(04).
079400         10  PPS-OUTLIER-PAY-AMT      PIC 9(07)V9(02).
079500         10  PPS-LOS                  PIC 9(03).
079600         10  PPS-DRG-ADJ-PAY-AMT      PIC 9(07)V9(02).
079700         10  PPS-FED-PAY-AMT          PIC 9(07)V9(02).
079800         10  PPS-FINAL-PAY-AMT        PIC 9(07)V9(02).
079900         10  PPS-FAC-COSTS            PIC 9(07)V9(02).
080000         10  PPS-NEW-FAC-SPEC-RATE    PIC 9(07)V9(02).
080100         10  PPS-OUTLIER-THRESHOLD    PIC 9(07)V9(02).
080200         10  PPS-SUBM-DRG-CODE        PIC X(03).
080300         10  PPS-CALC-VERS-CD         PIC X(05).
080400         10  PPS-REG-DAYS-USED        PIC 9(03).
080500         10  PPS-LTR-DAYS-USED        PIC 9(03).
080600         10  PPS-BLEND-YEAR           PIC 9(01).
080700         10  PPS-COLA                 PIC 9(01)V9(03).
080800         10  FILLER                   PIC X(04).
080900    05  PPS-OTHER-DATA.
081000         10  PPS-NAT-LABOR-PCT        PIC 9(01)V9(05).
081100         10  PPS-NAT-NONLABOR-PCT     PIC 9(01)V9(05).
081200         10  PPS-STD-FED-RATE         PIC 9(05)V9(02).
081300         10  PPS-BDGT-NEUT-RATE       PIC 9(01)V9(03).
081400         10  PPS-IPTHRESH             PIC 9(03)V9(01).
081500         10  PPS-LTCH-DPP-ADJ-AMT     PIC S9(09)V99.
081600         10  FILLER                   PIC X(05).
081700    05  PPS-PC-DATA.
081800         10  PPS-COT-IND              PIC X(01).
081900         10  FILLER                   PIC X(20).
082000
082100 01  PPS-CBSA                         PIC X(05).
082200
082300 01  PPS-PAYMENT-DATA.
082400     05  PPS-SITE-NEUTRAL-COST-PMT    PIC 9(07)V99.
082500     05  PPS-SITE-NEUTRAL-IPPS-PMT    PIC 9(07)V99.
082600     05  PPS-STANDARD-FULL-PMT        PIC 9(07)V99.
082700     05  PPS-STANDARD-SSO-PMT         PIC 9(07)V99.
082800
082900*****************************************************************
083000*            THESE ARE THE VERSIONS OF THE LTDRV___             *
083100*           PROGRAMS THAT WILL BE PASSED BACK----               *
083200*          ASSOCIATED WITH THE BILL BEING PROCESSED             *
083300*****************************************************************
083400 01  PRICER-OPT-VERS-SW.
083500     05  PRICER-OPTION-SW               PIC X(01).
083600         88  ALL-TABLES-PASSED          VALUE 'A'.
083700         88  PROV-RECORD-PASSED         VALUE 'P'.
083800     05  PPS-VERSIONS.
083900         10  PPDRV-VERSION              PIC X(05).
084000
084100**************************************************************
084200*      PROVIDER SPECIFIC RECORD                              *
084300**************************************************************
084400 01  PROV-RECORD-FROM-USER.
084500     05  PROV-REC1                  PIC X(80).
084600     05  PROV-REC2                  PIC X(80).
084700     05  PROV-REC3                  PIC X(80).
084800
084900*****************************************************************
085000*      CORE-BASED STATISTICAL AREA RECORD FROM USER (CBSA)      *
085100*****************************************************************
085200 01  CBSAX-TABLE-FROM-USER.
085300     05  FILLER                     PIC X(32000).
085400     05  FILLER                     PIC X(30000).
085500     05  FILLER                     PIC X(30000).
085600
085700*****************************************************************
085800*      IPPS CORE-BASED STATISTICAL AREA RECORD FROM USER (CBSA) *
085900*****************************************************************
086000 01  IPPS-CBSAX-TABLE-FROM-USER.
086100     05  FILLER                     PIC X(32000).
086200     05  FILLER                     PIC X(30000).
086300     05  FILLER                     PIC X(30000).
086400
086500*****************************************************************
086600*      METROPOLITAN STATISTICAL AREA RECORD FROM USER (MSA)     *
086700*****************************************************************
086800 01  MSAX-TABLE-FROM-USER.
086900     05  FILLER                     PIC X(32000).
087000     05  FILLER                     PIC X(30000).
087100     05  FILLER                     PIC X(30000).
087200
087300
087400
087500
087600 PROCEDURE DIVISION  USING BILL-NEW-DATA
087700                           PPS-DATA-ALL
087800                           PPS-CBSA
087900                           PPS-PAYMENT-DATA
088000                           PRICER-OPT-VERS-SW
088100                           PROV-RECORD-FROM-USER
088200                           CBSAX-TABLE-FROM-USER
088300                           IPPS-CBSAX-TABLE-FROM-USER
088400                           MSAX-TABLE-FROM-USER.
088500
088600
088700******************************************************************
088800*                                                                *
088900*    PROCESSING:                                                 *
089000*       A. THIS MODULE WILL LOAD ALL TABLES THE FIRST TIME THIS  *
089100*          SUBROUTINE IS CALLED.                                 *
089200*       B. THIS MODULE WILL CALL THE LTDRV MODULE.               *
089300*       C. THE PROVIDER TABLE AND WAGE INDEX MSA AND CBSA        *
089400*          TABLES WILL BE PASSED TO THE LTDRV PROGRAM.           *
089500*                                                                *
089600******************************************************************
089700
089800     INITIALIZE PPS-DATA-ALL.
089900     INITIALIZE PPS-CBSA.
090000
090100*----------------------------------------------------------*
090200*  RTC = 98  --  BILL DISCHARGE DATE BEFORE 10/01/2002     *
090300*----------------------------------------------------------*
090400     IF B-DISCHARGE-DATE < 20021001
090500        MOVE 98 TO PPS-RTC
090600        GOBACK.
090700
090800
090900******************************************************************
091000 0000-TEST-PRICER-OPTION-SW.
091100******************************************************************
091200
091300*-----------------------------------------------------*
091400* DETERMINE WHICH FILES HAVE BEEN PASSED IN AND CALL  *
091500* THE APPROPRIATE PARAGRAPH                           *
091600*-----------------------------------------------------*
091700     IF PRICER-OPTION-SW  = 'A'
091800        PERFORM 1900-OPTION-SW-A THRU 1900-EXIT
091900     ELSE
092000       IF PRICER-OPTION-SW  = 'P'
092100          PERFORM 2000-OPTION-SW-P THRU 2000-EXIT
092200       ELSE
092300          PERFORM 2100-OPTION-SW THRU 2100-EXIT
092400       END-IF
092500     END-IF.
092600
092700*-----------------------------------------------------*
092800***  GET THE PROVIDER RECORD IF NEEDED                *
092900*-----------------------------------------------------*
093000     IF PROV-RECORD-PASSED OR ALL-TABLES-PASSED
093100        MOVE 00 TO PPS-RTC
093200     ELSE
093300        PERFORM 1200-GET-THIS-PROVIDER THRU 1200-EXIT
093400     END-IF.
093500
093600***  RTC = 59  --  PROVIDER NOT FOUND
093700     IF PPS-RTC = 59
093800        GOBACK.
093900
094000     IF P-NEW-GEO-LOC-CBSAX = SPACES
094100        MOVE ZEROS TO P-NEW-GEO-LOC-CBSAX
094200     END-IF.
094300
094400     IF P-NEW-GEO-LOC-MSAX = SPACES
094500        MOVE ZEROS TO P-NEW-GEO-LOC-MSAX
094600     END-IF.
094700
094800*-----------------------------------------------------*
094900***  CALL LATEST LTDRVYYV PROGRAM                     *
095000*-----------------------------------------------------*
095100     CALL LTDRV202 USING BILL-NEW-DATA
095200                         PPS-DATA-ALL
095300                         PPS-CBSA
095400                         PPS-PAYMENT-DATA
095500                         PRICER-OPT-VERS-SW
095600                         PROV-NEW-HOLD
095700                         CBSA-WI-TABLE
095800                         IPPS-CBSA-WI-TABLE
095900                         MSA-WI-TABLE
096000                         WORK-COUNTERS.
096100
096200     GOBACK.
096300
096400
096500******************************************************************
096600 1200-GET-THIS-PROVIDER.
096700******************************************************************
096800*    ON A PROVIDER BREAK:                                        *
096900*        FIND THE NEW PROVIDER SPECIFIC DATA ELEMENTS            *
097000*    NOTE: IF BILLS ARE SORTED/BATCHED BY PROVIDER, FEWER        *
097100*             TABLE SEARCHES WILL BE NECESSARY.                  *
097200******************************************************************
097300*    IF B-PROVIDER-NO NOT = P-NEW-PROVIDER-NO
097400*       SEARCH ALL PROV-ENTRIES
097500        SET PX1 TO 1.
097600        SEARCH PROV-ENTRIES
097700          AT END
097800             MOVE 59 TO PPS-RTC
097900             GO TO 1200-EXIT
098000          WHEN PROV-NO (PX1) = B-PROVIDER-NO
098100             MOVE 00 TO PPS-RTC
098200             MOVE PROV-DATA1 (PX1) TO PROV-NEWREC-HOLD1
098300             SET PD2 TO PX1
098400             SET PD3 TO PX1
098500             MOVE PROV-DATA2 (PD2) TO PROV-NEWREC-HOLD2
098600             MOVE PROV-DATA3 (PD3) TO PROV-NEWREC-HOLD3
098700             PERFORM 1300-GET-CURR-PROV THRU 1300-EXIT
098800               VARYING PX1 FROM PX1 BY 1
098900                 UNTIL PROV-NO (PX1) NOT = B-PROVIDER-NO
099000                   OR PROV-NO (PX1) = '999999'.
099100
099200 1200-EXIT.
099300      EXIT.
099400
099500
099600******************************************************************
099700 1300-GET-CURR-PROV.
099800******************************************************************
099900     IF  B-DISCHARGE-DATE NOT < PROV-EFF-DATE (PX1)
100000         MOVE PROV-DATA1 (PX1) TO PROV-NEWREC-HOLD1
100100         SET PD2 TO PX1
100200         SET PD3 TO PX1
100300         MOVE PROV-DATA2 (PD2) TO PROV-NEWREC-HOLD2
100400         MOVE PROV-DATA3 (PD3) TO PROV-NEWREC-HOLD3
100500     END-IF.
100600
100700
100800 1300-EXIT.
100900      EXIT.
101000
101100
101200******************************************************************
101300 1500-LOAD-ALL-TABLES.
101400******************************************************************
101500*    THE FIRST TIME CALLED:                                      *
101600*        LOAD THE PROVIDER SPECIFIC TABLE SUPPLIED BY            *
101700*             THE INTERMEDIARY/USER.                             *
101800*        LOAD MSA, CBSA, & IPPS CBSA TABLES SUPPLIED BY CMS      *
101900******************************************************************
102000     MOVE ALL '9' TO PROV-NEW-HOLD.
102100     MOVE ALL '9' TO PROV-TABLE.
102200     MOVE ALL '9' TO PROV-DATA-2.
102300     MOVE ALL '9' TO PROV-DATA-3.
102400     OPEN INPUT PROV-FILE.
102500     MOVE 0 TO EOF-SW.
102600     SET PX1 TO EOF-SW.
102700
102800*----------------------------------------------------*
102900* LOAD THE PROVIDER TABLE                            *
103000*----------------------------------------------------*
103100     PERFORM 1600-READ-PROV-FILE THRU 1600-EXIT
103200             UNTIL EOF-SW = 1.
103300     CLOSE PROV-FILE.
103400
103500*----------------------------------------------------*
103600* LOAD THE MSA TABLE                                 *
103700*----------------------------------------------------*
103800     MOVE HIGH-VALUES TO MSA-WI-TABLE.
103900     PERFORM 1700-LOAD-MSAX-FILE THRU 1700-EXIT.
104000
104100*----------------------------------------------------*
104200* LOAD THE CBSA TABLE                                *
104300*----------------------------------------------------*
104400     MOVE HIGH-VALUES TO CBSA-WI-TABLE.
104500     PERFORM 1750-LOAD-CBSAX-FILE THRU 1750-EXIT.
104600
104700*----------------------------------------------------*
104800* LOAD THE IPPS CBSA TABLE                           *
104900*----------------------------------------------------*
105000     MOVE HIGH-VALUES TO IPPS-CBSA-WI-TABLE.
105100     PERFORM 1775-LOAD-IPPS-CBSAX-FILE THRU 1775-EXIT.
105200
105300
105400
105500 1500-EXIT.
105600      EXIT.
105700
105800
105900******************************************************************
106000 1600-READ-PROV-FILE.
106100******************************************************************
106200     READ PROV-FILE
106300         AT END
106400             SET PX1 UP BY 1
106500             MOVE ALL '9' TO PROV-DATA1 (PX1)
106600             SET PD2 TO PX1
106700             SET PD3 TO PX1
106800             MOVE ALL '9' TO PROV-DATA2 (PD2)
106900             MOVE ALL '9' TO PROV-DATA3 (PD3)
107000             MOVE 1 TO EOF-SW
107100*            DISPLAY 'NUMBER OF PROVIDERS   = ' PROV-CNT
107200             .
107300
107400     IF  EOF-SW = 0
107500         ADD 1 TO PROV-CNT
107600         SET PX1 UP BY 1
107700         MOVE PROV-PART1 TO PROV-DATA1 (PX1)
107800         SET PD2 TO PX1
107900         SET PD3 TO PX1
108000         MOVE PROV-PART2 TO PROV-DATA2 (PD2)
108100         MOVE PROV-PART3 TO PROV-DATA3 (PD3)
108200     END-IF.
108300
108400 1600-EXIT.
108500      EXIT.
108600
108700
108800******************************************************************
108900 1700-LOAD-MSAX-FILE.
109000******************************************************************
109100     OPEN INPUT MSAX-FILE.
109200     MOVE 0 TO EOF-SW.
109300     SET MU1 TO EOF-SW.
109400
109500     PERFORM 1800-READ-MSAX-FILE THRU 1800-EXIT
109600                      UNTIL EOF-SW = 1.
109700     CLOSE MSAX-FILE.
109800
109900 1700-EXIT.
110000      EXIT.
110100
110200
110300******************************************************************
110400 1750-LOAD-CBSAX-FILE.
110500******************************************************************
110600     OPEN INPUT CBSAX-FILE.
110700     MOVE 0 TO EOF-SW.
110800     SET CU1 TO EOF-SW.
110900
111000     PERFORM 1850-READ-CBSAX-FILE THRU 1850-EXIT
111100                      UNTIL EOF-SW = 1.
111200     CLOSE CBSAX-FILE.
111300
111400 1750-EXIT.
111500      EXIT.
111600
111700
111800******************************************************************
111900 1775-LOAD-IPPS-CBSAX-FILE.
112000******************************************************************
112100     OPEN INPUT IPPS-CBSAX-FILE.
112200     MOVE 0 TO EOF-SW.
112300     SET MA3 TO EOF-SW.
112400
112500     PERFORM 1875-READ-IPPS-CBSAX-FILE THRU 1875-EXIT
112600                      UNTIL EOF-SW = 1.
112700     CLOSE IPPS-CBSAX-FILE.
112800
112900 1775-EXIT.
113000      EXIT.
113100
113200
113300******************************************************************
113400 1800-READ-MSAX-FILE.
113500******************************************************************
113600     READ MSAX-FILE
113700         AT END
113800             MOVE 1 TO EOF-SW
113900*            DISPLAY 'NUMBER OF MSA RECORDS = ' MSA-CNT
114000             .
114100
114200     IF EOF-SW = 0
114300        ADD 1 TO MSA-CNT
114400        SET MU1 UP BY 1
114500        MOVE X-MSA-X         TO MSAX-MSA         (MU1)
114600        MOVE XE-DATE-M       TO MSAX-EFF-DATE    (MU1)
114700        MOVE X-WAGE-INDEX1-M TO MSAX-WAGE-INDEX1 (MU1)
114800        MOVE X-WAGE-INDEX2-M TO MSAX-WAGE-INDEX2 (MU1)
114900        MOVE X-WAGE-INDEX3-M TO MSAX-WAGE-INDEX3 (MU1)
115000     END-IF.
115100
115200 1800-EXIT.
115300      EXIT.
115400
115500
115600******************************************************************
115700 1850-READ-CBSAX-FILE.
115800******************************************************************
115900     READ CBSAX-FILE
116000         AT END
116100             MOVE 1 TO EOF-SW
116200*            DISPLAY 'NUMBER OF CBSA RECORDS = ' CBSA-CNT
116300             .
116400
116500     IF EOF-SW = 0
116600        ADD 1 TO CBSA-CNT
116700        SET CU1 UP BY 1
116800        MOVE X-CBSA-X        TO CBSAX-CBSA        (CU1)
116900        MOVE XE-DATE-C       TO CBSAX-EFF-DATE    (CU1)
117000        MOVE X-WAGE-INDEX1-C TO CBSAX-WAGE-INDEX1 (CU1)
117100        MOVE X-WAGE-INDEX2-C TO CBSAX-WAGE-INDEX2 (CU1)
117200        MOVE X-WAGE-INDEX3-C TO CBSAX-WAGE-INDEX3 (CU1)
117300     END-IF.
117400
117500 1850-EXIT.
117600      EXIT.
117700
117800
117900******************************************************************
118000 1875-READ-IPPS-CBSAX-FILE.
118100******************************************************************
118200     READ IPPS-CBSAX-FILE
118300         AT END
118400             MOVE 1 TO EOF-SW
118500*            DISPLAY 'NUMBER OF IP CBSA RECORDS = ' IPPS-CBSA-CNT
118600             .
118700
118800     IF EOF-SW = 0
118900        ADD 1 TO IPPS-CBSA-CNT
119000        SET MA3 UP BY 1
119100        MOVE F-CBSA            TO T-CBSA            (MA3)
119200        MOVE F-CBSA-SIZE       TO T-CBSA-SIZE       (MA3)
119300        MOVE F-CBSA-EFF-DATE   TO T-CBSA-EFF-DATE   (MA3)
119400        MOVE F-CBSA-WAGE-INDX1 TO T-CBSA-WAGE-INDX1 (MA3)
119500        MOVE F-CBSA-WAGE-INDX2 TO T-CBSA-WAGE-INDX2 (MA3)
119600     END-IF.
119700
119800 1875-EXIT.
119900      EXIT.
120000
120100
120200******************************************************************
120300 1900-OPTION-SW-A.
120400******************************************************************
120500     MOVE ALL '9' TO PROV-NEW-HOLD.
120600     MOVE PROV-RECORD-FROM-USER TO PROV-NEW-HOLD.
120700
120800     IF TABLES-LOADED-SW = 0
120900
121000*---------------------------------------------------------------*
121100*      MOVE THE MSA FILE FROM USER INTO MSA TABLE               *
121200*---------------------------------------------------------------*
121300          MOVE HIGH-VALUES                TO MSA-WI-TABLE
121400          MOVE MSAX-TABLE-FROM-USER       TO MSA-WI-TABLE
121500
121600*---------------------------------------------------------------*
121700*      MOVE THE CBSA FILE FROM USER INTO CBSA TABLE             *
121800*---------------------------------------------------------------*
121900          MOVE HIGH-VALUES                TO CBSA-WI-TABLE
122000          MOVE CBSAX-TABLE-FROM-USER      TO CBSA-WI-TABLE
122100
122200*---------------------------------------------------------------*
122300*      MOVE THE IPPS CBSA FILE FROM USER INTO CBSA TABLE        *
122400*---------------------------------------------------------------*
122500          MOVE HIGH-VALUES                TO IPPS-CBSA-WI-TABLE
122600          MOVE IPPS-CBSAX-TABLE-FROM-USER TO IPPS-CBSA-WI-TABLE
122700
122800          MOVE 1 TO TABLES-LOADED-SW
122900
123000     END-IF.
123100
123200
123300 1900-EXIT.
123400      EXIT.
123500
123600
123700******************************************************************
123800 2000-OPTION-SW-P.
123900******************************************************************
124000     MOVE ALL '9' TO PROV-NEW-HOLD.
124100     MOVE PROV-RECORD-FROM-USER TO PROV-NEW-HOLD.
124200
124300     IF TABLES-LOADED-SW = 0
124400*---------------------------------------------------------*
124500*      LOAD MSA TABLE                                     *
124600*---------------------------------------------------------*
124700          MOVE HIGH-VALUES TO MSA-WI-TABLE
124800          PERFORM 1700-LOAD-MSAX-FILE THRU 1700-EXIT
124900
125000*---------------------------------------------------------*
125100*      LOAD CBSA TABLE                                    *
125200*---------------------------------------------------------*
125300          MOVE HIGH-VALUES TO CBSA-WI-TABLE
125400          PERFORM 1750-LOAD-CBSAX-FILE THRU 1750-EXIT
125500
125600*---------------------------------------------------------*
125700*      LOAD IPPS CBSA TABLE                               *
125800*---------------------------------------------------------*
125900          MOVE HIGH-VALUES TO IPPS-CBSA-WI-TABLE
126000          PERFORM 1775-LOAD-IPPS-CBSAX-FILE THRU 1775-EXIT
126100
126200          MOVE 1 TO TABLES-LOADED-SW
126300
126400     END-IF.
126500
126600
126700 2000-EXIT.
126800      EXIT.
126900
127000
127100******************************************************************
127200 2100-OPTION-SW.
127300******************************************************************
127400     IF  TABLES-LOADED-SW = 0
127500         PERFORM 1500-LOAD-ALL-TABLES THRU 1500-EXIT
127600         MOVE 1 TO TABLES-LOADED-SW
127700     END-IF.
127800
127900 2100-EXIT.
128000      EXIT.
128100
128200*********************  END OF PROGRAM   **************************
