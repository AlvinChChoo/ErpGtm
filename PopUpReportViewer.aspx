<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            ShowReport
        End Sub
    
        Sub ShowReport()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim RptnAME as string = TRIM(rEQUEST.PARAMS("RptName"))
            Dim repDoc As New ReportDocument()
            repDoc.Load(Mappath("") + "\Report\" & trim(RptName) & ".rpt")
            Dim subRepDoc As New ReportDocument()
            Dim myDBName as string = "erp_gtm"
            Dim myOwner as string = "dbo"
            Dim crSections As Sections
            Dim crSection As Section
            Dim crReportObjects As ReportObjects
            Dim crReportObject As ReportObject
            Dim crSubreportObject As SubreportObject
            Dim crDatabase As Database
            Dim crTables As Tables
            Dim crTable As CrystalDecisions.CrystalReports.Engine.Table
            Dim crFormulas as FormulaFieldDefinitions
            Dim RptTitle as string
            Dim crFormulaTextField1 as FormulaFieldDefinition
            Dim crFormulaTextField2 as FormulaFieldDefinition
            crFormulas = repDoc.DataDefinition.FormulaFields
            crFormulaTextField1 = crFormulas.Item("ReportTitle")
            crFormulaTextField2 = crFormulas.Item("CompanyName")
    
            Dim CompanyName as string = ReqCOM.getFieldVal("Select Company_Name from Main","Company_Name")
    
            Dim crLogOnInfo As TableLogOnInfo
            Dim crConnInfo As New ConnectionInfo()
    
    
            crDatabase = repDoc.Database
            crTables = crDatabase.Tables
    
            For Each crTable In crTables
                With crConnInfo
                    .ServerName = ConfigurationSettings.AppSettings("ServerName")
                    .DatabaseName = ConfigurationSettings.AppSettings("DatabaseName")
                    .UserID = ConfigurationSettings.AppSettings("UserID")
                    .Password = ConfigurationSettings.AppSettings("Password")
                End With
    
                crLogOnInfo = crTable.LogOnInfo
                crLogOnInfo.ConnectionInfo = crConnInfo
                crTable.ApplyLogOnInfo(crLogOnInfo)
    
            Next
            crTable.Location = myDBName & "." & myOwner & "." & crTable.Location.Substring(crTable.Location.LastIndexOf(".") + 1)
            crSections = repDoc.ReportDefinition.Sections
    
            For Each crSection In crSections
                crReportObjects = crSection.ReportObjects
                For Each crReportObject In crReportObjects
                    If crReportObject.Kind = ReportObjectKind.SubreportObject Then
                        crSubreportObject = CType(crReportObject, SubreportObject)
                        subRepDoc = crSubreportObject.OpenSubreport(crSubreportObject.SubreportName)
                        crDatabase = subRepDoc.Database
                        crTables = crDatabase.Tables
                            For Each crTable In crTables
                                With crConnInfo
                                    .ServerName = ConfigurationSettings.AppSettings("ServerName")
                                    .DatabaseName = ConfigurationSettings.AppSettings("DatabaseName")
                                    .UserID = ConfigurationSettings.AppSettings("UserID")
                                    .Password = ConfigurationSettings.AppSettings("Password")
                                End With
    
                                crLogOnInfo = crTable.LogOnInfo
                                crLogOnInfo.ConnectionInfo = crConnInfo
                                crTable.ApplyLogOnInfo(crLogOnInfo)
                            Next
                        crTable.Location = myDBName & "." & myOwner & "." & crTable.Location.Substring(crTable.Location.LastIndexOf(".") + 1)
                    End If
                Next
            Next
    
            select case ucase(RptnAME)
                Case "SALESORDERMODEL" : CrystalReportViewer1.SelectionFormula = "{so_model_m.LOT_NO} = '" & trim(request.params("LotNo")) & "' "
    
                Case "MRPPREXPPENDINGUPA"
                    ReqCOM.ExecuteNonQuery("Update MRP_D_Net set IND = 'N'")
    
                    ReqCOM.ExecuteNonQuery("Update MRP_D_Net set IND = 'Y' where lead_time is null and type <> 'F' and on_hold = 0 and source = 'P' and part_no in (select distinct(part_no) from part_master where supply_type <> 'MAKE')")
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_NET.IND} = 'Y'"
                Case "SALESORDERPART"
                    CrystalReportViewer1.SelectionFormula = "{so_part_m.LOT_NO} = '" & trim(request.params("LotNo")) & "' "
                Case "PREXTRAPURC":CrystalReportViewer1.SelectionFormula = "{PR1_M.PR_No} = '" & trim(Request.params("ID")) & "'"
                Case "SALESREPORTMODEL1" : CrystalReportViewer1.SelectionFormula = "{so_model_m.Model_No} >= '" & trim(request.params("ModelFrom")) & "' and {so_model_m.Model_No} <= '" & trim(request.params("ModelTo")) & "' and {so_model_m.so_date} >= #" & trim(request.params("DateFrom")) & "# and {so_model_m.so_date} <= #" & trim(request.params("DateTo")) & "#"
    
                Case "VMIPARTLIST" : CrystalReportViewer1.SelectionFormula = "{Part_source.Ven_Code} = '" & trim(request.params("VenCode")) & "' and {Part_Source.VMI} = 'Y'"
    
                Case "BOMQUOTEBOMOVERSALESPERCENTAGE"
    
                Case "BOMCOMBINEUSAGE"
    
                Case "MRPLOTSEXPLODED"
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_NET_HISTORY.MRP_No} = " & trim(request.params("MRPNo")) & ""
                Case "POOUTSTANDINGBYPARTNO"
                    ReqCOM.ExecuteNonQuery("update po_d set bal_qty = order_qty - in_qty")
                    RptTitle = "Part range from " & ucase(trim(request.params("PartFrom"))) & " to " & ucase(trim(request.params("PartFrom")))
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    CrystalReportViewer1.SelectionFormula = "{PO_D.Part_No} >= '" & trim(request.params("PartFrom")) & "' and {PO_D.Part_No} <= '" & trim(request.params("PartTo")) & "' and {PO_D.Bal_Qty} <> 0"
                Case "POOUTSTANDINGBYPONO"
                    ReqCOM.ExecuteNonQuery("update po_d set bal_qty = order_qty - in_qty")
                    RptTitle = "P/O No range from " & ucase(trim(request.params("POFrom"))) & " to " & ucase(trim(request.params("POTo")))
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    CrystalReportViewer1.SelectionFormula = "{PO_M.PO_No} >= '" & trim(request.params("POFrom")) & "' and {PO_M.PO_No} <= '" & trim(request.params("POTo")) & "'"
                Case "MIFTRANSRPT"
                    if trim(request.params("ColName")) = "VEN_CODE" THEN
                        CrystalReportViewer1.SelectionFormula = "{vendor.Ven_Code} like '*" & trim(request.params("ColValue")) & "*' and {mif_m.MIF_Status} like '*" & trim(request.params("MIFStatus")) & "*'"
                    Elseif trim(request.params("ColName")) = "VEN_NAME" THEN
                        CrystalReportViewer1.SelectionFormula = "{vendor.Ven_Name} like '*" & trim(request.params("ColValue")) & "*' and {mif_m.MIF_Status} like '*" & trim(request.params("MIFStatus")) & "*'"
                    elseif trim(request.params("ColName")) = "PART_NO" THEN
                        CrystalReportViewer1.SelectionFormula = "{MIF_D." & trim(request.params("ColName")) & "} like '*" & trim(request.params("ColValue")) & "*' and {mif_m.MIF_Status} like '*" & trim(request.params("MIFStatus")) & "*'"
                    else
                        CrystalReportViewer1.SelectionFormula = "{MIF_M." & trim(request.params("ColName")) & "} like '*" & trim(request.params("ColValue")) & "*' and {mif_m.MIF_Status} like '*" & trim(request.params("MIFStatus")) & "*'"
                    End if
                Case "MIFTRANSRPTMAIN"
                    if trim(request.params("ColName")) = "VEN_CODE" THEN
                        CrystalReportViewer1.SelectionFormula = "{vendor.Ven_Code} like '*" & trim(request.params("ColValue")) & "*' and {mif_m.MIF_Status} like '*" & trim(request.params("MIFStatus")) & "*'"
                    Elseif trim(request.params("ColName")) = "VEN_NAME" THEN
                        CrystalReportViewer1.SelectionFormula = "{vendor.Ven_Name} like '*" & trim(request.params("ColValue")) & "*' and {mif_m.MIF_Status} like '*" & trim(request.params("MIFStatus")) & "*'"
                    elseif trim(request.params("ColName")) = "PART_NO" THEN
                        CrystalReportViewer1.SelectionFormula = "{MIF_D." & trim(request.params("ColName")) & "} like '*" & trim(request.params("ColValue")) & "*' and {mif_m.MIF_Status} like '*" & trim(request.params("MIFStatus")) & "*'"
                    else
                        CrystalReportViewer1.SelectionFormula = "{MIF_M." & trim(request.params("ColName")) & "} like '*" & trim(request.params("ColValue")) & "*' and {mif_m.MIF_Status} like '*" & trim(request.params("MIFStatus")) & "*'"
                    End if
                Case "MRPVMI"
                    Dim Supplier as FormulaFieldDefinition
                    Supplier = crFormulas.Item("Supplier")
                    Supplier.text = "'" & ReqCOM.GetFieldVal("Select top 1 Ven_Name from Vendor where ven_code = '" & trim(Request.params("Vendor")) & "'","Ven_Name")  & "'"
    
                Case "MRPBYLOTWEEKCTF"
                    'ReqCOM.ExecuteNonQuery("TRUNCATE TABLE mrp_cross_tab")
                    'ReqCOM.ExecuteNonQuery("insert into mrp_cross_tab(part_no,lot_no,shortage_qty,ETA_DATE) select part_no,lot_no,net_req_qty,ETA_DATE from mrp_d_gross")
                    'ReqCOM.ExecuteNonQuery("update mrp_cross_tab set work_week = datepart(ww,eta_date)")
                    'ReqCOM.ExecuteNonQuery("update mrp_cross_tab set week_day = datepart(dw,eta_date)")
                    'ReqCOM.ExecuteNonQuery("Update mrp_cross_tab set first_date_of_week = eta_date - week_day + 1")
                    'ReqCOM.ExecuteNonQuery("uPDATE mrp_cross_tab SET WORK_WEEK_REM = 'WEEK ' + CAST(WORK_WEEK AS NVARCHAR(20))")
                    'ReqCOM.ExecuteNonQuery("update mrp_cross_tab set row_ind = CONVERT(char(6), first_date_of_week,12) + LOT_NO")
                    'ReqCOM.ExecuteNonQuery("UPDATE mrp_cross_tab SET mrp_cross_tab.OPEN_PO = CONVERT(DECIMAL(10,0),PART_MASTER.OPEN_PO),mrp_cross_tab.PART_DESC = PART_MASTER.PART_DESC,mrp_cross_tab.PART_SPEC = PART_MASTER.PART_SPEC,mrp_cross_tab.M_PART_NO = PART_MASTER.M_PART_NO,mrp_cross_tab.MFG = PART_MASTER.MFG FROM mrp_cross_tab,PART_MASTER WHERE mrp_cross_tab.PART_NO = PART_MASTER.PART_NO")
                    'ReqCOM.ExecuteNonQuery("UPDATE mrp_cross_tab SET mrp_cross_tab.MOQ = CONVERT(DECIMAL(10,0),PART_SOURCE.MIN_ORDER_QTY),mrp_cross_tab.SPQ=CONVERT(DECIMAL(10,0),PART_SOURCE.STD_PACK_QTY) FROM mrp_cross_tab,PART_SOURCE WHERE mrp_cross_tab.PART_NO = PART_SOURCE.PART_NO and PART_SOURCE.ven_seq = 1")
                    'ReqCOM.ExecuteNonQuery("INSERT INTO mrp_cross_tab(PART_NO,PART_DESC,PART_SPEC,MFG,M_PART_NO,OPEN_PO,ROW_SEQ,MOQ,SPQ,first_date_of_week,work_week_rem,work_week,Cust_Part_No,past_due,lot_no) SELECT top 1 'G-Tek Part No.','Description','PART SPEC','Manufacturer','MPN','Open Order',1,'MOQ','SPQ',first_date_of_week,work_week_rem,work_week,'End Customer Part No.','Past Due',lot_no from mrp_cross_tab order by first_date_of_week asc")
    
                    'ShowReport("PopupReportviewer.aspx?RptName=MRPByLotWeekCTF")
                Case "MRPALLOCATION" :
                    ReqCOM.ExecuteNonQuery("Truncate table MRP_PART_ALLOCATION")
    
                    If ucase(Trim(Request.params("By"))) = "PART" then
                        'if trim(Request.params("PartTo")) = "?" then ReqCOM.ExecuteNonQuery("Insert into MRP_PART_ALLOCATION(MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,ETA_DATE,ORDER_QTY,P_USAGE,ATT,QTY_ISSUED,VARIANCE_QTY,SHORTAGE_QTY,SOURCE,GROSS_REQ_QTY,NET_REQ_QTY,IND,REM_alt_det,row_id) select MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,ETA_DATE,ORDER_QTY,P_USAGE,ATT,QTY_ISSUED,-Net_Req_Qty,-Net_Req_Qty,SOURCE,GROSS_REQ_QTY,NET_REQ_QTY,IND,REM_alt_det,2 from mrp_d_net_1 where main_part = '" & trim(Request.params("PartFrom")) & "'")
                        'if trim(Request.params("PartTo")) <> "?" then ReqCOM.ExecuteNonQuery("Insert into MRP_PART_ALLOCATION(MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,ETA_DATE,ORDER_QTY,P_USAGE,ATT,QTY_ISSUED,VARIANCE_QTY,SHORTAGE_QTY,SOURCE,GROSS_REQ_QTY,NET_REQ_QTY,IND,REM_alt_det,row_id) select MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,ETA_DATE,ORDER_QTY,P_USAGE,ATT,QTY_ISSUED,-Net_Req_Qty,-Net_Req_Qty,SOURCE,GROSS_REQ_QTY,NET_REQ_QTY,IND,REM_alt_det,2 from mrp_d_net_1 where main_part >= '" & trim(Request.params("PartFrom")) & "' and main_part <= '" & trim(request.params("PartTo")) & "';")
    
                        if trim(Request.params("PartTo")) = "?" then ReqCOM.ExecuteNonQuery("Insert into MRP_PART_ALLOCATION(MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,ETA_DATE,ORDER_QTY,P_USAGE,ATT,QTY_ISSUED,VARIANCE_QTY,SHORTAGE_QTY,SOURCE,GROSS_REQ_QTY,NET_REQ_QTY,IND,REM_alt_det,row_id) select MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,ETA_DATE,ORDER_QTY,P_USAGE,ATT,QTY_ISSUED,-NET_REQ_QTY,-NET_REQ_QTY,SOURCE,GROSS_REQ_QTY,NET_REQ_QTY,IND,REM_alt_det,2 from mrp_d_net_1 where part_no = '" & trim(Request.params("PartFrom")) & "'")
                        if trim(Request.params("PartTo")) <> "?" then ReqCOM.ExecuteNonQuery("Insert into MRP_PART_ALLOCATION(MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,ETA_DATE,ORDER_QTY,P_USAGE,ATT,QTY_ISSUED,VARIANCE_QTY,SHORTAGE_QTY,SOURCE,GROSS_REQ_QTY,NET_REQ_QTY,IND,REM_alt_det,row_id) select MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,ETA_DATE,ORDER_QTY,P_USAGE,ATT,QTY_ISSUED,-NET_REQ_QTY,-NET_REQ_QTY,SOURCE,GROSS_REQ_QTY,NET_REQ_QTY,IND,REM_alt_det,2 from mrp_d_net_1 where part_no >= '" & trim(Request.params("PartFrom")) & "' and part_no <= '" & trim(request.params("PartTo")) & "';")
    
                    ElseIf ucase(Trim(Request.params("By"))) = "BUYER" then
                        ReqCOM.ExecuteNonQuery("Insert into MRP_PART_ALLOCATION(MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,ETA_DATE,ORDER_QTY,P_USAGE,ATT,QTY_ISSUED,VARIANCE_QTY,SHORTAGE_QTY,SOURCE,GROSS_REQ_QTY,NET_REQ_QTY,IND,REM_alt_det,row_id) select MODEL_NO,LOT_NO,SO_TYPE,PART_NO,MAIN,MAIN_PART,P_LEVEL,ETA_DATE,ORDER_QTY,P_USAGE,ATT,QTY_ISSUED,-Net_Req_Qty,-Net_Req_Qty,SOURCE,GROSS_REQ_QTY,NET_REQ_QTY,IND,REM_alt_det,2 from mrp_d_net_1 where main_part in (Select distinct(Part_No) from Part_Master where buyer_Code = '" & trim(request.params("BuyerCode")) & "')")
                    End if
    
                    'ReqCOM.ExecuteNonQuery("update MRP_PART_ALLOCATION set variance_qty = 0,shortage_qty = 0 where main_part <> part_no")
                    ReqCOM.ExecuteNonQuery("insert into MRP_PART_ALLOCATION(MAIN,MAIN_PART,part_no,Model_No,Lot_No,NET_REQ_QTY,VARIANCE_QTY,SHORTAGE_QTY,p_usage,row_id) select '-',part_no,part_no,'Bal B/F','-',MDO_BAL+IQC_BAL+OPEN_PO+BAL_QTY+WIP,MDO_BAL+IQC_BAL+OPEN_PO+BAL_QTY+WIP,MDO_BAL+IQC_BAL+BAL_QTY+WIP,1,1 from part_master WHERE part_no IN (SELECT MAIN_PART FROM MRP_PART_ALLOCATION)")
                    ReqCOM.ExecuteNonQuery("Update MRP_Part_Allocation set MRP_Part_Allocation.order_qty = SO_Models_M.order_qty from MRP_Part_Allocation,SO_Models_M where MRP_Part_Allocation.lot_no = SO_Models_M.lot_no")
                Case "BOMUNIQUEPART"
                    RptTitle = trim(request.params("ModelNo"))
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "FECNPARTWITHOUTSTDCOST"
                    RptTitle = "Model No : " & trim(request.params("ModelNo"))
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "MRPALL"
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_NET_RPT.source} = 'P' and {part_master.supply_type} <> 'MAKE'"
                    RptTitle = "MATERIAL SHORTAGE LIST (LIST ALL PARTS)"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "MRPSUMMARY" :
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_NET_RPT.source} = 'P' and {part_master.supply_type} <> 'MAKE'"
                    RptTitle = "MATERIAL SHORTAGE SUMMARY"
                Case "MRPLOT"
                    Dim LotNo as FormulaFieldDefinition
                    LotNo = crFormulas.Item("LotNo")
                    LotNo.text = "'Lot No : " & Request.params("LotNo") & "'"
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_Net_Rpt.lot_no} = '" & trim(request.params("LotNo")) & "' and {MRP_D_NET_RPT.source} = 'P' and {part_master.supply_type} <> 'MAKE'"
                    RptTitle = "MATERIAL SHORTAGE LIST (Lot No : " & trim(request.params("LotNo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "MRPMODEL"
                    Dim ModelNo as FormulaFieldDefinition
                    Dim modelNo1 as string = ReqCOM.GetFieldVal("Select top 1 rtrim(model_code) + '-' + model_Desc as [model_code] from Model_Master where model_code = '" & trim(request.params("ModelNo")) & "'","model_code")
    
                    ModelNo = crFormulas.Item("ModelNo")
                    ModelNo.text = "'Model No / Description : " & Trim(ModelNo1) & "'"
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_net_RPT.Model_No} = '" & trim(request.params("ModelNo")) & "' and {MRP_D_net_RPT.Source} = 'P' and {Part_Master.Supply_Type} <> 'MAKE'"
                    RptTitle = "MATERIAL SHORTAGE LIST (Model No : " & trim(request.params("ModelNo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "POOUTSTANDING"
                    RptTitle = "(Part Range from " & trim(request.params("PartNoFrom")) & " to " & trim(request.params("PartNoTo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{PART_MASTER.Part_No} >= '" & trim(request.params("PartNoFrom")) & "' and {PART_MASTER.Part_No} <= '" & trim(request.params("PartNoTo")) & "'"
    
                Case "POOUTSTANDINGNOCOST"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{PART_MASTER.Part_No} >= '" & trim(request.params("PartNoFrom")) & "' and {PART_MASTER.Part_No} <= '" & trim(request.params("PartNoTo")) & "'"
    
                Case "PROBLEMATICLIST"
                    CrystalReportViewer1.SelectionFormula = "{PART_MASTER.Supply_Type} <> 'MAKE'"
                Case "IQCINSPECTIONRPT"
                    Dim PartType as FormulaFieldDefinition
                    Dim DateFrom as FormulaFieldDefinition
                    Dim DateTo as FormulaFieldDefinition
                    Dim IQCResult as FormulaFieldDefinition
    
                    PartType = crFormulas.Item("PartType")
                    DateFrom = crFormulas.Item("DateFrom")
                    DateTo = crFormulas.Item("DateTo")
                    IQCResult = crFormulas.Item("IQCResult")
                    crFormulaTextField1 = crFormulas.Item("ReportTitle")
                    crFormulaTextField2 = crFormulas.Item("CompanyName")
                    PartType.text = "'" & Request.params("PartType") & "'"
                    DateFrom.text = "'" & Request.params("DateFrom") & "'"
                    DateTo.text = "'" & Request.params("DateTo") & "'"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
    
                    if Request.params("Status") = "ACC" then IQCResult.text = "'ACCEPT'" : CrystalReportViewer1.SelectionFormula = "{MIF_M.APP1_Date} >= #" & trim(request.params("DateFrom")) & " 00:00:00# and {MIF_M.APP1_Date} <= #" & trim(request.params("DateTo")) & " 11:59:59# and {MIF_D.ACCEPT_QTY}>0 and {MIF_D.PART_TYPE}='" & trim(request.params("PartType")) & "'"
                    if Request.params("Status") = "REJ" then IQCResult.text = "'REJECT'" : CrystalReportViewer1.SelectionFormula = "{MIF_M.APP1_Date} >= #" & trim(request.params("DateFrom")) & " 00:00:00# and {MIF_M.APP1_Date} <= #" & trim(request.params("DateTo")) & " 11:59:59# and {MIF_D.REJ_QTY}>0 and {MIF_D.PART_TYPE}='" & trim(request.params("PartType")) & "'"
                Case "BOM" :
                    Dim ModelNo as string
                    ModelNo = ReqCOM.GetFieldval("Select top 1 Model_Code from Model_Master where Seq_No = " & request.params("ModelNo") & ";","Model_Code")
                    CrystalReportViewer1.SelectionFormula = "{BOM_M.Model_No} = '" & trim(ModelNo) & "' and {BOM_M.Revision} = " & request.params("Revision") & ""
                Case "FECNSUMMARY" : CrystalReportViewer1.SelectionFormula = "{FECN_D.IND} = 'Y'"
    
    
                Case "OPENPO"
    
                    Dim StartDate as datetime
                    Dim CapMth1,CapMth2,CapMth3,CapMth4,CapMth5,CapMth6,CapMth7,CapMth8,CapMth9,CapMth10,CapMth11,CapMth12 as String
                    Dim Mth1,Mth2,Mth3,Mth4,Mth5,Mth6,Mth7,Mth8,Mth9,Mth10,Mth11,Mth12 as FormulaFieldDefinition
    
                    StartDate = Request.params("StartDate")
                    CapMth1 = Format(StartDate,"MMM, yy")
                    CapMth2 = Format(StartDate.AddMonths(1),"MMM, yy")
                    CapMth3 = Format(StartDate.AddMonths(2),"MMM, yy")
                    CapMth4 = Format(StartDate.AddMonths(3),"MMM, yy")
                    CapMth5 = Format(StartDate.AddMonths(4),"MMM, yy")
                    CapMth6 = Format(StartDate.AddMonths(5),"MMM, yy")
                    CapMth7 = Format(StartDate.AddMonths(6),"MMM, yy")
                    CapMth8 = Format(StartDate.AddMonths(7),"MMM, yy")
                    CapMth9 = Format(StartDate.AddMonths(8),"MMM, yy")
                    CapMth10 = Format(StartDate.AddMonths(9),"MMM, yy")
                    CapMth11 = Format(StartDate.AddMonths(10),"MMM, yy")
                    CapMth12 = Format(StartDate.AddMonths(11),"MMM, yy")
    
                    MTH1 = crFormulas.Item("MTH1") : MTH1.text = "'" & CapMth1 & "'"
                    MTH2 = crFormulas.Item("MTH2") : MTH2.text = "'" & CapMth2 & "'"
                    MTH3 = crFormulas.Item("MTH3") : MTH3.text = "'" & CapMth3 & "'"
                    MTH4 = crFormulas.Item("MTH4") : MTH4.text = "'" & CapMth4 & "'"
                    MTH5 = crFormulas.Item("MTH5") : MTH5.text = "'" & CapMth5 & "'"
                    MTH6 = crFormulas.Item("MTH6") : MTH6.text = "'" & CapMth6 & "'"
                    MTH7 = crFormulas.Item("MTH7") : MTH7.text = "'" & CapMth7 & "'"
                    MTH8 = crFormulas.Item("MTH8") : MTH8.text = "'" & CapMth8 & "'"
                    MTH9 = crFormulas.Item("MTH9") : MTH9.text = "'" & CapMth9 & "'"
                    MTH10 = crFormulas.Item("MTH10") : MTH10.text = "'" & CapMth10 & "'"
                    MTH11 = crFormulas.Item("MTH11") : MTH11.text = "'" & CapMth11 & "'"
                    MTH12 = crFormulas.Item("MTH12") : MTH12.text = "'" & CapMth12 & "'"
                Case "MRPPARTALLOCATION"
                    CrystalReportViewer1.SelectionFormula = "{mrp_d_rpt.Part_No} >= '" & trim(request.params("PartNoFrom")) & "' and {MRP_D_RPT.pART_NO} <= '" & trim(request.params("PartNoTo")) & "'"
    
                Case "PENYATABORANGKASTAM"
                    Dim Bulan,NoLesen,StesenImport as FormulaFieldDefinition
                    Bulan = crFormulas.Item("Bulan") : Bulan.text = "'" & request.params("Bulan") & "'"
                    NoLesen = crFormulas.Item("NoLesen") : noLesen.text = "'" & request.params("NoLesen") & "'"
    
                    if ucase(trim(request.params("CustomExp"))) <> "ALL" then CrystalReportViewer1.SelectionFormula = "{MIF_M.Custom_Exp} = '" & trim(request.params("CustomExp")) & "' and Year ({MIF_M.MIF_DATE}) = " & trim(request.params("MIFYear")) & " and Month ({MIF_M.MIF_DATE}) = " & trim(request.params("MIFMonth")) & ""
                    if ucase(trim(request.params("CustomExp"))) = "ALL" then CrystalReportViewer1.SelectionFormula = "Year ({MIF_M.MIF_DATE}) = " & trim(request.params("MIFYear")) & " and Month ({MIF_M.MIF_DATE}) = " & trim(request.params("MIFMonth")) & ""
    
                    'CrystalReportViewer1.SelectionFormula = "{MIF_M.Custom_Exp} = '" & trim(request.params("CustomExp")) & "' and Year ({MIF_M.MIF_DATE}) = " & trim(request.params("MIFYear")) & " and Month ({MIF_M.MIF_DATE}) = " & trim(request.params("MIFMonth")) & ""
    
    
    
    
                Case "UPAEXPIREDPARTS"
                    ReqCOM.ExecuteNonQuery("Update UPAS_D set expired = 'N'")
                    ReqCom.ExecuteNonQuery("Update upas_d set Expired = 'Y' where day(date_expired) = " & request.params("RDay") & " and month(date_expired) = " & request.params("RMonth") & " and year(date_expired) = " & Request.params("RYear") & ";")
                Case "BOMUSAGELIST" :
    
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "PARTSYNOPSIS"
                    RptTitle = "(Part Range from " & trim(request.params("PartNoFrom")) & " to " & trim(request.params("PartNoTo")) & ")"
                    RptTitle = ""
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{part_master.Bal_Qty} > 0 and {part_master.Part_No} >= '" & trim(request.params("PartNoFrom")) & "' and {part_master.Part_No} <= '" & request.params("PartNoTo") & "';"
                Case "PARTLIST"
                    if request.params("Type") = "PartRange" then
                        RptTitle = "(Part Range from " & trim(request.params("PartNoFrom")) & " to " & trim(request.params("PartNoTo")) & ")"
                        crFormulaTextField1.text = "'" & RptTitle & "'"
                        crFormulaTextField2.text = "'" & CompanyName & "'"
                        CrystalReportViewer1.SelectionFormula = "{part_master.Part_No} >= '" & trim(request.params("PartNoFrom")) & "' and {part_master.Part_No} <= '" & request.params("PartNoTo") & "';"
                    elseif request.params("Type") = "Part_Spec" then
                        RptTitle = "Part Specification : " & trim(request.params("Keyword"))
                        crFormulaTextField1.text = "'" & RptTitle & "'"
                        crFormulaTextField2.text = "'" & CompanyName & "'"
                        CrystalReportViewer1.SelectionFormula = "{part_master.Part_Spec} like '*" & trim(request.params("Keyword")) & "*';"
                    elseif request.params("Type") = "Part_Desc" then
                        RptTitle = "Part Description : " & trim(request.params("Keyword"))
                        crFormulaTextField1.text = "'" & RptTitle & "'"
                        crFormulaTextField2.text = "'" & CompanyName & "'"
                        CrystalReportViewer1.SelectionFormula = "{part_master.Part_Desc} like '*" & trim(request.params("Keyword")) & "*';"
                    elseif request.params("Type") = "M_Part_No" then
                        RptTitle = "Mfg Part No : " & trim(request.params("Keyword"))
                        crFormulaTextField1.text = "'" & RptTitle & "'"
                        crFormulaTextField2.text = "'" & CompanyName & "'"
                        CrystalReportViewer1.SelectionFormula = "{part_master.M_Part_No} like '*" & trim(request.params("Keyword")) & "*';"
                    elseif request.params("Type") = "MFG" then
                        RptTitle = "Manufacturer : " & trim(request.params("Keyword"))
                        crFormulaTextField1.text = "'" & RptTitle & "'"
                        crFormulaTextField2.text = "'" & CompanyName & "'"
                        CrystalReportViewer1.SelectionFormula = "{part_master.MFG} like '*" & trim(request.params("Keyword")) & "*';"
                    End if
                Case "PARTSOURCEEDIT"
                    Dim Cap1,Cap2,Val1,Val2 as FormulaFieldDefinition
                    Dim StrMsg as string
    
                    if UCASE(request.params("Sel")) = "BUYER" then
                        Cap1 = crFormulas.Item("Cap1")
                        StrMsg = trim("Buyer Code :")
                        Cap1.text = "'" & StrMsg  & "'"
    
                        Val1 = crFormulas.Item("Val1")
                        StrMsg = trim(Request.params("BuyerCode"))
                        Val1.text = "'" & StrMsg  & "'"
    
                        if ucase(trim(Request.params("BuyerCode"))) <> "ALL" then
                            CrystalReportViewer1.SelectionFormula = "{part_source_Approval_M.Modify_By} = '" & request.params("BuyerCode") & "';"
                        end if
                    elseif UCASE(request.params("Sel")) = "PARTNO" then
                        Cap1 = crFormulas.Item("Cap1")
                        StrMsg = trim("Part No From :")
                        Cap1.text = "'" & StrMsg  & "'"
    
                        Val1 = crFormulas.Item("Val1")
                        StrMsg = trim(Request.params("PartNoFrom"))
                        Val1.text = "'" & StrMsg  & "'"
    
                        Cap2 = crFormulas.Item("Cap2")
                        StrMsg = trim("Part No To :")
                        Cap2.text = "'" & StrMsg  & "'"
    
                        Val2 = crFormulas.Item("Val2")
                        StrMsg = trim(Request.params("PartNoTo"))
                        Val2.text = "'" & StrMsg  & "'"
                        CrystalReportViewer1.SelectionFormula = "{part_source_Approval_M.Part_No} >= '" & request.params("PartNoFrom") & "' and {part_source_Approval_M.Part_No} <= '" & request.params("PartNoTo") & "';"
                    elseif UCASE(request.params("Sel")) = "PSANO" then
                        Cap1 = crFormulas.Item("Cap1")
                        StrMsg = trim("PAS No From :")
                        Cap1.text = "'" & StrMsg  & "'"
    
                        Val1 = crFormulas.Item("Val1")
                        StrMsg = trim(Request.params("PASNoFrom"))
                        Val1.text = "'" & StrMsg  & "'"
    
                        Cap2 = crFormulas.Item("Cap2")
                        StrMsg = trim("PSA No To :")
                        Cap2.text = "'" & StrMsg  & "'"
    
                        Val2 = crFormulas.Item("Val2")
                        StrMsg = trim(Request.params("PASNoTo"))
                        Val2.text = "'" & StrMsg  & "'"
                        CrystalReportViewer1.SelectionFormula = "{part_source_Approval_M.PSA_No} >= '" & request.params("PSANoFrom") & "' and {part_source_Approval_M.PSA_No} <= '" & request.params("PSANoTo") & "';"
    
                    End if
    
    
                Case "PARTSWITHOUTSOURCES"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
    
                Case "BOMQUOTETARGETCOSTSORTBYPARTNO":CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.MAIN} = 'MAIN';"
                Case "BOMQUOTETARGETCOSTSORTBYDESCRIPTION":CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.MAIN} = 'MAIN';"
                Case "BOMQUOTETARGETCOSTSORTBYORIGINALCURRENCY":CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.main} = 'MAIN';"
                Case "BOMQUOTETARGETCOSTSORTBYVENDOR":CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.MAIN} = 'MAIN';"
    
                Case "BOMQUOTETARGETVSLOWESTCOSTSORTBYPARTNO"
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set lowest_up = 0 where lowest_up is null and bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "';")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Std_UP = 0 where Std_UP is null and bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "';")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set ind = 'N'")
                    ReqCOM.ExecuteNonQuery("Truncate table BOM_Quote_Rpt")
                    ReqCom.ExecuteNonQuery("Insert into BOM_Quote_Rpt(Val_UP,Main_Part,BOM_Quote_No) select min(Lowest_up), main_part,'" & trim(request.params("BOMQuoteNo")) & "' from bom_quote_d where bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and p_usage > 0 and lowest_up > 0 group by main_part")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Low_YN = 'N'")
                    ReqCom.ExecuteNonQuery("Insert into BOM_Quote_Rpt(Ref_Seq_No) select max(bd.Seq_No) from bom_quote_d bd,bom_quote_rpt br where bd.bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and bd.main_part = br.main_part and bd.lowest_up = br.val_up group by bd.main_part")
                    ReqCom.ExecuteNonQuery("Update BOM_Quote_D set ind = 'Y' where seq_no in (Select ref_seq_No from bom_quote_Rpt)")
                    ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set Low_YN = 'Y' where bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and Main_Part = Part_No")
                    CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.Low_YN} = 'Y';"
                Case "BOMQUOTETARGETVSSOURCINGAVGCOSTSORTBYPARTNO"
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Average_Var = 0")
                    ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set Average_Var = Std_Up - Average_Hi_Low where BOM_Quote_No = '" & trim(request.params("BOMQuoteNo")) & "';")
                    CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.Main} = 'Main' and {BOM_Quote_D.Average_Var} <> 0;"
    
                Case "BOMQUOTETARGETVS1STVDRCOSTSORTBYPARTNO"
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Average_Var = 0")
                    ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set Average_Var = Std_Up - First_Up where BOM_Quote_No = '" & trim(request.params("BOMQuoteNo")) & "';")
                    CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.Main} = 'Main' and {BOM_Quote_D.Average_Var} <> 0;"
    
                Case "BOMQUOTESOURCINGAVGCOSTSORTBYPARTNO":CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.MAIN} = 'MAIN';"
                Case "BOMQUOTE1STVENDORCOSTSORTBYPARTNO":CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.MAIN} = 'MAIN';"
                Case "BOMQUOTETARGETVSHIGHESTCOSTSORTBYPARTNO"
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set highest_up = 0 where highest_up is null and bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "';")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set std_up = 0 where std_up is null and bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "';")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set ind = 'N'")
                    ReqCOM.ExecuteNonQuery("Truncate table BOM_Quote_Rpt")
                    ReqCom.ExecuteNonQuery("Insert into BOM_Quote_Rpt(Val_UP,Main_Part,BOM_Quote_No) select max(Highest_up), main_part,'" & trim(request.params("BOMQuoteNo")) & "' from bom_quote_d where bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and p_usage > 0 and highest_up > 0 group by main_part")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set High_YN = 'N'")
                    ReqCom.ExecuteNonQuery("Insert into BOM_Quote_Rpt(val_up,main_part,bom_quote_no) select max(std_up),main_part,'1' from bom_quote_d where bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and p_usage > 0 group by main_part")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_Rpt set bom_quote_rpt.ref_seq_no = bom_quote_d.seq_no from BOM_Quote_D,BOM_Quote_Rpt where BOM_Quote_D.main_part = BOM_Quote_Rpt.main_part and BOM_Quote_D.std_up = BOM_Quote_Rpt.val_up and bom_quote_d.bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "';")
                    ReqCOM.executeNonQuery("Update BOM_Quote_Rpt set val_up = null, main_part = null where bom_quote_no = '1'")
                    ReqCom.ExecuteNonQuery("Update BOM_Quote_D set ind = 'Y' where seq_no in (Select ref_seq_No from bom_quote_Rpt)")
                    ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set High_YN = 'Y' where bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and Main_Part = Part_No")
                    CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.High_YN} = 'Y' and {@VarLocalCurrUnitCost} <> 0;"
                Case "BOMQUOTEHIGHESTCOSTSORTBYPARTNO"
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set highest_up = 0 where highest_up is null and bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "';")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set std_up = 0 where std_up is null and bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "';")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set ind = 'N'")
                    ReqCOM.ExecuteNonQuery("Truncate table BOM_Quote_Rpt")
                    ReqCom.ExecuteNonQuery("Insert into BOM_Quote_Rpt(Val_UP,Main_Part,BOM_Quote_No) select max(Highest_up), main_part,'" & trim(request.params("BOMQuoteNo")) & "' from bom_quote_d where bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and p_usage > 0 and highest_up > 0 group by main_part")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set High_YN = 'N'")
                    ReqCom.ExecuteNonQuery("Insert into BOM_Quote_Rpt(val_up,main_part,bom_quote_no) select max(std_up),main_part,'1' from bom_quote_d where bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and p_usage > 0 group by main_part")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_Rpt set bom_quote_rpt.ref_seq_no = bom_quote_d.seq_no from BOM_Quote_D,BOM_Quote_Rpt where BOM_Quote_D.main_part = BOM_Quote_Rpt.main_part and BOM_Quote_D.std_up = BOM_Quote_Rpt.val_up and bom_quote_d.bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "';")
                    ReqCOM.executeNonQuery("Update BOM_Quote_Rpt set val_up = null, main_part = null where bom_quote_no = '1'")
                    ReqCom.ExecuteNonQuery("Update BOM_Quote_D set ind = 'Y' where seq_no in (Select ref_seq_No from bom_quote_Rpt)")
                    ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set BOM_Quote_D.High_YN = 'Y' from BOM_Quote_D,bom_quote_rpt where bom_quote_d.bom_quote_no = bom_quote_rpt.bom_quote_no and bom_quote_d.Main_Part = bom_quote_rpt.Main_Part and bom_quote_d.Highest_up = bom_quote_rpt.val_up and BOM_Quote_D.ind = 'Y'")
                    CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.High_YN} = 'Y';"
                Case "BOMQUOTELOWESTCOSTSORTBYPARTNO"
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set lowest_up = 0 where lowest_up is null and bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "';")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set ind = 'N'")
                    ReqCOM.ExecuteNonQuery("Truncate table BOM_Quote_Rpt")
    
                    ReqCom.ExecuteNonQuery("Insert into BOM_Quote_Rpt(Val_UP,Main_Part,BOM_Quote_No) select min(Lowest_up), main_part,'" & trim(request.params("BOMQuoteNo")) & "' from bom_quote_d where bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and p_usage > 0 group by main_part")
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Low_YN = 'N'")
                    ReqCom.ExecuteNonQuery("Insert into BOM_Quote_Rpt(Ref_Seq_No) select max(bd.Seq_No) from bom_quote_d bd,bom_quote_rpt br where bd.bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and bd.main_part = br.main_part and bd.lowest_up = br.val_up group by bd.main_part")
                    ReqCom.ExecuteNonQuery("Update BOM_Quote_D set ind = 'Y' where seq_no in (Select ref_seq_No from bom_quote_Rpt)")
                    ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set BOM_Quote_D.Low_YN = 'Y' from BOM_Quote_D,bom_quote_rpt where bom_quote_d.bom_quote_no = bom_quote_rpt.bom_quote_no and bom_quote_d.Main_Part = bom_quote_rpt.Main_Part and bom_quote_d.Lowest_up = bom_quote_rpt.val_up and BOM_Quote_D.ind = 'Y'")
                    CrystalReportViewer1.SelectionFormula = "{BOM_Quote_M.BOM_Quote_No} = '" & request.params("BOMQuoteNo") & "' and {BOM_Quote_D.Low_YN} = 'Y';"
                Case "WHEREUSELIST"
                    Dim PartNoFrom,PartNoTo as FormulaFieldDefinition
                    Dim StrMsg as string
    
                    PartNoFrom = crFormulas.Item("PartNoFrom")
                    PartNoTo = crFormulas.Item("PartNoTo")
    
                    StrMsg = trim(request.params("PartNoFrom"))
                    PartNoFrom.text = "'" & StrMsg  & "'"
    
                    StrMsg = trim(request.params("PartNoTo"))
                    PartNoTo.text = "'" & StrMsg  & "'"
    
                    ReqCOM.ProcessWhereUseList(trim(request.params("PartNoFrom")),trim(request.params("PartNoTo")))
    
                    RptTitle = "(Part Range from " & trim(request.params("PartNoFrom")) & " to " & trim(request.params("PartNoTo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                Case "PALLETRECORD"
                    CrystalReportViewer1.SelectionFormula = "{PALLET_RECORD_M.Seq_No} = " & trim(request.params("ID")) & ";"
                Case "JOBORDERTRACKING"
                    Dim JONo,PDLevel as FormulaFieldDefinition
                    Dim StrMsg as string
    
                    JONo = crFormulas.Item("JONo")
                    PDLevel = crFormulas.Item("PDLevel")
    
                    StrMsg = trim(request.params("JONo"))
                    JONo.text = "'" & StrMsg  & "'"
    
                    StrMsg = trim(request.params("Section"))
                    PDLevel.text = "'" & StrMsg  & "'"
                    CrystalReportViewer1.SelectionFormula = "{JOB_Order_Trail.JO_NO} = '" & trim(request.params("JONo")) & "' and {JOB_Order_Trail.PD_Level} = '" & request.params("Section") & "';"
                Case "MRF"
                    CrystalReportViewer1.SelectionFormula = "{MRF_M.Seq_No} = " & trim(request.params("ID")) & ";"
                Case "MATERIALISSUINGJOLEVEL"
                    Dim LotNo,LotSize,JONo,ModelDet,JOSize,Level as FormulaFieldDefinition
                    Dim StrMsg as string
    
                    LotNo = crFormulas.Item("LotNo")
                    LotSize = crFormulas.Item("LotSize")
                    JONo = crFormulas.Item("JONo")
                    JOSize = crFormulas.Item("JOSize")
                    Level = crFormulas.Item("Level")
                    ModelDet = crFormulas.Item("ModelDet")
    
                    StrMsg = trim(request.params("LotNo"))
                    LotNo.text = "'" & StrMsg  & "'"
    
                    StrMsg = trim(request.params("LotSize"))
                    LotSize.text = "'" & StrMsg  & "'"
    
                    StrMsg = trim(request.params("JONo"))
                    JONo.text = "'" & StrMsg  & "'"
    
                    StrMsg = trim(request.params("JOSize"))
                    JOSize.text = "'" & StrMsg  & "'"
    
                    StrMsg = trim(request.params("Level"))
                    Level.text = "'" & StrMsg  & "'"
    
                    StrMsg = trim(request.params("ModelDet"))
                    ModelDet.text = "'" & StrMsg  & "'"
    
                Case "MATISUINGRECBYJO"
                    'Dim LotNo,LotSize,JONo,ModelDet,JOSize,Level as FormulaFieldDefinition
                    'Dim StrMsg as string
    
                    'LotNo = crFormulas.Item("LotNo")
                    'LotSize = crFormulas.Item("LotSize")
                    'JONo = crFormulas.Item("JONo")
                    'JOSize = crFormulas.Item("JOSize")
                    'Level = crFormulas.Item("Level")
                    'ModelDet = crFormulas.Item("ModelDet")
    
                    'StrMsg = trim(request.params("LotNo"))
                    'LotNo.text = "'" & StrMsg  & "'"
    
                    'StrMsg = trim(request.params("LotSize"))
                    'LotSize.text = "'" & StrMsg  & "'"
    
                    'StrMsg = trim(request.params("JONo"))
                    'JONo.text = "'" & StrMsg  & "'"
    
                    'StrMsg = trim(request.params("JOSize"))
                    'JOSize.text = "'" & StrMsg  & "'"
    
                    'StrMsg = trim(request.params("Level"))
                    'Level.text = "'" & StrMsg  & "'"
    
                    'StrMsg = trim(request.params("ModelDet"))
                    'ModelDet.text = "'" & StrMsg  & "'"
                Case "MIFPOPARTTRACKING"
                    Dim PONo,PartNo as FormulaFieldDefinition
                    Dim StrMsg as string
    
                    PONo = crFormulas.Item("PONo")
                    PartNo = crFormulas.Item("PartNo")
    
                    StrMsg = trim(request.params("PartNo"))
                    PartNo.text = "'" & StrMsg  & "'"
    
                    StrMsg = trim(request.params("PONo"))
                    PONo.text = "'" & StrMsg  & "'"
    
                    CrystalReportViewer1.SelectionFormula = "{mif_d.part_no} = '" & trim(request.params("PartNo")) & "' and {mif_d.po_no} = '" & request.params("PoNo") & "';"
    
                Case "DAILYMIF"
                    Dim DateFromParam,DateToParam as FormulaFieldDefinition
    
                    Dim DateFrom,DateTo as date
                    Dim FromStr,ToStr as string
    
                    DateFromParam = crFormulas.Item("DateFrom")
                    DateToParam = crFormulas.Item("DateTo")
    
                    DateFrom = request.params("DateFrom")
                    DateTo = request.params("DateTo")
    
                    DateFromParam.text = "'" & format(cdate(DateFrom),"dd/MM/yy") & "'"
                    DateToParam.text = "'" & format(cdate(DateTo),"dd/MM/yy") & "'"
    
                    FromStr = DateFrom.Year & "," & DateFrom.Month & "," & DateFrom.Day & ",00,00,00"
                    ToStr = DateTo.Year & "," & DateTo.Month & "," & DateTo.Day & ",23,59,59"
    
                    CrystalReportViewer1.SelectionFormula = "{MIF_M.MIF_DATE} in DateTime (" & trim(FromStr) & ") to DateTime (" & trim(ToStr) & ")"
                Case "UPA"
                    RptTitle = ""
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{UPAS_M.UPAS_No} = '" & trim(request.params("UPASNo")) & "'"
                Case "FECN"
                    RptTitle = "FACTORY ENGINEERING CHANGE NOTICE (FECN)"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{FECN_M.FECN_No} = '" & trim(request.params("FECNNo")) & "'"
                Case "SSET"
                    RptTitle = "SAMPLE SUBMISSION & EVALUATION TRAVELER (SSET)"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{SSER_M.SSER_No} = '" & trim(request.params("SSERNo")) & "'"
                Case "BOMDIFFLIST"
                    RptTitle = ""
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                Case "PARTPRICEBYPARTNO"
                    RptTitle = ""
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{PART_SOURCE.PART_NO} >= '" & trim(request.params("PartNoFrom")) & "' and {PART_SOURCE.PART_NO} <= '" & request.params("PartNoTo") & "';"
                Case "PRSUMMARY"
                    RptTitle = "PR Summary Report"
                    crFormulaTextField1.text = "'" & request.params("ID") & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{pr1_D.pr_no} = '" & trim(request.params("ID")) & "'"
                Case "SFAS"
                    Dim ForecastDate as date
                    Dim ForecastDateStr as string
                    Dim Forecast1,Forecast2,Forecast3,Forecast4,Forecast5,Forecast6,Forecast7 as FormulaFieldDefinition
                    Forecast1 = crFormulas.Item("Month1")
                    Forecast2 = crFormulas.Item("Month2")
                    Forecast3 = crFormulas.Item("Month3")
                    Forecast4 = crFormulas.Item("Month4")
                    Forecast5 = crFormulas.Item("Month5")
                    Forecast6 = crFormulas.Item("Month6")
                    Forecast7 = crFormulas.Item("Month7")
    
                    ForecastDateStr = format(cdate(Request.params("Month1")),"MMM,yyyy")
                    Forecast1.text = "'" & ForecastDateStr  & "'"
    
                    ForecastDateStr = format(cdate(Request.params("Month2")),"MMM,yyyy")
                    Forecast2.text = "'" & ForecastDateStr  & "'"
    
                    ForecastDateStr = format(cdate(Request.params("Month3")),"MMM,yyyy")
                    Forecast3.text = "'" & ForecastDateStr  & "'"
    
                    ForecastDateStr = format(cdate(Request.params("Month4")),"MMM,yyyy")
                    Forecast4.text = "'" & ForecastDateStr  & "'"
    
                    ForecastDateStr = format(cdate(Request.params("Month5")),"MMM,yyyy")
                    Forecast5.text = "'" & ForecastDateStr  & "'"
    
                    ForecastDateStr = format(cdate(Request.params("Month6")),"MMM,yyyy")
                    Forecast6.text = "'" & ForecastDateStr  & "'"
    
                    ForecastDateStr = format(cdate(Request.params("Month7")),"MMM,yyyy")
                    Forecast7.text = "'" & ForecastDateStr  & "'"
                Case "PARTPRICE"
                    Dim StrCriteria as string
                    Dim crFormulaCriteria1Caption as FormulaFieldDefinition
                    Dim crFormulaCriteria1 as FormulaFieldDefinition
                    crFormulaCriteria1Caption = crFormulas.Item("Criteria1Caption")
                    crFormulaCriteria1 = crFormulas.Item("Criteria1")
                    if trim(request.params("RptType")) = "Part" then
                        StrCriteria = "Part Range : "
                        crFormulaCriteria1Caption.text = "'" & StrCriteria  & "'"
                        StrCriteria = trim(Request.params("PartNoFrom")) & " to " & trim(request.params("PartNoTo"))
                        crFormulaCriteria1.text = "'" & StrCriteria  & "'"
                        RptTitle = ""
                        crFormulaTextField1.text = "'" & RptTitle & "'"
                        crFormulaTextField2.text = "'" & CompanyName & "'"
                        CrystalReportViewer1.SelectionFormula = "{PART_SOURCE.PART_NO} >= '" & trim(request.params("PartNoFrom")) & "' and {PART_SOURCE.PART_NO} <= '" & request.params("PartNoTo") & "';"
                    Elseif trim(request.params("RptType")) = "Supplier" then
                        StrCriteria = "Supplier Range : "
                        crFormulaCriteria1Caption.text = "'" & StrCriteria  & "'"
                        StrCriteria = trim(Request.params("SupplierFrom")) & " to " & trim(request.params("SupplierTo"))
                        crFormulaCriteria1.text = "'" & StrCriteria  & "'"
                        RptTitle = ""
                        crFormulaTextField1.text = "'" & RptTitle & "'"
                        crFormulaTextField2.text = "'" & CompanyName & "'"
                        CrystalReportViewer1.SelectionFormula = "{PART_SOURCE.Ven_Code} >= '" & trim(request.params("SupplierFrom")) & "' and {PART_SOURCE.Ven_Code} <= '" & request.params("SupplierTo") & "';"
                    end if
                Case "UPAHISTORY"
                    if trim(request.params("RptType")) = "Part" then
                        if trim(request.params("Status")) <> "ALL" then
                            RptTitle = ""
                            crFormulaTextField1.text = "'" & RptTitle & "'"
                            crFormulaTextField2.text = "'" & CompanyName & "'"
                            CrystalReportViewer1.SelectionFormula = "{UPAS_D.PART_NO} >= '" & trim(request.params("PartNoFrom")) & "' and {UPAS_D.PART_NO} <= '" & request.params("PartNoTo") & "' and {upas_m.upas_status} = '" & request.params("Status") & "';"
                        elseif trim(request.params("Status")) = "ALL" then
                            RptTitle = ""
                            crFormulaTextField1.text = "'" & RptTitle & "'"
                            crFormulaTextField2.text = "'" & CompanyName & "'"
                            CrystalReportViewer1.SelectionFormula = "{UPAS_D.PART_NO} >= '" & trim(request.params("PartNoFrom")) & "' and {UPAS_D.PART_NO} <= '" & request.params("PartNoTo") & "';"
                        end if
                    Elseif trim(request.params("RptType")) = "Supplier" then
                        if trim(request.params("Status")) <> "ALL" then
                            RptTitle = ""
                            crFormulaTextField1.text = "'" & RptTitle & "'"
                            crFormulaTextField2.text = "'" & CompanyName & "'"
                            CrystalReportViewer1.SelectionFormula = "{UPAS_D.Ven_Code} >= '" & trim(request.params("SupplierFrom")) & "' and {UPAS_D.Ven_Code} <= '" & request.params("SupplierTo") & "' and {UPAS_m.upas_status} = '" & request.params("Status") & "';"
    
                        elseif trim(request.params("Status")) = "ALL" then
                            RptTitle = ""
                            crFormulaTextField1.text = "'" & RptTitle & "'"
                            crFormulaTextField2.text = "'" & CompanyName & "'"
                            CrystalReportViewer1.SelectionFormula = "{UPAS_D.Ven_Code} >= '" & trim(request.params("SupplierFrom")) & "' and {UPAS_D.Ven_Code} <= '" & request.params("SupplierTo") & "';"
                        end if
                    End if
                Case "PARTPRICEBYSUPPLIER"
                    RptTitle = ""
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{PART_SOURCE.VEN_CODE} >= '" & trim(request.params("SupplierFrom")) & "' and {PART_SOURCE.VEN_CODE} <= '" & request.params("SupplierTo") & "';"
                Case "BOMCOST"
                    RptTitle = "Model No : " & Request.params("ModelNo")
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{BOM_M.Model_No} = '" & trim(request.params("ModelNo")) & "' and {Part_Source.Ven_Seq} = 1 and {BOM_M.Revision} = " & cdec(request.params("Revision")) & ";"
                Case "SSET"
                    RptTitle = "SAMPLE SUBMISSION & EVALUATION TRAVELER (SSET)"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{SSER_M.SSER_No} = '" & trim(request.params("SSERNo")) & "'"
                Case "SSER"
                    RptTitle = "SAMPLE SUBMISSION & EVALUATION REPORT (SSER)"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{SSER_M.SSER_No} = '" & trim(request.params("SSERNo")) & "'"
                Case "SSERREJECTRPT"
                    RptTitle = "Date from " & format(cdate(Request.params("DateFrom")),"dd/MMM/yy") & " to " & format(cdate(request.params("DateTo")),"dd/MMM/yy")
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{sser_rej_rpt.submit_date} >= #" & trim(request.params("DateFrom")) & "# and {sser_rej_rpt.submit_date} <= #" & trim(request.params("DateTo")) & "# "
                Case "SSERDAYSLAPSE"
                    RptTitle = "Date from " & format(cdate(Request.params("DateFrom")),"dd/MMM/yy") & " to " & format(cdate(request.params("DateTo")),"dd/MMM/yy")
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{SSER_M.submit_date} >= #" & trim(request.params("DateFrom")) & "# and {SSER_M.submit_date} <= #" & trim(request.params("DateTo")) & "# and {sser_m.days_lapse} > 0"
                Case "PO"
                    CrystalReportViewer1.SelectionFormula = "{PO_M.PO_No} = '" & trim(request.params("PONo")) & "';"
                case "SSERTRANSDETRPT"
                    RptTitle = "FOR TRANSACTION BETWEEN " & format(CDATE(request.params("StartDate")),"dd/MMM/yy") & " TO " & format(cdate(request.params("EndDate")),"dd/MMM/yy")
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    if trim(request.params("Buyer")) = "ALL" then
                        CrystalReportViewer1.SelectionFormula = "{SSER_M.submit_date} >= #" & trim(request.params("sTARTdATE")) & "# and {SSER_M.submit_date} <= #" & trim(request.params("EndDate")) & "#"
                    elseif trim(request.params("Buyer")) <> "ALL" then
                        CrystalReportViewer1.SelectionFormula = "{SSER_M.submit_date} >= #" & trim(request.params("sTARTdATE")) & "# and {SSER_M.submit_date} <= #" & trim(request.params("EndDate")) & "# and {sser_m.submit_by} = '" & trim(request.params("Buyer")) & "'"
                    End if
                Case "WIPSTOCKBALSUMMARY"
                    Dim Location,PartNoFrom,PartNoTo,DateFrom,DateTo as FormulaFieldDefinition
                    Dim Str as string
    
                    Location = crFormulas.Item("Location")
                    PartNoFrom = crFormulas.Item("PartNoFrom")
                    PartNoTo = crFormulas.Item("PartNoTo")
                    DateFrom = crFormulas.Item("DateFrom")
                    DateTo = crFormulas.Item("DateTo")
    
                    Str = Request.params("Location")
                    Location.text = "'" & Str  & "'"
    
                    Str = Request.params("PartNoFrom")
                    PartNoFrom.text = "'" & Str  & "'"
    
                    Str = Request.params("PartNoTo")
                    PartNoTo.text = "'" & Str  & "'"
    
                    Str = Request.params("DateFrom")
                    DateFrom.text = "'" & Str  & "'"
    
                    Str = Request.params("DateTo")
                    DateTo.text = "'" & Str  & "'"
    
                Case "WIPLEDGER"
                    Dim Location,PartNoFrom,PartNoTo,DateFrom,DateTo as FormulaFieldDefinition
                    Dim Str as string
    
                    Location = crFormulas.Item("Location")
                    PartNoFrom = crFormulas.Item("PartNoFrom")
                    PartNoTo = crFormulas.Item("PartNoTo")
                    DateFrom = crFormulas.Item("DateFrom")
                    DateTo = crFormulas.Item("DateTo")
    
                    Str = Request.params("Location")
                    Location.text = "'" & Str  & "'"
    
                    Str = Request.params("PartNoFrom")
                    PartNoFrom.text = "'" & Str  & "'"
    
                    Str = Request.params("PartNoTo")
                    PartNoTo.text = "'" & Str  & "'"
    
                    Str = Request.params("DateFrom")
                    DateFrom.text = "'" & Str  & "'"
    
                    Str = Request.params("DateTo")
                    DateTo.text = "'" & Str  & "'"
                Case "POETATRAIL"
                case "FECNBOMCost"
                case "FECNBOMCOSTHISTORY"
                    CrystalReportViewer1.SelectionFormula = "{FECN_BOM_COMPARISON_HISTORY.FECN_NO} = '" & trim(request.params("FecnNo")) & "'"
                Case "SOFOLTrail"
                Case "PARTWITHOUTSTDCOST"
                Case "SUPPLYVSDEMANDSUMMARY"
                    Dim StrCriteria as string
                    Dim crCriteria as FormulaFieldDefinition
                    crCriteria = crFormulas.Item("Criteria")
                    StrCriteria = Request.params("RptTitle")
                    crCriteria.text = "'" & StrCriteria  & "'"
                Case "POOUTBYSUPPPARTETA"
                    Dim StrCriteria as string
                    Dim crFormulaCriteria1 as FormulaFieldDefinition
                    Dim crFormulaCriteria2 as FormulaFieldDefinition
    
                    crFormulaCriteria1 = crFormulas.Item("Criteria1")
                    crFormulaCriteria2 = crFormulas.Item("Criteria2")
                    StrCriteria = trim(Request.params("VenFrom")) & " to " & trim(request.params("VenTo"))
                    crFormulaCriteria1.text = "'" & StrCriteria  & "'"
                    StrCriteria = format(cdate(Request.params("ETAFrom")),"dd/MM/yy") & " to " & format(cdate(Request.params("ETATo")),"dd/MM/yy")
                    crFormulaCriteria2.text = "'" & StrCriteria  & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{PO_M.Ven_Code} >= '" & trim(request.params("VenFrom")) & "' and {PO_M.Ven_Code} <= '" & trim(request.params("VenTo")) & "' and {po_D.del_date} >= #" & trim(request.params("ETAFrom")) & "# and {po_D.del_date} <= #" & trim(request.params("ETATo")) & "#"
                Case "PCMCSRRPT"
                    CrystalReportViewer1.SelectionFormula = "{SR_M.submit_date} >= #" & trim(request.params("SRDateFrom")) & "# and {SR_M.submit_date} <= #" & trim(request.params("SRDateTo")) & "# and {sr_d.part_no} >= '" & trim(request.params("PartnoFrom")) & "' and {sr_d.part_no} <= '" & trim(request.params("PartNoTo")) & "';"
            End select
    
            'repDoc.ExportOptions.FormatType = crEFTWordForWindows
            'CrystalReportViewer1.ReportSource = repDoc
            'crReportObjectS.ExportOptions.FormatType = crEFTWordForWindows
    
            CrystalReportViewer1.ReportSource = repDoc
            CrystalReportViewer1.RefreshReport()
        End sub
    
        Sub CrystalReportViewer1_Init(sender As Object, e As EventArgs)
        End Sub
    
        Sub Button1_Click(sender As Object, e As EventArgs)
            Response.redirect("BOMRpt.aspx")
        End Sub

</script>
<html>
<head>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form method="post" runat="server">
        <p>
            <table style="HEIGHT: 38px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="3">
                            <p>
                                <CR:CRYSTALREPORTVIEWER id="CrystalReportViewer1" runat="server" Hasexportbutton="true" HasDrillUpButton="False" HasGotoPageButton="False" HasSearchButton="False" DisplayGroupTree="False" HasCrystalLogo="False" HasToggleGroupTreeButton="False" OnInit="CrystalReportViewer1_Init" EnableParameterPrompt="False" EnableDatabaseLogonPrompt="False" borderwidth="1px" borderstyle="Dotted" pagetotreeratio="4"></CR:CRYSTALREPORTVIEWER>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
