<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
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
            if page.isPostBack = false then
                Dissql ("Select Approval_No from PR_Approval order by Approval_Date","Approval_No","Approval_No",cmbApprovalNo)
            End if
            ShowReport()
        End Sub
    
        Sub Button1_Click(sender As Object, e As EventArgs)
            ShowReport()
        End Sub
    
        Sub ShowReport()
            Dim logOnInfo As New TableLogOnInfo()
                Dim i As Integer
                Dim Report as New ReportDocument()
                Report.Load(Mappath("") + "\" + "PRApprovalSheet.rpt")
                For i = 0 To report.Database.Tables.Count - 1
    
                    '(ConfigurationSettings.AppSettings("ConnectionString"))
    
                    logOnInfo.ConnectionInfo.ServerName = (ConfigurationSettings.AppSettings("ServerName"))
                    logOnInfo.ConnectionInfo.DatabaseName = (ConfigurationSettings.AppSettings("DatabaseName"))
                    logOnInfo.ConnectionInfo.UserID = (ConfigurationSettings.AppSettings("UserID"))
                    logOnInfo.ConnectionInfo.Password = (ConfigurationSettings.AppSettings("Password"))
                    report.Database.Tables.Item(i).ApplyLogOnInfo(logOnInfo)
                Next i
                CrystalReportViewer1.SelectionFormula = "{PR_Approval.Approval_No} = " & trim(cmbApprovalNo.selectedItem.value) & ";"
                CrystalReportViewer1.ReportSource = Report
                CrystalReportViewer1.RefreshReport()
        End sub
    
         SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
                 Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                 Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
                 with obj
                     .items.clear
                     .DataSource = ResExeDataReader
                     .DataValueField = trim(FValue)
                     .DataTextField = trim(FText)
                     .DataBind()
                 end with
                 ResExeDataReader.close()
         End Sub
    
    Sub CrystalReportViewer1_Init(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmbApprovalNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim RsPR as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR_Approval where Approval_No = " & cmbApprovalNo.selectedItem.text & ";")
        Do while RsPR.read
            lblApprovalDate.text = format(cdate(RsPR("Approval_Date")),"MM/dd/yy")
            if isdbnull(RsPR("Approved_Date")) = false then lblApprovedDate.text = format(cdate(RsPR("Approved_Date")),"MM/dd/yy")
        loop
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" size="4"></font>
        </p>
        <p>
            <table style="HEIGHT: 27px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">PR APPROVAL
                                SHEET</asp:Label>
                            </p>
                            <p>
                                &nbsp; 
                                <table style="HEIGHT: 24px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="WIDTH: 237px; HEIGHT: 68px" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label2" runat="server" width="217px" cssclass="LabelNormal">Approval
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbApprovalNo" runat="server" autopostback="true" OnSelectedIndexChanged="cmbApprovalNo_SelectedIndexChanged" Width="412px"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label5" runat="server" width="217px" cssclass="LabelNormal">Submission
                                                                Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApprovalDate" runat="server" width="412px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label8" runat="server" width="217px" cssclass="LabelNormal">Date Approved</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApprovedDate" runat="server" width="412px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:Button id="cmdGO" onclick="Button1_Click" runat="server" Width="110px" Text="GO"></asp:Button>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 14px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <center>
                                                    <CR:CrystalReportViewer id="CrystalReportViewer1" runat="server" width="100%" height="50px" pagetotreeratio="4" borderstyle="Dotted" borderwidth="1px" EnableDatabaseLogonPrompt="False" EnableParameterPrompt="False" OnInit="CrystalReportViewer1_Init" HasToggleGroupTreeButton="False" DisplayGroupTree="False"></CR:CrystalReportViewer>
                                                </center>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
