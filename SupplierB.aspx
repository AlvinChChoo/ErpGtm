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
            If SortField = "" then SortField = "Ven_Code"
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            ProcLoadGridData("SELECT * FROM VENDOR WHERE " & cmbSearchField.selectedItem.value & " like '%" & cstr(txtSearch.Text) & "%'")
    
    
            if gridcontrol1.items.count = 0 then
                Label2.visible = true: gridcontrol1.visible = false
            else
                Label2.visible = false: gridcontrol1.visible = true
            end if
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData("SELECT * FROM VENDOR WHERE " & cmbSearchField.selectedItem.value & " like '%" & cstr(txtSearch.Text) & "%'")
    end sub
    
    Sub ProcLoadGridData(StrSql as string)
        Dim SortSeq as String
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql & " Order by " & SortField & " " & SortSeq,"VENDOR")
        GridControl1.DataSource=resExePagedDataSet.Tables("VENDOR").DefaultView
        GridControl1.DataBind()
    end sub
    
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
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        ProcLoadGridData("SELECT * FROM VENDOR WHERE " & cmbSearchField.selectedItem.value & " like '%" & cstr(txtSearch.Text) & "%'")
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData("SELECT * FROM VENDOR WHERE " & cmbSearchField.selectedItem.value & " like '%" & cstr(txtSearch.Text) & "%'")
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
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
            <table style="HEIGHT: 631px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SUPPLIER LIST</asp:Label> 
                                <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="Label7" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp; 
                                                    <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="159px"></asp:TextBox>
                                                    &nbsp; <asp:Label id="Label5" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp; 
                                                    <asp:DropDownList id="cmbSearchField" runat="server" CssClass="OutputText" Width="143px">
                                                        <asp:ListItem Value="Ven_Code">Code</asp:ListItem>
                                                        <asp:ListItem Value="Ven_Name">Name</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;&nbsp; 
                                                    <asp:Button id="Button1" onclick="Button1_Click" runat="server" CssClass="OutputText" Width="58px" Text="GO" CausesValidation="False"></asp:Button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 634px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p>
                                                    <table style="WIDTH: 100%; HEIGHT: 52px" cellspacing="0" cellpadding="0">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="Label2" runat="server" width="335px">There are no item to display.</asp:Label>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSortCommand="SortGrid" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager" Visible="False" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" AllowSorting="True">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:HyperLinkColumn Text="View" DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="SupplierBDet.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                                <asp:BoundColumn DataField="Ven_Code" SortExpression="Ven_Code" HeaderText="CODE"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="VEN_NAME" SortExpression="Ven_Name" HeaderText="NAME"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="TEL1" HeaderText="TEL"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="FAX1" HeaderText="FAX"></asp:BoundColumn>
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
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        &nbsp;
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="151px" Text="Back"></asp:Button>
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
