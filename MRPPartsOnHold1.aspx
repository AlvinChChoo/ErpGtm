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
            procLoadGridData ()
            lblMRPNo.text = ReqCOM.GetFieldVal("Select top 1 MRP_No from MRP_M order by seq_no desc","MRP_No")
            lblLastMRPRun.text = ReqCOM.GetFieldVal("select top 1 'Last MRP Explosion as at ' + CONVERT(varchar(20), end_Date, 13) + ' (MRP No : ' + cast(MRP_No as nvarchar(20)) + ')' as [LastMRP] from mrp_history_m order by seq_no desc","LastMRP")
        End if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        if ValidateOnHoldQty = true then
            gridControl1.CurrentPageIndex = e.NewPageIndex
            ProcLoadGridData()
        End if
    end sub
    
    Sub ProcLoadGridData()
        Dim strSql as string
        strSql = "SELECT mrp.Gross_req_qty,mrp.p_usage,MRP.ATT,mrp.part_status,mrp.lead_time, mrp.SPQ, mrp.MOQ, mrp.ven_name,mrp.On_Hold,mrp.P_Level,mrp.Sch_Days,PM.WIP,MRP.Earliest_Date,MRP.Lot_No,Net_ETA as [NetETA],MRP.Model_No, PM.PART_DESC AS [PART_DESC],PM.BUYER_CODE,MRP.SEQ_NO,MRP.PART_NO,MRP.BOM_DATE,MRP.eta_date,MRP.NET_REQ_QTY FROM MRP_D_net MRP,PART_MASTER PM where MRP.PART_NO = pm.PART_NO and mrp.type <> 'F' and lead_time is not null and " & trim(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' order by MRP.part_no asc"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"MRP_D_net")
        GridControl1.DataSource=resExePagedDataSet.Tables("MRP_D_net").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim GrossReqQty As Label = CType(e.Item.FindControl("GrossReqQty"), Label)
        Dim ETaDate As Label = CType(e.Item.FindControl("ETaDate"), Label)
        Dim NetReqQty As Label = CType(e.Item.FindControl("NetReqQty"), Label)
        Dim ModelNo As Label = CType(e.Item.FindControl("ModelNo"), Label)
    
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            GrossReqQty.text = clng(GrossReqQty.text)
            ETaDate.text = format(cdate(ETaDate.text),"dd/MM/yy")
            NetReqQty.text = clng(NetReqQty.text)
            ModelNo.text = "(" & trim(ModelNo.text) & ")"
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdUpdateOnHoldQty_Click(sender As Object, e As EventArgs)
        if ValidateOnHoldQty = true then UpdateOnHoldQty
    End Sub
    
    Sub UpdateOnHoldQty
        Dim i as integer
        Dim OnHold As Textbox
        Dim SeqNo,NetReqQty As Label
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
    
        For i = 0 To GridControl1.Items.Count - 1
            OnHold = CType(GridControl1.Items(i).FindControl("OnHold"), Textbox)
            SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
            If clng(OnHold.text) > 0 Then ReqCOM.ExecuteNonQuery ("Update MRP_D_net set Part_status = 'ON HOLD',ON_HOLD = " & CLng(OnHold.text) & ", POST='Y' where Seq_No = " & SeqNo.text & ";")
            If clng(OnHold.text) = 0 Then ReqCOM.ExecuteNonQuery ("Update MRP_D_net set Part_status = 'PENDING SUBMISION',ON_HOLD = 0, POST='N' where Seq_No = " & SeqNo.text & ";")
            ReqCOM.ExecuteNonQuery ("Update MRP_History_Part_Allocation set ON_HOLD = " & CLng(OnHold.text) & " where Ref_Seq_No = " & clng(SeqNo.text) & " and mrp_no = '" & trim(lblMRPNo.text) & "';")
        Next i
        ProcLoadGridData
    End sub
    
    Public function ValidateOnHoldQty as boolean
        Dim i as integer
        Dim OnHold As Textbox
        Dim SeqNo,NetReqQty As Label
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
    
        ValidateOnHoldQty = true
    
        For i = 0 To GridControl1.Items.Count - 1
            OnHold = CType(GridControl1.Items(i).FindControl("OnHold"), Textbox)
            NetReqQty = CType(GridControl1.Items(i).FindControl("NetReqQty"), label)
    
            if isnumeric(OnHold.text) = false then
                ShowAlert("Error Line " & clng(i+1) & " : Invalid Quantity On-Hold.")
                ValidateOnHoldQty = false
                exit function
            End if
    
            if clng(NetReqQty.text) < clng(OnHold.text) then
                ShowAlert ("Error Line " & clng(i+1) & " : On Hold Qty cannot be greater than Req. Qty.")
                ValidateOnHoldQty = false
                exit function
            End if
        Next i
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
                                <asp:Label id="Label5" runat="server" font-bold="True" width="100%" cssclass="FormDesc">MRP
                                - PARTS PENDING P/R SUBMISSION</asp:Label><asp:Label id="lblLastMRPRun" runat="server" width="100%" cssclass="SectionHeader"></asp:Label>
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
                                <asp:DataGrid id="GridControl1" runat="server" width="98%" OnItemDataBound="FormatRow" OnPageIndexChanged="OurPager" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" AllowPaging="True" BorderColor="Black" GridLines="None" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False">
                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                    <PagerStyle mode="NumericPages" nextpagetext="Next" prevpagetext="Prev"></PagerStyle>
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <HeaderStyle cssclass="GridHeaderSmall" bordercolor="White"></HeaderStyle>
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="Part No/Desc.">
                                            <ItemTemplate>
                                                <asp:Label id="PartNo" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> <asp:Label id="SeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> - <asp:Label id="PartDesc" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "part_desc") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Lot #(Model #)">
                                            <ItemTemplate>
                                                <asp:Label id="LotNo" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "lot_no") %>' /> <asp:Label id="ModelNo" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "model_no") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Level">
                                            <ItemTemplate>
                                                <asp:Label id="PLevel" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "P_Level") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Gross Req. Qty">
                                            <ItemTemplate>
                                                <asp:Label id="GrossReqQty" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "GROSS_REQ_QTY") %>' /> 
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
                                        <asp:TemplateColumn HeaderText="On Hold">
                                            <ItemTemplate>
                                                <asp:Textbox id="OnHold" runat="server" cssclass="outputText" width="50px" text='<%# DataBinder.Eval(Container.DataItem, "on_hold") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="ETA Date">
                                            <ItemTemplate>
                                                <asp:Label id="ETADate" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "ETA_DATE") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Supplier Name">
                                            <ItemTemplate>
                                                <asp:Label id="VenName" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Name") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Lead Time">
                                            <ItemTemplate>
                                                <asp:Label id="LeadTime" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Lead_Time") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="SPQ">
                                            <ItemTemplate>
                                                <asp:Label id="SPQ" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "SPQ") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="MOQ">
                                            <ItemTemplate>
                                                <asp:Label id="MOQ" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "MOQ") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Part Status">
                                            <ItemTemplate>
                                                <asp:Label id="PartStatus" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "part_status") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                </asp:DataGrid>
                            </p>
                            <p>
                                <table style="HEIGHT: 14px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Button id="cmdUpdateOnHoldQty" onclick="cmdUpdateOnHoldQty_Click" runat="server" Width="168px" Text="Update On Hold Qty"></asp:Button>
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
