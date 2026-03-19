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
        Dim StrSql as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim resExePagedDataSet as Dataset
        cmdNew.visible = true
        if cmbSearch.selecteditem.value <> "PART_NO" and cmbSearch.selecteditem.value <> "VEN_CODE" THEN StrSql = "Select mm.create_date,mm.create_By,mm.seq_no,mm.do_no,mm.mif_status,mm.mif_date,mm.inv_no,mm.App1_Date,mm.App1_By,mm.App2_By,mm.App2_Date,MM.mif_no,mm.MIF_status,v.ven_name from MIF_M MM, VENDOR V where mm.ven_Code = v.ven_Code and " & cmbSearch.selecteditem.value & " like '%" & trim(txtSearch.text) & "%' and MIF_status like '%" & trim(cmbMIFStatus.selecteditem.value) & "%' order by mm.mif_date desc"
        if cmbSearch.selecteditem.value = "PART_NO" THEN StrSql = "Select mm.create_date,mm.create_By,mm.seq_no,mm.do_no,mm.mif_status,mm.mif_date,mm.inv_no,mm.App1_Date,mm.App1_By,mm.App2_By,mm.App2_Date,MM.mif_no,mm.MIF_status,v.ven_name from MIF_M MM, VENDOR V where mm.ven_Code = v.ven_Code and MIF_status like '%" & trim(cmbMIFStatus.selecteditem.value) & "%' and mif_no in (select mif_no from mif_d where part_no like '%" & trim(txtSearch.text) & "%') order by mm.mif_date desc"
    
        if cmbSearch.selecteditem.value = "VEN_CODE" THEN StrSql = "Select mm.create_date,mm.create_By,mm.seq_no,mm.do_no,mm.mif_status,mm.mif_date,mm.inv_no,mm.App1_Date,mm.App1_By,mm.App2_By,mm.App2_Date,MM.mif_no,mm.MIF_status,v.ven_name from MIF_M MM, VENDOR V where mm.ven_Code = v.ven_Code and MIF_status like '%" & trim(cmbMIFStatus.selecteditem.value) & "%' and mm.VEN_CODE in (select Ven_Code from Vendor where Ven_Code + Ven_Name like '%" & trim(txtSearch.text) & "%') order by mm.mif_date desc"
    
        resExePagedDataSet = ReqCom.ExePagedDataSet(StrSql,"MIF_M")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("MIF_M").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
            Dim MIFDate As Label = CType(e.Item.FindControl("MIFDate"), Label)
            Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
            Dim CreateDate As Label = CType(e.Item.FindControl("CreateDate"), Label)
    
            MIFDate.text = format(cdate(MIFDate.text),"dd/MM/yy")
            if trim(App1Date.text) <> "" then App1Date.text = format(cdate(App1Date.text),"dd/MM/yy")
            if trim(App2Date.text) <> "" then App2Date.text = format(cdate(App2Date.text),"dd/MM/yy")
            if trim(CreateDate.text) <> "" then CreateDate.text = format(cdate(CreateDate.text),"dd/MM/yy")
            if trim(App1By.text) = "" then e.Item.CssClass = "PartSource"
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
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("MIFDet.aspx?ID=" & clng(SeqNo.text))
    end sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        dtgPartWithSource.CurrentPageIndex = e.NewPageIndex
        LoadMIF()
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">MATERIAL INCOMING
                                LIST</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 7px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="Label1" runat="server" cssclass="OutputText">SEARCH</asp:Label>
                                                    <asp:TextBox id="txtSearch" runat="server" Width="112px" CssClass="OutputText"></asp:TextBox>
                                                    &nbsp;<asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;<asp:DropDownList id="cmbSearch" runat="server" Width="109px" CssClass="OutputText">
                                                        <asp:ListItem Value="MIF_NO">MIF NO</asp:ListItem>
                                                        <asp:ListItem Value="DO_NO">D/O NO</asp:ListItem>
                                                        <asp:ListItem Value="INV_NO">INVOICE NO</asp:ListItem>
                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                        <asp:ListItem Value="VEN_CODE">SUPPLIER</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;<asp:Label id="Label4" runat="server" cssclass="OutputText">SHOW</asp:Label>&nbsp;<asp:DropDownList id="cmbMIFStatus" runat="server" Width="172px" CssClass="OutputText">
                                                        <asp:ListItem Value="">ALL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING APPROVAL">PENDING APPROVAL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                        <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                        <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;<asp:Label id="Label5" runat="server" cssclass="OutputText">MIF</asp:Label>&nbsp; 
                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Width="90px" CssClass="OutputText" Text="GO"></asp:Button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="98%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnPageIndexChanged="OurPager" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Gray" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatRow" AllowPaging="True" PageSize="20" OnItemCommand="ItemCommand">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Left"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgView" ToolTip="View this P/O" ImageUrl="View.gif" CommandArgument='VIEW' runat="server"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MIF #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_NO") %>' /> <asp:Label id="MIFNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MIF_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MIF Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MIFDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MIF_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="INV. #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="InvNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Inv_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="DO #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="DONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "DO_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="VEN_NAME" SortExpression="Ven_Code" HeaderText="Supplier"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Create">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CreateBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Create_By") %>' /> - <asp:Label id="CreateDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Create_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Rec Store">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> - <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="IQC">
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
</body>
</html>
