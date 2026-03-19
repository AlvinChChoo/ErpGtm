<%@ Page Language="VB" %>
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
            cmdAddNew.attributes.add("onClick","javascript:if(confirm('This will create a new SSER document.\nAre you sure to continue ?')==false) return false;")
            ProcLoadGridData()
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Dim Reqcom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SSERNo as string = ReqCOM.GetDocumentNo("SSER")
    
        ReqCOM.ExeCuteNonQuery("Insert into SSER_M(SSER_No,SSER_DATE,Submit_By) SELECT '" & TRIM(SSERNo) & "','" & NOW & "','" & request.cookies("U_ID").value & "';")
        reqcom.executeNonQuery("Update main set sser = sser + 1")
        response.redirect("SSERDet.aspx?ID=" & ReqCOM.GetFieldVal("select seq_no from sser_m where sser_no = '" & trim(SSERNo) & "';","Seq_No"))
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
        if cmbSearch.selecteditem.value = "SSER_NO" then StrSql = "Select * from sser_m where SSER_NO like '%" & trim(txtSearch.text) & "%' and sser_stat like '%" & trim(cmbSSERStatus.selecteditem.value) & "%' order by seq_no desc"
        if cmbSearch.selecteditem.value = "PART_NO" then StrSql = "Select * from sser_m where Part_No_From + Part_No_To like '" & trim(txtSearch.text) & "%' and sser_stat like '%" & trim(cmbSSERStatus.selecteditem.value) & "%' order by seq_no desc"
        if cmbSearch.selecteditem.value = "SUBMIT_BY" then StrSql = "Select * from sser_m where Submit_By like '%" & trim(txtSearch.text) & "%' and sser_stat like '%" & trim(cmbSSERStatus.selecteditem.value) & "%' order by seq_no desc"
    
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"sser_m")
            GridControl1.DataSource=resExePagedDataSet.Tables("sser_m").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    
    
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
    
            if trim(SubmitDate.text) <> "" then SubmitDate.text = format(cdate(SubmitDate.text),"dd/MM/yy")
            if trim(MEEngDate.text) <> "" then MEEngDate.text = format(cdate(MEEngDate.text),"dd/MM/yy")
            if trim(MEHODDate.text) <> "" then MEHODDate.text = format(cdate(MEHODDate.text),"dd/MM/yy")
            if trim(QAEngDate.text) <> "" then QAEngDate.text = format(cdate(QAEngDate.text),"dd/MM/yy")
            if trim(QAHODDate.text) <> "" then QAHODDate.text = format(cdate(QAHODDate.text),"dd/MM/yy")
    
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
    
    
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim SSERNo As Label = CType(e.Item.FindControl("SSERNo"), Label)
    
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("SSERDet.aspx?ID=" & clng(SeqNo.text))
        if ucase(e.commandArgument) = "PRINT" then ShowReport("PopUpReportViewer.aspx?RptName=SSER&SSERNo=" & trim(SSERNo.text))
    end sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdSearch1_Click(sender As Object, e As EventArgs)
        gridControl1.CurrentPageIndex = 0
        ProcLoadGridData()
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
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
                            <div align="center"><asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">SAMPLE
                                SUBMISSION & EVALUATION REPORT (SSER)</asp:Label>
                            </div>
                            <div align="center">
                                <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="Label3" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp; 
                                                    <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="127px"></asp:TextBox>
                                                    &nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp;<asp:DropDownList id="cmbSearch" runat="server" CssClass="OutputText">
                                                        <asp:ListItem Value="SSER_NO">SSER NO</asp:ListItem>
                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                        <asp:ListItem Value="SUBMIT_BY">BUYER USER ID</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp; <asp:Label id="Label7" runat="server" cssclass="OutputText">Show </asp:Label>&nbsp;<asp:DropDownList id="cmbSSERStatus" runat="server" CssClass="OutputText">
                                                        <asp:ListItem Value="" Selected="True">ALL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING APPROVAL" >PENDING APPROVAL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                        <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                        <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:Button id="cmdSearch1" onclick="cmdSearch1_Click" runat="server" CssClass="OutputText" Width="105px" Text="Quick Search" CausesValidation="False"></asp:Button>
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
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemCommand="ItemCommand" AllowSorting="True" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" BorderColor="Black" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgView" ToolTip="View this SSER" ImageUrl="View.gif" CommandArgument='VIEW' runat="server"></asp:ImageButton>
                                                                    <asp:ImageButton id="ImgPrint" ToolTip="Delete this SSER" ImageUrl="Print.gif" CommandArgument='PRINT' runat="server"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="SSER NO">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> <asp:Label id="SSERNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SSER_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Iss/Submit">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_By") %>' /> - <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="ME/R&amp;D(ENG)">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MEEngBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ME_ENG_BY") %>' /> - <asp:Label id="MEEngDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ME_Eng_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="ME/R&amp;D(HOD)">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MEHODBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ME_HOD_BY") %>' /> - <asp:Label id="MEHodDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ME_Hod_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="QA(ENG)">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QAENGBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QA_ENG_BY") %>' /> - <asp:Label id="QAEngDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QA_Eng_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="QA(HOD)">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QAHODBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QA_HOD_BY") %>' /> - <asp:Label id="QAHODDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QA_HOD_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SSER_Stat") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False" HeaderText="Submit">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Urgent" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Urgent") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False" HeaderText="Submit">
                                                                <ItemTemplate>
                                                                    <asp:Label id="REGENERATE" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "REGENERATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_No_From" HeaderText="Part No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Model_No" HeaderText="Model No"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="New SSER #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="NewSSERNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "NEW_SSER_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="10%" bgcolor="red">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label4" runat="server" width="100%" cssclass="OutputText">Urgent
                                                                    Part Approval</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="yellow">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label5" runat="server" width="100%" cssclass="OutputText">Normal
                                                                    Part Approval</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="white">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label6" runat="server" width="100%" cssclass="OutputText">Completed
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
                                                                        <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="177px" Text="Add New SSER"></asp:Button>
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
