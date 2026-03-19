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
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dissql("Select Country from Country order by Country asc","Country","Country",cmbCountry)
            procLoadGridData ()
    
        end if
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
            with obj
                .items.clear
                .DataSource = ResExeDataReader
                .DataValueField = trim(FValue)
                .DataTextField = trim(FText)
                .DataBind()
            end with
            ResExeDataReader.close()
        End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        'Dim StrSql as string = "SELECT * FROM TERRITORY WHERE T_STATE+T_COUNTRY like '%" & cstr(txtSearch.Text) & "%'  ORDER BY T_STATE ASC"
        Dim StrSql as string = "SELECT * FROM TERRITORY WHERE " & trim(cmbby.selectedItem.value) & " like '%" & cstr(txtSearch.Text) & "%'  ORDER BY T_STATE ASC"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"TERRITORY")
        GridControl1.DataSource=resExePagedDataSet.Tables("TERRITORY").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("TerritoryAddNew.aspx")
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim State As Label = CType(GridControl1.Items(i).FindControl("lblState"), Label)
            Dim Country As Label = CType(GridControl1.Items(i).FindControl("lblCountry"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from Territory where T_State = '" & trim(State.text) & "' and T_Country = '" & trim(Country.text) & "';")
                end if
            Catch
    
            End Try
        Next
        procLoadGridData ()
    End Sub
    
    Sub ValDuplicateRec(sender As Object, e As ServerValidateEventArgs)
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.Erp_Gtm
            if ReqCOM.GetFieldVal("Select * from TERRITORY where T_State = '" & trim(txtState.text) & "' and T_Country = '" & trim(cmbCountry.selectedItem.value) & "';","t_cOUNTRY") <> "" then
                e.isvalid = false
            else
                e.isvalid = true
            end if
        End Sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim StrSql as string = "Insert into Territory(T_State,T_Country) select '" & trim(txtState.text) & "','" & trim(cmbCountry.selectedItem.value) & "';"
            ReqCOM.ExecuteNonQuery(StrSQl)
            procLoadGridData()
        end if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">TERRITORY
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="94%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="WIDTH: 100%; HEIGHT: 51px" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <table style="WIDTH: 100%; HEIGHT: 7px">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label id="Label3" runat="server" cssclass="OutputText">Search</asp:Label>&nbsp;&nbsp; 
                                                                                <asp:TextBox id="txtSearch" runat="server" Width="184px" CssClass="OutputText"></asp:TextBox>
                                                                                &nbsp;&nbsp; <asp:Label id="Label4" runat="server" cssclass="OutputText">By</asp:Label>&nbsp;&nbsp; 
                                                                                <asp:DropDownList id="cmbBy" runat="server" Width="187px" CssClass="OutputText">
                                                                                    <asp:ListItem Value="T_State">State</asp:ListItem>
                                                                                    <asp:ListItem Value="T_Country">Country</asp:ListItem>
                                                                                </asp:DropDownList>
                                                                            </td>
                                                                            <td colspan="3">
                                                                                &nbsp; 
                                                                                <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="58px" Text="GO" CausesValidation="False"></asp:Button>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 18px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="STATE">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblState" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "T_State") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="COUNTRY">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblCountry" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "T_COUNTRY") %>' /> 
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
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="185px" Text="Remove Selected Item(s)" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 8px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="454px">To add
                                                                        new Territory, key in State, Country and click 'Add New'</asp:Label>
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 52px" width="100%" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <font size="2">State&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font></td>
                                                                                    <td>
                                                                                        <div align="left">
                                                                                            <asp:TextBox id="txtState" runat="server" Width="257px" Font-Size="" CssClass="OutputText"></asp:TextBox>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                        <font size="2">Country</font></td>
                                                                                    <td>
                                                                                        <asp:DropDownList id="cmbCountry" runat="server" Width="257px" CssClass="OutputText"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <asp:RequiredFieldValidator id="ValState" runat="server" Font-Size="" CssClass="ErrorText" ForeColor=" " Font-Name="" Font-Names="" Display="Dynamic" ControlToValidate="txtState" ErrorMessage="'State' must not be left blank."></asp:RequiredFieldValidator>
                                                                    </p>
                                                                    <p>
                                                                        <asp:CustomValidator id="ValDuplicateRec1" runat="server" Font-Size="" CssClass="ErrorText" ForeColor=" " Font-Name="" Display="Dynamic" ControlToValidate="txtState" OnServerValidate="ValDuplicateRec">'Territory' already exist.</asp:CustomValidator>
                                                                    </p>
                                                                    <p>
                                                                        <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Add New"></asp:Button>
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