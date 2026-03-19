<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
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
            If SortField = "" then SortField = "Model_Code"
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
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        procLoadGridData ()
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "SELECT MM.MODEL_CODE, MM.MODEL_DESC, MM.BRAND_NAME, CUST.CUST_CODE + '|' + CUST.CUST_NAME AS [CUST_CODE],MM.SEQ_NO FROM CUST, MODEL_MASTER MM WHERE CUST.CUST_CODE = MM.CUST_CODE AND " & TRIM(cmbSearchField.selecteditem.value) & " like '%" & cstr(txtSearch.Text) & "%'"
        Dim SortSeq as String
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql & " Order by " & SortField & " " & SortSeq,"MODEL_MASTER")
        GridControl1.DataSource=resExePagedDataSet.Tables("MODEL_MASTER").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        response.redirect("ModelAdd.aspx")
    End Sub
    
    Sub Button1_Click_1(sender As Object, e As EventArgs)
        ProcLoadGridData()
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub ItemCommandModel(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if ucase(e.commandArgument) = "EDIT" then Response.redirect("ModelDet.aspx?ID=" & clng(SeqNo.text))
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <erp:HEADER id="UserControl1" runat="server"></erp:HEADER>
                            </div>
                            <div align="center">
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Model&nbsp;List</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <br />
                                                                    <table style="HEIGHT: 25px" width="96%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p align="center">
                                                                                        <asp:Label id="Label3" runat="server" cssclass="OutputText">Search</asp:Label>&nbsp; 
                                                                                        <asp:TextBox id="txtSearch" runat="server" Height="19px" Width="164px" CssClass="OutputText"></asp:TextBox>
                                                                                        &nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">by</asp:Label>&nbsp; 
                                                                                        <asp:DropDownList id="cmbSearchField" runat="server" Height="19px" Width="238px" CssClass="OutputText">
                                                                                            <asp:ListItem Value="MM.Model_Code">CODE</asp:ListItem>
                                                                                            <asp:ListItem Value="MM.Model_Desc">DESCRIPTION</asp:ListItem>
                                                                                            <asp:ListItem Value="MM.BRAND_NAME">BRAND NAME</asp:ListItem>
                                                                                            <asp:ListItem Value="CUST.CUST_CODE">CUSTOMER CODE</asp:ListItem>
                                                                                            <asp:ListItem Value="CUST.CUST_NAME">CUSTOMER NAME</asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                        <asp:Button id="Button1" onclick="Button1_Click_1" runat="server" Width="72px" CssClass="OutputText" Text="GO"></asp:Button>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <br />
                                                                    <div align="center">
                                                                        <asp:DataGrid id="GridControl1" runat="server" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Gray" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnSortCommand="SortGrid" OnItemCommand="ItemCommandModel" width="96%">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <PagerStyle verticalalign="Top" nextpagetext="Next" prevpagetext="Prev" horizontalalign="Center" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="MODEL_CODE" SortExpression="Model_Code" HeaderText="CODE"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="MODEL_DESC" SortExpression="MODEL_DESC" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="BRAND_NAME" HeaderText="BRAND NAME"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="CUST_CODE" SortExpression="CUST_CODE" HeaderText="CUSTOMER CODE / NAME"></asp:BoundColumn>
                                                                                <asp:TemplateColumn>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                        <asp:ImageButton id="ImgEdit" ToolTip="Edit this item" ImageUrl="View.gif" CommandArgument='Edit' runat="server"></asp:ImageButton>
                                                                                        <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                        <br />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <p>
                                                        <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <p>
                                                                            <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="153px" Text="Add New Model"></asp:Button>
                                                                        </p>
                                                                    </td>
                                                                    <td>
                                                                        <div align="right">
                                                                            <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="123px" Text="Back"></asp:Button>
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
                            </div>
                            <footer:footer id="footer" runat="server"></footer:footer>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
