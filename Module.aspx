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
             if page.isPostBack = false then procLoadGridData()
        End Sub
    
        Sub ProcLoadGridData()
            Dim StrSql as string
            StrSql = "Select Seq_No,DEPT,left(Mod_Desc,25) + ' ...' as [Mod_Desc],left(MOD_NAME,25) + ' ...' as [MOD_NAME] from Mod_Reg_D where " & trim(cmbBy.selectedItem.value) & " like '%" & trim(txtSearch.text) & "%';"
            Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"mod_reg_d")
            Dim DV as New DataView(resExePagedDataSet.Tables("mod_reg_d"))
            GridControl1.DataSource=DV
            GridControl1.DataBind()
        end sub
    
        Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
        End Sub
    
        Sub cmdBack_Click(sender As Object, e As EventArgs)
            response.redirect("Default.aspx")
        End Sub
    
        Sub cmdAdd_Click(sender As Object, e As EventArgs)
            response.redirect("ModuleAdd.aspx")
        End Sub
    
        Sub cmdSearch_Click(sender As Object, e As EventArgs)
            ProcLoadGridData()
        End Sub
    
        Sub ItemCommandModule(sender as Object,e as DataGridCommandEventArgs)
            Dim lblSeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            if ucase(e.commandArgument) = "EDIT" then Response.redirect("ModuleDet.aspx?ID=" & clng(lblSeqNo.text))
            if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQUery("Delete from Mod_Reg_D where seq_no = " & clng(lblSeqNo.text) & ";") : response.redirect("Module.aspx")
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
                                <asp:Label id="Label2" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">MODULE
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 27px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="HEIGHT: 17px" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Label id="Label1" runat="server" cssclass="OutputText">Search</asp:Label>&nbsp;&nbsp; 
                                                                                        <asp:TextBox id="txtSearch" runat="server" Width="248px" CssClass="OutputText"></asp:TextBox>
                                                                                        &nbsp;&nbsp; <asp:Label id="Label3" runat="server" cssclass="OutputText">By</asp:Label>&nbsp;&nbsp; 
                                                                                        <asp:DropDownList id="cmbBy" runat="server" Width="170px" CssClass="OutputText">
                                                                                            <asp:ListItem Value="Dept">Department</asp:ListItem>
                                                                                            <asp:ListItem Value="Mod_Desc">Description</asp:ListItem>
                                                                                            <asp:ListItem Value="Mod_Name">Form Name</asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="right">
                                                                                            <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" Width="67px" Text="GO"></asp:Button>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" BorderColor="Gray" cellpadding="4" AutoGenerateColumns="False" OnItemCommand="ItemCommandModule" BorderStyle="None">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="DEPT" HeaderText="Department"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Mod_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Form Name">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="MODNAME" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MOD_NAME") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Action">
                                                                                    <ItemTemplate>
                                                                                        <asp:ImageButton id="ImgEdit" ToolTip="Edit this item" ImageUrl="Edit.gif" CommandArgument='Edit' runat="server"></asp:ImageButton>
                                                                                        <asp:ImageButton id="ImgDelete" ToolTip="Delete this item" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server"></asp:ImageButton>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="173px" Text="Register new Module"></asp:Button>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="center">
                                                                                            <p align="center">
                                                                                            </p>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <p align="right">
                                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="120px" Text="Back"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
