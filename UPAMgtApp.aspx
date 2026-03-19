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
        if page.isPostBack = false then procLoadGridData ()
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if cmbSearch.selecteditem.value = "UPA_NO" then StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO LIKE '%" & txtSearch.Text & "%' and ACC2_BY is not null and upas_status <> 'REJECTED' and upas_status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' ORDER BY upas_no desc"
        if cmbSearch.selecteditem.value = "SUBMIT_BY" then StrSql = "SELECT * FROM UPAS_M WHERE SUBMIT_BY LIKE '%" & TRIM(txtSearch.text) & "%'  and ACC2_BY is not null and upas_status <> 'REJECTED' and upas_status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' ORDER BY upas_no desc"
        if cmbSearch.selecteditem.value = "VEN_CODE" then StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO in (SELECT UPAS_NO FROM UPAS_D WHERE VEN_CODE IN(Select VEN_CODE from VENDOR where VEN_CODE + VEN_NAME like '%" & trim(txtSearch.text) & "%'))  and ACC2_BY is not null and upas_status <> 'REJECTED' and upas_status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' ORDER BY upas_no desc"
    
        if cmbSearch.selecteditem.value = "PART_NO" then
            if txtSearch.text = "" then StrSql = "SELECT * FROM UPAS_M WHERE ACC2_BY is not null and upas_status <> 'REJECTED' and upas_status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' ORDER BY upas_no desc"
            if txtSearch.text <> "" then StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO in (Select UPAS_NO from UPAS_D where Part_No like '%" & trim(txtSearch.text) & "%') and ACC2_BY is not null and upas_status <> 'REJECTED' and upas_status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' ORDER BY upas_no desc"
        End if
    
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"CUST")
        GridControl1.DataSource=resExePagedDataSet.Tables("CUST").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub Button3_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim Submit As Label = CType(e.Item.FindControl("Submit"), Label)
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim PurcDate As Label = CType(e.Item.FindControl("PurcDate"), Label)
            Dim Urgent As Label = CType(e.Item.FindControl("Urgent"), Label)
            Dim AC1Date As Label = CType(e.Item.FindControl("AC1Date"), Label)
            Dim AC2Date As Label = CType(e.Item.FindControl("AC2Date"), Label)
            Dim MgtDate As Label = CType(e.Item.FindControl("MgtDate"), Label)
            Dim EntryDate As Label = CType(e.Item.FindControl("EntryDate"), Label)
            Dim Mgt As Label = CType(e.Item.FindControl("Mgt"), Label)
            Dim Status As Label = CType(e.Item.FindControl("Status"), Label)
            Dim NewUPASNo As Label = CType(e.Item.FindControl("NewUPASNo"), Label)
    
            if trim(SubmitDate.text) <> "" then SubmitDate.text = format(cdate(SubmitDate.text),"dd/MMM/yy")
            if trim(AC1Date.text) <> "" then AC1Date.text = format(cdate(AC1Date.text),"dd/MMM/yy")
            if trim(AC2Date.text) <> "" then AC2Date.text = format(cdate(AC2Date.text),"dd/MMM/yy")
            if trim(MgtDate.text) <> "" then MgtDate.text = format(cdate(MgtDate.text),"dd/MMM/yy")
            if trim(PurcDate.text) <> "" then PurcDate.text = format(cdate(PurcDate.text),"dd/MMM/yy")
            if trim(Submit.text) = "" then e.Item.CssClass = "PartSource"
    
            if trim(Mgt.text) = "" then
                e.Item.CssClass = "PartSource"
                if trim(Urgent.text) = "Y" then e.item.cssclass = "Urgent"
            end if
        end if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">UNIT PRICE
                                APPROVAL LIST</asp:Label> 
                                <table style="HEIGHT: 12px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="Label3" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp; 
                                                    <asp:TextBox id="txtSearch" runat="server" Width="177px" CssClass="OutputText"></asp:TextBox>
                                                    &nbsp;&nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp;&nbsp;<asp:DropDownList id="cmbSearch" runat="server" Width="143px" CssClass="OutputText">
                                                        <asp:ListItem Value="UPA_NO">UPA No</asp:ListItem>
                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                        <asp:ListItem Value="SUBMIT_BY">BUYER</asp:ListItem>
                                                        <asp:ListItem Value="VEN_CODE">SUPPLIER</asp:ListItem>
                                                    </asp:DropDownList>
                                                    <asp:Label id="Label7" runat="server" cssclass="OutputText">Show </asp:Label>
                                                    <asp:DropDownList id="cmbUPAStatus" runat="server" Width="139px" CssClass="OutputText">
                                                        <asp:ListItem Value="">ALL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING APPROVAL" Selected="True">PENDING APPROVAL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                        <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                        <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;&nbsp;&nbsp;<asp:Button id="Button3" onclick="Button3_Click" runat="server" Width="82px" CssClass="OutputText" Text="GO"></asp:Button>
                                                </div>
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
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AllowPaging="True" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" Font-Name="Verdana" OnItemDataBound="FormatRow" OnPageIndexChanged="OurPager" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:HyperLinkColumn Text="View" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="UPAMgtAppDet.aspx?ID={0}"></asp:HyperLinkColumn>
                                                            <asp:BoundColumn DataField="UPAS_NO" HeaderText="UPA #"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CREATE_BY" visible="false" HeaderText="Prepared"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Submit">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Submit" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SUBMIT_BY") %>' /> - <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SUBMIT_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Purchasing">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Purc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PURC_BY") %>' /> - <asp:Label id="PurcDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Purc_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="A/C 1">
                                                                <ItemTemplate>
                                                                    <asp:Label id="AC1" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ACC1_BY") %>' /> - <asp:Label id="AC1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ACC1_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="A/C 2">
                                                                <ItemTemplate>
                                                                    <asp:Label id="AC2" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ACC2_BY") %>' /> - <asp:Label id="AC2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ACC2_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Mgt">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Mgt" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MGT_BY") %>' /> - <asp:Label id="MgtDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MGT_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UPAS_Status") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="" visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Urgent" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "urgent") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="New UPA #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="NewUPASNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "New_Upas_No") %>' /> 
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
                                                                    &nbsp; <asp:Label id="Label4" runat="server" cssclass="OutputText" width="100%">Urgent
                                                                    UPA</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="yellow">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label5" runat="server" cssclass="OutputText" width="100%">Normal
                                                                    UPA</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="white">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label6" runat="server" cssclass="OutputText" width="100%">Completed
                                                                    UPA</asp:Label></td>
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
                                                <p>
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
