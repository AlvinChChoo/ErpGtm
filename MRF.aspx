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
        if page.ispostback = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            procLoadGridData()
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim SortSeq as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim StrSql as string
            StrSql = "Select SM.Model_No,MM.MRF_NO,MM.JO_No,MM.P_Level,MM.Submit_By,MM.Submit_Date,MM.App1_By,MM.App2_By,MM.App3_By,MM.App4_By,MM.App1_Date,MM.App2_Date,MM.App3_Date,MM.App4_Date,MM.MRF_Status,JM.Lot_No from MRF_M MM,Job_Order_M JM,SO_Models_M SM where mm.jo_no = jm.jo_no and jm.lot_no = sm.lot_no order by MRF_No desc"
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MRF_M")
            dtgShortage.visible = true
            dtgShortage.DataSource=resExePagedDataSet.Tables("MRF_M").DefaultView
            dtgShortage.DataBind()
     end sub
    
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
    
     Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
     End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
            Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
            Dim App2By As Label = CType(e.Item.FindControl("App2By"), Label)
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
            Dim App3By As Label = CType(e.Item.FindControl("App3By"), Label)
            Dim App3Date As Label = CType(e.Item.FindControl("App3Date"), Label)
            Dim App4By As Label = CType(e.Item.FindControl("App4By"), Label)
            Dim App4Date As Label = CType(e.Item.FindControl("App4Date"), Label)
            Dim SubmitBy As Label = CType(e.Item.FindControl("SubmitBy"), Label)
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim MRFStatus As Label = CType(e.Item.FindControl("MRFStatus"), Label)
    
            if trim(SubmitDate.text) <> "" then SubmitBy.text = SubmitBy.text & " - " & format(cdate(SubmitDate.text),"dd/MMM/yy-hh:mm")
            if trim(App1Date.text) <> "" then App1By.text = App1By.text & " - " & format(cdate(App1Date.text),"dd/MMM/yy-hh:mm")
            if trim(App2Date.text) <> "" then App2By.text = App2By.text & " - " & format(cdate(App2Date.text),"dd/MMM/yy-hh:mm")
            if trim(App3Date.text) <> "" then App3By.text = App3By.text & " - " & format(cdate(App3Date.text),"dd/MMM/yy-hh:mm")
            if trim(App4Date.text) <> "" then App4By.text = App4By.text & " - " & format(cdate(App4Date.text),"dd/MMM/yy-hh:mm")
        End if
    End Sub
    
    Sub ShowMRF(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim MRFNo As Label = CType(e.Item.FindControl("MRFNo"), Label)
        Dim SeqNo as integer = ReqCOM.GetFieldVal("Select Seq_No from MRF_M where MRF_NO = '" & trim(MRFNo.text) & "';","Seq_No")
        Response.redirect("MRFDet.aspx?ID=" & SeqNo)
    End sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        ProcLoadGridData()
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        Response.redirect("MRFAddNew.aspx")
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">MATERIAL RETURN
                                FORM</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Label id="lblUserRole" runat="server" width="291px" visible="False"></asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" OnEditCommand="ShowMRF" Font-Size="XX-Small" Font-Name="Verdana" Font-Names="Verdana" AllowSorting="True" OnSortCommand="SortGrid" OnItemDataBound="FormatRow" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="100" Height="35px" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                            <asp:TemplateColumn HeaderText="MRF No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MRFNo" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "MRF_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="J/O #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="JONo" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "JO_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Section">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PLevel" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "P_Level") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Lot No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LotNo" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Model">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModelNo" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submitted By">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitBy" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Submit_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitDate" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Approved">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1By" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PCMC">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2By" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="IQC">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3By" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "App3_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Store">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App4By" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "App4_By") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1Date" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "App1_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2Date" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "App2_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3Date" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "App3_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App4Date" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "App4_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MRFStatus" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "MRF_Status") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 25px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="50%">
                                                                    <div align="left">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Text="Register new MRF" Width="158px"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="50%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="114px"></asp:Button>
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
        <p align="left">
        </p>
    </form>
</body>
</html>
