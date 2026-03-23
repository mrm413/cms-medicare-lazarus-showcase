000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. LTDRV202.
000300*AUTHOR.     CENTERS FOR MEDICARE AND MEDICAID SERVICES
000400*REMARKS.    - FINDS WAGE-INDEX RECORD(S) FOR GIVEN BILL TO
000500*              BE PASSED TO LTCALYYV MODULES
000600*            - LOADS THE PPS TABLES
000700*            - CALLS THE LTCALYYV MODULES
000800*            - YYV MEANS YEAR AND VERSION
000900 DATE-COMPILED.
001000****************************************************************
001100*                                                              *
001200*   THIS SUBROUTINE IS FURNISHED BY THE CENTERS FOR MEDICARE   *
001300*   AND MEDICAID SERVICES.                                     *
001400*   IT IS TO BE USED AS AN AID IN IMPLEMENTING PROSPECTIVE     *
001500*   PAYMENT FOR LONG TERM CARE HOSPITALS.                      *
001600*   THE RESPONSIBILITY FOR INSTALLING, MODIFYING, TESTING,     *
001700*   MAINTAINING, AND VERIFYING THE ACCURACY OF THIS PROGRAM    *
001800*   IS THAT OF THE USER.                                       *
001900*                  *  *  *  *  *  *  *  *                      *
002000*   ONCE GROUPED THE PROSPECTIVE PAYMENT SUBROUTINE IS CALLED  *
002100*   TO CALCULATE THE TOTAL PAYMENT PRIOR TO DEDUCTIBLE,        *
002200*   CO-INSURANCE, AND CASES WHERE MEDICARE IS SECONDARY PAYOR. *
002300*   THE PROGRAM WILL:                                          *
002400*       1. EDIT THE BILL INFORMATION.                          *
002500*       2. PASS BACK RETURN CODES.                             *
002600*       3. CALCULATE WHEN APPLICABLE:                          *
002700*          A. THE HOSPITAL SPECIFIC PART OF PAYMENT.           *
002800*          B. THE FEDERAL SPECIFIC PART OF PAYMENT.            *
002900*          C. THE OUTLIER PORTION.                             *
003000*          D. TOTAL PAYMENT (B + C + D  ABOVE).                *
003100*                                                              *
003200*                  *  *  *  *  *  *  *  *                      *
003300*   THIS SUBROUTINE CALCULATES THE PROVIDER SPECIFIC           *
003400*   ELEMENTS ON A PROVIDER BREAK, THEREFORE IT WILL RUN FASTER *
003500*   WHEN BILLS ARE BATCHED BY PROVIDER.                        *
003600*                  *  *  *  *  *  *  *  *                      *
003700*                                                              *
003800*--------------------------------------------------------------*
003900*   CHANGE LOG.                                                *
004000*--------------------------------------------------------------*
004100*                                                              *
004200*   04/07/2005 - AT THE REQUEST OF FISS, LTSEL___ CREATED.     *
004300*                THIS PROGRAM IS CALLED BY LTDRV___ AND        *
004400*                RECEIVES THE PROVIDER RECORD, CBSA TABLE,     *
004500*                BILL RECORD, AND PPS DATA.  IT GETS THE       *
004600*                APPROPRIATE CBSA RECORD AND CALLS THE         *
004700*                APPROPRIATE LTCAL___ MODULE FOR THE BILL      *
004800*                                                              *
004900*--------------------------------------------------------------*
005000*                                                              *
005100*   04/21/2005 - EFFECTIVE JULY 1, 2005, CBSA (CORE-BASED      *
005200*                STATISTICAL AREA) IS USED IN PLACE OF MSA     *
005300*                (METROPOLITAN STATISTICAL AREA), THE PROGRAM  *
005400*                DETERMINES WHETHER TO USE THE CBSA WAGE INDEX *
005500*                FILE OR MSA WAGE INDEX FILE BASED ON THE BILL *
005600*                DISCHARGE DATE                                *
005700*                                                              *
005800*--------------------------------------------------------------*
005900*                                                              *
006000*   05/02/2005 - ADDED PSF FIELDS - SPECIAL PAY INDICATOR &    *
006100*                SPECIAL WAGE INDEX                            *
006200*                                                              *
006300*--------------------------------------------------------------*
006400*                                                              *
006500*   12/07/2005 - REMOVED TIME RESTRAINT FROM THE CALL TO THE   *
006600*                LATEST VERSION OF THE LTCAL PROGRAM           *
006700*                                                              *
006800*--------------------------------------------------------------*
006900*                                                              *
007000*   01/17/2006 - MODIFIED FOR 1ST CICS PACKAGE RELEASE;        *
007100*                FOR APRIL 1, 2006 RELEASE                     *
007200*                                                              *
007300*--------------------------------------------------------------*
007400*                                                              *
007500*   01/19/2006 - PROGRAM NAME CHANGED FROM LTSEL___ TO LTDRV___*
007600*                                                              *
007700*--------------------------------------------------------------*
007800*                                                              *
007900*   05/03/2006 - MODIFY PROGRAM FOR JULY 2006 RELEASE:         *
008000*                ADD LTCAL071 CALL, ADD IPPS CBSA WAGE INDEX   *
008100*                TABLE STORAGE & LOGIC.  DELETED LAYOUT FOR    *
008200*                W-PROV-NEW-HOLD - NOT NEEDED.                 *
008300*                IPPS WAGE INDEX LOGIC: ONLY THE IPPS CBSA     *
008400*                FLOOR POLICY IS APPLIED WHEN ASSIGNING THE    *
008500*                IPPS WAGE INDEX.  PUERTO RICO HOSPITALS ARE   *
008600*                GIVEN THE NATIONAL AND PUERTO RICO SPECIFIC   *
008700*                WAGE INDEX VALUES.                            *
008800*                                                              *
008900*--------------------------------------------------------------*
009000*                                                              *
009100*   06/15/2006 - CHANGE THE PLACEMENT OF THE MOVE OF THE PSF   *
009200*                CBSA TO THE IPPS CBSA HOLD AREA & REMOVE THAT *
009300*                MOVE FROM THE IPPS PR SEARCH LOGIC.           *
009400*                                                              *
009500*--------------------------------------------------------------*
009600*                                                              *
009700*   06/19/2006 - CHANGE THE VERSION FROM 07.0 TO 07.1          *
009800*                                                              *
009900*--------------------------------------------------------------*
010000*                                                              *
010100*   08/04/2006 - UPDATE PROGRAM FOR OCTOBER 2006 RELEASE 07.3  *
010200*                ADD FY 2007 FLOOR IF STATEMENT                *
010300*                STILL NEED TO ADD FLOOR CODE                  *
010400*                NEW VERSIONS OF LTCAL CALLED DUE TO THE SIZE  *
010500*                CHANGE OF THE FIELD: PPS-NEW-FAC-SPEC-RATE    *
010600*                FROM 9(5)V9(02) TO 9(7)V9(2).                 *
010700*                                                              *
010800*--------------------------------------------------------------*
010900*                                                              *
011000*   08/08/2006 - BECAUSE THE FY 2007 WAGE INDEX TABLE WILL NOT *
011100*                BE FINAL UNTIL LATE AUGUST, THE FOLLOWING     *
011200*                ITEMS ARE NOT INCLUDED IN VERSION 7.3 OF THE  *
011300*                LTCH PRICER:                                  *
011400*                                                              *
011500*                1) FY 2007 IPPS WAGE INDEX TABLE              *
011600*                2) FY 2007 IPPS WAGE INDEX FLOORS             *
011700*                3) FINAL FY 2007 IPPS DRG WEIGHTS             *
011800*                4) FY 2007 IPPS STANDARD RATES:               *
011900*                    H-IPPS-CAPI-STD-FED-RATE  (LTCAL073)      *
012000*                    H-IPPS-CAPI-STD-PR-RATE   (LTCAL073)      *
012100*                                                              *
012200*                FOR TESTING PURPOSES, THE FOLLOWING           *
012300*                SUBSTITUTES WERE MADE:                        *
012400*                                                              *
012500*                1) THE FY 2006 IPPS WAGE INDEX TABLE VERSION  *
012600*                   06.3 WILL BE USED IN PLACE OF THE FY 2007  *
012700*                   IPPS WAGE INDEX TABLE.                     *
012800*                2) THERE IS NO MODULE THAT ASSIGNS FY 2007    *
012900*                   IPPS WAGE INDEX FLOORS.  THE CODE THAT     *
013000*                   REFERENCES THIS FUTURE MODULE IS COMMENTED *
013100*                   OUT.                                       *
013200*                3) THE CURRENT FY 2007 DRG WEIGHTS ARE USED.  *
013300*                   THESE MAY OR MAY NOT CHANGE.               *
013400*                4) THE FY 2006 IPPS STANDARD RATES ARE USED.  *
013500*                                                              *
013600*--------------------------------------------------------------*
013700*                                                              *
013800*   08/09/2006 - DELETED RETURN CODES 02 & 03 AND ADDED CODES  *
013900*                20, 21, 22, 23, 24, & 25 FOR SHORT STAY       *
014000*                PAYMENT DESCRIPTIONS IN PROGRAM LTCAL073.     *
014100*                                                              *
014200*--------------------------------------------------------------*
014300*                                                              *
014400*   09/06/2006 - CREATE VERSION 07.4 OF THE LTCH PPS PRICER    *
014500*                UPDATED WITH THE FOLLOWING:                   *
014600*                1) FY 2007 IPPS WAGE INDEX TABLE              *
014700*                2) FY 2007 IPPS WAGE INDEX FLOORS             *
014800*                3) FINAL FY 2007 IPPS DRG WEIGHTS             *
014900*                4) FY 2007 IPPS STANDARD RATES (LTCAL074)     *
015000*                                                              *
015100*--------------------------------------------------------------*
015200*                                                              *
015300*   11/16/2006 - CREATE VERSION 07.5 OF THE LTCH PPS PRICER    *
015400*                UPDATED WITH THE FOLLOWING:                   *
015500*                1) IME MULTIPLIER IN PROGRAM LTCAL075 CHANGED *
015600*                   FROM 1.37 TO 1.32 (TO MATCH FY2007 IPPS)   *
015700*                2) PPS RETURN CODE 23 REMOVED FROM LTCAL075   *
015800*                   BECAUSE IT COULD NEVER BE REACHED          *
015900*                3) REMOVED CBSA 27860 FROM THE FY 2007 FLOOR  *
016000*                   CODE (DUE TO IPPS CN1 WAGE INDEX CHANGE)   *
016100*                                                              *
016200*--------------------------------------------------------------*
016300*                                                              *
016400*   12/28/2006 - CREATE VERSION 07.6 OF THE LTCH PPS PRICER    *
016500*                TO CORRECT THE CBSA SIZE LOGIC.  ALWAYS USE   *
016600*                THE GEOGRAPHIC CBSA'S SIZE; STOP USING THE    *
016700*                RURAL FLOOR CBSA'S SIZE.  ALSO, CBSA 27860    *
016800*                WAS REINSTATED INTO THE FLOOR LOGIC, IGNORED  *
016900*                11/03/2006 AND AFTER.                         *
017000*                *** THIS VERSION WAS NOT RELEASED ***         *
017100*                THE NEW LOGIC IS INTRODUCED IN VERSION 08.0.  *
017200*                                                              *
017300*--------------------------------------------------------------*
017400*                                                              *
017500*   05/03/2007 - CREATE VERSION 08.0 OF THE LTCH PPS PRICER    *
017600*                UPDATED WITH THE FOLLOWING:                   *
017700*                1) LTCH WAGE INDEX TABLE - 4/5 & 5/5 COLUMNS  *
017800*                2) LTCH RATES (LTCAL080)                      *
017900*                3) NEW SSO POLICY (IPPS COMPARABLE AMT)       *
018000*                4) 25% RULE (NOT APPLIED IN PRICER)           *
018100*                5) NEW RETURN CODES 26 & 27                   *
018200*                6) NEW IPPS COMPARABLE THRESHOLD COLUMN IN    *
018300*                   DRG TABLE                                  *
018400*                7) WAGE INDEX SELECTION CODE UPDATED          *
018500*                                                              *
018600*--------------------------------------------------------------*
018700*                                                              *
018800*   08/10/2007 - CREATE VERSION 08.1 OF THE LTCH PPS PRICER    *
018900*                UPDATED WITH THE FOLLOWING FY 2008 ITEMS:     *
019000*                1) LTCH DRG TBL (W/ NEW IPPS COMP THRESHOLDS) *
019100*                2) IPPS DRG TABLE                             *
019200*                3) IPPS WAGE INDEX TABLE                      *
019300*                4) IPPS RATES (IN LTCAL081)                   *
019400*                5) IPPS WAGE INDEX FLOORS                     *
019500*                6) NEW OPERATING IME FACTOR (1.35)            *
019600*                7) 3% LARGE URBAN ADD-ON ELIMINTATED          *
019700*                8) CHANGED MESSAGE FOR RETURN CODE 98         *
019800*                                                              *
019900*--------------------------------------------------------------*
020000*                                                              *
020100*   08/22/2007 - CREATE VERSION 08.2 OF THE LTCH PPS PRICER    *
020200*                UPDATED WITH THE FOLLOWING FY 2008 ITEMS:     *
020300*                1) REVISED IPPS WAGE INDEX TABLE              *
020400*                2) REVISED IPPS RATES (IN LTCAL082)           *
020500*                VERSION 08.2 REPLACES VERSION 08.1            *
020600*                                                              *
020700*--------------------------------------------------------------*
020800*                                                              *
020900*   09/14/2007 - CREATE VERSION 08.3 OF THE LTCH PPS PRICER    *
021000*                UPDATED WITH THE FOLLOWING FY 2008 ITEMS:     *
021100*                1) REVISED IPPS WAGE INDEX TABLE              *
021200*                2) REVISED IPPS RATES (IN LTCAL083)           *
021300*                VERSION 08.3 REPLACES VERSION 08.2            *
021400*                                                              *
021500*--------------------------------------------------------------*
021600*                                                              *
021700*   09/28/2007 - CREATE VERSION 08.4 OF THE LTCH PPS PRICER    *
021800*                UPDATED WITH CONGRESS MANDATED REVISION OF    *
021900*                IPPS RATES (IN LTCAL084)                      *
022000*                VERSION 08.4 REPLACES VERSION 08.3            *
022100*                                                              *
022200*--------------------------------------------------------------*
022300*                                                              *
022400*   12/27/2007 - CREATE VERSION 08.5 OF THE LTCH PPS PRICER    *
022500*                5TH SHORT STAY OUTLIER PROVISION NO LONGER    *
022600*                AVAILABLE TO BILLS DISCHARGED ON AND AFTER    *
022700*                12/29/2007 PER A CONGRESS MANDATE             *
022800*                UPDATED LTCAL085 TO REFLECT THIS CHANGE       *
022900*                                                              *
023000*--------------------------------------------------------------*
023100*                                                              *
023200*   02/06/2008 - CREATE VERSION 08.6 OF THE LTCH PPS PRICER    *
023300*                EFFECTIVE OCT 1, 2007 (REPLACES VERSION 08.5) *
023400*                CHANGES EFFECTIVE APRIL 1, 2008:              *
023500*                 1) CHANGED LTCH STANDARD FEDERAL RATE FROM   *
023600*                    $38,356.45 TO $38,086.04 IN PGM LTCAL086  *
023700*                 2) CHANGED FIXED LOSS AMOUNT FROM $20,738.00 *
023800*                    TO $20,707.00 IN PROGRAM LTCAL086         *
023900*                THESE CHANGES WERE MADE IN ACCORD WITH        *
024000*                SECTION 114(E)(2) AND (3) OF THE MEDICARE,    *
024100*                MEDICAID AND SCHIP EXTENSION ACT OF 2007,     *
024200*                ENACTED ON DECEMBER 29, 2007.                 *
024300*                                                              *
024400*--------------------------------------------------------------*
024500*                                                              *
024600*   05/08/2008 - CREATE VERSION 09.0 OF THE LTCH PPS PRICER    *
024700*                EFFECTIVE JULY 1, 2008 (FY 2008, RY 2009)     *
024800*                CHANGES EFFECTIVE JULY 1, 2008:               *
024900*                - NEW WAGE INDEX TABLE W/ 1 WAGE INDEX COLUMN *
025000*                - ALL CLAIMS RECEIVE THE FULL WAGE INDEX      *
025100*                  REGARDLESS OF ITS PROVIDER FY BEGIN DATE    *
025200*                - ALL SHORT STAY CLAIMS ELIGIBLE FOR THE      *
025300*                  BLENDED PAYMENT, NO CLAIMS ELIGIBLE FOR     *
025400*                  THE IPPS COMPARABLE PAYMENT                 *
025500*                - NEW LTCH RATES                              *
025600*                - DISABLE CALL TO LTCAL042 (5 YEAR RULE)      *
025700*                                                              *
025800*--------------------------------------------------------------*
025900*                                                              *
026000*   05/19/2008 - CREATE VERSION 09.1 OF THE LTCH PPS PRICER    *
026100*                EFFECTIVE JULY 1, 2008 (FY 2008, RY 2009)     *
026200*                CHANGED IPPS PUERTO RICO RATES EFFECTIVE      *
026300*                RETROACTIVE TO 10/01/2007.  CREATED TWO NEW   *
026400*                LTCAL MODULES FOR THIS CHANGE:                *
026500*                1) LTCAL087: FOR CLAIMS DISCHARGED            *
026600*                   10/01/2007 - 06/30/2008, REPLACED LTCAL086 *
026700*                2) LTCAL091: FOR CLAIMS DISCHARGED            *
026800*                   07/01/2008 & AFTER, REPLACED LTCAL090      *
026900*                                                              *
027000*--------------------------------------------------------------*
027100*                                                              *
027200*   08/04/2008 - CREATE VERSION 09.2 OF THE LTCH PPS PRICER    *
027300*                EFFECTIVE OCTOBER 1, 2008 (FY 2009, RY 2009)  *
027400*                UPDATED WITH THE FOLLOWING FY 2009 ITEMS:     *
027500*                1) LTCH DRG TBL (NO IPPS COMP THRESHOLDS)     *
027600*                2) IPPS DRG TABLE                             *
027700*                3) IPPS RATES (IN LTCAL092)                   *
027800*                4) OPERATING IME FACTOR (STILL 1.35)          *
027900*                5) FY 2009 FLOOR IF STATEMENT & PARAGRAPH     *
028000*                   USING FY 2008 FLOOR ASSIGNMENTS            *
028100*                                                              *
028200*                THE FOLLOWING FY 2009 UPDATES WERE NOT MADE   *
028300*                IN THIS VERSION BECAUSE THEY ARE NOT YET      *
028400*                AVAILABLE.  A NEW PRICER WILL BE RELEASED TO  *
028500*                INCLUDE THESE ITEMS.                          *
028600*                1) IPPS WAGE INDEX TABLE                      *
028700*                2) IPPS WAGE INDEX FLOORS                     *
028800*                                                              *
028900*                FOR TESTING PURPOSES, THE FOLLOWING           *
029000*                SUBSTITUTIONS WERE MADE:                      *
029100*                1) THE FY 2008 IPPS WAGE INDEX TABLE IS USED  *
029200*                   IN PLACE OF THE FY 2009 TABLE.             *
029300*                2) THE FY 2008 WAGE INDEX FLOORS ARE USED     *
029400*                   IN PLACE OF THE FY 2009 FLOORS.            *
029500*                                                              *
029600*--------------------------------------------------------------*
029700*                                                              *
029800*   08/11/2008 - COMMENTED OUT REFERENCES TO THE IPPS          *
029900*                COMPARABLE THRESHOLD IN LTCAL092 BECAUSE      *
030000*                SHORT STAY CLAIMS ARE NO LONGER ELIGIBLE      *
030100*                FOR THE IPPS COMPARABLE PER DIEM AND,         *
030200*                THEREFORE, THE IPPS THRESHOLD IS NOT INCLUDED *
030300*                IN THE LTCH DRG TABLE FOR FY 2009.  RETURN    *
030400*                CODES 26 & 27 WILL NO LONGER BE RETURNED.     *
030500*                ADDED FIELD P-VAL-BASED-PURCH-SCORE TO THE    *
030600*                PSF LAYOUT (TO BE USED IN IPPS 1/1/2008).     *
030700*                                                              *
030800*--------------------------------------------------------------*
030900*                                                              *
031000*   08/14/2008 - REDUCE H-CAPI-IME-TEACH ROUNDED BY 50%        *
031100*                IN LTCAL092.                                  *
031200*                                                              *
031300*                                                              *
031400*--------------------------------------------------------------*
031500*                                                              *
031600*   08/15/2008 - ADDED STATE SPECIFIC RURAL FLOOR BUDGET       *
031700*                NEUTRALITY (SSRFBN) TABLE AND LOGIC TO        *
031800*                LTCAL092 FOR FY 2009.                         *
031900*              - ADDED NEW RETURN CODE FOR SSRFBN LOGIC:       *
032000*                68 = PROVIDER SPECIFIC STATE CODE INVALID     *
032100*                                                              *
032200*--------------------------------------------------------------*
032300*                                                              *
032400*   09/09/2008 - CREATE VERSION 09.3 OF THE LTCH PPS PRICER    *
032500*                EFFECTIVE OCTOBER 1, 2008 (FY 2009, RY 2009)  *
032600*                REPLACES VERSION 09.2                         *
032700*                ADDED THE FOLLOWING ITEMS IN THIS VERSION:    *
032800*                - FY 2009 IPPS CBSA WAGE INDEX TABLE          *
032900*                  CHANGED NEW CBSA 14600 TO 42260 FOR LTCH    *
033000*                - FY 2009 IPPS RURAL FLOOR ASSIGNMENT CODE    *
033100*                - REVISED FY 2009 IPPS STANDARD RATES         *
033200*                - REVISED FY 2009 IPPS RFBN FACTOR TABLE      *
033300*                                                              *
033400*--------------------------------------------------------------*
033500*                                                              *
033600*   09/12/2008 - REVISED SSRFBN LOGIC IN LTCAL093 TO EXCLUDE   *
033700*                SPECIAL WAGE INDICES ENTERED INTO THE PSF     *
033800*                FROM THE SSRFBN ADJUSTMENT                    *
033900*                                                              *
034000*--------------------------------------------------------------*
034100*                                                              *
034200*   02/17/2009 - CREATE VERSION 09.4 OF THE LTCH PPS PRICER    *
034300*                EFFECTIVE RETROACTIVE BACK TO 10/01/2008      *
034400*                TO CONFORM TO ECONOMIC STIMULUS BILL SIGNED   *
034500*                02/17/2009, THE H-CAPI-IME-TEACH AMOUNT       *
034600*                CALCULATED IN PROGRAM LTCAL094 IS NO LONGER   *
034700*                REDUCED BY 50%.  NOW PAY 100% CAPITAL IME.    *
034800*                THIS VERSION REPLACES VERSION 09.3.           *
034900*                                                              *
035000*--------------------------------------------------------------*
035100*                                                              *
035200*   05/18/2009 - CREATE VERSION 09.5 OF THE LTCH PPS PRICER    *
035300*                EFFECTIVE 06/03/2009                          *
035400*                - ADDED NEW LTCH DRG WEIGHT TABLE (LTDRG095)  *
035500*                  AND CALCULATION PROGRAM (LTCAL095)          *
035600*                  NEW TABLE HAS CORRECTED WEIGHTS AND IS USED *
035700*                  TO PROCESS CLAIMS DISCHARGED ON AND AFTER   *
035800*                  JUNE 3, 2009 THROUGH SEPTEMBER 30, 2009     *
035900*                                                              *
036000*--------------------------------------------------------------*
036100*                                                              *
036200*   08/04/2009 - CREATE VERSION 10.0 OF THE LTCH PPS PRICER    *
036300*                EFFECTIVE 10/01/2009 (FY 2010, RY 2010)       *
036400*                - STARTING THIS YEAR, THE RATE YEAR AND       *
036500*                  FISCAL YEAR BOTH START ON OCTOBER 1ST       *
036600*                - THERE ARE NO POLICY OR FORMULA CHANGES      *
036700*                - RATE YEAR 2005 ITEMS REMOVED FROM PACKAGE   *
036800*                UPDATED WITH THE FOLLOWING FY 2010 ITEMS:     *
036900*                1) LTCH DRG TBL                               *
037000*                2) LTCH CBSA WAGE INDEX TABLE                 *
037100*                3) IPPS DRG TBL                               *
037200*                4) IPPS CBSA WAGE INDEX TABLE                 *
037300*                5) IPPS STATE SPECIFIC RURAL FLOOR BUDGET     *
037400*                   NEUTRALITY (SSRFBN) FACTOR TABLE           *
037500*                6) IPPS CBSA WAGE INDEX FLOOR ASSIGNMENT LOGIC*
037600*                7) LTCH STANDARD RATES IN PROGRAM LTCAL100    *
037700*                8) IPPS STANDARD RATES IN PROGRAM LTCAL100    *
037800*                                                              *
037900*--------------------------------------------------------------*
038000*                                                              *
038100*   09/03/2009 - CREATE VERSION 10.1 OF THE LTCH PPS PRICER    *
038200*                EFFECTIVE 10/01/2009 (FY 2010, RY 2010)       *
038300*                UPDATED W/ THE FOLLOWING REVISED FY2010 ITEMS:*
038400*                1) IPPS CBSA WAGE INDEX TABLE (IPWIX101)      *
038500*                2) IPPS CAPITAL RATES IN PROGRAM LTCAL101     *
038600*                                                              *
038700*--------------------------------------------------------------*
038800*                                                              *
038900*   11/11/2009 - CREATE VERSION 10.2 OF THE LTCH PPS PRICER    *
039000*                EFFECTIVE 10/01/2009 (FY 2010, RY 2010)       *
039100*                REPLACES VERSION 10.1                         *
039200*                UPDATED W/ THE FOLLOWING REVISED FY2010 ITEMS:*
039300*                1) IPPS CBSA WAGE INDEX TABLE (IPWIX103)      *
039400*                2) IPPS STATE SPECIFIC RURAL FLOOR BUDGET     *
039500*                   NEUTRALITY (SSRFBN) FACTOR TABLE (IRFBN102)*
039600*                   (KANSAS RFBN CORRECTED - CHANGED FROM      *
039700*                    0.99826 TO 0.99829)                       *
039800*                                                              *
039900*--------------------------------------------------------------*
040000*                                                              *
040100*   04/07/2010 - CREATE VERSION 10.3 OF THE LTCH PPS PRICER    *
040200*                EFFECTIVE 10/01/2010 (FY 2010, RY 2010)       *
040300*                REPLACES VERSION 10.2                         *
040400*                UPDATED W/ THE FOLLOWING REVISED FY2010 ITEMS:*
040500*                1) IPPS CBSA WAGE INDEX TABLE (IPWIX104)      *
040600*                2) IPPS STATE SPECIFIC RURAL FLOOR BUDGET     *
040700*                   NEUTRALITY TABLE (IRFBN105)                *
040800*                3) IPPS DRG TABLE (IPDRG104)                  *
040900*                4) LTCH STANDARD RATES IN PROGRAM LTCAL104    *
041000*                5) IPPS STANDARD RATES IN PROGRAM LTCAL104    *
041100*                                                              *
041200*--------------------------------------------------------------*
041300*                                                              *
041400*   04/19/2010 - CREATE VERSION 10.4 OF THE LTCH PPS PRICER    *
041500*                EFFECTIVE 10/01/2010 (FY 2010, RY 2010)       *
041600*                REPLACES VERSION 10.3                         *
041700*                UPDATED W/ THE FOLLOWING REVISED FY2010 ITEMS:*
041800*                1) LTCH STANDARD RATES IN PROGRAM LTCAL105    *
041900*                2) IPPS STANDARD RATES IN PROGRAM LTCAL105    *
042000*                                                              *
042100*--------------------------------------------------------------*
042200*                                                              *
042300*   08/04/2010 - CREATE VERSION 11.0 OF THE LTCH PPS PRICER    *
042400*                EFFECTIVE 10/01/2010 (FY 2011, RY 2011)       *
042500*                REPLACES VERSION 10.4                         *
042600*                UPDATED W/ THE FOLLOWING REVISED FY2011 ITEMS:*
042700*                1) IPPS CBSA WAGE INDEX TABLE (IPWIX110)      *
042800*                2) IPPS STATE SPECIFIC RURAL FLOOR BUDGET     *
042900*                   NEUTRALITY TABLE (IRFBN110)                *
043000*                3) IPPS DRG TABLE (IPDRG110)                  *
043100*                4) LTCH STANDARD RATES IN PROGRAM LTCAL110    *
043200*                5) IPPS STANDARD RATES IN PROGRAM LTCAL110    *
043300*                                                              *
043400*--------------------------------------------------------------*
043500*                                                              *
043600*   08/13/2010 - CORRECTED FY 2008 - FY 2011 FLOOR LOGIC TO    *
043700*                REFERENCE THE IPPS CBSA INSTEAD OF THE LTCH   *
043800*                CBSA (TAMARA HOWARD)                          *
043900*                                                              *
044000*--------------------------------------------------------------*
044100*                                                              *
044200*   10/19/2010 - CHANGED TO ALLOW ADJUSTMENTS TO CLAIMS WITH   *
044300*                DATES OF SERVICE OLDER THAN 5 YEARS           *
044400*--------------------------------------------------------------*
044500*                                                              *
044600*   08/01/2011 - CREATE VERSION 12.0 OF THE LTCH PPS PRICER    *
044700*                EFFECTIVE 10/01/2011 (FY 2012, RY 2012)       *
044800*                REPLACES VERSION 11.1                         *
044900*                UPDATED W/ THE FOLLOWING REVISED FY2012 ITEMS:*
045000*                1) IPPS CBSA WAGE INDEX TABLE (IPWIX120)      *
045100*                2) IPPS DRG TABLE (IPDRG120)                  *
045200*                3) LTCH STANDARD RATES IN PROGRAM LTCAL120    *
045300*                4) IPPS STANDARD RATES IN PROGRAM LTCAL120    *
045400*                                                              *
045500*--------------------------------------------------------------*
045600*                                                              *
045700*   08/31/2011 - CREATE VERSION 12.1 OF THE LTCH PPS PRICER    *
045800*                EFFECTIVE 10/01/2011 (FY 2012, RY 2012)       *
045900*                REPLACES VERSION 12.0                         *
046000*                UPDATED W/ THE FOLLOWING REVISED FY2012 ITEMS:*
046100*                1) IPPS CBSA WAGE INDEX TABLE (IPWIX121)      *
046200*                2) IPPS DRG TABLE (IPDRG121)                  *
046300*                3) LTCH CBSA WAGE INDEX TABLE (LTWIX121)      *
046400*--------------------------------------------------------------*
046500*                                                              *
046600*   10/28/2011 - CREATE VERSION 12.2 OF THE LTCH PPS PRICER    *
046700*                EFFECTIVE 10/01/2011 (FY 2012, RY 2012)       *
046800*                REPLACES VERSION 12.1                         *
046900*                UPDATED W/ THE FOLLOWING REVISED FY2012 ITEMS:*
047000*                1) LTCH DRG TABLE (IPDRG122)                  *
047100*                                                              *
047200*--------------------------------------------------------------*
047300*                                                              *
047400*   12/09/2011 - CREATE VERSION 12.3 OF THE LTCH PPS PRICER    *
047500*                EFFECTIVE 10/01/2011 (FY 2012, RY 2012)       *
047600*                REPLACES VERSION 12.2                         *
047700*                REVISED FY 2012 IPPS WAGE INDEX FLOOR         *
047800*                                                              *
047900*--------------------------------------------------------------*
048000*                                                              *
048100*   07/30/2012 - CREATE VERSION 13.0 OF THE LTCH PPS PRICER    *
048200*                EFFECTIVE 10/01/2012 (FY 2013, RY 2013)       *
048300*                REPLACES VERSION 12.3                         *
048400*                UPDATED W/ THE FOLLOWING REVISED FY2013 ITEMS:*
048500*                1) LTCH WAGE INDEX TABLE (LTWIX130)           *
048600*                2) LTCH DRG TABLE (LTDRG130)                  *
048700*                3) IPPS CBSA WAGE INDEX TABLE (IPWIX130)      *
048800*                4) IPPS DRG TABLE (IPDRG130)                  *
048900*                5) LTCH STANDARD RATES IN PROGRAM LTCAL130    *
049000*                6) IPPS STANDARD RATES IN PROGRAM LTCAL130    *
049100*                                                              *
049200*--------------------------------------------------------------*
049300*                                                              *
049400*   11/16/2012 - IN VERSION 13.0 OF THE LTCH PPS PRICER        *
049500*                CHANGED "T-CBSA-DATA  OCCURS 0 TO 4000 TIMES" *
049600*                     TO "T-CBSA-DATA  OCCURS 0 TO 7000 TIMES" *
049700*                FOR IPPS-CBSA-WI-TABLE IN RESPONSE TO         *
049800*                HPAR CR8041H2 (R41212).  NO VERSION NUMBERS   *
049900*                CHANGED AND ONLY MODULES LTDRV130 AND         *
050000*                LTOPN130 CHANGED AS DESCRIBED ABOVE.          *
050100*                                                              *
050200*--------------------------------------------------------------*
050300*                                                              *
050400*   08/08/2013 - CREATE VERSION 14.0 OF THE LTCH PPS PRICER    *
050500*                EFFECTIVE 10/01/2013 (FY 2014, RY 2014)       *
050600*                REPLACES VERSION 13.0                         *
050700*                UPDATED W/ THE FOLLOWING REVISED FY2014 ITEMS:*
050800*                1) LTCH WAGE INDEX TABLE (LTWIX140)           *
050900*                2) LTCH DRG TABLE (LTDRG140)                  *
051000*                3) IPPS CBSA WAGE INDEX TABLE (IPWIX140)      *
051100*                4) IPPS DRG TABLE (IPDRG140) - NEW TABLE      *
051200*                   LAYOUT & SEARCH LOGIC IN LTCAL140          *
051300*                5) LTCH STANDARD RATES IN PROGRAM LTCAL140    *
051400*                6) IPPS STANDARD RATES IN PROGRAM LTCAL140    *
051500*                7) ADDED HOSPITAL QUALITY INDICATOR TO PSF    *
051600*                8) ADDED OPERATING DSH PAYMENT REDUCTION FOR  *
051700*                   UNCOMPENSATED CARE PAYMENT IN LTCAL140     *
051800*                                                              *
051900*--------------------------------------------------------------*
052000*                                                              *
052100*   09/03/2013 - CREATE VERION 141 TO INCORPORATE THE NEW LTCH *
052200*                AND PPS WAGE INDEX TABLES                     *
052300*                                                              *
052400*--------------------------------------------------------------*
052500*                                                              *
052600*   08/06/2014 - CREATE VERSION 15.0 OF THE LTCH PPS PRICER    *
052700*                EFFECTIVE 10/01/2014 (FY 2015)                *
052800*                REPLACES VERSION 14.1                         *
052900*                UPDATED W/ THE FOLLOWING REVISED FY2015 ITEMS:*
053000*                1) LTCH WAGE INDEX TABLE (LTWIX150)           *
053100*                2) LTCH DRG TABLE (LTDRG150)                  *
053200*                3) IPPS CBSA WAGE INDEX TABLE (IPWIX150)      *
053300*                4) IPPS DRG TABLE (IPDRG150)                  *
053400*                5) LTCH STANDARD RATES IN PROGRAM LTCAL150    *
053500*                6) IPPS STANDARD RATES IN PROGRAM LTCAL150    *
053600*                7) IPPS BLENDED WAGE INDEX TABLE              *
053700*                   (BLEND150) - NEW FOR FY 2015               *
053800*                8) NEW LOGIC IN LTCAL150 TO USE THE IPPS CBSA *
053900*                   BLENDED WAGE INDEX IN TABLE BLEND150       *
054000*                   FOR ALL PROVIDERS IN THAT TABLE            *
054100*                9) NEW LOGIC TO ASSIGN IPPS CBSA WAGE INDEX   *
054200*                   FLOORS IN LTDRV150                         *
054300*               10) CORRECTED DATE RANGES FOR FYS 2011 - 2014  *
054400*                   RURAL FLOOR ASSIGNMENT LOGIC IN LTDRV150   *
054500*               11) CORRECTED FY 2014 RURAL FLOOR LOGIC TO     *
054600*                   CHANGE THE IPPS CBSA INSTEAD OF THE LTCH   *
054700*                   CBSA IN LTDRV150                           *
054800*               12) INCREASE SIZE OF LTCH CBSA TABLE FROM      *
054900*                   4,000 TO 7,000                             *
055000*                                                              *
055100*--------------------------------------------------------------*
055200*                                                              *
055300*   08/28/2014 - CREATE VERSION 15.1 OF THE LTCH PPS PRICER    *
055400*                EFFECTIVE 10/01/2014 (FY 2015)                *
055500*                REPLACES VERSION 15.0                         *
055600*              - ADDED CONDITIONS TO THE CBSA WAGE INDEX       *
055700*                SEARCH TO ONLY SELECT THE WAGE INDEX IF ITS   *
055800*                EFFECTIVE DATE IS WITHIN THE SAME FY AS THE   *
055900*                THE CLAIM'S DISCHARGE DATE. CODE WAS CHANGED  *
056000*                IN THE FOLLOWING THREE PLACES:                *
056100*                - NATIONAL LTCH WAGE INDEX SEARCH,            *
056200*                - NATIONAL IPPS WAGE INDEX SEARCH, AND        *
056300*                - PUERTO RICO IPPS WAGE INDEX SEARCH.         *
056400*              - MOVED LOGIC THAT ASSIGNS THE SPECIAL WAGE     *
056500*                INDEX WHEN APPLICABLE FROM LTCAL151 TO        *
056600*                LTDRV151 (0550-GET-CBSA).                     *
056700*              - MODIFIED SPECIAL WAGE INDEX ASSIGNMENT LOGIC  *
056800*                TO ONLY SELECT THE WAGE INDEX IF THE PSF      *
056900*                RECORD'S EFFECTIVE DATE FALLS WITHIN THE      *
057000*                CLAIM'S FISCAL YEAR (0550-GET-CBSA).          *
057100*              - ADDED LOGIC TO INITIALIZE LTCH AND IPPS WAGE  *
057200*                INDEX TABLES AND HOLD CBSA FIELDS             *
057300*              - ADDED LOGIC TO SET RTC TO 52 IF THE THIRD     *
057400*                COLUMN OF THE LTCH CBSA WAGE INDEX IS ZERO    *
057500*                                   *
057600*--------------------------------------------------------------*
057700*                                                              *
057800* 11/20/14 - VERSION 15.2 CREATED TO ADDRESS A PROBLEM         *
057900*   REPORTED BY FISS WHERE A CLAIM DATED 12/31/2007 RECEIVES   *
058000*   UNEXPECTED WAGE INDEX ERROR (RTC 52).                      *
058100*                                                              *
058200* ADDED CONDITION TO PROCEDURE 0650-N-GET-WAGE-INDX SO THAT TO *
058300* SELECT THE WAGE INDEX, IT MUST BE A CBSA WITH AN EFFECTIVE   *
058400* DATE ON OR BEFORE THE CLAIM DISCHARGE DATE AND A CLAIM       *
058500* DISCHARGE DATE ON OR BEFORE 09/30/2009                       *
058600*                                                              *
058700* THE CODE ADDED IS AS FOLLOWS:                                *
058800*   (B-DISCHARGE-DATE <= 20090930) OR                          *
058900*                                                              *
059000*--------------------------------------------------------------*
059100*                                                              *
059200* 03/16/15 - VERSION 15.3 CREATED TO ADD NEW DATA NAMES.       *
059300* THE FIRST STAGE OF BUILDING THE FY 2016 LTCH PRICER.         *
059400* WAS BUILT TO TEST THE CHANGES IN THE DATA LAYOUT, AND        *
059500* ONLY MADE CHANGES TO THE DRIVER MODULE (LTDRV153)            *
059600*                                                              *
059700*--------------------------------------------------------------*
059800* 06/11/15 - VERSION 16.B CREATED TO ADD NEW LOGIC.            *
059900* THE SECOND STAGE OF BUILDING THE FY 2016 LTCH PRICER.        *
060000* DONE IN ORDER TO GIVE THE PROGRAMMERS MORE TIME              *
060100* TO BE ABLE TO CREATE THE LOGIC AND TEST IT WITHOUT HAVING TO *
060200* FIRST GET THE FY 2016 RATES.                                 *
060300*                                                              *
060400*--------------------------------------------------------------*
060500*                                                              *
060600*   08/04/2015 - CREATE VERSION 16.0 OF THE LTCH PPS PRICER    *
060700*                EFFECTIVE 10/01/2015 (FY 2016)                *
060800*                REPLACES VERSION 15.3                         *
060900*              - ADDED NEW STATE CODES FOR RURAL FLOOR WAGE    *
061000*                INDEX LOGIC (TO BE USED STARTING APRIL 2016)  *
061100*              - CORRECTED CRITERIA TO SEARCH FOR CBSA SIZE    *
061200*              - ROUTINE FISCAL YEAR UPDATES TO VERSION AND    *
061300*                NEW CALL TO LTCAL160                          *
061400*                                                              *
061500*--------------------------------------------------------------*
061600*                                                              *
061700*   11/25/2015 - CREATE VERSION 16.C OF THE LTCH PPS PRICER    *
061800*                EFFECTIVE 04/01/2016 (FY 2016)                *
061900*                ** BETA VERSION FOR APRIL 2016 TESTING **     *
062000*              - ADDED NEW STATE CODES FOR RURAL FLOOR WAGE    *
062100*                INDEX LOGIC (TO BE USED STARTING APRIL 2016)  *
062200*                (ADDITIONAL CODES 95, 96, & 97)               *
062300*              - CREATED LTCAL15C TO PROCESS CLAIMS DISCHARGED *
062400*                01/01/2015 - 09/30/2015.                      *
062500*              - CREATED LTCAL16C TO PROCESS CLAIMS DISCHARGED *
062600*                10/01/2015 - 09/30/2016.                      *
062700*              - ADDED NEW COST REPORT DAYS VARIABLE TO INPUT  *
062800*                RECORD TO PRICE SUBCLAUSE (II) LTCH PAYMENTS  *
062900*                (LTDRV16C, LTCAL15C, LTCAL16C)                *
063000*              - NEW CALLS TO LTCAL15C & LTCAL16C              *
063100*              - ALTERED CALL TO LTCAL152 TO PROCESS CLAIMS    *
063200*                DISCHARGED 10/01/2014 - 12/31/2014.           *
063300*                                                              *
063400*--------------------------------------------------------------*
063500*                                                              *
063600*   12/11/2015 - VERSION 16.1 EFFECTIVE APRIL 1, 2016          *
063700*                DUE TO CR 9401                                *
063800*                                                              *
063900*--------------------------------------------------------------*
064000*                                                              *
064100*   01/28/2016 - VERSION 16.2 EFFECTIVE APRIL 1, 2016          *
064200*              - CHANGE TO CALL LTCAL162                       *
064300*              - LTCAL162 UPDATED DUE TO CR 9300 AND CR 9527   *
064400*                                                              *
064500* JUNE 20, 2016 - FOR VERSION 17.B CHANGED THE FOLLOWING:      *
064600*                                                              *
064700*   1.THE LAYOUT OF THE PROVIDER RECORD TO INCLUDE A           *
064800*        STATE CODE.                                           *
064900*      - REPLACE 05 FILLER PIC X(05). ON LINE 76 OF            *
065000*        PROV-NEW-HOLD WITH THE FOLLOWING:                     *
065100*             05  P-NEW-STATE-CODE           PIC 9(02).        *
065200*             05  P-NEW-STATE-CODE-X REDEFINES                 *
065300*                   P-NEW-STATE-CODE         PIC X(02).        *
065400*             05  FILLER                     PIC X(03).        *
065500*   2.THE LOGIC OF THE DRIVER MODULE TO MOVE THE NEW           *
065600*     STATE CODE INTO THE SEARCH VARIABLE AND TO               *
065700*     COMMENT-OUT THE LINES OF CODE THAT DO THE                *
065800*     FLOOR ASSIGNMENTS.                                       *
065900*   3.ADDED COBOL CODE TO ALLOW THE LTCH PRICER TO WORK WITH   *
066000*     THE NEW ARIZONA STATE CODE OF '00'                       *
066100*                                                              *
066200* 8-9-16 - VERSION 17.0                                        *
066300*  - MADE ANNUAL UPDATE                                        *
066400*  - ADDED CALL TO LTCAL170                                    *
066500*  - CHANGED TO NO LONGER GET THE PUERTO RICO SPECIFIC WAGE    *
066600*    INDEX FOR PR HOSPITALS BEGINNING FY 2016                  *
066700*                                                              *
066800* 8-8-17 - VERSION 18.0                                        *
066900*  - MADE ANNUAL UPDATE                                        *
067000*  - ADDED CALL TO LTCAL180                                    *
067100*                                                              *
067200* 9-21-17 - VERSION 18.1                                       *
067300*  - CHANGE TO CALL LTCAL181 INSTEAD OF LTCAL180               *
067400*                                                              *
067500* 10-20-17 - VERSION 18.2 - IMPLEMENTATION DATE = 1/1/18.      *
067600*  CR10368 - OFF-CYCLE UPDATE TO THE LONG TERM CARE HOSPITAL   *
067700*  (LTCH) PROSPECTIVE PAYMENT SYSTEM (PPS) FISCAL YEAR (FY)    *
067800*  2018 PRICER.                                                *
067900*  UPDATED LTCH WAGE INDEX.                                    *
068000*                                                              *
068100* 3-8-18 - VERSION 18.3 - IMPLEMENTATION DATE = 1/1/18         *
068200*  - CHANGE TO CALL LTCAL183                                   *
068300*  - IMPLEMENTS CR10547 - INPATIENT PROSPECTIVE PAYMENT SYSTEM *
068400*  (IPPS) AND LONG-TERM CARE HOSPITAL (LTCH) PER THE ADVANCING *
068500*  CHRONIC CARE, EXTENDERS, AND SOCIAL SERVICES (ACCESS) ACT   *
068600*  INCLUDED IN THE BIPARTISAN BUDGET ACT OF 2018.              *
068700*                                                              *
068800* 7-30-18 - VERSION 19.0 - IMPLEMENTATION DATE = 10/1/18       *
068900*  - CHANGE TO ADD CALL LTCAL190                               *
069000* 9-16-19 - VERSION 20.0 - IMPLEMENTATION DATE = 10/1/19       *
069100*  - CHANGE TO ADD CALL LTCAL201                               *
069200*  - CHANGED "T-CBSA-DATA  OCCURS 0 TO 7000 TIMES"             *
069300*        TO "T-CBSA-DATA  OCCURS 0 TO 10000 TIMES"             *
069400*     FOR IPPS-CBSA-WI-TABLE                                   *
069500*  - CHANGES TO LOGIC FOR WAGE INDEX RURAL FLOOR CALCULATION   *
069600*  - ADD REDEFINES FOR P-NEW-STATE TO ACCOMODATE ALPHA NUMERIC *
069700*    STATE CODES IN THE PROVIDER NUMBER                        *
069800*                                                              *
069900* 3-6-20 - VERSION 20.1 - IMPLEMENT CHANGES FROM CR11616       *
070000* INCLUDES THE DISCHARGE PAYMENT PERCENTAGE PAYMENT ADJUSTMENT *
070100* ADDS THE FOLLOWING TWO NEW VARIABLES TO THE INTERFACE WITH   *
070200*    FISS AND THE MEDICARE CONTRACTORS:                        *
070300*       B-LTCH-DPP-INDICATOR-SW                                *
070400*       PPS-LTCH-DPP-ADJ-AMT                                   *
070500*                                                              *
070600* 4-3-20 - VERSION 20.2 - CR11742                              *
070700*  - CHANGE TO CALL LTCAL202                                   *
070800*                                                              *
070900****************************************************************
071000
071100
071200 ENVIRONMENT DIVISION.
071300 CONFIGURATION SECTION.
071400 SOURCE-COMPUTER.            IBM-370.
071500 OBJECT-COMPUTER.            IBM-370.
071600 INPUT-OUTPUT  SECTION.
071700 FILE-CONTROL.
071800
071900 DATA DIVISION.
072000 FILE SECTION.
072100
072200
072300 WORKING-STORAGE SECTION.
072400 77  W-STORAGE-REF                  PIC X(48) VALUE
072500     'L T D R V _ _ _ - W O R K I N G   S T O R A G E'.
072600 01  DRV-VERSION                    PIC X(05) VALUE 'D20.2'.
072700
072800*-------------------------------------------------------------*
072900* LTCAL MODULES OLDER THAN 5 YEARS                            *
073000*-------------------------------------------------------------*
073100 01  LTCAL032                       PIC X(08) VALUE 'LTCAL032'.
073200 01  LTCAL042                       PIC X(08) VALUE 'LTCAL042'.
073300 01  LTCAL043                       PIC X(08) VALUE 'LTCAL043'.
073400 01  LTCAL058                       PIC X(08) VALUE 'LTCAL058'.
073500 01  LTCAL059                       PIC X(08) VALUE 'LTCAL059'.
073600 01  LTCAL063                       PIC X(08) VALUE 'LTCAL063'.
073700 01  LTCAL064                       PIC X(08) VALUE 'LTCAL064'.
073800 01  LTCAL072                       PIC X(08) VALUE 'LTCAL072'.
073900 01  LTCAL075                       PIC X(08) VALUE 'LTCAL075'.
074000
074100*-------------------------------------------------------------*
074200* LTCAL MODULES CURRENTLY CALLED                              *
074300*-------------------------------------------------------------*
074400 01  LTCAL080                       PIC X(08) VALUE 'LTCAL080'.
074500 01  LTCAL087                       PIC X(08) VALUE 'LTCAL087'.
074600 01  LTCAL091                       PIC X(08) VALUE 'LTCAL091'.
074700 01  LTCAL094                       PIC X(08) VALUE 'LTCAL094'.
074800 01  LTCAL095                       PIC X(08) VALUE 'LTCAL095'.
074900 01  LTCAL103                       PIC X(08) VALUE 'LTCAL103'.
075000 01  LTCAL105                       PIC X(08) VALUE 'LTCAL105'.
075100 01  LTCAL111                       PIC X(08) VALUE 'LTCAL111'.
075200 01  LTCAL123                       PIC X(08) VALUE 'LTCAL123'.
075300 01  LTCAL130                       PIC X(08) VALUE 'LTCAL130'.
075400 01  LTCAL141                       PIC X(08) VALUE 'LTCAL141'.
075500 01  LTCAL152                       PIC X(08) VALUE 'LTCAL152'.
075600 01  LTCAL154                       PIC X(08) VALUE 'LTCAL154'.
075700 01  LTCAL162                       PIC X(08) VALUE 'LTCAL162'.
075800 01  LTCAL170                       PIC X(08) VALUE 'LTCAL170'.
075900 01  LTCAL183                       PIC X(08) VALUE 'LTCAL183'.
076000 01  LTCAL190                       PIC X(08) VALUE 'LTCAL190'.
076100 01  LTCAL202                       PIC X(08) VALUE 'LTCAL202'.
076200
076300 01  WS-9S                          PIC X(08) VALUE '99999999'.
076400
076500 01  WI_QUARTILE_FY2020       PIC 9(02)V9(04)  VALUE 0.8457.
076600 01  WI_PCT_REDUC_FY2020      PIC S9(01)V9(02) VALUE -0.05.
076700 01  WI_PCT_ADJ_FY2020        PIC 9(01)V9(02)  VALUE 0.95.
076800
076900*---------------------------------------------------------*
077000* RURAL FLOOR FACTOR TABLE                                *
077100*---------------------------------------------------------*
077200 COPY RUFL200.
077300
077400 01  HOLD-RUFL-DATA.
077500     05  RUFL-IDX2                      PIC 9(03) VALUE 0.
077600
077700*---------------------------------------------------------*
077800* PREVIOUS FY WAGE INDEX TABLE                            *
077900*---------------------------------------------------------*
078000*COPY PREV200.
078100*
078200*01  HOLD-PREV-DATA.
078300*    05  HLD-PREV-WI                    PIC S9(02)V9(04).
078400
078500*-------------------------------------------------------------*
078600* VARIABLES TO HOLD THE BILL'S FY BEGIN AND END DATES         *
078700*-------------------------------------------------------------*
078800 01  W-FY-BEGIN-DATE.
078900     05  W-FY-BEGIN-CC              PIC 9(02).
079000     05  W-FY-BEGIN-YY              PIC 9(02).
079100     05  W-FY-BEGIN-MM              PIC 9(02) VALUE 10.
079200     05  W-FY-BEGIN-DD              PIC 9(02) VALUE 01.
079300
079400 01  W-FY-END-DATE.
079500     05  W-FY-END-CC                PIC 9(02).
079600     05  W-FY-END-YY                PIC 9(02).
079700     05  W-FY-END-MM                PIC 9(02) VALUE 09.
079800     05  W-FY-END-DD                PIC 9(02) VALUE 30.
079900
080000
080100***************************************************************
080200* MSA AND CBSA HOLD AREAS FOR SEARCH                          *
080300***************************************************************
080400 01  HOLD-PROV-MSA.
080500         10  H-PROV-BLANK             PIC X(2).
080600         10  H-PROV-STATE.
080700             15  FILLER               PIC X.
080800             15  H-MSA-LAST-POS       PIC X.
080900
081000 01  HOLD-PROV-CBSA.
081100         10  H-PROV-BLANK             PIC X(3).
081200         10  H-PROV-STATE.
081300             15  FILLER               PIC X.
081400             15  H-CBSA-LAST-POS      PIC X.
081500
081600 01  HOLD-PROV-IPPS-CBSA.
081700         10  H-PROV-BLANK             PIC X(3).
081800         10  H-PROV-STATE.
081900             15  FILLER               PIC X.
082000             15  H-IPPS-CBSA-LAST-POS PIC X.
082100
082200 01  HOLD-PROV-IPPS-CBSA-RURAL.
082300         10  H-PROV-BLANK-R              PIC X(3).
082400         10  H-PROV-STATE-R.
082500             15  FILLER                  PIC X.
082600             15  H-IPPS-CBSA-LAST-POS-R  PIC X.
082700
082800
082900***************************************************************
083000*      THIS IS THE WAGE-INDEX RECORD THAT WILL BE PASSED TO   *
083100*      THE LTCAL___ PROGRAM (MSA) - USED THROUGH 06/30/2005   *
083200***************************************************************
083300 01  WAGE-NEW-INDEX-RECORD-MSA.
083400     05  W-NEW-MSA                    PIC 9(4).
083500     05  W-NEW-EFF-DATE-M.
083600          10  W-NEW-EFF-DATE-M-CC     PIC 9(2).
083700          10  W-NEW-EFF-DATE-M-YMD.
083800              15  W-NEW-EFF-DATE-M-YY PIC 9(2).
083900              15  W-NEW-EFF-DATE-M-MM PIC 9(2).
084000              15  W-NEW-EFF-DATE-M-DD PIC 9(2).
084100     05  W-NEW-INDEX1-RECORD-M        PIC S9(02)V9(04).
084200     05  W-NEW-INDEX2-RECORD-M        PIC S9(02)V9(04).
084300     05  W-NEW-INDEX3-RECORD-M        PIC S9(02)V9(04).
084400
084500
084600***************************************************************
084700*      THIS IS THE WAGE-INDEX RECORD THAT WILL BE PASSED TO   *
084800*      THE LTCAL___ PROGRAM (CBSA) - USED SINCE 07/01/2005    *
084900***************************************************************
085000 01  WAGE-NEW-INDEX-RECORD-CBSA.
085100     05  W-NEW-CBSA                   PIC 9(5).
085200     05  W-NEW-EFF-DATE-C.
085300          10  W-NEW-EFF-DATE-C-CC     PIC 9(2).
085400          10  W-NEW-EFF-DATE-C-YMD.
085500              15  W-NEW-EFF-DATE-C-YY PIC 9(2).
085600              15  W-NEW-EFF-DATE-C-MM PIC 9(2).
085700              15  W-NEW-EFF-DATE-C-DD PIC 9(2).
085800     05  W-NEW-INDEX1-RECORD-C        PIC S9(02)V9(04).
085900     05  W-NEW-INDEX2-RECORD-C        PIC S9(02)V9(04).
086000     05  W-NEW-INDEX3-RECORD-C        PIC S9(02)V9(04).
086100
086200
086300***************************************************************
086400*      THIS IS THE IPPS WAGE-INDEX RECORD THAT WILL BE PASSED *
086500*      TO THE LTCAL___ PROGRAM (CBSA) - USED SINCE 07/01/2006 *
086600***************************************************************
086700 01  WAGE-IPPS-INDEX-RECORD-CBSA.
086800     05  W-CBSA-IPPS.
086900         10 CBSA-IPPS-123              PIC X(3).
087000         10 CBSA-IPPS-45               PIC X(2).
087100     05  W-CBSA-IPPS-SIZE              PIC X.
087200         88  LARGE-URBAN       VALUE 'L'.
087300         88  OTHER-URBAN       VALUE 'O'.
087400         88  ALL-RURAL         VALUE 'R'.
087500     05  W-CBSA-IPPS-EFF-DATE          PIC X(8).
087600     05  FILLER                        PIC X.
087700     05  W-IPPS-WAGE-INDEX             PIC S9(02)V9(04).
087800     05  W-IPPS-PR-WAGE-INDEX          PIC S9(02)V9(04).
087900
088000
088100***************************************************************
088200*      THIS IS THE IPPS RURAL WAGE INDEX INFO THAT WILL BE    *
088300*      HELD                                                   *
088400***************************************************************
088500 01  WAGE-IPPS-INDEX-RURAL-CBSA.
088600     05  W-CBSA-IPPS-RURAL.
088700         10 CBSA-IPPS-RURAL-123        PIC X(3).
088800         10 CBSA-IPPS-RURAL-45         PIC X(2).
088900     05  W-CBSA-IPPS-RUR-EFF-DATE      PIC X(8).
089000     05  W-IPPS-WAGE-INDEX-RURAL       PIC S9(02)V9(04).
089100
089200
089300***************************************************************
089400*      THIS IS THE IPPS RURAL WAGE INDEX INFO THAT WILL BE    *
089500*      HELD - PUERTO RICO SPECIFIC                            *
089600***************************************************************
089700 01  W-IPPS-PR-WAGE-INDEX-RUR          PIC S9(02)V9(04).
089800
089900
090000**************************************************************
090100*      THIS IS THE PROV-RECORD THAT IS PASSED FROM THE       *
090200*      LTDRV___ PROGRAM TO THE LTCAL___ PROGRAM              *
090300**************************************************************
090400 01  PROV-NEW-HOLD.
090500     02  PROV-NEWREC-HOLD1.
090600         05  P-NEW-NPI10.
090700             10  P-NEW-NPI8             PIC X(08).
090800             10  P-NEW-NPI-FILLER       PIC X(02).
090900         05  P-NEW-PROVIDER-NO.
091000             10  P-NEW-STATE            PIC 9(02).
091100             10  P-NEW-STATE-X REDEFINES
091200                 P-NEW-STATE            PIC X(02).
091300             10  FILLER                 PIC X(04).
091400         05  P-NEW-DATE-DATA.
091500             10  P-NEW-EFF-DATE.
091600                 15  P-NEW-EFF-DT-CC    PIC 9(02).
091700                 15  P-NEW-EFF-DT-YY    PIC 9(02).
091800                 15  P-NEW-EFF-DT-MM    PIC 9(02).
091900                 15  P-NEW-EFF-DT-DD    PIC 9(02).
092000             10  P-NEW-FY-BEGIN-DATE.
092100                 15  P-NEW-FY-BEG-DT-CC PIC 9(02).
092200                 15  P-NEW-FY-BEG-DT-YY PIC 9(02).
092300                 15  P-NEW-FY-BEG-DT-MM PIC 9(02).
092400                 15  P-NEW-FY-BEG-DT-DD PIC 9(02).
092500             10  P-NEW-REPORT-DATE.
092600                 15  P-NEW-REPORT-DT-CC PIC 9(02).
092700                 15  P-NEW-REPORT-DT-YY PIC 9(02).
092800                 15  P-NEW-REPORT-DT-MM PIC 9(02).
092900                 15  P-NEW-REPORT-DT-DD PIC 9(02).
093000             10  P-NEW-TERMINATION-DATE.
093100                 15  P-NEW-TERM-DT-CC   PIC 9(02).
093200                 15  P-NEW-TERM-DT-YY   PIC 9(02).
093300                 15  P-NEW-TERM-DT-MM   PIC 9(02).
093400                 15  P-NEW-TERM-DT-DD   PIC 9(02).
093500         05  P-NEW-WAIVER-CODE          PIC X(01).
093600             88  P-NEW-WAIVER-STATE       VALUE 'Y'.
093700         05  P-NEW-INTER-NO             PIC 9(05).
093800         05  P-NEW-PROVIDER-TYPE        PIC X(02).
093900         05  P-NEW-CURRENT-CENSUS-DIV   PIC 9(01).
094000         05  P-NEW-CURRENT-DIV   REDEFINES
094100                    P-NEW-CURRENT-CENSUS-DIV   PIC 9(01).
094200         05  P-NEW-MSA-DATA.
094300             10  P-NEW-CHG-CODE-INDEX       PIC X.
094400             10  P-NEW-GEO-LOC-MSAX         PIC X(04) JUST RIGHT.
094500             10  P-NEW-GEO-LOC-MSA9   REDEFINES
094600                             P-NEW-GEO-LOC-MSAX  PIC 9(04).
094700             10  P-NEW-GEO-LOC-MSA-AST REDEFINES
094800                             P-NEW-GEO-LOC-MSAX.
094900                 15  P-NEW-GEO-MSA-1ST    PIC X.
095000                 15  P-NEW-GEO-MSA-2ND    PIC X.
095100                 15  P-NEW-GEO-MSA-3RD    PIC X.
095200                 15  P-NEW-GEO-MSA-4TH    PIC X.
095300             10  P-NEW-WAGE-INDEX-LOC-MSA   PIC X(04) JUST RIGHT.
095400             10  P-NEW-STAND-AMT-LOC-MSA    PIC X(04) JUST RIGHT.
095500             10  P-NEW-STAND-AMT-LOC-MSA9
095600                   REDEFINES P-NEW-STAND-AMT-LOC-MSA.
095700                 15  P-NEW-RURAL-1ST.
095800                     20  P-NEW-STAND-RURAL  PIC XX.
095900                         88  P-NEW-STD-RURAL-CHECK VALUE '  '.
096000                 15  P-NEW-RURAL-2ND        PIC XX.
096100         05  P-NEW-SOL-COM-DEP-HOSP-YR PIC XX.
096200                 88  P-NEW-SCH-YRBLANK    VALUE   '  '.
096300                 88  P-NEW-SCH-YR82       VALUE   '82'.
096400                 88  P-NEW-SCH-YR87       VALUE   '87'.
096500         05  P-NEW-LUGAR                    PIC X.
096600         05  P-NEW-TEMP-RELIEF-IND          PIC X.
096700         05  P-NEW-FED-PPS-BLEND-IND        PIC X.
096800         05  P-NEW-STATE-CODE               PIC 9(02).
096900         05  P-NEW-STATE-CODE-X REDEFINES
097000               P-NEW-STATE-CODE             PIC X(02).
097100         05  FILLER                         PIC X(03).
097200     02  PROV-NEWREC-HOLD2.
097300         05  P-NEW-VARIABLES.
097400             10  P-NEW-FAC-SPEC-RATE     PIC  9(05)V9(02).
097500             10  P-NEW-COLA              PIC  9(01)V9(03).
097600             10  P-NEW-INTERN-RATIO      PIC  9(01)V9(04).
097700             10  P-NEW-BED-SIZE          PIC  9(05).
097800             10  P-NEW-CCR               PIC  9(01)V9(03).
097900             10  P-NEW-CMI               PIC  9(01)V9(04).
098000             10  P-NEW-SSI-RATIO         PIC  V9(04).
098100             10  P-NEW-MEDICAID-RATIO    PIC  V9(04).
098200             10  P-NEW-PPS-BLEND-YR-IND  PIC  X(01).
098300             10  P-NEW-PRUP-UPDTE-FACTOR PIC  9(01)V9(05).
098400             10  P-NEW-DSH-PERCENT       PIC  V9(04).
098500             10  P-NEW-FYE-DATE.
098600                 15  P-NEW-FYE-CC        PIC 99.
098700                 15  P-NEW-FYE-YY        PIC 99.
098800                 15  P-NEW-FYE-MM        PIC 99.
098900                 15  P-NEW-FYE-DD        PIC 99.
099000         05  P-NEW-CBSA-SPEC-PAY-IND       PIC X(01).
099100         05  P-NEW-HOSP-QUAL-IND           PIC X(01).
099200         05  P-NEW-GEO-LOC-CBSAX           PIC X(05) JUST RIGHT.
099300         05  P-NEW-GEO-LOC-CBSA9 REDEFINES
099400                          P-NEW-GEO-LOC-CBSAX PIC 9(05).
099500         05  P-NEW-GEO-LOC-CBSA-AST REDEFINES
099600                          P-NEW-GEO-LOC-CBSAX.
099700             10 P-NEW-GEO-LOC-CBSA-1ST     PIC X.
099800             10 P-NEW-GEO-LOC-CBSA-2ND     PIC X.
099900             10 P-NEW-GEO-LOC-CBSA-3RD     PIC X.
100000             10 P-NEW-GEO-LOC-CBSA-4TH     PIC X.
100100             10 P-NEW-GEO-LOC-CBSA-5TH     PIC X.
100200         05 P-NEW-GEO-LOC-CBSA-SIZE REDEFINES
100300                          P-NEW-GEO-LOC-CBSAX.
100400             10 P-NEW-GEO-LOC-CBSA-123     PIC X(03).
100500                88  P-NEW-RURAL-CBSA       VALUE '   '.
100600             10 P-NEW-GEO-LOC-CBSA-45      PIC X(02).
100700         05  FILLER                        PIC X(10).
100800         05  P-NEW-SPECIAL-WAGE-INDEX      PIC 9(02)V9(04).
100900     02  PROV-NEWREC-HOLD3.
101000         05  P-NEW-PASS-AMT-DATA.
101100             10  P-NEW-PASS-AMT-CAPITAL    PIC 9(04)V99.
101200             10  P-NEW-PASS-AMT-DIR-MED-ED PIC 9(04)V99.
101300             10  P-NEW-PASS-AMT-ORGAN-ACQ  PIC 9(04)V99.
101400             10  P-NEW-PASS-AMT-PLUS-MISC  PIC 9(04)V99.
101500         05  P-NEW-CAPI-DATA.
101600             15  P-NEW-CAPI-PPS-PAY-CODE   PIC X.
101700             15  P-NEW-CAPI-HOSP-SPEC-RATE PIC 9(04)V99.
101800             15  P-NEW-CAPI-OLD-HARM-RATE  PIC 9(04)V99.
101900             15  P-NEW-CAPI-NEW-HARM-RATIO PIC 9(01)V9999.
102000             15  P-NEW-CAPI-CSTCHG-RATIO   PIC 9V999.
102100             15  P-NEW-CAPI-NEW-HOSP       PIC X.
102200             15  P-NEW-CAPI-IME            PIC 9V9999.
102300             15  P-NEW-CAPI-EXCEPTIONS     PIC 9(04)V99.
102400             15  P-VAL-BASED-PURCH-SCORE   PIC 9V999.
102500         05  FILLER                        PIC X(18).
102600
102700
102800**************************************************************
102900*      THIS IS THE BILL-RECORD THAT WILL BE PASSED TO        *
103000*      THE LTCAL___ PROGRAM FOR FYS 2003 - 2015 OCT - DEC    *
103100**************************************************************
103200 01  BILL-DATA-FY03-FY15.
103300     05  B-03TO15-NPI10.
103400         10  B-03TO15-NPI8            PIC X(08).
103500         10  B-03TO15-NPI-FILLER      PIC X(02).
103600     05  B-03TO15-PROVIDER-NO         PIC X(06).
103700     05  B-03TO15-PATIENT-STATUS      PIC X(02).
103800     05  B-03TO15-DRG-CODE            PIC X(03).
103900     05  B-03TO15-LOS                 PIC 9(03).
104000     05  B-03TO15-COV-DAYS            PIC 9(03).
104100     05  B-03TO15-LTR-DAYS            PIC 9(02).
104200     05  B-03TO15-DISCHARGE-DATE.
104300         10  B-03TO15-DISCHG-CC       PIC 9(02).
104400         10  B-03TO15-DISCHG-YY       PIC 9(02).
104500         10  B-03TO15-DISCHG-MM       PIC 9(02).
104600         10  B-03TO15-DISCHG-DD       PIC 9(02).
104700     05  B-03TO15-COV-CHARGES         PIC 9(07)V9(02).
104800     05  B-03TO15-SPEC-PAY-IND        PIC X(01).
104900     05  FILLER                       PIC X(13).
105000
105100
105200***************************************************************
105300 LINKAGE SECTION.
105400***************************************************************
105500
105600**************************************************************
105700*      THIS IS THE BILL-RECORD THAT WILL BE PASSED TO        *
105800*      THE LTCAL___ PROGRAM FOR FYS 2015 (JANUARY) & LATER   *
105900**************************************************************
106000 01  BILL-NEW-DATA.
106100     05  B-NPI10.
106200         10  B-NPI8                   PIC X(08).
106300         10  B-NPI-FILLER             PIC X(02).
106400     05  B-PROVIDER-NO                PIC X(06).
106500     05  B-PATIENT-STATUS             PIC X(02).
106600     05  B-DRG-CODE                   PIC X(03).
106700     05  B-LOS                        PIC 9(03).
106800     05  B-COV-DAYS                   PIC 9(03).
106900     05  B-LTR-DAYS                   PIC 9(02).
107000     05  B-CST-RPT-DAYS               PIC 9(03).
107100     05  B-DISCHARGE-DATE.
107200         10  B-DISCHG-CC              PIC 9(02).
107300         10  B-DISCHG-YY              PIC 9(02).
107400         10  B-DISCHG-MM              PIC 9(02).
107500         10  B-DISCHG-DD              PIC 9(02).
107600     05  B-COV-CHARGES                PIC 9(07)V9(02).
107700     05  B-SPEC-PAY-IND               PIC X(01).
107800     05  B-REVIEW-CODE                PIC 9(02).
107900     05  B-DIAGNOSIS-CODE-TABLE.
108000         10  B-DIAGNOSIS-CODE         PIC X(07) OCCURS 25 TIMES
108100                                      INDEXED BY IDX-DIAG.
108200     05  B-PROCEDURE-CODE-TABLE.
108300         10 B-PROCEDURE-CODE          PIC X(07) OCCURS 25 TIMES
108400                                      INDEXED BY IDX-PROC.
108500     05  B-LTCH-DPP-INDICATOR-SW      PIC X.
108600         88 B-LTCH-DPP-ADJUSTMENT     VALUE 'Y'.
108700     05  FILLER                       PIC X(19).
108800
108900
109000**************************************************************
109100*      THIS IS THE PPS DATA PASSED TO THE LTCAL___ PROGRAM   *
109200*      IT WILL BE PASSED BACK TO THE LTDRV___ PROGRAM        *
109300**************************************************************
109400 01  PPS-DATA-ALL.
109500     05  PPS-RTC                      PIC X(02).
109600     05  PPS-CHRG-THRESHOLD           PIC 9(07)V9(02).
109700     05  PPS-DATA.
109800         10  PPS-MSA                  PIC X(04).
109900         10  PPS-WAGE-INDEX           PIC 9(02)V9(04).
110000         10  PPS-AVG-LOS              PIC 9(02)V9(01).
110100         10  PPS-RELATIVE-WGT         PIC 9(01)V9(04).
110200         10  PPS-OUTLIER-PAY-AMT      PIC 9(07)V9(02).
110300         10  PPS-LOS                  PIC 9(03).
110400         10  PPS-DRG-ADJ-PAY-AMT      PIC 9(07)V9(02).
110500         10  PPS-FED-PAY-AMT          PIC 9(07)V9(02).
110600         10  PPS-FINAL-PAY-AMT        PIC 9(07)V9(02).
110700         10  PPS-FAC-COSTS            PIC 9(07)V9(02).
110800         10  PPS-NEW-FAC-SPEC-RATE    PIC 9(07)V9(02).
110900         10  PPS-OUTLIER-THRESHOLD    PIC 9(07)V9(02).
111000         10  PPS-SUBM-DRG-CODE        PIC X(03).
111100         10  PPS-CALC-VERS-CD         PIC X(05).
111200         10  PPS-REG-DAYS-USED        PIC 9(03).
111300         10  PPS-LTR-DAYS-USED        PIC 9(03).
111400         10  PPS-BLEND-YEAR           PIC 9(01).
111500         10  PPS-COLA                 PIC 9(01)V9(03).
111600         10  FILLER                   PIC X(04).
111700    05  PPS-OTHER-DATA.
111800         10  PPS-NAT-LABOR-PCT        PIC 9(01)V9(05).
111900         10  PPS-NAT-NONLABOR-PCT     PIC 9(01)V9(05).
112000         10  PPS-STD-FED-RATE         PIC 9(05)V9(02).
112100         10  PPS-BDGT-NEUT-RATE       PIC 9(01)V9(03).
112200         10  PPS-IPTHRESH             PIC 9(03)V9(01).
112300         10  PPS-LTCH-DPP-ADJ-AMT     PIC S9(09)V99.
112400         10  FILLER                   PIC X(05).
112500    05  PPS-PC-DATA.
112600         10  PPS-COT-IND              PIC X(01).
112700         10  FILLER                   PIC X(20).
112800
112900 01  PPS-CBSA                         PIC X(05).
113000
113100 01  PPS-PAYMENT-DATA.
113200     05  PPS-SITE-NEUTRAL-COST-PMT    PIC 9(07)V99.
113300     05  PPS-SITE-NEUTRAL-IPPS-PMT    PIC 9(07)V99.
113400     05  PPS-STANDARD-FULL-PMT        PIC 9(07)V99.
113500     05  PPS-STANDARD-SSO-PMT         PIC 9(07)V99.
113600
113700*****************************************************************
113800*            THESE ARE THE VERSIONS OF THE LTDRV___             *
113900*           PROGRAMS THAT WILL BE PASSED BACK----               *
114000*          ASSOCIATED WITH THE BILL BEING PROCESSED             *
114100*****************************************************************
114200 01  PRICER-OPT-VERS-SW.
114300     05  PRICER-OPTION-SW               PIC X(01).
114400         88  ALL-TABLES-PASSED          VALUE 'A'.
114500         88  PROV-RECORD-PASSED         VALUE 'P'.
114600     05  PPS-VERSIONS.
114700         10  PPDRV-VERSION              PIC X(05).
114800
114900
115000
115100**************************************************************
115200*      PROVIDER SPECIFIC RECORD                              *
115300**************************************************************
115400*      THIS IS THE PROV-RECORD THAT IS PASSED FROM THE       *
115500*      LTOPN___ PROGRAM                                      *
115600**************************************************************
115700 01  PROV-RECORD.
115800     05  PROV-REC1                  PIC X(80).
115900     05  PROV-REC2                  PIC X(80).
116000     05  PROV-REC3                  PIC X(80).
116100
116200
116300**************************************************************
116400*      LTCH CBSA WAGE INDEX TABLE                            *
116500**************************************************************
116600*      THIS IS THE CBSA WAGE INDEX TABLE THAT IS PASSED FROM *
116700*      THE LTOPN___ PROGRAM                                  *
116800**************************************************************
116900 01  CBSA-WI-TABLE.
117000     05  C-CBSA-DATA  OCCURS 0 TO 7000 TIMES
117100                      DEPENDING ON CBSA-CNT
117200                      ASCENDING KEY IS CBSAX-CBSA
117300                      INDEXED BY CU1 CU2.
117400         10  CBSAX-CBSA         PIC X(05).
117500         10  CBSAX-EFF-DATE     PIC X(08).
117600         10  CBSAX-WAGE-INDEX1  PIC S9(02)V9(04).
117700         10  CBSAX-WAGE-INDEX2  PIC S9(02)V9(04).
117800         10  CBSAX-WAGE-INDEX3  PIC S9(02)V9(04).
117900
118000
118100**************************************************************
118200*      IPPS CBSA WAGE INDEX TABLE                            *
118300**************************************************************
118400*      THIS IS THE IPPS CBSA WAGE INDEX TABLE THAT IS PASSED *
118500*      FROM THE LTOPN___ PROGRAM                             *
118600**************************************************************
118700 01  IPPS-CBSA-WI-TABLE.
118800     05  T-CBSA-DATA  OCCURS 0 TO 10000 TIMES
118900                      DEPENDING ON IPPS-CBSA-CNT
119000                      ASCENDING KEY IS T-CBSA
119100                      INDEXED BY MA1 MA2 MA3.
119200         10  T-CBSA             PIC X(5).
119300         10  T-CBSA-SIZE        PIC X(01).
119400         10  T-CBSA-EFF-DATE    PIC X(08).
119500         10  T-CBSA-WAGE-INDX1  PIC S9(02)V9(04).
119600         10  T-CBSA-WAGE-INDX2  PIC S9(02)V9(04).
119700
119800
119900**************************************************************
120000*      LTCH MSA WAGE INDEX TABLE                             *
120100**************************************************************
120200*      THIS IS THE MSA WAGE INDEX TABLE THAT IS PASSED FROM  *
120300*      THE LTOPN___ PROGRAM                                  *
120400**************************************************************
120500 01  MSA-WI-TABLE.
120600     05  M-MSA-DATA   OCCURS 0 TO 4000 TIMES
120700                      DEPENDING ON MSA-CNT
120800                      ASCENDING KEY IS MSAX-MSA
120900                      INDEXED BY MU1 MU2.
121000         10  MSAX-MSA          PIC X(4).
121100         10  MSAX-EFF-DATE     PIC X(08).
121200         10  MSAX-WAGE-INDEX1  PIC S9(02)V9(04).
121300         10  MSAX-WAGE-INDEX2  PIC S9(02)V9(04).
121400         10  MSAX-WAGE-INDEX3  PIC S9(02)V9(04).
121500
121600
121700**************************************************************
121800*  INPUT FILE RECORD COUNTS                                  *
121900**************************************************************
122000 01  WORK-COUNTERS.
122100     05  CBSA-CNT              PIC 9(5).
122200     05  MSA-CNT               PIC 9(5).
122300     05  PROV-CNT              PIC 9(5).
122400     05  IPPS-CBSA-CNT         PIC 9(5).
122500
122600
122700
122800
122900 PROCEDURE DIVISION  USING BILL-NEW-DATA
123000                           PPS-DATA-ALL
123100                           PPS-CBSA
123200                           PPS-PAYMENT-DATA
123300                           PRICER-OPT-VERS-SW
123400                           PROV-RECORD
123500                           CBSA-WI-TABLE
123600                           IPPS-CBSA-WI-TABLE
123700                           MSA-WI-TABLE
123800                           WORK-COUNTERS.
123900
124000
124100******************************************************************
124200*                                                                *
124300*    PROCESSING:                                                 *
124400*      A. THIS MODULE WILL RETRIEVE THE WAGE INDEX RECORD(S)     *
124500*         NEEDED FOR EACH BILL.                                  *
124600*      B. THIS MODULE WILL CALL THE LTCAL MODULES.               *
124700*      C. THE PROV-RECORD AND WAGE-INDEX-RECORD(S) ASSOCIATED    *
124800*         WITH EACH BILL WILL BE PASSED TO THE LTCAL PROGRAMS.   *
124900*                                                                *
125000******************************************************************
125100
125200     MOVE DRV-VERSION TO PPDRV-VERSION.
125300
125400*----------------------------------------------------------*
125500* INITIALIZE VARIABLES                                     *
125600*----------------------------------------------------------*
125700     INITIALIZE PPS-DATA-ALL
125800                PPS-CBSA
125900                HOLD-PROV-MSA
126000                HOLD-PROV-CBSA
126100                HOLD-PROV-IPPS-CBSA
126200                HOLD-PROV-IPPS-CBSA-RURAL
126300                WAGE-NEW-INDEX-RECORD-MSA
126400                WAGE-NEW-INDEX-RECORD-CBSA
126500                WAGE-IPPS-INDEX-RECORD-CBSA
126600                W-IPPS-PR-WAGE-INDEX-RUR
126700                WAGE-IPPS-INDEX-RURAL-CBSA
126800                W-FY-BEGIN-CC
126900                W-FY-BEGIN-YY
127000                W-FY-END-CC
127100                W-FY-END-YY
127200                BILL-DATA-FY03-FY15
127300                PPS-PAYMENT-DATA.
127400
127500     MOVE PROV-RECORD TO PROV-NEW-HOLD.
127600
127700
127800*----------------------------------------------------------*
127900* RTC = 98  --  BILL DISCHARGE DATE BEFORE 10/01/2002      *
128000*----------------------------------------------------------*
128100     IF B-DISCHARGE-DATE < 20021001
128200        MOVE 98 TO PPS-RTC
128300        GOBACK
128400     END-IF.
128500
128600
128700*-----------------------------------------------------------*
128800* IF CLAIM DISCHARGED BEFORE JAN 2015, MOVE INPUT BILL DATA *
128900* TO OLD BILL RECORD LAYOUT TO PASS TO PRE-JAN 2015 VERSIONS*
129000* OF PROGRAM LTCAL***                                       *
129100*-----------------------------------------------------------*
129200     IF B-DISCHARGE-DATE < 20150101
129300        MOVE B-NPI8           TO B-03TO15-NPI8
129400        MOVE B-PROVIDER-NO    TO B-03TO15-PROVIDER-NO
129500        MOVE B-PATIENT-STATUS TO B-03TO15-PATIENT-STATUS
129600        MOVE B-DRG-CODE       TO B-03TO15-DRG-CODE
129700        MOVE B-LOS            TO B-03TO15-LOS
129800        MOVE B-COV-DAYS       TO B-03TO15-COV-DAYS
129900        MOVE B-LTR-DAYS       TO B-03TO15-LTR-DAYS
130000        MOVE B-DISCHG-CC      TO B-03TO15-DISCHG-CC
130100        MOVE B-DISCHG-YY      TO B-03TO15-DISCHG-YY
130200        MOVE B-DISCHG-MM      TO B-03TO15-DISCHG-MM
130300        MOVE B-DISCHG-DD      TO B-03TO15-DISCHG-DD
130400        MOVE B-COV-CHARGES    TO B-03TO15-COV-CHARGES
130500        MOVE B-SPEC-PAY-IND   TO B-03TO15-SPEC-PAY-IND
130600     END-IF.
130700
130800
130900*----------------------------------------------------------*
131000* SET FY BEGIN AND END DATES USING BILL DISCHARGE DATE     *
131100*----------------------------------------------------------*
131200     MOVE B-DISCHG-CC TO W-FY-BEGIN-CC.
131300     MOVE B-DISCHG-CC TO W-FY-END-CC.
131400
131500*----------------------------------*
131600* FOR CLAIMS DISCHARGED JAN - SEPT *
131700*----------------------------------*
131800     IF B-DISCHG-MM >= 01 AND
131900        B-DISCHG-MM <= 09
132000        COMPUTE W-FY-BEGIN-YY = B-DISCHG-YY - 1
132100        MOVE B-DISCHG-YY TO W-FY-END-YY
132200
132300*----------------------------------*
132400* FOR CLAIMS DISCHARGED OCT - DEC  *
132500*----------------------------------*
132600     ELSE
132700        MOVE B-DISCHG-YY TO W-FY-BEGIN-YY
132800        COMPUTE W-FY-END-YY = B-DISCHG-YY + 1
132900     END-IF.
133000
133100
133200
133300************************************************************
133400*    GET THE WAGE-INDEX RECORD                             *
133500************************************************************
133600
133700*------------------------------------------------*
133800* EDIT THE CBSA AND MSA FROM THE PROVIDER RECORD *
133900*------------------------------------------------*
134000     IF P-NEW-GEO-LOC-CBSAX = SPACES
134100        MOVE ZEROS TO P-NEW-GEO-LOC-CBSAX
134200     END-IF.
134300
134400     IF P-NEW-GEO-LOC-MSAX = SPACES
134500        MOVE ZEROS TO P-NEW-GEO-LOC-MSAX
134600     END-IF.
134700
134800     IF P-NEW-EFF-DATE > 20050701
134900        IF '*' = P-NEW-GEO-LOC-CBSA-1ST OR
135000                 P-NEW-GEO-LOC-CBSA-2ND OR
135100                 P-NEW-GEO-LOC-CBSA-3RD OR
135200                 P-NEW-GEO-LOC-CBSA-4TH OR
135300                 P-NEW-GEO-LOC-CBSA-5TH
135400           MOVE 60 TO PPS-RTC
135500           GOBACK
135600        END-IF
135700     END-IF.
135800
135900*----------------------------------------------------------*
136000* DETERMINE WHETHER TO GET THE LTCH MSA OR CBSA WAGE INDEX *
136100*----------------------------------------------------------*
136200     IF B-DISCHARGE-DATE < 20050701
136300       SET MU1 TO 1
136400       PERFORM 0500-GET-MSA THRU 0500-EXIT
136500     ELSE
136600       SET CU1 TO 1
136700       PERFORM 0550-GET-CBSA THRU 0550-EXIT
136800       IF W-NEW-INDEX3-RECORD-C = 0
136900          MOVE 52 TO PPS-RTC
137000     END-IF.
137100
137200*----------------------------------------------------------*
137300* GET THE IPPS CBSA WAGE INDEX FOR CLAIMS DISCHARGED AFTER *
137400* JUNE 30, 2006 FOR USE IN THE 4TH SHORT STAY PROVISION    *
137500*----------------------------------------------------------*
137600     IF B-DISCHARGE-DATE > 20060630
137700       SET MA1 TO 1
137800       PERFORM 0575-GET-IPPS-CBSA THRU 0575-EXIT
137900       IF W-IPPS-WAGE-INDEX = 0
138000          MOVE 52 TO PPS-RTC
138100       END-IF
138200     END-IF.
138300
138400*--------------------------------------------------------------*
138500* RTC = 60  --  LTCH/IPPS CBSA/MSA WAGE INDEX RECORD NOT FOUND *
138600* RTC = 52  --  LTCH/IPPS CBSA/MSA WAGE INDEX INVALID          *
138700*--------------------------------------------------------------*
138800     IF PPS-RTC = 60 OR PPS-RTC = 52
138900        GOBACK
139000     END-IF.
139100
139200
139300
139400******************************************************************
139500******************************************************************
139600**                                                              **
139700**          THIS NEXT CALL WILL PROCESS BILLS WITH              **
139800**          A DISCHARGE DATE ON OR AFTER 20021001               **
139900**                                                              **
140000**--------------------------------------------------------------**
140100**                                                              **
140200** FOR BILLS WITH DISCHARGE DATES AFTER 20050630, INCLUDE FIELD **
140300** PPS-CBSA IN THE CALL USING STATEMENT, OMIT THIS FIELD FOR    **
140400** BILLS WITH DISCHARGE DATES BEFORE 20050701.                  **
140500**                                                              **
140600** FOR BILLS WITH DISCHARGE DATES AFTER 20060630, INCLUDE FIELD **
140700** WAGE-IPPS-INDEX-RECORD-CBSA.                                 **
140800**                                                              **
140900******************************************************************
141000******************************************************************
141100
141200
141300*----------------------------------------------------------------*
141400*        FISCAL YEAR 2020
141500*----------------------------------------------------------------*
141600         IF B-DISCHARGE-DATE > 20190930
141700            CALL LTCAL202 USING BILL-NEW-DATA
141800                                PPS-DATA-ALL
141900                                PPS-CBSA
142000                                PPS-PAYMENT-DATA
142100                                PRICER-OPT-VERS-SW
142200                                PROV-NEW-HOLD
142300                                WAGE-NEW-INDEX-RECORD-CBSA
142400                                WAGE-IPPS-INDEX-RECORD-CBSA.
142500
142600
142700*----------------------------------------------------------------*
142800*        FISCAL YEAR 2019
142900*----------------------------------------------------------------*
143000         IF B-DISCHARGE-DATE > 20180930 AND
143100                             < 20191001
143200            CALL LTCAL190 USING BILL-NEW-DATA
143300                                PPS-DATA-ALL
143400                                PPS-CBSA
143500                                PPS-PAYMENT-DATA
143600                                PRICER-OPT-VERS-SW
143700                                PROV-NEW-HOLD
143800                                WAGE-NEW-INDEX-RECORD-CBSA
143900                                WAGE-IPPS-INDEX-RECORD-CBSA.
144000
144100
144200*----------------------------------------------------------------*
144300*        FISCAL YEAR 2018
144400*----------------------------------------------------------------*
144500         IF B-DISCHARGE-DATE > 20170930 AND
144600                             < 20181001
144700            CALL LTCAL183 USING BILL-NEW-DATA
144800                                PPS-DATA-ALL
144900                                PPS-CBSA
145000                                PPS-PAYMENT-DATA
145100                                PRICER-OPT-VERS-SW
145200                                PROV-NEW-HOLD
145300                                WAGE-NEW-INDEX-RECORD-CBSA
145400                                WAGE-IPPS-INDEX-RECORD-CBSA.
145500
145600
145700*----------------------------------------------------------------*
145800*        FISCAL YEAR 2017
145900*----------------------------------------------------------------*
146000         IF B-DISCHARGE-DATE > 20160930 AND
146100                             < 20171001
146200            CALL LTCAL170 USING BILL-NEW-DATA
146300                                PPS-DATA-ALL
146400                                PPS-CBSA
146500                                PPS-PAYMENT-DATA
146600                                PRICER-OPT-VERS-SW
146700                                PROV-NEW-HOLD
146800                                WAGE-NEW-INDEX-RECORD-CBSA
146900                                WAGE-IPPS-INDEX-RECORD-CBSA.
147000
147100
147200*----------------------------------------------------------------*
147300*        FISCAL YEAR 2016
147400*----------------------------------------------------------------*
147500         IF B-DISCHARGE-DATE > 20150930 AND
147600                             < 20161001
147700            CALL LTCAL162 USING BILL-NEW-DATA
147800                                PPS-DATA-ALL
147900                                PPS-CBSA
148000                                PPS-PAYMENT-DATA
148100                                PRICER-OPT-VERS-SW
148200                                PROV-NEW-HOLD
148300                                WAGE-NEW-INDEX-RECORD-CBSA
148400                                WAGE-IPPS-INDEX-RECORD-CBSA.
148500
148600*----------------------------------------------------------------*
148700*        FISCAL YEAR 2015, 01/01/2015 - 09/30/2015               *
148800*----------------------------------------------------------------*
148900         IF B-DISCHARGE-DATE > 20141231 AND
149000                             < 20151001
149100            CALL LTCAL154 USING BILL-NEW-DATA
149200                                PPS-DATA-ALL
149300                                PPS-CBSA
149400                                PRICER-OPT-VERS-SW
149500                                PROV-NEW-HOLD
149600                                WAGE-NEW-INDEX-RECORD-CBSA
149700                                WAGE-IPPS-INDEX-RECORD-CBSA.
149800
149900*----------------------------------------------------------------*
150000*        FISCAL YEAR 2015, 10/01/2014 - 12/31/2014               *
150100*----------------------------------------------------------------*
150200         IF B-DISCHARGE-DATE > 20140930 AND
150300                             < 20150101
150400            CALL LTCAL152 USING BILL-DATA-FY03-FY15
150500                                PPS-DATA-ALL
150600                                PPS-CBSA
150700                                PRICER-OPT-VERS-SW
150800                                PROV-NEW-HOLD
150900                                WAGE-NEW-INDEX-RECORD-CBSA
151000                                WAGE-IPPS-INDEX-RECORD-CBSA.
151100
151200*----------------------------------------------------------------*
151300*        FISCAL YEAR 2014, RATE YEAR 2014 (AFTER 10/1/2013)      *
151400*----------------------------------------------------------------*
151500         IF B-DISCHARGE-DATE > 20130930 AND
151600                             < 20141001
151700            CALL LTCAL141 USING BILL-DATA-FY03-FY15
151800                                PPS-DATA-ALL
151900                                PPS-CBSA
152000                                PRICER-OPT-VERS-SW
152100                                PROV-NEW-HOLD
152200                                WAGE-NEW-INDEX-RECORD-CBSA
152300                                WAGE-IPPS-INDEX-RECORD-CBSA.
152400
152500*----------------------------------------------------------------*
152600*        FISCAL YEAR 2013, RATE YEAR 2013 (AFTER 10/1/2012)      *
152700*----------------------------------------------------------------*
152800         IF B-DISCHARGE-DATE > 20120930 AND
152900                             < 20131001
153000            CALL LTCAL130 USING BILL-DATA-FY03-FY15
153100                                PPS-DATA-ALL
153200                                PPS-CBSA
153300                                PRICER-OPT-VERS-SW
153400                                PROV-NEW-HOLD
153500                                WAGE-NEW-INDEX-RECORD-CBSA
153600                                WAGE-IPPS-INDEX-RECORD-CBSA.
153700
153800*----------------------------------------------------------------*
153900*        FISCAL YEAR 2012, RATE YEAR 2012 (AFTER 10/1/2011)      *
154000*----------------------------------------------------------------*
154100         IF B-DISCHARGE-DATE > 20110930 AND
154200                             < 20121001
154300            CALL LTCAL123 USING BILL-DATA-FY03-FY15
154400                                PPS-DATA-ALL
154500                                PPS-CBSA
154600                                PRICER-OPT-VERS-SW
154700                                PROV-NEW-HOLD
154800                                WAGE-NEW-INDEX-RECORD-CBSA
154900                                WAGE-IPPS-INDEX-RECORD-CBSA.
155000
155100*----------------------------------------------------------------*
155200*        FISCAL YEAR 2011, RATE YEAR 2011 (AFTER 10/1/2010)      *
155300*----------------------------------------------------------------*
155400         IF B-DISCHARGE-DATE > 20100930 AND
155500                             < 20111001
155600            CALL LTCAL111 USING BILL-DATA-FY03-FY15
155700                                PPS-DATA-ALL
155800                                PPS-CBSA
155900                                PRICER-OPT-VERS-SW
156000                                PROV-NEW-HOLD
156100                                WAGE-NEW-INDEX-RECORD-CBSA
156200                                WAGE-IPPS-INDEX-RECORD-CBSA.
156300
156400*----------------------------------------------------------------*
156500*        FISCAL YEAR 2010, RATE YEAR 2010 (AFTER 3/31/2010)      *
156600*----------------------------------------------------------------*
156700         IF B-DISCHARGE-DATE > 20100331 AND
156800                             < 20101001
156900            CALL LTCAL105 USING BILL-DATA-FY03-FY15
157000                                PPS-DATA-ALL
157100                                PPS-CBSA
157200                                PRICER-OPT-VERS-SW
157300                                PROV-NEW-HOLD
157400                                WAGE-NEW-INDEX-RECORD-CBSA
157500                                WAGE-IPPS-INDEX-RECORD-CBSA.
157600
157700*----------------------------------------------------------------*
157800*        FISCAL YEAR 2010, RATE YEAR 2010 (BEFORE 4/1/2010)      *
157900*----------------------------------------------------------------*
158000         IF B-DISCHARGE-DATE > 20090930 AND
158100                             < 20100401
158200            CALL LTCAL103 USING BILL-DATA-FY03-FY15
158300                                PPS-DATA-ALL
158400                                PPS-CBSA
158500                                PRICER-OPT-VERS-SW
158600                                PROV-NEW-HOLD
158700                                WAGE-NEW-INDEX-RECORD-CBSA
158800                                WAGE-IPPS-INDEX-RECORD-CBSA.
158900
159000*----------------------------------------------------------------*
159100*        FISCAL YEAR 2009, RATE YEAR 2009 (AFTER 6/2/2009)       *
159200*----------------------------------------------------------------*
159300         IF B-DISCHARGE-DATE > 20090602 AND
159400                             < 20091001
159500            CALL LTCAL095 USING BILL-DATA-FY03-FY15
159600                                PPS-DATA-ALL
159700                                PPS-CBSA
159800                                PRICER-OPT-VERS-SW
159900                                PROV-NEW-HOLD
160000                                WAGE-NEW-INDEX-RECORD-CBSA
160100                                WAGE-IPPS-INDEX-RECORD-CBSA.
160200
160300*----------------------------------------------------------------*
160400*        FISCAL YEAR 2009, RATE YEAR 2009 (BEFORE 6/3/2009)      *
160500*----------------------------------------------------------------*
160600         IF B-DISCHARGE-DATE > 20080930 AND
160700                             < 20090603
160800            CALL LTCAL094 USING BILL-DATA-FY03-FY15
160900                                PPS-DATA-ALL
161000                                PPS-CBSA
161100                                PRICER-OPT-VERS-SW
161200                                PROV-NEW-HOLD
161300                                WAGE-NEW-INDEX-RECORD-CBSA
161400                                WAGE-IPPS-INDEX-RECORD-CBSA.
161500
161600*----------------------------------------------------------------*
161700*        FISCAL YEAR 2008, RATE YEAR 2009                        *
161800*----------------------------------------------------------------*
161900         IF B-DISCHARGE-DATE > 20080630 AND
162000                             < 20081001
162100            CALL LTCAL091 USING BILL-DATA-FY03-FY15
162200                                PPS-DATA-ALL
162300                                PPS-CBSA
162400                                PRICER-OPT-VERS-SW
162500                                PROV-NEW-HOLD
162600                                WAGE-NEW-INDEX-RECORD-CBSA
162700                                WAGE-IPPS-INDEX-RECORD-CBSA.
162800
162900*----------------------------------------------------------------*
163000*        FISCAL YEAR 2008, RATE YEAR 2008                        *
163100*----------------------------------------------------------------*
163200         IF B-DISCHARGE-DATE > 20070930 AND
163300                             < 20080701
163400            CALL LTCAL087 USING BILL-DATA-FY03-FY15
163500                                PPS-DATA-ALL
163600                                PPS-CBSA
163700                                PRICER-OPT-VERS-SW
163800                                PROV-NEW-HOLD
163900                                WAGE-NEW-INDEX-RECORD-CBSA
164000                                WAGE-IPPS-INDEX-RECORD-CBSA.
164100
164200*----------------------------------------------------------------*
164300*        FISCAL YEAR 2007, RATE YEAR 2008                        *
164400*----------------------------------------------------------------*
164500         IF B-DISCHARGE-DATE > 20070630 AND
164600                             < 20071001
164700            CALL LTCAL080 USING BILL-DATA-FY03-FY15
164800                                PPS-DATA-ALL
164900                                PPS-CBSA
165000                                PRICER-OPT-VERS-SW
165100                                PROV-NEW-HOLD
165200                                WAGE-NEW-INDEX-RECORD-CBSA
165300                                WAGE-IPPS-INDEX-RECORD-CBSA.
165400
165500*----------------------------------------------------------------*
165600*        FISCAL YEAR 2007, RATE YEAR 2007                        *
165700*----------------------------------------------------------------*
165800         IF B-DISCHARGE-DATE > 20060930 AND
165900                             < 20070701
166000            CALL LTCAL075 USING BILL-DATA-FY03-FY15
166100                                PPS-DATA-ALL
166200                                PPS-CBSA
166300                                PRICER-OPT-VERS-SW
166400                                PROV-NEW-HOLD
166500                                WAGE-NEW-INDEX-RECORD-CBSA
166600                                WAGE-IPPS-INDEX-RECORD-CBSA.
166700
166800*----------------------------------------------------------------*
166900*        FISCAL YEAR 2006, RATE YEAR 2007                        *
167000*----------------------------------------------------------------*
167100         IF B-DISCHARGE-DATE > 20060630 AND
167200                             < 20061001
167300            CALL LTCAL072 USING BILL-DATA-FY03-FY15
167400                                PPS-DATA-ALL
167500                                PPS-CBSA
167600                                PRICER-OPT-VERS-SW
167700                                PROV-NEW-HOLD
167800                                WAGE-NEW-INDEX-RECORD-CBSA
167900                                WAGE-IPPS-INDEX-RECORD-CBSA.
168000
168100*----------------------------------------------------------------*
168200*        FISCAL YEAR 2006, RATE YEAR 2006                        *
168300*----------------------------------------------------------------*
168400         IF B-DISCHARGE-DATE > 20050930 AND
168500                             < 20060701
168600            CALL LTCAL064 USING BILL-DATA-FY03-FY15
168700                                PPS-DATA-ALL
168800                                PPS-CBSA
168900                                PRICER-OPT-VERS-SW
169000                                PROV-NEW-HOLD
169100                                WAGE-NEW-INDEX-RECORD-CBSA.
169200
169300*----------------------------------------------------------------*
169400*        FISCAL YEAR 2005, RATE YEAR 2006                        *
169500*----------------------------------------------------------------*
169600         IF B-DISCHARGE-DATE > 20050630 AND
169700                             < 20051001
169800            CALL LTCAL063 USING BILL-DATA-FY03-FY15
169900                                PPS-DATA-ALL
170000                                PPS-CBSA
170100                                PRICER-OPT-VERS-SW
170200                                PROV-NEW-HOLD
170300                                WAGE-NEW-INDEX-RECORD-CBSA.
170400
170500*----------------------------------------------------------------*
170600*        FISCAL YEAR 2005, RATE YEAR 2005                        *
170700*----------------------------------------------------------------*
170800         IF B-DISCHARGE-DATE > 20040930 AND
170900            B-DISCHARGE-DATE < 20050701
171000            CALL LTCAL059 USING BILL-DATA-FY03-FY15
171100                                PPS-DATA-ALL
171200                                PRICER-OPT-VERS-SW
171300                                PROV-NEW-HOLD
171400                                WAGE-NEW-INDEX-RECORD-MSA.
171500
171600*----------------------------------------------------------------*
171700*        FISCAL YEAR 2004, RATE YEAR 2005                        *
171800*----------------------------------------------------------------*
171900         IF B-DISCHARGE-DATE > 20040630 AND
172000            B-DISCHARGE-DATE < 20041001
172100            CALL LTCAL058 USING BILL-DATA-FY03-FY15
172200                                PPS-DATA-ALL
172300                                PRICER-OPT-VERS-SW
172400                                PROV-NEW-HOLD
172500                                WAGE-NEW-INDEX-RECORD-MSA.
172600
172700*----------------------------------------------------------------*
172800*        FISCAL YEAR 2004, RATE YEAR 2004 (NO LONGER CALLED)     *
172900*----------------------------------------------------------------*
173000         IF B-DISCHARGE-DATE > 20030930 AND
173100            B-DISCHARGE-DATE < 20040701
173200            CALL LTCAL043 USING BILL-DATA-FY03-FY15
173300                                PPS-DATA-ALL
173400                                PRICER-OPT-VERS-SW
173500                                PROV-NEW-HOLD
173600                                WAGE-NEW-INDEX-RECORD-MSA.
173700
173800*----------------------------------------------------------------*
173900*        FISCAL YEAR 2003, RATE YEAR 2004 (NO LONGER CALLED)     *
174000*----------------------------------------------------------------*
174100         IF B-DISCHARGE-DATE > 20030630 AND
174200            B-DISCHARGE-DATE < 20031001
174300            CALL LTCAL042 USING BILL-DATA-FY03-FY15
174400                                PPS-DATA-ALL
174500                                PRICER-OPT-VERS-SW
174600                                PROV-NEW-HOLD
174700                                WAGE-NEW-INDEX-RECORD-MSA.
174800
174900*----------------------------------------------------------------*
175000*        FISCAL YEAR 2003, RATE YEAR 2003 (NO LONGER CALLED)     *
175100*----------------------------------------------------------------*
175200         IF B-DISCHARGE-DATE < 20030701
175300            CALL LTCAL032 USING BILL-DATA-FY03-FY15
175400                                PPS-DATA-ALL
175500                                PRICER-OPT-VERS-SW
175600                                PROV-NEW-HOLD
175700                                WAGE-NEW-INDEX-RECORD-MSA.
175800
175900
176000         GOBACK.
176100
176200******************************************************************
176300******************************************************************
176400
176500 0190-GET-RURAL-FLOOR-IPPS.
176600
176700*    IF H-CBSA-PROV-BLANK = '   ' AND P-NEW-CBSA-WI-BLANK
176800*      GO TO 0190-EXIT.
176900
177000     SET RUFL-IDX TO 1.
177100
177200     SEARCH RUFL-TAB VARYING RUFL-IDX
177300     AT END
177400       MOVE '   00'              TO W-CBSA-IPPS-RURAL
177500       MOVE 99999999             TO W-CBSA-IPPS-RUR-EFF-DATE
177600       MOVE 0                    TO W-IPPS-WAGE-INDEX-RURAL
177700       GO TO 0190-EXIT
177800     WHEN RUFL-CBSA(RUFL-IDX) = HOLD-PROV-IPPS-CBSA-RURAL
177900          SET RUFL-IDX2 TO RUFL-IDX.
178000
178100 0190-EXIT.  EXIT.
178200
178300******************************************************************
178400 0500-GET-MSA.
178500******************************************************************
178600
178700     MOVE P-NEW-GEO-LOC-MSAX TO HOLD-PROV-MSA.
178800
178900     SEARCH M-MSA-DATA VARYING MU1
179000       AT END
179100          MOVE 60 TO PPS-RTC
179200       WHEN MSAX-MSA (MU1) = HOLD-PROV-MSA
179300          SET MU2 TO MU1
179400          PERFORM 0600-N-GET-WAGE-INDX
179500            THRU 0600-N-EXIT VARYING MU2
179600            FROM MU1 BY 1 UNTIL
179700              MSAX-MSA (MU2) NOT = HOLD-PROV-MSA.
179800
179900 0500-EXIT.
180000      EXIT.
180100
180200
180300******************************************************************
180400 0550-GET-CBSA.
180500******************************************************************
180600
180700*----------------------------------------------------------------*
180800* USE SPECIAL WAGE INDEX WHEN INDICATED - FOR LTCH WAGE INDEX    *
180900* TO USE THE SPECIAL WAGE INDEX IT MUST:                         *
181000*   1) BE FOR A CLAIM DISCHARGED ON OR AFTER 07/01/2005          *
181100*      (WHEN SPECIAL WAGE INDEX WAS FIRST USED FOR LTCH)         *
181200*   2) BE NUMERIC,                                               *
181300*   3) BE GREATER THAN 0, AND                                    *
181400*   4) BE IN A PSF RECORD WITH AN EFFECTIVE DATE WITHIN THE      *
181500*      CLAIM'S FISCAL YEAR.                                      *
181600*----------------------------------------------------------------*
181700     IF B-DISCHARGE-DATE > 20050630
181800     IF P-NEW-CBSA-SPEC-PAY-IND = '1'
181900        IF P-NEW-SPECIAL-WAGE-INDEX NUMERIC AND
182000           P-NEW-SPECIAL-WAGE-INDEX > 0 AND
182100           (P-NEW-EFF-DATE >= W-FY-BEGIN-DATE AND
182200            P-NEW-EFF-DATE <= W-FY-END-DATE)
182300            MOVE ZEROS                    TO W-NEW-CBSA
182400            MOVE P-NEW-EFF-DATE           TO W-NEW-EFF-DATE-C
182500            MOVE P-NEW-SPECIAL-WAGE-INDEX TO W-NEW-INDEX1-RECORD-C
182600            MOVE P-NEW-SPECIAL-WAGE-INDEX TO W-NEW-INDEX2-RECORD-C
182700            MOVE P-NEW-SPECIAL-WAGE-INDEX TO W-NEW-INDEX3-RECORD-C
182800            GO TO 0550-EXIT
182900        ELSE
183000            MOVE 52 TO PPS-RTC
183100            GO TO 0550-EXIT
183200        END-IF
183300     END-IF
183400     END-IF.
183500
183600
183700     MOVE P-NEW-GEO-LOC-CBSAX TO HOLD-PROV-CBSA.
183800
183900*6-20-16
184000*ADDED FOLLOWING LINE TO ALLOW LTCH PRICER TO WORK
184100*WITH THE NEW ARIZONA STATE CODE OF 00 -->
184200
184300     IF HOLD-PROV-CBSA = '   00' MOVE '   03' TO HOLD-PROV-CBSA.
184400
184500     SEARCH C-CBSA-DATA VARYING CU1
184600        AT END
184700           MOVE 60 TO PPS-RTC
184800        WHEN CBSAX-CBSA (CU1) = HOLD-PROV-CBSA
184900           SET CU2 TO CU1
185000           PERFORM 0650-N-GET-WAGE-INDX
185100             THRU 0650-N-EXIT VARYING CU2
185200             FROM CU1 BY 1 UNTIL
185300               CBSAX-CBSA (CU2) NOT = HOLD-PROV-CBSA.
185400
185500 0550-EXIT.
185600      EXIT.
185700
185800
185900******************************************************************
186000 0575-GET-IPPS-CBSA.
186100******************************************************************
186200
186300*------------------------------------------------------------*
186400* SET IPPS CBSA TO GEOGRAPHIC LOCATION CBSA IN PSF           *
186500*------------------------------------------------------------*
186600     MOVE P-NEW-GEO-LOC-CBSAX TO HOLD-PROV-IPPS-CBSA.
186700
186800
186900*6-20-16
187000*ADDED FOLLOWING LINE TO ALLOW LTCH PRICER TO WORK
187100*WITH THE NEW ARIZONA STATE CODE OF 00 -->
187200
187300     IF HOLD-PROV-IPPS-CBSA = '   00'
187400        MOVE '   03' TO HOLD-PROV-IPPS-CBSA.
187500
187600*------------------------------------------------------------*
187700* ASSIGN FY 2006 IPPS WAGE INDEX FLOORS                      *
187800*------------------------------------------------------------*
187900     IF B-DISCHARGE-DATE > 20050930 AND < 20061001
188000        PERFORM 0580-FY2006-FLOOR-CBSA THRU 0580-FY2006-EXIT
188100     END-IF.
188200
188300
188400*------------------------------------------------------------*
188500* ASSIGN FY 2007 IPPS WAGE INDEX FLOORS                      *
188600*------------------------------------------------------------*
188700     IF B-DISCHARGE-DATE > 20060930 AND < 20071001
188800        PERFORM 0580-FY2007-FLOOR-CBSA THRU 0580-FY2007-EXIT
188900     END-IF.
189000
189100
189200*------------------------------------------------------------*
189300* ASSIGN FY 2008 IPPS WAGE INDEX FLOORS                      *
189400*------------------------------------------------------------*
189500     IF B-DISCHARGE-DATE > 20070930 AND < 20081001
189600        PERFORM 0580-FY2008-FLOOR-CBSA THRU 0580-FY2008-EXIT
189700     END-IF.
189800
189900
190000*------------------------------------------------------------*
190100* ASSIGN FY 2009 IPPS WAGE INDEX FLOORS                      *
190200*------------------------------------------------------------*
190300     IF B-DISCHARGE-DATE > 20080930 AND < 20091001
190400        PERFORM 0580-FY2009-FLOOR-CBSA THRU 0580-FY2009-EXIT
190500     END-IF.
190600
190700
190800*------------------------------------------------------------*
190900* ASSIGN FY 2010 IPPS WAGE INDEX FLOORS                      *
191000*------------------------------------------------------------*
191100     IF B-DISCHARGE-DATE > 20090930 AND < 20101001
191200        PERFORM 0580-FY2010-FLOOR-CBSA THRU 0580-FY2010-EXIT
191300     END-IF.
191400
191500*------------------------------------------------------------*
191600* ASSIGN FY 2011 IPPS WAGE INDEX FLOORS                      *
191700*------------------------------------------------------------*
191800     IF B-DISCHARGE-DATE > 20100930 AND < 20111001
191900        PERFORM 0580-FY2011-FLOOR-CBSA THRU 0580-FY2011-EXIT
192000     END-IF.
192100
192200*------------------------------------------------------------*
192300* ASSIGN FY 2012 IPPS WAGE INDEX FLOORS                      *
192400*------------------------------------------------------------*
192500     IF B-DISCHARGE-DATE > 20110930 AND < 20121001
192600        PERFORM 0580-FY2012-FLOOR-CBSA THRU 0580-FY2012-EXIT
192700     END-IF.
192800
192900*------------------------------------------------------------*
193000* ASSIGN FY 2013 IPPS WAGE INDEX FLOORS                      *
193100*------------------------------------------------------------*
193200     IF B-DISCHARGE-DATE > 20120930 AND < 20131001
193300        PERFORM 0580-FY2013-FLOOR-CBSA THRU 0580-FY2013-EXIT
193400     END-IF.
193500
193600*------------------------------------------------------------*
193700* ASSIGN FY 2014 IPPS WAGE INDEX FLOORS                      *
193800*------------------------------------------------------------*
193900     IF B-DISCHARGE-DATE > 20130930 AND < 20141001
194000        PERFORM 0580-FY2014-FLOOR-CBSA THRU 0580-FY2014-EXIT
194100     END-IF.
194200
194300*------------------------------------------------------------*
194400* SEARCH TABLE FOR IPPS CBSA & GET WAGE INDEX                *
194500*------------------------------------------------------------*
194600     SEARCH T-CBSA-DATA VARYING MA1
194700        AT END
194800           MOVE 60 TO PPS-RTC
194900        WHEN T-CBSA (MA1) = HOLD-PROV-IPPS-CBSA
195000           SET MA2 TO MA1
195100           PERFORM 0675-N-GET-IPPS-WAGE-INDX
195200              THRU 0675-N-EXIT VARYING MA2
195300              FROM MA1 BY 1 UNTIL
195400                   T-CBSA (MA2) NOT = HOLD-PROV-IPPS-CBSA.
195500
195600
195700*------------------------------------------------------------*
195800* ASSIGN IPPS WAGE INDEX FLOORS FOR FY 2015 AND LATER        *
195900*------------------------------------------------------------*
196000     IF B-DISCHARGE-DATE > 20140930
196100        PERFORM 0580-FY2015-LATER-FLOOR-CBSA
196200           THRU 0580-FY2015-LATER-EXIT
196300     END-IF.
196400
196500
196600*------------------------------------------------------------*
196700* GET THE IPPS CBSA SIZE INDICATOR                           *
196800*------------------------------------------------------------*
196900* LOGIC REVISED 12/28/2006 FOR VERSION 08.0                  *
197000*------------------------------------------------------------*
197100     MOVE P-NEW-GEO-LOC-CBSAX TO HOLD-PROV-IPPS-CBSA.
197200
197300*6-20-16
197400*ADDED FOLLOWING LINE TO ALLOW LTCH PRICER TO WORK
197500*WITH THE NEW ARIZONA STATE CODE OF 00 -->
197600
197700     IF HOLD-PROV-IPPS-CBSA = '   00'
197800        MOVE '   03' TO HOLD-PROV-IPPS-CBSA.
197900
198000
198100     SET MA1 TO 1.
198200     SEARCH T-CBSA-DATA VARYING MA1
198300        AT END
198400           MOVE 60 TO PPS-RTC
198500        WHEN T-CBSA (MA1) = HOLD-PROV-IPPS-CBSA
198600           SET MA2 TO MA1.
198700
198800     IF PPS-RTC NOT = 60
198900        PERFORM 0585-GET-IPPS-CBSA-SIZE
199000           THRU 0585-EXIT VARYING MA2
199100           FROM MA1 BY 1 UNTIL
199200                T-CBSA (MA2) NOT = HOLD-PROV-IPPS-CBSA.
199300
199400
199500*------------------------------------------------------------*
199600* GET THE PUERTO RICO SPECIFIC WAGE INDEX FOR PR HOSPITALS   *
199700*------------------------------------------------------------*
199800     IF (B-DISCHARGE-DATE < 20161001) AND
199900        (P-NEW-STATE = 40 OR 84)
200000        PERFORM 0590-GET-IPPS-CBSA-PR THRU 0590-EXIT
200100        IF W-IPPS-PR-WAGE-INDEX = 0
200200           MOVE 52 TO PPS-RTC
200300        END-IF
200400     END-IF.
200500
200600
200700 0575-EXIT.
200800      EXIT.
200900
201000
201100******************************************************************
201200*                                                                *
201300* FLOOR ASSIGNMENTS FOR FY 2006 ONLY:                            *
201400*   ASSIGN IPPS WAGE INDEX STATE FLOORS WHEN NECESSARY -         *
201500*   PROVIDER'S STATE'S WAGE INDEX IS GREATER THAN THE WAGE       *
201600*   WAGE INDEX OF THE CBSA IT IS ASSIGNED TO                     *
201700* ** LOGIC COPIED FROM IPPS PRICER PROGRAM: PPDRV063             *
201800*                                                                *
201900******************************************************************
202000 0580-FY2006-FLOOR-CBSA.
202100******************************************************************
202200
202300     IF HOLD-PROV-IPPS-CBSA = '   10'
202400        AND P-NEW-CBSA-SPEC-PAY-IND = 'Y'
202500        AND P-NEW-STATE = 10
202600            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
202700            MOVE '   10' TO HOLD-PROV-IPPS-CBSA.
202800
202900     IF HOLD-PROV-IPPS-CBSA = '   50'
203000        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
203100        AND P-NEW-STATE = 50
203200            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
203300            MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
203400
203500     IF HOLD-PROV-IPPS-CBSA = '10900'
203600        AND P-NEW-STATE = 31
203700            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
203800            MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
203900
204000     IF HOLD-PROV-IPPS-CBSA = '15764'
204100        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
204200        AND P-NEW-STATE = 30
204300            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
204400            MOVE '   30' TO HOLD-PROV-IPPS-CBSA.
204500
204600     IF HOLD-PROV-IPPS-CBSA = '16620'
204700        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
204800        AND P-NEW-STATE = 36
204900            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
205000            MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
205100
205200     IF HOLD-PROV-IPPS-CBSA = '19060'
205300        AND P-NEW-STATE = 21
205400            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
205500            MOVE '   21' TO HOLD-PROV-IPPS-CBSA.
205600
205700     IF HOLD-PROV-IPPS-CBSA = '22020'
205800        AND P-NEW-STATE = 24
205900            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
206000            MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
206100
206200     IF HOLD-PROV-IPPS-CBSA = '24220'
206300        AND P-NEW-STATE = 24
206400            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
206500            MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
206600
206700     IF HOLD-PROV-IPPS-CBSA = '24580'
206800        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
206900        AND P-NEW-STATE = 52
207000            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
207100            MOVE '   52' TO HOLD-PROV-IPPS-CBSA.
207200
207300     IF HOLD-PROV-IPPS-CBSA = '25540'
207400        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
207500        AND P-NEW-STATE = 07
207600            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
207700            MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
207800
207900     IF HOLD-PROV-IPPS-CBSA = '30300'
208000        AND P-NEW-STATE = 50
208100            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
208200            MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
208300
208400     IF HOLD-PROV-IPPS-CBSA = '37620'
208500        AND P-NEW-STATE = 36
208600            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
208700            MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
208800
208900     IF HOLD-PROV-IPPS-CBSA = '39900'
209000        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
209100        AND P-NEW-STATE = 05
209200            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
209300            MOVE '   05' TO HOLD-PROV-IPPS-CBSA.
209400
209500     IF HOLD-PROV-IPPS-CBSA = '48260'
209600        AND P-NEW-STATE = 36
209700            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
209800            MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
209900
210000     IF HOLD-PROV-IPPS-CBSA = '48540'
210100        AND P-NEW-STATE = 36
210200            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
210300            MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
210400
210500     IF HOLD-PROV-IPPS-CBSA = '48540'
210600        AND P-NEW-STATE = 51
210700            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
210800            MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
210900
211000     IF HOLD-PROV-IPPS-CBSA = '48864'
211100        AND P-NEW-STATE = 31
211200            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
211300            MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
211400
211500     IF HOLD-PROV-IPPS-CBSA = '49660'
211600        AND P-NEW-STATE = 36
211700            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
211800            MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
211900
212000
212100 0580-FY2006-EXIT.
212200      EXIT.
212300
212400
212500******************************************************************
212600*                                                                *
212700* FLOOR ASSIGNMENTS FOR FY 2007:                                 *
212800*   ASSIGN IPPS WAGE INDEX STATE FLOORS WHEN NECESSARY -         *
212900*   PROVIDER'S STATE'S WAGE INDEX IS GREATER THAN THE WAGE       *
213000*   WAGE INDEX OF THE CBSA IT IS ASSIGNED TO                     *
213100* ** LOGIC COPIED FROM IPPS PRICER PROGRAM: PPDRV071             *
213200*                                                                *
213300******************************************************************
213400 0580-FY2007-FLOOR-CBSA.
213500******************************************************************
213600
213700     IF HOLD-PROV-IPPS-CBSA = '   10'
213800        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
213900        AND P-NEW-STATE = 10
214000            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
214100            MOVE '   10' TO HOLD-PROV-IPPS-CBSA.
214200
214300     IF HOLD-PROV-IPPS-CBSA = '   14'
214400        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
214500        AND P-NEW-STATE = 14
214600            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
214700            MOVE '   14' TO HOLD-PROV-IPPS-CBSA.
214800
214900     IF HOLD-PROV-IPPS-CBSA = '   26'
215000        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
215100        AND P-NEW-STATE = 26
215200            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
215300            MOVE '   26' TO HOLD-PROV-IPPS-CBSA.
215400
215500     IF HOLD-PROV-IPPS-CBSA = '   50'
215600        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
215700        AND P-NEW-STATE = 50
215800            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
215900            MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
216000
216100     IF HOLD-PROV-IPPS-CBSA = '10900'
216200        AND P-NEW-STATE = 31
216300            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
216400            MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
216500
216600     IF HOLD-PROV-IPPS-CBSA = '19060'
216700        AND P-NEW-STATE = 21
216800            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
216900            MOVE '   21' TO HOLD-PROV-IPPS-CBSA.
217000
217100     IF HOLD-PROV-IPPS-CBSA = '22020'
217200        AND P-NEW-STATE = 24
217300            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
217400            MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
217500
217600     IF HOLD-PROV-IPPS-CBSA = '24220'
217700        AND P-NEW-STATE = 24
217800            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
217900            MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
218000
218100     IF HOLD-PROV-IPPS-CBSA = '24580'
218200        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
218300        AND P-NEW-STATE = 52
218400            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
218500            MOVE '   52' TO HOLD-PROV-IPPS-CBSA.
218600
218700     IF HOLD-PROV-IPPS-CBSA = '25540'
218800        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
218900        AND P-NEW-STATE = 07
219000            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
219100            MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
219200
219300     IF HOLD-PROV-IPPS-CBSA = '26580'
219400        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
219500        AND P-NEW-STATE = 36
219600            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
219700            MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
219800
219900
220000*----------------------------------------------------------*
220100*  ON AND AFTER 11/03/2006, NO HOSPITALS RECLASSIFYING TO  *
220200*  CBSA 27860 WILL RECEIVE ITS STATE FLOOR DUE TO THE WIX  *
220300*  CHANGE IN THE IPPS FINAL RULE 2007 CORRECTION NOTICE 1  *
220400*----------------------------------------------------------*
220500*  - LOGIC DISABLED 11-20-2006 FOR RELEASE 07.5            *
220600*  - REINSTATED & ALTERED 12-28-2006 FOR RELEASE 08.0 TO   *
220700*    MATCH THE IPPS PRICER (BECAUSE THIS CODE ONLY APPLIES *
220800*    RECLASS PROVIDERS AND THERE ARE NO LTCH RECLASS       *
220900*    PROVIDERS, THESE CHANGES DO NOT AFFECT BILL PAYMENT)  *
221000*----------------------------------------------------------*
221100     IF B-DISCHARGE-DATE < 20061103
221200        IF HOLD-PROV-IPPS-CBSA = '27860'
221300           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
221400           AND P-NEW-STATE = 26
221500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
221600               MOVE '   26' TO HOLD-PROV-IPPS-CBSA.
221700*----------------------------------------------------------*
221800
221900
222000     IF HOLD-PROV-IPPS-CBSA = '29100'
222100        AND P-NEW-STATE = 52
222200            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
222300            MOVE '   52' TO HOLD-PROV-IPPS-CBSA.
222400
222500     IF HOLD-PROV-IPPS-CBSA = '30300'
222600        AND P-NEW-STATE = 50
222700            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
222800            MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
222900
223000     IF HOLD-PROV-IPPS-CBSA = '37620'
223100        AND P-NEW-STATE = 36
223200            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
223300            MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
223400
223500     IF HOLD-PROV-IPPS-CBSA = '37964'
223600        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
223700        AND P-NEW-STATE = 31
223800            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
223900            MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
224000
224100     IF HOLD-PROV-IPPS-CBSA = '38300'
224200        AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
224300        AND P-NEW-STATE = 36
224400            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
224500            MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
224600
224700     IF HOLD-PROV-IPPS-CBSA = '39300'
224800        AND P-NEW-STATE = 22
224900            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
225000            MOVE '   22' TO HOLD-PROV-IPPS-CBSA.
225100
225200     IF HOLD-PROV-IPPS-CBSA = '39300'
225300        AND P-NEW-STATE = 41
225400            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
225500            MOVE '   41' TO HOLD-PROV-IPPS-CBSA.
225600
225700     IF HOLD-PROV-IPPS-CBSA = '45500'
225800        AND P-NEW-STATE = 45
225900            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
226000            MOVE '   45' TO HOLD-PROV-IPPS-CBSA.
226100
226200     IF HOLD-PROV-IPPS-CBSA = '48260'
226300        AND P-NEW-STATE = 36
226400            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
226500            MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
226600
226700     IF HOLD-PROV-IPPS-CBSA = '48540'
226800        AND P-NEW-STATE = 36
226900            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
227000            MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
227100
227200     IF HOLD-PROV-IPPS-CBSA = '48540'
227300        AND P-NEW-STATE = 51
227400            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
227500            MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
227600
227700     IF HOLD-PROV-IPPS-CBSA = '48864'
227800        AND P-NEW-STATE = 31
227900            MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
228000            MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
228100
228200
228300 0580-FY2007-EXIT.
228400      EXIT.
228500
228600
228700******************************************************************
228800*                                                                *
228900* FLOOR ASSIGNMENTS FOR FY 2008:                                 *
229000*   ASSIGN IPPS WAGE INDEX STATE FLOORS WHEN NECESSARY -         *
229100*   PROVIDER'S STATE'S WAGE INDEX IS GREATER THAN THE WAGE       *
229200*   WAGE INDEX OF THE CBSA IT IS ASSIGNED TO                     *
229300* ** LOGIC COPIED FROM IPPS PRICER PROGRAM: PPDRV080             *
229400*                                                                *
229500******************************************************************
229600 0580-FY2008-FLOOR-CBSA.
229700******************************************************************
229800
229900        IF HOLD-PROV-IPPS-CBSA = '   39'
230000           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
230100           AND P-NEW-STATE = 33
230200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
230300               MOVE '   33' TO HOLD-PROV-IPPS-CBSA.
230400
230500        IF HOLD-PROV-IPPS-CBSA = '   39'
230600           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
230700           AND P-NEW-STATE = 39
230800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
230900               MOVE '   39' TO HOLD-PROV-IPPS-CBSA.
231000
231100        IF HOLD-PROV-IPPS-CBSA = '10900'
231200           AND P-NEW-STATE = 31
231300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
231400               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
231500
231600        IF HOLD-PROV-IPPS-CBSA = '19060'
231700           AND P-NEW-STATE = 21
231800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
231900               MOVE '   21' TO HOLD-PROV-IPPS-CBSA.
232000
232100        IF HOLD-PROV-IPPS-CBSA = '21780'
232200           AND P-NEW-STATE = 15
232300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
232400               MOVE '   15' TO HOLD-PROV-IPPS-CBSA.
232500
232600        IF HOLD-PROV-IPPS-CBSA = '21780'
232700           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
232800           AND P-NEW-STATE = 15
232900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
233000               MOVE '   15' TO HOLD-PROV-IPPS-CBSA.
233100
233200        IF HOLD-PROV-IPPS-CBSA = '22020'
233300           AND P-NEW-STATE = 24
233400               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
233500               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
233600
233700        IF HOLD-PROV-IPPS-CBSA = '24220'
233800           AND P-NEW-STATE = 24
233900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
234000               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
234100
234200        IF HOLD-PROV-IPPS-CBSA = '24580'
234300           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
234400           AND P-NEW-STATE = 52
234500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
234600               MOVE '   52' TO HOLD-PROV-IPPS-CBSA.
234700
234800        IF HOLD-PROV-IPPS-CBSA = '25540'
234900           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
235000           AND P-NEW-STATE = 07
235100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
235200               MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
235300
235400        IF HOLD-PROV-IPPS-CBSA = '28420'
235500           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
235600           AND P-NEW-STATE = 50
235700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
235800               MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
235900
236000        IF HOLD-PROV-IPPS-CBSA = '28700'
236100           AND P-NEW-STATE = 44
236200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
236300               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
236400
236500        IF HOLD-PROV-IPPS-CBSA = '28700'
236600           AND P-NEW-STATE = 49
236700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
236800               MOVE '   49' TO HOLD-PROV-IPPS-CBSA.
236900
237000        IF HOLD-PROV-IPPS-CBSA = '30300'
237100           AND P-NEW-STATE = 50
237200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
237300               MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
237400
237500        IF HOLD-PROV-IPPS-CBSA = '35084'
237600           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
237700           AND P-NEW-STATE = 31
237800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
237900               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
238000
238100        IF HOLD-PROV-IPPS-CBSA = '37620'
238200           AND P-NEW-STATE = 36
238300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
238400               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
238500
238600        IF HOLD-PROV-IPPS-CBSA = '37964'
238700           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
238800           AND P-NEW-STATE = 31
238900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
239000               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
239100
239200        IF HOLD-PROV-IPPS-CBSA = '38300'
239300           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
239400           AND P-NEW-STATE = 36
239500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
239600               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
239700
239800        IF HOLD-PROV-IPPS-CBSA = '45500'
239900           AND P-NEW-STATE = 45
240000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
240100               MOVE '   45' TO HOLD-PROV-IPPS-CBSA.
240200
240300        IF HOLD-PROV-IPPS-CBSA = '48260'
240400           AND P-NEW-STATE = 36
240500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
240600               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
240700
240800        IF HOLD-PROV-IPPS-CBSA = '48540'
240900           AND P-NEW-STATE = 36
241000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
241100               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
241200
241300        IF HOLD-PROV-IPPS-CBSA = '48540'
241400           AND P-NEW-STATE = 51
241500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
241600               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
241700
241800        IF HOLD-PROV-IPPS-CBSA = '48864'
241900           AND P-NEW-STATE = 31
242000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
242100               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
242200
242300        IF HOLD-PROV-IPPS-CBSA = '48864'
242400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
242500           AND P-NEW-STATE = 31
242600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
242700               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
242800
242900
243000 0580-FY2008-EXIT.
243100      EXIT.
243200
243300
243400******************************************************************
243500*                                                                *
243600* FLOOR ASSIGNMENTS FOR FY 2009:                                 *
243700*   ASSIGN IPPS WAGE INDEX STATE FLOORS WHEN NECESSARY -         *
243800*   PROVIDER'S STATE'S WAGE INDEX IS GREATER THAN THE WAGE       *
243900*   WAGE INDEX OF THE CBSA IT IS ASSIGNED TO                     *
244000* ** LOGIC COPIED FROM IPPS PRICER PROGRAM: PPDRV093             *
244100*                                                                *
244200******************************************************************
244300 0580-FY2009-FLOOR-CBSA.
244400******************************************************************
244500
244600        IF HOLD-PROV-IPPS-CBSA = '   04'
244700           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
244800           AND P-NEW-STATE = 04
244900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
245000               MOVE '   04' TO HOLD-PROV-IPPS-CBSA.
245100
245200        IF HOLD-PROV-IPPS-CBSA = '   04'
245300           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
245400           AND P-NEW-STATE = 19
245500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
245600               MOVE '   19' TO HOLD-PROV-IPPS-CBSA.
245700
245800        IF HOLD-PROV-IPPS-CBSA = '   14'
245900           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
246000           AND P-NEW-STATE = 14
246100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
246200               MOVE '   14' TO HOLD-PROV-IPPS-CBSA.
246300
246400        IF HOLD-PROV-IPPS-CBSA = '   14'
246500           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
246600           AND P-NEW-STATE = 26
246700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
246800               MOVE '   26' TO HOLD-PROV-IPPS-CBSA.
246900
247000        IF HOLD-PROV-IPPS-CBSA = '10900'
247100           AND P-NEW-STATE = 31
247200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
247300               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
247400
247500        IF HOLD-PROV-IPPS-CBSA = '19340'
247600           AND P-NEW-STATE = 16
247700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
247800               MOVE '   16' TO HOLD-PROV-IPPS-CBSA.
247900
248000        IF HOLD-PROV-IPPS-CBSA = '21780'
248100           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
248200           AND P-NEW-STATE = 15
248300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
248400               MOVE '   15' TO HOLD-PROV-IPPS-CBSA.
248500
248600        IF HOLD-PROV-IPPS-CBSA = '22020'
248700           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
248800           AND P-NEW-STATE = 43
248900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
249000               MOVE '   43' TO HOLD-PROV-IPPS-CBSA.
249100
249200        IF HOLD-PROV-IPPS-CBSA = '22900'
249300           AND P-NEW-STATE = 37
249400               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
249500               MOVE '   37' TO HOLD-PROV-IPPS-CBSA.
249600
249700        IF HOLD-PROV-IPPS-CBSA = '24580'
249800           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
249900           AND P-NEW-STATE = 52
250000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
250100               MOVE '   52' TO HOLD-PROV-IPPS-CBSA.
250200
250300        IF HOLD-PROV-IPPS-CBSA = '25540'
250400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
250500           AND P-NEW-STATE = 07
250600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
250700               MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
250800
250900        IF HOLD-PROV-IPPS-CBSA = '28420'
251000           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
251100           AND P-NEW-STATE = 50
251200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
251300               MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
251400
251500        IF HOLD-PROV-IPPS-CBSA = '28700'
251600           AND P-NEW-STATE = 44
251700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
251800               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
251900
252000        IF HOLD-PROV-IPPS-CBSA = '28700'
252100           AND P-NEW-STATE = 49
252200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
252300               MOVE '   49' TO HOLD-PROV-IPPS-CBSA.
252400
252500        IF HOLD-PROV-IPPS-CBSA = '28700'
252600           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
252700           AND P-NEW-STATE = 18
252800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
252900               MOVE '   18' TO HOLD-PROV-IPPS-CBSA.
253000
253100        IF HOLD-PROV-IPPS-CBSA = '28700'
253200           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
253300           AND P-NEW-STATE = 44
253400               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
253500               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
253600
253700        IF HOLD-PROV-IPPS-CBSA = '28940'
253800           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
253900           AND P-NEW-STATE = 18
254000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
254100               MOVE '   18' TO HOLD-PROV-IPPS-CBSA.
254200
254300        IF HOLD-PROV-IPPS-CBSA = '28940'
254400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
254500           AND P-NEW-STATE = 44
254600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
254700               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
254800
254900        IF HOLD-PROV-IPPS-CBSA = '34820'
255000           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
255100           AND P-NEW-STATE = 34
255200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
255300               MOVE '   34' TO HOLD-PROV-IPPS-CBSA.
255400
255500        IF HOLD-PROV-IPPS-CBSA = '34820'
255600           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
255700           AND P-NEW-STATE = 42
255800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
255900               MOVE '   42' TO HOLD-PROV-IPPS-CBSA.
256000
256100        IF HOLD-PROV-IPPS-CBSA = '37620'
256200           AND P-NEW-STATE = 36
256300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
256400               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
256500
256600        IF HOLD-PROV-IPPS-CBSA = '37964'
256700           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
256800           AND P-NEW-STATE = 31
256900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
257000               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
257100
257200        IF HOLD-PROV-IPPS-CBSA = '38340'
257300           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
257400           AND P-NEW-STATE = 47
257500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
257600               MOVE '   47' TO HOLD-PROV-IPPS-CBSA.
257700
257800        IF HOLD-PROV-IPPS-CBSA = '41620'
257900           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
258000           AND P-NEW-STATE = 29
258100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
258200               MOVE '   29' TO HOLD-PROV-IPPS-CBSA.
258300
258400        IF HOLD-PROV-IPPS-CBSA = '43580'
258500           AND P-NEW-STATE = 16
258600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
258700               MOVE '   16' TO HOLD-PROV-IPPS-CBSA.
258800
258900        IF HOLD-PROV-IPPS-CBSA = '48540'
259000           AND P-NEW-STATE = 36
259100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
259200               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
259300
259400        IF HOLD-PROV-IPPS-CBSA = '48540'
259500           AND P-NEW-STATE = 51
259600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
259700               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
259800
259900        IF HOLD-PROV-IPPS-CBSA = '48864'
260000           AND P-NEW-STATE = 31
260100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
260200               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
260300
260400        IF HOLD-PROV-IPPS-CBSA = '48864'
260500           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
260600           AND P-NEW-STATE = 31
260700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
260800               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
260900
261000        IF HOLD-PROV-IPPS-CBSA = '19060'
261100           AND P-NEW-STATE = 21
261200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
261300               MOVE '   21' TO HOLD-PROV-IPPS-CBSA.
261400
261500        IF HOLD-PROV-IPPS-CBSA = '19060'
261600           AND P-NEW-STATE = 51
261700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
261800               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
261900
262000        IF HOLD-PROV-IPPS-CBSA = '22020'
262100           AND P-NEW-STATE = 24
262200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
262300               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
262400
262500        IF HOLD-PROV-IPPS-CBSA = '24220'
262600           AND P-NEW-STATE = 24
262700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
262800               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
262900
263000        IF HOLD-PROV-IPPS-CBSA = '30300'
263100           AND P-NEW-STATE = 50
263200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
263300               MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
263400
263500        IF HOLD-PROV-IPPS-CBSA = '48260'
263600           AND P-NEW-STATE = 36
263700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
263800               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
263900
264000
264100 0580-FY2009-EXIT.
264200      EXIT.
264300
264400
264500******************************************************************
264600*                                                                *
264700* FLOOR ASSIGNMENTS FOR FY 2010:                                 *
264800*   ASSIGN IPPS WAGE INDEX STATE FLOORS WHEN NECESSARY -         *
264900*   PROVIDER'S STATE'S WAGE INDEX IS GREATER THAN THE WAGE       *
265000*   WAGE INDEX OF THE CBSA IT IS ASSIGNED TO                     *
265100* ** LOGIC COPIED FROM IPPS PRICER PROGRAM: PPDRV100             *
265200*                                                                *
265300******************************************************************
265400 0580-FY2010-FLOOR-CBSA.
265500******************************************************************
265600
265700        IF HOLD-PROV-IPPS-CBSA = '   33'
265800           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
265900           AND P-NEW-STATE = 30
266000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
266100               MOVE '   30' TO HOLD-PROV-IPPS-CBSA.
266200
266300        IF HOLD-PROV-IPPS-CBSA = '   33'
266400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
266500           AND P-NEW-STATE = 33
266600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
266700               MOVE '   33' TO HOLD-PROV-IPPS-CBSA.
266800
266900        IF HOLD-PROV-IPPS-CBSA = '10900'
267000           AND P-NEW-STATE = 31
267100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
267200               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
267300
267400        IF HOLD-PROV-IPPS-CBSA = '19340'
267500           AND P-NEW-STATE = 16
267600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
267700               MOVE '   16' TO HOLD-PROV-IPPS-CBSA.
267800
267900        IF HOLD-PROV-IPPS-CBSA = '19340'
268000           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
268100           AND P-NEW-STATE = 16
268200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
268300               MOVE '   16' TO HOLD-PROV-IPPS-CBSA.
268400
268500        IF HOLD-PROV-IPPS-CBSA = '21780'
268600           AND P-NEW-STATE = 15
268700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
268800               MOVE '   15' TO HOLD-PROV-IPPS-CBSA.
268900
269000        IF HOLD-PROV-IPPS-CBSA = '21780'
269100           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
269200           AND P-NEW-STATE = 15
269300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
269400               MOVE '   15' TO HOLD-PROV-IPPS-CBSA.
269500
269600        IF HOLD-PROV-IPPS-CBSA = '25180'
269700           AND P-NEW-STATE = 21
269800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
269900               MOVE '   21' TO HOLD-PROV-IPPS-CBSA.
270000
270100        IF HOLD-PROV-IPPS-CBSA = '25540'
270200           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
270300           AND P-NEW-STATE = 07
270400               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
270500               MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
270600
270700        IF HOLD-PROV-IPPS-CBSA = '28420'
270800           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
270900           AND P-NEW-STATE = 50
271000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
271100               MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
271200
271300        IF HOLD-PROV-IPPS-CBSA = '28940'
271400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
271500           AND P-NEW-STATE = 18
271600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
271700               MOVE '   18' TO HOLD-PROV-IPPS-CBSA.
271800
271900        IF HOLD-PROV-IPPS-CBSA = '28940'
272000           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
272100           AND P-NEW-STATE = 44
272200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
272300               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
272400
272500        IF HOLD-PROV-IPPS-CBSA = '35084'
272600           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
272700           AND P-NEW-STATE = 31
272800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
272900               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
273000
273100        IF HOLD-PROV-IPPS-CBSA = '37620'
273200           AND P-NEW-STATE = 36
273300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
273400               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
273500
273600        IF HOLD-PROV-IPPS-CBSA = '37964'
273700           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
273800           AND P-NEW-STATE = 31
273900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
274000               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
274100
274200        IF HOLD-PROV-IPPS-CBSA = '48540'
274300           AND P-NEW-STATE = 36
274400               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
274500               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
274600
274700        IF HOLD-PROV-IPPS-CBSA = '48540'
274800           AND P-NEW-STATE = 51
274900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
275000               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
275100
275200        IF HOLD-PROV-IPPS-CBSA = '48864'
275300           AND P-NEW-STATE = 31
275400               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
275500               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
275600
275700        IF HOLD-PROV-IPPS-CBSA = '48864'
275800           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
275900           AND P-NEW-STATE = 31
276000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
276100               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
276200
276300        IF HOLD-PROV-IPPS-CBSA = '49660'
276400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
276500           AND P-NEW-STATE = 36
276600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
276700               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
276800
276900        IF HOLD-PROV-IPPS-CBSA = '19060'
277000           AND P-NEW-STATE = 21
277100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
277200               MOVE '   21' TO HOLD-PROV-IPPS-CBSA.
277300
277400        IF HOLD-PROV-IPPS-CBSA = '22020'
277500           AND P-NEW-STATE = 24
277600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
277700               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
277800
277900        IF HOLD-PROV-IPPS-CBSA = '24220'
278000           AND P-NEW-STATE = 24
278100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
278200               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
278300
278400        IF HOLD-PROV-IPPS-CBSA = '30300'
278500           AND P-NEW-STATE = 50
278600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
278700               MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
278800
278900        IF HOLD-PROV-IPPS-CBSA = '35084'
279000           AND P-NEW-STATE = 31
279100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
279200               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
279300
279400        IF HOLD-PROV-IPPS-CBSA = '48260'
279500           AND P-NEW-STATE = 36
279600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
279700               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
279800
279900        IF HOLD-PROV-IPPS-CBSA = '48260'
280000           AND P-NEW-STATE = 51
280100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
280200               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
280300
280400
280500 0580-FY2010-EXIT.
280600      EXIT.
280700
280800******************************************************************
280900*                                                                *
281000* FLOOR ASSIGNMENTS FOR FY 2011:                                 *
281100* ** LOGIC COPIED FROM IPPS PRICER PROGRAM: PPDRV110             *
281200*                                                                *
281300******************************************************************
281400
281500 0580-FY2011-FLOOR-CBSA.
281600
281700        IF HOLD-PROV-IPPS-CBSA = '   45'
281800          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
281900          AND P-NEW-STATE = 45
282000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
282100               MOVE '   45' TO HOLD-PROV-IPPS-CBSA.
282200
282300        IF HOLD-PROV-IPPS-CBSA = '   37'
282400          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
282500          AND P-NEW-STATE = 37
282600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
282700               MOVE '   37' TO HOLD-PROV-IPPS-CBSA.
282800
282900        IF HOLD-PROV-IPPS-CBSA = '10900'
283000           AND P-NEW-STATE = 31
283100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
283200               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
283300
283400        IF HOLD-PROV-IPPS-CBSA = '21500'
283500          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
283600           AND P-NEW-STATE = 33
283700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
283800               MOVE '   33' TO HOLD-PROV-IPPS-CBSA.
283900
284000        IF HOLD-PROV-IPPS-CBSA = '21500'
284100          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
284200           AND P-NEW-STATE = 39
284300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
284400               MOVE '   39' TO HOLD-PROV-IPPS-CBSA.
284500
284600        IF HOLD-PROV-IPPS-CBSA = '21780'
284700           AND P-NEW-STATE = 15
284800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
284900               MOVE '   15' TO HOLD-PROV-IPPS-CBSA.
285000
285100        IF HOLD-PROV-IPPS-CBSA = '22900'
285200           AND P-NEW-STATE = 37
285300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
285400               MOVE '   37' TO HOLD-PROV-IPPS-CBSA.
285500
285600        IF HOLD-PROV-IPPS-CBSA = '24540'
285700           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
285800           AND P-NEW-STATE = 53
285900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
286000               MOVE '   53' TO HOLD-PROV-IPPS-CBSA.
286100
286200        IF HOLD-PROV-IPPS-CBSA = '25540'
286300           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
286400           AND P-NEW-STATE = 07
286500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
286600               MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
286700
286800        IF HOLD-PROV-IPPS-CBSA = '28700'
286900           AND P-NEW-STATE = 44
287000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
287100               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
287200
287300        IF HOLD-PROV-IPPS-CBSA = '28700'
287400           AND P-NEW-STATE = 49
287500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
287600               MOVE '   49' TO HOLD-PROV-IPPS-CBSA.
287700
287800        IF HOLD-PROV-IPPS-CBSA = '28940'
287900           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
288000           AND P-NEW-STATE = 18
288100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
288200               MOVE '   18' TO HOLD-PROV-IPPS-CBSA.
288300
288400        IF HOLD-PROV-IPPS-CBSA = '28940'
288500           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
288600           AND P-NEW-STATE = 44
288700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
288800               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
288900
289000        IF HOLD-PROV-IPPS-CBSA = '37620'
289100           AND P-NEW-STATE = 36
289200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
289300               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
289400
289500        IF HOLD-PROV-IPPS-CBSA = '37620'
289600           AND P-NEW-STATE = 51
289700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
289800               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
289900
290000        IF HOLD-PROV-IPPS-CBSA = '37964'
290100           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
290200           AND P-NEW-STATE = 31
290300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
290400               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
290500
290600        IF HOLD-PROV-IPPS-CBSA = '38300'
290700           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
290800           AND P-NEW-STATE = 36
290900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
291000               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
291100
291200        IF HOLD-PROV-IPPS-CBSA = '38300'
291300           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
291400           AND P-NEW-STATE = 39
291500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
291600               MOVE '   39' TO HOLD-PROV-IPPS-CBSA.
291700
291800        IF HOLD-PROV-IPPS-CBSA = '43580'
291900           AND P-NEW-STATE = 43
292000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
292100               MOVE '   43' TO HOLD-PROV-IPPS-CBSA.
292200
292300        IF HOLD-PROV-IPPS-CBSA = '48540'
292400           AND P-NEW-STATE = 36
292500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
292600               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
292700
292800        IF HOLD-PROV-IPPS-CBSA = '48540'
292900           AND P-NEW-STATE = 51
293000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
293100               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
293200
293300        IF HOLD-PROV-IPPS-CBSA = '48864'
293400           AND P-NEW-STATE = 31
293500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
293600               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
293700
293800        IF HOLD-PROV-IPPS-CBSA = '17300'
293900           AND P-NEW-STATE = 18
294000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
294100               MOVE '   18' TO HOLD-PROV-IPPS-CBSA.
294200
294300        IF HOLD-PROV-IPPS-CBSA = '17300'
294400           AND P-NEW-STATE = 44
294500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
294600               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
294700
294800        IF HOLD-PROV-IPPS-CBSA = '19060'
294900           AND P-NEW-STATE = 21
295000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
295100               MOVE '   21' TO HOLD-PROV-IPPS-CBSA.
295200
295300        IF HOLD-PROV-IPPS-CBSA = '22020'
295400           AND P-NEW-STATE = 24
295500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
295600               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
295700
295800        IF HOLD-PROV-IPPS-CBSA = '22020'
295900           AND P-NEW-STATE = 35
296000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
296100               MOVE '   35' TO HOLD-PROV-IPPS-CBSA.
296200
296300        IF HOLD-PROV-IPPS-CBSA = '24220'
296400           AND P-NEW-STATE = 24
296500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
296600               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
296700
296800        IF HOLD-PROV-IPPS-CBSA = '24220'
296900           AND P-NEW-STATE = 35
297000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
297100               MOVE '   35' TO HOLD-PROV-IPPS-CBSA.
297200
297300        IF HOLD-PROV-IPPS-CBSA = '30300'
297400           AND P-NEW-STATE = 50
297500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
297600               MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
297700
297800        IF HOLD-PROV-IPPS-CBSA = '44600'
297900           AND P-NEW-STATE = 36
298000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
298100               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
298200
298300        IF HOLD-PROV-IPPS-CBSA = '44600'
298400           AND P-NEW-STATE = 51
298500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
298600               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
298700
298800        IF HOLD-PROV-IPPS-CBSA = '45500'
298900           AND P-NEW-STATE = 45
299000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
299100               MOVE '   45' TO HOLD-PROV-IPPS-CBSA.
299200
299300
299400 0580-FY2011-EXIT.
299500      EXIT.
299600
299700******************************************************************
299800*                                                                *
299900* FLOOR ASSIGNMENTS FOR FY 2012:                                 *
300000* ** LOGIC COPIED FROM IPPS PRICER PROGRAM: PPDRV120             *
300100*                                                                *
300200* ******* CHANGE HOLD-PROV-CBSA TO HOLD-PROV-IPPS-CBSA ******    *
300300*                                                                *
300400******************************************************************
300500
300600 0580-FY2012-FLOOR-CBSA.
300700
300800**************YEARCHANGE 2012.0 ******************************
300900
301000        IF HOLD-PROV-IPPS-CBSA = '   30'
301100          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
301200          AND P-NEW-STATE = 30
301300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
301400               MOVE '   30' TO HOLD-PROV-IPPS-CBSA.
301500
301600        IF HOLD-PROV-IPPS-CBSA = '   39'
301700          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
301800          AND P-NEW-STATE = 39
301900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
302000               MOVE '   39' TO HOLD-PROV-IPPS-CBSA.
302100
302200        IF HOLD-PROV-IPPS-CBSA = '   39'
302300          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
302400          AND P-NEW-STATE = 33
302500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
302600               MOVE '   33' TO HOLD-PROV-IPPS-CBSA.
302700
302800        IF HOLD-PROV-IPPS-CBSA = '10900'
302900           AND P-NEW-STATE = 31
303000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
303100               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
303200
303300        IF HOLD-PROV-IPPS-CBSA = '14484'
303400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
303500           AND P-NEW-STATE = 22
303600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
303700               MOVE '   22' TO HOLD-PROV-IPPS-CBSA.
303800
303900        IF HOLD-PROV-IPPS-CBSA = '16020'
304000           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
304100           AND P-NEW-STATE = 14
304200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
304300               MOVE '   14' TO HOLD-PROV-IPPS-CBSA.
304400
304500        IF HOLD-PROV-IPPS-CBSA = '21500'
304600          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
304700           AND P-NEW-STATE = 33
304800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
304900               MOVE '   33' TO HOLD-PROV-IPPS-CBSA.
305000
305100        IF HOLD-PROV-IPPS-CBSA = '21500'
305200          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
305300           AND P-NEW-STATE = 39
305400               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
305500               MOVE '   39' TO HOLD-PROV-IPPS-CBSA.
305600
305700        IF HOLD-PROV-IPPS-CBSA = '22900'
305800           AND P-NEW-STATE = 37
305900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
306000               MOVE '   37' TO HOLD-PROV-IPPS-CBSA.
306100
306200        IF HOLD-PROV-IPPS-CBSA = '25180'
306300           AND P-NEW-STATE = 21
306400               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
306500               MOVE '   21' TO HOLD-PROV-IPPS-CBSA.
306600
306700        IF HOLD-PROV-IPPS-CBSA = '25540'
306800           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
306900           AND P-NEW-STATE = 07
307000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
307100               MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
307200
307300        IF HOLD-PROV-IPPS-CBSA = '25540'
307400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
307500           AND P-NEW-STATE = 22
307600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
307700               MOVE '   22' TO HOLD-PROV-IPPS-CBSA.
307800
307900        IF HOLD-PROV-IPPS-CBSA = '26820'
308000           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
308100           AND P-NEW-STATE = 53
308200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
308300               MOVE '   53' TO HOLD-PROV-IPPS-CBSA.
308400
308500        IF HOLD-PROV-IPPS-CBSA = '28700'
308600           AND P-NEW-STATE = 44
308700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
308800               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
308900
309000        IF HOLD-PROV-IPPS-CBSA = '28700'
309100           AND P-NEW-STATE = 49
309200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
309300               MOVE '   49' TO HOLD-PROV-IPPS-CBSA.
309400
309500        IF HOLD-PROV-IPPS-CBSA = '28700'
309600           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
309700           AND P-NEW-STATE = 18
309800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
309900               MOVE '   18' TO HOLD-PROV-IPPS-CBSA.
310000
310100        IF HOLD-PROV-IPPS-CBSA = '28700'
310200           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
310300           AND P-NEW-STATE = 44
310400               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
310500               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
310600
310700        IF HOLD-PROV-IPPS-CBSA = '28940'
310800           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
310900           AND P-NEW-STATE = 18
311000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
311100               MOVE '   18' TO HOLD-PROV-IPPS-CBSA.
311200
311300        IF HOLD-PROV-IPPS-CBSA = '35084'
311400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
311500           AND P-NEW-STATE = 31
311600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
311700               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
311800
311900        IF HOLD-PROV-IPPS-CBSA = '37620'
312000           AND P-NEW-STATE = 36
312100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
312200               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
312300
312400        IF HOLD-PROV-IPPS-CBSA = '37964'
312500           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
312600           AND P-NEW-STATE = 31
312700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
312800               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
312900
313000        IF HOLD-PROV-IPPS-CBSA = '43580'
313100           AND P-NEW-STATE = 43
313200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
313300               MOVE '   43' TO HOLD-PROV-IPPS-CBSA.
313400
313500        IF HOLD-PROV-IPPS-CBSA = '44600'
313600           AND P-NEW-STATE = 36
313700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
313800               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
313900
314000        IF HOLD-PROV-IPPS-CBSA = '44600'
314100           AND P-NEW-STATE = 51
314200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
314300               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
314400
314500        IF HOLD-PROV-IPPS-CBSA = '48540'
314600           AND P-NEW-STATE = 36
314700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
314800               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
314900
315000        IF HOLD-PROV-IPPS-CBSA = '48540'
315100           AND P-NEW-STATE = 51
315200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
315300               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
315400
315500        IF HOLD-PROV-IPPS-CBSA = '48864'
315600           AND P-NEW-STATE = 31
315700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
315800               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
315900
316000        IF HOLD-PROV-IPPS-CBSA = '49660'
316100           AND P-NEW-STATE = 36
316200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
316300               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
316400
316500        IF HOLD-PROV-IPPS-CBSA = '49660'
316600           AND P-NEW-STATE = 39
316700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
316800               MOVE '   39' TO HOLD-PROV-IPPS-CBSA.
316900
317000        IF HOLD-PROV-IPPS-CBSA = '19060'
317100           AND P-NEW-STATE = 21
317200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
317300               MOVE '   21' TO HOLD-PROV-IPPS-CBSA.
317400
317500        IF HOLD-PROV-IPPS-CBSA = '22020'
317600           AND P-NEW-STATE = 24
317700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
317800               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
317900
318000        IF HOLD-PROV-IPPS-CBSA = '22020'
318100           AND P-NEW-STATE = 35
318200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
318300               MOVE '   35' TO HOLD-PROV-IPPS-CBSA.
318400
318500        IF HOLD-PROV-IPPS-CBSA = '24220'
318600           AND P-NEW-STATE = 24
318700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
318800               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
318900
319000        IF HOLD-PROV-IPPS-CBSA = '24220'
319100           AND P-NEW-STATE = 35
319200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
319300               MOVE '   35' TO HOLD-PROV-IPPS-CBSA.
319400
319500        IF HOLD-PROV-IPPS-CBSA = '30300'
319600           AND P-NEW-STATE = 50
319700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
319800               MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
319900
320000        IF HOLD-PROV-IPPS-CBSA = '30860'
320100           AND P-NEW-STATE = 46
320200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
320300               MOVE '   46' TO HOLD-PROV-IPPS-CBSA.
320400
320500        IF HOLD-PROV-IPPS-CBSA = '35084'
320600           AND P-NEW-STATE = 31
320700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
320800               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
320900
321000        IF HOLD-PROV-IPPS-CBSA = '39300'
321100           AND P-NEW-STATE = 22
321200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
321300               MOVE '   22' TO HOLD-PROV-IPPS-CBSA.
321400
321500        IF HOLD-PROV-IPPS-CBSA = '45500'
321600           AND P-NEW-STATE = 45
321700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
321800               MOVE '   45' TO HOLD-PROV-IPPS-CBSA.
321900
322000**************YEARCHANGE 2012.0 ******************************
322100
322200 0580-FY2012-EXIT.
322300      EXIT.
322400
322500 0580-FY2013-FLOOR-CBSA.
322600
322700**************YEARCHANGE 2013.0 ****************************
322800
322900        IF HOLD-PROV-IPPS-CBSA = '10900'
323000           AND P-NEW-STATE = 31
323100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
323200               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
323300
323400        IF HOLD-PROV-IPPS-CBSA = '14484'
323500           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
323600           AND P-NEW-STATE = 22
323700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
323800               MOVE '   22' TO HOLD-PROV-IPPS-CBSA.
323900
324000        IF HOLD-PROV-IPPS-CBSA = '16020'
324100           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
324200           AND P-NEW-STATE = 14
324300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
324400               MOVE '   14' TO HOLD-PROV-IPPS-CBSA.
324500
324600        IF HOLD-PROV-IPPS-CBSA = '21500'
324700          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
324800           AND P-NEW-STATE = 33
324900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
325000               MOVE '   33' TO HOLD-PROV-IPPS-CBSA.
325100
325200        IF HOLD-PROV-IPPS-CBSA = '21500'
325300          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
325400           AND P-NEW-STATE = 39
325500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
325600               MOVE '   39' TO HOLD-PROV-IPPS-CBSA.
325700
325800        IF HOLD-PROV-IPPS-CBSA = '21780'
325900          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
326000           AND P-NEW-STATE = 15
326100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
326200               MOVE '   15' TO HOLD-PROV-IPPS-CBSA.
326300
326400        IF HOLD-PROV-IPPS-CBSA = '24580'
326500          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
326600           AND P-NEW-STATE = 52
326700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
326800               MOVE '   52' TO HOLD-PROV-IPPS-CBSA.
326900
327000        IF HOLD-PROV-IPPS-CBSA = '25540'
327100           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
327200           AND P-NEW-STATE = 07
327300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
327400               MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
327500
327600        IF HOLD-PROV-IPPS-CBSA = '25540'
327700           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
327800           AND P-NEW-STATE = 22
327900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
328000               MOVE '   22' TO HOLD-PROV-IPPS-CBSA.
328100
328200        IF HOLD-PROV-IPPS-CBSA = '26820'
328300           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
328400           AND P-NEW-STATE = 53
328500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
328600               MOVE '   53' TO HOLD-PROV-IPPS-CBSA.
328700
328800        IF HOLD-PROV-IPPS-CBSA = '27900'
328900           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
329000           AND P-NEW-STATE = 17
329100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
329200               MOVE '   17' TO HOLD-PROV-IPPS-CBSA.
329300
329400        IF HOLD-PROV-IPPS-CBSA = '28700'
329500           AND P-NEW-STATE = 44
329600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
329700               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
329800
329900        IF HOLD-PROV-IPPS-CBSA = '28700'
330000           AND P-NEW-STATE = 49
330100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
330200               MOVE '   49' TO HOLD-PROV-IPPS-CBSA.
330300
330400        IF HOLD-PROV-IPPS-CBSA = '28700'
330500           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
330600           AND P-NEW-STATE = 18
330700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
330800               MOVE '   18' TO HOLD-PROV-IPPS-CBSA.
330900
331000        IF HOLD-PROV-IPPS-CBSA = '28700'
331100           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
331200           AND P-NEW-STATE = 44
331300               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
331400               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
331500
331600        IF HOLD-PROV-IPPS-CBSA = '28940'
331700           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
331800           AND P-NEW-STATE = 18
331900               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
332000               MOVE '   18' TO HOLD-PROV-IPPS-CBSA.
332100
332200        IF HOLD-PROV-IPPS-CBSA = '35084'
332300           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
332400           AND P-NEW-STATE = 31
332500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
332600               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
332700
332800        IF HOLD-PROV-IPPS-CBSA = '37620'
332900           AND P-NEW-STATE = 36
333000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
333100               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
333200
333300        IF HOLD-PROV-IPPS-CBSA = '37964'
333400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
333500           AND P-NEW-STATE = 31
333600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
333700               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
333800
333900        IF HOLD-PROV-IPPS-CBSA = '38300'
334000           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
334100           AND P-NEW-STATE = 36
334200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
334300               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
334400
334500        IF HOLD-PROV-IPPS-CBSA = '43580'
334600           AND P-NEW-STATE = 43
334700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
334800               MOVE '   43' TO HOLD-PROV-IPPS-CBSA.
334900
335000        IF HOLD-PROV-IPPS-CBSA = '48540'
335100           AND P-NEW-STATE = 36
335200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
335300               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
335400
335500        IF HOLD-PROV-IPPS-CBSA = '48540'
335600           AND P-NEW-STATE = 51
335700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
335800               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
335900
336000        IF HOLD-PROV-IPPS-CBSA = '48864'
336100           AND P-NEW-STATE = 31
336200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
336300               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
336400
336500        IF HOLD-PROV-IPPS-CBSA = '49660'
336600           AND P-NEW-STATE = 36
336700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
336800               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
336900
337000        IF HOLD-PROV-IPPS-CBSA = '49660'
337100           AND P-NEW-STATE = 39
337200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
337300               MOVE '   39' TO HOLD-PROV-IPPS-CBSA.
337400
337500        IF HOLD-PROV-IPPS-CBSA = '22020'
337600           AND P-NEW-STATE = 24
337700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
337800               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
337900
338000        IF HOLD-PROV-IPPS-CBSA = '22020'
338100           AND P-NEW-STATE = 35
338200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
338300               MOVE '   35' TO HOLD-PROV-IPPS-CBSA.
338400
338500        IF HOLD-PROV-IPPS-CBSA = '24220'
338600           AND P-NEW-STATE = 24
338700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
338800               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
338900
339000        IF HOLD-PROV-IPPS-CBSA = '24220'
339100           AND P-NEW-STATE = 35
339200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
339300               MOVE '   35' TO HOLD-PROV-IPPS-CBSA.
339400
339500        IF HOLD-PROV-IPPS-CBSA = '30300'
339600           AND P-NEW-STATE = 50
339700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
339800               MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
339900
340000        IF HOLD-PROV-IPPS-CBSA = '39300'
340100           AND P-NEW-STATE = 22
340200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
340300               MOVE '   22' TO HOLD-PROV-IPPS-CBSA.
340400
340500        IF HOLD-PROV-IPPS-CBSA = '39300'
340600           AND P-NEW-STATE = 41
340700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
340800               MOVE '   41' TO HOLD-PROV-IPPS-CBSA.
340900
341000        IF HOLD-PROV-IPPS-CBSA = '44600'
341100           AND P-NEW-STATE = 36
341200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
341300               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
341400
341500 0580-FY2013-EXIT.
341600      EXIT.
341700
341800 0580-FY2014-FLOOR-CBSA.
341900
342000**************YEARCHANGE 2014.0 ******************************
342100
342200        IF HOLD-PROV-IPPS-CBSA = '   07'
342300           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
342400           AND P-NEW-STATE = 07
342500               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
342600               MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
342700
342800        IF HOLD-PROV-IPPS-CBSA = '   36'
342900           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
343000           AND P-NEW-STATE = 36
343100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
343200               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
343300
343400        IF HOLD-PROV-IPPS-CBSA = '10900'
343500           AND P-NEW-STATE = 31
343600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
343700               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
343800
343900        IF HOLD-PROV-IPPS-CBSA = '14484'
344000           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
344100           AND P-NEW-STATE = 22
344200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
344300               MOVE '   22' TO HOLD-PROV-IPPS-CBSA.
344400
344500        IF HOLD-PROV-IPPS-CBSA = '17300'
344600           AND P-NEW-STATE = 18
344700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
344800               MOVE '   18' TO HOLD-PROV-IPPS-CBSA.
344900
345000        IF HOLD-PROV-IPPS-CBSA = '22900'
345100           AND P-NEW-STATE = 37
345200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
345300               MOVE '   37' TO HOLD-PROV-IPPS-CBSA.
345400
345500        IF HOLD-PROV-IPPS-CBSA = '25540'
345600          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
345700           AND P-NEW-STATE = 07
345800               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
345900               MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
346000
346100        IF HOLD-PROV-IPPS-CBSA = '25540'
346200          AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
346300           AND P-NEW-STATE = 22
346400               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
346500               MOVE '   22' TO HOLD-PROV-IPPS-CBSA.
346600
346700        IF HOLD-PROV-IPPS-CBSA = '26820'
346800           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
346900           AND P-NEW-STATE = 53
347000               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
347100               MOVE '   53' TO HOLD-PROV-IPPS-CBSA.
347200
347300        IF HOLD-PROV-IPPS-CBSA = '27180'
347400           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
347500           AND P-NEW-STATE = 25
347600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
347700               MOVE '   25' TO HOLD-PROV-IPPS-CBSA.
347800
347900        IF HOLD-PROV-IPPS-CBSA = '28700'
348000           AND P-NEW-STATE = 44
348100               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
348200               MOVE '   44' TO HOLD-PROV-IPPS-CBSA.
348300
348400        IF HOLD-PROV-IPPS-CBSA = '28700'
348500           AND P-NEW-STATE = 49
348600               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
348700               MOVE '   49' TO HOLD-PROV-IPPS-CBSA.
348800
348900        IF HOLD-PROV-IPPS-CBSA = '35644'
349000           AND P-NEW-CBSA-SPEC-PAY-IND  = 'Y'
349100           AND P-NEW-STATE = 07
349200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
349300               MOVE '   07' TO HOLD-PROV-IPPS-CBSA.
349400
349500        IF HOLD-PROV-IPPS-CBSA = '37620'
349600           AND P-NEW-STATE = 36
349700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
349800               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
349900
350000        IF HOLD-PROV-IPPS-CBSA = '43580'
350100           AND P-NEW-STATE = 43
350200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
350300               MOVE '   43' TO HOLD-PROV-IPPS-CBSA.
350400
350500        IF HOLD-PROV-IPPS-CBSA = '48540'
350600           AND P-NEW-STATE = 36
350700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
350800               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
350900
351000        IF HOLD-PROV-IPPS-CBSA = '48540'
351100           AND P-NEW-STATE = 51
351200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
351300               MOVE '   51' TO HOLD-PROV-IPPS-CBSA.
351400
351500        IF HOLD-PROV-IPPS-CBSA = '48864'
351600           AND P-NEW-STATE = 31
351700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
351800               MOVE '   31' TO HOLD-PROV-IPPS-CBSA.
351900
352000        IF HOLD-PROV-IPPS-CBSA = '49660'
352100           AND P-NEW-STATE = 36
352200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
352300               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
352400
352500        IF HOLD-PROV-IPPS-CBSA = '49660'
352600           AND P-NEW-STATE = 39
352700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
352800               MOVE '   39' TO HOLD-PROV-IPPS-CBSA.
352900
353000        IF HOLD-PROV-IPPS-CBSA = '19060'
353100           AND P-NEW-STATE = 21
353200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
353300               MOVE '   21' TO HOLD-PROV-IPPS-CBSA.
353400
353500        IF HOLD-PROV-IPPS-CBSA = '22020'
353600           AND P-NEW-STATE = 24
353700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
353800               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
353900
354000        IF HOLD-PROV-IPPS-CBSA = '22020'
354100           AND P-NEW-STATE = 35
354200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
354300               MOVE '   35' TO HOLD-PROV-IPPS-CBSA.
354400
354500        IF HOLD-PROV-IPPS-CBSA = '24220'
354600           AND P-NEW-STATE = 24
354700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
354800               MOVE '   24' TO HOLD-PROV-IPPS-CBSA.
354900
355000        IF HOLD-PROV-IPPS-CBSA = '24220'
355100           AND P-NEW-STATE = 35
355200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
355300               MOVE '   35' TO HOLD-PROV-IPPS-CBSA.
355400
355500        IF HOLD-PROV-IPPS-CBSA = '30300'
355600           AND P-NEW-STATE = 50
355700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
355800               MOVE '   50' TO HOLD-PROV-IPPS-CBSA.
355900
356000        IF HOLD-PROV-IPPS-CBSA = '39300'
356100           AND P-NEW-STATE = 22
356200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
356300               MOVE '   22' TO HOLD-PROV-IPPS-CBSA.
356400
356500        IF HOLD-PROV-IPPS-CBSA = '39300'
356600           AND P-NEW-STATE = 41
356700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
356800               MOVE '   41' TO HOLD-PROV-IPPS-CBSA.
356900
357000        IF HOLD-PROV-IPPS-CBSA = '44600'
357100           AND P-NEW-STATE = 36
357200               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
357300               MOVE '   36' TO HOLD-PROV-IPPS-CBSA.
357400
357500        IF HOLD-PROV-IPPS-CBSA = '45500'
357600           AND P-NEW-STATE = 45
357700               MOVE 'N' TO P-NEW-CBSA-SPEC-PAY-IND
357800               MOVE '   45' TO HOLD-PROV-IPPS-CBSA.
357900
358000 0580-FY2014-EXIT.
358100      EXIT.
358200
358300
358400******************************************************************
358500*                                                                *
358600* IPPS WAGE INDEX FLOOR ASSIGNMENT LOGIC FOR FY 2015 AND LATER   *
358700* ** LOGIC ADDED 08/06/2014 **                                   *
358800*                                                                *
358900******************************************************************
359000
359100 0580-FY2015-LATER-FLOOR-CBSA.
359200
359300*------------------------------------------------------------*
359400* SET RURAL IPPS CBSA TO PROVIDER'S STATE CODE               *
359500* (HOLD-PROV-IPPS-CBSA-RURAL)                                *
359600*------------------------------------------------------------*
359700     MOVE SPACES              TO H-PROV-BLANK-R.
359800*    MOVE P-NEW-STATE         TO H-PROV-STATE-R.
359900     MOVE P-NEW-STATE-CODE-X  TO H-PROV-STATE-R.
360000
360100*6-20-16
360200*ADDED FOLLOWING LINE TO ALLOW LTCH PRICER TO WORK
360300*WITH THE NEW ARIZONA STATE CODE OF 00 -->
360400
360500     IF H-PROV-STATE-R = '00' MOVE '03' TO H-PROV-STATE-R.
360600
360700*------------------------------------------------------------*
360800* SEARCH TABLE FOR RURAL IPPS CBSA & GET RURAL WAGE INDEX    *
360900*------------------------------------------------------------*
361000     SET MA1 TO 1.
361100
361200*------------------------------------------------------------*
361300* FOR FY 2015 - 2019: USE STATE CODE AREA WAGE INDEX         *
361400*                     IN ORIGINAL CBSA WAGE INDEX TABLE      *
361500*------------------------------------------------------------*
361600     IF B-DISCHARGE-DATE < 20191001
361700       SEARCH T-CBSA-DATA VARYING MA1
361800          AT END
361900             MOVE SPACES TO W-CBSA-IPPS-RURAL
362000             MOVE ZEROS TO W-CBSA-IPPS-RUR-EFF-DATE
362100             MOVE ZEROS TO W-IPPS-WAGE-INDEX-RURAL
362200          WHEN T-CBSA (MA1) = HOLD-PROV-IPPS-CBSA-RURAL
362300             SET MA2 TO MA1
362400             PERFORM 0675-N-GET-IPPS-WAGE-INDX-RUR
362500                THRU 0675-N-RUR-EXIT VARYING MA2
362600                FROM MA1 BY 1 UNTIL
362700                  T-CBSA (MA2) NOT = HOLD-PROV-IPPS-CBSA-RURAL.
362800
362900
363000*------------------------------------------------------------*
363100* FOR FY 2020 & LATER: USE STATE CODE RURAL WAGE INDEX       *
363200*                      IN RURAL WAGE INDEX COPYBOOK          *
363300*------------------------------------------------------------*
363400     IF B-DISCHARGE-DATE > 20190930
363500      IF PPS-RTC = '  '
363600       IF W-CBSA-IPPS-RUR-EFF-DATE NOT = WS-9S
363700         PERFORM 0190-GET-RURAL-FLOOR-IPPS THRU 0190-EXIT
363800         PERFORM 0690-GET-RURAL-FLOOR-IPPS-WI
363900          THRU 0690-EXIT VARYING RUFL-IDX2
364000          FROM RUFL-IDX BY 1 UNTIL
364100           RUFL-CBSA (RUFL-IDX2) NOT = HOLD-PROV-IPPS-CBSA-RURAL
364200       END-IF
364300      END-IF
364400     END-IF.
364500
364600
364700*------------------------------------------------------------*
364800* REPLACE CBSA WAGE INDEX & CBSA WITH RURAL FLOOR WAGE INDEX *
364900* & CBSA IF RURAL FLOOR WAGE INDEX IS HIGHER                 *
365000*------------------------------------------------------------*
365100     IF W-IPPS-WAGE-INDEX-RURAL > W-IPPS-WAGE-INDEX
365200        MOVE W-CBSA-IPPS-RURAL        TO W-CBSA-IPPS
365300        MOVE W-CBSA-IPPS-RUR-EFF-DATE TO W-CBSA-IPPS-EFF-DATE
365400        MOVE W-IPPS-WAGE-INDEX-RURAL  TO W-IPPS-WAGE-INDEX
365500     END-IF.
365600
365700 0580-FY2015-LATER-EXIT.
365800      EXIT.
365900
366000
366100******************************************************************
366200 0585-GET-IPPS-CBSA-SIZE.
366300******************************************************************
366400
366500     IF B-DISCHARGE-DATE NOT < T-CBSA-EFF-DATE (MA2)
366600        IF P-NEW-RURAL-CBSA
366700           MOVE 'R' TO W-CBSA-IPPS-SIZE
366800        ELSE
366900          IF T-CBSA-SIZE (MA2) = 'L'
367000             MOVE 'L' TO W-CBSA-IPPS-SIZE
367100          ELSE
367200             MOVE 'O' TO W-CBSA-IPPS-SIZE
367300          END-IF
367400        END-IF
367500     END-IF.
367600
367700 0585-EXIT.
367800      EXIT.
367900
368000
368100******************************************************************
368200 0590-GET-IPPS-CBSA-PR.
368300******************************************************************
368400
368500*--------------------------------------*
368600* SET PUERTO RICO CBSA INDICATOR       *
368700*--------------------------------------*
368800     MOVE '*' TO H-IPPS-CBSA-LAST-POS.
368900
369000*------------------------------------------------------------*
369100* SEARCH TABLE FOR PR CBSA & GET PR SPECIFIC WAGE INDEX      *
369200*------------------------------------------------------------*
369300     SET MA1 TO 1.
369400     SEARCH T-CBSA-DATA VARYING MA1
369500        AT END
369600           MOVE 60 TO PPS-RTC
369700        WHEN T-CBSA (MA1) = HOLD-PROV-IPPS-CBSA
369800           SET MA2 TO MA1
369900               PERFORM 0680-N-GET-IPPS-PR-WAGE-INDX
370000                  THRU 0680-N-EXIT VARYING MA2
370100                  FROM MA1 BY 1 UNTIL
370200                       T-CBSA (MA2) NOT = HOLD-PROV-IPPS-CBSA.
370300
370400
370500*------------------------------------------------------------*
370600* ASSIGN PR IPPS WAGE INDEX FLOOR FOR FY 2015 AND LATER      *
370700*------------------------------------------------------------*
370800     IF B-DISCHARGE-DATE > 20140930
370900        PERFORM 0590-FY2015-LATER-PR-FLOOR
371000           THRU 0590-FY2015-LATER-PR-EXIT
371100     END-IF.
371200
371300 0590-EXIT.
371400      EXIT.
371500
371600
371700******************************************************************
371800*                                                                *
371900* PUERTO RICO SPECIFIC WAGE INDEX:                               *
372000* IPPS WAGE INDEX FLOOR ASSIGNMENT LOGIC FOR FY 2015 AND LATER   *
372100* ** LOGIC ADDED 08/06/2014 **                                   *
372200*                                                                *
372300******************************************************************
372400
372500 0590-FY2015-LATER-PR-FLOOR.
372600
372700*------------------------------------------------------------*
372800* SET RURAL IPPS CBSA TO PROVIDER'S STATE CODE               *
372900* (HOLD-PROV-IPPS-CBSA-RURAL)                                *
373000*------------------------------------------------------------*
373100     MOVE SPACES              TO H-PROV-BLANK-R.
373200*    MOVE P-NEW-STATE         TO H-PROV-STATE-R.
373300     MOVE P-NEW-STATE-CODE-X  TO H-PROV-STATE-R.
373400     MOVE '*'                 TO H-IPPS-CBSA-LAST-POS-R.
373500
373600
373700*------------------------------------------------------------*
373800* SEARCH TABLE FOR RURAL PR IPPS CBSA & GET WAGE INDEX       *
373900*------------------------------------------------------------*
374000     SET MA1 TO 1.
374100     SEARCH T-CBSA-DATA VARYING MA1
374200        AT END
374300           MOVE ZEROS TO W-IPPS-PR-WAGE-INDEX-RUR
374400        WHEN T-CBSA (MA1) = HOLD-PROV-IPPS-CBSA-RURAL
374500           SET MA2 TO MA1
374600           PERFORM 0680-N-GET-IPPS-PR-WAGE-IDX-RU
374700              THRU 0680-N-RU-EXIT VARYING MA2
374800              FROM MA1 BY 1 UNTIL
374900                   T-CBSA (MA2) NOT = HOLD-PROV-IPPS-CBSA-RURAL.
375000
375100
375200*------------------------------------------------------------*
375300* REPLACE CBSA WAGE INDEX & CBSA WITH RURAL FLOOR WAGE INDEX *
375400* & CBSA IF RURAL FLOOR WAGE INDEX IS HIGHER                 *
375500*------------------------------------------------------------*
375600     IF W-IPPS-PR-WAGE-INDEX-RUR > W-IPPS-PR-WAGE-INDEX
375700        MOVE W-IPPS-PR-WAGE-INDEX-RUR TO W-IPPS-PR-WAGE-INDEX
375800     END-IF.
375900
376000
376100 0590-FY2015-LATER-PR-EXIT.
376200      EXIT.
376300
376400
376500******************************************************************
376600 0600-N-GET-WAGE-INDX.
376700******************************************************************
376800
376900     IF  B-DISCHARGE-DATE NOT < MSAX-EFF-DATE (MU2)
377000         MOVE MSAX-MSA (MU2)         TO W-NEW-MSA
377100         MOVE MSAX-EFF-DATE (MU2)    TO W-NEW-EFF-DATE-M
377200         MOVE MSAX-WAGE-INDEX1 (MU2) TO W-NEW-INDEX1-RECORD-M
377300         MOVE MSAX-WAGE-INDEX2 (MU2) TO W-NEW-INDEX2-RECORD-M
377400         MOVE MSAX-WAGE-INDEX3 (MU2) TO W-NEW-INDEX3-RECORD-M
377500     END-IF.
377600
377700 0600-N-EXIT.
377800     EXIT.
377900
378000
378100******************************************************************
378200 0650-N-GET-WAGE-INDX.
378300******************************************************************
378400
378500*----------------------------------------------------------------*
378600* TO SELECT THE WAGE INDEX, IT MUST BE EITHER:                   *
378700* 1) AN INDIAN HEALTH CBSA (98 OR 99) WITH AN EFFECTIVE DATE ON  *
378800*    OR BEFORE THE CLAIM DISCHARGE DATE, OR                      *
378900* 2) A CBSA WITH AN EFFECTIVE DATE ON OR BEFORE THE CLAIM
379000*    DISCHARGE DATE AND A CLAIM DISCHARGE DATE ON OR BEFORE
379100*    09/30/2009 OR
379200* 3) A NON-INDIAN HEATLH CBSA WITH AN EFFECTIVE DATE ON OR BEFORE*
379300*    THE CLAIM DISHARGE DATE AND WITHIN THE CLAIM'S FISCAL YEAR  *
379400*----------------------------------------------------------------*
379500     IF  B-DISCHARGE-DATE NOT < CBSAX-EFF-DATE (CU2)
379600
379700         IF (HOLD-PROV-CBSA = '   98' OR
379800             HOLD-PROV-CBSA = '   99') OR
379900
380000*THE FOLLOWING LINE ADDED WITH VERSION 15.2 TO FIX A PROBLEM
380100*FOUND BY FISS THAT CAUSED AN UNEXPECTED WAGE INDEX ERROR CODE
380200*TO BE REPORTED
380300
380400            (B-DISCHARGE-DATE <= 20090930) OR
380500
380600            (CBSAX-EFF-DATE (CU2)  >= W-FY-BEGIN-DATE AND
380700             CBSAX-EFF-DATE (CU2)  <= W-FY-END-DATE)
380800
380900             MOVE CBSAX-CBSA (CU2)        TO W-NEW-CBSA
381000             MOVE CBSAX-EFF-DATE (CU2)    TO W-NEW-EFF-DATE-C
381100             MOVE CBSAX-WAGE-INDEX1 (CU2) TO W-NEW-INDEX1-RECORD-C
381200             MOVE CBSAX-WAGE-INDEX2 (CU2) TO W-NEW-INDEX2-RECORD-C
381300             MOVE CBSAX-WAGE-INDEX3 (CU2) TO W-NEW-INDEX3-RECORD-C
381400         END-IF
381500     END-IF.
381600
381700 0650-N-EXIT.
381800     EXIT.
381900
382000
382100******************************************************************
382200 0675-N-GET-IPPS-WAGE-INDX.
382300******************************************************************
382400
382500*----------------------------------------------------------------*
382600* TO SELECT THE WAGE INDEX, IT MUST BE EITHER:                   *
382700* 1) AN INDIAN HEALTH CBSA (98 OR 99) WITH AN EFFECTIVE DATE ON  *
382800*    OR BEFORE THE CLAIM DISCHARGE DATE, -OR-                    *
382900* 2) A NON-INDIAN HEATLH CBSA WITH AN EFFECTIVE DATE ON OR BEFORE*
383000*    THE CLAIM DISHARGE DATE AND WITHIN THE CLAIM'S FISCAL YEAR  *
383100*----------------------------------------------------------------*
383200     IF  B-DISCHARGE-DATE NOT < T-CBSA-EFF-DATE (MA2)
383300
383400         IF (HOLD-PROV-IPPS-CBSA = '   98' OR
383500             HOLD-PROV-IPPS-CBSA = '   99') OR
383600
383700            (T-CBSA-EFF-DATE (MA2) >= W-FY-BEGIN-DATE AND
383800             T-CBSA-EFF-DATE (MA2) <= W-FY-END-DATE)
383900
384000         MOVE T-CBSA (MA2)            TO W-CBSA-IPPS
384100         MOVE T-CBSA-EFF-DATE (MA2)   TO W-CBSA-IPPS-EFF-DATE
384200         MOVE T-CBSA-WAGE-INDX1 (MA2) TO W-IPPS-WAGE-INDEX
384300     END-IF.
384400
384500 0675-N-EXIT.
384600     EXIT.
384700
384800
384900******************************************************************
385000 0675-N-GET-IPPS-WAGE-INDX-RUR.
385100******************************************************************
385200
385300*----------------------------------------------------------------*
385400* TO SELECT THE WAGE INDEX, ITS EFFECTIVE DATE MUST BE ON OR     *
385500* BEFORE THE CLAIM DISCHARGE DATE AND WITHIN THE CLAIM'S FISCAL  *
385600* YEAR.                                                          *
385700*----------------------------------------------------------------*
385800     IF  B-DISCHARGE-DATE NOT < T-CBSA-EFF-DATE (MA2) AND
385900         T-CBSA-EFF-DATE (MA2) >= W-FY-BEGIN-DATE AND
386000         T-CBSA-EFF-DATE (MA2) <= W-FY-END-DATE
386100         MOVE T-CBSA (MA2)            TO W-CBSA-IPPS-RURAL
386200         MOVE T-CBSA-EFF-DATE (MA2)   TO W-CBSA-IPPS-RUR-EFF-DATE
386300         MOVE T-CBSA-WAGE-INDX1 (MA2) TO W-IPPS-WAGE-INDEX-RURAL
386400     END-IF.
386500
386600 0675-N-RUR-EXIT.
386700     EXIT.
386800
386900
387000******************************************************************
387100 0680-N-GET-IPPS-PR-WAGE-INDX.
387200******************************************************************
387300
387400*----------------------------------------------------------------*
387500* TO SELECT THE WAGE INDEX, ITS EFFECTIVE DATE MUST BE ON OR     *
387600* BEFORE THE CLAIM DISCHARGE DATE AND WITHIN THE CLAIM'S FISCAL  *
387700* YEAR.                                                          *
387800*----------------------------------------------------------------*
387900     IF  B-DISCHARGE-DATE NOT < T-CBSA-EFF-DATE (MA2) AND
388000         T-CBSA-EFF-DATE (MA2) >= W-FY-BEGIN-DATE AND
388100         T-CBSA-EFF-DATE (MA2) <= W-FY-END-DATE
388200         MOVE T-CBSA-WAGE-INDX1 (MA2) TO W-IPPS-PR-WAGE-INDEX
388300     END-IF.
388400
388500 0680-N-EXIT.
388600     EXIT.
388700
388800
388900******************************************************************
389000 0680-N-GET-IPPS-PR-WAGE-IDX-RU.
389100******************************************************************
389200
389300*----------------------------------------------------------------*
389400* TO SELECT THE WAGE INDEX, ITS EFFECTIVE DATE MUST BE ON OR     *
389500* BEFORE THE CLAIM DISCHARGE DATE AND WITHIN THE CLAIM'S FISCAL  *
389600* YEAR.                                                          *
389700*----------------------------------------------------------------*
389800     IF  B-DISCHARGE-DATE NOT < T-CBSA-EFF-DATE (MA2) AND
389900         T-CBSA-EFF-DATE (MA2) >= W-FY-BEGIN-DATE AND
390000         T-CBSA-EFF-DATE (MA2) <= W-FY-END-DATE
390100         MOVE T-CBSA-WAGE-INDX1 (MA2) TO W-IPPS-PR-WAGE-INDEX-RUR
390200     END-IF.
390300
390400 0680-N-RU-EXIT.
390500     EXIT.
390600
390700
390800******************************************************************
390900 0690-GET-RURAL-FLOOR-IPPS-WI.
391000******************************************************************
391100
391200     IF B-DISCHARGE-DATE NOT < RUFL-EFF-DATE (RUFL-IDX2) AND
391300        RUFL-EFF-DATE (RUFL-IDX2) >= W-FY-BEGIN-DATE AND
391400        RUFL-EFF-DATE (RUFL-IDX2) <= W-FY-END-DATE
391500        MOVE RUFL-CBSA     (RUFL-IDX2) TO W-CBSA-IPPS-RURAL
391600        MOVE RUFL-EFF-DATE (RUFL-IDX2) TO W-CBSA-IPPS-RUR-EFF-DATE
391700        MOVE RUFL-WI3      (RUFL-IDX2) TO W-IPPS-WAGE-INDEX-RURAL.
391800
391900 0690-EXIT.  EXIT.
392000
392100
392200******************************************************************
392300********************   END OF PROGRAM   **************************
392400******************************************************************
