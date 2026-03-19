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
                     procLoadGridData
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
            GridControl1.CurrentPageIndex = e.NewPageIndex
            ProcLoadGridData
        end sub
    
        Sub ProcLoadGridData
            'Dim StrSql as string = "select mm.cust_code,MM.MODEL_DESC,SF.MODEL_NO,sf.forecast_date,SF.FORECAST_QTY,SF.UP from SFAS_D SF, MODEL_MASTER MM where sfas_no = '" & trim(lblSFASNo.text) & "' AND MM.model_code = SF.MODEL_NO;"
            Dim StrSql as string = "select app1_by,app2_by,app1_date,app2_date,sfas_status,submit_by,submit_date,seq_no,SFAS_NO from SFAS_M where App1_Date is not null"
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
            Dim ForecastDate,SubmitBy,SubmitDate,App1By,App2By,App1Date,App2Date As Label
    
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                ForecastDate = CType(e.Item.FindControl("ForecastDate"), Label)
                SubmitBy = CType(e.Item.FindControl("SubmitBy"), Label)
                SubmitDate = CType(e.Item.FindControl("SubmitDate"), Label)
                App1By = CType(e.Item.FindControl("App1By"), Label)
                App1Date = CType(e.Item.FindControl("App1Date"), Label)
                App2By = CType(e.Item.FindControl("App2By"), Label)
                App2Date = CType(e.Item.FindControl("App2Date"), Label)
    
    
                if trim(SubmitDate.text) <> "" then SubmitBy.text = trim(SubmitBy.text) & "-" & format(cdate(SubmitDate.text),"dd/MM/yy")
                if trim(App1Date.text) <> "" then App1By.text = trim(App1By.text) & "-" & format(cdate(App1Date.text),"dd/MM/yy")
                if trim(App2Date.text) <> "" then App2By.text = trim(App2By.text) & "-" & format(cdate(App2Date.text),"dd/MM/yy")
            End if
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
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SALES FORECAST
                                APPROVAL SHEET</asp:Label>
                            </p>
                            <div align="center">
                            </div>
                            <div align="center">
                                <asp:DataGrid id="GridControl1" runat="server" width="90%" OnPageIndexChanged="OurPager" OnItemDataBound="FormatRow" Font-Names="Verdana" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="2" Font-Name="Verdana" Font-Size="XX-Small" ShowFooter="True" AutoGenerateColumns="False">
                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                    <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <Columns>
                                        <asp:HyperLinkColumn DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="SFASApp2Det.aspx?ID={0}" DataTextField="SFAS_No" HeaderText="SFAS #"></asp:HyperLinkColumn>
                                        <asp:TemplateColumn HeaderText="Submitted By">
                                            <ItemTemplate>
                                                <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_By") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Verified By">
                                            <ItemTemplate>
                                                <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Approved By">
                                            <ItemTemplate>
                                                <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Status">
                                            <ItemTemplate>
                                                <asp:Label id="SFASStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SFAS_Status") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="false">
                                            <ItemTemplate>
                                                <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
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
                                    </Columns>
                                </asp:DataGrid>
                            </div>
                            <div align="center">&nbsp;&nbsp; 
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
