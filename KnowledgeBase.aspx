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
            If SortField = "" then SortField = "Category_ID"
            ProcLoadGridData
            
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim SortSeq as string
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim SortingField as string
    
        Dim StrSql as string = "Select * from KBProblems order by " & SortField & " " & SortSeq
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"KBProblems")
        GridControl1.DataSource=resExePagedDataSet.Tables("KBProblems").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub ShowAlert()
        Dim Msg as string
        Dim strScript as string
    
        If  trim(request.cookies("AlertMessage").value) = "" then
        else
            msg = trim(Request.cookies("AlertMessage").value)
            Response.Cookies("AlertMessage").Value = ""
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
    
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        end if
    End sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdNew_Click(sender As Object, e As EventArgs)
        Response.redirect("SymptomAdd.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(4).Text = format(cdate(e.Item.Cells(4).Text),"MM/dd/yy")
        End if
    End Sub
    
    Sub SortGrid(s As Object, e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        ProcLoadGridData()
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

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">KNOWLEDGE BASE</asp:Label>
                            </p>
                            <p>
                                <asp:DataGrid id="GridControl1" runat="server" width="100%" OnPageIndexChanged="OurPager" AllowPaging="True" ShowFooter="True" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AutoGenerateColumns="False" GridLines="Vertical" BorderColor="Black" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" cellpadding="4" OnItemDataBound="FormatRow" OnSortCommand="SortGrid" AllowSorting="True">
                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                    <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <Columns>
                                        <asp:HyperLinkColumn Text="View" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="SymptomDetails.aspx?ID={0}"></asp:HyperLinkColumn>
                                        <asp:BoundColumn DataField="SYMPTOMS" HeaderText="SYMPTOMS"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="CATEGORY_ID" SortExpression="CATEGORY_ID" HeaderText="CATEGORY"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="U_ID" SortExpression="U_ID" HeaderText="AUTHOR"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="Trans_Date" SortExpression="Trans_Date" HeaderText="DATE"></asp:BoundColumn>
                                    </Columns>
                                </asp:DataGrid>
                            </p>
                            <p>
                                <table style="HEIGHT: 25px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Button id="cmdNew" onclick="cmdNew_Click" runat="server" Text="Post New Symptoms"></asp:Button>
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
        </p>
    </form>
</body>
</html>
