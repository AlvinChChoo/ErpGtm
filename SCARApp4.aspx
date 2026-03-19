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
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if page.isPostBack = false then
            If SortField = "" then SortField = "MIF_NO"
            LoadDataWithSource()
        End if
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
    
    Sub LoadDataWithSource()
        Dim SortSeq,StrSql as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim resExePagedDataSet as Dataset
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        StrSql = "Select s.scar_status,s.create_By,s.create_date,s.app1_by,s.app1_date,s.app2_by,s.app2_date,s.app3_date,s.app3_by,s.app4_date,s.app4_by,S.scar_no,s.ven_code,s.mif_no,s.part_no,ven.ven_name from scar s,vendor ven where s.ven_code = ven.ven_code and app3_by is not null order by scar_no desc"
        resExePagedDataSet = ReqCom.ExePagedDataSet(StrSql,"MIF_M")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("MIF_M").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Sub ShowSO(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ScarNo As Label = CType(e.Item.FindControl("ScarNo"), Label)
        Dim SeqNo as integer = ReqCOM.GetFieldVal("Select Seq_No from SCAR where SCAR_NO = '" & trim(ScarNo.text) & "';","Seq_No")
        Response.redirect("SCARApp4Det.aspx?ID=" & SeqNo)
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim CreateBy As Label = CType(e.Item.FindControl("CreateBy"), Label)
            Dim CreateDate As Label = CType(e.Item.FindControl("CreateDate"), Label)
            Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
            Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
            Dim App2By As Label = CType(e.Item.FindControl("App2By"), Label)
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
            Dim App3By As Label = CType(e.Item.FindControl("App3By"), Label)
            Dim App3Date As Label = CType(e.Item.FindControl("App3Date"), Label)
            Dim App4By As Label = CType(e.Item.FindControl("App4By"), Label)
            Dim App4Date As Label = CType(e.Item.FindControl("App4Date"), Label)
    
            if App1Date.text <> "" then App1By.text = App1By.text & "-" & format(cdate(App1Date.text),"dd/MM/yy")
            if App2Date.text <> "" then App2By.text = App2By.text & "-" & format(cdate(App2Date.text),"dd/MM/yy")
            if App3Date.text <> "" then App3By.text = App3By.text & "-" & format(cdate(App3Date.text),"dd/MM/yy")
            if App4Date.text <> "" then App4By.text = App4By.text & "-" & format(cdate(App4Date.text),"dd/MM/yy")
            if CreateBy.text <> "" then CreateBy.text = CreateBy.text & "-" & format(cdate(CreateDate.text),"dd/MM/yy")
        End if
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        LoadDataWithSource()
    End Sub
    
    Sub cmdNew_Click(sender As Object, e As EventArgs)
        Response.redirect("MIFAddNew.aspx")
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">SUPPLIER CORRECTIVE
                                ACTION REPORT (SCAR)</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnItemDataBound="FormatRow" AllowSorting="True" OnSortCommand="SortGrid" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" OnEditCommand="ShowSO">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                            <asp:TemplateColumn HeaderText="SCAR #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SCARNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SCAR_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Supplier">
                                                                <ItemTemplate>
                                                                    <asp:Label id="VenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ven_name") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MIF #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MIFNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MIF_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Part #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Create By/Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CreateBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Create_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Ver. By/Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="App. By/Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Purc. By/Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="IQC. By/Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App4By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App4Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CreateDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Create_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SCARStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Scar_Status") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="120px" Text="Back"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
