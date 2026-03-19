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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            txtGroup.text = ReqCOM.GetFieldVal("Select Group_Name from Program_Group_M where Seq_No = " & cint(request.params("ID")) & ";","Group_Name")
            txtDesc.text = ReqCOM.GetFieldVal("Select Group_Desc from Program_Group_M where Seq_No = " & cint(request.params("ID")) & ";","Group_Desc")
            txtDisplayName.text = ReqCOM.GetFieldVal("Select Display_Name from Program_Group_M where Seq_No = " & cint(request.params("ID")) & ";","Display_Name")
        end if
    End sub
    
    Sub ValDuplicateGroup(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select group_desc from Program_Group_m where group_desc = '" & trim(txtGroup.text) & "' and Seq_No <> " & cint(request.params("ID")) & ";","group_desc") = True then
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
        response.redirect("ProgramGroup.aspx")
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
    
        StrSql = "Update Program_Group_M set "
        StrSql = StrSql + "Group_Name = '" & trim(txtGroup.text) & "',"
        StrSql = StrSql + "Group_Desc = '" & trim(txtDesc.text) & "',"
        StrSql = StrSql + "Display_Name = '" & trim(txtDisplayName.text) & "'"
        StrSql = StrSql + " where seq_no = " & cint(request.params("ID")) & ";"
    
        ReqCOM.ExecuteNonQuery(StrSql)
        response.redirect("ProgramGroup.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" backcolor="" cssclass="FormDesc">GROUP
                                ACCESS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 113px" cellspacing="0" cellpadding="0" width="70%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="valFeature" runat="server" ControlToValidate="txtGroup" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Program Group." Display="Dynamic" ForeColor=" " Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" CssClass="ErrorText" ErrorMessage="Program Group already exist." Display="Dynamic" ForeColor=" " Width="100%" OnServerValidate="ValDuplicateGroup"></asp:CustomValidator>
                                                </div>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Program Group</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtGroup" runat="server" CssClass="OutputText" Width="359px" MaxLength="20"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Display Name</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtDisplayName" runat="server" CssClass="OutputText" Width="100%" MaxLength="20"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtDesc" runat="server" CssClass="OutputText" Width="100%" MaxLength="50"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" CssClass="OutputText" Width="145px" Text="Update Group Details"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="145px" Text="Back"></asp:Button>
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
