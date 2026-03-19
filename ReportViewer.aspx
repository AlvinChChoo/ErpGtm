<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<%@ import Namespace="System.IO" %>
<script runat="server">

    Private repDoc As New ReportDocument()
    
        Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            ShowReport
        End Sub
    
        Sub ShowReport()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim RptnAME as string = TRIM(rEQUEST.PARAMS("RptName"))
    
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
                Case "SALESORDERPART"
                    CrystalReportViewer1.SelectionFormula = "{so_part_m.LOT_NO} = '" & trim(request.params("LotNo")) & "' "
                Case "SALESREPORTMODEL1" : CrystalReportViewer1.SelectionFormula = "{so_model_m.Model_No} >= '" & trim(request.params("ModelFrom")) & "' and {so_model_m.Model_No} <= '" & trim(request.params("ModelTo")) & "' and {so_model_m.so_date} >= #" & trim(request.params("DateFrom")) & "# and {so_model_m.so_date} <= #" & trim(request.params("DateTo")) & "#"
                Case "MRPLOT"
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_Net.lot_no} = '" & trim(request.params("LotNo")) & "' and {MRP_D_Net.Source} = 'P'"
                    RptTitle = "MATERIAL SHORTAGE LIST (Lot No : " & trim(request.params("LotNo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "MRPMODEL"
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_NET.Model_No} = '" & trim(request.params("ModelNo")) & "' and {MRP_D_Net.Source} = 'P'"
                    RptTitle = "MATERIAL SHORTAGE LIST (Model No : " & trim(request.params("ModelNo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "PROBLEMATICLIST"
                Case "POOUTSTANDING"
                    RptTitle = "(Part Range from " & trim(request.params("PartNoFrom")) & " to " & trim(request.params("PartNoTo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{PART_MASTER.Part_No} >= '" & trim(request.params("PartNoFrom")) & "' and {PART_MASTER.Part_No} <= '" & trim(request.params("PartNoTo")) & "'"
                Case "BOM" : CrystalReportViewer1.SelectionFormula = "{BOM_M.Model_No} = '" & trim(request.params("ModelNo")) & "' and {BOM_M.Revision} = " & request.params("Revision") & ""
                Case "MRPALL"
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_Net.Source} = 'P'"
                    RptTitle = "MATERIAL SHORTAGE LIST (LIST ALL PARTS)"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "MRPSUMMARY" :
                    RptTitle = "MATERIAL SHORTAGE SUMMARY"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "PARTSYNOPSIS" :
                    RptTitle = "(Part Range from " & trim(request.params("PartNoFrom")) & " to " & trim(request.params("PartNoTo")) & ")"
                    RptTitle = ""
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{part_master.Bal_Qty} > 0 and {part_master.Part_No} >= '" & trim(request.params("PartNoFrom")) & "' and {part_master.Part_No} <= '" & request.params("PartNoTo") & "';"
                Case "PARTLIST"
                    RptTitle = "(Part Range from " & trim(request.params("PartNoFrom")) & " to " & trim(request.params("PartNoTo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{part_master.Part_No} >= '" & trim(request.params("PartNoFrom")) & "' and {part_master.Part_No} <= '" & request.params("PartNoTo") & "';"
                Case "PARTSWITHOUTSOURCES"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                Case "WHEREUSELIST"
                    RptTitle = "(Part Range from " & trim(request.params("PartNoFrom")) & " to " & trim(request.params("PartNoTo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
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
                Case "PARTPRICEBYSUPPLIER"
                    RptTitle = ""
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{PART_SOURCE.VEN_CODE} >= '" & trim(request.params("SupplierFrom")) & "' and {PART_SOURCE.VEN_CODE} <= '" & request.params("SupplierTo") & "';"
                Case "BOMCOST"
                    RptTitle = "Model No : " & Request.params("ModelNo")
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{BOM_D.Model_No} = '" & trim(request.params("ModelNo")) & "' and {BOM_D.Revision} = " & cdec(request.params("Revision")) & ";"
                Case "SSERREJECTRPT"
                    RptTitle = ""
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{SSER_REJ_RPT.U_ID} = '" & trim(REQUEST.COOKIES("U_ID").VALUE) & "';"
                case "POEXCESSPURCHASE"
                    Dim MRPNo as string
                    Dim MRPDate as date
                    MrpNo = ReqCOM.GetFieldVal("Select top 1 MRP_No from mrp_history_m order by mrp_no desc","MRP_No")
                    MRPDate = format(cdate(ReqCOM.GetFieldVal("Select Top 1 Create_Date from mrp_history_m order by mrp_no desc","Create_Date")),"dd/MMM/yyyy")
                    RptTitle = "MRP No : " & MrpNo & "     MRP Explosion Date : " & MRPDate
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{PO_M.MRP_NO} = " & MRPNo & ";"
                Case "PARTSPENDINGSOURCES"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{part_master.Ind} = 'Y';"
                Case "PARTSPENDINGSSER"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{part_master.Ind} = 'Y';"
                Case "PARTSPENDINGSTDCOST"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{part_master.Ind} = 'Y';"
            End select
            CrystalReportViewer1.ReportSource = repDoc
            CrystalReportViewer1.RefreshReport()
        End sub
    
    Sub CrystalReportViewer1_Init(sender As Object, e As EventArgs)
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        Response.redirect("BOMRpt.aspx")
    End Sub
    
    Sub LinkButton1_Click(sender As Object, e As EventArgs)
        response.redirect(Request.params("ReturnURL"))
    End Sub
    
    Sub Button1_Click_1(sender As Object, e As EventArgs)
        Dim StrExportFile as string = Server.MapPath(".") & "/pdf2.pdf"
        repDoc.ExportOptions.ExportDestinationType = ExportDestinationType.DiskFile
        repDoc.ExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat
    
        Dim objOptions as DiskFileDestinationOptions = New DiskFileDestinationOptions
        objOptions.DiskFilename = strExportFile
        repDoc.ExportOptions.DestinationOptions = objOptions
        repDoc.export()
        objoptions = nothing
        repDoc = nothing
    End Sub

</script>
<html>
<head>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" size="4"> 
            <table style="HEIGHT: 38px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="3">
                            <asp:LinkButton id="LinkButton1" onclick="LinkButton1_Click" runat="server" Width="382px"><< BACK  >></asp:LinkButton>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <p>
                                <CR:CRYSTALREPORTVIEWER id="CrystalReportViewer1" runat="server" HasDrillUpButton="False" HasGotoPageButton="False" HasSearchButton="False" DisplayGroupTree="False" HasCrystalLogo="False" HasToggleGroupTreeButton="False" OnInit="CrystalReportViewer1_Init" EnableParameterPrompt="False" EnableDatabaseLogonPrompt="False" borderwidth="1px" borderstyle="Dotted" pagetotreeratio="4" HasViewList="False"></CR:CRYSTALREPORTVIEWER>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
            </font>
        </p>
        <asp:Button id="Button1" onclick="Button1_Click_1" runat="server" Text="Button" Visible="False"></asp:Button>
    </form>
</body>
</html>