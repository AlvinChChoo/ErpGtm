<%@ Page Language="VB" Debug="true" %>
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
    if page.ispostback = false then
        if request.cookies("U_ID") is nothing then
            response.redirect("AccessDenied.aspx")
        else
            ProcLoadGridData()
        end if
    End if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        txtSearch.text = ""
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        StrSql = "SELECT so.job_order_qty,so.csd_app_date,so.pcmc_app_date,So.PCMC_APP_BY,CUST.CUST_name,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.ORDER_QTY, SO.MODEL_NO, SO.SEQ_NO FROM SO_MODELS_M SO, cust WHERE SO.LOT_NO LIKE '%" & txtSearch.Text & "%' AND SO.CUST_CODE = CUST.CUST_cODE and SO_STATUS = 'APPROVED' ORDER BY SO.LOT_NO ASC"
    
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SO_MODELS_M")
            GridControl1.DataSource=resExePagedDataSet.Tables("SO_MODELS_M").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub SortGrid(s As Object, e As DataGridSortCommandEventArgs)
        ProcLoadGridData()
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub ShowSO(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim LotNo As Label = CType(e.Item.FindControl("LotNo"), Label)
        Dim SeqNo as integer = ReqCOM.GetFieldVal("Select Seq_No from SO_MODELS_M where LOT_NO = '" & trim(LotNo.text) & "';","Seq_No")
        ReqCOm.ExecuteNonQuery("Truncate table Job_Flow")
        Response.redirect("JobOrderDet.aspx?ID=" & SeqNo)
    End sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderModelAdd.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim SODate As Label = CType(e.Item.FindControl("SODate"), Label)
            SODate.text = format(cdate(SODate.text),"dd/MM/yy")
        End if
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UCcontent" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">SALES
                                ORDER LIST (JOB ORDER CREATION)</asp:Label>
                            </p>
                            <p align="center">
                                <table height="100%" cellspacing="0" cellpadding="0" width="90%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="top" width="100%">
                                                <p align="center">
                                                    <table style="WIDTH: 100%; HEIGHT: 51px" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="WIDTH: 100%; HEIGHT: 7px">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="Label2" runat="server" cssclass="OutputText">Search by Lot No</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                    <asp:TextBox id="txtSearch" runat="server" Width="200px"></asp:TextBox>
                                                                                </td>
                                                                                <td colspan="2">
                                                                                    <div align="right">
                                                                                        <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" Width="78px" Text="GO"></asp:Button>
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
                                                    <table style="HEIGHT: 27px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSortCommand="sortGrid" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" OnEditCommand="ShowSO" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" AllowSorting="True">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View J/O"></asp:EditCommandColumn>
                                                                                <asp:TemplateColumn HeaderText="Lot No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="LotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="S/O Date">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SODate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SO_DATE") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="Cust_Name" HeaderText="Customer Name"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="ORDER_QTY" HeaderText="Lot Qty.">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Job_Order_Qty" HeaderText="J/O Qty">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="MODEL_NO" HeaderText="Model No"></asp:BoundColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="right">
                                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="143px" Text="Back"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
