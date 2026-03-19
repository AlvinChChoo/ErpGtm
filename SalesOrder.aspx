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
                Dissql ("Select Lot_No from SO_Model_M order by SO_Date asc","Lot_No","Lot_No",cmbSONo)
                ShowReport()
            End if
        End Sub
    
        Sub Button1_Click(sender As Object, e As EventArgs)
            ShowReport()
        End Sub
    
        Sub ShowReport()
            Dim logOnInfo As New TableLogOnInfo()
            Dim i As Integer
            Dim Report as New ReportDocument()
    
            Report.Load(Mappath("") + "\" + "SalesOrderModel.rpt")
            For i = 0 To report.Database.Tables.Count - 1
                logOnInfo.ConnectionInfo.ServerName = "ws-alvin"
                logOnInfo.ConnectionInfo.DatabaseName = "DTF"
                logOnInfo.ConnectionInfo.UserID = "alvin"
                logOnInfo.ConnectionInfo.Password = "791205"
                report.Database.Tables.Item(i).ApplyLogOnInfo(logOnInfo)
            Next i
    
            CrystalReportViewer1.SelectionFormula = "{SO_MODEL_M.LOT_NO} = '" & trim(cmbSONo.selectedItem.value) & "';"
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
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form method="post" runat="server">
        <font face="Verdana" size="4"> 
        <table style="HEIGHT: 21px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;<asp:Label id="LotNo" runat="server" width="112px" cssclass="LabelNormal">Lot
                        No : </asp:Label>&nbsp; 
                        <asp:DropDownList id="cmbSONo" runat="server" Width="307px"></asp:DropDownList>
                        &nbsp;&nbsp;&nbsp; 
                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="110px" Text="GO"></asp:Button>
                    </td>
                </tr>
                <tr>
                    <td>
                        <center>
                            <CR:CrystalReportViewer id="CrystalReportViewer1" runat="server" width="100%" height="50px" pagetotreeratio="4" borderstyle="Dotted" borderwidth="1px" EnableDatabaseLogonPrompt="False" EnableParameterPrompt="False" OnInit="CrystalReportViewer1_Init" HasToggleGroupTreeButton="False" HasCrystalLogo="False" DisplayGroupTree="False"></CR:CrystalReportViewer>
                        </center>
                    </td>
                </tr>
            </tbody>
        </table>
        </font>
    </form>
</body>
</html>