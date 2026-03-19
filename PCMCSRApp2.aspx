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
                 if request.cookies("U_ID") is nothing then
                     response.redirect("AccessDenied.aspx")
                 else
                     Dim OurCommand as sqlcommand
                     Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                     ProcLoadGridData("SELECT * FROM SR_M where App1_date is not null order by seq_no desc")
                 end if
             else
                 if request.cookies("U_ID") is nothing then
                     response.redirect("AccessDenied.aspx")
                 else
                     Dim OurCommand as sqlcommand
                     Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                 end if
             end if
         End Sub
    
         Sub OurPager(sender as object,e as datagridpagechangedeventargs)
            gridControl1.CurrentPageIndex = e.NewPageIndex
            ProcLoadGridData("SELECT * FROM SR_M where App1_date is not null order by seq_no desc")
         end sub
    
         Sub ProcLoadGridData(StrSql as string)
             Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
             Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SR_M")
             GridControl1.DataSource=resExePagedDataSet.Tables("SR_M").DefaultView
             GridControl1.DataBind()
         end sub
    
    
    
    
         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdMain_Click(sender As Object, e As EventArgs)
             response.redirect("Main.aspx")
         End Sub
    
         Sub Button2_Click(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdAddNew_Click(sender As Object, e As EventArgs)
             response.redirect("CustomerAddNew.aspx")
         End Sub
    
        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                Dim SubmitBy As Label = CType(e.Item.FindControl("SubmitBy"), Label)
                Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
                Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
                Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
                Dim App2By As Label = CType(e.Item.FindControl("App2By"), Label)
                Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
                Dim App3By As Label = CType(e.Item.FindControl("App3By"), Label)
                Dim App3Date As Label = CType(e.Item.FindControl("App3Date"), Label)
                Dim App4By As Label = CType(e.Item.FindControl("App4By"), Label)
                Dim App4Date As Label = CType(e.Item.FindControl("App4Date"), Label)
                Dim SRStatus As Label = CType(e.Item.FindControl("SRStatus"), Label)
    
                if trim(submitDate.text) <> "" then submitBy.text = trim(submitBy.text) & " - " & format(cdate(submitDate.text),"dd/MMM/yy")
                if trim(submitDate.text) = "" then submitBy.text = "-"
    
                if trim(App1Date.text) <> "" then App1By.text = trim(App1By.text) & " - " & format(cdate(App1Date.text),"dd/MMM/yy")
                if trim(App1Date.text) = "" then App1By.text = "-"
    
                if trim(App2Date.text) <> "" then App2By.text = trim(App2By.text) & " - " & format(cdate(App2Date.text),"dd/MMM/yy")
                if trim(App2Date.text) = "" then App2By.text = "-"
    
                if trim(App3Date.text) <> "" then App3By.text = trim(App3By.text) & " - " & format(cdate(App3Date.text),"dd/MMM/yy")
                if trim(App3Date.text) = "" then App3By.text = "-"
    
                if trim(App4Date.text) <> "" then App4By.text = trim(App4By.text) & " - " & format(cdate(App4Date.text),"dd/MMM/yy")
                if trim(App4Date.text) = "" then App4By.text = "-"
    
                if trim(SRStatus.text) <> "REJECTED" then
                    if trim(App2Date.text) = "" then e.Item.CssClass = "PartSource"
                end if
            end if
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
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 23px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SPECIAL REQUEST
                                LIST</asp:Label>
                            </p>
                            <div align="center">&nbsp;<asp:DataGrid id="GridControl1" runat="server" width="90%" OnItemDataBound="FormatRow" Font-Names="Verdana" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" OnPageIndexChanged="OurPager" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="2" Font-Name="Verdana" Font-Size="XX-Small" ShowFooter="True" AutoGenerateColumns="False">
                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                    <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <Columns>
                                        <asp:HyperLinkColumn DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="PCMCSRApp2Det.aspx?ID={0}" DataTextField="SR_NO" HeaderText="SR No"></asp:HyperLinkColumn>
                                        <asp:TemplateColumn HeaderText="Submit">
                                            <ItemTemplate>
                                                <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_By") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Buyer">
                                            <ItemTemplate>
                                                <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="PCMC">
                                            <ItemTemplate>
                                                <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Purc HOD">
                                            <ItemTemplate>
                                                <asp:Label id="App3By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_By") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="P/O Gen.">
                                            <ItemTemplate>
                                                <asp:Label id="App4By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_By") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="False">
                                            <ItemTemplate>
                                                <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="False">
                                            <ItemTemplate>
                                                <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_Date") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="False">
                                            <ItemTemplate>
                                                <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_Date") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="False">
                                            <ItemTemplate>
                                                <asp:Label id="App3Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_Date") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="False">
                                            <ItemTemplate>
                                                <asp:Label id="App4Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_Date") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Status">
                                            <ItemTemplate>
                                                <asp:Label id="SRStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SR_Status") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                </asp:DataGrid>
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td width="50%">
                                            </td>
                                            <td width="50%">
                                                <div align="right">
                                                    <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="173px"></asp:Button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
