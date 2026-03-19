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

    Sub Button1_Click(sender As Object, e As EventArgs)
        if chkRptType.checked = true then ShowReport("PopupReportViewer.aspx?RptName=MIFTRANSRPT&ColName=" & trim(cmbSearch.selecteditem.value) & "&ColValue=" & trim(txtSearch.text) & "&MIFStatus=" & trim(cmbMIFStatus.selecteditem.value))
        if chkRptType.checked = false then ShowReport("PopupReportViewer.aspx?RptName=MIFTRANSRPTMain&ColName=" & trim(cmbSearch.selecteditem.value) & "&ColValue=" & trim(txtSearch.text) & "&MIFStatus=" & trim(cmbMIFStatus.selecteditem.value))
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" size="4"> 
            <table style="HEIGHT: 38px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="3">
                            <font color="red"><strong>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                            </strong></font></td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" backcolor="" forecolor="">MIF
                                TRANSACTION REPORT</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="40%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="OutputText">SEARCH</asp:Label></td>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="OutputText">By</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbSearch" runat="server" CssClass="OutputText" Width="100%">
                                                                        <asp:ListItem Value="MIF_NO">MIF NO</asp:ListItem>
                                                                        <asp:ListItem Value="DO_NO">D/O NO</asp:ListItem>
                                                                        <asp:ListItem Value="INV_NO">INVOICE NO</asp:ListItem>
                                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                                        <asp:ListItem Value="VEN_CODE">SUPPLEIR CODE</asp:ListItem>
                                                                        <asp:ListItem Value="VEN_NAME">SUPPLEIR NAME</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="OutputText">MIF Status</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbMIFStatus" runat="server" CssClass="OutputText" Width="100%">
                                                                        <asp:ListItem Value="">ALL</asp:ListItem>
                                                                        <asp:ListItem Value="PENDING APPROVAL">PENDING APPROVAL</asp:ListItem>
                                                                        <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                                        <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                                        <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:CheckBox id="chkRptType" runat="server" CssClass="OutputText" Width="100%" Text="Show Details Transactions"></asp:CheckBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" CssClass="OutputText" Width="94px" Text="View Report"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="94px" Text="Back"></asp:Button>
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
            </font>
        </p>
    </form>
</body>
</html>
