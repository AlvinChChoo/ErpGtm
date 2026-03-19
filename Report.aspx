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
            'Dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust order by Cust_Code asc","Cust_Code","Cust_Code",cmbCustCode)
            'CrystalReportViewer1.ReportSource =  Mappath("") + "\" + "CustomerListing.rpt"
            'CrystalReportViewer1.RefreshReport()
    
            '// Add namespaces at top.
            'using CrystalDecisions.CrystalReports.Engine;
            'using CrystalDecisions.Shared;
    
            '//Crystal Report Variables
            'Dim crReportDocument as CrystalReport1 = new CrystalReport1()
            'CrystalReport1 crReportDocument = new CrystalReport1();
    
            '//'CrystalReport1' must be the name the CrystalReport
            'TableLogOnInfo crTableLogOnInfo = new TableLogOnInfo();
            'ConnectionInfo crConnectionInfo = new ConnectionInfo();
    
            '//Crystal Report Properties
            'CrystalDecisions.CrystalReports.Engine.Database crDatabase;
            'CrystalDecisions.CrystalReports.Engine.Tables crTables;
            'CrystalDecisions.CrystalReports.Engine.Table crTable;
    
            'crConnectionInfo.ServerName = "EnterServerNameHere"
            'crConnectionInfo.DatabaseName = "EnterDatabaseNameHere"
            'crConnectionInfo.UserID = "EnterUserIDHere"
            'crConnectionInfo.Password = "EnterPasswordHere"
            'crDatabase = crReportDocument.Database
            'crTables = crDatabase.Tables
    
            'foreach(CrystalDecisions.CrystalReports.Engine.Table crTable in crTables)
            '    {
            '    	crTableLogOnInfo = crTable.LogOnInfo;
                  '    crTableLogOnInfo.ConnectionInfo = crConnectionInfo;
                  '    crTable.ApplyLogOnInfo(crTableLogOnInfo);
            '    }
    
            'CrystalReportViewer1.ReportSource = crReportDocument
    
            'CrystalReportViewer1.SelectionFormula = "{CUST.CUST_CODE} = '" & trim(cmbCustCode.selectedItem.value) & "'"
            CrystalReportViewer1.ReportSource =  Mappath("") + "\" + "CustomerListing.rpt"
            CrystalReportViewer1.RefreshReport()
    
        End if
    End Sub
    
    Sub GetReport()
    
    
    
    
    
    
        'logonInfo = rpt.Database.Tables[0].LogOnInfo;
        'logonInfo.ConnectionInfo.ServerName = "g";
        'logonInfo.ConnectionInfo.DatabaseName = "accounts";
        'logonInfo.ConnectionInfo.UserID = "sa";
        'logonInfo.ConnectionInfo.Password = "sa";
        'rpt.Database.Tables[0].ApplyLogOnInfo(logonInfo);
        'CrystalReportViewer1.ReportSource=rpt;
    
        'Dim ViewerBase1 as CrystalReportViewerBase
        'CrystalReportViewer1.LogOnInfo "ws_alvin","DTF","alvin","791205"
        'Dim crpReport as
        'Dim crptTable as Database.Tables.Item(1)
        'crptTable.SetLogonInfo "ws_alvin","DTF","alvin","791205"
    
        'CrystalReportViewer1.SelectionFormula = "{CUST.CUST_CODE} = 'GT001'"
        '"{Mkt_Cross_Board_M.Cross_Brd_Id} = '" & Trim(cboCrossBrdId.Text) & "'"
    
        'CrystalReportViewer1.ReportSource =  Mappath("") + "\" + "CustomerListing.rpt"
        'CrystalReportViewer1.RefreshReport()
    End sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
    
    
    
    
    
        CrystalReportViewer1.SelectionFormula = "{CUST.CUST_CODE} = '" & trim(cmbCustCode.selectedItem.value) & "'"
        CrystalReportViewer1.ReportSource =  Mappath("") + "\" + "CustomerListing.rpt"
        CrystalReportViewer1.RefreshReport()
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
            'Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            'Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
            'with obj
            '    .items.clear
            '    .DataSource = ResExeDataReader
            '    .DataValueField = trim(FValue)
            '    .DataTextField = trim(FText)
            '    .DataBind()
            'end with
            'ResExeDataReader.close()
    End Sub

</script>
<html xmlns:crystalreports="xmlns:crystalreports">
<head>
</head>
<body>
    <form method="post" runat="server">
        <center><font face="Verdana" size="4"> 
            <table style="WIDTH: 600px; HEIGHT: 26px" cellspacing="0" cellpadding="0" width="600" align="left">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:DropDownList id="cmbCustCode" runat="server" Width="307px"></asp:DropDownList>
                            <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="110px" Text="Button"></asp:Button>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <center>
                                <cr:CrystalReportViewer id="CrystalReportViewer1" runat="server" width="350px" height="50px" pagetotreeratio="4" displaygrouptree="false" displaytoolbar="false"></cr:CrystalReportViewer>
                                &nbsp; 
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
