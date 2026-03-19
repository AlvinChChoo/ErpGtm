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
        if page.isPostBack = false then procLoadGridData ()
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("SELECT SEQ_No,MRP_No,End_Date FROM MRP_HISTORY_M ORDER BY MRP_No Desc","MRP_HISTORY_M")
        GridControl1.DataSource=resExePagedDataSet.Tables("MRP_HISTORY_M").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim MRPNo As Label = CType(e.Item.FindControl("MRPNo"), Label)
    
        if ucase(e.commandArgument) = "VIEW" then ShowReport ("PopupReportViewer.aspx?RptName=MRPLOTSEXPLODED&MRPNo=" & trim(MRPNo.text))
    end sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim EndDate As Label = CType(e.Item.FindControl("EndDate"), Label)
            EndDate.text = format(cdate(EndDate.text),"dd/MM/yy")
        End if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">MRP
                                LOT EXPLOSION</asp:Label> 
                            </p>
                            <p align="center">
                                <asp:DataGrid id="GridControl1" runat="server" width="60%" AutoGenerateColumns="False" cellpadding="4" GridLines="None" BorderColor="Black" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" AllowPaging="True" OnItemCommand="ItemCommand" PageSize="20" OnItemDataBound="FormatRow" BorderWidth="1px" OnPageIndexChanged="OurPager">
                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                    <Columns>
                                        <asp:TemplateColumn>
                                            <ItemTemplate>
                                                <asp:ImageButton id="ImgView" ToolTip="View this S/O" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="MRP No">
                                            <ItemTemplate>
                                                <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> <asp:Label id="MRPNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MRP_No") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Explosion Date">
                                            <ItemTemplate>
                                                <asp:Label id="ENDDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "END_Date") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                </asp:DataGrid>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
