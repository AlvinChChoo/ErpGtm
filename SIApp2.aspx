<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data" %>
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
    
         Sub cmdBack_Click(sender As Object, e As EventArgs)
             Response.redirect("Default.aspx")
         End Sub
    
    
         Sub ProcLoadGridData()
             Dim StrSql as string
             Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
             if cmbSearch.selecteditem.value = "REF_NO" then
                 StrSql = "Select * from VENDOR_INFO where REF_NO like '%" & trim(txtSearch.text) & "%' and App1_date is not null order by seq_no desc"
             elseif cmbSearch.selecteditem.value = "COMPANY_NAME" then
                 StrSql = "Select * from VENDOR_INFO where COMPANY_NAME like '%" & trim(txtSearch.text) & "%' and App1_date is not null order by seq_no desc"
             end if
    
             IF StrSql <> "" THEN
                 Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"sser_m")
                 GridControl1.DataSource=resExePagedDataSet.Tables("sser_m").DefaultView
                 GridControl1.DataBind()
             End if
         end sub
    
         Sub ShowData(sender as Object,e as DataGridCommandEventArgs)
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim RefNo As Label = CType(e.Item.FindControl("RefNo"), Label)
    
             Dim SeqNo as integer = ReqCOM.GetFieldVal("Select Seq_No from Vendor_Info where Ref_No = '" & trim(RefNo.text) & "';","Seq_No")
             Response.redirect("SIApp2Det.aspx?ID=" & SeqNo)
         End sub
    
         Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
    
             If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
                Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
                Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
                Dim App3Date As Label = CType(e.Item.FindControl("App3Date"), Label)
                Dim rEGENERATE As Label = CType(e.Item.FindControl("rEGENERATE"), Label)
    
    
    
                Dim Status As Label = CType(e.Item.FindControl("Status"), Label)
    
                if trim(SubmitDate.text) <> "" then e.item.cells(3).text = e.item.cells(3).text & " - " & format(cdate(SubmitDate.text),"dd/MMM/yy")
    
                if trim(App1Date.text) <> "" then e.item.cells(4).text = e.item.cells(4).text & " - " & format(cdate(App1Date.text),"dd/MMM/yy")
                if trim(App2Date.text) <> "" then e.item.cells(5).text = e.item.cells(5).text & " - " & format(cdate(App2Date.text),"dd/MMM/yy")
                if trim(App3Date.text) <> "" then e.item.cells(6).text = e.item.cells(6).text & " - " & format(cdate(App3Date.text),"dd/MMM/yy")
    
                if (trim(App2Date.text) = "")  then
                    e.Item.CssClass = "PartSource"
                    'if trim(Urgent.text) = "Y" then e.item.cssclass = "Urgent"
                end if
             End if
         End Sub
    
         Sub OurPager(sender as object,e as datagridpagechangedeventargs)
             gridControl1.CurrentPageIndex = e.NewPageIndex
             ProcLoadGridData()
         end sub
    
         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
         End Sub
    
         Sub cmdSearch_Click(sender As Object, e As EventArgs)
             ProcLoadGridData()
         End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center"><asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SUPPLIER
                                INFORMATION LIST</asp:Label>
                            </div>
                            <div align="center">
                                <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="Label3" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:TextBox id="txtSearch" runat="server" Width="164px" Height="19px" CssClass="OutputText"></asp:TextBox>
                                                    &nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:DropDownList id="cmbSearch" runat="server" Width="238px" Height="19px" CssClass="OutputText">
                                                        <asp:ListItem Value="REF_NO">REF NO</asp:ListItem>
                                                        <asp:ListItem Value="COMPANY_NAME">COMPANY NAME</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" Width="72px" CssClass="OutputText" Text="GO"></asp:Button>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <p align="center">
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" OnEditCommand="ShowData" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False" AllowSorting="True">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                            <asp:TemplateColumn HeaderText="REF #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="RefNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "REF_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="company_name" HeaderText="COMPANY NAME" DataFormatString="{0:d}"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Submit_By" HeaderText="Iss/Submit"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="APP1_BY" HeaderText="HOD Approval"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="APP2_BY" HeaderText="Accounts"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="APP3_BY" HeaderText="Final Approval"></asp:BoundColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP1_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP2_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "APP3_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="TRUE" >
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SI_Status") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="rEGENERATE" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "rEGENERATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="136px" Text="Back"></asp:Button>
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
