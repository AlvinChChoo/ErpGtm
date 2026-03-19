<%@ Page Language="VB" %>
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
            if page.isPostBack = false then
                Dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust order by Cust_Code asc","Cust_Code","Cust_Code",cmbCustCodeFrom)
                Dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust order by Cust_Code asc","Cust_Code","Cust_Code",cmbCustCodeTo)
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
                Report.Load(Mappath("") + "\" + "CustomerListing.rpt")
                For i = 0 To report.Database.Tables.Count - 1
                    logOnInfo.ConnectionInfo.ServerName = "ws-alvin"
                    logOnInfo.ConnectionInfo.DatabaseName = "DTF"
                    logOnInfo.ConnectionInfo.UserID = "alvin"
                    logOnInfo.ConnectionInfo.Password = "791205"
                    report.Database.Tables.Item(i).ApplyLogOnInfo(logOnInfo)
                Next i
                CrystalReportViewer1.SelectionFormula = "{CUST.CUST_CODE} in '" & trim(cmbCustCodeFrom.selectedItem.value) & "' to '" & trim(cmbCustCodeTo.selectedItem.value) & "'"
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

</script>
<html>
<head>
</head>
<body>
    <form method="post" runat="server">
        <center><font face="Verdana" size="4"> 
            <table style="WIDTH: 600px; HEIGHT: 26px" cellspacing="0" cellpadding="0" width="600" align="left">
                <tbody>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:DropDownList id="cmbCustCodeFrom" runat="server" Width="307px"></asp:DropDownList>
                            <asp:DropDownList id="cmbCustCodeTo" runat="server" Width="307px"></asp:DropDownList>
                            <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="110px" Text="Button"></asp:Button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <center>
                                <CR:CrystalReportViewer id="CrystalReportViewer1" runat="server" HasToggleGroupTreeButton="False" OnInit="CrystalReportViewer1_Init" EnableParameterPrompt="False" EnableDatabaseLogonPrompt="False" borderwidth="1px" borderstyle="Dotted" pagetotreeratio="4" height="50px" width="100%"></CR:CrystalReportViewer>
                            </center>
                        </td>
                    </tr>
                </tbody>
            </table>
            </font>
        </center>
        <center>
            <br />
            &nbsp; 
        </center>
        <center>
        </center>
        <center>
        </center>
    </form>
</body>
</html>
