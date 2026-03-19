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
        IF page.ispostback=false then
            Dim ReqCOm as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            lblUPASNo.text = ReqCOM.GetFieldVal("Select top 1 UPAS_No from UPAS_M where Seq_No = '" & trim(request.params("ID")) & "';","UPAS_No")
            lblAction.text = "ADD"
        end if
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = FValue
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim strSql as string
            Dim OldRMUP as decimal
            Dim NewRMUP as decimal
            Dim DiffPctg as decimal
            Dim DiffAmt as decimal
    
            if trim(lblCurr.text) = "RM" then NewRMUP = cdec(txtUP.text)
            if trim(lblCurr.text) <> "RM" then NewRMUP = cdec(txtUP.text) * cdec(ReqCOM.GetFieldVal("Select Rate / Unit_Conv as [Rate] from curr where Curr_Code = '" & trim(lblCurr.text) & "';","Rate"))
    
            if trim(lblSupplier.text) <> "" then
                OldRMUP = cdec(lblUP.text) * cdec(ReqCOM.GetFieldVal("Select Rate / Unit_Conv as [Rate] from curr where Curr_Code = '" & trim(lblCurr1.text) & "';","Rate"))
                DiffAmt = cdec(NewRMUP) - cdec(OldRMUP)
                DiffPctg = cdec(DiffAmt) * 100 / cdec(OldRMUP)
            elseif trim(lblSupplier.text) = "" then
                OldRMUP = 0
                DiffAmt = 0
                DiffPctg = 0
            end if
    
            if trim(lblSupplier.text) = "" then
                lblSupplier.text = "-"
                lblUP.text = "0"
                lblStdPack.text = "0"
                lblMOQ.text = "0"
                lblLeadTime.text = "0"
                lblCancellation.text = "0"
                lblReschedule.text = "0"
                lblCurr1.text = ""
            end if
    
            StrSql = "Insert into UPAS_D(UPAS_NO,A_Curr_Code,Curr_Code,PART_NO,A_VEN_CODE,A_Ven_Code_Temp,Ven_Code_Temp,ACT,A_UP,A_STD_PACK,A_MIN_ORDER_QTY,Rem,VEN_CODE,UP,LEAD_TIME,STD_PACK,MIN_ORDER_QTY,DIFF_AMT,DIFF_PCTG,UP_RM,A_UP_RM,CANCEL_LT,A_CANCEL_LT,RESCHEDULE_LT,A_RESCHEDULE_LT,validity,A_ORI_VEN_NAME,A_ORI_CURR_CODE,A_ORI_UP,ORI_VEN_NAME,ORI_CURR_CODE,ORI_UP,A_Lead_Time) "
            StrSql = StrSql + "Select '" & trim(lblUPASNo.text) & "',"
            StrSql = StrSql + "'" & trim(lblCurr.text) & "','" & trim(lblCurr1.text) & "',"
            StrSql = StrSql + "'" & trim(cmbPartNo.selectedItem.value) & "','" & trim(cmbVenCode.selectedItem.value) & "','" & trim(cmbVenCode.selectedItem.text) & "',"
            StrSql = StrSql + "'" & trim(lblSupplier.text) & "','" & trim(lblAction.text) & "',"
            StrSql = StrSql + "" & txtUP.text & "," & txtStdpack.text & "," & txtMinOrderQty.text & ","
            StrSql = StrSql + "'" & trim(replace(txtRem.text,"'","`")) & "',"
            StrSql = StrSql + "'" & trim(OldVendorCode.text) & "'," & lblUP.text & "," & lblLeadTime.text & "," & lblStdPack.text & "," & lblMOQ.text & "," & DiffAmt & "," & DiffPctg & "," & cdec(OldRMUp) & ","
            StrSql = StrSql + "" & cdec(NewRMUp) & "," & lblCancellation.text & "," & txtCancellation.text & "," & lblReschedule.text & "," & txtReschedule.text & "," & txtValidity.text & ","
    
            if trim(cmbVenCode.selecteditem.value) = "TG005" then
                StrSql = StrSql + "'" & txtOriVenName.text & "','" & cmbOriCurrCode.selecteditem.value & "'," & txtOriUP.text & ","
            Elseif mid(trim(cmbVenCode.selecteditem.value),1,4) = "TEMP" then
                StrSql = StrSql + "'" & txtOriVenName.text & "','" & ucase(trim(lblCurr.text)) & "'," & txtUP.text & ","
            else
                StrSql = StrSql + "null,null,null,"
            end if
    
            StrSql = StrSql + "'" & trim(lblOriVenName.text) & "','" & trim(lblOriCurrCode.text) & "',"
    
            if trim(lblOriUP.text) <> "" then StrSql = StrSql + "" & cdec(lblOriUP.text) & ","
            if trim(lblOriUP.text) = "" then StrSql = StrSql + "null,"
    
            StrSql = StrSql + "" & txtLeadTime.text & ""
            ReqCOM.ExecuteNonQuery(StrSql)
            response.redirect("UnitPriceApprovalSheetDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("UnitPriceApprovalSheetDet.aspx?ID=" & request.params("ID"))
    End Sub
    
    Sub ServerValItemCount(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOm as ERp_Gtm.ERp_Gtm = new Erp_Gtm.Erp_Gtm
        If ReqCOM.GetFieldVal ("Select count(Ven_Code) as[NoOfSource] from Part_Source where Part_No = '" & trim(cmbPartNo.selecteditem.value) & "';","NoOfSource") >= 3 then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_PART_NO from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","M_PART_NO")
        lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
        ShowOtherSupplier
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        cmbPartNo.items.clear
        Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' order by Part_No asc","Part_No","Desc",cmbPartNo)
    
        if cmbPartNo.selectedindex <> -1 then
            lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_PART_NO from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","M_PART_NO")
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
            txtSearchPart.text = "-- Search --"
            ShowOtherSupplier
            GetNextControl(txtSearchVendor)
        else if cmbPartNo.selectedindex = -1 then
            ShowOtherSupplier
            txtSearchPart.text = "-- Search --"
            ShowAlert("Invalid Part No. Pls try another part no.")
        end if
    End Sub
    
    sub ShowOtherSupplier
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        lblSupplier.text = ""
        lblUP.text = ""
        lblStdPack.text = ""
        lblMOQ.text = ""
        lblLeadTime.text = ""
        lblCancellation.text = ""
        lblReschedule.text = ""
        lblCurr1.text = ""
    
        if cmbPartNo.selectedIndex = -1 then exit sub
        if ReqCOm.FuncCheckDuplicate("Select Top 1 Part_No from Part_Source where Part_no = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_No") = true then
            Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            cnnGetFieldVal.Open()
            Dim myCommand As SqlCommand = New SqlCommand("Select Top 1 * from Part_Source where Part_No = '" & trim(cmbPartNo.selecteditem.value) & "' order by UP asc;", cnnGetFieldVal )
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            do while drGetFieldVal.read
                OldVendorCode.text = drGetFieldVal("Ven_Code")
                lblUP.text = drGetFieldVal("UP")
                lblStdPack.text = drGetFieldVal("Std_Pack_qty")
                lblMOQ.text = drGetFieldVal("min_order_qty")
                lblStdPack.text = clng(lblStdPack.text)
                lblMOQ.text = clng(lblMOQ.text)
                lblLeadTime.text = drGetFieldVal("Lead_Time")
                lblCancellation.text = drGetFieldVal("Cancel_LT")
                lblReschedule.text = drGetFieldVal("Reschedule_LT")
                lblCurr1.text = ReqCOM.GetFieldVal("Select Curr_Code from Vendor where Ven_Code = '" & trim(OldVendorCode.text) & "';","Curr_Code")
                lblSupplier.text = ReqCOM.GetFieldVal("Select Ven_Code + '(' + Ven_Name + ')' as [Desc] from vendor where ven_Code = '"& trim(OldVendorCode.text) & "';","Desc")
                if isdbnull(drGetFieldVal("Ori_Ven_Name")) = false then lblOriVenName.text = drGetFieldVal("Ori_Ven_Name")
                if isdbnull(drGetFieldVal("Ori_Curr_Code")) = false then lblOriCurrCode.text = drGetFieldVal("Ori_Curr_Code")
                if isdbnull(drGetFieldVal("Ori_UP")) = false then lblOriUP.text = drGetFieldVal("Ori_UP")
            loop
            myCommand.dispose()
            drGetFieldVal.close()
            cnnGetFieldVal.Close()
            cnnGetFieldVal.Dispose()
        end if
    end sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
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
    
    Sub cmdSearchVendor_Click(sender As Object, e As EventArgs)
        cmbVenCode.items.clear
        Dissql ("Select Ven_Code,Ven_Code + '|' + Ven_Name as [Desc] from VEndor where ven_code + Ven_Name like '%" & trim(txtSearchVendor.text) & "%' order by Ven_Code asc","Ven_Code","Desc",cmbVenCode)
    
        if cmbVenCode.selectedindex <> -1 then
            FilterInputBox()
            txtSearchVendor.text = "-- Search --"
        elseif cmbVenCode.selectedindex = -1 then
            txtSearchVendor.text = "-- Search --"
            ShowAlert("Invalid supplier code. Pls try another supplier.")
        end if
    End Sub
    
    Sub cmbVenCode_SelectedIndexChanged(sender As Object, e As EventArgs)
        FilterInputBox()
    End Sub
    
    Sub FilterInputBox()
        Dim VenDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if cmbVenCode.selectedindex <> -1 then
            lblCurr.text = ReqCOM.GetFieldVal("Select Curr_Code from Vendor where Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "'","Curr_Code")
            txtSearchVendor.text = "-- Search --"
            'GetNextControl(txtUP)
    
            if trim(cmbVenCode.selecteditem.value) = "TG005" then
                txtOriVenName.visible = true
                cmbOriCurrCode.visible = true
                txtConRate.visible = true
                txtHandlingCharges.visible = true
                txtOriUP.visible = true
                cmbCalculate.visible = true
                txtUP.enabled = false
            Elseif MID(trim(cmbVenCode.selecteditem.value),1,4) = "TEMP" then
                txtOriVenName.visible = true
                cmbOriCurrCode.visible = false
                txtConRate.visible = false
                txtHandlingCharges.visible = false
                txtOriUP.visible = false
                cmbCalculate.visible = false
                txtUP.enabled = TRUE
            Else
                txtOriVenName.visible = false
                cmbOriCurrCode.visible = false
                txtConRate.visible = false
                txtHandlingCharges.visible = false
                txtOriUP.visible = false
                cmbCalculate.visible = false
                txtUP.enabled = true
            End if
        End if
    End sub
    
    Sub cmdView_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if cmbPartNo.selectedIndex = -1 then
            ShowAlert("Invalid Part No. Please select another.")
        else
            if ReqCOm.FuncCheckDuplicate("Select Part_No from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_No") = true then
                ShowSupplier()
            else
                ShowAlert("No supplier exist for this part.")
            end if
        end if
    End Sub
    
    Sub ShowSupplier()
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open('PopUpPartSource.aspx?PartNo=" & cmbPartNo.selectedItem.value & "','','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmbOriCurrCode_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        txtconRate.text = ReqCOM.GetFieldVal("Select UPA_Conv_Rate from Curr Where Curr_Code = '" & trim(cmbOriCurrCode.selecteditem.value) & "';","UPA_Conv_Rate")
        if cmbOriCurrCode.selecteditem.value= "" then txtHandlingCharges.text = ""
        if cmbOriCurrCode.selecteditem.value<> "" then txtHandlingCharges.text = "1.03"
    
    End Sub
    
    Sub cmbCalculate_Click(sender As Object, e As EventArgs)
        if txtconrate.text = "" then exit sub
        if txtHandlingCharges.text = "" then exit sub
        if txtOriUP.text = "" then exit sub
        if txtConRate.text <= 0 then exit sub
    
        txtUP.text = format(cdec(cdec(txtOriUP.text) / cdec(txtConRate.text) * cdec(txtHandlingCharges.text)),"####0.00000")
        txtUP.text = format(AsymArith(cdec(txtup.text),100000),"##,##0.00000")
    End Sub
    
    Function AsymArith(ByVal X As Double, Optional ByVal Factor As Double = 1) As Double
        AsymArith = Int(X * Factor + 0.5) / Factor
    End Function
    
    Sub ValChanges_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOM.funcCheckDuplicate("Select top 1 * from Part_Source where reschedule_lt = " & cdec(txtReschedule.text) & " and Cancel_Lt = " & cdec(txtCancellation.text) & " and Lead_Time = " & clng(txtLeadTime.text) & " and UP = " & cdec(txtUP.text) & " and part_no = '" & trim(cmbPartno.selecteditem.value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "' and Min_Order_Qty = " & clng(txtMinOrderQty.text) & " and Std_Pack_Qty = " & clng(txtStdPack.text) & ";","Part_No") = true then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form name="UnitPriceApprovalSheetAddNew" method="post" runat="server">
        <p>
            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label5" runat="server" cssclass="FormDesc" width="100%">ADD NEW PART
                                SOURCE</asp:Label>
                            </p>
                            <p align="left">
                                <table style="HEIGHT: 266px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:comparevalidator id="CompareStdPack" runat="server" ValueToCompare="0" Width="100%" ErrorMessage="You don't seem to have supplied a valid standard pack." ControlToValidate="txtStdPack" Display="Dynamic" Type="Integer" Operator="GreaterThan" ForeColor=" " CssClass="ErrorText"></asp:comparevalidator>
                                                <asp:comparevalidator id="CompareMinOrderQty" runat="server" ValueToCompare="0" Width="100%" ErrorMessage="You don't seems to have supplied a valid Min. Order Qty." ControlToValidate="txtMinOrderQty" Display="Dynamic" Type="Integer" Operator="GreaterThan" ForeColor=" " CssClass="ErrorText"></asp:comparevalidator>
                                                <asp:comparevalidator id="CompareLeadTime" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid lead time." ControlToValidate="txtLeadTime" Display="Dynamic" Type="Integer" Operator="DataTypeCheck" ForeColor=" " CssClass="ErrorText"></asp:comparevalidator>
                                                <asp:comparevalidator id="CompareUP" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Unit Price." ControlToValidate="txtUP" Display="Dynamic" Type="Double" Operator="DataTypeCheck" ForeColor=" " CssClass="ErrorText"></asp:comparevalidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Std. Pack." ControlToValidate="txtStdPack" Display="Dynamic" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Unit Price." ControlToValidate="txtUP" Display="Dynamic" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Min. Order Qty." ControlToValidate="txtminOrderQty" Display="Dynamic" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Lead Time." ControlToValidate="txtLeadTime" Display="Dynamic" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:CustomValidator id="ValItemCount" runat="server" Width="100%" ControlToValidate="cmbPartNo" Display="Dynamic" ForeColor=" " CssClass="ErrorText" OnServerValidate="ServerValItemCount">
                                    The maximum no of part source already exceeded.
                                </asp:CustomValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Cancellation window value." ControlToValidate="txtCancellation" Display="Dynamic" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:CompareValidator id="CompareValidator1" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Original UP." ControlToValidate="txtOriUP" Display="Dynamic" Type="Double" Operator="DataTypeCheck" ForeColor=" " CssClass="ErrorText"></asp:CompareValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Re-schedule window value." ControlToValidate="txtreschedule" Display="Dynamic" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:CompareValidator id="CompareValidator4" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Conversion Rate." ControlToValidate="txtConRate" Display="Dynamic" Type="Double" Operator="DataTypeCheck" ForeColor=" " CssClass="ErrorText"></asp:CompareValidator>
                                                <asp:CompareValidator id="CompareValidator6" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Handling Charges." ControlToValidate="txtHandlingCharges" Display="Dynamic" Type="Double" Operator="DataTypeCheck" ForeColor=" " CssClass="ErrorText"></asp:CompareValidator>
                                                <asp:CustomValidator id="ValChanges" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid changes to this item." Display="Dynamic" ForeColor=" " CssClass="ErrorText" OnServerValidate="ValChanges_ServerValidate"></asp:CustomValidator>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="128px">Approval
                                                                    Sheet No</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblUPASNo" runat="server" cssclass="OutputText" width="384px"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="128px">Action</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblAction" runat="server" cssclass="OutputText" width="384px"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="128px">Part No</asp:Label></td>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                        &nbsp;<asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                        &nbsp; 
                                                                        <asp:DropDownList id="cmbPartNo" runat="server" Width="358px" CssClass="OutputText" autopostback="True" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged"></asp:DropDownList>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="128px">Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSearchVendor" onkeydown="KeyDownHandler(cmdSearchVendor)" onclick="GetFocus(txtSearchVendor)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                    &nbsp;<asp:Button id="cmdSearchVendor" onclick="cmdSearchVendor_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                    &nbsp; 
                                                                    <asp:DropDownList id="cmbVenCode" runat="server" Width="358px" CssClass="OutputText" autopostback="true" OnSelectedIndexChanged="cmbVenCode_SelectedIndexChanged"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="128px">Unit Price</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtUP" onkeydown="GetFocusWhenEnter(txtStdPack)" runat="server" Width="214px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal" width="128px">Std. Pack</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtStdPack" onkeydown="GetFocusWhenEnter(txtminOrderQty)" runat="server" Width="214px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label15" runat="server" cssclass="LabelNormal" width="128px">Min. Order
                                                                    Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtminOrderQty" onkeydown="GetFocusWhenEnter(txtLeadTime)" runat="server" Width="214px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal" width="128px">Lead Time
                                                                    (weeks)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtLeadTime" onkeydown="GetFocusWhenEnter(txtCancellation)" runat="server" Width="214px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="">Cancellation
                                                                    (weeks)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtCancellation" onkeydown="GetFocusWhenEnter(txtreschedule)" runat="server" Width="214px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="">Re-schedule
                                                                    (weeks)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtreschedule" onkeydown="GetFocusWhenEnter(txtOriVenName)" runat="server" Width="214px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label20" runat="server" cssclass="LabelNormal" width="128px">Original
                                                                    Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtOriVenName" onkeydown="GetFocusWhenEnterWithoutSelect(cmbOriCurrCode)" runat="server" Width="100%" CssClass="OutputText" Height="22px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label29" runat="server" cssclass="LabelNormal" width="128px">Original
                                                                    Currency</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbOriCurrCode" onkeydown="GetFocusWhenEnter(txtConRate)" runat="server" Width="214px" CssClass="OutputText" autopostback="true" OnSelectedIndexChanged="cmbOriCurrCode_SelectedIndexChanged">
                                                                        <asp:ListItem Value=""></asp:ListItem>
                                                                        <asp:ListItem Value="JPY">JAPANESE YEN</asp:ListItem>
                                                                        <asp:ListItem Value="USD">US DOLLARS</asp:ListItem>
                                                                        <asp:ListItem Value="NTD">NT DOLLARS</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label30" runat="server" cssclass="LabelNormal" width="128px">Conv.
                                                                    Rate</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtConRate" onkeydown="GetFocusWhenEnter(txtHandlingCharges)" runat="server" Width="214px" CssClass="OutputText" Height="22px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label31" runat="server" cssclass="LabelNormal" width="128px">Handling
                                                                    Charges</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtHandlingCharges" onkeydown="GetFocusWhenEnter(txtOriUP)" runat="server" Width="214px" CssClass="OutputText" Height="22px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label28" runat="server" cssclass="LabelNormal" width="128px">Original
                                                                    U/P</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtOriUP" onkeydown="GetFocusWhenEnter(txtRem)" runat="server" Width="214px" CssClass="OutputText" Height="22px"></asp:TextBox>
                                                                    &nbsp;&nbsp; 
                                                                    <asp:Button id="cmbCalculate" onclick="cmbCalculate_Click" runat="server" Width="94px" CausesValidation="False" Text="Calculate"></asp:Button>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="128px">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" onkeydown="GetFocusWhenEnter(txtValidity)" runat="server" Width="100%" CssClass="OutputText" Height="22px" MaxLength="200"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label18" runat="server" cssclass="LabelNormal" width="128px">Validity</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtValidity" runat="server" Width="78px" CssClass="OutputText">0</asp:TextBox>
                                                                    &nbsp;<asp:Label id="Label19" runat="server" cssclass="LabelNormal">days upon approval
                                                                    (Set to 0 if no validity)</asp:Label> 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="128px">Supplier
                                                                    Curr.</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCurr" runat="server" cssclass="OutputText" width="431px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="128px">Specification</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartSpec" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="128px">Mfg. Part
                                                                    No.</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMfgPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:Label id="Label17" runat="server" cssclass="Instruction ">Existing supplier with
                                                                    the lowest unit price. (if any)</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label21" runat="server" cssclass="LabelNormal" width="128px">Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSupplier" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label22" runat="server" cssclass="LabelNormal" width="128px">Unit Price</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCurr1" runat="server" cssclass="OutputText"></asp:Label>&nbsp;<asp:Label id="lblUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label23" runat="server" cssclass="LabelNormal">SPQ/MOQ</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStdPack" runat="server" cssclass="OutputText"></asp:Label>&nbsp;/ <asp:Label id="lblMOQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label25" runat="server" cssclass="LabelNormal">Lead Time/Canc./Re-sch
                                                                    (Wks)</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLeadTime" runat="server" cssclass="OutputText"></asp:Label>&nbsp;/ <asp:Label id="lblCancellation" runat="server" cssclass="OutputText"></asp:Label>&nbsp;/ <asp:Label id="lblReschedule" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Ori. Supplier / Unit
                                                                    Price</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblOriVenName" runat="server" cssclass="OutputText"></asp:Label>&nbsp;/ <asp:Label id="lblOriCurrCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;<asp:Label id="lblOriUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" CssClass="OutputText" Text="Add to approval sheet"></asp:Button>
                                                                    <asp:Label id="OldVendorCode" runat="server" visible="False">Label</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdView" onclick="cmdView_Click" runat="server" Width="174px" CssClass="OutputText" CausesValidation="False" Text="View Existing Supplier"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="174px" CssClass="OutputText" CausesValidation="False" Text="Cancel"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
