<%@ Page Language="VB" Debug="TRUE" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then
            rbPartNo.Attributes.Add("onclick", "checkedChange();")
            rbPONo.Attributes.Add("onclick", "checkedChange();")
        End if
    End Sub
    
    Sub cmdFinish_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        if rbPartNo.checked = true then ShowPopup("PopupReportviewer.aspx?RptName=POOutstandingByPartNo&PartFrom=" & trim(txtPartFrom.text) & "&PartTo=" & trim(txtPartTo.text))
        if rbpono.checked = true then ShowPopup("PopupReportviewer.aspx?RptName=POOutstandingByPONo&POFrom=" & trim(txtPOFrom.text) & "&POTo=" & trim(txtPOTo.text))
    End Sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

</script>
<html>
<head>
    <link href="CSS.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <script language="javascript">

function getObj(name)
    {
        if (document.getElementById) // test if browser supports document.getElementById
            {
                this.obj = document.getElementById(name);
                this.style = document.getElementById(name).style;
            }
        else if (document.all) // test if browser supports document.all
            {
                this.obj = document.all[name];
                this.style = document.all[name].style;
            }
        else if (document.layers) // test if browser supports document.layers
            {
                this.obj = document.layers[name];
                this.style = document.layers[name].style;
            }
    }

function checkedChange()
    {
        var rbPartNo = new getObj('rbPartNo');
        var rbOthers = new getObj('rbPONo');
        var txtPartFrom = new getObj('txtPartFrom');
        var txtPartTo = new getObj('txtPartTo');
        var txtPOFrom = new getObj('txtPOFrom');
        var txtPOTo = new getObj('txtPOTo');

        if (rbPartNo.obj.checked == true)
            {
                txtPartFrom.obj.disabled = false;
                txtPartTo.obj.disabled = false;
                txtPOFrom.obj.value = "";
                txtPOTo.obj.value = "";
                txtPOFrom.obj.disabled = true;
                txtPOTo.obj.disabled = true;
            }
        else if (rbOthers.obj.checked == true)
            {
                txtPartFrom.obj.disabled = true;
                txtPartTo.obj.disabled = true;
                txtPartFrom.obj.value = "";
                txtPartTo.obj.value = "";
                txtPOFrom.obj.disabled = false;
                txtPOTo.obj.disabled = false;
            }
    }
</script>
    <form runat="server">
        <p align="center">
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="434">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    P/O Outstanding</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <br />
                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="90%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="30%" bgcolor="silver">
                                                                                    <asp:RadioButton id="rbPartNo" runat="server" CssClass="OutputText" Text="By Part No" GroupName="Type" Checked="True"></asp:RadioButton>
                                                                                </td>
                                                                                <td>
                                                                                    <asp:TextBox id="txtPartFrom" runat="server" CssClass="input_box" Width="118px"></asp:TextBox>
                                                                                    &nbsp;<asp:Label id="Label1" runat="server" cssclass="OutputText">to</asp:Label>&nbsp;<asp:TextBox id="txtPartTo" runat="server" CssClass="input_box" Width="118px"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:RadioButton id="rbPONo" runat="server" CssClass="OutputText" Text="By P/O No" GroupName="Type"></asp:RadioButton>
                                                                                </td>
                                                                                <td>
                                                                                    <asp:TextBox id="txtPOFrom" runat="server" CssClass="input_box" Width="118px" Enabled="False"></asp:TextBox>
                                                                                    &nbsp;<asp:Label id="Label2" runat="server" cssclass="OutputText">to</asp:Label>&nbsp;<asp:TextBox id="txtPOTo" runat="server" CssClass="input_box" Width="118px" Enabled="False"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <br />
                                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="50%">
                                                                                    <p>
                                                                                        <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" CssClass="submit_button" Text="View Report" Width="117px"></asp:Button>
                                                                                    </p>
                                                                                </td>
                                                                                <td width="50%">
                                                                                    <p align="right">
                                                                                        <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" CssClass="submit_button" Text="Back" Width="117px"></asp:Button>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <br />
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </p>
                                <p>
                                </p>
                                <p>
                                </p>
                                <p>
                                    <Footer:Footer id="Footer" runat="server"></Footer:Footer>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
