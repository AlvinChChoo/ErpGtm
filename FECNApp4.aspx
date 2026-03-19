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
        if page.isPostBack = false then procLoadGridData()
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update FECN_M set SORT_SEQ = 2")
        ReqCOM.ExecuteNonQuery("Update FECN_M set Sort_Seq = 1 where FECN_Status <> 'REJECTED' and App4_By is null")
    
        if trim(cmbSearch.selecteditem.value) = "FECN_No" then
            if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "ECN_No" then
            if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "MODEL_NO" then
            if trim(cmbFECNStatus.selecteditem.value) = "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "PART_NO" then
            if trim(cmbFECNStatus.selecteditem.value) =  "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND fecn_no in (Select Fecn_No from fecn_d where main_part_b4 like '%" & trim(txtSearch.text) & "%' or main_part like '%" & trim(txtSearch.text) & "%' or alt_part_b4 like '%" & trim(txtSearch.text) & "%' or alt_part like '%" & trim(txtSearch.text) & "%') ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND fecn_no in (Select Fecn_No from fecn_d where main_part_b4 like '%" & trim(txtSearch.text) & "%' or main_part like '%" & trim(txtSearch.text) & "%' or alt_part_b4 like '%" & trim(txtSearch.text) & "%' or alt_part like '%" & trim(txtSearch.text) & "%') AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "LOT_NO" then
            if trim(cmbFECNStatus.selecteditem.value) =  "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND fecn_no in (Select Fecn_No from fecn_d where lot_no like '%" & trim(txtSearch.text) & "%') ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND fecn_no in (Select Fecn_No from fecn_d where lot_no like '%" & trim(txtSearch.text) & "%') AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        if trim(cmbSearch.selecteditem.value) = "PART_DESC" then
            if trim(cmbFECNStatus.selecteditem.value) =  "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND fecn_no in (Select Fecn_No from fecn_d where PART_DESC_B4 like '%" & trim(txtSearch.text) & "%' or PART_DESC like '%" & trim(txtSearch.text) & "%' or alt_part_b4 like '%" & trim(txtSearch.text) & "%' or alt_part like '%" & trim(txtSearch.text) & "%') ORDER BY Sort_Seq,FEcn_No DESC"
            if trim(cmbFECNStatus.selecteditem.value) <> "ALL" then StrSql = "SELECT * FROM FECN_M where App3_date is not null and App2_Date is not null and App1_date is not null AND fecn_no in (Select Fecn_No from fecn_d where PART_DESC_B4 like '%" & trim(txtSearch.text) & "%' or PART_DESC like '%" & trim(txtSearch.text) & "%' or alt_part_b4 like '%" & trim(txtSearch.text) & "%' or alt_part like '%" & trim(txtSearch.text) & "%') AND FECN_STATUS = '" & TRIM(cmbFECNStatus.selecteditem.value) & "' ORDER BY Sort_Seq,FEcn_No DESC"
        end if
    
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"FECN_M")
        Dim DV as New DataView(resExePagedDataSet.Tables("FECN_M"))
        Dim SortSeq as String
        GridControl1.DataSource=DV
        GridControl1.DataBind()
    end sub
    
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
            if trim(App4Date.text) = "" and trim(ucase(Status.text)) <> "REJECTED" then e.Item.CssClass = "PartSource"
            if trim(App4Date.text) = "" and trim(ucase(Status.text)) <> "REJECTED" and trim(ucase(Urgent.text)) = "Y" then e.Item.CssClass = "Urgent"
        End if
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim FECNNo As Label = CType(e.Item.FindControl("FECNNo"), Label)
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("FECNApp4Det.aspx?ID=" & clng(SeqNo.text))
        if ucase(e.commandArgument) = "PRINT" then Response.redirect("PopupPDFViewer.aspx?RptName=FECN&FECNNo=" & trim(FECNNo.text))
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">FECN
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 7px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="Label1" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;<asp:TextBox id="txtSearch" runat="server" Width="123px" CssClass="OutputText"></asp:TextBox>
                                                    &nbsp;<asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;<asp:DropDownList id="cmbSearch" runat="server" Width="199px" CssClass="OutputText">
                                                        <asp:ListItem Value="FECN_No">FECN NO</asp:ListItem>
                                                        <asp:ListItem Value="ECN_No">ECN NO</asp:ListItem>
                                                        <asp:ListItem Value="MODEL_NO">MODEL NO</asp:ListItem>
                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                        <asp:ListItem Value="LOT_NO">LOT NO</asp:ListItem>
                                                        <asp:ListItem Value="PART_DESC">Part DESCRIPTION</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;<asp:Label id="Label4" runat="server" cssclass="OutputText">SHOW</asp:Label>&nbsp;<asp:DropDownList id="cmbFECNStatus" runat="server" Width="167px" CssClass="OutputText">
                                                        <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING APPROVAL" Selected="True">PENDING APPROVAL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                        <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                        <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;<asp:Label id="Label5" runat="server" cssclass="OutputText">FECN</asp:Label>&nbsp;&nbsp;&nbsp; 
                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Width="48px" CssClass="OutputText" Text="GO"></asp:Button>
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
                                                    &nbsp;<asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" BorderColor="Gray" AllowPaging="True" OnPageIndexChanged="OurPager" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" OnItemCommand="ItemCommand">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgView" ToolTip="View this S/O" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                                                    <asp:ImageButton id="ImgPrint" ToolTip="Print this FECN" ImageUrl="Print.gif" CommandArgument='Print' runat="server"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="FECN No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="FECNNO" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FECN_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Model_No" SortExpression="Model_No" HeaderText="Model No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ECN_NO" SortExpression="ECN_NO" HeaderText="ECN No"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="SUBMIT">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SUBMIT_BY") %>' /> <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
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
                                                            <asp:TemplateColumn HeaderText="R&amp;D HOD">
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
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App5Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App5_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App6Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App6_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FECN_Status") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="New Ref.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="NewFECNNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "New_FECN_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Urgent" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Urgent") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="10%" bgcolor="red">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label6" runat="server" cssclass="OutputText" width="100%">Urgent
                                                                    FECN Pending Approval</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="yellow">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label7" runat="server" cssclass="OutputText" width="100%">Normal
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
