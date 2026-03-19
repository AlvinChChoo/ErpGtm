<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
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
            procLoadGridData()
        end if
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
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
    
        'if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' order by seq_no desc"
        'if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' order by seq_no desc"
        if trim(cmbSearch.selecteditem.value) = "FECN_No" then
            if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "ECN_No" then
            if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "MODEL_NO" then
            if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "PART_NO" then
            if trim(cmbFECNStatus.selecteditem.value) =  "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND fecn_no in (Select Fecn_No from fecn_d where main_part_b4 like '%" & trim(txtSearch.text) & "%' or main_part like '%" & trim(txtSearch.text) & "%' or alt_part_b4 like '%" & trim(txtSearch.text) & "%' or alt_part like '%" & trim(txtSearch.text) & "%') ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND fecn_no in (Select Fecn_No from fecn_d where main_part_b4 like '%" & trim(txtSearch.text) & "%' or main_part like '%" & trim(txtSearch.text) & "%' or alt_part_b4 like '%" & trim(txtSearch.text) & "%' or alt_part like '%" & trim(txtSearch.text) & "%') AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "LOT_NO" then
            if trim(cmbFECNStatus.selecteditem.value) =  "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND fecn_no in (Select Fecn_No from fecn_d where lot_no like '%" & trim(txtSearch.text) & "%') ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where Submit_by is not null AND fecn_no in (Select Fecn_No from fecn_d where lot_no like '%" & trim(txtSearch.text) & "%') AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"FECN_M")
        Dim DV as New DataView(resExePagedDataSet.Tables("FECN_M"))
        GridControl1.DataSource=DV
        GridControl1.DataBind()
    end sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        ProcLoadGridData()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
            Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
            Dim App2By As Label = CType(e.Item.FindControl("App2By"), Label)
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
            Dim App3By As Label = CType(e.Item.FindControl("App3By"), Label)
            Dim App3Date As Label = CType(e.Item.FindControl("App3Date"), Label)
            Dim App4By As Label = CType(e.Item.FindControl("App4By"), Label)
            Dim App4Date As Label = CType(e.Item.FindControl("App4Date"), Label)
            Dim App5By As Label = CType(e.Item.FindControl("App5By"), Label)
            Dim App5Date As Label = CType(e.Item.FindControl("App5Date"), Label)
            Dim App6By As Label = CType(e.Item.FindControl("App6By"), Label)
            Dim App6Date As Label = CType(e.Item.FindControl("App6Date"), Label)
            Dim SubmitBy As Label = CType(e.Item.FindControl("SubmitBy"), Label)
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim Status As Label = CType(e.Item.FindControl("Status"), Label)
            Dim NewFECNNo As Label = CType(e.Item.FindControl("NewFECNNo"), Label)
            Dim Urgent As Label = CType(e.Item.FindControl("Urgent"), Label)
    
    
            if Trim(SubmitDate.text) <> "" then SubmitBy.text = SubmitBy.text & "-" & format(cdate(SubmitDate.text),"dd/MM/yy")
            if Trim(App1Date.text) <> "" then App1By.text = App1By.text & "-" & format(cdate(App1Date.text),"dd/MM/yy")
            if Trim(App2Date.text) <> "" then App2By.text = App2By.text & "-" & format(cdate(App2Date.text),"dd/MM/yy")
            if Trim(App3Date.text) <> "" then App3By.text = App3By.text & "-" & format(cdate(App3Date.text),"dd/MM/yy")
            if Trim(App4Date.text) <> "" then App4By.text = App4By.text & "-" & format(cdate(App4Date.text),"dd/MM/yy")
            if Trim(App5Date.text) <> "" then App5By.text = App5By.text & "-" & format(cdate(App5Date.text),"dd/MM/yy")
            if Trim(App6Date.text) <> "" then App6By.text = App6By.text & "-" & format(cdate(App6Date.text),"dd/MM/yy")
            if trim(App1Date.text) = "" and trim(ucase(Status.text)) <> "REJECTED" then e.Item.CssClass = "PartSource"
            if trim(App1Date.text) = "" and trim(ucase(Status.text)) <> "REJECTED" and trim(ucase(Urgent.text)) = "Y" then e.Item.CssClass = "Urgent"
        End if
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        ProcLoadGridData
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">FECN
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 7px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="Label1" runat="server" cssclass="OutputText">SEARCH</asp:Label>
                                                    <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="101px"></asp:TextBox>
                                                    &nbsp;<asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;<asp:DropDownList id="cmbSearch" runat="server" CssClass="OutputText" Width="113px">
                                                        <asp:ListItem Value="FECN_No">FECN NO</asp:ListItem>
                                                        <asp:ListItem Value="ECN_No">ECN NO</asp:ListItem>
                                                        <asp:ListItem Value="MODEL_NO">MODEL NO</asp:ListItem>
                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                        <asp:ListItem Value="LOT_NO">LOT NO</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;<asp:Label id="Label4" runat="server" cssclass="OutputText">SHOW</asp:Label>&nbsp;<asp:DropDownList id="cmbFECNStatus" runat="server" CssClass="OutputText" Width="172px">
                                                        <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING APPROVAL">PENDING APPROVAL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                        <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                        <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;<asp:Label id="Label5" runat="server" cssclass="OutputText">FECN</asp:Label>&nbsp;<asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Width="90px" Text="GO"></asp:Button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 27px" width="94%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    &nbsp;<asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" OnPageIndexChanged="OurPager" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" OnSortCommand="SortGrid" AllowSorting="True">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:HyperLinkColumn Text="View" DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="FECNApp1Det.aspx?ID={0}"></asp:HyperLinkColumn>
                                                            <asp:BoundColumn DataField="FECN_NO" SortExpression="FECN_NO" HeaderText="FECN No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Model_No" SortExpression="Model_No" HeaderText="Model No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ECN_NO" SortExpression="ECN_NO" HeaderText="ECN No"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="SUBMIT">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SUBMIT_BY") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Elec. Eng.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Mech. Eng.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="R&D HOD">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PCMC App.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App4By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="A/C App.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App5By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App5_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Mgt. App.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App6By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App6_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App4Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App5Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App5_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App6Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App6_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FECN_Status") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="New Ref." >
                                                                <ItemTemplate>
                                                                    <asp:Label id="NewFECNNo" width="" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "New_FECN_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Urgent" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Urgent") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="10%" bgcolor="red">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label6" runat="server" width="100%" cssclass="OutputText">Urgent
                                                                    FECN Pending Approval</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="yellow">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label7" runat="server" width="100%" cssclass="OutputText">Normal
                                                                    FECN Pending Approval</asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="120px" Text="Back"></asp:Button>
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
