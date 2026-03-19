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
    
        if cmbSearch.selecteditem.value = "SSER_NO" then
            StrSql = "Select * from sser_m where SSER_NO like '%" & trim(txtSearch.text) & "%' and QA_ENG_BY is not null and sser_stat <> 'REJECTED' order by QA_HOD_STAT, seq_no ASC"
        elseif cmbSearch.selecteditem.value = "PART_NO" then
            StrSql = "Select * from sser_m where Part_No_From + Part_No_To like '%" & trim(txtSearch.text) & "%' and QA_ENG_BY is not null and sser_stat <> 'REJECTED' order by seq_no desc"
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
        Dim SeqNo as integer = ReqCOM.GetFieldVal("Select Seq_No from SSER_M where SSER_NO = '" & trim(SSERNo.text) & "';","Seq_No")
        Response.redirect("SSERQAHODDet.aspx?ID=" & SeqNo)
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim MEEngDate As Label = CType(e.Item.FindControl("MEEngDate"), Label)
            Dim MEHODDate As Label = CType(e.Item.FindControl("MEHODDate"), Label)
            Dim QAEngDate As Label = CType(e.Item.FindControl("QAEngDate"), Label)
            Dim QAHODDate As Label = CType(e.Item.FindControl("QAHODDate"), Label)
            Dim Urgent As Label = CType(e.Item.FindControl("Urgent"), Label)
    
            e.item.cells(2).text = format(cdate(e.item.cells(2).text),"dd/MMM/yy")
            if trim(SubmitDate.text) <> "" then e.item.cells(3).text = e.item.cells(3).text & " - " & format(cdate(SubmitDate.text),"dd/MMM/yy")
            if trim(MEEngDate.text) <> "" then e.item.cells(4).text = e.item.cells(4).text & " - " & format(cdate(MEEngDate.text),"dd/MMM/yy")
            if trim(MEHODDate.text) <> "" then e.item.cells(5).text = e.item.cells(5).text & " - " & format(cdate(MEHODDate.text),"dd/MMM/yy")
            if trim(QAEngDate.text) <> "" then e.item.cells(6).text = e.item.cells(6).text & " - " & format(cdate(QAEngDate.text),"dd/MMM/yy")
            if trim(QAHODDate.text) <> "" then e.item.cells(7).text = e.item.cells(7).text & " - " & format(cdate(QAHODDate.text),"dd/MMM/yy")
    
            if trim(QAHODDate.text) = "" then
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
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">SAMPLE SUBMISSION
                                & EVALUATION REPORT (SSER)</asp:Label> 
                                <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="Label5" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:TextBox id="txtSearch" runat="server" Height="19px" CssClass="OutputText" Width="164px"></asp:TextBox>
                                                    &nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="Label6" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:DropDownList id="cmbSearch" runat="server" Height="19px" CssClass="OutputText" Width="238px">
                                                        <asp:ListItem Value="SSER_NO">SSER NO</asp:ListItem>
                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" CssClass="OutputText" Width="72px" Text="GO"></asp:Button>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="94%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" AllowSorting="True" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" OnEditCommand="ShowSSER" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager">
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
                                                                    <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MEEngDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ME_ENG_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MEHODDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ME_HOD_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QAEngDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QA_ENG_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QAHODDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QA_HOD_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="QAHodDate" visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Urgent" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Urgent") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status" visible= "True">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SSER_Stat") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_No_From" HeaderText="Part No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Model_No" HeaderText="Model No"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="New SSER #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="NewSSERNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "New_SSER_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="10%" bgcolor="red">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label2" runat="server" width="100%" cssclass="OutputText">Urgent
                                                                    Part Approval</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="yellow">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label3" runat="server" width="100%" cssclass="OutputText">Normal
                                                                    Part Approval</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="white">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label4" runat="server" width="100%" cssclass="OutputText">Completed
                                                                    Part Approval</asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
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
