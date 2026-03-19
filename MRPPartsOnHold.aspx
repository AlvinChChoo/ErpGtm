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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            If SortField = "" then SortField = "ETA_DATE"
            procLoadGridData ()
            lblMRPNo.text = ReqCOM.GetFieldVal("Select top 1 MRP_No from MRP_M order by seq_no desc","MRP_No")
            lblLastMRPRun.text = ReqCOM.GetFieldVal("select top 1 'Last MRP Explosion as at ' + CONVERT(varchar(20), end_Date, 13) + ' (MRP No : ' + cast(MRP_No as nvarchar(20)) + ')' as [LastMRP] from mrp_history_m order by seq_no desc","LastMRP")
        End if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        UpdateOnHoldQty
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim strSql as string
            Dim SortSeq as string
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        strSql = "SELECT mrp.Gross_req_qty,mrp.p_usage,MRP.spq,MRP.moq,MRP.ATT,mrp.part_status,mrp.lead_time,left(mrp.ven_name,12) + '...' as [ven_name],mrp.On_Hold,mrp.P_Level,mrp.Sch_Days,PM.WIP,MRP.Earliest_Date,MRP.Lot_No,Net_ETA as [NetETA],MRP.Model_No, PM.PART_DESC AS [PART_DESC],PM.BUYER_CODE,MRP.SEQ_NO,MRP.PART_NO,MRP.BOM_DATE,MRP.eta_date,MRP.NET_REQ_QTY FROM MRP_D_net MRP,PART_MASTER PM where MRP.PART_NO = pm.PART_NO and mrp.type <> 'F' and lead_time is not null and " & trim(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' ORDER BY " & trim(SortField) & " " & trim(SortSeq)
    
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"MRP_D_net")
        GridControl1.DataSource=resExePagedDataSet.Tables("MRP_D_net").DefaultView
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
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        procLoadGridData ()
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim GrossReqQty As Label = CType(e.Item.FindControl("GrossReqQty"), Label)
        Dim ETaDate As Label = CType(e.Item.FindControl("ETaDate"), Label)
        Dim NetReqQty As Label = CType(e.Item.FindControl("NetReqQty"), Label)
        Dim ModelNo As Label = CType(e.Item.FindControl("ModelNo"), Label)
        Dim PartStatus As Label = CType(e.Item.FindControl("PartStatus"), Label)
        Dim chkOnHold As checkbox = CType(e.Item.FindControl("chkOnHold"), checkbox)
    
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            if trim(PartStatus.text) = "ON HOLD" then chkOnHold.checked = true
            NetReqQty.text = clng(NetReqQty.text)
            ModelNo.text = "(" & trim(ModelNo.text) & ")"
            e.item.cells(10).text = format(cdate(e.item.cells(10).text),"dd/MM/yy")
        End if
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdUpdateOnHoldQty_Click(sender As Object, e As EventArgs)
        UpdateOnHoldQty
    End Sub
    
    Sub UpdateOnHoldQty
        Dim i as integer
        Dim OnHold As Textbox
        Dim SeqNo As Label
        Dim chkOnHold As Checkbox
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim selected,NotSelected as string
    
        selected = "0"
        NotSelected = "0"
    
        For i = 0 To GridControl1.Items.Count - 1
            chkOnHold = CType(GridControl1.Items(i).FindControl("chkOnHold"), Checkbox)
            SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
            if chkOnHold.checked = true then Selected = Selected & "," & clng(SeqNo.text)
            if chkOnHold.checked <> true then NotSelected = NotSelected & "," & clng(SeqNo.text)
        Next i
    
        ReqCOM.ExecuteNonQUery("Update mrp_d_net set Part_Status = 'ON HOLD',On_Hold = net_req_qty,Post = 'Y' where seq_no in (" & trim(Selected) & ")")
        ReqCOM.ExecuteNonQUery("Update mrp_d_net set Part_Status = 'PENDING SUBMISION',On_Hold = 0,Post = 'N' where seq_no in (" & trim(NotSelected) & ")")
        ProcLoadGridData
    End sub
    
    Public function ValidateOnHoldQty as boolean
    End Function
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label5" runat="server" width="100%" cssclass="FormDesc">MRP - PARTS
                                PENDING P/R SUBMISSION</asp:Label><asp:Label id="lblLastMRPRun" runat="server" width="100%" cssclass="SectionHeader"></asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 10px" width="98%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="lblMRPNo" runat="server" visible="False"></asp:Label><asp:Label id="Label1" runat="server" cssclass="OutputText">Search </asp:Label>&nbsp; 
                                                    <asp:TextBox id="txtSearch" onkeydown="KeyDownHandler(cmdGO)" runat="server" Width="235px" CssClass="OutputText"></asp:TextBox>
                                                    &nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">by</asp:Label>&nbsp; 
                                                    <asp:DropDownList id="cmbSearchField" runat="server" Width="148px" CssClass="OutputText">
                                                        <asp:ListItem Value="MRP.Part_No">PART NO</asp:ListItem>
                                                        <asp:ListItem Value="MRP.Model_No">MODEL NO</asp:ListItem>
                                                        <asp:ListItem Value="MRP.Lot_No">LOT NO</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                    <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" Width="58px" CssClass="OutputText" CausesValidation="False" Text="GO"></asp:Button>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <asp:DataGrid id="GridControl1" runat="server" width="98%" onsortcommand="SortGrid" AllowSorting="True" OnItemDataBound="FormatRow" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Gray" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False">
                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                    <Columns>
                                        <asp:TemplateColumn>
                                            <ItemTemplate>
                                                <asp:Hyperlink ID="Hyperlink2" ToolTip="View this P/R" imageURL="view.gif" Runat="Server" NavigateUrl= <%#"javascript:my_window=window.open('PopupReportViewer.aspx?RptName=MRPAllocation&PartFrom=" + DataBinder.Eval(Container.DataItem,"Part_No").ToString() + "&PartTo=?&By=Part','my_window','resizable=1,scrollbars=1');my_window.focus()" %>></asp:Hyperlink>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="Part_No" SortExpression="mrp.Part_No" HeaderText="Part No"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderText="Lot #(Model #)">
                                            <ItemTemplate>
                                                <asp:Label id="LotNo" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "lot_no") %>' /> <asp:Label id="ModelNo" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "model_no") %>' /> <asp:Label id="SeqNo" runat="server" visible= "false" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Seq_no") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Level">
                                            <ItemTemplate>
                                                <asp:Label id="PLevel" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "P_Level") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="False" HeaderText="Gross Req. Qty">
                                            <ItemTemplate>
                                                <asp:Label id="GrossReqQty1" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "GROSS_REQ_QTY") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Usage">
                                            <ItemTemplate>
                                                <asp:Label id="PUsage" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Att">
                                            <ItemTemplate>
                                                <asp:Label id="Att" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Att") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="WIP">
                                            <ItemTemplate>
                                                <asp:Label id="WIP" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "WIP") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Net Req. Qty">
                                            <ItemTemplate>
                                                <asp:Label id="NetReqQty" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "net_req_qty") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="False" HeaderText="On Hold">
                                            <ItemTemplate>
                                                <asp:Textbox id="OnHold1" runat="server" cssclass="outputText" width="50px" text='<%# DataBinder.Eval(Container.DataItem, "on_hold") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="ETA_DATE" SortExpression="ETA_DATE" HeaderText="ETA Date"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderText="Supplier Name">
                                            <ItemTemplate>
                                                <asp:Label id="VenName" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Name") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="L/T">
                                            <ItemTemplate>
                                                <asp:Label id="LeadTime" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Lead_Time") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="MOQ/SPQ">
                                            <ItemTemplate>
                                                <asp:Label id="MOQ" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "MOQ") %>' /> /<asp:Label id="SPQ" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "SPQ") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Part Status">
                                            <ItemTemplate>
                                                <asp:Label id="PartStatus" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "part_status") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="On Hold">
                                            <ItemTemplate>
                                                <asp:checkbox id="chkOnHold" runat="server" cssclass="outputText" width="50px" />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                </asp:DataGrid>
                            </p>
                            <p>
                                <table style="HEIGHT: 14px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Button id="cmdUpdateOnHoldQty" onclick="cmdUpdateOnHoldQty_Click" runat="server" Width="168px" Text="On Hold Selected Lots"></asp:Button>
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
    </form>
</body>
</html>
