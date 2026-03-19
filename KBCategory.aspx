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
        if page.isPostBack = false then
            Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            procLoadGridData ()
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
    
        'Dim StrSql as string = "Select * from KBCategory order by Category_ID asc"
        'Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        'Dim SortSeq as String
        'SortSeq = IIF((SortAscending=True),"Asc","Desc")
        'Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql & " Order by " & SortField & " " & SortSeq,"Categoty_ID")
        'GridControl1.DataSource=resExePagedDataSet.Tables("MRP_D").DefaultView
        'GridControl1.DataBind()
    
    
    
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet("SELECT Category_ID FROM KBCategory where category_id is not null ORDER BY Category_ID ASC","KBCATEGORY")
        GridControl1.DataSource=resExePagedDataSet.Tables("KBCATEGORY").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Dim ReqCom as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if page.isvalid = true then
            ReqCOM.ExecuteNonQuery("Insert into KBCategory(Category_ID) select '" & ucase(trim(txtCategory.text)) & "';")
            txtCategory.text = ""
            Response.redirect("KBCategory.aspx")
    
        end if
    End Sub
    
    Sub ValDuplicateColor(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select Category_ID from KBCategory where Category_ID = '" & trim(txtCategory.text) & "';","Category_ID") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim SeqNo As Label = CType(GridControl1.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from KBCategory where Category_ID = '" & trim(SeqNo.text) & "';")
                end if
            Catch
               ' MyError.Text = "There has been a problem with one or more of your inputs."
            End Try
        Next
        procLoadGridData ()
    End Sub

</script>
<html>
<head>
    <link href="CSSSTYLES.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" backcolor="" cssclass="FormDesc">CATEGORY
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 231px" cellspacing="0" cellpadding="0" width="90%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p align="center">
                                                    <table style="HEIGHT: 20px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="CATEGORY">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CATEGORY_ID") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Remove">
                                                                                    <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <center>
                                                                                            <asp:CheckBox id="Remove" runat="server" />
                                                                                        </center>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdpdate" onclick="cmdpdate_Click" runat="server" CausesValidation="False" Text="Remove Selected Item(s)" Width="176px"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 28px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="Label7" runat="server" cssclass="Instruction">To add new Category,
                                                                        key in Category and click 'Add New' </asp:Label>
                                                                    </p>
                                                                    <table style="HEIGHT: 17px" width="100%" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="Label8" runat="server" width="94px" cssclass="LabelNormal">Category</asp:Label></td>
                                                                                <td width="100%">
                                                                                    <asp:TextBox id="txtCategory" runat="server" Width="359px" CssClass="OutputText" MaxLength="35"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="Category already exist." OnServerValidate="ValDuplicateColor" ControlToValidate="txtCategory" Display="Dynamic" ForeColor=" "></asp:CustomValidator>
                                                                    <asp:RequiredFieldValidator id="valFeature" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Category." ControlToValidate="txtCategory" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Text="Add New" Width="173px"></asp:Button>
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
