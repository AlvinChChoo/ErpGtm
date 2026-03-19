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
        'StrSql = "SELECT so.CSD_App_by,so.so_status,so.csd_app_date,so.pcmc_app_date,So.PCMC_APP_BY,CUST.CUST_Code + '|' + Cust.Cust_Name as [Cust_Code] ,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.ORDER_QTY, SO.MODEL_NO, SO.SEQ_NO FROM SO_MODELS_M SO, cust WHERE " & cmbBy.selectedItem.value & " LIKE '%" & txtSearch.Text & "%' AND SO.CUST_CODE = CUST.CUST_cODE  ORDER BY SO.so_date desc"
    
        StrSql = "SELECT so.CSD_App_by,so.so_status,so.csd_app_date,so.pcmc_app_date,So.PCMC_APP_BY,CUST.CUST_Code + '|' + Cust.Cust_Name as [Cust_Code] ,SO.CSD_APP_BY,SO.LOT_NO, SO.SO_DATE, SO.CUST_CODE, SO.ORDER_QTY, SO.MODEL_NO, SO.SEQ_NO FROM SO_MODELS_M SO, cust WHERE " & cmbBy.selectedItem.value & " LIKE '%" & txtSearch.Text & "%' AND SO.CUST_CODE = CUST.CUST_code AND SO.SO_STATUS LIKE '%" & trim(cmbSOStatus.selecteditem.value) & "%' ORDER BY SO.so_date desc"
    
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SO_MODELS_M")
            GridControl1.DataSource=resExePagedDataSet.Tables("SO_MODELS_M").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM
        response.redirect("SalesOrderModelAdd.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(2).Text = format(cdate(e.Item.Cells(2).Text),"dd/MMM/yy")
            Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
            Dim App2By As Label = CType(e.Item.FindControl("App2By"), Label)
            Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
            Dim CSDAppBy As Label = CType(e.Item.FindControl("CSDAppBy"), Label)
            Dim Submit As checkbox = CType(e.Item.FindControl("Submit"), checkbox)
            Dim ImgCancel As ImageButton = CType(e.Item.FindControl("ImgCancel"), ImageButton)
            Dim SOStatus As Label = CType(e.Item.FindControl("SOStatus"), Label)
    
            if CSDAppBy.text <> "" then
                Submit.checked = true
                submit.enabled = false
            else
                Submit.checked = false
                submit.enabled = true
            end if
    
            if ucase(trim(SOStatus.text)) = "APPROVED" Then ImgCancel.visible = true
            if ucase(trim(SOStatus.text)) <> "APPROVED" Then ImgCancel.visible = false
    
    
            if App1Date.text <> "" then App1By.text = App1By.text & "-" & format(cdate(App1Date.text),"dd/MM/yy")
            if App2Date.text <> "" then App2By.text = App2By.text & "-" & format(cdate(App2Date.text),"dd/MM/yy")
            if App1By.text = "" then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim Submit As CheckBox
        Dim LotNo As label
    
        For i = 0 To gridcontrol1.Items.Count - 1
            Submit = CType(gridcontrol1.Items(i).FindControl("Submit"), CheckBox)
            LotNo = CType(gridcontrol1.Items(i).FindControl("LotNo"), Label)
    
            if Submit.checked = true then
                ReqCOM.ExecuteNonQuery("Update SO_MODELS_M set CSD_App_by = '" & trim(request.cookies("U_ID").value) & "', CSD_App_Date = '" & now & "',so_status = 'PENDING APPROVAL' where Lot_No = '" & trim(LotNo.text) & "';")
            end if
        Next i
        ShowAlert ("Selected S/O has been submitted to PCMC.")
        redirectPage("SalesOrderModel.aspx")
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
    
    Sub ItemCommandSO(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("SalesOrderModelDet.aspx?ID=" & clng(SeqNo.text))
        if ucase(e.commandArgument) = "CANCEL" then Response.redirect("SalesOrderModelCancel.aspx?ID=" & clng(SeqNo.text))
    end sub

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
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">SALES
                                ORDER LIST (by Model)</asp:Label>
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
                                                                                            <asp:TextBox id="txtSearch" runat="server" Width="140px" CssClass="OutputText"></asp:TextBox>
                                                                                            &nbsp; <asp:Label id="Label3" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp; 
                                                                                            <asp:DropDownList id="cmbBy" runat="server" CssClass="OutputText">
                                                                                                <asp:ListItem Value="SO.LOT_NO">LOT NO</asp:ListItem>
                                                                                                <asp:ListItem Value="SO.MODEL_NO">MODEL NO</asp:ListItem>
                                                                                                <asp:ListItem Value="CUST.CUST_CODE">CUSTOMER CODE</asp:ListItem>
                                                                                                <asp:ListItem Value="CUST.CUST_NAME">CUSTOMER NAME</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            &nbsp;<asp:Label id="Label4" runat="server" cssclass="OutputText">SHOW</asp:Label> 
                                                                                            <asp:DropDownList id="cmbSOStatus" runat="server" CssClass="OutputText">
                                                                                                <asp:ListItem Value="">ALL</asp:ListItem>
                                                                                                <asp:ListItem Value="PENDING APPROVAL">PENDING APPROVAL</asp:ListItem>
                                                                                                <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                                                                <asp:ListItem Value="CANCELLED">CANCELLED</asp:ListItem>
                                                                                                <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                                                                <asp:ListItem Value="CLOSED">CLOSED</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            &nbsp;&nbsp; 
                                                                                            <asp:Button id="Button2" onclick="cmdSearch_Click" runat="server" Width="52px" CssClass="OutputText" Text="GO"></asp:Button>
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
                                                                        <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:Button id="Button1" onclick="cmdAddNew_Click" runat="server" Width="152px" CssClass="OutputText" Text="Add New Sales Order"></asp:Button>
                                                                                        </p>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="center">
                                                                                            <asp:Button id="Button3" onclick="cmdSubmit_Click" runat="server" Width="152px" CssClass="OutputText" Text="Submit Selected S/O"></asp:Button>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="right">
                                                                                            <asp:Button id="Button4" onclick="cmdBack_Click" runat="server" Width="152px" CssClass="OutputText" Text="Back" CausesValidation="False"></asp:Button>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Gray" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" AllowSorting="True" OnItemCommand="ItemCommandSO">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="Action">
                                                                                    <ItemTemplate>
                                                                                        <asp:ImageButton id="ImgView" ToolTip="View this S/O" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                                                                        <asp:ImageButton id="ImgCancel" ToolTip="Cancel this S/O" ImageUrl="Delete.gif" CommandArgument='Cancel' runat="server"></asp:ImageButton>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Lot No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="LotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' /> <asp:Label id="SeqNo" runat="server" visible="false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="SO_DATE" HeaderText="Issued Date" DataFormatString="{0:d}"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Cust_cODE" HeaderText="Customer Code/Name"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="ORDER_QTY" HeaderText="Lot Qty.">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="MODEL_NO" HeaderText="Model No"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="CSD App.">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CSD_APP_BY") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="PCMC App.">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PCMC_APP_BY") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CSD_APP_Date") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PCMC_APP_Date") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Status">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SOStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SO_Status") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="CSDAppBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CSD_App_by") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Submit">
                                                                                    <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <center>
                                                                                            <asp:CheckBox id="Submit" runat="server" />
                                                                                        </center>
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
                                                                        <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="152px" CssClass="OutputText" Text="Add New Sales Order"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="152px" CssClass="OutputText" Text="Submit Selected S/O"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="152px" CssClass="OutputText" Text="Back" CausesValidation="False"></asp:Button>
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
