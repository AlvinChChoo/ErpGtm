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
            If SortField = "" then SortField = "Module_Name"
            procLoadGridData()
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        procLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim SortSeq as String
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
    
    
    
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
        if txtsearch.text = "" then
            StrSql = "SELECT * FROM ERP_MANUAL ORDER BY " & SortField & " " & SortSeq & ";"
        elseif txtsearch.text <> "" then
            if cmbSearchBy.selectedItem.value = "MODULE_NAME" then
                StrSql = "SELECT * FROM ERP_MANUAL where module_name like '%" & trim(txtSearch.text) & "%' ORDER BY " & SortField & " " & SortSeq & ";"
            elseif cmbSearchBy.selectedItem.value = "APPLY_TO" then
                StrSql = "SELECT * FROM ERP_MANUAL where apply_to like '%" & trim(txtSearch.text) & "%'  ORDER BY " & SortField & " " & SortSeq & ";"
            end if
        end if
    
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"ERP_MANUAL")
        GridControl1.DataSource=resExePagedDataSet.Tables("ERP_MANUAL").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
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
        procLoadGridData ()
    End Sub
    
    Sub ShowManual(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim FileName as string = "Manual/" & ReqCOM.GetFieldVal("Select File_Name from ERP_Manual where Seq_no = " & SeqNo.text & ";","File_Name")
                'ShowPopup("popupSSERAtt.aspx?ID=" & Request.params("ID"))
        ShowPopUp(FileName)
    End sub
    
    Sub ShowPopUp(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowPopupManual", Script.ToString())
    End sub
    
    Sub cmdback_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        ProcLoadGridData
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
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
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" backcolor="" cssclass="FormDesc">USER
                                MANUALS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 23px" cellspacing="0" cellpadding="0" width="86%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center"><asp:Label id="Label2" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp; 
                                                                        <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                        &nbsp;&nbsp; <asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp; 
                                                                        <asp:DropDownList id="cmbSearchBy" runat="server" CssClass="OutputText" Width="223px">
                                                                            <asp:ListItem Value="MODULE_NAME">MODULE NAME</asp:ListItem>
                                                                            <asp:ListItem Value="APPLY_TO">APPLY TO</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp; 
                                                                        <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" CssClass="OutputText" Text="Search"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" AllowSorting="True" OnSortCommand="SortGrid" OnEditCommand="Showmanual" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                            <asp:BoundColumn DataField="File_Name" HeaderText="FILE NAME"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Module_Name" SortExpression="Module_Name" HeaderText="MODULE"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Apply_To" SortExpression="Apply_To" HeaderText="APPLY TO"></asp:BoundColumn>
                                                            <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadManual.aspx?ID={0}"></asp:HyperLinkColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdback" onclick="cmdback_Click" runat="server" Width="84px" Text="Back"></asp:Button>
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
