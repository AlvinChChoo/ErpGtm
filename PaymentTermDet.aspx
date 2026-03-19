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
        if page.ispostback=false then LoadData
    End Sub

    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
    '    Dim ReqExecuteNonQuery as Erp_Gtm.Erp_Gtm = New Erp_Gtm.Erp_Gtm
    '    ReqExecuteNonQuery.ExecuteNonQuery("Update PayTerm set no_Of_days = " & cint(txtNoOfDays.text) & ", Modify_By = '" & trim(request.cookies("U_ID").value) & "' where Seq_No = '" & trim(txtID.text) & "';")
    '    LoadData
        Dim ReqPaytermUpdate as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        ReqPayTermUpdate.PaytermUpdate(cint(txtNoOfDays.text),trim(request.cookies("U_ID").value),cint(txtID.text))
        LoadData
    End Sub

    Sub LoadData
        Dim strSql as string = "SELECT * FROM PAYTERM WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)

        txtID.text = request.params("ID")
        do while ResExeDataReader.read
            txtDesc.text = ResExeDataReader("PAYTERM_DESC").tostring
            txtnoOfDays.text = ResExeDataReader("NO_OF_DAYS")
            txtCreatedby.text = ResExeDataReader("CREATE_BY").tostring
            if isdbnull(ResExeDataReader("CREATE_DATE")) = false then
                txtCreatedDate.text = format(ResExeDataReader("CREATE_DATE"),"dd/MM/yyyy")
            end if


            txtModifiedBy.text = ResExeDataReader("MODIFY_BY").tostring

            if isdbnull(ResExeDataReader("MODIFY_DATE")) = false then
                txtModifiedDate.text = format(ResExeDataReader("MODIFY_DATE"),"dd/MM/yyyy")
            end if
        loop
    end sub

    Sub TextBox3_TextChanged(sender As Object, e As EventArgs)

    End Sub

    Sub Menu1_Load(sender As Object, e As EventArgs)

    End Sub

    Sub UserControl2_Load(sender As Object, e As EventArgs)

    End Sub

    Sub lnkList_Click(sender As Object, e As EventArgs)
        response.redirect("PaymentTerm.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
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
                            &nbsp;
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
                        <p>
                        </p>
                        <p>
                        </p>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" width="100%" font-bold="True" forecolor="White" backcolor="Olive">PAYMENT
                            TERM DETAILS</asp:Label>
                        </p>
                        <p>
                            <table style="HEIGHT: 52px" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td>
                                            ID</td>
                                        <td>
                                            <asp:TextBox id="txtID" runat="server" Font-Size="XX-Small" Enabled="False" Width="181px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Description&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </td>
                                        <td>
                                            <div align="left">
                                                <asp:TextBox id="txtDesc" runat="server" Font-Size="XX-Small" Enabled="False" Width="181px"></asp:TextBox>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            No of Days</td>
                                        <td>
                                            <div align="left">
                                                <asp:TextBox id="txtNoOfDays" runat="server" Font-Size="XX-Small" Width="181px" MaxLength="30" Columns="30"></asp:TextBox>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Created By</td>
                                        <td>
                                            <asp:TextBox id="txtCreatedBy" runat="server" Font-Size="XX-Small" Enabled="False" Width="181px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Created Date</td>
                                        <td>
                                            <asp:TextBox id="txtCreatedDate" runat="server" Font-Size="XX-Small" Enabled="False" Width="181px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Modified By</td>
                                        <td>
                                            <asp:TextBox id="txtModifiedBy" runat="server" Font-Size="XX-Small" Enabled="False" Width="181px" OnTextChanged="TextBox3_TextChanged"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Modified Date</td>
                                        <td>
                                            <div align="left">
                                                <asp:TextBox id="txtModifiedDate" runat="server" Font-Size="XX-Small" Enabled="False" Width="181px"></asp:TextBox>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <asp:comparevalidator id="ValNoOfDaysFormat" runat="server" Font-Size="X-Small" Width="492px" Operator="DataTypeCheck" Type="Integer" Font-Names="Verdana" Display="Dynamic" ControlToValidate="txtnoOfDays" ErrorMessage="'No Of Days' must be an integer value."></asp:comparevalidator>
                        </p>
                        <div align="left">
                            <asp:RequiredFieldValidator id="ValNoOfDays" runat="server" Font-Size="X-Small" Font-Names="verdana" Display="Dynamic" ControlToValidate="txtNoOfDays" ErrorMessage="'No Of Days' must not be left blank." Font-Name="verdana"></asp:RequiredFieldValidator>
                        </div>
                        <div align="left">
                        </div>
                        <div align="left">
                        </div>
                        <div align="left">
                        </div>
                        <div align="left">
                        </div>
                        <div align="left">
                            <asp:RequiredFieldValidator id="ValDesc" runat="server" Font-Size="X-Small" Font-Names="verdana" Display="Dynamic" ControlToValidate="txtDesc" ErrorMessage="'Payment Term Description' must not be left blank." Font-Name="verdana"></asp:RequiredFieldValidator>
                        </div>
                        <p>
                            <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Update Changes"></asp:Button>
                        </p>
                        <p>
                            <asp:LinkButton id="lnkList" onclick="lnkList_Click" runat="server" Width="227px">Show Payment Term List</asp:LinkButton>
                        </p>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
    <!-- Insert content here -->
</body>
</html>
