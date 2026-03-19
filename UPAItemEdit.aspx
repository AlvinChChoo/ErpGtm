<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Math" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback=false then LoadUPADet
    End Sub
    
    Sub LoadUPADet()
        Dim strSql as string = "Select * from UPAS_D where Seq_No = " & clng(Request.params("ID")) & ";"
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim OriCurrCode as string
        Dim PartSourceSeqNo as long
    
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        do while drGetFieldVal.read
            lblUPASNo.text = drGetFieldVal("UPAS_No").tostring
            lblAction.text = drGetFieldVal("Act").tostring
            Dissql("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no = '" & trim(drGetFieldVal("Part_No").tostring) & "' order by Part_No asc","Part_No","Desc",cmbPartNo)
            Dissql ("Select ps.seq_no,VEN.Ven_Code as [Ven_Code],VEN.Ven_Code + '|' + VEN.Ven_Name + '|' + cast(min_order_qty as nvarchar(20)) + '|' + cast(std_pack_qty as nvarchar(20)) as [Desc] from Vendor VEN,Part_Source PS where VEN.Ven_Code = PS.Ven_Code and PS.Part_No = '" & trim(cmbPartNo.selecteditem.value) & "' order by Ven.Ven_Code asc","Seq_No","DESC",cmbVenCode)
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(drGetFieldVal("Part_No").tostring) & "';","Part_Spec")
            lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_Part_No from Part_Master where Part_No = '" & trim(drGetFieldVal("Part_No")) & "';","M_Part_No")
            lblStdPack.text = drGetFieldVal("std_pack").tostring
            lblMinOrderQty.text = drGetFieldVal("Min_Order_Qty").tostring
            PartSourceSeqNo = ReqCOM.GetFieldVal("Select Seq_No from part_source where Part_No = '" & trim(drGetFieldVal("Part_No")) & "' and Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "' and std_pack_qty = " & lblStdPack.text & " and Min_Order_Qty = " & lblMinOrderQty.text & ";","Seq_No")
            cmbVenCode.Items.FindByValue(PartSourceSeqNo).Selected = True
            lblCancellation.text = drGetFieldVal("Cancel_lt").tostring
            lblReschedule.text = drGetFieldVal("Reschedule_lt").tostring
            lblLeadTime.text = drGetFieldVal("Lead_Time").tostring
            lblOriVenName.text = drGetFieldVal("Ori_Ven_Name").tostring
            lblOriCurrCode.text = drGetFieldVal("Ori_Curr_Code").tostring
            lblOriUP.text = drGetFieldVal("Ori_UP").tostring
            if trim(lblOriUP.text) <> "" then lblOriUP.text = format(cdec(lblOriUP.text),"##,##0.0000")
            lblUP.text = format(cdec(drGetFieldVal("UP")),"##,##0.00000")
            txtValidity.text = drGetFieldVal("Validity").tostring
    
            txtReschedule.text = drGetFieldVal("A_Reschedule_lt").tostring
            txtCancellation.text = drGetFieldVal("A_Cancel_Lt").tostring
            txtLeadTime.text = drGetFieldVal("A_Lead_Time").tostring
            txtMinOrderQty.text = drGetFieldVal("A_Min_Order_Qty").tostring
            txtStdPack.text = drGetFieldVal("A_Std_Pack").tostring
            txtRem.text = drGetFieldVal("Rem").tostring
            txtOriVenName.text = drGetFieldVal("A_Ori_Ven_Name").tostring
            txtUP.text = drGetFieldVal("A_UP").tostring
            txtOriUP.text = drGetFieldVal("A_Ori_UP").tostring
            if trim(txtOriUP.text) <> "" then txtOriUP.text = format(cdec(txtOriUP.text),"##,##0.0000")
    
            if isdbnull(drGetFieldVal("A_Ori_Curr_Code")) = true then
                cmbOriCurrCode.Items.FindByValue("").Selected = True
                txtconRate.text = ReqCOM.GetFieldVal("Select UPA_Conv_Rate from Curr Where Curr_Code = '" & trim(cmbOriCurrCode.selecteditem.value) & "';","UPA_Conv_Rate")
            elseif isdbnull(drGetFieldVal("A_Ori_Curr_Code")) = false then
                if trim(drGetFieldVal("A_Ori_Curr_Code")) = "JPY" then cmbOriCurrCode.Items.FindByValue("JPY").Selected = True
                if trim(drGetFieldVal("A_Ori_Curr_Code")) = "USD" then cmbOriCurrCode.Items.FindByValue("USD").Selected = True
                if trim(drGetFieldVal("A_Ori_Curr_Code")) = "NTD" then cmbOriCurrCode.Items.FindByValue("NTD").Selected = True
                txtconRate.text = ReqCOM.GetFieldVal("Select UPA_Conv_Rate from Curr Where Curr_Code = '" & trim(cmbOriCurrCode.selecteditem.value) & "';","UPA_Conv_Rate")
            end if
    
            if cmbOriCurrCode.selecteditem.value= "" then txtHandlingCharges.text = ""
            if cmbOriCurrCode.selecteditem.value<> "" then txtHandlingCharges.text = "1.03"
    
            Dissql ("Select VEN.Ven_Code as [Ven_Code],VEN.Ven_Code + '|' + VEN.Ven_Name as [Desc] from Vendor VEN where Ven_Code = '" & trim(drGetFieldVal("A_Ven_Code")) & "' order by Ven.Ven_Code asc","Ven_Code","DESC",cmbVenCodeC)
    
            if trim(cmbVenCodeC.selecteditem.value) = "TG005" then
                txtOriVenName.visible = true
                cmbOriCurrCode.visible = true
                txtConRate.visible = true
                txtHandlingCharges.visible = true
                txtOriUP.visible = true
                cmbCalculate.visible = true
                txtUP.enabled = false
            Elseif trim(cmbVenCodeC.selecteditem.value) <> "TG005" then
                txtOriVenName.visible = false
                cmbOriCurrCode.visible = false
                txtConRate.visible = false
                txtHandlingCharges.visible = false
                txtOriUP.visible = false
                cmbCalculate.visible = false
                txtUP.enabled = true
            End if
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End SUb
    
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
            Dim CurrVen as string = ReqCOM.GEtFieldVal("Select Ven_Code + '(' + Ven_Name + ')' as [Ven] from vendor where Ven_Code = '" & trim(cmbVenCode.selectedItem.value) & "';","Ven")
            Dim NewVen as string = ReqCOM.GEtFieldVal("Select Ven_Code + '(' + Ven_Name + ')' as [Ven] from vendor where Ven_Code = '" & trim(cmbVenCodeC.selectedItem.value) & "';","Ven")
    
            Dim CurrCurrency as string = ReqCOM.GEtFieldVal("Select Curr_Code as [Ven] from vendor where Ven_Code in (Select Ven_Code from part_source where seq_no = " & cmbVenCode.selecteditem.value & ")","Ven")
    
            Dim NewCurrency As String = ReqCOM.GEtFieldVal("Select Curr_Code as [Ven] from vendor where Ven_Code = '" & trim(cmbVenCodeC.selectedItem.value) & "';","Ven")
            Dim NewRMUP, OldRMUP as decimal
            Dim Rate,UnitConv as decimal
            Dim VenCode as string = ReqCOM.GetFieldVal("Select Ven_Code from part_source where Seq_No = " & cmbVenCode.selecteditem.value & ";","Ven_Code")
            lblUPAAppNo.text = ReqCOM.GetFieldVal("select UP_APP_NO from part_source where Seq_No = " & cmbVenCode.selecteditem.value & ";","UP_APP_NO")
    
            if trim(NewCurrency) = "RM" then NewRMUP = cdec(txtUP.text)
            if trim(NewCurrency) <> "RM" then
                Rate = reqCOM.getFieldVal("Select rate from Curr where curr_code = '" & trim(NewCurrency) & "';","Rate")
                UnitConv = reqCOM.getFieldVal("Select Unit_Conv from Curr where curr_code = '" & trim(NewCurrency) & "';","Unit_Conv")
                NewRMUP = cdec(txtUP.text) * Rate / UnitConv
            End if
    
            if trim(CurrCurrency) = "RM" then OldRMUP = cdec(lblUP.text)
            if trim(CurrCurrency) <> "RM" then
                Rate = reqCOM.getFieldVal("Select rate from Curr where curr_code = '" & trim(CurrCurrency) & "';","Rate")
                UnitConv = reqCOM.getFieldVal("Select Unit_Conv from Curr where curr_code = '" & trim(CurrCurrency) & "';","Unit_Conv")
                OldRMUP = cdec(lblUP.text) * Rate / UnitConv
            End if
    
            Dim DiffAmt as decimal = cdec(NewRMUP) - cdec(OldRMUP)
            Dim DiffPctg as decimal = cdec(DiffAmt) * 100 / cdec(OldRMUP)
    
            Dim strSql as string
            StrSql = "Update UPAS_D set UP_RM = " & cdec(OldRMUP) & ","
            StrSql = StrSql & "A_UP_RM = " & cdec(NewRMUP) & ","
            StrSql = StrSql & "Ven_Code_Temp = '" & trim(CurrVen) & "',"
            StrSql = StrSql & "A_Ven_COde_Temp = '" & trim(NewVen) & "',"
            StrSql = StrSql & "Curr_Code = '" & trim(CurrCurrency) & "',"
            StrSql = StrSql & "A_Curr_Code = '" & trim(NewCurrency) & "',"
            StrSql = StrSql & "PART_NO = '" & trim(cmbPartNo.selectedItem.value) & "',"
            StrSql = StrSql & "VEN_CODE = '" & trim(VenCode) & "',"
            StrSql = StrSql & "ACT = '" & trim(lblAction.text) & "',"
            StrSql = StrSql & "UP = " & lblUP.text & ","
            StrSql = StrSql & "STD_PACK = " & lblStdpack.text & ","
            StrSql = StrSql & "MIN_ORDER_QTY = " & lblMinOrderQty.text & ","
            StrSql = StrSql & "Lead_Time = " & lblLeadTime.text & ","
            StrSql = StrSql & "A_VEN_CODE = '" & trim(cmbVenCodeC.selectedItem.value) & "',"
            StrSql = StrSql & "A_UP = " & txtUP.text & ","
            StrSql = StrSql & "A_LEAD_TIME = " & txtLeadTime.text & ","
            StrSql = StrSql & "A_STD_PACK = " & txtStdPack.text & ","
            StrSql = StrSql & "DIFF_AMT = " & cdec(DiffAmt) & ","
            StrSql = StrSql & "DIFF_PCTG = " & cdec(DiffPctg) & ","
            StrSql = StrSql & "Rem = '" & trim(txtRem.text) & "',"
            StrSql = StrSql & "cancel_lt = " & lblCancellation.text & ","
            StrSql = StrSql & "a_cancel_lt = " & txtCancellation.text & ","
            StrSql = StrSql & "reschedule_lt = " & lblReschedule.text & ","
            StrSql = StrSql & "a_reschedule_lt = " & txtReschedule.text & ","
            StrSql = StrSql & "validity = " & txtValidity.text & ","
            StrSql = StrSql & "ORI_VEN_NAME = '" & trim(lblOriVenName.text) & "',"
            StrSql = StrSql & "ORI_CURR_CODE = '" & trim(ReqCOM.GetFieldVal("Select Curr_Code from Curr where Curr_Desc = '" & trim(lblOriCurrCode.text) & "'","Curr_Code")) & "',"
    
    
            if lblOriCurrCode.text <> "" then StrSql = StrSql & "ORI_UP = " & cdec(lblOriUP.text) & ","
            if lblOriCurrCode.text = "" then StrSql = StrSql & "ORI_UP = null,"
    
            StrSql = StrSql & "A_ORI_VEN_NAME = '" & trim(txtOriVenname.text) & "',"
            StrSql = StrSql & "A_ORI_CURR_CODE = '" & trim(cmbOriCurrCode.selecteditem.value) & "',"
    
            if txtoriup.text <> "" then StrSql = StrSql & "A_ORI_UP = " & cdec(txtOriUP.text) & ","
            if txtoriup.text = "" then StrSql = StrSql & "A_ORI_UP = null,"
    
            StrSql = StrSql & "A_MIN_ORDER_QTY = " & txtMinOrderQty.text & " "
            StrSql = StrSql & " where seq_no = " & request.params("ID") & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            response.redirect("UPAItemEdit.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub cmbVenCode_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If ReqCOM.FuncCheckDuplicate("Select * from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","Part_No") = true then
            ClearVenDet1
            Dim RsUPASD as SqlDataReader = ReqCOM.ExeDataReader("Select * from Part_Source where Seq_No = " & cmbVenCode.selectedItem.Value & ";")
            Do while RsUPASD.read
                lblUP.text = RsUPASD("UP").toString
                lblStdPack.text = cint(RsUPASD("Std_Pack_Qty"))
                lblUPAAppNo.text = rsUPASD("UP_APP_NO").tostring
                lblMinOrderQty.text = cint(RsUPASD("Min_Order_Qty"))
                lblLeadTime.text = cint(RsUPASD("Lead_Time"))
    
                lblOriVenName.text = rsUPASD("Ori_Ven_Name").tostring
                if isdbnull(rsUPASD("Ori_UP")) = false then lblOriUP.text = format(cdec(rsUPASD("Ori_UP")),"##,##0.0000")
                if isdbnull(rsUPASD("Ori_Curr_Code")) = false then lblOriCurrCode.text = reqCOM.GetFieldVal("Select Curr_Desc from Curr where Curr_Code = '" & trim(rsUPASD("Ori_Curr_Code")) & "';","Curr_Desc")
    
            loop
            RsUPASD.close()
        end if
    End Sub
    
    Sub ServerValExisting(sender As Object, e As ServerValidateEventArgs)
    '    Dim ReqCOm as ERp_Gtm.ERp_Gtm = new Erp_Gtm.Erp_Gtm
    '    If ReqCOM.FuncCheckDuplicate("Select * from UPAS_D where UPAS_No = '" & trim(lblUPASNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Part_No") = true
    '        e.isvalid = false
    '    else
    '        e.isvalid = true
    '    end if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Response.redirect("UnitPriceApprovalSheetDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from UPAS_M where upas_no = '" & trim(lblUPASNo.text) & "';","Seq_No"))
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dissql ("Select VEN.Ven_Code as [Ven_Code],VEN.Ven_Code + '|' + VEN.Ven_Name as [Desc] from Vendor VEN,Part_Source PS where VEN.Ven_Code = PS.Ven_Code and PS.Part_No = '" & trim(cmbPartNo.selecteditem.value) & "' order by Ven.Ven_Code asc","Ven_Code","DESC",cmbVenCode)
        lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_PART_NO from Part_Master where Part_No = '" & trim(cmbPartNo.selecteditem.value) & "';","M_PART_NO")
        lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartno.selecteditem.value) & "';","Part_Spec")
    
        if cmbVenCode.selectedindex = 0 then
            lblUP.text = reqCOM.GetFieldVal("Select UP from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","UP")
            lblStdPack.text = cint(reqCOM.GetFieldVal("Select Std_Pack_Qty from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Std_Pack_Qty"))
            lblUPAAppNo.text = reqCOM.GetFieldVal("Select UP_APP_NO from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","UP_APP_NO")
            lblMinOrderQty.text = cint(reqCOM.GetFieldVal("Select Min_Order_Qty from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Min_Order_Qty"))
            lblLeadTime.text = cint(reqCOM.GetFieldVal("Select Lead_Time from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","Lead_Time"))
            lblCancellation.text = cint(reqCOM.GetFieldVal("Select cancel_lt from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","cancel_lt"))
            lblReschedule.text = cint(reqCOM.GetFieldVal("Select reschedule_lt from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';","reschedule_lt"))
        elseif cmbVenCode.selectedindex = -1 then
            lblUP.text = ""
            lblStdPack.text = ""
            lblUPAAppNo.text = ""
            lblMinOrderQty.text = ""
            lblLeadTime.text = ""
        End if
    End Sub
    
    Sub cmbPartnoC_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dissql ("Select VEN.Ven_Code as [Ven_Code],VEN.Ven_Code + '|' + VEN.Ven_Name as [Desc] from Vendor VEN,Part_Source PS where VEN.Ven_Code = PS.Ven_Code and PS.Part_No = '" & trim(cmbPartNo.selecteditem.value) & "' order by Ven.Ven_Code asc","Ven_Code","DESC",cmbVenCodeC)
    End Sub
    
    Sub cmbVenCodeC_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        ClearVenDet2
        If ReqCOM.FuncCheckDuplicate("Select * from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCodec.selecteditem.value) & "';","Part_No") = true then
    
            Dim RsUPASD as SqlDataReader = ReqCOM.ExeDataReader("Select * from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCode.selecteditem.value) & "';")
            Do while RsUPASD.read
                txtUP.text = CINT(RsUPASD("UP").toString)
                txtStdPack.text = cint(RsUPASD("Std_Pack_Qty"))
                txtMinOrderQty.text = cint(RsUPASD("Min_Order_Qty"))
                txtLeadTime.text = cint(RsUPASD("Lead_Time"))
            loop
            RsUPASD.close()
    
                if trim(cmbVenCode.selecteditem.value) = "TG005" then
                    txtOriVenName.visible = true
                    cmbOriCurrCode.visible = true
                    txtConRate.visible = true
                    txtHandlingCharges.visible = true
                    txtOriUP.visible = true
                    cmbCalculate.visible = true
                    txtUP.enabled = false
                Elseif trim(cmbVenCode.selecteditem.value) <> "TG005" then
                    txtOriVenName.visible = false
                    cmbOriCurrCode.visible = false
                    txtConRate.visible = false
                    txtHandlingCharges.visible = false
                    txtOriUP.visible = false
                    cmbCalculate.visible = false
                    txtUP.enabled = true
                End if
    
        end if
    END SUB
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim OriUP,OriCurrCode as string
        cmbPartNo.items.clear
        cmbVEnCode.items.clear
        Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' order by Part_No asc","Part_No","Desc",cmbPartNo)
    
        if cmbPartNo.selectedindex = 0 then
            Dissql ("Select ps.seq_no,VEN.Ven_Code as [Ven_Code],VEN.Ven_Code + '|' + VEN.Ven_Name + '|' + cast(min_order_qty as nvarchar(20)) + '|' + cast(std_pack_qty as nvarchar(20)) as [Desc] from Vendor VEN,Part_Source PS where VEN.Ven_Code = PS.Ven_Code and PS.Part_No = '" & trim(cmbPartNo.selecteditem.value) & "' order by Ven.Ven_Code asc","Seq_No","DESC",cmbVenCode)
            Dissql ("Select ps.seq_no,VEN.Ven_Code as [Ven_Code],VEN.Ven_Code + '|' + VEN.Ven_Name + '|' + cast(min_order_qty as nvarchar(20)) + '|' + cast(std_pack_qty as nvarchar(20)) as [Desc] from Vendor VEN,Part_Source PS where VEN.Ven_Code = PS.Ven_Code and PS.Part_No = '" & trim(cmbPartNo.selecteditem.value) & "' order by Ven.Ven_Code asc","Seq_No","DESC",cmbVenCode)
            lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_PART_NO from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","M_PART_NO")
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
        end if
    
        if cmbVenCode.selectedindex = 0 then
            lblUP.text = reqCOM.GetFieldVal("Select UP from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","UP")
            lblStdPack.text = cint(reqCOM.GetFieldVal("Select Std_Pack_Qty from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","Std_Pack_Qty"))
            lblUPAAppNo.text = reqCOM.GetFieldVal("Select UP_APP_NO from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","UP_APP_NO")
            lblMinOrderQty.text = cint(reqCOM.GetFieldVal("Select Min_Order_Qty from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","Min_Order_Qty"))
            lblLeadTime.text = cint(reqCOM.GetFieldVal("Select Lead_Time from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","Lead_Time"))
            lblCancellation.text = cint(reqCOM.GetFieldVal("Select cancel_lt from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","cancel_lt"))
            lblReschedule.text = cint(reqCOM.GetFieldVal("Select reschedule_lt from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","reschedule_lt"))
            lblOriVenName.text = reqCOM.GetFieldVal("Select Ori_Ven_Name from Part_Source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","Ori_Ven_Name")
    
            OriUP = Reqcom.GetFieldVal("Select Ori_UP from part_source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","Ori_UP")
            if OriUP = "<NULL>" then
                lblOriUP.text = "0.0000"
            else
                lblOriUP.text = format(cdec(OriUP),"##,##0.0000")
            end if
    
            OriCurrCode = Reqcom.GetFieldVal("Select Ori_Curr_Code from part_source where Seq_No = " & trim(cmbVenCode.selectedItem.Value) & ";","Ori_Curr_Code")
            if OriCurrCode = "<NULL>" then
                lblOriCurrCode.text = ""
            else
                lblOriCurrCode.text = trim(OriCurrCode)
            end if
        Elseif cmbVenCode.selectedindex = -1 then
            lblUP.text = ""
            lblStdPack.text = ""
            lblMinOrderQty.text = ""
            lblLeadTime.text = ""
            lblCancellation.text = ""
            lblReschedule.text = ""
            lblOriVenName.text = ""
            lblOriUP.text = "0.00"
            lblOriCurrCode.text = ""
            lblUPAAppNo.text = ""
        end if
    
        txtSearchPart.text = "-- Search --"
    
        if cmbPartNo.selectedindex = 0 then
            GetNextControl(cmbVenCode)
        elseif cmbPartNo.selectedindex = -1 then
            ShowAlert("Invalid Part no selected. Please select another Part no.")
        end if
    
    End Sub
    
    Sub ClearVenDet1()
        lblUP.text = ""
        lblStdPack.text = ""
        lblMinOrderQty.text = ""
        lblLeadTime.text = ""
    End sub
    
    Sub ClearVenDet2()
        txtUP.text = ""
        txtStdPack.text = ""
        lblUPAAppNo.text = ""
        txtMinOrderQty.text = ""
        txtLeadTime.text = ""
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub ClearPartDet()
        lblMfgPartNo.text = ""
        lblPartSpec.text = ""
    End sub
    
    Sub cmdSearchSupplier_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if cmbPartNo.selectedindex = -1 then txtSearchSupplier.text = "-- Search --" : ShowAlert("Invalid Part No. Please select another.") :Exit sub
        if cmbVenCode.selectedIndex = -1 then txtSearchSupplier.text = "-- Search --": ShowAlert("Invalid Current Supplier Code. Please select another.") :Exit sub
    
        cmbVenCodeC.items.clear
        Dissql ("Select VEN.Ven_Code as [Ven_Code],VEN.Ven_Code + '|' + VEN.Ven_Name as [Desc] from Vendor VEN where VEN.Ven_Code + Ven.Ven_Name like '%" & trim(txtSearchSupplier.text) & "%' order by Ven.Ven_Code asc","Ven_Code","DESC",cmbVenCodeC)
    
    
    
        if cmbVenCodeC.selectedindex = 0  then
            if ReqCOM.FuncCheckDuplicate("Select UP from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCodeC.selecteditem.value) & "';","UP") = true then
                txtUP.text = CINT(reqCOM.GetFieldVal("Select UP from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCodeC.selecteditem.value) & "';","UP"))
                txtStdPack.text = cint(reqCOM.GetFieldVal("Select Std_Pack_Qty from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCodeC.selecteditem.value) & "';","Std_Pack_Qty"))
                txtMinOrderQty.text = cint(reqCOM.GetFieldVal("Select Min_Order_Qty from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCodeC.selecteditem.value) & "';","Min_Order_Qty"))
                txtLeadTime.text = cint(reqCOM.GetFieldVal("Select Lead_Time from Part_Source where Part_No = '" & trim(cmbPartNo.selectedItem.Value) & "' and Ven_Code = '" & trim(cmbVenCodeC.selecteditem.value) & "';","Lead_Time"))
            End if
    
                if trim(cmbVenCodeC.selecteditem.value) = "TG005" then
                    txtOriVenName.visible = true
                    cmbOriCurrCode.visible = true
                    txtConRate.visible = true
                    txtHandlingCharges.visible = true
                    txtOriUP.visible = true
                    cmbCalculate.visible = true
                    txtUP.enabled = false
                Elseif trim(cmbVenCodeC.selecteditem.value) <> "TG005" then
                    txtOriVenName.visible = false
                    cmbOriCurrCode.visible = false
                    txtConRate.visible = false
                    txtHandlingCharges.visible = false
                    txtOriUP.visible = false
                    cmbCalculate.visible = false
                    txtUP.enabled = true
                End if
        else
            ClearVenDet2
        End if
        txtSearchSupplier.text = "-- Search --"
    
        if cmbVenCodeC.selectedindex = 0 then
            GetNextControl(txtUP)
        elseif cmbVenCodeC.selectedindex = -1 then
            ShowAlert("Invalid Supplier Code selected. Please select another.")
        end if
    End Sub
    
    Sub GetNextControl(ByVal FocusControl As Control)
        Dim Script As New System.Text.StringBuilder
        Dim ClientID As String = FocusControl.ClientID
    
            Script.Append("<script language=javascript>")
            Script.Append("document.getElementById('")
            Script.Append(ClientID)
            Script.Append("').focus();")
            Script.Append("</script" & ">")
            RegisterStartupScript("setFocus", Script.ToString())
    End Sub
    
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
    
    Sub cmbCalculate_Click(sender As Object, e As EventArgs)
        if txtconrate.text = "" then exit sub
        if txtHandlingCharges.text = "" then exit sub
        if txtOriUP.text = "" then exit sub
        if txtConRate.text <= 0 then exit sub
    
        txtUP.text = format(cdec(cdec(txtOriUP.text) / cdec(txtConRate.text) * cdec(txtHandlingCharges.text)),"####0.00000")
        txtUP.text = AsymArith(cdec(txtup.text),10000)
    End Sub
    
    Function AsymArith(ByVal X As Double, Optional ByVal Factor As Double = 1) As Double
        AsymArith = Int(X * Factor + 0.5) / Factor
    End Function
    
    Sub cmbOriCurrCode_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        txtconRate.text = ReqCOM.GetFieldVal("Select UPA_Conv_Rate from Curr Where Curr_Code = '" & trim(cmbOriCurrCode.selecteditem.value) & "';","UPA_Conv_Rate")
        if cmbOriCurrCode.selecteditem.value= "" then txtHandlingCharges.text = ""
        if cmbOriCurrCode.selecteditem.value<> "" then txtHandlingCharges.text = "1.03"
    
    End Sub
    
    
    Sub ValVen_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        'Dim VenCode as string = ReqCOM.GetFieldVal("Select Ven_Code from Part_Source where seq_no = " & cmbVenCode.selecteditem.value & ";","Ven_Code")
        'if ReqCOM.FuncCheckDuplicate("Select part_no from UPAS_D where Part_no = '" & trim(cmbPartNo.selecteditem.value) & "' and Ven_Code = '" & trim(VenCode) & "' and Std_Pack = " & clng(lblStdPack.text) & " and Min_Order_Qty = " & clng(lblMinOrderQty.text) & " and upas_no = '" & trim(lblUPASNo.text) & "' and act = 'EDIT';","Part_No") = true then
        '    e.isvalid = false
        'end if
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
                                <asp:Label id="Label5" runat="server" width="100%" cssclass="FormDesc">EDIT APPROVAL
                                SHEET ITEM</asp:Label>
                            </p>
                            <p align="left">
                                <table style="HEIGHT: 27px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table cellspacing="0" cellpadding="0" width="84%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:CustomValidator id="ValExisting" runat="server" EnableClientScript="False" OnServerValidate="ServerValExisting" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="cmbPartNo" Width="100%">
                                    Part Source already exist in currrent Approval Sheet
                                </asp:CustomValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtCancellation" Width="100%" ErrorMessage="You don't seem to have supplied a valid Cancellation window value."></asp:RequiredFieldValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator10" runat="server" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtReschedule" Width="100%" ErrorMessage="You don't seem to have supplied a valid Reschedule window value"></asp:RequiredFieldValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator11" runat="server" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtLeadTime" Width="100%" ErrorMessage="You don't seem to have supplied a valid Lead Time."></asp:RequiredFieldValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtminOrderQty" Width="100%" ErrorMessage="You don't seem to have supplied a valid Min. Order Qty."></asp:RequiredFieldValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtUP" Width="100%" ErrorMessage="You don't seem to have supplied a valid Unit Price."></asp:RequiredFieldValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtStdPack" Width="100%" ErrorMessage="You don't seem to have supplied a valid Std. Pack."></asp:RequiredFieldValidator>
                                                                        <asp:comparevalidator id="CompareUP" runat="server" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtUP" Width="100%" ErrorMessage="You don't seem to have supplied a valid Unit Price." Operator="DataTypeCheck" Type="Double"></asp:comparevalidator>
                                                                        <asp:comparevalidator id="CompareLeadTime" runat="server" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtLeadTime" Width="100%" ErrorMessage="You don't seem to have supplied a valid Lead Time." Operator="DataTypeCheck" Type="Integer"></asp:comparevalidator>
                                                                        <asp:comparevalidator id="CompareMinOrderQty" runat="server" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtMinOrderQty" Width="100%" ErrorMessage="You don't seem to have supplied a valid Min. Order Qty." Operator="DataTypeCheck" Type="Integer"></asp:comparevalidator>
                                                                        <asp:comparevalidator id="CompareStdPack" runat="server" EnableClientScript="False" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtStdPack" Width="100%" ErrorMessage="You don't seem to have supplied a valid Std. Pack." Operator="DataTypeCheck" Type="Integer"></asp:comparevalidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="cmbVenCode" Width="100%" ErrorMessage="You don't seem to have supplied a valid Supplier."></asp:RequiredFieldValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtValidity" Width="100%" ErrorMessage="You don't seem to have supplied a valid validity."></asp:RequiredFieldValidator>
                                                                        <asp:CompareValidator id="CompareValidator1" runat="server" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtValidity" ErrorMessage="You don't seem to have supplied a valid validity." Operator="GreaterThan" Type="Integer" ValueToCompare="-1"></asp:CompareValidator>
                                                                        <asp:CustomValidator id="ValVen" runat="server" EnableClientScript="False" OnServerValidate="ValVen_ServerValidate" CssClass="ErrorText" ForeColor=" " Display="Dynamic" Width="100%" ErrorMessage="Supplier with same MOQ and SPQ already exist. Please select another."></asp:CustomValidator>
                                                                    </p>
                                                                    <p>
                                                                    </p>
                                                                    <div align="left"><asp:Label id="lblUPASNo" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblUPAAppNo" runat="server" width="128px" cssclass="LabelNormal" visible="False"></asp:Label>
                                                                    </div>
                                                                    <div align="left"><asp:Label id="lblAction" runat="server" cssclass="OutputText" visible="False"></asp:Label>
                                                                    </div>
                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <p>
                                                                                        <asp:Label id="Label1" runat="server" cssclass="Instruction">EXISTING SOURCE</asp:Label>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label7" runat="server" width="128px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left">
                                                                                        <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                                        &nbsp;&nbsp; 
                                                                                        <asp:DropDownList id="cmbPartNo" runat="server" CssClass="OutputText" Width="305px" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label8" runat="server" width="128px" cssclass="LabelNormal">Supplier</asp:Label></td>
                                                                                <td>
                                                                                    <asp:DropDownList id="cmbVenCode" onkeydown="GetFocus(txtSearchSupplier)" runat="server" CssClass="OutputText" Width="100%" OnSelectedIndexChanged="cmbVenCode_SelectedIndexChanged" autopostback="true"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="lblPartSpec1" runat="server" width="128px" cssclass="LabelNormal">Specification</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPartSpec" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="lblMfgPartNo1" runat="server" width="128px" cssclass="LabelNormal">Mfg
                                                                                    Part No</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblMfgPartNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label13" runat="server" width="128px" cssclass="LabelNormal">Unit Price</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblUP" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label14" runat="server" width="128px" cssclass="LabelNormal">Std. Pack</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblStdPack" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label15" runat="server" width="128px" cssclass="LabelNormal">Min. Order
                                                                                    Qty</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblminOrderQty" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label4" runat="server" width="128px" cssclass="LabelNormal">cancellation
                                                                                    (weeeks)</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblCancellation" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label6" runat="server" width="128px" cssclass="LabelNormal">Reschedule(weeks)</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblReschedule" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label16" runat="server" width="128px" cssclass="LabelNormal">Lead Time</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblLeadTime" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
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
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td colspan="2">
                                                                                        <asp:Label id="Label2" runat="server" cssclass="Instruction">NEW SOURCE</asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label11" runat="server" width="128px" cssclass="LabelNormal">Supplier</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtSearchSupplier" onkeydown="KeyDownHandler(cmdSearchSupplier)" onclick="GetFocus(txtSearchSupplier)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdSearchSupplier" onclick="cmdSearchSupplier_Click" runat="server" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                                        &nbsp;&nbsp; 
                                                                                        <asp:DropDownList id="cmbVenCodeC" runat="server" CssClass="OutputText" Width="311px" OnSelectedIndexChanged="cmbVenCodeC_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label12" runat="server" width="128px" cssclass="LabelNormal">Unit Price</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtUP" onkeydown="GetFocusWhenEnter(txtStdPack)" runat="server" CssClass="OutputText" Width="181px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label17" runat="server" width="128px" cssclass="LabelNormal">Std. Pack</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtStdPack" onkeydown="GetFocusWhenEnter(txtMinOrderQty)" runat="server" CssClass="OutputText" Width="181px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label18" runat="server" width="128px" cssclass="LabelNormal">Min. Order
                                                                                        Qty</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtMinOrderQty" onkeydown="GetFocusWhenEnter(txtLeadTime)" runat="server" CssClass="OutputText" Width="181px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label19" runat="server" width="128px" cssclass="LabelNormal">Lead Time</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtLeadTime" onkeydown="GetFocusWhenEnter(txtCancellation)" runat="server" CssClass="OutputText" Width="181px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label9" runat="server" width="128px" cssclass="LabelNormal">cancellation
                                                                                        (weeeks)</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtCancellation" onkeydown="GetFocusWhenEnter(txtReschedule)" runat="server" CssClass="OutputText" Width="181px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label10" runat="server" width="128px" cssclass="LabelNormal">Reschedule(weeks)</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtReschedule" onkeydown="GetFocusWhenEnter(txtOriVenName)" runat="server" CssClass="OutputText" Width="181px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label25" runat="server" width="128px" cssclass="LabelNormal">Original
                                                                                        Supplier</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOriVenName" onkeydown="GetFocusWhenEnterWithoutSelect(cmbOriCurrCode)" runat="server" CssClass="OutputText" Width="100%" Height="22px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label29" runat="server" width="128px" cssclass="LabelNormal">Original
                                                                                        Currency</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:DropDownList id="cmbOriCurrCode" onkeydown="GetFocusWhenEnter(txtConRate)" runat="server" CssClass="OutputText" Width="214px" OnSelectedIndexChanged="cmbOriCurrCode_SelectedIndexChanged" autopostback="true">
                                                                                            <asp:ListItem Value=""></asp:ListItem>
                                                                                            <asp:ListItem Value="JPY">JAPANESE YEN</asp:ListItem>
                                                                                            <asp:ListItem Value="USD">US DOLLARS</asp:ListItem>
                                                                                            <asp:ListItem Value="NTD">NT DOLLARS</asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label30" runat="server" width="128px" cssclass="LabelNormal">Conv.
                                                                                        Rate</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtConRate" onkeydown="GetFocusWhenEnter(txtHandlingCharges)" runat="server" CssClass="OutputText" Width="214px" Height="22px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label31" runat="server" width="128px" cssclass="LabelNormal">Handling
                                                                                        Charges</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtHandlingCharges" onkeydown="GetFocusWhenEnter(txtOriUP)" runat="server" CssClass="OutputText" Width="214px" Height="22px"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label26" runat="server" width="128px" cssclass="LabelNormal">Original
                                                                                        U/P</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtOriUP" onkeydown="GetFocusWhenEnter(txtValidity)" runat="server" CssClass="OutputText" Width="214px" Height="22px"></asp:TextBox>
                                                                                        &nbsp;&nbsp; 
                                                                                        <asp:Button id="cmbCalculate" onclick="cmbCalculate_Click" runat="server" Width="94px" Text="Calculate" CausesValidation="False"></asp:Button>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label20" runat="server" width="128px" cssclass="LabelNormal">Validity</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtValidity" onkeydown="GetFocusWhenEnter(txtRem)" runat="server" CssClass="OutputText" Width="78px"></asp:TextBox>
                                                                                        <asp:Label id="Label21" runat="server" cssclass="LabelNormal">days upon approval (set
                                                                                        to 0 if no validity)</asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server" width="128px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="100%" Height="22px" MaxLength="200"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 26px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Update item details"></asp:Button>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="center">
                                                                                            <asp:Button id="cmdView" onclick="cmdView_Click" runat="server" Width="189px" Text="View Existing Supplier" CausesValidation="False"></asp:Button>
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
