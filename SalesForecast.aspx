<%@ Page Language="VB" Debug="true" %>
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
        if page.isPostBack = false then procLoadGridData ()
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string
        'StrSql = "select SF.FORECAST_TYPE,sf.seq_no,sf.up*curr.rate/curr.unit_conv as [base_curr], sf.curr_Code,sf.Ref_No,sf.Model_No,sf.Forecast_Date,sf.Forecast_Qty,sf.UP from sales_Forecast sf,Curr curr where sf.curr_Code = curr.curr_code and sf.model_No like '%" & trim(txtSearch.text) & "%'"
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("select SF.FORECAST_TYPE,sf.seq_no,sf.up*curr.rate/curr.unit_conv as [base_curr], sf.curr_Code,sf.Ref_No,sf.Model_No,sf.Forecast_Date,sf.Forecast_Qty,sf.UP from sales_Forecast sf,Curr curr where sf.curr_Code = curr.curr_code and sf.model_No like '%" & trim(txtSearch.text) & "%'","CUST")
        GridControl1.DataSource=resExePagedDataSet.Tables("CUST").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub Button3_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ForecastDate As Label = CType(e.Item.FindControl("ForecastDate"), Label)
            Dim UP As Label = CType(e.Item.FindControl("UP"), Label)
            Dim ForecastQty As Label = CType(e.Item.FindControl("ForecastQty"), Label)
            Dim BaseCurr As Label = CType(e.Item.FindControl("BaseCurr"), Label)
            Dim Amt As Label = CType(e.Item.FindControl("Amt"), Label)
    
            UP.text = format(cdec(UP.text),"##,##0.0000")
            BaseCurr.text = format(cdec(BaseCurr.text),"##,##0.0000")
            amt.text = format(cdec(BaseCurr.text) * cdec(ForecastQty.text),"##,##0.00")
    
            select case month(cdate(ForecastDate.text))
                case 1 : ForecastDate.text = "Jan, " & year(cdate(ForecastDate.text))
                case 2 : ForecastDate.text = "Feb, " & year(cdate(ForecastDate.text))
                case 3 : ForecastDate.text = "Mar, " & year(cdate(ForecastDate.text))
                case 4 : ForecastDate.text = "Apr, " & year(cdate(ForecastDate.text))
                case 5 : ForecastDate.text = "May, " & year(cdate(ForecastDate.text))
                case 6 : ForecastDate.text = "June, " & year(cdate(ForecastDate.text))
                case 7 : ForecastDate.text = "July, " & year(cdate(ForecastDate.text))
                case 8 : ForecastDate.text = "Aug, " & year(cdate(ForecastDate.text))
                case 9 : ForecastDate.text = "Sep, " & year(cdate(ForecastDate.text))
                case 10 : ForecastDate.text = "Oct, " & year(cdate(ForecastDate.text))
                case 11 : ForecastDate.text = "Nov, " & year(cdate(ForecastDate.text))
                case 12 : ForecastDate.text = "Dec, " & year(cdate(ForecastDate.text))
            end select
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect ("Default.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">SALES FORECAST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="Label3" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp; 
                                                    <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="177px"></asp:TextBox>
                                                    &nbsp;&nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp; 
                                                    <asp:DropDownList id="cmbSearch" runat="server" CssClass="OutputText" Width="143px">
                                                        <asp:ListItem Value="Model_No">Model No</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;&nbsp;&nbsp;<asp:Button id="Button3" onclick="Button3_Click" runat="server" CssClass="OutputText" Width="80px" Text="GO"></asp:Button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="94%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" OnPageIndexChanged="OurPager" AllowPaging="True" BorderColor="Gray" cellpadding="4" Font-Name="Verdana" ShowFooter="True" AutoGenerateColumns="False" OnItemDataBound="FormatRow" Font-Names="Verdana">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:HyperLinkColumn Visible="False" Text="View" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="UnitPriceApprovalSheetDet.aspx?ID={0}"></asp:HyperLinkColumn>
                                                            <asp:TemplateColumn HeaderText="Forecast #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="RefNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ref_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MODEL #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModelNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Forecast Month">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ForecastDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Forecast_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Type">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ForecastType" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Forecast_Type") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Forecast Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="ForecastQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Forecast_Qty") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="U/P">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="U/P (RM)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="BaseCurr" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Base_Curr") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Amt(RM)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="Amt" runat="server" text='' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 25px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="107px" Text="Back"></asp:Button>
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
