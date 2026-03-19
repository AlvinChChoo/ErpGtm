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
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine.ReportDocument" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            UpdateRptTable()
            ShowReport("PartsWithoutSources.rpt")
        End Sub
    
        Sub UpdateRptTable()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Update Part_Master set Parts_without_source = 'N'")
            ReqCOM.ExecuteNonQuery("Update Part_master set Parts_without_source = 'Y' where part_no not in(select part_no from part_source)")
        End sub
    
        Sub ShowReport(ReportName as string)
            Dim repDoc As New ReportDocument()
            repDoc.Load(Mappath("") + "\" + ReportName )
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
    
        'CrystalReportViewer1.SelectionFormula = "{FECN_M.FECN_NO} = '" & trim(cmbFECNNo.selecteditem.value) & "';"
        CrystalReportViewer1.ReportSource = repDoc
        CrystalReportViewer1.RefreshReport()
    End sub
    
        Sub CrystalReportViewer1_Init(sender As Object, e As EventArgs)
        End Sub

</script>
<html>
<head>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form method="post" runat="server">
        <font face="Verdana" size="4"> 
        <table style="HEIGHT: 21px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <a class="ErrorText" href="javascript: history.go(-1)"><font color="red"><strong>&lt;&lt;
                        Back &gt;&gt;</strong></font></a><font color="red"><strong> </strong></font></td>
                </tr>
                <tr>
                    <td>
                        <center>
                            <CR:CrystalReportViewer id="CrystalReportViewer1" runat="server" width="100%" DisplayGroupTree="False" HasCrystalLogo="False" HasToggleGroupTreeButton="False" OnInit="CrystalReportViewer1_Init" EnableParameterPrompt="False" EnableDatabaseLogonPrompt="False" borderwidth="1px" borderstyle="Dotted" pagetotreeratio="4" height="50px"></CR:CrystalReportViewer>
                        </center>
                    </td>
                </tr>
            </tbody>
        </table>
        </font>
    </form>
</body>
</html>
