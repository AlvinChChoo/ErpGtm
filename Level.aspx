<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="erp" TagName="Header" Src="_Header.ascx" %>
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
            Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            If SortField = "" then SortField = "Level_Code"
            procLoadGridData ()
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim SortSeq as String = IIF((SortAscending=True),"Asc","Desc")
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSQL as string = "SELECT * FROM P_Level where level_code + Level_Desc like '%" & trim(txtSearch.text) & "%'  ORDER BY " & SortField & " "  & SortSeq
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"P_Level")
        GridControl1.DataSource=resExePagedDataSet.Tables("P_Level").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim SeqNo As Label = CType(GridControl1.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from P_Level where Level_Code = '" & trim(SeqNo.text) & "';")
                end if
            Catch
    
            End Try
        Next
        procLoadGridData ()
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
    
    Sub cmdback_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        ShowPopup("LevelAddNew.aspx")
        redirectPage("Level.aspx")
    End Sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        ProcLoadGridData
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        ProcLoadGridData
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="28" background="Frame-Top-left.jpg" height="28">
                                                            </td>
                                                            <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                Production&nbsp;Level&nbsp;List</td>
                                                            <td width="28" background="Frame-Top-right.jpg">
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <div align="center">
                                                                    <p>
                                                                        <br />
                                                                        <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label1" runat="server">SEARCH</asp:Label>&nbsp; &nbsp; 
                                                                                            <asp:TextBox id="txtSearch" runat="server" Width="101px" CssClass="input_box"></asp:TextBox>
                                                                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                            <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" Text="SEARCH" CssClass="OutputText"></asp:Button>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        <br />
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="96%" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Black" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" AllowSorting="True" OnSortCommand="SortGrid" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn SortExpression="Level_Code" HeaderText="LEVEL">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Level_Code") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="Level_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PC_SCH_DAYS" HeaderText="Sch. Days"></asp:BoundColumn>
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
                                                                        <br />
                                                                    </p>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p align="right">
                                                    <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" CausesValidation="False" Text="Add New Level" Width="171px" CssClass="submit_button"></asp:Button>
                                                                </td>
                                                                <td width="28%">
                                                                    <p align="center">
                                                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" CausesValidation="False" Text="Remove Selected Item(s)" Width="171px" CssClass="submit_button"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Text="Refresh" Width="171px" CssClass="submit_button"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="22%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdback" onclick="cmdback_Click" runat="server" CausesValidation="False" Text="Back" Width="171px" CssClass="submit_button"></asp:Button>
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
                            <footer:footer id="footer" runat="server"></footer:footer>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
