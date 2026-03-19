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
        if page.isPostBack = false then
            procLoadGridData ()
        end if
    End Sub
    
    Property SortField() As String
                 Get
                     Dim o As Object = ViewState("SortField")
                     If o Is Nothing Then
                         Return [String].Empty
                     End If
                     Return CStr(o)
                 End Get
                 Set(ByVal Value As String)
                     If Value = SortField Then
                         SortAscending = Not SortAscending
                     End If
                     ViewState("SortField") = Value
                 End Set
             End Property
    
             Property SortAscending() As Boolean
                 Get
                     Dim o As Object = ViewState("SortAscending")
    
                     If o Is Nothing Then
                         Return True
                     End If
                     Return CBool(o)
                 End Get
                 Set(ByVal Value As Boolean)
                     ViewState("SortAscending") = Value
                 End Set
             End Property
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim SubmitBy As Label = CType(e.Item.FindControl("SubmitBy"), Label)
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim VerifyBy As Label = CType(e.Item.FindControl("VerifyBy"), Label)
            Dim VerifyDate As Label = CType(e.Item.FindControl("VerifyDate"), Label)
            Dim ReviewBy As Label = CType(e.Item.FindControl("ReviewBy"), Label)
            Dim ReviewDate As Label = CType(e.Item.FindControl("ReviewDate"), Label)
            Dim ApproveBy As Label = CType(e.Item.FindControl("ApproveBy"), Label)
            Dim ApproveDate As Label = CType(e.Item.FindControl("ApproveDate"), Label)
    
            if Trim(SubmitDate.text)  <> "" then SubmitDate.text  = format(cdate(SubmitDate.text),"dd/MMM/yy")
            if Trim(VerifyDate.text)  <> "" then VerifyDate.text  = format(cdate(VerifyDate.text),"dd/MMM/yy")
            if Trim(ReviewDate.text)  <> "" then ReviewDate.text  = format(cdate(ReviewDate.text),"dd/MMM/yy")
            if Trim(ApproveDate.text) <> "" then ApproveDate.text = format(cdate(ApproveDate.text),"dd/MMM/yy")
    
        End if
    End Sub
    
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
            SortField = CStr(e.SortExpression)
            procLoadGridData ()
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        if trim(cmbStatus.selecteditem.value) = "ALL" then
            if trim(cmbSearchField.selecteditem.value) = "BOM_QUOTE_NO" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and App1_By is not null order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "MODEL_NO" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and App1_By is not null  order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "MODEL_DESC" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and App1_By is not null  order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "PART_SPEC" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE bom_quote_no in (Select BOM_Quote_No from bom_quote_D where " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ) and App1_By is not null  order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "PART_DESC" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE bom_quote_no in (Select BOM_Quote_No from bom_quote_D where " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ) and App1_By is not null  order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "CUST_part_no" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE bom_quote_no in (Select BOM_Quote_No from bom_quote_D where " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ) and App1_By is not null  order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "PART_NO" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE bom_quote_no in (Select BOM_Quote_No from bom_quote_D where " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ) and App1_By is not null  order by BOM_QUOTE_NO desc"
        elseif trim(cmbStatus.selecteditem.value) <> "ALL" then
            if trim(cmbSearchField.selecteditem.value) = "BOM_QUOTE_NO" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and BOM_Quote_Status = '" & trim(cmbStatus.selecteditem.value) & "' and App1_By is not null  order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "MODEL_NO" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and BOM_Quote_Status = '" & trim(cmbStatus.selecteditem.value) & "' and App1_By is not null  order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "MODEL_DESC" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and BOM_Quote_Status = '" & trim(cmbStatus.selecteditem.value) & "' and App1_By is not null  order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "PART_SPEC" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE bom_quote_no in (Select BOM_Quote_No from bom_quote_D where " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ) and App1_By is not null  and BOM_Quote_Status = '" & trim(cmbStatus.selecteditem.value) & "' order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "PART_DESC" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE bom_quote_no in (Select BOM_Quote_No from bom_quote_D where " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ) and App1_By is not null  and BOM_Quote_Status = '" & trim(cmbStatus.selecteditem.value) & "' order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "CUST_part_no" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE bom_quote_no in (Select BOM_Quote_No from bom_quote_D where " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ) and App1_By is not null  and BOM_Quote_Status = '" & trim(cmbStatus.selecteditem.value) & "' order by BOM_QUOTE_NO desc"
            if trim(cmbSearchField.selecteditem.value) = "PART_NO" then StrSql = "SELECT * FROM BOM_QUOTE_M WHERE bom_quote_no in (Select BOM_Quote_No from bom_quote_D where " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ) and App1_By is not null  and BOM_Quote_Status = '" & trim(cmbStatus.selecteditem.value) & "' order by BOM_QUOTE_NO desc"
        End if
    
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"BOM_QUOTE_D")
        GridControl1.DataSource=resExePagedDataSet.Tables("BOM_QUOTE_D").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    
    Sub Button1_Click_1(sender As Object, e As EventArgs)
        ProcLoadGridData()
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmbSearchField_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">BOM QUOTATION
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 497px" cellspacing="0" cellpadding="0" width="90%" align="center" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 25px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label3" runat="server" cssclass="OutputText">Search</asp:Label>&nbsp; 
                                                                        <asp:TextBox id="txtSearch" runat="server" Height="19px" Width="164px" CssClass="OutputText"></asp:TextBox>
                                                                        &nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">by</asp:Label>&nbsp; 
                                                                        <asp:DropDownList id="cmbSearchField" runat="server" Height="19px" Width="161px" CssClass="OutputText" OnSelectedIndexChanged="cmbSearchField_SelectedIndexChanged">
                                                                            <asp:ListItem Value="BOM_QUOTE_NO">QUOTATION NO</asp:ListItem>
                                                                            <asp:ListItem Value="MODEL_NO">MODEL NO</asp:ListItem>
                                                                            <asp:ListItem Value="MODEL_DESC">MODEL DESCRIPTION</asp:ListItem>
                                                                            <asp:ListItem Value="PART_SPEC">PART SPECIFICATION</asp:ListItem>
                                                                            <asp:ListItem Value="PART_DESC">PART DESCRIPTION</asp:ListItem>
                                                                            <asp:ListItem Value="CUST_part_no">CUST. PART NO</asp:ListItem>
                                                                            <asp:ListItem Value="PART_NO">G-Tek PART NO</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList id="cmbStatus" runat="server" Height="19px" Width="166px" CssClass="OutputText" OnSelectedIndexChanged="cmbSearchField_SelectedIndexChanged">
                                                                            <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                                                            <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                                            <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                                            <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                                            <asp:ListItem Value="PENDING APPROVAL">PENDING APPROVAL</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="Button1" onclick="Button1_Click_1" runat="server" Width="43px" CssClass="OutputText" Text="GO"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSortCommand="SortGrid" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:HyperLinkColumn Text="View" DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="BOMQuoteWorkSheetApp2.aspx?ID={0}"></asp:HyperLinkColumn>
                                                            <asp:BoundColumn DataField="BOM_QUOTE_NO" HeaderText="Quotation No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CUST_NAME" HeaderText="Customer Name"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MODEL_NO" HeaderText="Model No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MODEL_DESC" HeaderText="Model Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="BOM_QUOTE_REV" HeaderText="Revision No"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Submitted By">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SUBMIT_BY") %>' /> <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SUBMIT_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Verified By">
                                                                <ItemTemplate>
                                                                    <asp:Label id="VerifyBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP1_BY") %>' /> <asp:Label id="VerifyDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP1_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Reviewed By">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ReviewBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP2_BY") %>' /> <asp:Label id="ReviewDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP2_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Approved By">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ApproveBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP3_BY") %>' /> <asp:Label id="ApproveDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP3_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Old Ref No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="NewBOMQuoteNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "New_BOM_Quote_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="BOMQuoteStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "BOM_Quote_Status") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="131px" Text="Back"></asp:Button>
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
