<%@ Page Language="VB" %>
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
             if page.isPostBack = false then
                 If SortField = "" then SortField = "PR_NO"

                 Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
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


        Sub ProcLoadGridData()
            Dim StrSql as string = "SELECT * FROM TPR_M"
            Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"TPR_M")
            Dim DV as New DataView(resExePagedDataSet.Tables("TPR_M"))
            Dim SortSeq as String
            SortSeq = IIF((SortAscending=True),"Asc","Desc")
            DV.Sort = SortField + " " + SortSeq
            GridControl1.DataSource=DV
            GridControl1.DataBind()
         end sub

         Sub Button1_Click(sender As Object, e As EventArgs)
             GridControl1.currentpageindex=0
             ProcLoadGridData()
         End Sub

        Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
            SortField = CStr(e.SortExpression)
            ProcLoadGridData()
        End Sub

         Sub cmdAddNew_Click(sender As Object, e As EventArgs)
             response.redirect("PartAddNew.aspx")
         End Sub

         Protected Sub CalculateExtendedPrice(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
             'If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
             '    Dim PRDateDue As Date = trim(e.Item.Cells(5).Text)
             '    If PRDateDue <= now Then e.Item.CssClass = "PRExpired"
             'End If
         End Sub

         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)

         End Sub

        Sub cmdBack_Click(sender As Object, e As EventArgs)
            Response.redirect("Default.aspx")
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
            <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">PURCHASE
                                REQUISITION LIST</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="WIDTH: 100%; HEIGHT: 51px" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="WIDTH: 100%; HEIGHT: 7px">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="Label3" runat="server" cssclass="OutputText">Search by PR No.</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
                                                                                    <asp:TextBox id="txtSearch" runat="server" Width="276px"></asp:TextBox>
                                                                                </td>
                                                                                <td colspan="3">
                                                                                    <div align="right">
                                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="100px" CausesValidation="False" Text="GO"></asp:Button>
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
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" OnPageIndexChanged="OurPager" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" OnItemDataBound="CalculateExtendedPrice" OnSortCommand="SortGrid" AllowSorting="True">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:HyperLinkColumn Text="View" DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="TempPRHODPendingPRSubmission.aspx?ID={0}"></asp:HyperLinkColumn>
                                                            <asp:BoundColumn DataField="PR_NO" HeaderText="PR NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Status" HeaderText="STATUS"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CREATE_BY" HeaderText="CREATED BY"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CREATE_DATE" SortExpression="CREATE_DATE" HeaderText="DATE CREATED"></asp:BoundColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="120px" Text="Back"></asp:Button>
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
    <!-- Insert content here -->
</body>
</html>
