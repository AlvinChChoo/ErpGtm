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
        Dim StrSql as string = "SELECT * FROM UOM WHERE UOM like '%" & cstr(txtSearch.Text) & "%'  ORDER BY UOM ASC"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"UOM")
        GridControl1.DataSource=resExePagedDataSet.Tables("UOM").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        ProcLoadGridData()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            ReqCOM.ExecuteNonQuery("Insert into UOM(UOM,UOM_Desc) select '" & ucase(trim(txtUOM.text)) & "','" & ucase(trim(txtUOMDesc.text)) & "';")
            Response.redirect("UOM.aspx")
        end if
    End Sub
    
    Sub ValDuplicateUOM(sender As Object, e As ServerValidateEventArgs)
    Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select uom from uom where uom = '" & trim(txtUOM.text) & "';","uom") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim SeqNo As Label = CType(GridControl1.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from UOM where UOM = '" & trim(SeqNo.text) & "';")
                end if
            Catch
    
            End Try
        Next
        procLoadGridData ()
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">UNIT OR MEASUREMENT
                                (UOM)LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 497px" cellspacing="0" cellpadding="0" width="90%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p align="center">
                                                    <table style="WIDTH: 100%; HEIGHT: 51px" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="WIDTH: 100%; HEIGHT: 7px">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="Label2" runat="server" width="55px" cssclass="LabelNormal">Search :</asp:Label>
                                                                                    <asp:TextBox id="txtSearch" runat="server" Width="222px"></asp:TextBox>
                                                                                </td>
                                                                                <td colspan="3">
                                                                                    <div align="right">
                                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="110px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 25px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        &nbsp;<asp:DataGrid id="GridControl1" runat="server" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" width="100%" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="Code">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UOM") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Description">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UOM_DESC") %>' /> 
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
                                                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" Width="185px" CausesValidation="False" Text="Remove Selected Item(s)"></asp:Button>
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
                                                                        <asp:Label id="Label7" runat="server" cssclass="Instruction">To add new UOM, key in
                                                                        Code and Description and click 'Add New' </asp:Label> 
                                                                    </p>
                                                                    <table style="HEIGHT: 17px" width="100%" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="Label8" runat="server" width="90px">Code</asp:Label></td>
                                                                                <td>
                                                                                    <asp:TextBox id="txtUOM" runat="server" Width="359px" MaxLength="20" CssClass="OutputText"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="Label3" runat="server" width="90px">Description</asp:Label></td>
                                                                                <td width="100%">
                                                                                    <asp:TextBox id="txtUOMDesc" runat="server" Width="359px" MaxLength="35" CssClass="OutputText"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <p>
                                                                        <asp:CustomValidator id="CustomValidator1" runat="server" OnServerValidate="ValDuplicateUOM" CssClass="ErrorText" ForeColor=" " ControlToValidate="txtUOM" Display="Dynamic">
                                    'Unit' already exist.
                                </asp:CustomValidator>
                                                                    </p>
                                                                    <p>
                                                                        <asp:RequiredFieldValidator id="valFeature" runat="server" CssClass="ErrorText" ForeColor=" " ControlToValidate="txtUOM" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Code."></asp:RequiredFieldValidator>
                                                                    </p>
                                                                    <p>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" ForeColor=" " ControlToValidate="txtUOMDesc" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Description"></asp:RequiredFieldValidator>
                                                                    </p>
                                                                    <p>
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="Server" autopostback="true" Text="Add New"></asp:Button>
                                                                        &nbsp;&nbsp; 
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
