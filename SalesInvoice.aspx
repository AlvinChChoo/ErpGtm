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
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        'StrSql = "SELECT so.CSD_App_by,so.so_status,so.csd_app_date,so.pcmc_app_date,So.PCMC_APP_BY,CUST.CUST_Code + '|' + Cust.Cust_Name as [Cust_Code] ,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.ORDER_QTY, SO.MODEL_NO, SO.SEQ_NO FROM SO_MODELS_M SO, cust WHERE " & cmbBy.selectedItem.value & " LIKE '%" & txtSearch.Text & "%' AND SO.CUST_CODE = CUST.CUST_cODE  ORDER BY SO.so_date desc"
        StrSql = "Select * from Sales_Invoice_M order by SI_No asc"
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SO_MODELS_M")
            GridControl1.DataSource=resExePagedDataSet.Tables("SO_MODELS_M").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ShowInvoice(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Response.redirect("SalesInvoiceDet.aspx?ID=" & clng(SeqNo.text))
    End sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("SalesInvoiceAdd.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        'Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        'If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
        '    E.Item.Cells(2).Text = format(cdate(e.Item.Cells(2).Text),"dd/MMM/yy")
        '    Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
    
    
        '    Dim Submit As checkbox = CType(e.Item.FindControl("Submit"), checkbox)
    
        '    if CSDAppBy.text <> "" then
        '        Submit.checked = true
        '        submit.enabled = false
        '    else
        '        Submit.checked = false
        '        submit.enabled = true
        '    end if
    
    
        '    if App1Date.text <> "" then App1By.text = App1By.text & "-" & format(cdate(App1Date.text),"dd/MM/yy")
        '    if App2Date.text <> "" then App2By.text = App2By.text & "-" & format(cdate(App2Date.text),"dd/MM/yy")
        '    if App1By.text = "" then e.Item.CssClass = "PartSource"
        'End if
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        'Dim i as integer
        'Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        'Dim Submit As CheckBox
        'Dim LotNo As label
    
        'For i = 0 To gridcontrol1.Items.Count - 1
        '    Submit = CType(gridcontrol1.Items(i).FindControl("Submit"), CheckBox)
        '    LotNo = CType(gridcontrol1.Items(i).FindControl("LotNo"), Label)
    
        '    if Submit.checked = true then
        '        ReqCOM.ExecuteNonQuery("Update SO_MODELS_M set CSD_App_by = '" & trim(request.cookies("U_ID").value) & "', CSD_App_Date = '" & now & "',so_status = 'PENDING APPROVAL' where Lot_No = '" & trim(LotNo.text) & "';")
        '    end if
        'Next i
        'ShowAlert ("Selected S/O has been submitted to PCMC.")
        'redirectPage("SalesOrderModel.aspx")
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub

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
                                <asp:Label id="Label1" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">SALES
                                INVOICES</asp:Label>
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
                                                                                            <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="163px"></asp:TextBox>
                                                                                            &nbsp; <asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp; 
                                                                                            <asp:DropDownList id="cmbBy" runat="server" CssClass="OutputText" Width="167px">
                                                                                                <asp:ListItem Value="SI_NO">SALES INVOICE #</asp:ListItem>
                                                                                                <asp:ListItem Value="CUST_NAME + CUST_CODE">CUSTOMER</asp:ListItem>
                                                                                                <asp:ListItem Value="MODEL_NO + MODEL_NAME">MODEL</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                            <asp:Button id="Button2" onclick="cmdSearch_Click" runat="server" CssClass="OutputText" Width="69px" Text="GO"></asp:Button>
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
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" AllowSorting="True" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" OnEditCommand="ShowInvoice" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" OnPageIndexChanged="OurPager">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                                                <asp:TemplateColumn HeaderText="Invoice #">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SINo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SI_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Customer">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="CustName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Cust_Name") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Invoice Date">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SIDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SI_Date") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn Visible= "false">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
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
                                                                    <p>
                                                                        <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="167px" Text="New Sales Invoice"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="158px" Text="Submit Sales Invoice"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="111px" Text="Back" CausesValidation="False"></asp:Button>
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
