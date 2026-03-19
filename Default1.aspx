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
        if page.isPostBack = false then
            Dim selectionId As String = Request.Params("selection")
            If Not selectionId Is Nothing Then MyList.SelectedIndex = CInt(selectionId)
    
            Dim StrSql as String = "Select PGM.GROUP_Name,UG.Group_ID,PGM.Display_Name,PGM.Seq_No from User_Group UG,program_group_m PGM where UG.U_ID = '" & trim(request.cookies("U_ID").value) & "' and UG.Group_ID = PGM.Seq_No order by UG.Group_ID asc"
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"User_Group")
            MyList.DataSource=resExePagedDataSet.Tables("User_Group").DefaultView
            MyList.DataBind()
    
            if request.params("ID") <> nothing then populateShoppingCartList()
        end if
    End Sub
    
    
    Sub PopulateShoppingCartList()
        Dim OurCommand as sqlcommand
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ourDataAdapter as SQLDataAdapter
        dim OurDataset as new dataset()
        OurCommand = New SQLCommand("Select PG.Form_ID,MOD.MOD_Desc,MOD.MOD_Name from program_group_d PG,Mod_Reg_D MOD where PG.Group_Desc = '" & trim(Request.Params("ID")) & "' and MOD.Seq_No = PG.Form_ID ORDER BY MOD.MOD_Desc",myconnection)
        ourdataadapter=new sqldataadapter(ourcommand)
        ourDataAdapter.fill(OurDataset,"program_group_d")
        Dim OurDataTable as new dataview(ourDataSet.Tables("program_group_d"))
        GridControl1.DataSource = OurDatatable
        GridControl1.DataBind()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <table height="100%" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td colspan="2">
                        <p>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </p>
                    </td>
                </tr>
                <tr>
                    <td valign="top" align="left" height="100%">
                        <p>
                            <table style="WIDTH: 134px" height="100%" cellspacing="0" cellpadding="0" width="134" border="0">
                                <tbody>
                                    <tr valign="top">
                                        <td colspan="2">
                                            <p align="left">
                                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="98%" align="center">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label2" runat="server" width="100%" cssclass="SectionHeader"> Shortcuts</asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <p align="left">
                                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="98%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:DataList id="MyList" runat="server" width="227px" Height="55px" cellpadding="2" SelectedItemStyle-BackColor="dimgray" EnableViewState="False">
                                                                                            <SelectedItemStyle backcolor="DimGray"></SelectedItemStyle>
                                                                                            <SelectedItemTemplate>
                                                                                                <asp:HyperLink class="MenuSelected" id="HyperLink2" Text='<%# DataBinder.Eval(Container.DataItem, "Display_Name") %>' NavigateUrl='<%# "Default.aspx?ID=" & DataBinder.Eval(Container.DataItem, "Group_Name") & "&selection=" & Container.ItemIndex %>' runat="server" />
                                                                                            </SelectedItemTemplate>
                                                                                            <ItemTemplate>
                                                                                                <asp:HyperLink class="MenuUnselected" id="HyperLink1" Text='<%# DataBinder.Eval(Container.DataItem, "Display_Name") %>' NavigateUrl='<%# "Default.aspx?ID=" & DataBinder.Eval(Container.DataItem, "Group_Name") & "&selection=" & Container.ItemIndex %>' runat="server" />
                                                                                            </ItemTemplate>
                                                                                        </asp:DataList>
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
                                            <p align="left">
                                                &nbsp;
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" align="left" colspan="2">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="10">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            &nbsp; 
                        </p>
                    </td>
                    <td valign="top" nowrap="nowrap" align="left" width="100%" height="100%">
                        <asp:DataGrid id="GridControl1" runat="server" cellpadding="0" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" CellSpacing="5" ShowHeader="False" Font-Size="Large" AutoGenerateColumns="False" Font-Name="Verdana" GridLines="Vertical" BorderColor="White" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" Font-Names="Verdana" BorderStyle="None" Width="100%">
                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                            <ItemStyle cssclass="GridItem"></ItemStyle>
                            <Columns>
                                <asp:HyperLinkColumn DataNavigateUrlField="Mod_Name" DataNavigateUrlFormatString="{0}" DataTextField="MOD_DESC"></asp:HyperLinkColumn>
                            </Columns>
                        </asp:DataGrid>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
