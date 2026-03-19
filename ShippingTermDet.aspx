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

        if request.cookies("U_ID") is nothing then
            response.redirect("AccessDenied.aspx")
        else
            Dim OurCommand as sqlcommand
            Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            procLoadGridData ("SELECT * FROM SHIPTERM")
            lblMaxRec.text = cint(ReqGetFieldVal.GetFieldVal("Select Grid_Max_Rec from Main","Grid_Max_Rec"))
        end if
    End Sub

    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData("SELECT * FROM SHIPTERM WHERE SHIPTERM_DESC like '%" & cstr(txtSearch.Text) & "%'  ORDER BY SHIPTERM_DESC ASC")
    end sub

    Sub ProcLoadGridData(StrSql as string)
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SHIPTERM")
        GridControl1.DataSource=resExePagedDataSet.Tables("SHIPTERM").DefaultView
        GridControl1.DataBind()
    end sub

    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        if isnumeric(txtNoOfRec.text) = false then  txtNoOfRec.text = lblMaxRec.text
        if txtNoOfRec.text = "" then txtNoOfRec.text = lblMaxRec.text
        if txtNoOfRec.text > cint(lblMaxRec.text) then  txtNoOfRec.text = lblMaxRec.text
        if txtNoOfRec.text < 1 then  txtNoOfRec.text = lblMaxRec.text
        gridcontrol1.PageSize= txtNoOfRec.text
        ProcLoadGridData("SELECT * FROM PAYTERM WHERE SHIPTERM_DESC like '%" & cstr(txtSearch.Text) & "%'  ORDER BY SHIPTERM_DESC ASC")
    End Sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub

    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub

    Sub Menu1_Load(sender As Object, e As EventArgs)

    End Sub

    Sub UserControl2_Load(sender As Object, e As EventArgs)

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
            <table height="100%" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <table height="100%" width="100%" bgcolor="white">
                                <tbody>
                                    <tr>
                                        <td valign="top">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                        <td valign="top">
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                                <table style="HEIGHT: 25px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p align="center">
                                                    <asp:Label id="Label1" runat="server" width="100%" font-bold="True" backcolor="Olive" forecolor="White">SHIPPING
                                                    TERM LIST</asp:Label>
                                                </p>
                                                <p>
                                                    <table style="WIDTH: 100%; HEIGHT: 51px" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="WIDTH: 100%; HEIGHT: 7px">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td colspan="3">
                                                                                    <font face="Verdana" size="1">Search&nbsp;:&nbsp;<asp:TextBox id="txtSearch" runat="server" Width="222px" Font-Names="Verdana" Font-Size="XX-Small"></asp:TextBox>
                                                                                    &nbsp;By&nbsp;<strong>Description</strong>
                                                                                    <div align="right">
                                                                                    </div>
                                                                                    </font></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <table style="WIDTH: 100%; HEIGHT: 19px">
                                                                        <tbody>
                                                                            <tr valign="top">
                                                                                <td>
                                                                                    <font size="1">No of&nbsp; Records to display&nbsp;&nbsp;<asp:TextBox id="txtNoOfRec" runat="server" Width="63px" Font-Names="Verdana" Font-Size="XX-Small"></asp:TextBox>
                                                                                    &nbsp;(Max&nbsp;<asp:Label id="lblMaxRec" runat="server" font-names="Verdana" font-size="XX-Small"></asp:Label></font><font size="1">&nbsp;records)</font></td>
                                                                                <td valign="top" colspan="2">
                                                                                    <div align="left">
                                                                                    </div>
                                                                                    <div align="right">
                                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" CausesValidation="False" Text="GO"></asp:Button>
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
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 25px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    &nbsp;<asp:DataGrid id="GridControl1" runat="server" width="100%" Font-Names="Verdana" Font-Size="XX-Small" Height="216px" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" OnPageIndexChanged="OurPager" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" ShowFooter="True" AutoGenerateColumns="False">
                                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                        <Columns>
                                                                            <asp:HyperLinkColumn DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="ShippingTermDet.aspx?ID={0}" Text="View" HeaderText=""></asp:HyperLinkColumn>
                                                                            <asp:BoundColumn DataField="SHIPTERM_DESC" HeaderText="Description"></asp:BoundColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
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
                            <asp:Button id="cmdAddNew" runat="server" Width="173px" Text="New Shipping Term"></asp:Button>
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
