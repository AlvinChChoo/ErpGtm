<%@ Page Language="VB" Debug="true" %>
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
            Dissql("Select Model_Code from Model_Master order by Model_Code","Model_Code","Model_Code",cmbModelNo)
            If SortField = "" then SortField = "Model_No"
            procLoadGridData ()
    
        end if
    End Sub
    
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
            with obj
                .items.clear
                .DataSource = ResExeDataReader
                .DataValueField = FValue
                .DataTextField = FText
                .DataBind()
            end with
            ResExeDataReader.close()
    
        End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim SortSeq as string = iif((SortAscending=true),"asc","desc")
        Dim strSql as string = "SELECT * FROM BOM_D WHERE Model_No = '" & cstr(cmbModelNo.selectedItem.value) & "' ORDER BY " + SortField & ",Part_No,P_Level " & SortSeq
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"PART_MASTER")
        GridControl1.DataSource=resExePagedDataSet.Tables("PART_MASTER").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("PartAddNew.aspx")
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
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
    
    Property SortAscending() As boolean
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
        ProcLoadGridData()
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim PartNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
    
            e.item.cells(11).text = ReqCOm.GetFieldVal("Select count(Model_No) as [Model_No] from BOM_D where Part_No = '" & trim(e.item.cells(2).text) & "' and Model_No = '" & trim(e.item.cells(1).text) & "' and P_Level = '" & trim(e.item.cells(3).text) & "' and Revision = " & cdec(e.item.cells(10).text) & ";","Model_No")
            if cint(e.item.cells(11).text) > 1 then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        response.redirect("PartAddNew.aspx")
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim SeqNo As Label = CType(GridControl1.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from BOM_D where Seq_No = '" & trim(SeqNo.text) & "';")
                end if
            Catch
    
            End Try
        Next
        procLoadGridData ()
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="WIDTH: 100%; HEIGHT: 51px" align="center" border="1">
                <tbody>
                    <tr>
                        <td>
                            <table style="WIDTH: 100%; HEIGHT: 7px">
                                <tbody>
                                    <tr>
                                        <td>
                                            <asp:Label id="Label1" runat="server" cssclass="OutputText">Model No</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList id="cmbModelNo" runat="server" Width="369px"></asp:DropDownList>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                        </td>
                                        <td colspan="3">
                                            <div align="right">
                                                <div align="right">
                                                    <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="58px" CausesValidation="False" Text="GO"></asp:Button>
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
            <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%" border="1">
                <tbody>
                    <tr>
                        <td>
                            <p>
                                <asp:DataGrid id="GridControl1" runat="server" width="100%" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="100" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" OnItemDataBound="FormatRow" OnSortCommand="SortGrid" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AllowSorting="True" Font-Size="Smaller" AllowPaging="True">
                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                    <Columns>
                                        <asp:TemplateColumn>
                                            <ItemTemplate>
                                                <asp:Label id="lblSeqNo" visible="False" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="Model_No" SortExpression="Model_No" HeaderText="Model"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="Part_No" HeaderText="Part_No"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="P_Level" HeaderText="level"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="P_Location" HeaderText="Location"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="P_Color" HeaderText="Color"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="Packing" HeaderText="Packing"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="lot_factor1" HeaderText="L/F 1"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="Lot_Factor2" HeaderText="L/F 2"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="P_Usage" HeaderText="Usage"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="Revision" HeaderText="Revision"></asp:BoundColumn>
                                        <asp:BoundColumn HeaderText="Count"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderText="Remove">
                                            <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                            <ItemStyle horizontalalign="Center"></ItemStyle>
                                            <ItemTemplate>
                                                <center>
                                                    <asp:CheckBox id="Remove" runat="server" />
                                                </center>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" pagebuttoncount="50" mode="NumericPages"></PagerStyle>
                                </asp:DataGrid>
                            </p>
                            <p>
                                <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                            </td>
                                            <td>
                                                <div align="right">
                                                    <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="169px" Text="Remove selected part"></asp:Button>
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
        <p>
        </p>
    </form>
</body>
</html>
