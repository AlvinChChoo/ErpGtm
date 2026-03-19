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
        if page.isPostBack = false then
            Dim selectionId As String = Request.Params("selection")
            If Not selectionId Is Nothing Then MyList.SelectedIndex = CInt(selectionId)
            Dim StrSql as String = "Select PGM.GROUP_Name,UG.Group_ID,PGM.Display_Name,PGM.Seq_No from User_Group UG,program_group_m PGM where UG.U_ID = '" & trim(request.cookies("U_ID").value) & "' and UG.Group_ID = PGM.Seq_No order by UG.Group_ID asc"
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"User_Group")
            MyList.DataSource=resExePagedDataSet.Tables("User_Group").DefaultView
            MyList.DataBind()
            if request.params("ID") <> nothing then populateShoppingCartList()
            if request.params("ID") <> nothing then lblSelModule.text = "Module  >>  " & ReqCOM.GetFieldVal("select Display_name from Program_group_m where group_name = '" & trim(request.params("ID")) & "';","Display_name")
        end if
    End Sub
    
    Sub PopulateShoppingCartList()
        Dim OurCommand as sqlcommand
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ourDataAdapter as SQLDataAdapter
        dim OurDataset as new dataset()
        OurCommand = New SQLCommand("Select PG.Form_ID,MOD.MOD_Desc,MOD.MOD_Name from program_group_d PG,Mod_Reg_D MOD where PG.Group_Desc = '" & trim(Request.Params("ID")) & "' and MOD.Seq_No = PG.Form_ID ORDER BY MOD.SEQ_NO ASC",myconnection)
        ourdataadapter=new sqldataadapter(ourcommand)
        ourDataAdapter.fill(OurDataset,"program_group_d")
        Dim OurDataTable as new dataview(ourDataSet.Tables("program_group_d"))
        GridControl1.DataSource = OurDatatable
        GridControl1.DataBind()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 4px" cellspacing="0" cellpadding="0" width="747" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <br />
            <table style="HEIGHT: 4px" cellspacing="0" cellpadding="0" width="747" align="center">
                <tbody>
                    <tr>
                        <td valign="top" width="200">
                            <p>
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="96%" align="left">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="28" background="Frame-Top-left.jpg" height="28">
                                                            </td>
                                                            <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                MODULES</td>
                                                            <td width="28" background="Frame-Top-right.jpg">
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td bgcolor="white">
                                                                <div align="center">
                                                                    <asp:DataList id="MyList" runat="server" width="98%" Height="55px" cellpadding="0" SelectedItemStyle-BackColor="dimgray" EnableViewState="False" CellSpacing="2" BorderStyle="None" OnSelectedIndexChanged="MyList_SelectedIndexChanged">
                                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                        <SelectedItemStyle backcolor="DimGray"></SelectedItemStyle>
                                                                        <SelectedItemTemplate>
                                                                            <asp:HyperLink class="MenuSelected" id="HyperLink2" Text='<%# DataBinder.Eval(Container.DataItem, "Display_Name") %>' NavigateUrl='<%# "Default.aspx?ID=" & DataBinder.Eval(Container.DataItem, "Group_Name") & "&selection=" & Container.ItemIndex %>' runat="server" />
                                                                        </SelectedItemTemplate>
                                                                        <ItemTemplate>
                                                                            <asp:HyperLink class="ItemUnselected" id="HyperLink1" Text='<%# DataBinder.Eval(Container.DataItem, "Display_Name") %>' NavigateUrl='<%# "Default.aspx?ID=" & DataBinder.Eval(Container.DataItem, "Group_Name") & "&selection=" & Container.ItemIndex %>' runat="server" />
                                                                        </ItemTemplate>
                                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                    </asp:DataList>
                                                                </div>
                                                                <br />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                        </td>
                        <td valign="top">
                            <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%" align="right">
                                <tbody>
                                    <tr>
                                        <td>
                                            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td width="28" background="Frame-Top-left.jpg" height="28">
                                                        </td>
                                                        <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                            <asp:Label id="lblSelModule" runat="server"></asp:Label></td>
                                                        <td width="28" background="Frame-Top-right.jpg">
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td bgcolor="white">
                                                            <asp:DataGrid id="GridControl1" runat="server" cellpadding="0" CellSpacing="5" BorderStyle="None" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" ShowHeader="False" Font-Size="Large" AutoGenerateColumns="False" Font-Name="Verdana" GridLines="None" BorderColor="White" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" Font-Names="Verdana" Width="100%">
                                                                <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                <Columns>
                                                                    <asp:HyperLinkColumn DataNavigateUrlField="Mod_Name" DataNavigateUrlFormatString="{0}" DataTextField="MOD_DESC"></asp:HyperLinkColumn>
                                                                </Columns>
                                                            </asp:DataGrid>
                                                            <br />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
            <br />
            <table style="HEIGHT: 4px" cellspacing="0" cellpadding="0" width="747" align="center">
                <tbody>
                    <tr>
                        <td>
                            <Footer:Footer id="Footer" runat="server"></Footer:Footer>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
