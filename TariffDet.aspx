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
        IF page.ispostback=false then LoadData
    End Sub

    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        Dim strSql as string
        Dim reqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        StrSql = "Update Tariff set Tariff_Desc = '" & trim(txtTariffDesc.text) & "',Modify_By = '" & trim(request.cookies("U_ID").value) & "', Modify_Date = '" & now & "' where Tariff_Code = '" & trim(lblTariffCode.text) & "';"
        ReqCOM.ExecuteNonQuery(StrSql)
        loadData
    End Sub

    sub LoadData
        Dim strSql as string = "Select * from Tariff where Seq_No = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)

        do while ResExeDataReader.read
            lblTariffCode.text = ResExeDataReader("Tariff_Code")
            txtTariffDesc.text = ResExeDataReader("Tariff_Desc")
            lblCurrBal.text =format(ResExeDataReader("Curr_Bal"),"##,##0.0000")
            lblBalCF.text = format(ResExeDataReader("Bal_CF"),"##,##0.0000")

            lblCreateBy.text = ResExeDataReader("Create_By").ToString
            if isdbnull(ResExeDataReader("Create_Date")) = false then lblCreateDate.text = ResExeDataReader("Create_Date").toShortDateString
            lblModifyBy.text = ResExeDataReader("Modify_By").ToString
            if isdbnull(ResExeDataReader("Modify_Date"))=false then lblModifyDate.text = ResExeDataReader("Modify_Date").toShortDateString
        loop
    End sub

    Sub Menu1_Load(sender As Object, e As EventArgs)

    End Sub

    Sub UserControl2_Load(sender As Object, e As EventArgs)
    End Sub

    Sub lnkList_Click(sender As Object, e As EventArgs)
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
            <table style="WIDTH: 913px; HEIGHT: 540px" height="100%" cellspacing="0" cellpadding="0" width="913" border="0">
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
                                <table style="WIDTH: 517px; HEIGHT: 21px">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="WIDTH: 651px; HEIGHT: 250px" align="left" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="2">
                                                                <p align="center">
                                                                    TARIFF DETAILS
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Tariff Code</td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblTariffCode" runat="server" width="300px" font-names="Verdana" font-size="X-Small"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Tariff Description&nbsp;&nbsp;&nbsp;
                                                            </td>
                                                            <td>
                                                                <div align="left">
                                                                    <asp:TextBox id="txtTariffDesc" runat="server" Width="300px" MaxLength="30" Columns="30" Font-Size="X-Small" Font-Names="Verdana"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Current Balance</td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblCurrBal" runat="server" width="300px" font-names="Verdana" font-size="X-Small"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Balance C/F</td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblBalCF" runat="server" width="300px" font-names="Verdana" font-size="X-Small"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Created By</td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblCreateBy" runat="server" width="300px" font-names="Verdana" font-size="X-Small"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Created Date</td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblCreateDate" runat="server" width="300px" font-names="Verdana" font-size="X-Small"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Modified By</td>
                                                            <td>
                                                                <div align="left"><asp:Label id="lblModifyBy" runat="server" width="300px" font-names="Verdana" font-size="X-Small"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                Modified Date</td>
                                                            <td>
                                                                <div align="center">
                                                                    <div align="left"><asp:Label id="lblModifyDate" runat="server" width="300px" font-names="Verdana" font-size="X-Small"></asp:Label>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
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
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <asp:RequiredFieldValidator id="ValTariffDesc" runat="server" Font-Size="9pt" Font-Name="verdana" Display="Dynamic" ControlToValidate="txtTariffDesc" ErrorMessage="'Tariff Description' must not be left blank."></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Update Changes"></asp:Button>
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
