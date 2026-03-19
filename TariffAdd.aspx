<%@ Page Language="VB" %>

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

    Sub Menu1_Load(sender As Object, e As EventArgs)
    End Sub

    Sub UserControl2_Load(sender As Object, e As EventArgs)
    End Sub


    Sub Button1_Click(sender As Object, e As EventArgs)

    End Sub

    Sub txtAdd_Click(sender As Object, e As EventArgs)
        LBLeRROR.TEXT = ""
        Dim ReqCom as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim strSql as string
        If ReqCom.GetFieldVal("Select Tariff_Code from Tariff where Tariff_Code = '" & trim(txtTariffCode.text) & "';","Tariff_Code") <> "" then lblError.text = "'Tariff Code' already exist.":Exit sub
        If ReqCom.GetFieldVal("Select Tariff_Desc from Tariff where Tariff_Desc = '" & trim(txtTariffDesc.text) & "';","Tariff_Desc") <> "" then lblError.text = "'Tariff Description' already exist.":Exit sub

        StrSql = "Insert into Tariff (Tariff_Code,Tariff_Desc,Create_By,Create_Date) "
        StrSql = StrSql + "Select '" & (txtTariffCode.text) & "','" & trim(txtTariffDesc.text) & "',"
        StrSql = StrSql + "'" & trim(request.cookies("U_ID").value) & "','" & now & "';"

        ReqCOM.ExecuteNonQuery(StrsQL)
        response.redirect("Tariff.aspx")
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
            <table style="HEIGHT: 497px" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
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
                        <td>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                                <table style="HEIGHT: 17px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                Tariff&nbsp;Code</td>
                                                            <td>
                                                                <asp:TextBox id="txtTariffCode" runat="server" Width="258px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Tariff&nbsp;Description</td>
                                                            <td>
                                                                <asp:TextBox id="txtTariffDesc" runat="server" Width="258px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Created By</td>
                                                            <td>
                                                                <asp:TextBox id="txtCreateBy" runat="server" Width="258px" Enabled="False"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Created&nbsp;Date</td>
                                                            <td>
                                                                <asp:TextBox id="txtCreateDate" runat="server" Width="258px" Enabled="False"></asp:TextBox>
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
                                <asp:Label id="lblError" runat="server" forecolor="Red" width="360px"></asp:Label>
                            </p>
                            <p>
                                <asp:RequiredFieldValidator id="valTariffCode" runat="server" Font-Size="9pt" Font-Name="verdana" Display="Dynamic" ControlToValidate="txtTariffCode" ErrorMessage="'Tariff Code' must not be left blank."></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <asp:RequiredFieldValidator id="ValTariffDesc" runat="server" Font-Size="9pt" Font-Name="verdana" Display="Dynamic" ControlToValidate="txtTariffDesc" ErrorMessage="'Tariff Description' must not be left blank."></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <asp:Button id="txtAdd" onclick="txtAdd_Click" runat="server" Width="166px" Text="Add New Tariff"></asp:Button>
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
                    </tr>
                </tbody>
            </table>
        </p>
        <span id="span1" runat="server"></span>
        <p>
        </p>
        <p>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </p>
        <p>
        </p>
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
