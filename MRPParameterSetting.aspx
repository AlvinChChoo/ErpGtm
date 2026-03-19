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
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if not ispostback then txtMatProc.text = ReqCOM.GetFieldVal("Select PR_PROCESSING_DAYS from Main","PR_PROCESSING_DAYS")
    End Sub
    
    
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid =  true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Update Main set PR_PROCESSING_DAYS = " & cint(txtMatProc.text) & ";")
            response.redirect("MRPParameterSetting.aspx")
        End if
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
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">MRP PARAMETER
                                SETTING</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtMatProc" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Material Processing Days" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" ControlToValidate="txtMatProc" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Material Processing Days" Width="100%" CssClass="ErrorText" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server">Material Processing (days)</asp:Label></td>
                                                                <td>
                                                                    <div align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:TextBox id="txtMatProc" runat="server" Width="54px" CssClass="OutputText"></asp:TextBox>
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
                                                                <p>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="101px" Text="Update"></asp:Button>
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="101px" Text="Cancel"></asp:Button>
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
