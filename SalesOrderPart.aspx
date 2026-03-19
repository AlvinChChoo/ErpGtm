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
        if request.cookies("U_ID") is nothing then
            response.redirect("AccessDenied.aspx")
        else
            procLoadGridData()
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        'ProcLoadGridData("SELECT * FROM SO_PART_M WHERE LOT_NO like '%" & txtSearch.Text & "%'  ORDER BY LOT_NO ASC")
        procLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
        'StrSql = "SELECT SO.PO_NO,So.PCMC_APP_BY,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, cust.CUST_CODE + '|' + cust.Cust_Name as [Cust_Code], SO.SEQ_NO FROM SO_Part_M SO, cust WHERE SO.LOT_NO LIKE '%" & txtSearch.Text & "%' AND SO.CUST_CODE = CUST.CUST_cODE  ORDER BY SO.LOT_NO ASC"
        StrSql = "SELECT SO.PO_NO,So.App2_By,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, cust.CUST_CODE + '|' + cust.Cust_Name as [Cust_Code], SO.SEQ_NO FROM SO_Part_M SO, cust WHERE " & cmbBy.selectedItem.value & " LIKE '%" & txtSearch.Text & "%' AND SO.CUST_CODE = CUST.CUST_cODE  ORDER BY SO.LOT_NO ASC"
    
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SO_Part_M")
            GridControl1.DataSource=resExePagedDataSet.Tables("SO_Part_M").DefaultView
            GridControl1.DataBind()
        End if
    
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        procLoadGridData()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(2).Text = format(cdate(e.Item.Cells(2).Text),"dd/MMM/yy")
            Dim AppBy As Label = CType(e.Item.FindControl("AppBy"), Label)
            Dim PCMCAppBy As Label = CType(e.Item.FindControl("PCMCAppBy"), Label)
            if AppBy.text = "" then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub ShowSO(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim LotNo As Label = CType(e.Item.FindControl("LotNo"), Label)
        Dim SeqNo as integer = ReqCOM.GetFieldVal("Select Seq_No from SO_Part_M where LOT_NO = '" & trim(LotNo.text) & "';","Seq_No")
    
        'if trim(ucase(lblUserRole.text)) = "CSD" then
            Response.redirect("SalesOrderPartDet.aspx?ID=" & SeqNo)
        'elseif trim(ucase(lblUserRole.text)) = "PCMC" then
        '    Response.redirect("SalesOrderPartsDetPCMC.aspx?ID=" & SeqNo)
        'else
        '    response.redirect("UnauthorisedUser.aspx")
        'End if
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderPartAddNew.aspx")
    End Sub

</script>
<html xmlns:erp= "xmlns:erp">
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">SALES
                                ORDER LIST - By Part</asp:Label>
                            </p>
                            <p align="center">
                                <table height="100%" cellspacing="0" cellpadding="0" width="90%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="top" width="100%">
                                                <p>
                                                    <table style="HEIGHT: 12px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label3" runat="server" cssclass="OutputText" width="">SEARCH</asp:Label>&nbsp; 
                                                                        <asp:TextBox id="txtSearch" runat="server" Width="180px" CssClass="OutputText"></asp:TextBox>
                                                                        &nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText" width="">BY</asp:Label>&nbsp; 
                                                                        <asp:DropDownList id="cmbBy" runat="server" Width="173px" CssClass="OutputText">
                                                                            <asp:ListItem Value="SO.LOT_NO">LOT NO</asp:ListItem>
                                                                            <asp:ListItem Value="CUST.CUST_CODE">CUSTOMER CODE</asp:ListItem>
                                                                            <asp:ListItem Value="CUST.CUST_NAME">CUSTOMER NAME</asp:ListItem>
                                                                            <asp:ListItem Value="SO.PO_NO">PO NO</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp; &nbsp;&nbsp; 
                                                                        <asp:Button id="GO" onclick="Button1_Click" runat="server" Width="60px" CssClass="OutputText" Text="GO" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 27px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" OnEditCommand="ShowSO" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager" OnItemDataBound="FormatRow" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                                                <asp:TemplateColumn HeaderText="Lot No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="LOTNO" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "LOT_NO") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="SO_DATE" HeaderText="Issued Date" DataFormatString="{0:d}"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="CUST_CODE" HeaderText="Customer Code/Name"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PO_NO" HeaderText="P/O NO"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="CSD App">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="AppBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CSD_APP_BY") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="PCMC App">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="173px" Text="Add New Sales Order"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="117px" Text="Back"></asp:Button>
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
        <p>
        </p>
    </form>
</body>
</html>
