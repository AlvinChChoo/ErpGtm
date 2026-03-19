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
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
        if cmbSearch.selecteditem.value = "SSER_NO" then
            StrSql = "Select * from sser_m where SSER_NO like '%" & trim(txtSearch.text) & "%' and sser_stat = 'APPROVED' and ME_ENG_STAT = 3 order by seq_no desc"
        elseif cmbSearch.selecteditem.value = "PART_NO" then
            StrSql = "Select * from sser_m where Part_No_From + Part_No_To like '%" & trim(txtSearch.text) & "%' and sser_stat = 'APPROVED' and ME_ENG_STAT = 3 order by seq_no desc"
        elseif cmbSearch.selecteditem.value = "SUBMIT_BY" then
            StrSql = "Select * from sser_m where Submit_By like '%" & trim(txtSearch.text) & "%' and sser_stat = 'APPROVED' and ME_ENG_STAT = 3 order by seq_no desc"
        end if
    
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"sser_m")
            GridControl1.DataSource=resExePagedDataSet.Tables("sser_m").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub ShowSSER(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SSERNo As Label = CType(e.Item.FindControl("SSERNo"), Label)
        ShowReport("PopupReportViewer.aspx?RptName=SSER&SSERNo=" & trim(SSERNo.text))
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim MEEngDate As Label = CType(e.Item.FindControl("MEEngDate"), Label)
            Dim MEHODDate As Label = CType(e.Item.FindControl("MEHODDate"), Label)
            Dim QAEngDate As Label = CType(e.Item.FindControl("QAEngDate"), Label)
            Dim QAHODDate As Label = CType(e.Item.FindControl("QAHODDate"), Label)
            Dim Urgent As Label = CType(e.Item.FindControl("Urgent"), Label)
            Dim Status As Label = CType(e.Item.FindControl("Status"), Label)
            Dim REGENERATE As Label = CType(e.Item.FindControl("REGENERATE"), Label)
    
            e.item.cells(2).text = format(cdate(e.item.cells(2).text),"dd/MMM/yy")
            if trim(SubmitDate.text) <> "" then e.item.cells(3).text = e.item.cells(3).text & " - " & format(cdate(SubmitDate.text),"dd/MMM/yy")
            if trim(MEEngDate.text) <> "" then e.item.cells(4).text = e.item.cells(4).text & " - " & format(cdate(MEEngDate.text),"dd/MMM/yy")
            if trim(MEHODDate.text) <> "" then e.item.cells(5).text = e.item.cells(5).text & " - " & format(cdate(MEHODDate.text),"dd/MMM/yy")
            if trim(QAEngDate.text) <> "" then e.item.cells(6).text = e.item.cells(6).text & " - " & format(cdate(QAEngDate.text),"dd/MMM/yy")
            if trim(QAHODDate.text) <> "" then e.item.cells(7).text = e.item.cells(7).text & " - " & format(cdate(QAHODDate.text),"dd/MMM/yy")
    
            if (trim(SubmitDate.text) = "") or (trim(Status.text) = "REJECTED" AND TRIM(REGENERATE.text) = "N") then
                e.Item.CssClass = "PartSource"
                if trim(Urgent.text) = "Y" then e.item.cssclass = "Urgent"
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
                            <div align="center"><asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SAMPLE
                                SUBMISSION & EVALUATION REPORT (SSER) - Conditional Approval Only</asp:Label> 
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
                                                        <asp:ListItem Value="SSER_NO">SSER NO</asp:ListItem>
                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                        <asp:ListItem Value="SUBMIT_BY">BUYER USER ID</asp:ListItem>
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
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" OnEditCommand="ShowSSER" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" AllowSorting="True">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                            <asp:TemplateColumn HeaderText="SSER NO">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SSERNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SSER_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="SSER_Date" HeaderText="SSER Date" DataFormatString="{0:d}"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Submit_By" HeaderText="Iss/Submit"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ME_ENG_BY" HeaderText="ME/R&D(ENG)"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ME_HOD_BY" HeaderText="ME/R&D(HOD)"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="QA_ENG_BY" HeaderText="QA(ENG)"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="QA_HOD_BY" HeaderText="QA(HOD)"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Submit" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MEEngDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ME_Eng_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MEHodDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ME_Hod_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QAEngDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QA_Eng_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="QAHodDate" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QAHODDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QA_HOD_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status" visible= "True">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SSER_Stat") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Urgent" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Urgent") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="REGENERATE" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "REGENERATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_No_From" HeaderText="Part No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Model_No" HeaderText="Model No"></asp:BoundColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
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
