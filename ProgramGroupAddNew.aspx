<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    End Sub
    
    
    
    Sub ValDuplicateGroup(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select group_desc from Program_Group_m where group_desc = '" & trim(txtGroup.text) & "';","group_desc") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Dim ReqCom as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if page.isvalid = true then
            ReqCOM.ExecuteNonQuery("Insert into Program_group_m(Group_Name,Group_Desc,Display_Name) select '" & ucase(trim(txtGroup.text)) & "','" & trim(txtDesc.text) & "','" & ucase(trim(txtDisplayName.text)) & "';")
            txtGroup.text = ""
            response.redirect("ProgramGroup.aspx")
        end if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("ProgramGroup.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0" onkeypress="KeyPress()">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" backcolor="" cssclass="FormDesc">NEW
                                PROGRAM GROUP REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 144px" cellspacing="0" cellpadding="0" width="70%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" ErrorMessage="Program Group already exist." OnServerValidate="ValDuplicateGroup" Display="Dynamic" ForeColor=" " CssClass="ErrorText" Width="100%"></asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="valFeature" runat="server" ErrorMessage="You don't seem to have supplied a valid Program Group." Display="Dynamic" ForeColor=" " CssClass="ErrorText" Width="100%" ControlToValidate="txtGroup"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label8" runat="server" width="150px" cssclass="LabelNormal">Program
                                                                        Group</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:TextBox id="txtGroup" runat="server" CssClass="OutputText" Width="100%" MaxLength="20"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label3" runat="server" width="150px" cssclass="LabelNormal">Display
                                                                        Name </asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:TextBox id="txtDisplayName" runat="server" CssClass="OutputText" Width="100%" MaxLength="20"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label2" runat="server" width="150px" cssclass="LabelNormal">Description </asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:TextBox id="txtDesc" runat="server" CssClass="OutputText" Width="100%" MaxLength="50"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="right">
                                                    <table style="HEIGHT: 16px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Width="149px" Text="Save as New Group"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="133px" Text="Back" CausesValidation="False"></asp:Button>
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
        </p>
    </form>
</body>
</html>
