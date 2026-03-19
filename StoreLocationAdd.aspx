<%@ Page Language="VB" %>
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
        end if
    End Sub
    
    
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            ReqCOM.ExecuteNonQuery("Insert into LOC(LOC_CODE) select '" & trim(txtLOC.text) & "';")
            response.redirect("StoreLocationCon.aspx")
        end if
    End Sub
    
    
    
    Sub ValDuplicateLoc(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select LOC_Code from LOC where LOC_CODE = '" & trim(txtLOC.text) & "';","LOC_CODE") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    
    
    Sub cmdNo_Click(sender As Object, e As EventArgs)
        response.redirect("StoreLocation.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">STORE
                                LOCATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" CssClass="ErrorText" Display="Dynamic" ControlToValidate="txtLOC" OnServerValidate="ValDuplicateLoc" ForeColor=" ">
                                    'Store Location' already exist.
                                </asp:CustomValidator>
                                                </p>
                                                <p align="center">
                                                    <asp:RequiredFieldValidator id="valLoc" runat="server" CssClass="ErrorText" Display="Dynamic" ControlToValidate="txtLOC" ForeColor=" " ErrorMessage="'Store Location' must not be left blank."></asp:RequiredFieldValidator>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 14px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center"><asp:Label id="Label2" runat="server" cssclass="OutputText">Store
                                                                        Location</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:TextBox id="txtLOC" runat="server" CssClass="OutputText" Width="242px" MaxLength="100"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label3" runat="server" cssclass="Instruction">Are you sure to add the
                                                    above location ?</asp:Label>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 15px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Width="53px" Text="Yes"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    <asp:Button id="cmdNo" onclick="cmdNo_Click" runat="server" Width="53px" Text="No"></asp:Button>
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