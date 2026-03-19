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
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("SELECT * FROM program_group_m ORDER BY Group_desc ASC","program_group_m")
    
        GridControl1.DataSource=resExePagedDataSet.Tables("program_group_m").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        Dim SeqNo As Label
        Dim remove As CheckBox
    
        For i = 0 To GridControl1.Items.Count - 1
            SeqNo = CType(GridControl1.Items(i).FindControl("lblSeqNo"), Label)
            remove = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
            If remove.Checked = true Then ReqCOM.ExecuteNonQuery("Delete from Program_Group_M where Group_Name = '" & trim(SeqNo.text) & "';")
        Next
        Response.redirect("ProgramGroup.aspx")
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdAddNew_Click_1(sender As Object, e As EventArgs)
        response.redirect("ProgramGroupAddNew.aspx")
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
    
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("ProgramGroupDet.aspx?ID=" & SeqNo.text)
        if ucase(e.commandArgument) = "SETTING" then Response.redirect("ProgramDet.aspx?ID=" & SeqNo.text)
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQuery("Delete from Program_Group_M where Seq_No = " & trim(SeqNo.text) & ";"):Response.redirect("ProgramGroup.aspx?ID=" & Request.params("ID"))
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" backcolor="" cssclass="FormDesc">PROGRAM
                                GROUP LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 231px" cellspacing="0" cellpadding="0" width="90%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p align="center">
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemCommand="ItemCommand" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" BorderColor="Gray" cellpadding="4" AutoGenerateColumns="False">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="User Group">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> <asp:Label id="GroupName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Group_Name") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Description">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Group_Desc") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Display Name">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblDisplayName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Display_Name") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Action">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:ImageButton id="ImgView" ToolTip="View this item" ImageUrl="View.gif" CommandArgument='View' runat="server" CausesValidation="False"></asp:ImageButton>
                                                                                        <asp:ImageButton id="ImgSetting" ToolTip="User Group Setting" ImageUrl="Setting.gif" CommandArgument='Setting' runat="server" CausesValidation="False"></asp:ImageButton>
                                                                                        <asp:ImageButton id="ImgDelete" ToolTip="Delete this item" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server" CausesValidation="False"></asp:ImageButton>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p align="right">
                                                                        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click_1" runat="server" Text="Add New program group" Width="180px" CssClass="OutputText"></asp:Button>
                                                                                    </td>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Button id="cmdpdate" onclick="cmdpdate_Click" runat="server" Text="Remove Selected Item(s)" Width="180px" CausesValidation="False" CssClass="OutputText"></asp:Button>
                                                                                        </p>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="right">
                                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="180px" CssClass="OutputText"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
