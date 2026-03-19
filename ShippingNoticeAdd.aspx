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
        if ispostback = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dissql ("Select Cust_Code,Cust_Name from Cust order by cust_name asc","Cust_Code","Cust_Name",cmbCustCode)
        end if
    End Sub

    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim StrSql as string
            Dim SNNo as string = ReqCOM.GetDocumentNo("Ship_Notice_No")
            sTRsQL = "Insert into Ship_Notice_m(SN_No,shipment_date,REM,MODE_OF_DEL,MODE_OF_FREIGHT,CUST_CODE) select '" & trim(SNNo) & "','" & cdate(txtShipDate.text) & "','" & trim(replace(txtRem.text,"'","`")) & "','" & trim(cmbModeOfDel.selecteditem.value) & "','" & trim(cmbModeOfFreight.selecteditem.value) & "','" & trim(cmbCustCode.selecteditem.value) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)

            Response.redirect("ShippingNoticeDet.aspx?ID=" & ReqCOm.GetFieldVal("Select Seq_No from Ship_Notice_M where sn_nO = '" & trim(SNNo) & "';","Seq_No"))
        end if
    End Sub

    Sub cmbProdtype_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Model.aspx")
    End Sub

    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)

        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = FValue
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
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
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">NEW SHIPPING
                                NOTICE REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" width="116px" cssclass="LabelNormal" height="0px">Customer</asp:Label>&nbsp;&nbsp;</td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:DropDownList id="cmbCustCode" runat="server" Width="382px" CssClass="OutputText"></asp:DropDownList>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" width="116px" cssclass="LabelNormal">Shipping
                                                                Date</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:TextBox id="txtShipDate" runat="server" Width="382px" CssClass="OutputText"></asp:TextBox>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" width="116px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtRem" runat="server" Width="382px" CssClass="OutputText" Height="60px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" width="116px" cssclass="LabelNormal">Mode Of
                                                                Delivery</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbModeOfDel" runat="server" Width="382px" CssClass="OutputText">
                                                                    <asp:ListItem Value="TRACK">TRACK</asp:ListItem>
                                                                    <asp:ListItem Value="AIR FREIGHT">AIR FREIGHT</asp:ListItem>
                                                                    <asp:ListItem Value="CONTAINER 40FT">CONTAINER 40FT</asp:ListItem>
                                                                    <asp:ListItem Value="CONTAINER 20FT">CONTAINER 20FT</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" width="116px" cssclass="LabelNormal">Mode Of
                                                                Freight</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:DropDownList id="cmbModeOfFreight" runat="server" Width="382px" CssClass="OutputText">
                                                                        <asp:ListItem Value="PREPAID">PREPAID</asp:ListItem>
                                                                        <asp:ListItem Value="COLLECT">COLLECT</asp:ListItem>
                                                                        <asp:ListItem Value="OTHERS">OTHERS</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="Server" Width="115px" Text="Add New" autopostback="true"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="113px" Text="Back" CausesValidation="False"></asp:Button>
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
