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
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            ProcLoadGridData
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
                Case "SALESORDERPART"
                    CrystalReportViewer1.SelectionFormula = "{so_part_m.LOT_NO} = '" & trim(request.params("LotNo")) & "' "
                Case "SALESREPORTMODEL1" : CrystalReportViewer1.SelectionFormula = "{so_model_m.Model_No} >= '" & trim(request.params("ModelFrom")) & "' and {so_model_m.Model_No} <= '" & trim(request.params("ModelTo")) & "' and {so_model_m.so_date} >= #" & trim(request.params("DateFrom")) & "# and {so_model_m.so_date} <= #" & trim(request.params("DateTo")) & "#"
                Case "MRPLOT"
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_RPT.lot_no} = '" & trim(request.params("LotNo")) & "'"
                    RptTitle = "MATERIAL SHORTAGE LIST (Lot No : " & trim(request.params("LotNo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "MRPMODEL"
                    CrystalReportViewer1.SelectionFormula = "{MRP_D_RPT.Model_No} = '" & trim(request.params("ModelNo")) & "'"
                    RptTitle = "MATERIAL SHORTAGE LIST (Model No : " & trim(request.params("ModelNo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                Case "POOUTSTANDING"
                    RptTitle = "(Part Range from " & trim(request.params("PartNoFrom")) & " to " & trim(request.params("PartNoTo")) & ")"
                    crFormulaTextField1.text = "'" & RptTitle & "'"
                    crFormulaTextField2.text = "'" & CompanyName & "'"
                    CrystalReportViewer1.SelectionFormula = "{PART_MASTER.Part_No} >= '" & trim(request.params("PartNoFrom")) & "' and {PART_MASTER.Part_No} <= '" & trim(request.params("PartNoTo")) & "'"
                Case "BOM" : CrystalReportViewer1.SelectionFormula = "{BOM_M.Model_No} = '" & trim(request.params("ModelNo")) & "' and {BOM_M.Revision} = " & request.params("Revision") & ""
                Case "MRPALL"
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
    
    
            End select
            CrystalReportViewer1.ReportSource = repDoc
            CrystalReportViewer1.RefreshReport()
        End sub
    
    
    Sub CrystalReportViewer1_Init(sender As Object, e As EventArgs)
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        Response.redirect("BOMRpt.aspx")
    End Sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
         Sub ProcLoadGridData()
             Dim StrSql as string = "Select * from SSER_ATTACHMENT where SSER_NO = '" & trim(request.params("SSERNo")) & "';"
             Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
             Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SSER_ATTACHMENT")
             dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("SSER_ATTACHMENT").DefaultView
             dtgUPASAttachment.DataBind()
         end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form method="post" runat="server">
        <p>
            <table style="HEIGHT: 33px" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <div><font face="Verdana" size="4"><asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">SSER
                                ATTACHMENT</asp:Label></font>
                            </div>
                            <div>
                                <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False" HeaderStyle-CssClass="CartListHead" ItemStyle-CssClass="CartListItem" AlternatingItemStyle-CssClass="CartListItemAlt" PageSize="50" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged">
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                    <Columns>
                                        <asp:TemplateColumn visible="false">
                                            <ItemTemplate>
                                                <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                        <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadSSERAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                    </Columns>
                                </asp:DataGrid>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p>
                            </p>
                            <p>
                            </p>
                            <div>&nbsp;
                            </div>
                            <div><asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">SSER DETAILS</asp:Label>
                            </div>
                            <div>
                                <CR:CRYSTALREPORTVIEWER id="CrystalReportViewer1" runat="server" pagetotreeratio="4" borderstyle="Dotted" borderwidth="1px" EnableDatabaseLogonPrompt="False" EnableParameterPrompt="False" OnInit="CrystalReportViewer1_Init" HasToggleGroupTreeButton="False" HasCrystalLogo="False" DisplayGroupTree="False" HasSearchButton="False" HasGotoPageButton="False" HasDrillUpButton="False"></CR:CRYSTALREPORTVIEWER>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
