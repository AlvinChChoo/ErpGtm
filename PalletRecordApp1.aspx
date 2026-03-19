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
    if page.ispostback = false then
        if request.cookies("U_ID") is nothing then
            response.redirect("AccessDenied.aspx")
        else
            ProcLoadGridData()
        end if
    End if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
        StrSql = "Select pm.pallet_status,pm.seq_no,PM.PPR_No,PM.jo_no,submit_by,submit_date,app1_by,app1_date,app2_by,app2_date from pallet_Record_M PM where " & trim(cmbBy.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and Submit_By is not null order by seq_no desc"
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"pallet_Record_M")
            GridControl1.DataSource=resExePagedDataSet.Tables("pallet_Record_M").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub SortGrid(s As Object, e As DataGridSortCommandEventArgs)
        ProcLoadGridData()
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub ShowPalletRecord(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
    
        Response.redirect("PalletRecordApp1Det.aspx?ID=" & SeqNo.text)
    End sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim SubmitBy As Label = CType(e.Item.FindControl("SubmitBy"), Label)
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
            Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
            Dim App2By As Label = CType(e.Item.FindControl("App2By"), Label)
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
    
            if trim(SubmitDate.text) <> "" then SubmitBy.text = SubmitBy.text & "-" & format(cdate(SubmitDate.text),"dd/MM/yy")
            if trim(App1Date.text) <> "" then App1By.text = App1By.text & "-" & format(cdate(App1Date.text),"dd/MM/yy")
            if trim(App2Date.text) <> "" then App2By.text = App2By.text & "-" & format(cdate(App2Date.text),"dd/MM/yy")
    
            if App1Date.text = "" then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UCcontent" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" backcolor="" forecolor="" cssclass="FormDesc" width="100%">PALLET
                                RECORD</asp:Label>
                            </p>
                            <p align="center">
                                <table height="100%" cellspacing="0" cellpadding="0" width="98%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="top" width="100%">
                                                <p align="center">
                                                    <table style="HEIGHT: 11px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="HEIGHT: 9px" width="100%" align="center">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label2" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp; 
                                                                                            <asp:TextBox id="txtSearch" runat="server" Width="163px" CssClass="OutputText"></asp:TextBox>
                                                                                            &nbsp; <asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp; 
                                                                                            <asp:DropDownList id="cmbBy" runat="server" Width="167px" CssClass="OutputText">
                                                                                                <asp:ListItem Value="PM.PPR_No">PPR NO</asp:ListItem>
                                                                                                <asp:ListItem Value="PM.JO_No">JOB ORDER NO</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                            <asp:Button id="Button2" onclick="cmdSearch_Click" runat="server" Width="69px" CssClass="OutputText" Text="GO"></asp:Button>
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
                                                <p>
                                                    <table style="HEIGHT: 27px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" AllowSorting="True" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" OnEditCommand="ShowPalletRecord" OnItemDataBound="FormatRow" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager" OnSortCommand="sortGrid" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                                                <asp:TemplateColumn HeaderText="PPR No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PPRNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PPR_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="J/O No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="JONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "JO_no") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Production">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_By") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="FQA">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="FGS">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Status">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PalletStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Pallet_Status") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn visible="false">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
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
                                                                                        <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="111px" Text="Back" CausesValidation="False"></asp:Button>
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
