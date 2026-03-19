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
        if page.isPostBack = false then
            Dim QtyDel as decimal
            Dim CurrDate as date = format(now,"dd/MMM/yyyy")
    
            lblSupplier.text = trim(request.params("VenCode"))
            lblMifNo.text = trim(request.params("MIFNo"))
            ShowMifDet
            GetNextControl(txtPONo)
        end if
    End Sub
    
    Sub ShowMifDet()
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim StrSql as string = "Select mif.foc_qty,MIF.IN_QTY,MIF.Del_Date,MIF.Seq_No,MIF.po_no, PM.Part_No,PM.Part_Desc from mif_D MIF, Part_Master PM where MIF.Part_No = PM.Part_No AND MIF_NO = '" & TRIM(lblMIFNo.text) & "' order by mif.seq_no desc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MIF_D")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("MIF_D").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim InQty As Label = CType(e.Item.FindControl("InQty"), Label)
            InQty.text = cint(InQty.text)
        End if
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .DataSource = ResExeDataReader
            .DataValueField = FValue
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmbPONo_SelectedIndexChanged(sender As Object, e As EventArgs)
        ShowPart()
    End Sub
    
    Sub ShowPart()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update PO_D set SCH_Date = Del_Date where po_no = '" & trim(cmbPONo.selectedItem.value) & "' and Sch_Date is null")
        Dim CurrDate as date = now
        cmbPartNo.items.clear
        Dissql("Select Part_No + '   |   ' + CONVERT(varchar(8), SCH_Date, 3)  as [Part_No],Seq_No from PO_D where PO_NO = '" & trim(cmbPONo.selectedItem.Text) & "' and month(Sch_Date) <= '" & month(now) & "';","Seq_No","Part_No",cmbPartNo)
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim QtyDel as decimal
        DisplayPartQty()
    End Sub
    
    Sub DisplayPartQty()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        lblOrderQty.text = ReqCOM.GetFieldVal("Select Order_Qty from PO_D where Seq_No = " & cmbPartNo.selectedItem.value & ";","Order_Qty")
        lblFOCQty.text = ReqCOM.GetFieldVal("Select FOC_Qty from PO_D where Seq_No = " & cmbPartNo.selectedItem.value & ";","FOC_Qty")
    
        lblUP.text = ReqCOM.GetFieldVal("Select UP from PO_D where Seq_No = " & cmbPartNo.selectedItem.value & ";","UP")
        Dim ETADate as datetime = ReqCOM.GetFieldVal("Select Del_Date from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Del_Date")
        Dim PartNo as string = ReqCOM.GetFieldVal("Select Part_No from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Part_No")
    
        lblQtyDel.text = ReqCOM.GetFieldVal("Select sum(In_Qty + FOC_Qty) as [TotalIn] from mif_d where part_no = '" & trim(PartNo) & "' and po_no = '" & trim(cmbPONo.selecteditem.value) & "' and del_date = '" & cdate(ETADate) & "'","TotalIn")
        if trim(lblQtyDel.text) = "<NULL>" then lblQtyDel.text = "0"
    
        lblPartDet.text = ReqCOM.GetFieldVal("Select Part_No + '-' + Part_Desc as [Part_Det] from part_master where part_no in (select part_no from po_d where seq_no = " & clng(cmbPartNo.selecteditem.value) & ");","Part_Det")
    
        lblWAC.text = ReqCOM.GetFieldVal("Select WAC_Cost from part_master where part_no = '" & trim(PartNo) & "';","WAC_Cost")
        lblCurrCode.text = ReqCOM.GetFieldVal("Select Curr_Code from Vendor where Ven_Code = '" & trim(lblSupplier.text) & "';","Curr_Code")
        lblUPRM.text = cdec(lblUP.text) * ReqCOM.GetFieldVal("Select Rate/unit_conv as [Desc] from curr where Curr_Code = '" & trim(lblCurrCode.text) & "';","Desc")
    End sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim InQty,FOCQty as long
            Dim StrSql as string
            Dim PartNo as string = ReqCOM.GetFieldVal("Select Part_No from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Part_No")
            Dim ETADate as datetime = ReqCOM.GetFieldVal("Select Del_Date from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Del_Date")
            Dim BalToShip as long = clng(lblOrderQty.text) - clng(lblQtyDel.text)
    
            if ReqCOM.funcCheckDuplicate("Select Top 1 MIF_NO from MIF_D where MIF_NO = '" & trim(lblMIFNo.text) & "' and Part_No = '" & trim(PartNo) & "' and po_no = '" & trim(cmbPONo.selecteditem.value) & "' and Del_Date = '" & ETADate & "';","MIF_NO") <> true then
    
                if clng(txtInQty.text) <= clng(BalToShip) then
                    InQty = clng(txtInQty.text)
                    FocQty = 0
                elseif clng(txtInQty.text) > clng(BalToShip) then
                    InQty = clng(BalToShip)
                    FOCQty = clng(txtInQty.text) - clng(BalToShip)
                end if
    
                StrSql = "Insert into MIF_D(MIF_NO,PO_NO,PART_NO,IN_QTY,Del_Date,Date_Receive,ORDER_QTY,FOC_QTY,UP,UP_RM,WAC) "
                StrSql = StrSql + "Select '" & trim(lblMIFNo.text) & "','" & trim(cmbPONo.selectedItem.text) & "','" & trim(PartNo) & "'," & cint(InQty) & ",'" & cdate(ETADate) & "','" & now & "'," & cdec(lblOrderQty.text) & "," & clng(FocQty) & "," & cdec(lblUP.text) & "," & cdec(lblUPRM.text) & "," & cdec(lblWAC.text) & ";"
    
                ReqCOM.ExecuteNonQuery(StrSql)
                cmbPONo.items.clear
                cmbPartNo.items.clear
                txtInQty.text = "0"
                response.redirect("PopupMIFItem.aspx?VenCode=" & Request.params("VenCode") & "&MIFNo=" & request.params("MIFNo"))
            Else
                ShowAlert("Part already exist.")
                redirectPage("PopupMIFItem.aspx?VenCode=" & Request.params("VenCode") & "&MIFNo=" & request.params("MIFNo"))
            end if
        End if
    End Sub
    
    Sub ValSources(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOM.FuncCheckDuplicate("Select Part_No from mif_d where MIF_NO = '" & trim(lblMIFNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.text) & "' and PO_NO = '" & trim(cmbPONo.selecteditem.text) & "';","Part_No") = true then
            e.isvalid = false
        End if
    End Sub
    
    Sub ValInQty(sender As Object, e As ServerValidateEventArgs)
        if txtInQty.text = "" then exit sub
        if isnumeric(txtInQty.text) = false then exit sub
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        response.redirect("MIFDet.aspx?ID=" & ReqCOM.GEtFIeldVal("select top 1 Seq_No from mif_m where mif_no = '" & trim(lblMIFNo.text) & "';","Seq_No"))
    End Sub
    
    Sub cmdViewPO_Click(sender As Object, e As EventArgs)
        if cmbPONo.selectedindex = -1 then
            ShowAlert("You don't seem to have select a valid P/O Mo.")
            Exit sub
        End if
    
        if cmbPartNo.selectedindex = -1 then
            ShowAlert("You don't seem to have select a valid Part No.")
            Exit sub
        End if
    
        Dim PartNo as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        PartNo = ReqCOM.GetFieldVal("Select Part_No from PO_D where Seq_No = " & trim(cmbPartNo.selecteditem.value) & ";","Part_No")
        ShowReport("PopupReportViewer.aspx?RptName=MIFPOPartTracking&PONo=" & trim(cmbPONo.selecteditem.value) & "&PartNo=" & trim(PartNo))
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim CurrDate as date = format(now,"dd/MMM/yy")
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dissql("Select PO_NO from PO_M where Ven_Code = '" & trim(lblSupplier.text) & "' and po_no like '%" & trim(txtPoNo.text) & "%';","PO_NO","PO_NO",cmbPONo)
    
        if cmbpono.selectedindex = 0 then
            ShowPart()
            if cmbPartNo.selectedindex = 0 then
                ShowDeliveryDet
                lblPartDet.text = ReqCOM.GetFieldVal("Select Part_No + '-' + Part_Desc as [Part_Det] from part_master where part_no in (select part_no from po_d where seq_no = " & clng(cmbPartNo.selecteditem.value) & ");","Part_Det")
                GetNextControl(txtPartNo)
            End if
        Elseif cmbpono.selectedindex <> 0 then
            lblOrderQty.text = ""
            ShowAlert("You don't seem to have supplied a valid P/O No.")
        end if
        txtPONo.text = "-- Search --"
    End Sub
    
    Sub cmdPartNo_Click(sender As Object, e As EventArgs)
        Dim CurrDate as date = now
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        ReqCOM.ExecuteNonQuery("Update PO_D set SCH_Date = Del_Date where po_no = '" & trim(cmbPONo.selectedItem.value) & "' and Sch_Date is null")
        cmbPartNo.items.clear
        Dissql("Select left(Part_No,20) + '   |   ' + CONVERT(VARCHAR(8), SCH_Date, 3)  as [Part_No],Seq_No from PO_D where PO_NO = '" & trim(cmbPONo.selectedItem.Text) & "' and part_no like '%" & trim(txtPartNo.text) & "%';","Seq_No","Part_No",cmbPartNo)
        ShowDeliveryDet()
        GetNextControl(txtInQty)
    End Sub
    
    Sub ShowDeliveryDet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if cmbPartNo.selectedindex <> -1 then DisplayPartQty()
        txtPartNo.text = "-- Search --"
    End sub
    
    Sub CustomValidator1_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        if (clng(txtInQty.text) + clng(lblQtyDel.text)) > clng(lblOrderQty.text) then e.isvalid = false
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if ucase(e.commandArgument) = "DELETE" then
            ReqCOM.ExecuteNonQuery("Delete from MIF_D where SEQ_NO = " & SeqNo.text & ";")
            response.redirect("PopupMIFItem.aspx?VenCode=" & Request.params("VenCode") & "&MIFNo=" & request.params("MIFNo"))
        End if
    end sub
    
    Sub GetNextControl(ByVal FocusControl As Control)
        Dim Script As New System.Text.StringBuilder
        Dim ClientID As String = FocusControl.ClientID
    
        Script.Append("<script language=javascript>")
        Script.Append("document.getElementById('")
        Script.Append(ClientID)
        Script.Append("').focus();")
        Script.Append("document.getElementById('")
        Script.Append(ClientID)
        Script.Append("').select();")
        Script.Append("</script" & ">")
        RegisterStartupScript("setFocus", Script.ToString())
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">MATERIAL INCOMING
                                FORM (MIF) ITEM</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="cmbPONo" ErrorMessage="You don't seem to have supplied a valid P/O No." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="cmbPartNo" ErrorMessage="You don't seem to have supplied a valid Part No." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" ControlToValidate="txtInQty" ErrorMessage="You don't seem to have supplid a valid In Qty" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" Operator="GreaterThanEqual" ValueToCompare="0" Type="Integer"></asp:CompareValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtInQty" ErrorMessage="You don't seem to have supplied a valid In Qty" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" ErrorMessage="Total In Qty. exceeded P/O Qty" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" EnableClientScript="False" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                                                </p>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="118px">P/O No</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:TextBox id="txtPONo" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtPONo)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                    &nbsp; 
                                                                    <asp:DropDownList id="cmbPONo" runat="server" Width="341px" CssClass="OutputText" OnSelectedIndexChanged="cmbPONo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="138px">Part No/ETA
                                                                    Date</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtPartNo" onkeydown="KeyDownHandler(cmdPartNo)" onclick="GetFocus(txtPartNo)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdPartNo" onclick="cmdPartNo_Click" runat="server" CssClass="OutputText" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                    &nbsp; 
                                                                    <asp:DropDownList id="cmbPartNo" runat="server" Width="327px" CssClass="OutputText" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="true"></asp:DropDownList>
                                                                    &nbsp;&nbsp; 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Part No/Description</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartDet" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="155px">Quantity</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtInQty" onkeydown="KeyDownHandler(cmdAdd)" runat="server" Width="130px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Order Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblOrderQty" runat="server" cssclass="OutputText"></asp:Label>&nbsp;<asp:Label id="lblFOCQty" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Qty. Delivered</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblQtyDel" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="174px" CssClass="OutputText" Text="Add to list"></asp:Button>
                                                                        <asp:Label id="lblSupplier" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblMIFNo" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblLoc" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblUP" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblWAC" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblUPRM" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblCurrCode" runat="server" cssclass="OutputText" visible="False"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" Width="100%" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" OnItemCommand="ItemCommand" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="None" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnSortCommand="SortGrid" AllowSorting="True" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="PO_NO" HeaderText="P/O No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="Part No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_dESC" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Rec. Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> <asp:Label id="InQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "In_Qty") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="FOC">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="FOCQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FOC_Qty") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Action">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgDelete" CausesValidation="False" ToolTip="Delete this Item" ImageUrl="Delete.gif" CommandArgument='DELETE' runat="server"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="33%">
                                                                    <p align="left">
                                                                    </p>
                                                                </td>
                                                                <td width="34%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdViewPO" onclick="cmdViewPO_Click" runat="server" Width="159px" CssClass="OutputText" Text="View MIF Transaction" CausesValidation="False" Visible="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="159px" CssClass="OutputText" Text="Back" CausesValidation="False"></asp:Button>
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
