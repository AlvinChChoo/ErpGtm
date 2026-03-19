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
        if page.isPostBack = false then LoadMIF()
    End Sub
    
    Sub LoadMIF()
        Dim SortSeq as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        Dim resExePagedDataSet as Dataset
    
        cmdNew.visible = false
        if trim(cmbMIFStatus.selecteditem.value) = "ALL" THEN StrSql = "Select mm.seq_no,mm.do_no,mm.inv_no,mm.inv_no,CONVERT(VARCHAR(8), mm.mif_date, 3) as [mif_date],mm.App1_By,CONVERT(VARCHAR(8), mm.App1_Date, 3) as [App1_Date],mm.App2_By,CONVERT(VARCHAR(8), mm.App2_Date, 3) as [App2_Date],MM.mif_no,mm.MIF_status,v.ven_name from MIF_M MM, VENDOR V where mm.ven_Code = v.ven_Code and App1_Date is not null and " & cmbSearch.selecteditem.value & " like '%" & trim(txtSearch.text) & "%' order by mm.mif_date desc"
        if trim(cmbMIFStatus.selecteditem.value) <> "ALL" THEN StrSql = "Select mm.seq_no,mm.do_no,mm.inv_no,mm.inv_no,CONVERT(VARCHAR(8), mm.mif_date, 3) as [mif_date],mm.App1_By,CONVERT(VARCHAR(8), mm.App1_Date, 3) as [App1_Date],mm.App2_By,CONVERT(VARCHAR(8), mm.App2_Date, 3) as [App2_Date],MM.mif_no,mm.MIF_status,v.ven_name from MIF_M MM, VENDOR V where mm.ven_Code = v.ven_Code and App1_Date is not null and " & cmbSearch.selecteditem.value & " like '%" & trim(txtSearch.text) & "%' and MIF_status = '" & trim(cmbMIFStatus.selecteditem.value) & "' order by mm.mif_date desc"
        resExePagedDataSet = ReqCom.ExePagedDataSet(StrSql,"MIF_M")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("MIF_M").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        dtgPartWithSource.CurrentPageIndex = e.NewPageIndex
        LoadMIF()
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
            if trim(App2Date.text) = "" then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdNew_Click(sender As Object, e As EventArgs)
        Response.redirect("MIFAddNew.aspx")
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        LoadMIF
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("MIFIQCDet.aspx?ID=" & clng(SeqNo.text))
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
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
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">MATERIAL INCOMING
                                LIST</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="98%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 7px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center"><asp:Label id="Label1" runat="server" cssclass="OutputText">SEARCH</asp:Label>
                                                                        <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="112px"></asp:TextBox>
                                                                        &nbsp;<asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;<asp:DropDownList id="cmbSearch" runat="server" CssClass="OutputText" Width="109px">
                                                                            <asp:ListItem Value="MIF_NO">MIF NO</asp:ListItem>
                                                                            <asp:ListItem Value="DO_NO">D/O NO</asp:ListItem>
                                                                            <asp:ListItem Value="INV_NO">INVOICE NO</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;<asp:Label id="Label4" runat="server" cssclass="OutputText">SHOW</asp:Label>&nbsp;<asp:DropDownList id="cmbMIFStatus" runat="server" CssClass="OutputText" Width="172px">
                                                                            <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                                                            <asp:ListItem Value="PENDING APPROVAL">PENDING APPROVAL</asp:ListItem>
                                                                            <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                                            <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                                            <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;<asp:Label id="Label5" runat="server" cssclass="OutputText">MIF</asp:Label>&nbsp; 
                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Width="90px" Text="GO"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnPageIndexChanged="OurPager" OnItemDataBound="FormatRow" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" BorderColor="Gray" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" AllowPaging="True" OnItemCommand="ItemCommand">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_NO") %>' visible= "false" /> 
                                                                    <asp:ImageButton id="ImgView" ToolTip="View this item" ImageUrl="View.gif" CommandArgument='VIEW' runat="server"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MIF #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MIFNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MIF_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MIF DATE">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MIFDATE" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MIF_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="INV #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="INVNO" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "INV_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="DO #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="DONO" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "DO_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="VEN_NAME" HeaderText="Supplier"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Store">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> - <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="IQC App">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> - <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MIF_Status") %>' /> 
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
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdNew" onclick="cmdNew_Click" runat="server" Width="167px" Text="Add New MIF"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="129px" Text="Back"></asp:Button>
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
