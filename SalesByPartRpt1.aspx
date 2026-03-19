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
            if page.ispostback = false then ShowReport
        End Sub
    
        Sub ShowReport()
            Dim RptType as string = trim(Request.params("RptType"))
            Dim RptnAME as string = TRIM(rEQUEST.PARAMS("RptName"))
    
            Dim repDoc As New ReportDocument()
            repDoc.Load(Mappath("") + "\" & trim(RptName) & ".rpt")
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
    
            select case ucase(RptType)
                Case "PART" : CrystalReportViewer1.SelectionFormula = "{so_part_d.part_no} >= '" & trim(request.params("PartFrom")) & "' and {so_part_d.part_no} <= '" & trim(request.params("PartTo")) & "' and {so_part_m.so_date} >= #" & cdate(request.params("DateFrom")) & "# and {so_part_m.so_date} <= #" & cdate(request.params("DateTo")) & "#"
                Case "CUST" : CrystalReportViewer1.SelectionFormula = "{so_part_d.cust_code} >= '" & trim(request.params("CustFrom")) & "' and {so_part_d.cust_code} <= '" & trim(request.params("CustTo")) & "' and {so_part_m.so_date} >= #" & cdate(request.params("DateFrom")) & "# and {so_part_m.so_date} <= #" & cdate(request.params("DateTo")) & "#"
                Case "DATE" : CrystalReportViewer1.SelectionFormula = "{so_part_m.so_date} >= #" & cdate(request.params("DateFrom")) & "# and {so_part_m.so_date} <= #" & cdate(request.params("DateTo")) & "#"
            End select
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
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" size="4"> 
            <table style="HEIGHT: 38px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="3">
                            <p>
                                <a class="ErrorText" href="javascript: history.go(-1)"><font color="red"><strong>&lt;&lt;
                                Back &gt;&gt;</strong></font></a><font color="red"><strong> </strong></font>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <p>
                                <CR:CrystalReportViewer id="CrystalReportViewer1" runat="server" width="100%" height="50px" pagetotreeratio="4" borderstyle="Dotted" borderwidth="1px" EnableDatabaseLogonPrompt="False" EnableParameterPrompt="False" OnInit="CrystalReportViewer1_Init" HasToggleGroupTreeButton="False" HasCrystalLogo="False" DisplayGroupTree="False"></CR:CrystalReportViewer>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
            </font>
        </p>
    </form>
</body>
</html>
