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
            'Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master order by Part_No asc","Part_No","Desc",cmbpartNo)
            If SortField = "" then SortField = "Part_No"
            'Dissql("select Loc_Code from LOC order by Loc_Code","LOC_CODE","LOC_CODE",cmbLOCCode)
            procLoadGridData ()
            'lblMaxRec.text = cint(ReqGetFieldVal.GetFieldVal("Select Grid_Max_Rec from Main","Grid_Max_Rec"))
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim SortSeq as String = IIF((SortAscending=True),"Asc","Desc")
    
        Dim StrSql as string = "SELECT * FROM PART_LOC WHERE " & cmbBy.selectedItem.value & " like '%" & cstr(txtSearch.Text) & "%'  ORDER BY " & SortField & " "  & SortSeq
    
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"PART_LOC")
        GridControl1.DataSource=resExePagedDataSet.Tables("PART_LOC").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
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
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        'if page.isvalid = true then
        '    Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        '    ReqCOM.ExecuteNonQuery("Insert into Part_Loc(Loc,Part_No) select '" & cmbLOCCode.selecteditem.value & "','" & trim(cmbPartNo.selecteditem.value) & "';")
        '    procLoadGridData ()
        'end if
    End Sub
    
    Sub ValDuplicateRec(sender As Object, e As ServerValidateEventArgs)
        'Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        'if ReqCOM.funcCheckDuplicate("Select Part_no from Part_LOC where Part_no = '" & trim(cmbPartNo.selecteditem.value) & "' and LOC = '" & trim(cmbLocCode.selecteditem.value) & "';","Part_No") = True then
        '    e.isvalid = false
        'else
        '    e.isvalid = true
        'end if
    
    End Sub
    
    Property SortField() As String
             Get
                 Dim o As Object = ViewState("SortField")
                 If o Is Nothing Then
                     Return [String].Empty
                 End If
                 Return CStr(o)
             End Get
             Set(ByVal Value As String)
                 If Value = SortField Then
                     SortAscending = Not SortAscending
                 End If
                 ViewState("SortField") = Value
             End Set
         End Property
    
         Property SortAscending() As Boolean
            Get
                Dim o As Object = ViewState("SortAscending")
    
                If o Is Nothing Then
                    Return True
                End If
                Return CBool(o)
            End Get
            Set(ByVal Value As Boolean)
                ViewState("SortAscending") = Value
            End Set
         End Property
    
    
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        ProcLoadGridData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdAddNew_Click_1(sender As Object, e As EventArgs)
        response.redirect("PartLocationAdd.aspx")
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
    
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQuery("Delete from Part_Loc where Seq_No = " & trim(SeqNo.text) & ";"):Response.redirect("PartLocation.aspx")
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" backcolor="" cssclass="FormDesc">PART
                                LOCATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="70%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 21px" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <table style="WIDTH: 100%; HEIGHT: 7px">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Label id="Label3" runat="server" cssclass="OutputText">Search </asp:Label>&nbsp;<asp:TextBox id="txtSearch" runat="server" Width="141px" CssClass="OutputText"></asp:TextBox>
                                                                                &nbsp;<asp:Label id="Label2" runat="server" cssclass="OutputText">By </asp:Label>&nbsp;<asp:DropDownList id="cmbBy" runat="server" Width="102px" CssClass="OutputText">
                                                                                    <asp:ListItem Value="Part_No">Part No</asp:ListItem>
                                                                                    <asp:ListItem Value="LOC">Location</asp:ListItem>
                                                                                </asp:DropDownList>
                                                                            </td>
                                                                            <td colspan="3">
                                                                                <div align="center">
                                                                                    <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="103px" CausesValidation="False" Text="Quick Search" CssClass="OutputText"></asp:Button>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" OnPageIndexChanged="OurPager" AllowPaging="True" BorderColor="Black" GridLines="None" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" OnItemCommand="ItemCommand">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="PART NO">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> <asp:Label id="lblPartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="LOCATION">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblLocation" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "LOC") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn>
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgDelete" ToolTip="Delete this item" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click_1" runat="server" Width="161px" Text="Add New Part Location" CssClass="OutputText"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="161px" Text="Back" CssClass="OutputText"></asp:Button>
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
