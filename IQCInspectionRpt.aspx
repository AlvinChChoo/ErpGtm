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
    
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim StartDate,EndDate as datetime
            Dim Status as string
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            StartDate = ReqCOM.FormatDate(txtDateFrom.text)
            EndDate = ReqCOM.FormatDate(txtDateTo.text)
            Status = trim(cmbPartStatus.selecteditem.value)
            ShowReport("PopupReportViewer.aspx?RptName=IQCInspectionRpt&Status=" & trim(Status) & "&DateFrom=" & cdate(StartDate) & "&DateTo=" & cdate(EndDate) & "&PartType=" & trim(cmbPartType.selecteditem.value) & "&IQCResult=" & trim(cmbPartStatus.selecteditem.value))
        End if
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if reqCom.IsDate(txtDateFrom.text) = false then
            e.isvalid = false
            ValDateInput.ErrorMessage = "You don't seem to have supplied a valid Start Date."
            Exit Sub
        end if
    
        if reqCom.IsDate(txtDateTo.text) = false then
            e.isvalid = false
            ValDateInput.ErrorMessage = "You don't seem to have supplied a valid End Date."
            Exit Sub
        end if
    End Sub

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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" backcolor="" forecolor="">IQC
                                INSPECTION REPORT</asp:Label>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="ValDateInput" runat="server" CssClass="ErrorText" Width="100%" OnServerValidate="ValDateInput_ServerValidate" EnableClientScript="False" ErrorMessage="" Display="Dynamic" ForeColor=" "></asp:CustomValidator>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="50%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                </div>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="40%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Date From(dd/mm/yy)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtDateFrom" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Date To(dd/mm/yy)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtDateTo" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Part Type</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbPartType" runat="server" CssClass="OutputText" Width="100%">
                                                                        <asp:ListItem Value="GENERAL">GENERAL</asp:ListItem>
                                                                        <asp:ListItem Value="PACKING">PACKING</asp:ListItem>
                                                                        <asp:ListItem Value="PLASTIC">PLASTIC</asp:ListItem>
                                                                        <asp:ListItem Value="ELECTRONIC">ELECTRONIC</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Part Status</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbPartStatus" runat="server" CssClass="OutputText" Width="100%">
                                                                        <asp:ListItem Value="ACC">ACCEPT</asp:ListItem>
                                                                        <asp:ListItem Value="REJ">REJECT</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" CssClass="OutputText" Width="97px" Text="View Report"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="97px" Text="Back"></asp:Button>
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
