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
    
        'if cmbSearch.selecteditem.value = "UPA_NO" then
        '    StrSql = "SELECT * FROM UPAS_M WHERE UPAS_No LIKE '%" & txtSearch.Text & "%' ORDER BY Seq_no desc"
        'elseif cmbSearch.selecteditem.value = "PART_NO" then
        '    StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO in (Select UPAS_NO from UPAS_D where Part_No like '%" & trim(txtSearch.text) & "%') ORDER BY Seq_no desc"
        'elseif cmbSearch.selecteditem.value = "SUBMIT_BY" then
        '    StrSql = "SELECT * FROM UPAS_M WHERE SUBMIT_BY LIKE '%" & TRIM(txtSearch.text) & "%' ORDER BY Seq_no desc"
        'elseif cmbSearch.selecteditem.value = "VEN_CODE" then
        '    StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO in (SELECT UPAS_NO FROM UPAS_D WHERE VEN_CODE IN(Select VEN_CODE from VENDOR where VEN_CODE + VEN_NAME like '%" & trim(txtSearch.text) & "%')) ORDER BY Seq_no desc"
        'end if
    
        StrSql = "Select * from Sales_Forecast where model_No like '%" & trim(txtSearch.text) & "%' order by forecast_date desc"
    
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"CUST")
    
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
            Dim Amt As Label = CType(e.Item.FindControl("Amt"), Label)
    
            UP.text = format(cdec(UP.text),"##,##0.0000")
            Amt.text = format(cdec(UP.text),"##,##0.00")
    
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
    
    Sub cmbSearch_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub LinkButton1_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesForecast.aspx")
    End Sub
    
    
    Sub LinkButton4_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesForecastEdit.aspx")
    End Sub
    
    Sub LinkButton5_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesForecast1.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
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
                                <table style="HEIGHT: 16px" bordercolor="gray" cellspacing="0" cellpadding="0" width="100%" bgcolor="silver" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="33%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton1" onclick="LinkButton1_Click" runat="server" Width="100%" ForeColor="White" Font-Bold="True" CausesValidation="False">VIEW FORECAST</asp:LinkButton>
                                                </p>
                                            </td>
                                            <td width="34%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton4" onclick="LinkButton4_Click" runat="server" Width="100%" ForeColor="WhiteSmoke" Font-Bold="True" CausesValidation="False">EDIT FORECAST</asp:LinkButton>
                                                </p>
                                            </td>
                                            <td width="33%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton5" onclick="LinkButton5_Click" runat="server" Width="100%" ForeColor="White" Font-Bold="True" CausesValidation="False" BackColor="#FF8080">VIEW FORECAST</asp:LinkButton>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="Label3" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp; 
                                                    <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="177px"></asp:TextBox>
                                                    &nbsp;&nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp; 
                                                    <asp:DropDownList id="cmbSearch" runat="server" CssClass="OutputText" Width="143px" OnSelectedIndexChanged="cmbSearch_SelectedIndexChanged">
                                                        <asp:ListItem Value="Model_No">Model No</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;&nbsp;&nbsp;<asp:Button id="Button3" onclick="Button3_Click" runat="server" CssClass="OutputText" Width="117px" Text="GO"></asp:Button>
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
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="10" OnPageIndexChanged="OurPager" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" ShowFooter="True" AutoGenerateColumns="False" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:HyperLinkColumn visible="false" Text="View" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="UnitPriceApprovalSheetDet.aspx?ID={0}"></asp:HyperLinkColumn>
                                                            <asp:TemplateColumn HeaderText="SEQ #">
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
                                                            <asp:TemplateColumn HeaderText="Forecast Qty">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ForecastQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Forecast_Qty") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="U/P">
                                                                <ItemTemplate>
                                                                    <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Amt">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Amt" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Amt") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
