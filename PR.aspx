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
        if page.ispostback = false then procLoadGridData ()
    End Sub
    
    Sub ProcLoadGridData()
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim CurrMRPNo as integer = ReqCOM.GetFieldVal("Select MRP_No from Main","Mrp_No") - 1
        Dim StrSql as string = "Select buyer.u_id,PR.PR_NO,PR.BUYER_CODE,PR.SUBMIT_BY,PR.APP1_BY,PR.APP2_BY,PR.APP3_BY,PR.APP4_BY,PR.APP5_BY,PR.APP1_DATE,PR.APP2_DATE,PR.APP3_DATE,PR.APP4_DATE,PR.APP5_DATE,PR.SEQ_NO,PR.PR_STATUS,PR.SUBMIT_DATE from pr1_m PR,bUYER BUYER WHERE PR.BUYER_CODE = BUYER.BUYER_CODE order by PR.Seq_No desc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MRP_D")
        dtgShortage.DataSource=resExePagedDataSet.Tables("MRP_D").DefaultView
        dtgShortage.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
            Dim App3Date As Label = CType(e.Item.FindControl("App3Date"), Label)
            Dim App4Date As Label = CType(e.Item.FindControl("App4Date"), Label)
            Dim App5Date As Label = CType(e.Item.FindControl("App5Date"), Label)
    
            if trim(SubmitDate.text) <> "" then SubmitDate.text = format(cdate(SubmitDate.text),"dd/MM/yy")
            if trim(App1Date.text) <> "" then App1Date.text = format(cdate(App1Date.text),"dd/MM/yy")
            if trim(App2Date.text) <> "" then App2Date.text = format(cdate(App2Date.text),"dd/MM/yy")
            if trim(App3Date.text) <> "" then App3Date.text = format(cdate(App3Date.text),"dd/MM/yy")
            if trim(App4Date.text) <> "" then App4Date.text = format(cdate(App4Date.text),"dd/MM/yy")
            if trim(App5Date.text) <> "" then App5Date.text = format(cdate(App5Date.text),"dd/MM/yy")
            if trim(SubmitDate.text) = "" then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        dtgShortage.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub LinkButton1_Click(sender As Object, e As EventArgs)
        Response.redirect("PR.aspx")
    End Sub
    
    Sub LinkButton2_Click(sender As Object, e As EventArgs)
        Response.redirect("PRApp2.aspx")
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("PRDet.aspx?ID=" & clng(SeqNo.text))
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
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
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td width="50%" bgcolor="silver">
                                                <div align="center">
                                                    <asp:LinkButton id="LinkButton1" onclick="LinkButton1_Click" runat="server">P/R Submission</asp:LinkButton>
                                                </div>
                                            </td>
                                            <td width="50%" bgcolor="white">
                                                <div align="center">
                                                    <asp:LinkButton id="LinkButton2" onclick="LinkButton2_Click" runat="server">P/R Approval</asp:LinkButton>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">P/R LIST (SUBMISSION)</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="98%" OnItemCommand="ItemCommand" OnItemDataBound="FormatRow" AutoGenerateColumns="False" Font-Size="XX-Small" Font-Name="Verdana" cellpadding="4" BorderColor="Gray" PageSize="20" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Font-Names="Verdana" Height="35px" AllowPaging="True" OnPageIndexChanged="OurPager">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn >
                                                                <ItemTemplate>
                                                                    <asp:Hyperlink ID="Hyperlink2" ToolTip="View this P/R" imageURL="view.gif" Runat="Server" NavigateUrl= <%#"PRDet.aspx?id=" + DataBinder.Eval(Container.DataItem,"Seq_No").ToString() + "" %>></asp:Hyperlink>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn >
                                                            <asp:TemplateColumn HeaderText="PR #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PRNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_NO") %>' /> <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' visible= "false" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Buyer">
                                                                <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Left"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="buyer" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Buyer_Code") %>' /> (<asp:Label id="uid" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "U_ID") %>' />) 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit By">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_By") %>' /> - <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Buyer">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> - <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PCMC">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> - <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Buyer HOD">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_By") %>' /> - <asp:Label id="App3Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Mgt">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App4By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_By") %>' /> - <asp:Label id="App4Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="P/O Gen.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App5By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App5_By") %>' /> - <asp:Label id="App5Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App5_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_STATUS") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 17px" width="98%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <div align="right">
                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="135px" Text="Back"></asp:Button>
                                                                        </div>
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
