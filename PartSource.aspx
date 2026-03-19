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
        if page.isPostBack = false then LoadPartList()
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        LoadPartList()
    end sub
    
    Sub LoadPartList()
        Dim strSql as string = "SELECT PART_MASTER.part_no,PART_MASTER.part_desc,PART_MASTER.part_spec,PART_MASTER.M_PART_NO,PART_MASTER.seq_no,PART_MASTER.supply_type,(Select count(distinct(part_source.ven_code)) from part_source where part_source.part_no = PART_MASTER.part_no) as [NoOfSources] FROM PART_MASTER WHERE " & cmbSearchField.selecteditem.value & " like '%" & cstr(txtSearch.Text) & "%'  ORDER BY PART_MASTER.Part_No asc"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"PART_MASTER")
        GridControl1.DataSource=resExePagedDataSet.Tables("PART_MASTER").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        LoadPartList()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            if trim(e.item.cells(6).text) = "MAKE" then e.item.cells(5).text = "MAKE"
            if e.item.cells(5).text = "0" then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("PartSourceDet.aspx?ID=" & clng(SeqNo.text))
    end sub

</script>
<html xmlns:ibuyspy= "xmlns:ibuyspy" xmlns:footer= "xmlns:footer">
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <ERP:HEADER id="UserControl1" runat="server"></ERP:HEADER>
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
                                                                    Part Source List</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <br />
                                                                        <table style="HEIGHT: 10px" width="98%" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label1" runat="server" cssclass="OutputText">Search </asp:Label>&nbsp; 
                                                                                            <asp:TextBox id="txtSearch" runat="server" CssClass="Input_Box" Width="176px"></asp:TextBox>
                                                                                            &nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">by</asp:Label>&nbsp; 
                                                                                            <asp:DropDownList id="cmbSearchField" runat="server" CssClass="Input_Box" Width="148px">
                                                                                                <asp:ListItem Value="Part_No">PART NO</asp:ListItem>
                                                                                                <asp:ListItem Value="Part_Desc">DESCRIPTION</asp:ListItem>
                                                                                                <asp:ListItem Value="Part_Spec">SPECIFICATION</asp:ListItem>
                                                                                                <asp:ListItem Value="M_Part_No">MFG PART NO</asp:ListItem>
                                                                                                <asp:ListItem Value="MFG">MANUFACTURER</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                            <asp:Button id="Button1" onclick="Button1_Click" runat="server" CssClass="OutputText" Width="58px" Text="GO" CausesValidation="False"></asp:Button>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        <br />
                                                                    </p>
                                                                    <p align="center">
                                                                        <asp:DataGrid id="GridControl1" runat="server" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" BorderColor="Gray" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager" OnItemDataBound="FormatRow" OnItemCommand="ItemCommand" width="98%">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <PagerStyle verticalalign="Top" nextpagetext="Next" prevpagetext="Prev" horizontalalign="Center" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                        <asp:ImageButton id="ImgView" ToolTip="View this Part Source" ImageUrl="View.gif" CommandArgument='VIEW' runat="server"></asp:ImageButton>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="PART_NO" SortExpression="Part_No" HeaderText="PART NO"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PART_DESC" SortExpression="Part_Desc" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PART_SPEC" SortExpression="Part_Spec" HeaderText="SPECIFICATION"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="M_PART_NO" HeaderText="Mfg Part No"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="NoOfSources" HeaderText="SRC"></asp:BoundColumn>
                                                                                <asp:BoundColumn Visible="False" DataField="Supply_Type"></asp:BoundColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p align="center">
                                                                        <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="98%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="15%" bgcolor="yellow">
                                                                                    </td>
                                                                                    <td>
                                                                                        &nbsp; <asp:Label id="Label3" runat="server" cssclass="OutputText" width="100%">Part
                                                                                        without source(s)</asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        <br />
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <p>
                                                        <table style="HEIGHT: 14px" width="100%">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <div align="right">
                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="143px" Text="Back"></asp:Button>
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
