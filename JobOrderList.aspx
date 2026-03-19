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
        'StrSql = "Select jd.on_hold_qty,jd.jo_status,jd.in_qty,jd.out_qty,jd.released_date,jd.released_by,jd.seq_no,jm.lot_no,jd.jo_no,jd.pd_level,jd.prod_qty from Job_Order_D jd,job_order_m JM where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and jd.released_by is not null and jd.jo_no = jm.jo_no order by jd.jo_no asc"
        StrSql = "Select jd.on_hold_qty,jd.jo_status,jd.in_qty,jd.out_qty,jd.released_date,jd.released_by,jd.seq_no,jm.lot_no,jd.jo_no,jd.pd_level,jd.prod_qty from Job_Order_D jd,job_order_m JM where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and jd.jo_no = jm.jo_no order by jd.jo_no asc"
    
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Job_Order_D")
            GridControl1.DataSource=resExePagedDataSet.Tables("Job_Order_D").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub SortGrid(s As Object, e As DataGridSortCommandEventArgs)
        ProcLoadGridData()
    End Sub
    
    'Sub ShowSO(sender as Object,e as DataGridCommandEventArgs)
    '    Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
    '    ShowPopup("PopupJobOrderExpDet.aspx?ID=" & clng(SeqNo.text))
    'End sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=700,height=300');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowPopup1", Script.ToString())
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ReleasedBy As Label = CType(e.Item.FindControl("ReleasedBy"), Label)
            Dim ReleasedDate As Label = CType(e.Item.FindControl("ReleasedDate"), Label)
            If trim(ReleasedDate.text) <> "" then ReleasedBy.text = ReleasedBy.text & "-" & format(cdate(ReleasedDate.text),"dd/MM/yy")
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
        Sub ShowSO(sender as Object,e as DataGridCommandEventArgs)
            Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
            ShowPopup("PopupJobOrderExpDet.aspx?ID=" & clng(SeqNo.text))
            ProcLoadGridData()
        End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UCcontent" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">JOB
                                ORDER</asp:Label>
                            </p>
                            <p align="center">
                                <table height="100%" cellspacing="0" cellpadding="0" width="90%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="top" width="100%">
                                                <p align="center">
                                                    <table style="HEIGHT: 9px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label3" runat="server" cssclass="outputText">SEARCH</asp:Label>&nbsp;&nbsp; 
                                                                        <asp:TextBox id="txtSearch" runat="server" CssClass="outputText"></asp:TextBox>
                                                                        &nbsp;&nbsp; <asp:Label id="Label4" runat="server" cssclass="outputText">BY</asp:Label>&nbsp;&nbsp; 
                                                                        <asp:DropDownList id="cmbSearch" runat="server" CssClass="outputText" Width="165px">
                                                                            <asp:ListItem Value="JD.JO_NO">JOB ORDER NO</asp:ListItem>
                                                                            <asp:ListItem Value="JM.LOT_NO">LOT NO</asp:ListItem>
                                                                            <asp:ListItem Value="JD.PD_LEVEL">PRODUCTION</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp; 
                                                                        <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" CssClass="outputText" Width="65px" Text="GO"></asp:Button>
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
                                                                        &nbsp;<asp:DataGrid id="GridControl1" runat="server" width="100%" OnSortCommand="sortGrid" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" OnEditCommand="ShowSO" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" AllowSorting="True">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View Det."></asp:EditCommandColumn>
                                                                                <asp:TemplateColumn HeaderText="JO #">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="JONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "JO_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Section">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PDLevel" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PD_Level") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="LOT #">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="LOTNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="JO Qty.">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ProdQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prod_Qty") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Released">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ReleasedBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Released_By") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Input Qty">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="InQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "In_Qty") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="On Hold Qty">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="OnHoldQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "On_Hold_Qty") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Output Qty">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="OutQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Out_Qty") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Status">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="JOStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "JO_Status") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ReleasedDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Released_Date") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="right">
                                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="143px" Text="Back"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
