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
        if page.isPostBack = false then ProcLoadGridData()
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("SELECT * FROM Lot_Closure_M ORDER BY Lot_Closure_No DESC","FECN_M")
        Dim DV as New DataView(resExePagedDataSet.Tables("FECN_M"))
    
        GridControl1.DataSource=DV
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        Dim LotClosureNo as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        LotClosureNo = ReqCOM.GetDocumentNo("Lot_Closure_No")
    
        ReqCOM.ExecuteNonQuery("Update Main set Lot_Closure_no = Lot_Closure_no + 1")
    
        ReqCom.ExecuteNonQuery("insert into lot_closure_m(lot_closure_no,create_by,create_date,lot_closure_status) select '" & trim(LotClosureNo) & "','" & trim(Request.cookies("U_ID").value) & "','" & cdate(now) & "','Pending Submission'")
        Response.redirect("LotClosureDet.aspx?ID=" & ReqCOM.GetFieldVal("select Seq_No from Lot_Closure_m where Lot_Closure_No = '" & trim(LotClosureNo) & "';","Seq_No"))
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim CreateDate As Label = CType(e.Item.FindControl("CreateDate"), Label)
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim IQCDate As Label = CType(e.Item.FindControl("IQCDate"), Label)
            Dim StoreDate As Label = CType(e.Item.FindControl("StoreDate"), Label)
            Dim POOutDate As Label = CType(e.Item.FindControl("POOutDate"), Label)
    
            if trim(CreateDate.text) <> "" then CreateDate.text = format(cdate(CreateDate.text),"dd/MM/yy")
            if trim(SubmitDate.text) <> "" then SubmitDate.text = format(cdate(SubmitDate.text),"dd/MM/yy")
            if trim(IQCDate.text) <> "" then IQCDate.text = format(cdate(IQCDate.text),"dd/MM/yy")
            if trim(StoreDate.text) <> "" then StoreDate.text = format(cdate(StoreDate.text),"dd/MM/yy")
            if trim(POOutDate.text) <> "" then POOutDate.text = format(cdate(POOutDate.text),"dd/MM/yy")
        End if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">LOT
                                CLOSURE LIST</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 27px" width="94%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" OnPageIndexChanged="OurPager" AllowPaging="True" BorderColor="Gray" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <PagerStyle mode="NumericPages" nextpagetext="Next" prevpagetext="Prev"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle cssclass="GridHeaderSmall" bordercolor="White"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn >
                                                                <ItemTemplate>
                                                                    <asp:Hyperlink ID="Hyperlink2" ToolTip="View this Item" imageURL="view.gif" Runat="Server" NavigateUrl= <%#"LotClosureDet.aspx?id=" + DataBinder.Eval(Container.DataItem,"Seq_No").ToString() + "" %>></asp:Hyperlink>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn >
                                                            <asp:TemplateColumn HeaderText="Lot Closure No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LotClosureNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "LOT_CLOSURE_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Create By/Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CreateBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Create_By") %>' /> - <asp:Label id="CreateDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Create_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit By/Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Create_By") %>' /> - <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="IQC">
                                                                <ItemTemplate>
                                                                    <asp:Label id="IQCDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "IQC_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Store">
                                                                <ItemTemplate>
                                                                    <asp:Label id="StoreDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Store_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="P/O Outstanding">
                                                                <ItemTemplate>
                                                                    <asp:Label id="POOutDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PO_Out_Date") %>' /> <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LotClosureStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_Closure_Status") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Text="New Lot Closure List" CssClass="OutputText" Width="173px"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <p align="center">
                                                                        </p>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" CssClass="OutputText" Width="173px"></asp:Button>
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
    <!-- Insert content here -->
</body>
</html>
