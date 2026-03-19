<%@ Page Language="VB" %>
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
        if page.isPostBack = false then procLoadGridData ()
    End Sub

    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub

    Sub ProcLoadGridData()
        Dim StrSql as string = "SELECT * FROM LOC WHERE LOC_CODE like '%" & cstr(txtSearch.Text) & "%'  ORDER BY LOC_CODE ASC"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"LOC")
        GridControl1.DataSource=resExePagedDataSet.Tables("LOC").DefaultView
        GridControl1.DataBind()
    end sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub Button3_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub

    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Response.redirect("StoreLocationAdd.aspx")
    End Sub

    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQuery("Delete from LOC where Seq_No = " & trim(SeqNo.text) & ";") : response.redirect("StoreLocation.aspx")
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" backcolor="" cssclass="FormDesc">STORE
                                LOCATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="60%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 22px" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <table style="WIDTH: 100%; HEIGHT: 7px">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label id="Label3" runat="server" cssclass="OutputText">Search</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
                                                                                <asp:TextBox id="txtSearch" runat="server" Width="202px" Height="20px" CssClass="OutputText"></asp:TextBox>
                                                                            </td>
                                                                            <td colspan="3">
                                                                                <div align="right">
                                                                                    <asp:Button id="Button3" onclick="Button3_Click" runat="server" Width="109px" CssClass="OutputText" Text="Quick Search"></asp:Button>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Black" GridLines="None" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" OnItemCommand="ItemCommand">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Location">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> <asp:Label id="LOCCODE" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "LOC_CODE") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn>
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgDelete" ToolTip="Delete this item" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="138px" CssClass="OutputText" Text="Add New Location"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="center">
                                                                        &nbsp;
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="138px" CssClass="OutputText" Text="Back"></asp:Button>
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
