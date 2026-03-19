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
        if request.cookies("U_ID") is nothing then
            response.redirect("AccessDenied.aspx")
        else
            procLoadGridData()
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        procLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        'Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        'Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SO_PART_M")
        'GridControl1.DataSource=resExePagedDataSet.Tables("SO_PART_M").DefaultView
        'GridControl1.DataBind()
    
    
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
        'if trim(ucase(lblUserRole.text)) = "CSD" then
            'StrSql = "SELECT SO.PO_NO,So.PCMC_APP_BY,CUST.CUST_name,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.ORDER_QTY, SO.SEQ_NO FROM SO_Part_M SO, cust WHERE SO.LOT_NO LIKE '%" & txtSearch.Text & "%' AND SO.CUST_CODE = CUST.CUST_cODE  ORDER BY SO.LOT_NO ASC"
            'StrSql = "SELECT SO.PO_NO,So.PCMC_APP_BY,CUST.CUST_name,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.SEQ_NO FROM SO_Part_M SO, cust WHERE SO.LOT_NO LIKE '%" & txtSearch.Text & "%' AND SO.CUST_CODE = CUST.CUST_cODE  ORDER BY SO.LOT_NO ASC"
            'lblCSD.visible = true
        'elseif trim(ucase(lblUserRole.text)) = "PCMC" then
            StrSql = "SELECT SO.PO_NO,So.APP2_By,CUST.CUST_name,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.SEQ_NO FROM SO_Part_M SO, cust WHERE SO.LOT_NO LIKE '%" & txtSearch.Text & "%' AND SO.CUST_CODE = CUST.CUST_cODE and SO.CSD_APP_BY Is not null ORDER BY SO.LOT_NO ASC"
    
        'else
        '    response.redirect("UnauthorisedUser.aspx")
        'End if
    
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SO_Part_M")
            GridControl1.DataSource=resExePagedDataSet.Tables("SO_Part_M").DefaultView
            GridControl1.DataBind()
        End if
    
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        procLoadGridData()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
    '    Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    '    If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
    '        E.Item.Cells(2).Text = format(cdate(e.Item.Cells(2).Text),"MM/dd/yy")
    '        Dim AppBy As Label = CType(e.Item.FindControl("AppBy"), Label)
    '        if AppBy.text = "" then e.Item.CssClass = "PartSource"
    '    End if
    
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(2).Text = format(cdate(e.Item.Cells(2).Text),"MM/dd/yy")
            Dim AppBy As Label = CType(e.Item.FindControl("AppBy"), Label)
            Dim App2By As Label = CType(e.Item.FindControl("App2By"), Label)
    
            'if trim(ucase(lblUserRole.text)) = "CSD" then
            '    if AppBy.text = "" then e.Item.CssClass = "PartSource"
            'elseif trim(ucase(lblUserRole.text)) = "PCMC" then
                if App2By.text = "" then e.Item.CssClass = "PartSource"
            'End if
        End if
    
    End Sub
    
    Sub ShowSO(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim LotNo As Label = CType(e.Item.FindControl("LotNo"), Label)
        Dim SeqNo as integer = ReqCOM.GetFieldVal("Select Seq_No from SO_Part_M where LOT_NO = '" & trim(LotNo.text) & "';","Seq_No")
    
        'if trim(ucase(lblUserRole.text)) = "CSD" then
        '    Response.redirect("SalesOrderPartDet.aspx?ID=" & SeqNo)
        'elseif trim(ucase(lblUserRole.text)) = "PCMC" then
            Response.redirect("SalesOrderPartsDetPCMC.aspx?ID=" & SeqNo)
        'else
        '    response.redirect("UnauthorisedUser.aspx")
        'End if
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

</script>
<html xmlns:erp= "xmlns:erp">
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">SALES
                                ORDER LIST - By Part</asp:Label>
                            </p>
                            <p align="center">
                                <table height="100%" cellspacing="0" cellpadding="0" width="90%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="top" width="100%">
                                                <p>
                                                    <table style="WIDTH: 100%; HEIGHT: 51px" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="WIDTH: 100%; HEIGHT: 7px">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="132px">Search
                                                                                    by Lot No</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                    <asp:TextBox id="txtSearch" runat="server" Width="275px"></asp:TextBox>
                                                                                </td>
                                                                                <td colspan="3">
                                                                                    <div align="right">
                                                                                        <div align="right">
                                                                                            <asp:Button id="GO" onclick="Button1_Click" runat="server" Width="60px" Text="GO" CausesValidation="False"></asp:Button>
                                                                                        </div>
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
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" OnEditCommand="ShowSO" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager" OnItemDataBound="FormatRow" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                                                <asp:TemplateColumn HeaderText="Lot No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="LOTNO" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "LOT_NO") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="SO_DATE" HeaderText="S/O Date" DataFormatString="{0:d}"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="CUST_CODE" HeaderText="Customer Code"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PO_NO" HeaderText="P/O NO"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="CSD App">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="AppBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CSD_APP_BY") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="PCMC App">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> 
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
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        &nbsp;
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="117px" Text="Back"></asp:Button>
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
