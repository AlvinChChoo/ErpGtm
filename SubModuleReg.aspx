<%@ Page Language="VB" %>

<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            procLoadGridData ("SELECT * FROM MOD_REG_D ORDER BY MOD_DESC ASC")
        end if
    End Sub

    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData("SELECT * FROM MOD_REG_D ORDER BY MOD_DESC ASC")
    end sub

    Sub ProcLoadGridData(StrSql as string)
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"MOD_REG_D")
        GridControl1.DataSource=resExePagedDataSet.Tables("MOD_REG_D").DefaultView
        GridControl1.DataBind()
    end sub

    Sub Button1_Click(sender As Object, e As EventArgs)
    End Sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub Button2_Click(sender As Object, e As EventArgs)
    End Sub

    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        'response.redirect("CustomerAddNew.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 497px" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <p>
                                &nbsp;
                            </p>
                        </td>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label1" runat="server" font-bold="True" backcolor="Olive" forecolor="White" width="100%">MODULE
                                REGISTRATION </asp:Label>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 20px" width="100%" align="center" border="1">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" ShowFooter="True" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" OnPageIndexChanged="OurPager" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Height="210px">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:HyperLinkColumn Text="View" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="CustomerDet.aspx?ID={0}"></asp:HyperLinkColumn>
                                                            <asp:BoundColumn DataField="MAIN_MOD" HeaderText="MAIN MODULE"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MOD_DESC" HeaderText="SUB MODULE"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MOD_MANE" HeaderText="FILE NAME"></asp:BoundColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="173px" Text="Add New Customer"></asp:Button>
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
