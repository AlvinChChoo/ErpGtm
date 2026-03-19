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
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if page.isPostBack = false then
            If SortField = "" then SortField = "KIT_LOT_NO"
            LoadDataWithSource()
        End if
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
    
    Sub LoadDataWithSource()
        Dim SortSeq,StrSql as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim resExePagedDataSet as Dataset
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        StrSql = "Select kl.seq_no,kl.kit_lot_no,kl.lot_no,so.model_no,kl.app1_by,kl.app1_date,kl.app1_date,kl.app1_by,kl.app2_by,kl.app2_date,kl.kit_lot_status from kit_lot kl, so_model_m so where kl.lot_no = so.lot_no"
        resExePagedDataSet = ReqCom.ExePagedDataSet(StrSql,"kit_lot")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("kit_lot").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Sub ShowSO(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Response.redirect("KitLotApp1Det.aspx?ID=" & SeqNo.text)
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim CreateBy As Label = CType(e.Item.FindControl("CreateBy"), Label)
            Dim CreateDate As Label = CType(e.Item.FindControl("CreateDate"), Label)
            Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
            Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
            Dim App2By As Label = CType(e.Item.FindControl("App2By"), Label)
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
    
            if App1Date.text <> "" then App1By.text = App1By.text & "-" & format(cdate(App1Date.text),"dd/MM/yy")
            if App2Date.text <> "" then App2By.text = App2By.text & "-" & format(cdate(App2Date.text),"dd/MM/yy")
        End if
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        LoadDataWithSource()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">KIT LOT FORM</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnEditCommand="ShowSO" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnSortCommand="SortGrid" AllowSorting="True" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                            <asp:TemplateColumn HeaderText="Kit Lot #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="KitLotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Kit_Lot_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Lot #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Model #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModelNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Prod. App">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PCMC. App">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="KitLotStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Kit_Lot_Status") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="50%">
                                                                    <p>
                                                                        &nbsp;
                                                                    </p>
                                                                </td>
                                                                <td width="50%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="120px"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
