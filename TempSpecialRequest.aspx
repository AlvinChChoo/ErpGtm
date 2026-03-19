<%@ Page Language="VB" Debug="True" %>
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
        cmdSRExplosion.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after SR explosion.\nAre you sure you want to proceed ?')==false) return false;")
        if page.ispostback = false then
            LoadSRItem()
        end if
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = trim(FValue)
            .DataTextField = trim(FText)
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("CustomerAddNew.aspx")
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rsSR as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 * from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';")
    
        Do while rsSR.read
            lblPartDesc.text = rsSR("Part_Desc").tostring
            lblPartSpec.text = rsSR("Part_Spec").tostring
        Loop
        rsSR.close()
     End Sub
    
     Sub LoadSRItem()
         Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
         Dim StrSql as string = "Select sr.rem,pm.buyer_code,sr.eta_date,sr.spare_qty,sr.req_qty+sr.spare_qty as [TotalQty],SR.Lot_No,SR.Seq_No,PM.PART_DESC,PM.PART_SPEC,SR.REQ_QTY,SR.PART_NO from TSR SR, PART_MASTER PM where SR.Create_By = '" & trim(request.cookies("U_ID").value) & "' AND SR.PART_NO = PM.PART_NO"
         Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
         dtgSRItem.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
         dtgSRItem.DataBind()
     end sub
    
     Sub cmdAddItem_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim CMonth,CDay,CYear as string
            Dim CDt as string
            CDt = txtReqDate.text
    
            Cmonth = CDt.substring(3,2)
            CDay  = CDt.substring(0,2)
            CYear = CDt.substring(6,2)
            Cdt = CMonth & "/" & Cday & "/" & CYear
    
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
    
            StrSql = "Insert into TSR(Create_By,Create_Date,Part_No,Lot_No,Req_Qty,Spare_Qty,Rem,ETA_Date) "
            StrSql = StrSql & "Select '" & trim(request.cookies("U_ID").value) & "','" & now & "','" & trim(cmbPartNo.selectedItem.value) & "','" & trim(cmbLotNo.selecteditem.value) & "'," & cdec(txtreqQty.text) & "," & clng(txtSpareQty.text) & ",'" & trim(replace(txtrem.text,"'","`")) & "','" & Cdt & "';"
    
            ReqCOM.ExecuteNonQuery(StrSql)
            ClearControl
            'LoadSRItem
            Response.redirect("TempSpecialRequest.aspx")
        End if
     End Sub
    
    Sub ClearControl ()
        lblPartDesc.text = ""
        lblPartSpec.text = ""
        lblUsage.text = ""
        lblOrderqty.text = ""
        lblTotalQty.text = ""
        txtSpareQty.text = ""
        txtReqQty.text = ""
        txtReqDate.text = ""
        cmblotNo.items.clear
        cmbPartNo.items.clear
        txtRem.text = ""
    End sub
    
    Sub dtgSRItem_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        if cmblotno.selectedindex = -1 then exit sub
    
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        'Dim ModelNo as string = ReqCOM.GetfieldVal("Select Model_No from SO_Models_M where Lot_No in (Select Lot_No from job_order_M where jo_no = '" & trim(cmbLotNo.selecteditem.value) & "')","Model_No")
        Dim ModelNo as string = ReqCOM.GetfieldVal("Select Model_No from SO_Models_M where Lot_No = '" & trim(cmbLotNo.selecteditem.value) & "';","Model_No")
    
        cmbPartNo.items.clear
    
        if cmbLotNo.selecteditem.value <> "STORE" then Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' and part_no in (Select Part_no from BOM_D where Model_No = '" & trim(ModelNo) & "') order by Part_No asc","Part_No","Desc",cmbPartNo)
        if cmbLotNo.selecteditem.value = "STORE" then Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' order by Part_No asc","Part_No","Desc",cmbPartNo)
    
        if cmbPartNo.selectedindex = 0 then
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
            lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
    
            if trim(cmbLotNo.selecteditem.value) = "STORE" THEN
                lblUsage.text = "0"
                lblTotalQty.text = "0"
                txtReqDate.text = ""
            else
                'lblUsage.text = ReqCOM.GetFieldVal("Select P_Usage from BOM_D where Model_No = '" & trim(ModelNo) & "';","P_Usage")
                'lblTotalQty.text = format(cdec(lblUsage.text) * cdec(lblOrderQty.text),"##,##0")
                'txtReqDate.text = ReqCOM.GetFieldVal("select min(ETA_Date) as [ETADate] from part_allocation where lot_no = '" & trim(cmbLotNo.selecteditem.value) &"' and part_no = '" & trim(cmbpartNo.selecteditem.value) & "';","ETADate")
                'if txtReqDate.text <> "<NULL>" then txtReqDate.text = format(cdate(ReqCOM.GetFieldVal("select min(ETA_Date) as [ETADate] from part_allocation where lot_no = '" & trim(cmbLotNo.selecteditem.value) &"' and part_no = '" & trim(cmbpartNo.selecteditem.value) & "';","ETADate")),"dd/MM/yy")
                'if txtReqDate.text = "<NULL>" then txtReqDate.text = ""
            end if
        end if
        txtSearchPart.text = "-- Search --"
    End Sub
    
    Sub cmdLotNo_Click(sender As Object, e As EventArgs)
        Dim LotNo as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim oList As ListItemCollection = cmbLotNo.Items
        oList.Add(New ListItem("STORE"))
    
        cmbLotNo.items.clear
        if ucase(triM(txtLotNo.text)) <> "STORE" then
            'Dissql ("Select distinct(JO_No) as [jo_no] from job_order_D where JO_No like '%" & cstr(txtLotNo.Text) & "%' order by jo_no asc","JO_No","JO_No",cmbLotNo)
            Dissql ("Select Lot_No from SO_Models_M where Lot_No like '%" & cstr(txtLotNo.Text) & "%' order by Lot_No asc","Lot_No","Lot_No",cmbLotNo)
        elseif ucase(triM(txtLotNo.text)) = "STORE" then
            oList.Add(New ListItem("STORE"))
        end if
    
        if cmbLotNo.selectedindex = -1 then lblOrderQty.text = "0"
    
        if cmbLotNo.selectedindex <> -1 then
            lblModelNo.text = ReqCOM.GetFieldVal("Select model_No from SO_Models_M where lot_no in (Select lot_No from Job_Order_M where JO_No = '" & trim(txtLotNo.text) & "')","model_No")
            if cmbLotNo.selecteditem.value = "STORE" then lblOrderQty.text = "0"
            if cmbLotNo.selecteditem.value <> "STORE" then lblOrderQty.text = Reqcom.GetFieldVal("Select prod_qty from job_order_D where JO_No = '" & trim(cmbLotNo.selecteditem.value) & "';","prod_qty")
        end if
        txtLotNo.text = "-- Search --"
    End Sub
    
    Sub cmbLotNo_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        RESPONSE.REDIRECT("PCMCSpecialRequest.aspx")
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To dtgSRItem.Items.Count - 1
            Dim SeqNo As Label = CType(dtgSRItem.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(dtgSRItem.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from TSR where Seq_no = " & trim(SeqNo.text) & ";")
                end if
            Catch
            ' MyError.Text = "There has been a problem with one or more of your inputs."
            End Try
        Next
        LoadSRItem
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ETADate As Label = CType(e.Item.FindControl("ETADate"), Label)
            Dim SpareQty As Label = CType(e.Item.FindControl("SpareQty"), Label)
            Dim ReqQty As Label = CType(e.Item.FindControl("ReqQty"), Label)
            Dim TotalQty As Label = CType(e.Item.FindControl("TotalQty"), Label)
    
            ETADate.text = format(cdate(ETADate.text),"dd/MM/yy")
            SpareQty.text = format(cdec(SpareQty.text),"##,##0")
            ReqQty.text = format(cdec(ReqQty.text),"##,##0")
            TotalQty.text = format(cdec(TotalQty.text),"##,##0")
        End if
    End Sub
    
    Sub cmdSRExplosion_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as erp_gtm.erp_gtm = new erp_gtm.erp_gtm
        Dim rsSR As SqlDataReader
        Dim SRFrom,SRTo as string
        ReqCOm.ExecutenonQuery("Update tsr set tsr.buyer_code = part_master.buyer_code from part_master,tsr where tsr.part_no = part_master.part_no and tsr.create_by = '" & trim(REQUEST.COOKIES("u_id").VALUE) & "';")
        rsSR = ReqCOM.ExeDataReader("select distinct(buyer_code) as [BuyerCode] from tsr where create_by = '" & trim(request.cookies("U_ID").value) & "';")
        SRFrom = ReqCOM.GetDocumentNo("SR_NO")
        do while rsSR.read
            SRTo = ReqCOM.GetDocumentNo("SR_NO")
            ReqCOm.ExecuteNonQuery("insert into SR_M(SR_NO,BUYER_CODE,Create_By,Create_Date) select '" & trim(SRTo) & "','" & TRIM(rsSR("BuyerCode")) & "','" & trim(request.cookies("U_ID").value) & "','" & now & "';")
            ReqCOm.ExecuteNonQuery("Insert into SR_D(SR_NO,PART_NO,LOT_NO,SO_QTY,P_USAGE,CAL_QTY,REQ_QTY,SPARE_QTY,ETA_DATE,REM) select '" & trim(SRTo) & "',PART_NO,LOT_NO,SO_QTY,P_USAGE,CAL_QTY,REQ_QTY,SPARE_QTY,ETA_DATE,REM from TSR where Buyer_Code = '" & trim(rsSR("BuyerCode")) & "' and create_By = '" & trim(request.cookies("U_ID").value) & "';")
    
            ReqCOm.ExecuteNonQuery("insert into SR_M_ori(SR_NO,BUYER_CODE,SUBMIT_BY) select '" & trim(SRTo) & "','" & TRIM(rsSR("BuyerCode")) & "','" & trim(request.cookies("U_ID").value) & "';")
            ReqCOm.ExecuteNonQuery("Insert into SR_D_ori(SR_NO,PART_NO,LOT_NO,SO_QTY,P_USAGE,CAL_QTY,REQ_QTY,SPARE_QTY,ETA_DATE,REM) select '" & trim(SRTo) & "',PART_NO,LOT_NO,SO_QTY,P_USAGE,CAL_QTY,REQ_QTY,SPARE_QTY,ETA_DATE,REM from TSR where Buyer_Code = '" & trim(rsSR("BuyerCode")) & "' and create_By = '" & trim(request.cookies("U_ID").value) & "';")
    
            ReqCOm.ExecuteNonQuery("Update Main set SR_No = SR_NO + 1")
        loop
        SelectFirstVendor(SRFrom,SRTo)
        ReqCOM.ExecuteNonQuery("Delete from TSR where Create_By = '" & trim(request.cookies("U_ID").value) & "';")
        Showalert("SR No Generated : " & SRFrom & " to " & SRTo)
        redirectPage("PCMCSpecialRequest.aspx")
    End Sub
    
    Sub SelectFirstVendor(SRNoFrom as long,SRNoTo as long)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql, CurrVendor, PRNo As String
        Dim MRPNo, i As Integer
        Dim SeqNo, Quantity, CurrUP, ReqQty, ReelTobuy, QtyToBuy As Long
        Dim rsTemp As SqlDataReader
        Dim RsPR1 As SqlDataReader
        Dim rsBuyerCode As SqlDataReader
        Dim Temp, PRNoFrom, PRNoTo As String
        Dim Min_Order_Qty, Std_Pack_Qty As Long
        Dim Seq_No As Long
    
        rsBuyerCode = ReqCOM.ExeDataReader("Select * from SR_D where SR_No >= '" & Trim(SRNoFrom) & "' and SR_No <= '" & Trim(SRNoTo) & "';")
        Do While rsBuyerCode.read
            ReqCOm.ExecuteNonQuery("Update Part_Source set Qty_To_Buy = 0")
            ReqQty = CDec(rsBuyerCode("Req_Qty")) '+ CDec(rsBuyerCode("Spare_Qty"))
            Min_Order_Qty = ReqCOM.GetFieldVal("select min_Order_Qty from part_source where part_no = '" & Trim(rsBuyerCode!Part_No) & "' and Ven_Seq = 1", "min_Order_Qty")
            Std_Pack_Qty = ReqCOM.GetFieldVal("select Std_Pack_Qty from part_source where part_no = '" & Trim(rsBuyerCode!Part_No) & "' and Ven_Seq = 1", "Std_Pack_Qty")
            Seq_No = ReqCOM.GetFieldVal("select Seq_No from part_source where part_no = '" & Trim(rsBuyerCode!Part_No) & "' and Ven_Seq = 1", "Seq_No")
            CurrVendor = ReqCOM.GetFieldVal("select Ven_Code from part_source where part_no = '" & Trim(rsBuyerCode!Part_No) & "' and Ven_Seq = 1", "Ven_Code")
            CurrUP = ReqCOM.GetFieldVal("select UP from part_source where part_no = '" & Trim(rsBuyerCode!Part_No) & "' and Ven_Seq = 1", "UP")
    
            If ReqQty <= CLng(Min_Order_Qty) Then ReqQty = CLng(Min_Order_Qty)
            If CInt(ReqQty / Std_Pack_Qty) >= (ReqQty / Std_Pack_Qty) Then
                ReelTobuy = CInt(ReqQty / Std_Pack_Qty)
            Else
                ReelTobuy = CInt(ReqQty / Std_Pack_Qty) + 1
            End If
            ReqCOM.ExecuteNonQuery("Update Part_Source set QTY_TO_BUY = Std_Pack_Qty * " & ReelTobuy & " where Seq_No = " & Seq_No & ";")
            QtyToBuy = Std_Pack_Qty * ReelTobuy
            ReqCOM.ExecuteNonQuery("Update sr_D set UP = " & CurrUP & ",Qty_To_Buy = " & QtyToBuy & ", Ven_Code = '" & Trim(CurrVendor) & "' where Seq_No = " & CInt(rsBuyerCode("Seq_No")) & ";")
        Loop
        ReqCoM.ExecuteNonQuery("Update sr_D set Variance = QTY_TO_BUY - Req_Qty where SR_No >= '" & trim(SRNoFrom) & "' and SR_No <= '" & trim(SRNoTo) & "';")
        ReqCOM.ExecuteNonQuery("update sr_D set calculated_qty = qty_to_buy where SR_No >= '" & trim(SRNoFrom) & "' and SR_No <= '" & trim(SRNoTo) & "';")
        ReqCOm.ExecuteNonQuery("Update sr_D set sr_D.Lead_Time = PS.Lead_Time * 7 from Part_Source PS,sr_D where sr_D.Ven_Code = PS.Ven_Code and sr_D.Part_No = PS.Part_No and sr_D.SR_No >= '" & trim(SRNoFrom) & "' and sr_D.SR_No <= '" & trim(SRNoTo) & "';")
        ReqCOm.ExecuteNonQuery("Update sr_D set NET_ETA = ETA_Date - Lead_Time where  SR_No >= '" & trim(SRNoFrom) & "' and SR_No <= '" & trim(SRNoTo) & "';")
        ReqCOm.ExecuteNonQuery("Update sr_D set sr_D.UP = Part_Source.UP from sr_D,Part_Source where SR_D.Part_No = Part_Source.Part_No and Part_Source.ven_seq = 1 and sr_no >= '" & trim(SRNoFrom) & "' and SR_No <= '" & trim(SRnoTo) & "';")
    End sub
    
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
    
    Sub ValDateFormat_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim CMonth,CDay,CYear as integer
        Dim CDt as string
        CDt = txtReqDate.text
        if len(CDt) <> 8 then e.isvalid = false :exit sub
        Cmonth = CDt.substring(3,2)
        CDay  = CDt.substring(0,2)
        CYear = CDt.substring(6,2)
        Cdt = CMonth & "/" & Cday & "/" & CYear
        if isdate(CDt) = false then e.isvalid = false else e.isvalid = true
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
            <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">NEW SPECIAL
                                REQUEST REGISTRATION</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Lot No" ForeColor=" " ControlToValidate="cmbLotNo" Display="Dynamic"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Part No" ForeColor=" " ControlToValidate="cmbPartNo" Display="Dynamic"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Delivery Date" ForeColor=" " ControlToValidate="txtReqDate" Display="Dynamic"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Qty To Order." ForeColor=" " ControlToValidate="txtReqQty" Display="Dynamic"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="ValPODate" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Delivery Date." ForeColor=" " ControlToValidate="txtReqDate" Display="Dynamic" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                    <asp:comparevalidator id="ValOrderQtyFormat" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Qty To Order" ForeColor=" " ControlToValidate="txtReqQty" Display="Dynamic" EnableClientScript="False" Type="Double" Operator="DataTypeCheck"></asp:comparevalidator>
                                                    <asp:CustomValidator id="ValDateFormat" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid ETA Date." ForeColor=" " Display="Dynamic" EnableClientScript="False" OnServerValidate="ValDateFormat_ServerValidate"></asp:CustomValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Spare Qty." ForeColor=" " ControlToValidate="txtSpareQty" Display="Dynamic"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Spare Qty." ForeColor=" " ControlToValidate="txtSpareQty" Display="Dynamic" Type="Integer" Operator="GreaterThanEqual" ValueToCompare="0"></asp:CompareValidator>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 10px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Label id="Label12" runat="server" width="100%" cssclass="Instruction">To add
                                                                        item to S/R for, please select Part No and Request Qty and click "ADD TO S/R FORM"</asp:Label>
                                                                    </p>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtlotno" onkeydown="KeyDownHandler(cmdLotNo)" onclick="GetFocus(txtlotno)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdLotNo" onclick="cmdLotNo_Click" runat="server" CssClass="OutputText" Text="GO" Height="20px" CausesValidation="False"></asp:Button>
                                                                                        <asp:DropDownList id="cmbLotNo" runat="server" CssClass="OutputText" Width="361px" OnSelectedIndexChanged="cmbLotNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Text="GO" Height="20px" CausesValidation="False"></asp:Button>
                                                                                        <asp:DropDownList id="cmbPartNo" runat="server" CssClass="OutputText" Width="361px" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label18" runat="server" cssclass="LabelNormal">ETA Date</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:TextBox id="txtReqDate" onclick="GetFocus(txtReqDate)" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                                            &nbsp;&nbsp; 
                                                                                            <asp:Button id="Button1" runat="server" CssClass="Outputtext" Width="179px" Text="View ETA Date for this part" CausesValidation="False" Visible="False"></asp:Button>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label17" runat="server" cssclass="LabelNormal">Qty. To Order</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtReqQty" onclick="GetFocus(txtReqQty)" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Spare Qty.</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtSpareQty" onclick="GetFocus(txtSpareQty)" runat="server" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtRem" onclick="GetFocus(txtRem)" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Model No / Description</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblPartDesc" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label6" runat="server" cssclass="labelNormal">Specification</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblPartSpec" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label15" runat="server" cssclass="LabelNormal" visible="False">Usage</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblUsage" runat="server" width="100%" cssclass="OutputText" visible="False"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label8" runat="server" cssclass="LabelNormal" visible="False">Lot Size</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblOrderQty" runat="server" width="100%" cssclass="OutputText" visible="False"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label4" runat="server" cssclass="LabelNormal" visible="False">Total
                                                                                        Qty.</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblTotalQty" runat="server" width="100%" cssclass="OutputText" visible="False"></asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdAddItem" onclick="cmdAddItem_Click" runat="server" Text="Add To S/R Form"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:DataGrid id="dtgSRItem" runat="server" width="100%" Height="9px" OnSelectedIndexChanged="dtgSRItem_SelectedIndexChanged" Font-Name="Verdana" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" Font-Names="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatRow">
                                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                        <Columns>
                                                                            <asp:TemplateColumn visible="false" HeaderText="">
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="lblSeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="Part No"></asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="PART_DESC" HeaderText="Description"></asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Lot_No" HeaderText="Job Order No"></asp:BoundColumn>
                                                                            <asp:TemplateColumn HeaderText="ETA Date" >
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="ETADate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ETA_DAte") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="Spare Qty" >
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="SpareQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Spare_Qty") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="Req Qty" >
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="ReqQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "REQ_QTY") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="Total Qty" >
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="TotalQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "TotalQty") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="Buyer Code" >
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="buyerCode" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Buyer_Code") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="Remarks" >
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="Remarks" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="Remove">
                                                                                <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                                <ItemTemplate>
                                                                                    <center>
                                                                                        <asp:CheckBox id="Remove" runat="server" />
                                                                                    </center>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="168px" Text="Remove Selected Item" CausesValidation="False"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdSRExplosion" onclick="cmdSRExplosion_Click" runat="server" Text="SR Explosion" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="128px" Text="Back" CausesValidation="False"></asp:Button>
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
        <p>
        </p>
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
