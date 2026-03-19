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
        if page.isPostBack = false then LoadSOList()
    End Sub
    
    Sub LoadSOList()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update SO_Model_M set RESCH_PROD_DATE = prod_date where RESCH_PROD_DATE is null")
        ReqCOM.ExecuteNonQuery("Update SO_Model_M set PREV_RESCH_PROD_DATE = RESCH_PROD_DATE where PREV_RESCH_PROD_DATE is null")
        Dim StrSql as string = "Select so.req_date,so.prod_date,so.resch_prod_date,so.prev_resch_prod_date,cust.cust_name,so.seq_no,so.lot_no,so.po_no,so.po_date,so.cust_code,so.model_no,so.prod_date,so.order_qty from so_model_m SO,cust where so.lot_close = 'N' and so.cust_code = cust.cust_code order by so.seq_no asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"so_model_m")
        dtgSOList.DataSource=resExePagedDataSet.Tables("so_model_m").DefaultView
        dtgSOList.DataBind()
    end sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        LoadSOList()
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim PODate As Label = CType(e.Item.FindControl("PODate"), Label)
            Dim TempProdDate As Label = CType(e.Item.FindControl("TempProdDate"), Label)
            Dim PrevReschProdDate As Label = CType(e.Item.FindControl("PrevReschProdDate"), Label)
            Dim ReschProdDate As textbox = CType(e.Item.FindControl("ReschProdDate"), textbox)
            Dim DelDate As Label = CType(e.Item.FindControl("DelDate"), Label)
            PODate.text = format(cdate(PODate.text),"dd/MM/yy")
            TempProdDate.text = format(cdate(TempProdDate.text),"dd/MM/yy")
            ReschProdDate.text = format(cdate(ReschProdDate.text),"dd/MM/yy")
            DelDate.text = format(cdate(DelDate.text),"dd/MM/yy")
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ValDuplicateDate(sender As Object, e As ServerValidateEventArgs)
        Dim CMonth,CDay,CYear as integer
        Dim CDt as string
        Dim ReschProdDate As Textbox
        Dim i as integer
    
        For i = 0 To dtgSOList.Items.Count - 1
            ReschProdDate = Ctype(dtgSOList.Items(i).FindControl("ReschProdDate"), Textbox)
            if len(trim(ReschProdDate.text)) <> 8 then CustomValidator1.text = "You don't seem to have supplied a valid FOL Date." : e.isvalid = false :Exit sub
            CDt = ReschProdDate.text
    
            if isnumeric(CDt.substring(3,2)) = true then
                Cmonth = CDt.substring(3,2)
            else
                 CustomValidator1.text = "You don't seem to have supplied a valid FOL Date." : e.isvalid = false :Exit sub
            end if
    
            if isnumeric(CDt.substring(0,2)) = true then
                CDay = CDt.substring(0,2)
            else
                 CustomValidator1.text = "You don't seem to have supplied a valid FOL Date." : e.isvalid = false :Exit sub
            end if
    
            if isnumeric(CDt.substring(6,2)) = true then
                CYear = CDt.substring(6,2)
            else
                 CustomValidator1.text = "You don't seem to have supplied a valid FOL Date." : e.isvalid = false :Exit sub
            end if
    
            Cdt = CMonth & "/" & Cday & "/" & CYear
            if isdate(cdt) = false then CustomValidator1.text = "You don't seem to have supplied a valid FOL Date." : e.isvalid = false :Exit sub
        next
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub dtgSOList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim SeqNo,i,CMonth,CDay,CYear as integer
            Dim CDt as string
            Dim ReschProdDate as Textbox
            Dim ProdDate,LotNo,PrevReschProdDate as label
    
            if page.isvalid = true then
                For i = 0 To dtgSOList.Items.Count - 1
                    ReschProdDate = CType(dtgSOList.Items(i).FindControl("ReschProdDate"), textbox)
                    ProdDate = CType(dtgSOList.Items(i).FindControl("ProdDate"), label)
                    LotNo = CType(dtgSOList.Items(i).FindControl("LotNo"), label)
                    PrevReschProdDate = CType(dtgSOList.Items(i).FindControl("PrevReschProdDate"), label)
                    Cdt = trim(ReschProdDate.text)
                    Cmonth = CDt.substring(3,2)
                    CDay  = CDt.substring(0,2)
                    CYear = CDt.substring(6,2)
                    Cdt = CMonth & "/" & Cday & "/" & CYear
                    if cdate(PrevReschProdDate.text) <> cdate(CDt) then
                        ReqCOM.ExecuteNonQuery("Insert into SO_FOL_TRAIL(SO_NO,FOL,CON_FOL,CREATE_BY,CREATE_date) select '" & trim(LotNo.text) & "','" & cdate(ProdDate.text) & "','" & cdate(CDt) & "','" & trim(request.cookies("U_ID").value) & "','" & now & "'")
                        ReqCOM.ExecuteNonQuery("Update SO_MODEL_M set Resch_Prod_Date = '" & cdate(CDt) & "' where Lot_No = '" & trim(LotNo.text) & "';")
                    end if
                next i
            end if
            Response.redirect("SOFOLSetting.aspx")
        end if
    End Sub
    
    Sub cmdViewHistory_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=SOFOLTrail")
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">SALES ORDER
                                FOL DATE RESCHEDULE</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" ForeColor=" " CssClass="ErrorText" OnServerValidate="ValDuplicateDate" Display="Dynamic" Width="100%"></asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgSOList" runat="server" width="100%" OnItemDataBound="FormatRow" AllowSorting="True" OnSortCommand="SortGrid" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgSOList_SelectedIndexChanged" Font-Names="Verdana">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Lot #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "LOT_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Model">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModelNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Lot Size">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LotSize" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Order_Qty") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Customer">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CustCode" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Cust_Name") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PO #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PO_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PO Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PODate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PO_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PrevReschproddate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prev_Resch_prod_date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PrevProdDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prev_Resch_Prod_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Delv. Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="DelDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="FOL">
                                                                <ItemTemplate>
                                                                    <asp:Label id="TempProdDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prod_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Revised FOL">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="ReschProdDate" cssclass="OutputText" width="80px" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Resch_Prod_Date") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ProdDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prod_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Text="Update FOL Date"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdViewHistory" onclick="cmdViewHistory_Click" runat="server" Text="View History"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="134px" Text="Back"></asp:Button>
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
