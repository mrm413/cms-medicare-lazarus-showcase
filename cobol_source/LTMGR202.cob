000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID.         LTMGR202.
000300*AUTHOR.             CMS
000400 DATE-COMPILED.
000500 ENVIRONMENT DIVISION.
000600 CONFIGURATION SECTION.
000700 SOURCE-COMPUTER.                IBM-370.
000800 OBJECT-COMPUTER.                IBM-370.
000900
001000******************************************************
001100*
001200* THIS PROGRAM RUNS THE LONG-TERM CARE PPS PRICER
001300* MODULES FOR TESTING PURPOSES.
001400*
001500*----------------------------------------------------
001600* CHANGE LOG
001700*----------------------------------------------------
001800*
001900* 04/22/2005 - PPS-CBSA ADDED TO ACCOMODATE THE
002000*              JULY 1, 2005 CHANGE FROM MSA TO CBSA
002100*              BASED WAGE INDICES
002200*
002300*----------------------------------------------------
002400*
002500* 05/02/2005 - ADDED PSF FIELDS - SPECIAL PAY IND &
002600*              SPECIAL WAGE INDEX
002700*
002800*----------------------------------------------------
002900*
003000* 09/28/2005 - PROGRAM NAME CHANGED FROM LTDRIVER TO
003100*              LTMGR___
003200*
003300*----------------------------------------------------
003400*
003500* 01/17/2006 - PROGRAM PREPARED FOR APRIL 2006
003600*              CICS RELEASE
003700*
003800*----------------------------------------------------
003900*
004000* 01/19/2006 - CALLED PROGRAM CHANGED TO LTOPN___
004100*
004200*----------------------------------------------------
004300*
004400* 05/03/2006 - ADDED IPPS-CBSAX RECORD TO OPTION 4
004500*              OF LTOPN___ CALL
004600*
004700*----------------------------------------------------
004800*
004900* 06/19/2006 - VERSION CHANGED FROM 07.0 TO 07.1
005000*
005100*
005200*----------------------------------------------------
005300*
005400* 08/09/2006 - UPDATED FOR OCTOBER 2006 VERSION 07.3
005500*
005600*
005700*----------------------------------------------------
005800*
005900* 09/06/2006 - UPDATED FOR OCTOBER 2006 VERSION 07.4
006000*
006100*----------------------------------------------------
006200*
006300* 11/16/2006 - CREATED VERSION 07.5 FOR OCTOBER 2006
006400*              DUE TO CORRECTION OF THE IME
006500*              MULTIPLIER USED IN THE 4TH SSO
006600*              PROVISION (IPPS PORTION), IPPS WAGE
006700*              INDEX CHANGE & REMOVAL OF PPS-RTC 23
006800*
006900*----------------------------------------------------
007000*
007100* 12/28/2006 - CREATED VERSION 07.6 FOR OCTOBER 2006
007200*              DUE TO CBSA SIZE LOGIC CORRECTION
007300*              ** THIS VERSION WAS NOT RELEASED **
007400*
007500*----------------------------------------------------
007600*
007700* 05/03/2007 - UPDATED FOR JULY 2007 VERSION 08.0
007800*
007900*----------------------------------------------------
008000*
008100* 08/13/2007 - UPDATED FOR OCTOBER 2007 VERSION 08.1
008200*
008300*----------------------------------------------------
008400*
008500* 08/23/2007 - UPDATED FOR OCTOBER 2007 VERSION 08.2
008600*              (FOR REVISED IPPS RATES & WAGE INDEX)
008700*
008800*----------------------------------------------------
008900*
009000* 09/14/2007 - UPDATED FOR OCTOBER 2007 VERSION 08.3
009100*              (FOR REVISED IPPS RATES & WAGE INDEX)
009200*
009300*----------------------------------------------------
009400*
009500* 09/28/2007 - UPDATED FOR OCTOBER 2007 VERSION 08.4
009600*              (FOR REVISED IPPS RATES)
009700*
009800*----------------------------------------------------
009900*
010000* 12/27/2007 - UPDATED FOR OCTOBER 2007 VERSION 08.5
010100*              (FOR REVISED SHORT STAY OUTLIER LOGIC)
010200*
010300*----------------------------------------------------
010400*
010500* 02/06/2008 - UPDATE FOR OCTOBER 2007 VERSION 08.6
010600*              (FOR REVISED STANDARD FEDERAL RATE &
010700*               FIXED LOSS AMOUNT FOR APRIL 2008)
010800*
010900*----------------------------------------------------
011000*
011100* 05/08/2008 - CREATED VERSION 09.0 FOR JULY 2008
011200*              (FOR NEW RATE YEAR 2009, STILL FY2008)
011300*
011400*----------------------------------------------------
011500*
011600* 05/19/2008 - CREATED VERSION 09.1 FOR JULY 2008
011700*              REVISED IPPS PUERTO RICO RATES
011800*              EFFECTIVE RETROACTIVE TO 10/01/2007
011900*
012000*----------------------------------------------------
012100*
012200* 08/11/2008 - CREATED VERSION 09.2 FOR OCTOBER 2008
012300*              (FOR RATE YEAR 2009, FY 2009)
012400*              ADDED FIELD P-VAL-BASED-PURCH-SCORE
012500*              TO THE PSF (TO BE USED IN IPPS 1/1/08)
012600*
012700*----------------------------------------------------
012800*
012900* 09/09/2008 - CREATED VERSION 09.3 FOR OCTOBER 2008
013000*              (FOR RATE YEAR 2009, FY 2009)
013100*
013200*----------------------------------------------------
013300*
013400* 02/17/2009 - CREATED VERSION 09.4 FOR OCTOBER 2008
013500*              (FOR RATE YEAR 2009, FY 2009)
013600*
013700*----------------------------------------------------
013800*
013900* 05/18/2009 - CREATED VERSION 09.5 FOR JUN-SEPT '09
014000*              (FOR RATE YEAR 2009, FY 2009)
014100*
014200*----------------------------------------------------
014300*
014400* 08/05/2009 - CREATED VERSION 10.0 FOR OCTOBER 2009
014500*              (FOR RATE YEAR 2010, FY 2010)
014600*
014700*----------------------------------------------------
014800*
014900* 09/03/2009 - CREATED VERSION 10.1 FOR OCTOBER 2009
015000*              (FOR RATE YEAR 2010, FY 2010)
015100*
015200*----------------------------------------------------
015300*
015400* 11/11/2009 - CREATED VERSION 10.2 FOR OCTOBER 2009
015500*              (FOR RATE YEAR 2010, FY 2010)
015600*
015700*----------------------------------------------------
015800*
015900* 04/07/2010 - CREATED VERSION 10.3 FOR OCTOBER 2009
016000*              (FOR RATE YEAR 2010, FY 2010)
016100*
016200*----------------------------------------------------
016300*
016400* 04/19/2010 - CREATED VERSION 10.4 FOR OCTOBER 2009
016500*              (FOR RATE YEAR 2010, FY 2010)
016600*
016700*----------------------------------------------------
016800*
016900* 08/04/2010 - CREATED VERSION 11.0 FOR OCTOBER 2010
017000*              (FOR RATE YEAR 2011, FY 2011)
017100*
017200*----------------------------------------------------
017300*
017400* 10/20/2010 - CREATED VERSION 11.1 FOR OCTOBER 2010
017500*              ALLOWS CLAIMS WITH DATES OF SERVICE
017600*              OLDER THAN 5 YEARS
017700*
017800*----------------------------------------------------
017900*
018000* 08/01/2011 - CREATED VERSION 12.0 FOR OCTOBER 2011
018100*              (FOR RATE YEAR 2012, FY 2012)
018200*
018300*----------------------------------------------------
018400*
018500* 08/31/2011 - CREATED VERSION 12.1 FOR OCTOBER 2011
018600*              (FOR RATE YEAR 2012, FY 2012)
018700*
018800*----------------------------------------------------
018900*
019000* 10/28/2011 - CREATED VERSION 12.2 FOR OCTOBER 2011
019100*              (FOR RATE YEAR 2012, FY 2012)
019200*
019300*----------------------------------------------------
019400*
019500* 12/09/2011 - CREATED VERSION 12.3 FOR OCTOBER 2011
019600*              (FOR RATE YEAR 2012, FY 2012)
019700*
019800*----------------------------------------------------
019900*
020000* 07/31/2012 - CREATED VERSION 13.0 FOR OCTOBER 2012
020100*              (FOR RATE YEAR 2013, FY 2013)
020200*
020300*----------------------------------------------------
020400*
020500* 08/09/2013 - CREATED VERSION 14.0 FOR OCTOBER 2013
020600*              (FOR RATE YEAR 2014, FY 2014)
020700*            - ADDED HOSPITAL QUALITY INDICATOR TO
020800*              TO PSF
020900*
021000*----------------------------------------------------
021100*
021200* 09/04/2013 - CREATED VERSION 14.1 TO INCORPORATE
021300*              CHANGES TO WAGE INDEX TABLES FOR
021400*              LTCH AND IPPS
021500*
021600*
021700*----------------------------------------------------
021800*
021900* 08/07/2014 - CREATED VERSION 15.0
022000*
022100*----------------------------------------------------
022200*
022300* 09/03/2014 - CREATED VERSION 15.1
022400*
022500* 03/20/15 - VERSION 15.3 CREATED TO ADD NEW DATA NAMES
022600*
022700* 06/29/15 - VERSION 16.B CREATED TO TEST LOGIC CHANGES
022800*
022900* 08/05/15 - VERSION 16.0 CREATED TO TEST LOGIC CHANGES
023000*
023100* 11/25/15 - VERSION 16.C CREATED TO TEST UPDATED INTERFACE
023200*            (BILL-NEW-DATA - ADDED COST REPORT DAYS) &
023300*            LOGIC
023400*
023500* 12/11/15 - VERSION 16.1 TO IMPLEMENT CR9401 ON 4/1/16
023600*
023700* 01/08/16 - VERSION 16.2
023800*
023900* 5-23-16 - VERSION 17.B
024000* 7-18-16 - VERSION 17.0
024100* 8-9-17 - VERSION 18.0
024200* 10-13-17 - VERSION 18.2
024300* 2-8-18 - VERSION 18.3
024400* 7-30-18 - VERSION 19.0
024500* 8-1-19 - VERSION 20.0
024600* 3-4-20 - VERSION 20.1
024600* 4-3-20 - VERSION 20.2
024700*******************************************************
024800
024900 INPUT-OUTPUT SECTION.
025000 FILE-CONTROL.
025100
025200     SELECT BILLFILE   ASSIGN TO UT-S-SYSUT1
025300         FILE STATUS IS UT1-STAT.
025400     SELECT PRTOPER    ASSIGN TO UT-S-PRTOPER
025500         FILE STATUS IS OPR-STAT.
025600
025700 DATA DIVISION.
025800 FILE SECTION.
025900 FD  BILLFILE
026000     LABEL RECORDS ARE STANDARD
026100     RECORDING MODE IS F
026200     BLOCK CONTAINS 0 RECORDS.
026300 01  BILL-REC                    PIC X(422).
026400
026500 FD  PRTOPER
026600     RECORDING MODE IS F
026700     BLOCK CONTAINS 133 RECORDS
026800     LABEL RECORDS ARE STANDARD.
026900 01  PRTOPER-LINE                PIC X(133).
027000
027100 WORKING-STORAGE SECTION.
027200 77  W-STORAGE-REF               PIC X(51)  VALUE
027300     'L T C M A N A G E R - W O R K I N G   S T O R A G E'.
027400 01  PPMGR-VERSION               PIC X(05)  VALUE 'M20.2'.
027500 01  LTOPN202                    PIC X(08)  VALUE 'LTOPN202'.
027600 01  EOF-SW                      PIC 9(01)  VALUE 0.
027700 01  OPERLINE-CTR                PIC 9(02)  VALUE 65.
027800 01  UT1-STAT.
027900     05  UT1-STAT1               PIC X.
028000     05  UT1-STAT2               PIC X.
028100 01  OPR-STAT.
028200     05  OPR-STAT1               PIC X.
028300     05  OPR-STAT2               PIC X.
028400*******************************************************
028500*******************************************************
028600*    MILLENNIUM BILL RECORD FORMAT                    *
028700*******************************************************
028800 01  BILL-WORK.
028900     05  BILL-NPI10.
029000         10  BILL-NPI8                 PIC X(08).
029100         10  BILL-NPI-FILLER           PIC X(02).
029200     05  BILL-PROVIDER-N.
029300         10  FILLER                    PIC X(02).
029400         10  BILL-LTC-PROV             PIC X(04).
029500     05  BILL-PATIENT-STATUS           PIC X(02).
029600     05  BILL-DRG-CODE                 PIC X(03).
029700     05  BILL-LOS                      PIC 9(03).
029800     05  BILL-COV-DAYS                 PIC 9(03).
029900     05  BILL-LTR-DAYS                 PIC 9(02).
030000     05  BILL-CST-RPT-DAYS             PIC 9(03).
030100     05  BILL-DISCHARGE-DATE.
030200         10  BILL-DISCHG-CC            PIC 9(02).
030300         10  BILL-DISCHG-YY            PIC 9(02).
030400         10  BILL-DISCHG-MM            PIC 9(02).
030500         10  BILL-DISCHG-DD            PIC 9(02).
030600     05  BILL-COV-CHARGES              PIC 9(07)V9(02).
030700     05  BILL-SPEC-PAY-IND             PIC X(01).
030800     05  BILL-REVIEW-CODE              PIC 9(02).
030900     05  BILL-DIAGNOSIS-CODE-TABLE.
031000         10  BILL-DIAGNOSIS-CODE    PIC X(07) OCCURS 25 TIMES
031100                                     INDEXED BY IDX-DIAG.
031200     05  BILL-PROCEDURE-CODE-TABLE.
031300         10 BILL-PROCEDURE-CODE     PIC X(07) OCCURS 25 TIMES
031400                                     INDEXED BY IDX-PROC.
031500     05  FILLER                       PIC X(20).
031600
031700*******************************************************
031800*    RETURNED BY LTOPN___                             *
031900*******************************************************
032000  01  PPS-DATA-ALL.
032100      05  PPS-RTC                      PIC X(02).
032200      05  PPS-CHRG-THRESHOLD           PIC 9(07)V9(02).
032300      05  PPS-DATA.
032400         10  PPS-MSA                   PIC X(04).
032500         10  PPS-WAGE-INDEX            PIC 9(02)V9(04).
032600         10  PPS-AVG-LOS               PIC 9(02)V9(01).
032700         10  PPS-RELATIVE-WGT          PIC 9(01)V9(04).
032800         10  PPS-OUTLIER-PAY-AMT       PIC 9(07)V9(02).
032900         10  PPS-LOS                   PIC 9(03).
033000         10  PPS-DRG-ADJ-PAY-AMT       PIC 9(07)V9(02).
033100         10  PPS-FED-PAY-AMT           PIC 9(07)V9(02).
033200         10  PPS-FINAL-PAY-AMT         PIC 9(07)V9(02).
033300         10  PPS-FAC-COSTS             PIC 9(07)V9(02).
033400         10  PPS-NEW-FAC-SPEC-RATE     PIC 9(07)V9(02).
033500         10  PPS-OUTLIER-THRESHOLD     PIC 9(07)V9(02).
033600         10  PPS-SUBM-DRG-CODE         PIC X(03).
033700         10  PPS-CALC-VERS-CD          PIC X(05).
033800         10  PPS-REG-DAYS-USED         PIC 9(03).
033900         10  PPS-LTR-DAYS-USED         PIC 9(03).
034000         10  PPS-BLEND-YEAR            PIC 9(01).
034100         10  PPS-COLA                  PIC 9(01)V9(03).
034200         10  FILLER                    PIC X(04).
034300      05  PPS-OTHER-DATA.
034400         10  PPS-NAT-LABOR-PCT         PIC 9(01)V9(05).
034500         10  PPS-NAT-NONLABOR-PCT      PIC 9(01)V9(05).
034600         10  PPS-STD-FED-RATE          PIC 9(05)V9(02).
034700         10  PPS-BDGT-NEUT-RATE        PIC 9(01)V9(03).
034710         10  PPS-IPTHRESH              PIC 9(03)V9(01).
034720         10  PPS-LTCH-DPP-ADJ-AMT      PIC S9(09)V99.
034800         10  FILLER                    PIC X(05).
034900      05  PPS-PC-DATA.
035000         10  PPS-COT-IND               PIC X(01).
035100         10  FILLER                    PIC X(20).
035200
035300  01  PPS-CBSA                         PIC X(05).
035400
035500  01  PPS-PAYMENT-DATA.
035600      05  PPS-SITE-NEUTRAL-COST-PMT    PIC 9(07)V99.
035700      05  PPS-SITE-NEUTRAL-IPPS-PMT    PIC 9(07)V99.
035800      05  PPS-STANDARD-FULL-PMT        PIC 9(07)V99.
035900      05  PPS-STANDARD-SSO-PMT         PIC 9(07)V99.
036000
036100*******************************************************
036200*    PASSED TO LTOPN___     MILLENNIUM                *
036300*******************************************************
036400 01  BILL-NEW-DATA.
036500     05  B-NPI10.
036600         10  B-NPI8                   PIC X(08).
036700         10  B-NPI-FILLER             PIC X(02).
036800     05  B-PROVIDER-NO                PIC X(06).
036900     05  B-PATIENT-STATUS             PIC X(02).
037000     05  B-DRG-CODE                   PIC X(03).
037100     05  B-LOS                        PIC 9(03).
037200     05  B-COV-DAYS                   PIC 9(03).
037300     05  B-LTR-DAYS                   PIC 9(02).
037400     05  B-CST-RPT-DAYS               PIC 9(03).
037500     05  B-DISCHARGE-DATE.
037600         10  B-DISCHG-CC              PIC 9(02).
037700         10  B-DISCHG-YY              PIC 9(02).
037800         10  B-DISCHG-MM              PIC 9(02).
037900         10  B-DISCHG-DD              PIC 9(02).
038000     05  B-COV-CHARGES                PIC 9(07)V9(02).
038100     05  B-SPEC-PAY-IND               PIC X(01).
038200     05  B-REVIEW-CODE                PIC 9(02).
038300     05  B-DIAGNOSIS-CODE-TABLE.
038400         10  B-DIAGNOSIS-CODE         PIC X(07) OCCURS 25 TIMES
038500                                      INDEXED BY IDX-DIAG.
038600     05  B-PROCEDURE-CODE-TABLE.
038700         10 B-PROCEDURE-CODE          PIC X(07) OCCURS 25 TIMES
038800                                      INDEXED BY IDX-PROC.
038900     05  B-LTCH-DPP-INDICATOR-SW      PIC X.
039000         88 B-LTCH-DPP-ADJUSTMENT     VALUE 'Y'.
039100     05  FILLER                       PIC X(19).
039200
039300*******************************************************
039400*    PASSED TO LTOPN___                               *
039500*******************************************************
039600 01  PRICER-OPT-VERS-SW.
039700     02  PRICER-OPTION-SW        PIC X.
039800     02  PPS-VERSIONS.
039900         10  PPDRV-VERSION       PIC X(05).
040000
040100*******************************************************
040200*    CAN BE PASSED TO LTOPN___                        *
040300*******************************************************
040400 01  PROV-RECORD-FROM-USER.
040500    02  W-PROV-NEWREC-HOLD1.
040600        05  W-P-NEW-NPI10.
040700            10  W-P-NEW-NPI8           PIC X(08).
040800            10  W-P-NEW-NPI-FILLER     PIC X(02).
040900        05  W-P-NEW-PROVIDER-OSCAR-NO.
041000            10  W-P-NEW-STATE            PIC 9(02).
041100            10  W-P-NEW-STATE-X REDEFINES
041200                W-P-NEW-STATE            PIC X(02).
041300            10  FILLER                   PIC X(04).
041400        05  W-P-NEW-DATE-DATA.
041500            10  W-P-NEW-EFF-DATE.
041600                15  W-P-NEW-EFF-DT-CC    PIC 9(02).
041700                15  W-P-NEW-EFF-DT-YY    PIC 9(02).
041800                15  W-P-NEW-EFF-DT-MM    PIC 9(02).
041900                15  W-P-NEW-EFF-DT-DD    PIC 9(02).
042000            10  W-P-NEW-FY-BEGIN-DATE.
042100                15  W-P-NEW-FY-BEG-DT-CC PIC 9(02).
042200                15  W-P-NEW-FY-BEG-DT-YY PIC 9(02).
042300                15  W-P-NEW-FY-BEG-DT-MM PIC 9(02).
042400                15  W-P-NEW-FY-BEG-DT-DD PIC 9(02).
042500            10  W-P-NEW-REPORT-DATE.
042600                15  W-P-NEW-REPORT-DT-CC PIC 9(02).
042700                15  W-P-NEW-REPORT-DT-YY PIC 9(02).
042800                15  W-P-NEW-REPORT-DT-MM PIC 9(02).
042900                15  W-P-NEW-REPORT-DT-DD PIC 9(02).
043000            10  W-P-NEW-TERMINATION-DATE.
043100                15  W-P-NEW-TERM-DT-CC   PIC 9(02).
043200                15  W-P-NEW-TERM-DT-YY   PIC 9(02).
043300                15  W-P-NEW-TERM-DT-MM   PIC 9(02).
043400                15  W-P-NEW-TERM-DT-DD   PIC 9(02).
043500        05  W-P-NEW-WAIVER-CODE          PIC X(01).
043600            88  W-P-NEW-WAIVER-STATE       VALUE 'Y'.
043700        05  W-P-NEW-INTER-NO             PIC X(05).
043800        05  W-P-NEW-PROVIDER-TYPE        PIC X(02).
043900        05  W-P-NEW-CURRENT-CENSUS-DIV   PIC X(01).
044000        05  W-P-NEW-MSA-DATA.
044100            10  W-P-NEW-CHG-CODE-INDEX    PIC X.
044200            10  W-P-NEW-GEO-LOC-MSA        PIC X(04) JUST RIGHT.
044300            10  W-P-NEW-WAGE-INDEX-LOC-MSA PIC X(04) JUST RIGHT.
044400            10  W-P-NEW-STAND-AMT-LOC-MSA  PIC X(04) JUST RIGHT.
044500            10  W-P-NEW-STAND-AMT-LOC-MSA9
044600                REDEFINES W-P-NEW-STAND-AMT-LOC-MSA.
044700                15  W-P-NEW-RURAL-1ST.
044800                    20  W-P-NEW-STAND-RURAL  PIC XX.
044900                15  W-P-NEW-RURAL-2ND        PIC XX.
045000        05  W-P-NEW-SOL-COM-DEP-HOSP-YR PIC XX.
045100        05  W-P-NEW-LUGAR               PIC X.
045200        05  W-P-NEW-TEMP-RELIEF-IND     PIC X.
045300        05  W-P-NEW-FED-PPS-BLEND-IND   PIC X.
045400        05  W-P-NEW-STATE-CODE          PIC 9(02).
045500        05  W-P-NEW-STATE-CODE-X REDEFINES
045600              W-P-NEW-STATE-CODE        PIC X(02).
045700        05  FILLER                      PIC X(03).
045800     02  W-PROV-NEWREC-HOLD2.
045900        05  W-P-NEW-VARIABLES.
046000            10  W-P-NEW-FAC-SPEC-RATE     PIC  X(07).
046100            10  W-P-NEW-COLA              PIC  X(04).
046200            10  W-P-NEW-INTERN-RATIO      PIC  X(05).
046300            10  W-P-NEW-BED-SIZE          PIC  X(05).
046400            10  W-P-NEW-CCR               PIC  X(04).
046500            10  W-P-NEW-CMI               PIC  X(05).
046600            10  W-P-NEW-SSI-RATIO         PIC  X(04).
046700            10  W-P-NEW-MEDICAID-RATIO    PIC  X(04).
046800            10  W-P-NEW-PPS-BLEND-YR-IND  PIC  X(01).
046900            10  W-P-NEW-PRUP-UPDTE-FACTOR PIC  9(01)V9(05).
047000            10  W-P-NEW-DSH-PERCENT       PIC  V9(04).
047100            10  W-P-NEW-FYE-DATE.
047200                15  W-P-NEW-FYE-CC        PIC 99.
047300                15  W-P-NEW-FYE-YY        PIC 99.
047400                15  W-P-NEW-FYE-MM        PIC 99.
047500                15  W-P-NEW-FYE-DD        PIC 99.
047600        05  W-P-NEW-SPECIAL-PAY-IND       PIC X(01).
047700        05  W-P-NEW-HOSP-QUAL-IND         PIC X(01).
047800        05  W-P-NEW-GEO-LOC-CBSAX         PIC X(05).
047900        05  W-P-NEW-GEO-LOC-CBSA9 REDEFINES
048000                        W-P-NEW-GEO-LOC-CBSAX PIC 9(05).
048100        05  W-P-NEW-GEO-LOC-CBSA-AST REDEFINES
048200                        W-P-NEW-GEO-LOC-CBSAX.
048300            10 W-P-NEW-GEO-LOC-CBSA-1ST   PIC X.
048400            10 W-P-NEW-GEO-LOC-CBSA-2ND   PIC X.
048500            10 W-P-NEW-GEO-LOC-CBSA-3RD   PIC X.
048600            10 W-P-NEW-GEO-LOC-CBSA-4TH   PIC X.
048700            10 W-P-NEW-GEO-LOC-CBSA-5TH   PIC X.
048800        05  FILLER                        PIC X(10).
048900        05  W-P-NEW-SPECIAL-WAGE-INDEX    PIC 9(02)V9(04).
049000    02  W-PROV-NEWREC-HOLD3.
049100        05  W-P-NEW-PASS-AMT-DATA.
049200            10  W-P-NEW-PASS-AMT-CAPITAL    PIC X(06).
049300            10  W-P-NEW-PASS-AMT-DIR-MED-ED PIC X(06).
049400            10  W-P-NEW-PASS-AMT-ORGAN-ACQ  PIC X(06).
049500            10  W-P-NEW-PASS-AMT-PLUS-MISC  PIC X(06).
049600        05  W-P-NEW-CAPI-DATA.
049700            15  W-P-NEW-CAPI-PPS-PAY-CODE   PIC X.
049800            15  W-P-NEW-CAPI-HOSP-SPEC-RATE PIC X(6).
049900            15  W-P-NEW-CAPI-OLD-HARM-RATE  PIC X(6).
050000            15  W-P-NEW-CAPI-NEW-HARM-RATIO PIC X(5).
050100            15  W-P-NEW-CAPI-CSTCHG-RATIO   PIC X(04).
050200            15  W-P-NEW-CAPI-NEW-HOSP       PIC X.
050300            15  W-P-NEW-CAPI-IME            PIC X(05).
050400            15  W-P-NEW-CAPI-EXCEPTIONS     PIC X(6).
050500            15  W-P-VAL-BASED-PURCH-SCORE   PIC X(4).
050700        05  FILLER                          PIC X(18).
050800
050900*******************************************************
051000*    CAN BE PASSED TO LTOPN___  - CBSA WAGE INDEX TBL *
051100*******************************************************
051200 01  CBSAX-TABLE-FROM-USER.
051300     05  FILLER                  PIC X(32000).
051400     05  FILLER                  PIC X(30000).
051500     05  FILLER                  PIC X(30000).
051600
051700*******************************************************
051800*    CAN BE PASSED TO LTOPN___ - IPPS CBSA WI TABLE   *
051900*******************************************************
052000 01  IPPS-CBSAX-TABLE-FROM-USER.
052100     05  FILLER                  PIC X(32000).
052200     05  FILLER                  PIC X(30000).
052300     05  FILLER                  PIC X(30000).
052400
052500*******************************************************
052600*    CAN BE PASSED TO LTOPN___ - MSA WAGE INDEX TBL   *
052700*******************************************************
052800 01  MSAX-TABLE-FROM-USER.
052900     05  FILLER                  PIC X(32000).
053000     05  FILLER                  PIC X(30000).
053100     05  FILLER                  PIC X(30000).
053200
053300*******************************************************
053400*    PROSPECTIVE PAYMENT REPORT COMPONENTS            *
053500*******************************************************
053600 01  PPS-DETAIL-LINE-OPER.
053700     05  FILLER                  PIC X(01)  VALUE SPACES.
053800     05  PRT-PROV                PIC X(06).
053900     05  FILLER                  PIC X(02)  VALUE SPACES.
054000     05  PRT-DRG-ADJ-PAY         PIC Z,ZZZ,ZZZ.99.
054100     05  FILLER                  PIC X(03)  VALUE SPACES.
054200     05  PRT-OUTLIER-PAY         PIC Z,ZZZ,ZZZ.99.
054300     05  FILLER                  PIC X(01)  VALUE SPACES.
054400     05  PRT-FAC-SPEC-RATE       PIC Z,ZZZ,ZZZ.99.
054500     05  FILLER                  PIC X(02)  VALUE SPACES.
054600     05  PRT-TOT-PAY             PIC Z,ZZZ,ZZZ.99.
054700     05  FILLER                  PIC X(02)  VALUE SPACES.
054800     05  PRT-OUT-THRESH          PIC Z,ZZZ,ZZZ.99.
054900     05  FILLER                  PIC X(02)  VALUE SPACES.
055000     05  PRT-FAC-COST            PIC Z,ZZZ,ZZZ.99.
055100     05  FILLER                  PIC X(02)  VALUE SPACES.
055200     05  PRT-LOS                 PIC ZZ9.
055300     05  FILLER                  PIC X(02)  VALUE SPACES.
055400     05  PRT-REG-DAYS-USED       PIC 9(03).
055500     05  FILLER                  PIC X(02)  VALUE SPACES.
055600     05  PRT-LTR-DAYS-USED       PIC 9(03).
055700     05  FILLER                  PIC X(02)  VALUE SPACES.
055800     05  PRT-ALOS                PIC ZZ.9.
055900     05  FILLER                  PIC X(03)  VALUE SPACES.
056000     05  PRT-PPS-RTC             PIC XX.
056100     05  FILLER                  PIC X(02)  VALUE SPACES.
056200     05  PRT-REL-WT              PIC 9.9999.
056300     05  FILLER                  PIC X(02)  VALUE SPACES.
056400     05  PRT-WAGE-INDEX          PIC 9.9999.
056500
056600 01  PPS-HEAD2-OPER.
056700     05  FILLER                  PIC X(01)  VALUE SPACES.
056800     05  FILLER                  PIC X(44)  VALUE
056900        '  CMS  LTCH PRICER            P R O S P E C '.
057000     05  FILLER                  PIC X(44)  VALUE
057100        'T I V E   P A Y M E N T   T E S T   D A T A '.
057200     05  FILLER                  PIC X(44)  VALUE
057300        '  R E P O R T                               '.
057400
057500 01  PPS-HEAD3-OPER.
057600     05  FILLER                  PIC X(01)  VALUE SPACES.
057700     05  FILLER                  PIC X(42)  VALUE
057800        'PROV          DRG         OUTLIER       FA'.
057900     05  FILLER                  PIC X(47)  VALUE
058000        'C           FINAL        OUTLIER         FAC   '.
058100     05  FILLER                  PIC X(43)  VALUE
058200        '   BILL REG  LTR  AVG   PPS  REL     WAGE'.
058300
058400 01  PPS-HEAD4-OPER.
058500     05  FILLER                  PIC X(01)  VALUE SPACES.
058600     05  FILLER                  PIC X(42)  VALUE
058700        ' NO        ADJ PAY        PAY AMT    SPEC '.
058800     05  FILLER                  PIC X(47)  VALUE
058900        'RATE       PAY AMT      THRESHOLD       COST   '.
059000     05  FILLER                  PIC X(43)  VALUE
059100        '   LOS  USED USED LOS   RTC  WGT     INDEX'.
059200
059300
059400******************************************************************
059500******************************************************************
059600
059700 PROCEDURE  DIVISION.
059800
059900 0000-MAINLINE  SECTION.
060000     OPEN INPUT  BILLFILE.
060100
060200     OPEN OUTPUT PRTOPER.
060300
060400     MOVE ALL '0'     TO PPS-VERSIONS.
060500
060600     PERFORM 0100-PROCESS-RECORDS THRU 0100-EXIT UNTIL EOF-SW = 1.
060700
060800     CLOSE BILLFILE.
060900
061000     CLOSE PRTOPER.
061100     STOP RUN.
061200
061300 0100-PROCESS-RECORDS.
061400     READ BILLFILE INTO BILL-WORK
061500         AT END
061600             MOVE 1 TO EOF-SW.
061700
061800     MOVE BILL-WORK TO BILL-NEW-DATA.
061900     IF  EOF-SW = 0
062000         PERFORM 1000-CALC-PAYMENT THRU 1000-EXIT
062100         PERFORM 1100-WRITE-SYSUT2 THRU 1100-EXIT.
062200
062300 0100-EXIT.  EXIT.
062400
062500
062600 1000-CALC-PAYMENT.
062700***************************************************************
062800*    CALL TO THE PPS SUBROUTINE TO CALCULATE THE              *
062900*    PAYMENT                                                  *
063000***************************************************************
063100***************************************************************
063200* OPTION (1)                                                  *
063300*       (1)  MOVE ' ' TO PRICER-OPTION-SW.                    *
063400*            CALL 'LTOPN___' USING BILL-NEW-DATA              *
063500*                                  PPS-DATA-ALL               *
063600*                                  PPS-CBSA                   *
063700*                                  PRICER-OPT-VERS-SW.        *
063800*        THIS PASSES THE STANDARD VARIABLES USED FOR PRICING. *
063900*                        *  *  *  *                           *
064000* OPTION (2)                                                  *
064100*       (2)  MOVE 'P' TO PRICER-OPTION-SW.                    *
064200*            CALL 'LTOPN___' USING BILL-NEW-DATA              *
064300*                                  PPS-DATA-ALL               *
064400*                                  PPS-CBSA                   *
064500*                                  PRICER-OPT-VERS-SW         *
064600*                                  PROV-RECORD-FROM-USER.     *
064700*        THIS PASSES THE STANDARD VARIABLES AND               *
064800*        THE PROVIDER RECORD FROM THE USER                    *
064900*       USED FOR THIS BILL ONLY IS ALSO PASSED.               *
065000*                        *  *  *  *                           *
065100* OPTION (3)                                                  *
065200*       (3)  MOVE 'A' TO PRICER-OPTION-SW.                    *
065300*            CALL 'LTOPN___' USING BILL-NEW-DATA              *
065400*                                  PPS-DATA-ALL               *
065500*                                  PPS-CBSA                   *
065600*                                  PRICER-OPT-VERS-SW         *
065700*                                  PROV-RECORD-FROM-USER      *
065800*                                  CBSAX-TABLE-FROM-USER      *
065900*                                  IPPS-CBSAX-TABLE-FROM-USER *
066000*                                  MSAX-TABLE-FROM-USER.      *
066100*      THIS IS THE ONLINE COMPATIBLE INTERFACE.               *
066200*      THIS PASSES THE STANDARD VARIABLES AND THE             *
066300*      THE PROVIDER RECORD AND THE WAGE INDEX TABLES FROM     *
066400*      THE USERS (CBSA, IPPS CBSA, & MSA WIX TBLS).           *
066500***************************************************************
066600
066700**************************************************************
066800*** APRIL 22, 2005 ADDED CBSA FIELD SEPARATE FROM PPS-DATA ***
066900*** TO ACCOMODATE OLDER LTCAL VERSIONS                     ***
067000**************************************************************
067100*** OPTION (1)
067200     MOVE ' ' TO PRICER-OPTION-SW.
067300     CALL  LTOPN202   USING BILL-NEW-DATA
067400                            PPS-DATA-ALL
067500                            PPS-CBSA
067600                            PPS-PAYMENT-DATA
067700                            PRICER-OPT-VERS-SW.
067800*** OPTION (2)
067900*    MOVE 'P' TO PRICER-OPTION-SW.
068000*    CALL  LTOPN202   USING BILL-NEW-DATA
068100*                           PPS-DATA-ALL
068200*                           PPS-CBSA
068300*                           PRICER-OPT-VERS-SW
068400*                           PROV-RECORD-FROM-USER.
068500*** OPTION (3)
068600*    MOVE 'A' TO PRICER-OPTION-SW.
068700*    CALL  LTOPN202   USING BILL-NEW-DATA
068800*                           PPS-DATA-ALL
068900*                           PPS-CBSA
069000*                           PRICER-OPT-VERS-SW
069100*                           PROV-RECORD-FROM-USER
069200*                           CBSAX-TABLE-FROM-USER
069300*                           IPPS-CBSAX-TABLE-FROM-USER
069400*                           MSAX-TABLE-FROM-USER.
069500
069600 1000-EXIT.  EXIT.
069700
069800
069900 1100-WRITE-SYSUT2.
070000******************************************************************
070100*    PRINT OPERATING PROSPECTIVE PAYMENT TEST DATA DETAIL
070200******************************************************************
070300     IF  OPERLINE-CTR > 54
070400         PERFORM 1200-PPS-HEADINGS THRU 1200-EXIT.
070500     MOVE SPACES                TO  PPS-DETAIL-LINE-OPER.
070600     MOVE B-PROVIDER-NO         TO  PRT-PROV.
070700     MOVE PPS-LTR-DAYS-USED     TO  PRT-LTR-DAYS-USED.
070800     MOVE PPS-RELATIVE-WGT      TO  PRT-REL-WT.
070900     MOVE PPS-FAC-COSTS         TO  PRT-FAC-COST.
071000     MOVE PPS-AVG-LOS           TO  PRT-ALOS.
071100     MOVE PPS-LOS               TO  PRT-LOS.
071200     MOVE PPS-FINAL-PAY-AMT     TO  PRT-TOT-PAY.
071300     MOVE PPS-OUTLIER-THRESHOLD TO  PRT-OUT-THRESH.
071400     MOVE PPS-DRG-ADJ-PAY-AMT   TO  PRT-DRG-ADJ-PAY.
071500     MOVE PPS-OUTLIER-PAY-AMT   TO  PRT-OUTLIER-PAY.
071600     MOVE PPS-REG-DAYS-USED     TO  PRT-REG-DAYS-USED.
071700     MOVE PPS-NEW-FAC-SPEC-RATE TO  PRT-FAC-SPEC-RATE.
071800     MOVE PPS-RTC               TO  PRT-PPS-RTC.
071900     MOVE PPS-WAGE-INDEX        TO  PRT-WAGE-INDEX.
072000     IF PPS-RTC = 67
072100        MOVE PPS-CHRG-THRESHOLD TO  PRT-OUT-THRESH.
072200
072300     WRITE PRTOPER-LINE FROM PPS-DETAIL-LINE-OPER
072400                             AFTER ADVANCING 1.
072500     IF OPR-STAT1 > 0
072600        DISPLAY ' BAD4 WRITE ON PRTOPER FILE'.
072700     ADD 1 TO OPERLINE-CTR.
072800
072900 1100-EXIT.  EXIT.
073000
073100 1200-PPS-HEADINGS.
073200     WRITE PRTOPER-LINE FROM PPS-HEAD2-OPER
073300                             AFTER ADVANCING PAGE.
073400     IF OPR-STAT1 > 0
073500        DISPLAY ' BAD5 WRITE ON PRTOPER FILE'.
073600     WRITE PRTOPER-LINE FROM PPS-HEAD3-OPER
073700                             AFTER ADVANCING 2.
073800     IF OPR-STAT1 > 0
073900        DISPLAY ' BAD7 WRITE ON PRTOPER FILE'.
074000     WRITE PRTOPER-LINE FROM PPS-HEAD4-OPER
074100                             AFTER ADVANCING 1.
074200     IF OPR-STAT1 > 0
074300        DISPLAY ' BAD8 WRITE ON PRTOPER FILE'.
074400     MOVE ALL '  -' TO PRTOPER-LINE.
074500     WRITE PRTOPER-LINE AFTER ADVANCING 1.
074600     IF OPR-STAT1 > 0
074700        DISPLAY ' BAD9 WRITE ON PRTOPER FILE'.
074800     MOVE 4 TO OPERLINE-CTR.
074900
075000 1200-EXIT.  EXIT.
075100
075200*****        LAST STATEMENT               *************
