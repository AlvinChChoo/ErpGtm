<%@ Page Language="VB" %>
<%@ Register TagPrefix="IBuySpy" TagName="Menu" Src="_Menu.ascx" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if request.cookies("U_ID") is nothing then response.redirect("AccessDenied.aspx")
    End Sub
    
    Sub cmbAdd_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub Menu1_Load(sender As Object, e As EventArgs)
    End Sub
    
    Sub UserControl2_Load(sender As Object, e As EventArgs)
    End Sub
    
    Sub TextBox1_TextChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdList_Click(sender As Object, e As EventArgs)
        response.redirect("Currency.aspx")
    End Sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim StrSql as string
    
        StrSQL = "Insert into Curr"
        StrSql = StrSql + "(Curr_Code,Curr_Desc,UNIT_CONV,RATE,US_DLR,CREATE_BY,CREATE_DATE)"
        StrSql = StrSql + "sELECT '" & txtCurrCode.text & "',"
        StrSql = StrSql + "'" & txtCurrDesc.text & "',"
        StrSql = StrSql + "" & txtUnitConv.text & ","
        StrSql = StrSql + "" & txtRate.text & ","
        StrSql = StrSql + "" & txtUsDlr.text & ","
        StrSql = StrSql + "'" & trim(request.cookies("U_ID").value) & "',"
        StrSql = StrSql + "'" & Now & "'"
        ReqCOM.ExecuteNonQuery(StrSQL)
        response.redirect("Currency.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 648px" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr valign="top">
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <p>
                                <IBuySpy:Menu id="UserControl1" runat="server" OnLoad="Menu1_Load"></IBuySpy:Menu>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                        </td>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p>
                            </p>
                            <p>
                            </p>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" forecolor="White" backcolor="Olive" font-bold="True">NEW
                                UNIT OR MEASUREMENT REGISTRATION</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 12px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 114px" width="100%">
                                                    <tbody>
                                                        <tr valign="top">
                                                            <td>
                                                                Currency Code</td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtCurrCode" runat="server" Font-Size="XX-Small" width="300px"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Description</td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtCurrDesc" runat="server" Font-Size="XX-Small" Width="300px" Columns="30" MaxLength="30"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Unit Conversion</td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtUnitConv" runat="server" Font-Size="XX-Small" Width="300px"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Rate</td>
                                                            <td>
                                                                <p align="center">
                                                                    <asp:TextBox id="txtRate" runat="server" Font-Size="XX-Small" Width="300px"></asp:TextBox>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                US Dollar</td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtUSDlr" runat="server" Font-Size="XX-Small" Width="300px"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Created By</td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtCreateBy" runat="server" Width="300px" OnTextChanged="TextBox1_TextChanged"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Created Date</td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtCreateDate" runat="server" Width="300px"></asp:TextBox>
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
                            <p>
                                <asp:comparevalidator id="valUSDlrCurr" runat="server" ErrorMessage="'US Dollar' must be an integer value." ControlToValidate="txtUSDlr" Display="Dynamic" Type="Double" Operator="DataTypeCheck"></asp:comparevalidator>
                            </p>
                            <p>
                                <asp:comparevalidator id="valRateCurr" runat="server" ErrorMessage="'Rate' must be an integer value." ControlToValidate="txtRate" Display="Dynamic" Type="Double" Operator="DataTypeCheck"></asp:comparevalidator>
                            </p>
                            <p>
                                <asp:comparevalidator id="ValUnitConvCurr" runat="server" ErrorMessage="'Unit Conversion' must be an integer value." ControlToValidate="txtUnitConv" Display="Dynamic" Type="Double" Operator="DataTypeCheck"></asp:comparevalidator>
                            </p>
                            <p>
                                <asp:RequiredFieldValidator id="ValUsDlr" runat="server" Font-Size="9pt" ErrorMessage="'US Dollar' must not be left blank." ControlToValidate="txtUSDlr" Display="Dynamic" Font-Name="verdana"></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <asp:RequiredFieldValidator id="ValRate" runat="server" Font-Size="9pt" ErrorMessage="'Rate' must not be left blank." ControlToValidate="txtRate" Display="Dynamic" Font-Name="verdana"></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <asp:RequiredFieldValidator id="valUnitConv" runat="server" Font-Size="9pt" ErrorMessage="'Unit conversion' must not be left blank." ControlToValidate="txtUnitConv" Display="Dynamic" Font-Name="verdana"></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <asp:RequiredFieldValidator id="valCurrDesc" runat="server" Font-Size="9pt" ErrorMessage="'Currency Description' must not be left blank." ControlToValidate="txtCurrDesc" Display="Dynamic" Font-Name="verdana"></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <asp:RequiredFieldValidator id="ValCurrCode" runat="server" Font-Size="9pt" ErrorMessage="'Currency Code' must not be left blank." ControlToValidate="txtCurrCode" Display="Dynamic" Font-Name="verdana"></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Update Changes"></asp:Button>
                                &nbsp;&nbsp;&nbsp;&nbsp; 
                                <asp:Button id="cmdList" onclick="cmdList_Click" runat="server" Width="126px" Text="Currency List" CausesValidation="False"></asp:Button>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <td>
        </td>
    </form>
    <!-- Insert content here -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="Label1" runat="server">Label</asp:Label>
</body>
</html>
