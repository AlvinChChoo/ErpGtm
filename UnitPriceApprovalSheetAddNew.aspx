<%@ Page Language="VB" Debug="true" %>
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
        if page.ispostback = false then
            lblCreateBy.text = trim(request.cookies("U_ID").value)
            lblCreateDate.text = now.toshortDateString
        end if
    
    
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim UPANo as string = reqCOM.GetDocumentNo("UPA_No")
        Dim StrSql as string
    
        StrSql = "Insert into UPAS_M(UPAS_No,Rem,Inv_Cost,Create_By) "
        StrSql = StrSql + "Select '" & trim(UPANo) & "',"
        StrSql = StrSql + "'" & trim(txtRem.text) & "','" & trim(cmbType.selecteditem.value) & "',"
        StrSql = StrSql + "'" & trim(request.cookies("U_ID").value) & "'"
        ReqCOM.ExecuteNonQuery(StrSql)
        ReqCOM.ExecuteNonQuery ("Update Main set UPA_No = UPA_No + 1")
        Response.redirect("UnitPriceApprovalSheetDet.aspx?ID=" + ReqCOM.GetFieldVal("Select Seq_No from UPAS_M where UPAS_No = '" & trim(UPaNo) & "';","Seq_No"))
    
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
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">NEW UNIT PRICE
                                APPROVAL SHEET REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 90%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="90%" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="">Remarks</asp:Label></td>
                                            <td>
                                                <div align="left">
                                                    <asp:TextBox id="txtRem" runat="server" Width="471px" CssClass="OutputText"></asp:TextBox>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="">UPA Type :</asp:Label></td>
                                            <td>
                                                <asp:DropDownList id="cmbType" runat="server" Width="398px" CssClass="OutputText">
                                                    <asp:ListItem Value="Y">Involving Costing</asp:ListItem>
                                                    <asp:ListItem Value="N">Not Involving Costing</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <div align="left"><asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="">Prepared
                                                    By </asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="">Date Prepared</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblCreateDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="130px" Text="Save"></asp:Button>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
