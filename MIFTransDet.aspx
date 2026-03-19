<%@ Page Language="VB" %>
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
            'txtTransDate.text = format(cdate(now),"dd/MM/yy")
        End if
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        Dim TransDate as date
        Dim DtStr as string
    
        DtStr = clng(cmbMonth.selecteditem.value) & "/" & clng(cmbDay.selecteditem.value) & "/" & clng(cmbYear.selecteditem.value)
    
        if isdate(DTStr) = false then
            ShowAlert("You don't seem to have supplied a valid transaction date.")
            exit sub
        End if
    
        TransDate = cdate(DTStr)
    
        'TransDate = txtTransDate.text
        ShowReport("PopupReportViewer.aspx?RptName=DailyMIF&TransDate=" & cdate(DTStr))
        redirectPage("MIFDailyRpt.aspx")
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <font face="Verdana" size="4"> 
            <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p>
                                <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">MIF DAILY TRANSACTION
                                REPORT</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td width="84%" border="0">
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" width="100%">Supplier From</asp:Label></td>
                                                                <td width="70%">
                                                                    <asp:DropDownList id="DropDownList1" runat="server" Width="100%" CssClass="OutputText"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="100%">Supplier To</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="DropDownList2" runat="server" Width="100%" CssClass="OutputText"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="100%">MIF Date From</asp:Label></td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" width="100%">MIF Date To</asp:Label></td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="100%">Transaction Date</asp:Label></td>
                                                                <td width="70%">
                                                                    <asp:DropDownList id="cmbDay" runat="server" Width="71px" CssClass="OutputText">
                                                                        <asp:ListItem Value="1">1</asp:ListItem>
                                                                        <asp:ListItem Value="2">2</asp:ListItem>
                                                                        <asp:ListItem Value="3">3</asp:ListItem>
                                                                        <asp:ListItem Value="4">4</asp:ListItem>
                                                                        <asp:ListItem Value="5">5</asp:ListItem>
                                                                        <asp:ListItem Value="6">6</asp:ListItem>
                                                                        <asp:ListItem Value="7">7</asp:ListItem>
                                                                        <asp:ListItem Value="8">8</asp:ListItem>
                                                                        <asp:ListItem Value="9">9</asp:ListItem>
                                                                        <asp:ListItem Value="10">10</asp:ListItem>
                                                                        <asp:ListItem Value="11">11</asp:ListItem>
                                                                        <asp:ListItem Value="12">12</asp:ListItem>
                                                                        <asp:ListItem Value="13">13</asp:ListItem>
                                                                        <asp:ListItem Value="14">14</asp:ListItem>
                                                                        <asp:ListItem Value="15">15</asp:ListItem>
                                                                        <asp:ListItem Value="16">16</asp:ListItem>
                                                                        <asp:ListItem Value="17">17</asp:ListItem>
                                                                        <asp:ListItem Value="18">18</asp:ListItem>
                                                                        <asp:ListItem Value="19">19</asp:ListItem>
                                                                        <asp:ListItem Value="20">20</asp:ListItem>
                                                                        <asp:ListItem Value="21">21</asp:ListItem>
                                                                        <asp:ListItem Value="22">22</asp:ListItem>
                                                                        <asp:ListItem Value="23">23</asp:ListItem>
                                                                        <asp:ListItem Value="24">24</asp:ListItem>
                                                                        <asp:ListItem Value="25">25</asp:ListItem>
                                                                        <asp:ListItem Value="26">26</asp:ListItem>
                                                                        <asp:ListItem Value="27">27</asp:ListItem>
                                                                        <asp:ListItem Value="28">28</asp:ListItem>
                                                                        <asp:ListItem Value="29">29</asp:ListItem>
                                                                        <asp:ListItem Value="30">30</asp:ListItem>
                                                                        <asp:ListItem Value="31">31</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    &nbsp;/ 
                                                                    <asp:DropDownList id="cmbMonth" runat="server" Width="71px" CssClass="OutputText">
                                                                        <asp:ListItem Value="1">1</asp:ListItem>
                                                                        <asp:ListItem Value="2">2</asp:ListItem>
                                                                        <asp:ListItem Value="3">3</asp:ListItem>
                                                                        <asp:ListItem Value="4">4</asp:ListItem>
                                                                        <asp:ListItem Value="5">5</asp:ListItem>
                                                                        <asp:ListItem Value="6">6</asp:ListItem>
                                                                        <asp:ListItem Value="7">7</asp:ListItem>
                                                                        <asp:ListItem Value="8">8</asp:ListItem>
                                                                        <asp:ListItem Value="9">9</asp:ListItem>
                                                                        <asp:ListItem Value="10">10</asp:ListItem>
                                                                        <asp:ListItem Value="11">11</asp:ListItem>
                                                                        <asp:ListItem Value="12">12</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    &nbsp;/ 
                                                                    <asp:DropDownList id="cmbYear" runat="server" Width="89px" CssClass="OutputText">
                                                                        <asp:ListItem Value="2005">2005</asp:ListItem>
                                                                        <asp:ListItem Value="2006">2006</asp:ListItem>
                                                                        <asp:ListItem Value="2007">2007</asp:ListItem>
                                                                        <asp:ListItem Value="2008">2008</asp:ListItem>
                                                                        <asp:ListItem Value="2009">2009</asp:ListItem>
                                                                        <asp:ListItem Value="2010">2010</asp:ListItem>
                                                                        <asp:ListItem Value="2011">2011</asp:ListItem>
                                                                        <asp:ListItem Value="2012">2012</asp:ListItem>
                                                                        <asp:ListItem Value="2013">2013</asp:ListItem>
                                                                        <asp:ListItem Value="2014">2014</asp:ListItem>
                                                                        <asp:ListItem Value="2015">2015</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 17px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="117px" Text="View Report"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="117px" Text="Back"></asp:Button>
                                                                    </div>
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
                        </td>
                    </tr>
                </tbody>
            </table>
            </font><font face="Verdana" size="4"></font>
        </p>
    </form>
</body>
</html>
