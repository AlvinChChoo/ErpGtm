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
            Dim PartSourceSeqNo as long
            Dim RsUPASM as SqlDataReader = ReqCOm.ExeDataReader("Select * from upaS_d where Seq_No = '" & trim(request.params("ID")) & "';")
            Do while RsUPASM.read
                lblUPASNo.text = RsUPASM("UPAS_NO").tostring
                Dissql("Select part_no,part_No + '|' + Part_Desc as [PartDesc] from Part_Master where part_no = '" & trim(RsUPASM("Part_No")) & "';","Part_No","PartDesc",cmbPartNo)
                Dissql ("Select ps.seq_no,VEN.Ven_Code as [Ven_Code],VEN.Ven_Code + '|' + VEN.Ven_Name + '|' + cast(min_order_qty as nvarchar(20)) + '|' + cast(std_pack_qty as nvarchar(20)) as [Desc] from Vendor VEN,Part_Source PS where VEN.Ven_Code = PS.Ven_Code and PS.Part_No = '" & trim(cmbPartNo.selecteditem.value) & "' order by Ven.Ven_Code asc","Seq_No","DESC",cmbVenCode)
                lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_PART_NO from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","M_PART_NO")
                lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
                lblAction.text = RsUPASM("act").tostring
                lblUP.text = RsUPASM("UP").tostring
                lblStdpack.text = RsUPASM("STD_PACK").tostring
                lblMinOrderQty.text = RsUPASM("MIN_Order_Qty").tostring
                txtRem.text = RsUPASM("Rem").tostring
                lblLeadTime.text = RsUPASM("Lead_Time").tostring
                lblcancellation.text = RsUPASM("CANCEL_LT").tostring
                lblReschedule.text = RsUPASM("RESCHEDULE_LT").tostring
                PartSourceSeqNo = ReqCOM.GetFieldVal("Select Seq_No from part_source where Part_No = '" & trim(RsUPASM("Part_No")) & "' and Ven_Code = '" & trim(RsUPASM("Ven_Code")) & "' and std_pack_qty = " & lblStdPack.text & " and Min_Order_Qty = " & lblMinOrderQty.text & ";","Seq_No")
                cmbVenCode.Items.FindByValue(PartSourceSeqNo).Selected = True
            loop
            RsUPASM.Close
            lblAction.text = "DELETE"
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
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim strSql as string
        Dim VenCode as string = ReqCOM.GetFieldVal("Select Ven_Code from Part_Source where Seq_No = " & cmbVenCode.selecteditem.value & ";","Ven_Code")
        Dim OldCurr as string = ReqCOM.GEtFieldVal("Select Curr_Code from vendor where Ven_Code in (Select ven_Code from Part_source where seq_no = " & cmbVenCode.selecteditem.value & ")","Curr_Code")
    
        Dim OldRMUP,Rate,UnitConv as decimal
        if page.isvalid = true then
            if trim(OldCurr) = "RM" then OldRMUP = cdec(lblUP.text)
            if trim(OldCurr) <> "RM" then
                Rate = reqCOM.getFieldVal("Select rate from Curr where curr_code = '" & trim(OldCurr) & "';","Rate")
    
                UnitConv = reqCOM.getFieldVal("Select Unit_Conv from Curr where curr_code = '" & trim(OldCurr) & "';","Unit_Conv")
                OldRMUP = cdec(lblUP.text) * Rate / UnitConv
            End if
    
            Dim CurrSupp as string = ReqCOM.GEtFieldVal("Select Ven_Code + '(' + Ven_Name + ')' as [Ven] from vendor where Ven_Code = '" & trim(cmbVenCode.selectedItem.value) & "';","Ven")
    
            StrSql = "Update UPAS_D set PART_NO = '" & trim(cmbPartNo.selectedItem.value) & "',"
            StrSql = StrSql + "Ven_Code = '" & trim(VenCode) & "',"
            StrSql = StrSql + "VEN_CODE_Temp = '" & trim(CurrSupp) & "',"
            StrSql = StrSql + "A_VEN_CODE_TEMP = '-',"
            StrSql = StrSql + "ACT = '" & trim(lblAction.text) & "',"
            StrSql = StrSql + "UP = " & lblUP.text & ","
            StrSql = StrSql + "STD_PACK = " & lblStdpack.text & ","
            StrSql = StrSql + "MIN_ORDER_QTY = " & clng(lblMinOrderQty.text) & ","
            StrSql = StrSql + "Rem = '" & trim(replace(txtRem.text,"'","`")) & "',"
            StrSql = StrSql + "Lead_Time = " & trim(lblLeadTime.text) & ","
            StrSql = StrSql + "A_VEN_CODE = '-',"
            StrSql = StrSql + "A_UP = 0,"
            StrSql = StrSql + "A_STD_PACK = 0,"
            StrSql = StrSql + "A_MIN_ORDER_QTY = 0,"
            StrSql = StrSql + "A_Lead_Time = 0,"
            StrSql = StrSql + "Diff_AMt = 0,"
            StrSql = StrSql + "Diff_Pctg = 0,"
            StrSql = StrSql + "A_UP_RM = 0,"
            StrSql = StrSql + "UP_RM = " & OldRMUP & ","
            StrSql = StrSql + "CANCEL_LT = " & trim(lblcancellation.text) & ","
            StrSql = StrSql + "A_CANCEL_LT = 0,"
            StrSql = StrSql + "RESCHEDULE_LT = " & trim(lblReschedule.text) & ","
            StrSql = StrSql + "A_RESCHEDULE_LT = 0,"
            StrSql = StrSql + "Curr_Code = '" & OldCurr & "' "
            StrSql = StrSql + " where seq_no = " & request.params("ID") & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
            response.redirect("UPAItemRemove.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub cmbVenCode_SelectedIndexChanged(sender As Object, e As EventArgs)
        ShowSourceDet
    End Sub
    
    Sub ShowSourceDet ()
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If ReqCOM.FuncCheckDuplicate("Select * from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","Part_No") = true then
            Dim RsUPASD as SqlDataReader = ReqCOM.ExeDataReader("Select * from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";")
            Do while RsUPASD.read
                lblUP.text = format(cdec(RsUPASD("UP")),"##,##0.00000")
                lblStdPack.text = format(clng(RsUPASD("Std_Pack_Qty")),"##,##0")
                lblMinOrderQty.text = format(clng(RsUPASD("Min_Order_Qty")),"##,##0")
                lblLeadTime.text = format(clng(RsUPASD("Lead_Time")),"##,##0")
    
                lblOriVenName.text = rsUPASD("ORI_VEN_NAME").tostring
                lblOriCurrCode.text = rsUPASD("ORI_CURR_CODE").tostring
                lblOriUP.text = rsUPASD("ORI_UP").tostring
    
                lblCancellation.text = rsUPASD("Cancel_LT").tostring
                lblReschedule.text = rsUPASD("reschedule_lt").tostring
            loop
            RsUPASD.close()
        end if
    end sub
    
    Sub ServerValExisting(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOm as ERp_Gtm.ERp_Gtm = new Erp_Gtm.Erp_Gtm
        If ReqCOM.FuncCheckDuplicate("Select * from UPAS_D where UPAS_No = '" & trim(lblUPASNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Part_No") = true
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Response.redirect("UnitPriceApprovalSheetDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from UPAS_M where UPAS_No = '" & trim(lblUPASNo.text) & "';","Seq_No"))
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_PART_NO from Part_Master where Part_No = '" & trim(txtSearchPart.text) & "';","M_PART_NO")
        lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(txtSearchPart.text) & "';","Part_Spec")
    
        Dissql ("Select VEN.Ven_Code as [Ven_Code],VEN.Ven_Code + '|' + VEN.Ven_Name as [Desc] from Vendor VEN,Part_Source PS where VEN.Ven_Code = PS.Ven_Code and PS.Part_No = '" & trim(cmbPartNo.selecteditem.value) & "' order by Ven.Ven_Code asc","Ven_Code","DESC",cmbVenCode)
        if cmbVenCode.selectedindex = 0 then
            lblUP.text = ReqCOM.GetFieldVal("Select UP from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","UP")
            lblStdPack.text = ReqCOM.GetFieldVal("Select Std_Pack_Qty from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Std_Pack_Qty")
            lblMinOrderQty.text = ReqCOM.GetFieldVal("Select Min_Order_Qty from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Min_Order_Qty")
            lblLeadTime.text = ReqCOM.GetFieldVal("Select Lead_Time from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Lead_Time")
    
    
            lblOriVenName.text = ReqCOM.GetFieldVal("Select Ori_Ven_Name from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Ori_Ven_Name")
            lblOriUP.text = ReqCOM.GetFieldVal("Select Ori_UP from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Ori_UP")
            lblOriCurrCode.text = ReqCOM.GetFieldVal("Ori_Curr_Code Lead_Time from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Ori_Curr_Code")
    
        else
            lblUP.text = ""
            lblStdPack.text = ""
            lblMinOrderQty.text = ""
            lblLeadTime.text = ""
    
    
            lblOriVenName.text = ""
            lblOriUP.text = ""
            lblOriCurrCode.text = ""
        end if
    
    
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        cmbPartNo.items.clear
        Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' order by Part_No asc","Part_No","Desc",cmbPartNo)
    
        If cmbPartNo.selectedindex = 0 then
            lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_PART_NO from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","M_PART_NO")
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
    
            lblOriVenname.text = ""
            lblOriCurrCode.text = ""
            lblOriUP.text = ""
    
            Dissql ("Select ps.seq_no,VEN.Ven_Code as [Ven_Code],VEN.Ven_Code + '|' + VEN.Ven_Name + '|' + cast(min_order_qty as nvarchar(20)) + '|' + cast(std_pack_qty as nvarchar(20)) as [Desc] from Vendor VEN,Part_Source PS where VEN.Ven_Code = PS.Ven_Code and PS.Part_No = '" & trim(cmbPartNo.selecteditem.value) & "' order by Ven.Ven_Code asc","Seq_No","DESC",cmbVenCode)
        elseif cmbPartNo.selectedindex = -1 then
            ClearVenDet
            lblMfgPartNo.text = ""
            lblPartSpec.text = ""
            lblOriVenname.text = ""
            lblOriCurrCode.text = ""
            lblOriUP.text = ""
        End if
    
        if cmbVenCode.selectedindex = 0 then
            'lblUP.text = ReqCOM.GetFieldVal("Select UP from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","UP")
            'lblStdPack.text = ReqCOM.GetFieldVal("Select Std_Pack_Qty from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Std_Pack_Qty")
            'lblMinOrderQty.text = ReqCOM.GetFieldVal("Select Min_Order_Qty from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Min_Order_Qty")
            'lblLeadTime.text = ReqCOM.GetFieldVal("Select Lead_Time from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Lead_Time")
            'lblCancellation.text = ReqCOM.GetFieldVal("Select Cancel_LT from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","cancel_lt")
            'lblReschedule.text = ReqCOM.GetFieldVal("Select reschedule_lt from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","reschedule_lt")
    
            'lblOriVenname.text = ReqCOM.GetFieldVal("Select Ori_Ven_Name from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Ori_Ven_Name")
            'lblOriCurrCode.text = ReqCOM.GetFieldVal("Select Ori_Curr_Code from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Ori_Curr_Code")
            'lblOriUP.text = ReqCOM.GetFieldVal("Select Ori_UP from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Ori_UP")
            ShowSourceDet
        else
            lblUP.text = ""
            lblStdPack.text = ""
            lblMinOrderQty.text = ""
            lblLeadTime.text = ""
            lblOriVenname.text = ""
            lblOriCurrCode.text = ""
            lblOriUP.text = ""
        end if
    
        If cmbPartNo.selectedindex = 0 then
            txtSearchPart.text = "-- Search --"
            GetNextControlWithoutSelect(cmbVenCode)
        elseif cmbPartNo.selectedindex = -1 then
            txtSearchPart.text = "-- Search --"
            ShowAlert("Invalid Part No. Please select another.")
        End if
    
    End Sub
    
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
    
        Sub GetNextControlWithoutSelect(ByVal FocusControl As Control)
                Dim Script As New System.Text.StringBuilder
                Dim ClientID As String = FocusControl.ClientID
    
                Script.Append("<script language=javascript>")
                Script.Append("document.getElementById('")
                Script.Append(ClientID)
                Script.Append("').focus();")
    
                Script.Append("</script" & ">")
                RegisterStartupScript("setFocus", Script.ToString())
        End Sub
    
        Sub ShowAlert(Msg as string)
                Dim strScript as string
                strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
                If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        End sub
    
    Sub ClearVenDet()
        cmbVenCOde.items.clear
        lblUP.text = ""
        lblStdPack.text = ""
        lblMinOrderQty.text = ""
        lblLeadTime.text = ""
        lblOriUP.text = ""
        lblOriVenName.text = ""
        lblOriCurrcode.text = ""
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
    
    Sub ValVen_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim VenCode as string = ReqCOM.GetFieldVal("Select Ven_Code from Part_Source where seq_no = " & cmbVenCode.selecteditem.value & ";","Ven_Code")
        if ReqCOM.FuncCheckDuplicate("Select part_no from UPAS_D where Part_no = '" & trim(cmbPartNo.selecteditem.value) & "' and Ven_Code = '" & trim(VenCode) & "' and Std_Pack = " & clng(lblStdPack.text) & " and Min_Order_Qty = " & clng(lblMinOrderQty.text) & " and upas_no = '" & trim(lblUPASNo.text) & "';","Part_No") = true then
            e.isvalid = false
        end if
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
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
                                <asp:Label id="Label5" runat="server" width="100%" cssclass="FormDesc">REMOVE PART
                                SOURCE</asp:Label>
                            </p>
                            <p align="left">
                                <table style="HEIGHT: 27px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table cellspacing="0" cellpadding="0" width="80%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:CustomValidator id="ValExisting" runat="server" EnableClientScript="False" OnServerValidate="ServerValExisting" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="cmbPartNo" Width="100%">
                                    Part Source already exist in currrent Approval Sheet
                                </asp:CustomValidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="cmbVenCode" Width="100%" ErrorMessage="You don't seem to have supplied a valid Supplier."></asp:RequiredFieldValidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="cmbPartNo" Width="100%" ErrorMessage="You don't seem to have supplied a valid Part No."></asp:RequiredFieldValidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:CustomValidator id="ValVen" runat="server" EnableClientScript="False" OnServerValidate="ValVen_ServerValidate" CssClass="ErrorText" ForeColor=" " Display="Dynamic" Width="100%" ErrorMessage="Supplier with same MOQ and SPQ already exist. Please select another."></asp:CustomValidator>
                                                                    </div>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server" width="128px" cssclass="LabelNormal">Approval
                                                                                        Sheet No</asp:Label></td>
                                                                                    <td>
                                                                                        <div align="left"><asp:Label id="lblUPASNo" runat="server" width="384px" cssclass="OutputText"></asp:Label>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label10" runat="server" width="128px" cssclass="LabelNormal">Action</asp:Label></td>
                                                                                    <td>
                                                                                        <div align="left"><asp:Label id="lblAction" runat="server" width="384px" cssclass="OutputText"></asp:Label>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label7" runat="server" width="128px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                                    <td>
                                                                                        <div align="left">
                                                                                            <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                            <asp:Button id="cmdGo" onkeydown="KeyDownHandler(cmdGo)" onclick="cmdGo_Click" runat="server" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                                            &nbsp;&nbsp; 
                                                                                            <asp:DropDownList id="cmbPartNo" runat="server" CssClass="OutputText" Width="327px" autopostback="True" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged"></asp:DropDownList>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label8" runat="server" width="128px" cssclass="LabelNormal">Vendor</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:DropDownList id="cmbVenCode" onkeydown="GetFocusWhenEnter(txtRem)" runat="server" CssClass="OutputText" Width="100%" autopostback="True" OnSelectedIndexChanged="cmbVenCode_SelectedIndexChanged"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label4" runat="server" width="128px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="100%" MaxLength="200"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label2" runat="server" width="128px" cssclass="LabelNormal">Specification</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblPartSpec" runat="server" width="431px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server" width="128px" cssclass="LabelNormal">Mfg. Part
                                                                                        No.</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblMfgPartNo" runat="server" width="436px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label13" runat="server" width="128px" cssclass="LabelNormal">Unit Price</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblUP" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label14" runat="server" width="128px" cssclass="LabelNormal">Std. Pack</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblStdPack" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label15" runat="server" width="128px" cssclass="LabelNormal">Min. Order
                                                                                        Qty</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblMinOrderQty" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label6" runat="server" width="" cssclass="LabelNormal">Cancellation
                                                                                        (weeks)</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblCancellation" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label9" runat="server" width="" cssclass="LabelNormal">Re-schedule(weeks)</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblReschedule" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label16" runat="server" width="128px" cssclass="LabelNormal">Lead Time</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblLeadTime" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label22" runat="server" width="128px" cssclass="LabelNormal">Original
                                                                                        Supplier</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblOriVenName" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label23" runat="server" width="128px" cssclass="LabelNormal">Original
                                                                                        Curr.</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblOriCurrCode" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label24" runat="server" width="128px" cssclass="LabelNormal">Original
                                                                                        U/P</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblOriUP" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Update item details"></asp:Button>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="center">
                                                                                            <asp:Button id="cmdView" onclick="cmdView_Click" runat="server" Width="175px" Text="View Existing Supplier" CausesValidation="False"></asp:Button>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="right">
                                                                                            <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="174px" Text="Cancel" CausesValidation="False"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
