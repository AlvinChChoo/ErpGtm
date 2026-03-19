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
            If SortField = "" then SortField = "so.req_date"
            ProcLoadGridData()
        End if
    End Sub
    
    Sub ProcLoadGridData()
        Dim SortSeq as string
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        if ucase(trim(cmbShowLot.selecteditem.value)) = "ALL" then StrSql = "SELECT so.req_date,so.fol,so.CSD_App_by,so.so_status,so.csd_app_date,so.pcmc_app_date,So.PCMC_APP_BY,CUST.CUST_Code + '-' + left(Cust.Cust_Name,13) + '...' as [Cust_Code] ,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.ORDER_QTY, SO.MODEL_NO, SO.SEQ_NO FROM SO_MODELS_M SO, cust WHERE " & cmbBy.selectedItem.value & " LIKE '%" & txtSearch.Text & "%' AND SO.CUST_CODE = CUST.CUST_cODE and SO.so_status in ('APPROVED','MRP ON HOLD')  ORDER BY " & trim(SortField) & " " & trim(SortSeq)
        if ucase(trim(cmbShowLot.selecteditem.value)) = "EXPIRED" then StrSql = "SELECT so.req_date,so.fol,so.CSD_App_by,so.so_status,so.csd_app_date,so.pcmc_app_date,So.PCMC_APP_BY,CUST.CUST_Code + '-' + left(Cust.Cust_Name,13) + '...' as [Cust_Code] ,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.ORDER_QTY, SO.MODEL_NO, SO.SEQ_NO FROM SO_MODELS_M SO, cust WHERE " & cmbBy.selectedItem.value & " LIKE '%" & txtSearch.Text & "%' and so.req_date <= '" & now & "' AND SO.CUST_CODE = CUST.CUST_cODE and SO.so_status in ('APPROVED','MRP ON HOLD')  ORDER BY " & trim(SortField) & " " & trim(SortSeq)
        if ucase(trim(cmbShowLot.selecteditem.value)) = "ONHOLD" then StrSql = "SELECT so.req_date,so.fol,so.CSD_App_by,so.so_status,so.csd_app_date,so.pcmc_app_date,So.PCMC_APP_BY,CUST.CUST_Code + '-' + left(Cust.Cust_Name,13) + '...' as [Cust_Code] ,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.ORDER_QTY, SO.MODEL_NO, SO.SEQ_NO FROM SO_MODELS_M SO, cust WHERE " & cmbBy.selectedItem.value & " LIKE '%" & txtSearch.Text & "%' and SO.CUST_CODE = CUST.CUST_cODE and SO.so_status = 'MRP ON HOLD' ORDER BY " & trim(SortField) & " " & trim(SortSeq)
    
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SO_MODELS_M")
        GridControl1.DataSource=resExePagedDataSet.Tables("SO_MODELS_M").DefaultView
        GridControl1.DataBind()
    end sub
    
    Property SortField() As String
        Get
            Dim o As Object = ViewState("SortField")
            If o Is Nothing Then
                Return [String].Empty
            End If
            Return CStr(o)
        End Get
        Set(ByVal Value As String)
            If Value = SortField Then
                SortAscending = Not SortAscending
            End If
            ViewState("SortField") = Value
        End Set
    End Property
    
    Property SortAscending() As Boolean
        Get
            Dim o As Object = ViewState("SortAscending")
    
            If o Is Nothing Then
                Return True
            End If
            Return CBool(o)
        End Get
        Set(ByVal Value As Boolean)
            ViewState("SortAscending") = Value
        End Set
    End Property
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        procLoadGridData ()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SODate,SOStatus,ReqDate,FOL As Label
        Dim chkOnHold As Checkbox
    
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            SODate = CType(e.Item.FindControl("SODate"), Label)
            FOL = CType(e.Item.FindControl("FOL"), Label)
            ReqDate = CType(e.Item.FindControl("ReqDate"), Label)
            SOStatus = CType(e.Item.FindControl("SOStatus"), Label)
            chkOnHold = CType(e.Item.FindControl("chkOnHold"), Checkbox)
            if trim(SOStatus.text) = "MRP ON HOLD" then chkOnHold.checked = true
            SODate.text = format(cdate(SODate.text),"dd/MM/yy")
            FOL.text = format(cdate(FOL.text),"dd/MM/yy")
    
            e.item.cells(2).text = format(cdate(e.item.cells(2).text),"dd/MM/yy")
    
        End if
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim chkOnHold As CheckBox
        Dim SeqNo As label
        Dim Selected,NotSelected as string
    
        For i = 0 To gridcontrol1.Items.Count - 1
            chkOnHold = CType(gridcontrol1.Items(i).FindControl("chkOnHold"), CheckBox)
            SeqNo = CType(gridcontrol1.Items(i).FindControl("SeqNo"), Label)
            if chkOnHold.checked = true then
                if trim(Selected) = "" then
                    Selected = clng(seqno.text)
                elseif trim(Selected) <> "" then
                    Selected = Selected & "," & clng(seqno.text)
                end if
            elseif chkOnHold.checked = false then
                if trim(NotSelected) = "" then
                    NotSelected = clng(seqno.text)
                elseif trim(NotSelected) <> "" then
                    NotSelected = NotSelected & "," & clng(seqno.text)
                end if
            end if
        Next i
    
        if Trim(Selected) <> "" then ReqCOM.ExecuteNonQuery("Update SO_Models_M set SO_Status = 'MRP ON HOLD' where seq_no in (" & Selected & ")")
        if Trim(NotSelected) <> "" then ReqCOM.ExecuteNonQuery("Update SO_Models_M set SO_Status = 'APPROVED' where seq_no in (" & NotSelected & ")")
        ShowAlert ("Lot On Hold Updated.")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">MRP
                                - LOT ON HOLD LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table height="100%" cellspacing="0" cellpadding="0" width="98%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="top" width="100%">
                                                <p align="center">
                                                    <table style="HEIGHT: 11px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="HEIGHT: 9px" width="100%" align="center">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label2" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp; 
                                                                                            <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="85px"></asp:TextBox>
                                                                                            &nbsp;<asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;<asp:DropDownList id="cmbBy" runat="server" CssClass="OutputText">
                                                                                                <asp:ListItem Value="SO.LOT_NO">LOT NO</asp:ListItem>
                                                                                                <asp:ListItem Value="SO.MODEL_NO">MODEL NO</asp:ListItem>
                                                                                                <asp:ListItem Value="CUST.CUST_CODE">CUSTOMER CODE</asp:ListItem>
                                                                                                <asp:ListItem Value="CUST.CUST_NAME">CUSTOMER NAME</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            &nbsp;<asp:Label id="Label4" runat="server" cssclass="OutputText">SHOW</asp:Label>&nbsp;<asp:DropDownList id="cmbShowLot" runat="server" CssClass="OutputText">
                                                                                                <asp:ListItem Value="ALL">ALL LOTS</asp:ListItem>
                                                                                                <asp:ListItem Value="EXPIRED">EXPIRED LOTS</asp:ListItem>
                                                                                                <asp:ListItem Value="ONHOLD">ON-HOLD LOTS</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            &nbsp;&nbsp;<asp:Button id="Button2" onclick="cmdSearch_Click" runat="server" CssClass="OutputText" Width="53px" Text="GO"></asp:Button>
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
                                                    <table style="HEIGHT: 27px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" onsortcommand="SortGrid" AutoGenerateColumns="False" cellpadding="4" BorderColor="Gray" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" OnPageIndexChanged="OurPager" AllowPaging="True" ShowFooter="True" AllowSorting="True">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="Lot No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="LotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' /> <asp:Label id="SeqNo" runat="server" visible="false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Iss. Date">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SODate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SO_DATE") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="REQ_Date" SortExpression="so.req_date" HeaderText="Req. Date"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="FOL">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="FOL" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FOL") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="Cust_cODE" HeaderText="Customer Code/Name"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Model_No" SortExpression="so.model_no" HeaderText="Model No"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="ORDER_QTY" HeaderText="Lot Qty.">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Status">
                                                                                    <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Left"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SOStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "so_sTATUS") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="On Hold">
                                                                                    <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Center" verticalalign="Top"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Checkbox id="chkOnHold" runat="server" />
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
                                                    <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="cmdOnHold" onclick="cmdSubmit_Click" runat="server" CssClass="OutputText" Width="158px" Text="On Hold Selected S/O"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="111px" Text="Back" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
