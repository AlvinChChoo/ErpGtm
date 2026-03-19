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
            Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            procLoadGridData ()
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "SELECT * FROM Dept WHERE Dept like '%" & cstr(txtSearch.Text) & "%'  ORDER BY Dept ASC"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Dept")
        GridControl1.DataSource=resExePagedDataSet.Tables("Dept").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        ProcLoadGridData()
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Dim ReqCom as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if page.isvalid = true then
            ReqCOM.ExecuteNonQuery("Insert into Dept(Dept) select '" & UCASE(trim(txtDept.text)) & "';")
            txtDept.text = ""
            response.redirect("Department.aspx")
        end if
    End Sub
    
    Sub ValDuplicateColor(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select Dept from Dept where Dept = '" & trim(txtDept.text) & "';","Color_desc") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim Dept As Label = CType(GridControl1.Items(i).FindControl("Dept"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then ReqCOM.ExecuteNonQuery("Delete from Dept where Dept = '" & trim(Dept.text) & "';")
            Catch
            End Try
        Next
        procLoadGridData ()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">DEPARTMENT
                                MAINTENANCE</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="92%" align="center">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p>
                                                    <table style="HEIGHT: 17px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="WIDTH: 100%; HEIGHT: 19px">
                                                                        <tbody>
                                                                            <tr valign="top">
                                                                                <td>
                                                                                    <asp:Label id="Label3" runat="server" cssclass="OutputText">Search by Department</asp:Label>&nbsp;&nbsp;&nbsp; 
                                                                                    <asp:TextBox id="txtSearch" runat="server" Width="315px"></asp:TextBox>
                                                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                                                <td valign="top" colspan="2">
                                                                                    <div align="left">
                                                                                    </div>
                                                                                    <div align="right">
                                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="58px" CausesValidation="False" Text="GO"></asp:Button>
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
                                                    <table style="HEIGHT: 12px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False">
                                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                        <Columns>
                                                                            <asp:TemplateColumn HeaderText="Department">
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="Dept" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Dept") %>' /> 
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
                                                                    <p align="right">
                                                                        <asp:Button id="cmdpdate" onclick="cmdpdate_Click" runat="server" Width="176px" CausesValidation="False" Text="Remove Selected Item(s)"></asp:Button>
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
                                                                    <p align="center">
                                                                        <asp:Label id="Label7" runat="server" cssclass="Instruction" width="100%">To add new
                                                                        Department, key in Department Code and click 'Add New' </asp:Label>
                                                                    </p>
                                                                    <p>
                                                                    </p>
                                                                    <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    &nbsp;&nbsp; <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="99px">Department</asp:Label></td>
                                                                                <td>
                                                                                    <div align="center">
                                                                                        <asp:TextBox id="txtDept" runat="server" Width="299px" MaxLength="100"></asp:TextBox>
                                                                                    </div>
                                                                                </td>
                                                                                <td>
                                                                                    <div align="right">
                                                                                        <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Width="80px" Text="Add New"></asp:Button>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <p>
                                                                        <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" ForeColor=" " CssClass="ErrorText" OnServerValidate="ValDuplicateColor" ErrorMessage="Department Code already exist." ControlToValidate="txtDept" Display="Dynamic"></asp:CustomValidator>
                                                                    </p>
                                                                    <p>
                                                                        <asp:RequiredFieldValidator id="valFeature" runat="server" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Department Code." ControlToValidate="txtDept" Display="Dynamic"></asp:RequiredFieldValidator>
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
