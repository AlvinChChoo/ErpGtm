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
        if page.ispostback = false then ProcLoadGridData()
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        txtSearch.text = ""
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        StrSql = "SELECT so.req_date,datepart(ww,so.req_date) as [WK],so.fol,SO.so_status,so.csd_app_date,so.pcmc_app_date,So.PCMC_APP_BY,CUST.CUST_name,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.ORDER_QTY, SO.MODEL_NO, SO.SEQ_NO FROM SO_MODELS_M SO, cust WHERE " & trim(cmbSearchCol.selecteditem.value) & " LIKE '%" & trim(txtSearch.Text) & "%' and so.so_status like '%" & trim(cmbSOStatus.selecteditem.value) & "%' AND SO.CUST_CODE = CUST.CUST_cODE and SO.CSD_APP_BY Is not null ORDER BY SO.so_date desc"
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SO_MODELS_M")
            GridControl1.DataSource=resExePagedDataSet.Tables("SO_MODELS_M").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim PCMCAppDate As Label = CType(e.Item.FindControl("PCMCAppDate"), Label)
            Dim ReqDate As Label = CType(e.Item.FindControl("ReqDate"), Label)
            Dim CSDAppDate As Label = CType(e.Item.FindControl("CSDAppDate"), Label)
            Dim FOL As Label = CType(e.Item.FindControl("FOL"), Label)
            Dim SODate As Label = CType(e.Item.FindControl("SODate"), Label)
            Dim SOStatus As Label = CType(e.Item.FindControl("SOStatus"), Label)
            Dim WK As Label = CType(e.Item.FindControl("WK"), Label)
    
            if trim(WK.text) <> "" then WK.text = "(" & WK.text & ")"
            if trim(PCMCAppDate.text) <> "" then PCMCAppDate.text = format(cdate(PCMCAppDate.text),"dd/MM/yy")
            if trim(CSDAppDate.text) <> "" then CSDAppDate.text = format(cdate(CSDAppDate.text),"dd/MM/yy")
            if trim(FOL.text) <> "" then FOL.text = format(cdate(FOL.text),"dd/MM/yy")
            if trim(SODate.text) <> "" then SODate.text = format(cdate(SODate.text),"dd/MM/yy")
            if trim(ReqDate.text) <> "" then ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
            if trim(SOStatus.text) = "PENDING APPROVAL" then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub ItemCommandSO(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("SalesOrderModelDetPCMC.aspx?ID=" & clng(SeqNo.text))
    end sub

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
                                ORDER LIST (by Model)</asp:Label>
                            </p>
                            <p align="center">
                                <table height="100%" cellspacing="0" cellpadding="0" width="96%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="top" width="100%">
                                                <p align="center">
                                                    <table style="HEIGHT: 6px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="HEIGHT: 9px" width="100%" align="center">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label2" runat="server" cssclass="OutputText">Search</asp:Label>&nbsp;<asp:TextBox id="txtSearch" runat="server" Width="145px" CssClass="OutputText"></asp:TextBox>
                                                                                            &nbsp;<asp:Label id="Label3" runat="server" cssclass="OutputText">By</asp:Label>&nbsp;<asp:DropDownList id="cmbSearchCol" runat="server" CssClass="OutputText">
                                                                                                <asp:ListItem Value="SO.LOT_NO">Lot No</asp:ListItem>
                                                                                                <asp:ListItem Value="SO.Model_No">Model No</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            <asp:Label id="Label4" runat="server" cssclass="OutputText">SHOW</asp:Label>
                                                                                            <asp:DropDownList id="cmbSOStatus" runat="server" CssClass="OutputText">
                                                                                                <asp:ListItem Value="">ALL</asp:ListItem>
                                                                                                <asp:ListItem Value="PENDING APPROVAL" Selected="True">PENDING APPROVAL</asp:ListItem>
                                                                                                <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                                                                <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                                                                <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            &nbsp;&nbsp; 
                                                                                            <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" Width="116px" CssClass="OutputText" Text="QUICK SEARCH"></asp:Button>
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
                                                <p>
                                                    <table style="HEIGHT: 27px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Gray" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" AllowSorting="True" OnItemCommand="ItemCommandSO">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn>
                                                                                    <ItemTemplate>
                                                                                        <asp:Hyperlink ID="ImgView" ToolTip="View this S/O" imageURL="view.gif" Runat="Server" NavigateUrl= <%#"javascript:SOModelApp=window.open('SalesOrderModelDetPCMC.aspx?id=" + DataBinder.Eval(Container.DataItem,"Seq_No").ToString() + "','SOModelApp','resizable=1,scrollbars=1,height=400');SOModelApp.focus()" %>></asp:Hyperlink>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Lot No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="LotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' /> <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' visible= "false" /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="MODEL_NO" HeaderText="Model No"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Lot Qty.">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="OrderQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ORDER_QTY") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Issued Date">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SODATE" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SO_DATE") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Req. Date(WK)">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ReqDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Date") %>' /><asp:Label id="WK" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "WK") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="CSD App.">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="AppBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CSD_APP_BY") %>' /> - <asp:Label id="CSDAppDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CSD_App_Date") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="PCMC App.">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PCMCAppBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PCMC_APP_BY") %>' /> - <asp:Label id="PCMCAppDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PCMC_APP_Date") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="FOL">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="FOL" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FOL") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Status">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SOStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SO_Status") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
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
