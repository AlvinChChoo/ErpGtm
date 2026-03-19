<%@ Page Language="VB" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            cmdAddNew.attributes.add("onClick","javascript:if(confirm('This will create a new approval sheet document.\nAre you sure to continue ?')==false) return false;")
            procLoadGridData ()
        End If
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string
    
        if cmbSearch.selecteditem.value = "UPA_NO" then StrSql = "SELECT * FROM UPAS_M WHERE UPAS_No LIKE '%" & txtSearch.Text & "%' and UPAS_Status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' ORDER BY upas_no desc"
        if cmbSearch.selecteditem.value = "PART_NO" then StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO in (Select UPAS_NO from UPAS_D where Part_No like '%" & trim(txtSearch.text) & "%') and UPAS_Status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' ORDER BY upas_no desc"
        if cmbSearch.selecteditem.value = "SUBMIT_BY" then StrSql = "SELECT * FROM UPAS_M WHERE SUBMIT_BY LIKE '%" & TRIM(txtSearch.text) & "%' and UPAS_Status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' ORDER BY upas_no desc"
        if cmbSearch.selecteditem.value = "VEN_CODE" then StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO in (SELECT UPAS_NO FROM UPAS_D WHERE UPAS_Status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' and A_VEN_CODE IN(Select VEN_CODE from VENDOR where VEN_CODE + VEN_NAME like '%" & trim(txtSearch.text) & "%')) ORDER BY upas_no desc"
        if cmbSearch.selecteditem.value = "VEN_CODE" then StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO in (SELECT UPAS_NO FROM UPAS_D WHERE UPAS_Status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' and A_VEN_CODE IN(Select VEN_CODE from VENDOR where VEN_CODE + VEN_NAME like '%" & trim(txtSearch.text) & "%') or ven_code in ((Select VEN_CODE from VENDOR where VEN_CODE + VEN_NAME like '%" & trim(txtSearch.text) & "%'))) ORDER BY upas_no desc"
        if cmbSearch.selecteditem.value = "M_PART_NO" then StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO in (SELECT UPAS_NO FROM UPAS_D WHERE UPAS_Status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' and PART_NO IN(Select PART_NO from PART_MASTER where m_part_no like '%" & trim(txtSearch.text) & "%')) ORDER BY upas_no desc"
        if cmbSearch.selecteditem.value = "PART_SPEC" then StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO in (SELECT UPAS_NO FROM UPAS_D WHERE UPAS_Status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' and PART_NO IN(Select PART_NO from PART_MASTER where PART_SPEC like '%" & trim(txtSearch.text) & "%')) ORDER BY upas_no desc"
        if cmbSearch.selecteditem.value = "PART_DESC" then StrSql = "SELECT * FROM UPAS_M WHERE UPAS_NO in (SELECT UPAS_NO FROM UPAS_D WHERE UPAS_Status like '%" & trim(cmbUPAStatus.selecteditem.value) & "%' and PART_NO IN(Select PART_NO from PART_MASTER where PART_DESC like '%" & trim(txtSearch.text) & "%')) ORDER BY upas_no desc"
    
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"CUST")
        GridControl1.DataSource=resExePagedDataSet.Tables("CUST").DefaultView
        GridControl1.DataBind()
    end sub
    
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("UnitPriceApprovalSheetAddNew.aspx")
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
            Dim Create as label = CType(e.Item.FindControl("Create"), Label)
            Dim CreateDate as label = CType(e.Item.FindControl("CreateDate"), Label)
            Dim Submit As Label = CType(e.Item.FindControl("Submit"), Label)
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim PurcDate As Label = CType(e.Item.FindControl("PurcDate"), Label)
            Dim AC1Date As Label = CType(e.Item.FindControl("AC1Date"), Label)
            Dim AC2Date As Label = CType(e.Item.FindControl("AC2Date"), Label)
            Dim MgtDate As Label = CType(e.Item.FindControl("MgtDate"), Label)
            Dim EntryDate As Label = CType(e.Item.FindControl("EntryDate"), Label)
            Dim Status As Label = CType(e.Item.FindControl("Status"), Label)
            Dim regenerate As Label = CType(e.Item.FindControl("regenerate"), Label)
            Dim Urgent As Label = CType(e.Item.FindControl("Urgent"), Label)
    
            if trim(CreateDate.text) <> "" then CreateDate.text = format(cdate(CreateDate.text),"dd/MMM/yy")
            if trim(PurcDate.text) <> "" then PurcDate.text = format(cdate(PurcDate.text),"dd/MMM/yy")
            if trim(SubmitDate.text) <> "" then SubmitDate.text = format(cdate(SubmitDate.text),"dd/MMM/yy")
            if trim(AC1Date.text) <> "" then AC1Date.text = format(cdate(AC1Date.text),"dd/MMM/yy")
            if trim(AC2Date.text) <> "" then AC2Date.text = format(cdate(AC2Date.text),"dd/MMM/yy")
            if trim(MgtDate.text) <> "" then MgtDate.text = format(cdate(MgtDate.text),"dd/MMM/yy")
            if trim(Submit.text) = "" then e.Item.CssClass = "PartSource"
    
            if trim(ucase(Status.text)) = "REJECTED" or SubmitDate.text = "" then
                if trim(regenerate.text) = "N" then
                    e.Item.CssClass = "PartSource"
                    if trim(Urgent.text) = "Y" then e.item.cssclass = "Urgent"
                End if
            End if
        End if
    End Sub
    
    Sub cmbSearch_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub ItemCommandUPAS(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim UPANo As Label = CType(e.Item.FindControl("UPANo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("UnitPriceApprovalSheetDet.aspx?ID=" & clng(SeqNo.text))
    
        if ucase(e.commandArgument) = "PRINT" then
            ReqCOM.ExecuteNonQuery("Update UPAS_D set UPAS_D.Ven_Code_Temp = Vendor.Ven_Name from UPAS_D, Vendor where upas_d.Ven_Code = vendor.ven_code and UPAS_D.UPAS_No = '" & trim(UPANo.text) & "';")
            ReqCOM.ExecuteNonQuery("Update UPAS_D set UPAS_D.A_Ven_Code_Temp = Vendor.Ven_Name from UPAS_D, Vendor where upas_d.A_Ven_Code = vendor.ven_code and UPAS_D.UPAS_No = '" & trim(UPANo.text) & "';")
            ShowPopup("PopupreportViewer.aspx?RptName=UPA&UPASNo=" & Trim(UPANo.text) )
        End if
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
        </p>
        <p align="center">
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <IBUYSPY:HEADER id="UserControl1" runat="server"></IBUYSPY:HEADER>
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Unit Price Apporval (UPA) List</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="HEIGHT: 12px" width="98%" align="center">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <div align="center"><asp:Label id="Label3" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp; 
                                                                                        <asp:TextBox id="txtSearch" runat="server" Width="113px" CssClass="Input_Box"></asp:TextBox>
                                                                                        &nbsp;&nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp; 
                                                                                        <asp:DropDownList id="cmbSearch" runat="server" Width="104px" CssClass="Input_Box" OnSelectedIndexChanged="cmbSearch_SelectedIndexChanged">
                                                                                            <asp:ListItem Value="UPA_NO">UPA No</asp:ListItem>
                                                                                            <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                                                            <asp:ListItem Value="SUBMIT_BY">BUYER USER ID</asp:ListItem>
                                                                                            <asp:ListItem Value="VEN_CODE">SUPPLIER</asp:ListItem>
                                                                                            <asp:ListItem Value="M_PART_NO">MPN</asp:ListItem>
                                                                                            <asp:ListItem Value="PART_SPEC">SPECIFICATION</asp:ListItem>
                                                                                            <asp:ListItem Value="PART_DESC">DESCRIPTION</asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                        &nbsp;<asp:Label id="Label7" runat="server" cssclass="OutputText">Show </asp:Label> 
                                                                                        <asp:DropDownList id="cmbUPAStatus" runat="server" CssClass="Input_Box">
                                                                                            <asp:ListItem Value="">ALL</asp:ListItem>
                                                                                            <asp:ListItem Value="PENDING APPROVAL" Selected="True">PENDING APPROVAL</asp:ListItem>
                                                                                            <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                                                            <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                                                            <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                        &nbsp;&nbsp;&nbsp;<asp:Button id="Button3" onclick="Button3_Click" runat="server" Width="111px" CssClass="OutputText" Text="QUICK SEARCH"></asp:Button>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <p align="center">
                                                                        <asp:DataGrid id="GridControl1" runat="server" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemCommand="ItemCommandUPAS" OnItemDataBound="FormatRow" AutoGenerateColumns="False" ShowFooter="True" Font-Name="Verdana" cellpadding="4" BorderColor="Gray" AllowPaging="True" OnPageIndexChanged="OurPager" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" width="98%">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn>
                                                                                    <ItemTemplate>
                                                                                        <asp:ImageButton id="ImgView" ToolTip="View this item" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                                                                        <asp:ImageButton id="ImgPrint" ToolTip="Print" ImageUrl="Print.gif" CommandArgument='Print' runat="server"></asp:ImageButton>
                                                                                        <asp:Label id="SeqNo" runat="server" visible="false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="UPA #">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="UPANo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UPAS_NO") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn Visible="False" DataField="CREATE_BY" HeaderText="Prepared"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Create">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="Create" runat="server" tooltip= '<%# DataBinder.Eval(Container.DataItem, "CREATE_BY") %>' text='<%# DataBinder.Eval(Container.DataItem, "CREATE_BY") %>' /> - <asp:Label id="CreateDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Create_Date") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
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
                                                                                <asp:TemplateColumn HeaderText="New UPA #">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="NewUPASNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "New_Upas_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="regenerate" visible="false" width="" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "REGENERATE") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="Urgent" visible="false" width="" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Urgent") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                        <br />
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="98%" align="center">
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
                                                                        <br />
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <p>
                                                        <table style="HEIGHT: 13px" width="98%">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <p>
                                                                            <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="177px" Text="Add New Approval Sheet"></asp:Button>
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
                                <p>
                                    <Footer:Footer id="Footer" runat="server"></Footer:Footer>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
