<%@ Page Language="VB" %>
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
        Dim StrSql as string = "Select part_no,left(part_spec,15) + '...' as [Part_Spec],left(part_desc,15) + '...' as [part_desc],Seq_No,m_part_no,date_launch,launch,ref_model,Std_Cost_RD_Curr_Code,Ori_Std_Cost_RD from Part_master where " & trim(cmbsearchfield.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' order by launch,part_no asc"
        DIm ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        ReqCom.ExecuteNonQuery("Update BOM_M set LATEST_REV = 'N'")
        ReqCom.ExecuteNonQuery("Truncate table UPDATE_BOM_REV")
        ReqCom.ExecuteNonQuery("insert into UPDATE_BOM_REV(Revision,Model_No) select max(Revision),model_no from bom_m group by model_no")
        ReqCOM.ExecuteNonQuery("Update BOM_M set Latest_Rev = 'N'")
        ReqCOM.ExecuteNonQuery("Update BOM_M set Latest_Rev = 'Y' from BOM_M,UPDATE_BOM_REV where BOM_M.model_no = UPDATE_BOM_REV.model_no and BOM_M.revision = UPDATE_BOM_REV.revision")
        ReqCom.ExecuteNonQuery("update part_master set launch = 'N';")
        ReqCom.ExecuteNonQuery("update part_master set launch = 'Y' where std_cost_rd = 0 and part_no in (select MAIN_PART_B4 from fecn_d where fecn_no in (select fecn_no from fecn_m where fecn_status = 'PENDING APPROVAL')) ;")
        ReqCom.ExecuteNonQuery("update part_master set launch = 'Y' where std_cost_rd = 0 and part_no in (select MAIN_PART from fecn_d where fecn_no in (select fecn_no from fecn_m where fecn_status = 'PENDING APPROVAL')) ;")
        ReqCom.ExecuteNonQuery("Update Part_master set Launch = 1 where launch = 'Y'")
        ReqCom.ExecuteNonQuery("Update Part_master set Launch = 2 where launch = 'N'")
    
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
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            'Dim OriStdCostRD As Label = CType(e.Item.FindControl("OriStdCostRD"), Label)
            Dim Launch As Label = CType(e.Item.FindControl("Launch"), Label)
    
            if trim(Launch.text) = "1" then e.Item.CssClass = "Urgent"
    
            'Launch
            'if cdec(OriStdCostRD.text) <= 0 then e.Item.CssClass = "WithoutStdCost"
        End if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub ItemCommandStdCost(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("PopupPartStdCost.aspx?ID=" & clng(SeqNo.text))
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" forecolor="" backcolor="" cssclass="FormDesc">PARTS
                                WITHOUT STD. COST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 16px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label1" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp;<asp:TextBox id="txtSearch" runat="server" Width="176px" CssClass="OutputText"></asp:TextBox>
                                                                        &nbsp; <asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp; 
                                                                        <asp:DropDownList id="cmbSearchField" runat="server" Width="172px" CssClass="OutputText">
                                                                            <asp:ListItem Value="Part_No">PART NO</asp:ListItem>
                                                                            <asp:ListItem Value="Part_Desc">DESCRIPTION</asp:ListItem>
                                                                            <asp:ListItem Value="Part_Spec">SPECIFICATION</asp:ListItem>
                                                                            <asp:ListItem Value="M_PART_NO">MFG. PART NO</asp:ListItem>
                                                                            <asp:ListItem Value="REF_Model">REF. MODEL</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp; 
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="58px" CssClass="OutputText" Text="GO" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemCommand="ItemCommandStdCost" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager" OnItemDataBound="FormatRow" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" BorderColor="Gray" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                    <asp:ImageButton id="ImgView" ToolTip="View this item" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Part No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="PART_DESC" SortExpression="PART_DESC" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_SPEC" SortExpression="PART_SPEC" HeaderText="Specification"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="m_part_no" HeaderText="Mfg. Part No"></asp:BoundColumn>
                                                            <asp:TemplateColumn Visible="False" HeaderText="Remove">
                                                                <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <center>
                                                                        <asp:CheckBox id="Remove" runat="server" />
                                                                    </center>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False" HeaderText="Date Launch">
                                                                <ItemTemplate>
                                                                    <asp:Label id="DateLaunch" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Date_Launch") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Launch" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Launch") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Ref_Model" HeaderText="Ref Model"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="R&D Std Cost">
                                                                <ItemTemplate>
                                                                    <asp:Label id="StdCostRDCurrCode" visible= "true" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Cost_RD_Curr_Code") %>' /> <asp:Label id="OriStdCostRD" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ori_Std_Cost_RD") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="114px" Text="Back"></asp:Button>
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
