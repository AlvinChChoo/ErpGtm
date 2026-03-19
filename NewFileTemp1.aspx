<%@ Page Language="VB" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            cmdAddNew.attributes.add("onClick","javascript:if(confirm('This will create a new approval sheet document.\nAre you sure to continue ?')==false) return false;")
            LoadLotClosureData
            procLoadGridData ()
        End If
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string
    
        StrSql = "SELECT * FROM SO_Model_M where lot_closure_no = '" & trim(Request.params("ID")) & "' ORDER BY lot_closure_no desc"
    
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"CUST")
        GridControl1.DataSource=resExePagedDataSet.Tables("CUST").DefaultView
        GridControl1.DataBind()
    end sub
    
    sub LoadLotClosureData()
    
        strsql ="select * from lot_closure_m where lot_closure_no = '" & trim(request.params("ID")) & "';"
    
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while result.read
            lblLotClosureNo.text= result("Lot_Closure_No")
            lblCreateBy.text= result("Create_By")
            lblCreateDate.text= result("Create_Date")
    
            if trim(lblCreateDate.text) <> "" then lblCreateDate.text = format(cdate(lblCreateDate.text),"dd/MM/yy")
    
        loop
    end sub
    
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("UnitPriceApprovalSheetAddNew.aspx")
    End Sub
    
    Sub Button3_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("LotClosure.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
    
    
            Dim CreateDate as label = CType(e.Item.FindControl("CreateDate"), Label)
    
            if trim(CreateDate.text) <> "" then format(cdate(CreateDate.text),"dd/MM/yy")
    
    
    
    
        End if
    End Sub
    
    Sub cmbSearch_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ItemCommandUPAS(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim UPANo As Label = CType(e.Item.FindControl("UPANo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("NewFileTemp1.aspx?ID=" & clng(SeqNo.text))
    
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">UNIT PRICE
                                APPROVAL LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="WIDTH: 239px; HEIGHT: 71px">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Label id="Label2" runat="server">Lot Closure No</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblLotClosureNo" runat="server"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <asp:Label id="lblCreateBy" runat="server"></asp:Label>&nbsp;- <asp:Label id="lblCreateDate" runat="server"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <asp:Label id="Label5" runat="server"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <asp:Label id="Label6" runat="server"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <asp:Label id="Label7" runat="server"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <asp:Label id="Label8" runat="server"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" OnPageIndexChanged="OurPager" AllowPaging="True" BorderColor="Gray" cellpadding="4" Font-Name="Verdana" ShowFooter="True" AutoGenerateColumns="False" OnItemDataBound="FormatRow" OnItemCommand="ItemCommandUPAS" Font-Names="Verdana">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Model #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModelNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Lot #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Quantity">
                                                                <ItemTemplate>
                                                                    <asp:Label id="OrderQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Order_Qty") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                    &nbsp; 
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="136px" Text="Back"></asp:Button>
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
