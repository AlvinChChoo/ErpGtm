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
        cmdUpdate.attributes.add("onClick","javascript:if(confirm('Are you sure to update MRP setting ?')==false) return false;")
    
        if not ispostback then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            txtMatProc.text = ReqCOM.GetFieldVal("Select PR_PROCESSING_DAYS from Main","PR_PROCESSING_DAYS")
            txtTPRVar.text = ReqCOM.GetFieldVal("Select TPR_Var_PCTG from Main","TPR_Var_PCTG")
        End if
    End Sub
    
    
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid =  true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Update Main set PR_PROCESSING_DAYS = " & cint(txtMatProc.text) & ",TPR_VAR_PCTG=" & cint(txtTPRVar.text) & ";")
            response.redirect("PurchasingParamSetting.aspx")
        End if
    End Sub
    
    Sub LinkButton2_Click(sender As Object, e As EventArgs)
        Response.redirect("BuyerCode.aspx")
    End Sub
    
    Sub LinkButton1_Click(sender As Object, e As EventArgs)
        Response.redirect("PurchasingParamSetting.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">PURCHASING
                                DEPARTMENT SETTING</asp:Label> 
                                <table style="HEIGHT: 16px" bordercolor="gray" cellspacing="0" cellpadding="0" width="100%" bgcolor="silver" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="50%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton2" onclick="LinkButton2_Click" runat="server" ForeColor="White" Width="100%" CausesValidation="False" Font-Bold="True">BUYER CODE</asp:LinkButton>
                                                </p>
                                            </td>
                                            <td width="50%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton1" onclick="LinkButton1_Click" runat="server" ForeColor="White" Width="100%" CausesValidation="False" Font-Bold="True" BackColor="#FF8080">OTHERS</asp:LinkButton>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="60%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ForeColor=" " Width="100%" ControlToValidate="txtMatProc" EnableClientScript="False" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid P/O Processing (days)" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" ForeColor=" " Width="100%" ControlToValidate="txtMatProc" EnableClientScript="False" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid P/O Processing (days)" CssClass="ErrorText" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server">P/O Processing (days)</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtMatProc" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="40%" bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server">Temp P/R Var %</asp:Label></td>
                                                                <td width="60%">
                                                                    <div align="right">
                                                                        <asp:TextBox id="txtTPRVar" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="101px" Text="Update"></asp:Button>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="101px" Text="Back"></asp:Button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
