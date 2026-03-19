<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Web.Mail" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then
            cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this Document ?')==false) return false;")
            cmdSubmit1.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this Document ?')==false) return false;")
            cmdRemove1.attributes.add("onClick","javascript:if(confirm('Are you sure you want to remove this SSER from the system ?')==false) return false;")
            cmdRemove.attributes.add("onClick","javascript:if(confirm('Are you sure you want to remove this SSER from the system ?')==false) return false;")
            cmdResubmit.attributes.add("onClick","javascript:if(confirm('A new part approval submission will be re-generated.\nAre you sure u want to proceed ?')==false) return false;")
            cmdIgnoreResubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to re-generate this rejected part submission.\nAre you sure u want to proceed ?')==false) return false;")
            cmdResubmit1.attributes.add("onClick","javascript:if(confirm('A new part approval submission will be re-generated.\nAre you sure u want to proceed ?')==false) return false;")
            cmdIgnoreResubmit1.attributes.add("onClick","javascript:if(confirm('You will not be able to re-generate this rejected part submission.\nAre you sure u want to proceed ?')==false) return false;")
    
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim rsSSER as SQLDataReader = ReqCOM.ExeDataReader("Select * from SSER_M where Seq_No = " & Request.params("ID") & "")
            Dim oList As ListItemCollection
    
            do while rsSSER.read
                lblSSERNo.text = rsSSER("SSER_No").tostring
                lblSSERDate.text = format(rsSSER("SSER_Date"),"dd/MMM/yy")
                lblSubmitBy.text = rsSSER("Submit_By").tostring
                if isdbnull(rsSSER("Submit_Date")) = false then lblSubmitDate.text = format(rsSSER("Submit_Date"),"dd/MMM/yy")
                ProcLoadGridData
                txtMEHODRem.text = rsSSER("ME_HOD_Rem").tostring
                lblMEHODBy.text = rsSSER("ME_HOD_BY").tostring
                if isdbnull(rsSSER("ME_HOD_Date")) = false then lblMEHODDate.text = format(cdate(rsSSER("ME_HOD_Date").tostring),"dd/MMM/yy")
    
                if rsSSER("ME_HOD_Stat").tostring = "Y" then
                    rbMEHodAcc.checked = true
                elseif rsSSER("ME_HOD_Stat").tostring = "N" then
                    rbMEHodRej.checked = true
                Else
                    rbMEHodAcc.checked = true
                End if
    
                if isdbnull(rsSSER("URGent")) = false then
                    if rsSSER("URGent") = "Y" then chkUrgent.checked = true else chkUrgent.checked = false
                end if
    
                txtQAColor.text = rsSSER("QA_color_rem").tostring
                txtQACosApp.text = rsSSER("QA_Cos_App_rem").tostring
                txtQAPack.text = rsSSER("QA_Pack_rem").tostring
                lblMFG.text = rsSSER("manufacturer").tostring
                txtMfg.text = rsSSER("manufacturer").tostring
                lblMFGPartNo.text = rsSSER("Mfg_Part_No").tostring
                lblPartDesc.text = rsSSER("Part_Desc").tostring
                lblPartSpec.text = rsSSER("part_Spec").tostring
                lblRefModel.text = rsSSER("ref_model").tostring
    
                lblQAEngBy.text = rsSSER("QA_Eng_By").tostring
                if isdbnull(rsSSER("QA_Eng_Date")) = false then lblQAEngDate.text = format(cdate(rsSSER("QA_Eng_Date")),"dd/MMM/yy")
                txtQAEngRem.text = rsSSER("QA_Eng_Rem").tostring
    
                if isdbnull(rsSSER("QA_HOD_By")) = false then lblQAHODBy.text = rsSSER("QA_HOD_By").tostring
                if isdbnull(rsSSER("QA_HOD_Date")) = false then lblQAHODDate.text = format(cdate(rsSSER("QA_HOD_Date")),"dd/MMM/yy")
                if isdbnull(rsSSER("QA_HOD_Rem")) = false then txtQAHODRem.text = rsSSER("QA_HOD_Rem")
    
                if isdbnull(rsSSER("ME_DIA_MEA_STAT")) = false then
                    if rsSSER("ME_DIA_MEA_STAT") = 1 then rbDM1.checked = true
                    if rsSSER("ME_DIA_MEA_STAT") = 2 then rbDM2.checked = true
                    if rsSSER("ME_DIA_MEA_STAT") = 3 then rbDM3.checked = true
                Elseif isdbnull(rsSSER("ME_DIA_MEA_STAT")) = true then
                end if
    
                if isdbnull(rsSSER("ME_INIT_MEA_STAT")) = false then
                    if rsSSER("ME_INIT_MEA_STAT") = 1 then rbIM1.checked = true
                    if rsSSER("ME_INIT_MEA_STAT") = 2 then rbIM2.checked = true
                    if rsSSER("ME_INIT_MEA_STAT") = 3 then rbIM3.checked = true
                else
                end if
    
                if isdbnull(rsSSER("ME_ENV_TEST_STAT")) = false then
                    if rsSSER("ME_ENV_TEST_STAT") = 1 then rbET1.checked = true
                    if rsSSER("ME_ENV_TEST_STAT") = 2 then rbET2.checked = true
                    if rsSSER("ME_ENV_TEST_STAT") = 3 then rbET3.checked = true
                else
                end if
    
                if isdbnull(rsSSER("ME_MECH_TEST_STAT")) = false then
                    if rsSSER("ME_MECH_TEST_STAT") = 1 then rbMT1.checked = true
                    if rsSSER("ME_MECH_TEST_STAT") = 2 then rbMT2.checked = true
                    if rsSSER("ME_MECH_TEST_STAT") = 3 then rbMT3.checked = true
                else
                end if
    
                if isdbnull(rsSSER("ME_END_TEST_STAT")) = false then
                    if rsSSER("ME_END_TEST_STAT") = 1 then rbENDT1.checked = true
                    if rsSSER("ME_END_TEST_STAT") = 2 then rbENDT2.checked = true
                    if rsSSER("ME_END_TEST_STAT") = 3 then rbENDT3.checked = true
                else
                End if
    
                if isdbnull(rsSSER("ME_Safe_Check_STAT")) = false then
                    if rsSSER("ME_Safe_Check_STAT") = 1 then rbSC1.checked = true
                    if rsSSER("ME_Safe_Check_STAT") = 2 then rbSC2.checked = true
                    if rsSSER("ME_Safe_Check_STAT") = 3 then rbSC3.checked = true
                Else
                End if
    
                if isdbnull(rsSSER("ME_Mat_Analy_STAT")) = false then
                    if rsSSER("ME_Mat_Analy_STAT") = 1 then rbMA1.checked = true
                    if rsSSER("ME_Mat_Analy_STAT") = 2 then rbMA2.checked = true
                    if rsSSER("ME_Mat_Analy_STAT") = 3 then rbMA3.checked = true
                Else
                end if
    
                 if isdbnull(rsSSER("me_func_aspect_stat")) = false then
                    if rsSSER("me_func_aspect_stat") = 1 then rbFA1.checked = true
                    if rsSSER("me_func_aspect_stat") = 2 then rbFA2.checked = true
                    if rsSSER("me_func_aspect_stat") = 3 then rbFA3.checked = true
                else
                end if
    
                if isdbnull(rsSSER("QA_Color_Stat")) = true then
                else
                    if rsSSER("QA_Color_Stat") = 1 then rbcol1.checked = true
                    if rsSSER("QA_Color_Stat") = 2 then rbcol2.checked = true
                    if rsSSER("QA_Color_Stat") = 3 then rbcol3.checked = true
                end if
    
                if isdbnull(rsSSER("QA_COS_APP_stat")) = true then
                else
                    if rsSSER("QA_COS_APP_stat") = 1 then RBcOSaPP1.checked = true
                    if rsSSER("QA_COS_APP_stat") = 2 then RBcOSaPP2.checked = true
                    if rsSSER("QA_COS_APP_stat") = 3 then RBcOSaPP3.checked = true
                end if
    
                if isdbnull(rsSSER("QA_pack_stat")) = true then
    
                else
                    if rsSSER("QA_pack_stat") = 1 then rbPack1.checked = true
                    if rsSSER("QA_pack_stat") = 2 then rbPack2.checked = true
                    if rsSSER("QA_pack_stat") = 3 then rbPack3.checked = true
                end if
    
                if isdbnull(rsSSER("QA_Eng_Stat")) = false then
                    if rsSSER("QA_Eng_Stat") = "Y" then rbQAEngApp.checked = true
                    if rsSSER("QA_Eng_Stat") = "N" then rbQAEngRej.checked = true
                Else
                    rbQAEngRej.checked = true
                end if
    
                if isdbnull(rsSSER("QA_HOD_Stat")) = true then
                    rbQAHODRej.checked = true
                else
                    if rsSSER("QA_HOD_Stat") = "Y" then rbQAHODApp.checked = true
                    if rsSSER("QA_HOD_Stat") = "N" then rbQAHODRej.checked = true
                end if
    
                txtRemarks.text = rsSSER("SUBMIT_REM").tostring
    
                txtDimMea.text = rsSSER("ME_DIA_MEA_REM").tostring
                txtIniMea.text = rsSSER("ME_INIT_MEA_REM").tostring
                txtEnvTest.text = rsSSER("ME_ENV_TEST_REM").tostring
                txtMechTest.text = rsSSER("ME_MECH_TEST_REM").tostring
                txtEndTest.text = rsSSER("ME_END_TEST_REM").tostring
                txtMatAnaly.text = rsSSER("ME_MAT_ANALY_REM").tostring
                txtSafetyCheck.text = rsSSER("ME_SAFE_CHECK_REM").tostring
                txtFuncAspect.text = rsSSER("ME_FUNC_ASPECT_REM").tostring
                txtMEOthers.text = rsSSER("ME_OTHERS").tostring
                txtMEApplicant.text = rsSSER("ME_APPLICANT").tostring
                txtMEFileNo.text = rsSSER("ME_FILE_NO").tostring
                if isdbnull(rsSSER("Req_Date")) = false then lblReqDate.text = format(cdate(rsSSER("Req_Date")),"dd/MMM/yy")
                if rsSSER("UL").tostring = "Y" then chkUL.Checked = true else chkUL.Checked = false
                if rsSSER("ETL").tostring = "Y" then chkETL.Checked = true else chkETL.Checked = false
                if rsSSER("CSA").tostring = "Y" then chkCSA.Checked = true else chkCSA.Checked = false
                if rsSSER("CE").tostring = "Y" then chkCE.Checked = true else chkCE.Checked = false
                if rsSSER("PEN_FILE_APP").tostring = "Y" then chkPendingFileApproval.Checked = true else chkPendingFileApproval.Checked = false
                if rsSSER("ME_Others").tostring = "Y" then chkMeOthers.Checked = true else chkMeOthers.Checked = false
    
                if isdbnull(rsSSER("ME_ENG_Stat")) = false then
                    if rsSSER("ME_ENG_Stat") = 1 then rbMEEngAcc.checked = true
                    if rsSSER("ME_ENG_Stat") = 2 then rbMEEngRej.checked = true
                    if rsSSER("ME_ENG_Stat") = 3 then rbMEEngCon.checked = true
                else
                    rbMEEngAcc.checked = true
                end if
    
                if isdbnull(rsSSER("ME_ENG_BY")) = false then lblMEEngBy.text = rsSSER("ME_ENG_BY").tostring
                if isdbnull(rsSSER("ME_ENG_DATE")) = false then lblMEEngDate.text = format(cdate(rsSSER("ME_ENG_DATE")),"dd/MMM/yy")
                txtMEEngRem.text = rsSSER("ME_ENG_Rem").tostring
    
                if TRIM(rsSSER("NEW_PART").TOSTRING) = "N" then chkNewPart.checked = false
                if TRIM(rsSSER("NEW_PART").TOSTRING) = "Y" then chkNewPart.checked = true
    
                if TRIM(rsSSER("RE_SUBMIT").TOSTRING) = "N" then chkReSubmit.checked = false
                if TRIM(rsSSER("RE_SUBMIT").TOSTRING) = "Y" then chkReSubmit.checked = true
    
                if TRIM(rsSSER("ADD_SOURCE").TOSTRING) = "N" then chkAddSource.checked = false
                if TRIM(rsSSER("ADD_SOURCE").TOSTRING) = "Y" then chkAddSource.checked = true
    
                if TRIM(rsSSER("COST_DOWN").TOSTRING) = "N" then chkCostDown.checked = false
                if TRIM(rsSSER("COST_DOWN").TOSTRING) = "Y" then chkCostDown.checked = true
    
                if isdbnull(rsSSER("submit_date")) = false then
                    cmdUpdate.enabled = false
                    cmdSubmit.enabled = false
                    cmdUpdate1.enabled = false
                    cmdSubmit1.enabled = false
                    cmdPrintTraveller.enabled = true
                    cmdPrintTraveller1.enabled = true
                    cmdPrintSSER.enabled = true
                    cmdPrintSSER1.enabled = true
                    lnkAttachment.enabled = false
                    chkUrgent.enabled = false
                    chkNewPart.enabled = false
                    chkResubmit.enabled = false
                    chkAddSource.enabled = false
                    chkCostDown.enabled = false
                    lblVenCode.text = ReqCOM.GetFieldVal("Select Ven_name from Vendor Where Ven_Code = '" & trim(rsSSER("ven_Code").tostring) & "';","Ven_name")
                    txtSearchSupplier.visible = false
                    cmdSearchSupplier.visible = false
                    cmbVenCodeC.visible = false
                    lblVenCode.visible = true
                    lblCntPerson.text = rsSSER("CNT_Person").tostring
                    lblCntPerson.visible = true
                    txtCntPerson.visible = false
                    lblEMail.text = rsSSER("EMail").tostring
                    lblEMail.visible = true
                    txtEMail.visible = false
                    lblSampleQty.text = rsSSER("Sample_Qty").tostring
                    txtSampleQty.visible = False
                    lblSampleQty.visible = true
                    lblPartFrom.text = rsSSER("Part_No_From")
                    lblPartFrom.visible = true
                    cmbPartFrom.visible = false
                    txtPartFrom.visible = false
                    cmdPartFrom.visible = false
    
    
    
    
                    lblPartTo.text = rsSSER("Part_No_To")
                    lblPartTo.visible = true
                    cmbPartTo.visible = false
                    txtPartTo.visible = false
                    cmdPartTo.visible = false
                    cmdRemove.enabled = false
                    cmdRemove1.enabled = false
    
                    if rsSSER("SSER_STAT").tostring = "REJECTED" then
                        if rsSSER("REGENERATE").TOSTRING = "N" then
                            cmdResubmit.enabled = true
                            cmdResubmit1.enabled = true
                            cmdIgnoreResubmit.enabled = true
                            cmdIgnoreResubmit1.enabled = true
                        elseif (rsSSER("REGENERATE").TOSTRING = "I") or (rsSSER("REGENERATE").TOSTRING = "Y") then
                            cmdResubmit.enabled = false
                            cmdResubmit1.enabled = false
                            cmdIgnoreResubmit.enabled = false
                            cmdIgnoreResubmit1.enabled = false
                        END IF
                    else
                        cmdResubmit.enabled = false
                        cmdResubmit1.enabled = false
                        cmdIgnoreResubmit.enabled = false
                        cmdIgnoreResubmit1.enabled = false
                    end if
    
                    lblMfg.visible = true
                    txtMfg.visible = false
    
    
                elseif isdbnull(rsSSER("submit_date")) = true then
                    cmdResubmit.enabled = false
                    cmdResubmit1.enabled = false
    
                    cmdIgnoreResubmit.enabled = false
                    cmdIgnoreResubmit1.enabled = false
    
    
    
                    if ucase(trim(lblSubMitBy.text)) = trim(ucase(request.cookies("U_ID").value)) then
                        cmdRemove.enabled = true
                        cmdRemove1.enabled = true
                    else
                        cmdRemove.enabled = false
                        cmdRemove1.enabled = false
                    end if
    
                    if ReqCOm.FuncCheckDuplicate("Select mfg from Part_master where part_no = '" & trim(rsSSER("Part_No_From").tostring) & "' and Mfg is not null","mfg") = true then
                        if ReqCOm.GetFieldVal("Select mfg from Part_master where part_no = '" & trim(rsSSER("Part_No_From").tostring) & "';","mfg") = "" then
                            lblMfg.visible = false
                            txtMfg.visible = true
                        else
                            lblMfg.visible = true
                            txtMfg.visible = false
                        end if
                    else
                        lblMfg.visible = false
                        txtMfg.visible = true
                    end if
    
    
    
    
    
                    chkUrgent.enabled = true
                    cmdUpdate.enabled = true
                    cmdUpdate1.enabled = true
                    cmdPrintSSER.enabled = false
                    cmdPrintSSER1.enabled = false
                    lnkAttachment.visible = true
                    Dissql("Select Ven_name,Ven_Code from Vendor Where Ven_Code = '" & trim(rsSSER("ven_Code").tostring) & "';","Ven_Code","Ven_name",cmbVenCodeC)
                    txtSearchSupplier.visible = true
                    cmdSearchSupplier.visible = true
                    cmbVenCodeC.visible = true
                    lblVenCode.visible = false
                    txtCntPerson.text = rsSSER("CNT_Person").tostring
                    lblCntPerson.visible = false
                    txtCntPerson.visible = true
                    txtEMail.text = rsSSER("EMail").tostring
                    lblEMail.visible = false
                    txtEMail.visible = true
                    txtSampleQty.text = rsSSER("Sample_Qty").tostring
                    txtSampleQty.visible = true
                    lblSampleQty.visible = False
                    oList  = cmbPartFrom.Items
                    oList.Add(New ListItem(rsSSER("Part_No_From").tostring))
                    lblPartFrom.visible = false
                    cmbPartFrom.visible = true
                    txtPartFrom.visible = true
                    cmdPartFrom.visible = true
                    oList = cmbPartTo.Items
                    oList.Add(New ListItem(rsSSER("Part_No_To").tostring))
                    lblPartTo.visible = false
                    cmbPartTo.visible = true
                    txtPartTo.visible = true
                    cmdPartTo.visible = true
                    chkNewPart.enabled = true
                    chkResubmit.enabled = true
                    chkAddSource.enabled = true
                    chkCostDown.enabled = true
                    cmdPrintTraveller.enabled = False
                    cmdPrintTraveller1.enabled = False
    
                    if cint(dtgUPASAttachment.items.count) = 0 then
                        cmdSubmit.enabled = false
                        cmdSubmit1.enabled = false
                    elseif cint(dtgUPASAttachment.items.count) <> 0 then
                        cmdSubmit.enabled = true
                        cmdSubmit1.enabled = true
                    End if
    
                 end if
                 loop
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
    
         Sub GetSupplierDet()
            Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            if cmbVenCodeC.selectedindex = -1 then
                txtCntPerson.text = ""
                txtEmail.text = ""
            elseif cmbVenCodeC.selectedindex <> -1 then
                txtCntPerson.text = ReqCOm.GetFieldVal("Select top 1 Contact_Person from vendor where ven_Code = '" & trim(cmbVenCodeC.selecteditem.value) & "';","Contact_Person")
                txtEmail.text = ReqCOm.GetFieldVal("Select top 1 EMAIL_SSER from vendor where ven_Code = '" & trim(cmbVenCodeC.selecteditem.value) & "';","EMAIL_SSER")
            end if
         End sub
    
         Sub cmbVenCodeC_SelectedIndexChanged(sender As Object, e As EventArgs)
             GetSupplierDet()
         End Sub
    
         Sub cmdpartFrom_Click(sender As Object, e As EventArgs)
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim rsPart as SQLDataReader
    
             cmbPartFrom.items.clear
             Dissql ("Select Part_No,Part_No as [Desc] from Part_Master where part_no like '%" & cstr(replace(txtPartFrom.Text,"'","`")) & "%' order by Part_No asc","Part_No","Desc",cmbPartFrom)
             Dissql ("Select top 1 Part_No,Part_No as [Desc] from Part_Master where part_no like '%" & trim(txtPartFrom.text) & "%' order by Part_No asc","Part_No","Desc",cmbPartTo)
    
             if cmbPartFrom.selectedindex = 0 then
                 rsPart  = ReqCOM.ExeDataReader("Select top 1 * from Part_Master where Part_No = '" & trim(cmbPartFrom.selectedItem.value) & "';")
                 Do while rsPart.read
                     lblPartSpec.text = rsPart("Part_Spec").tostring
                     lblPartDesc.text = rsPart("Part_Desc").tostring
                     lblMfgPartNo.text = rsPart("M_Part_No").tostring
                     lblMfg.text = rsPart("MFG").tostring
                     txtMfg.text = rsPart("MFG").tostring
                     lblRefModel.text = rsPart("Ref_Model").tostring
    
                     if trim(lblMfg.text) = "" then
                        txtMfg.visible = true
                        lblMfg.visible = false
                     else
                        txtMfg.visible = false
                        lblMfg.visible = true
                     end if
                 loop
             elseif cmbPartFrom.selectedindex = -1 then
                Dim oList As ListItemCollection = cmbPartFrom.Items
                oList.Add(New ListItem(replace(txtPartFrom.text,"'","`")))
                lblPartSpec.text = ""
                lblPartDesc.text = ""
                lblMfgPartNo.text = ""
                lblMfg.text = ""
                txtMfg.text = ""
                txtMfg.visible = true
             end if
    
             txtPartFrom.text = "-- Search --"
         End Sub
    
         Sub cmdPartTo_Click(sender As Object, e As EventArgs)
             cmbPartTo.items.clear
             Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no like '%" & cstr(replace(txtPartTo.Text,"'","`")) & "%' order by Part_No asc","Part_No","Part_No",cmbPartTo)
             if cmbPartTo.selectedIndex = -1 then
                 Dim oList As ListItemCollection = cmbPartTo.Items
                 oList.Add(New ListItem(replace(txtPartTo.text,"'","`")))
             end if
             txtPartTo.text = "-- Search --"
         End Sub
    
         Sub SaveDetails()
            Dim StrSql as string
            Dim Reason as integer
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            StrSql = "Update SSER_M set Ven_Code = '" & trim(cmbVenCodeC.selectedItem.value) & "',"
    
            StrSql = StrSql + "CNT_Person='" & trim(replace(txtCntPerson.text,"'","`")) & "', EMail='" & trim(replace(txtEMail.text,"'","`")) & "',"
            StrSql = StrSql + "Part_No_From='" & trim(replace(cmbPartFrom.selectedItem.text,"'","`")) & "',Part_No_To='" & trim(cmbPartTo.selectedItem.text) & "',"
            StrSql = StrSql + "Part_Desc = '" & trim(replace(lblPartDesc.text,"'","`")) & "',part_Spec='" & trim(lblPartSpec.text) & "',"
    
            StrSql = StrSql + "Ref_Model='"& trim(replace(lblRefModel.text,"'","`")) & "',"
    
            StrSql = StrSql + "manufacturer='"& trim(replace(txtMfg.text,"'","`")) & "',Mfg_Part_No='" & trim(lblMFGPartNo.text) & "',"
    
            if chkUrgent.checked = true then StrSql = StrSql + "Urgent='Y',"
            if chkUrgent.checked = false then StrSql = StrSql + "Urgent='N',"
    
            if chkNewPart.checked = true then StrSql = StrSql + "New_Part = 'Y',"
            if chkNewPart.checked = false then StrSql = StrSql + "New_Part = 'N',"
    
            if chkReSubmit.checked = true then StrSql = StrSql + "RE_SUBMIT = 'Y',"
            if chkReSubmit.checked = false then StrSql = StrSql + "RE_SUBMIT = 'N',"
    
            if chkAddSource.checked = true then StrSql = StrSql + "ADD_SOURCE = 'Y',"
            if chkAddSource.checked = false then StrSql = StrSql + "ADD_SOURCE = 'N',"
    
            if chkCostDown.checked = true then StrSql = StrSql + "COST_DOWN = 'Y',"
            if chkCostDown.checked = false then StrSql = StrSql + "COST_DOWN = 'N',"
    
            StrSql = StrSql + "Submit_Rem = '" & trim(replace(txtRemarks.text,"'","`")) & "',"
    
            StrSql = StrSql + "Sample_Qty=" & cint(txtSampleQty.text) & " Where SSER_No = '" & trim(lblSSERNo.text) & "'"
            ReqCOM.ExecuteNonQuery(StrSql)
         End sub
    
        Sub ProcLoadGridData()
            Dim StrSql as string = "Select * from SSER_ATTACHMENT where SSER_NO = '" & trim(lblSSERNo.text) & "';"
            Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SSER_ATTACHMENT")
            dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("SSER_ATTACHMENT").DefaultView
            dtgUPASAttachment.DataBind()
        end sub
    
        Sub lnkAttachment_Click(sender As Object, e As EventArgs)
            'ShowPopup("popupSSERAtt.aspx?ID=" & Request.params("ID"))
            response.redirect("popupSSERAtt.aspx?ID=" & Request.params("ID"))
        End Sub
    
        Sub ShowPopup(ReturnURL as string)
            Dim Script As New System.Text.StringBuilder
            Script.Append("<script language=javascript>")
            Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
            Script.Append("</script" & ">")
            RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
        End sub
    
        Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
        End Sub
    
        Sub cmdSubmit_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then
                SaveDetails()
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim ReqDate as date = DateTime.now
                Dim i as integer
                Dim ReqDays as integer
                if chkUrgent.checked = true then ReqDays = 2
                if chkUrgent.checked = false then ReqDays = 5
    
                Dim MReceiver as string = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select U_ID from authority where app_type = 'ME ENG' and module_name = 'SSER')","Email")
                Dim MSender as string = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblSubmitBy.text) & "';","Email")
    
                for i = 1 to ReqDays
                    ReqDate = ReqDate.AddDays(1)
                    if cint(ReqDate.DayOfWeek) = 6 then ReqDate = ReqDate.AddDays(1)
                    if cint(ReqDate.DayOfWeek) = 0 then ReqDate = ReqDate.AddDays(1)
                next i
    
                ReqCOM.ExecuteNonQuery("Update SSER_M set submit_by = '" & trim(request.cookies("U_ID").value) & "',Req_Date = '" & ReqDate & "',sser_stat='PENDING APPROVAL',SUBMIT_Date = '" & now & "' where SSER_No = '" & trim(lblSSERNo.text) & "';")
                GenerateMail(MSender,MReceiver,trim(lblSSERNo.text))
                ShowAlert("Selected Document has been submitted successfully.")
                redirectPage("SSERDet.aspx?ID=" & Request.params("ID"))
            end if
         End Sub
    
         Sub GenerateMail(Sender as string, Receiver as string,DOcNo as string)
            Dim objEmail as New MailMessage()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrMsg as string
            Dim TotalQty as decimal
            Dim TotalAmt as Decimal
            Dim POTotal as Decimal
            Dim ObjAttachment as MailAttachment
    
            StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
            StrMsg = StrMsg + "There is a New Part Approval pending for your approval." & vblf & vblf & vblf
            StrMsg = StrMsg + "Part Approval Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
            StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=SSERMEEngDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from SSER_M where SSER_No = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
            StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            StrMsg = StrMsg + "Regards," & vblf & vblf
            StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
            objEmail.To       = trim(Receiver)
            objEmail.From     = trim(Sender)
            objEmail.Subject  = "Approval Sheet No : " & DOcNo
            objEmail.Body     = StrMsg
            objEmail.Priority = MailPriority.High
    
            SmtpMail.SmtpServer  = "192.168.42.111"
            SmtpMail.Send(objEmail)
         End sub
    
        Sub ShowAlert(Msg as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        End sub
    
        Sub cmdSearchSupplier_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
            cmbVenCodeC.items.clear
            Dissql ("Select VEN.Ven_Code as [Ven_Code],VEN.Ven_Name as [Desc] from Vendor VEN where VEN.Ven_Code + ven.Ven_Name like '%" & trim(replace(txtSearchSupplier.text,"'","`")) & "%' order by Ven.Ven_Code asc","Ven_Code","DESC",cmbVenCodeC)
            txtSearchSupplier.text = "-- Search --"
            if cmbVenCodeC.selectedindex = -1 then showAlert("Invalid Supplier.")
            if cmbVenCodeC.selectedindex <> -1 then GetSupplierDet
        End Sub
    
        Sub cmdPrintTraveller_Click(sender As Object, e As EventArgs)
            Dim Script As New System.Text.StringBuilder
            Script.Append("<script language=javascript>")
            Script.Append("pupUp=window.open('PopUpReportViewer.aspx?RptName=SSET&&SSERNo=" & trim(lblSSERNo.text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=700,height=250');")
            Script.Append("</script" & ">")
            RegisterStartupScript("NewPopUp", Script.ToString())
        End Sub
    
        Sub cmbPartFrom_SelectedIndexChanged(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim rsPart as SQLDataReader
    
            rsPart  = ReqCOM.ExeDataReader("Select * from Part_Master where Part_No = '" & trim(cmbPartFrom.selectedItem.value) & "';")
            Do while rsPart.read
                lblPartSpec.text = rsPart("Part_Spec").tostring
                lblPartDesc.text = rsPart("Part_Desc").tostring
                lblMfgPartNo.text = rsPart("M_Part_No").tostring
                lblMfg.text = rsPart("MFG").tostring
                txtMfg.text = rsPart("MFG").tostring
    
                if trim(lblMfg.text) = "" then
                txtMfg.visible = true
                lblMfg.visible = false
                else
                txtMfg.visible = false
                lblMfg.visible = true
                end if
            loop
        End Sub
    
        Sub redirectPage(ReturnURL as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
            If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
        End sub
    
        Sub cmdUpdate_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                SaveDetails()
                ShowAlert("Records Updated.")
                redirectPage("SSERDET.aspx?ID=" & Request.params("ID"))
            end if
        End Sub
    
    Sub cmdPrintSSER_Click(sender As Object, e As EventArgs)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open('PopUpReportViewer.aspx?RptName=SSER&SSERNo=" & trim(lblSSERNo.text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowSSER", Script.ToString())
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCom.executeNonQuery("Delete from SSER_M where Seq_No = " & cint(request.params("ID")) & ";")
        ReqCom.executeNonQuery("Delete from SSER_ATTACHMENT where sser_no = '" & trim(lblSSERNo.text) & "';")
        ShowAlert("Selected SSER has been removed from the system.")
        redirectPage("SSER.aspx")
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("SSER.aspx")
    End Sub
    
    
    
    Sub ValReason_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim i as integer = 0
        e.isvalid = true
    
        if chkNewPart.checked = false then i = i + 1
        if chkReSubmit.checked = false then i = i + 1
        if chkAddSource.checked = false then i = i + 1
        if chkCostDown.checked = false then i = i + 1
        if i = 4 then e.isvalid = false
    End Sub
    
    Sub cmdIgnoreResubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOm.ExecutenonQuery("Update SSER_M set REGENERATE = 'I' where sser_no = '" & trim(lblSSERNo.text) & "';")
        Response.redirect("SSERDet.aspx?ID=" & request.params("ID"))
    End Sub
    
    Sub cmdReSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        Dim NewSSERNo as string = ReqCOM.GetDocumentNo("SSER")
    
        StrSql = "Insert into SSER_M(URGENT,SSER_NO,SSER_DATE,VEN_CODE,CNT_PERSON,EMAIL,PART_NO_FROM,PART_NO_TO,PART_DESC,PART_SPEC,MANUFACTURER,MFG_PART_NO,SAMPLE_QTY,NEW_PART,RE_SUBMIT,ADD_SOURCE,COST_DOWN,SUBMIT_BY,MODEL_NO,SSER_STAT,OLD_SSER_NO,REGENERATE) "
        StrSql = StrSql + "select URGENT,'" & trim(NewSSERNo) & "','" & now & "',VEN_CODE,CNT_PERSON,EMAIL,PART_NO_FROM,PART_NO_TO,PART_DESC,PART_SPEC,MANUFACTURER,MFG_PART_NO,SAMPLE_QTY,NEW_PART,'Y',ADD_SOURCE,COST_DOWN,'" & trim(request.cookies("U_ID").value) & "',MODEL_NO,'PENDING SUBMISSION',SSER_NO,'N' from sser_m where sser_no = '" & trim(lblSSERNo.text) & "';"
        ReqCOM.ExecuteNonQuery(StrSql)
    
        StrSql = "Insert into SSER_Attachment(FILE_NAME,FILE_DESC,SSER_NO,FILE_SIZE) "
        StrSql = StrSql + "Select FILE_NAME,FILE_DESC,'" & trim(NewSSERNo) &  "',FILE_SIZE from sser_attachment where sser_no = '" & trim(lblSSERNo.text) & "';"
        ReqCOM.ExecuteNonQuery(StrSql)
    
        StrSql = "Update sser_m set regenerate = 'Y',New_SSER_No = '" & trim(NewSSERNo) & "' where sser_no = '" & trim(lblSSERNo.text) & "';"
        ReqCOM.ExecuteNonQuery(StrSql)
    
        StrSql = "Update sser_m set sser_m.part_desc = part_master.part_desc,sser_m.part_spec = part_master.part_spec from sser_m,part_master where sser_m.sser_no = '" & trim(lblSSERNo.text) & "' and sser_m.part_no_from = part_master.part_no"
        ReqCOM.ExecuteNonQuery(StrSql)
    
        ReqCOM.ExecuteNonQuery("Update Main set SSER = SSER + 1")
    
        Response.redirect("SSERDet.aspx?ID=" & ReqCOM.GetFieldVal("select seq_no from sser_m where sser_no = '" & trim(NewSSERNo) & "';","Seq_No"))
    End Sub
    
    Sub PartNo_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        e.isvalid = true
        if cmbpartFrom.visible = true then
            if cmbPartFrom.selecteditem.value = cmbPartTo.selecteditem.value then
                if Reqcom.FuncCheckDuplicate("Select Part_No from Part_Master where Part_No = '" & trim(cmbPartFrom.selecteditem.value) & "';","Part_No") = false then
                    e.isvalid = false:Exit sub
                end if
            end if
        End if
    End Sub
    
    Sub cmdViewWUL_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if cmbPartFrom.visible = true then ReqCOM.ProcessWhereUseList(cmbPartFrom.selecteditem.value,cmbPartTo.selecteditem.text)
        if lblPartFrom.visible = true then ReqCOM.ProcessWhereUseList(lblPartFrom.text,lblPartTo.text)
        ShowReport("PopupReportViewer.aspx?RptName=WhereUseList&PartNoFrom=" & trim(lblPartFrom.text) & "&PartNoTo=" & trim(lblPartTo.text))
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        '<asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadSSERAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
    
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("DownloadSSERAttachment.aspx?ID=" & clng(SeqNo.text))
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQUery("Delete from SSER_ATTACHMENT where seq_no = " & clng(SeqNo.text) & ";") : response.redirect("SSERDet.aspx?ID=" & clng(request.params("ID")))
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" width="100%" cssclass="fORMdESC">SAMPLE SUBMISSION
                            & EVALUATION REPORT (SSER)</asp:Label>
                            <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Supplier" ForeColor=" " Display="Dynamic" ControlToValidate="cmbVenCodeC"></asp:RequiredFieldValidator>
                            <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Part No From" ForeColor=" " Display="Dynamic" ControlToValidate="cmbPartFrom"></asp:RequiredFieldValidator>
                            <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Part No To" ForeColor=" " Display="Dynamic" ControlToValidate="cmbPartTo"></asp:RequiredFieldValidator>
                            <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Sample Qty." ForeColor=" " Display="Dynamic" ControlToValidate="txtSampleQty"></asp:RequiredFieldValidator>
                            <asp:CompareValidator id="CompareValidator1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Sample Qty." ForeColor=" " Display="Dynamic" ControlToValidate="txtSampleQty" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                            <asp:CompareValidator id="CompareValidator3" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Sample Qty." ForeColor=" " Display="Dynamic" ControlToValidate="txtSampleQty" Operator="GreaterThan" Type="Integer" ValueToCompare="-1"></asp:CompareValidator>
                            <asp:CustomValidator id="ValReason" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" OnServerValidate="ValReason_ServerValidate">You don't seem to have supplied a valid Reason of submission.</asp:CustomValidator>
                            <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Manufacturer." ForeColor=" " Display="Dynamic" ControlToValidate="txtMfg"></asp:RequiredFieldValidator>
                            <asp:CustomValidator id="PartNo" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Part No." ForeColor=" " Display="Dynamic" OnServerValidate="PartNo_ServerValidate" EnableClientScript="False"></asp:CustomValidator>
                            <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Remarks" ForeColor=" " Display="Dynamic" ControlToValidate="txtRemarks"></asp:RequiredFieldValidator>
                        </p>
                        <p>
                            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td width="12.5%">
                                            <asp:Button id="cmdPrintTraveller1" onclick="cmdPrintTraveller_Click" runat="server" CssClass="OutputText" Width="100%" Text="Print Traveller" CausesValidation="False"></asp:Button>
                                        </td>
                                        <td width="12.5%">
                                            <div align="center">
                                                <asp:Button id="cmdUpdate1" onclick="cmdUpdate_Click" runat="server" CssClass="OutputText" Width="100%" Text="Update SSER"></asp:Button>
                                            </div>
                                        </td>
                                        <td width="12.5%">
                                            <div align="center">
                                                <asp:Button id="cmdPrintSSER" onclick="cmdPrintSSER_Click" runat="server" CssClass="OutputText" Width="100%" Text="Print SSER" CausesValidation="False"></asp:Button>
                                            </div>
                                        </td>
                                        <td width="12.5%">
                                            <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" CssClass="OutputText" Width="100%" Text="Remove SSER" CausesValidation="False"></asp:Button>
                                        </td>
                                        <td width="12.5%">
                                            <asp:Button id="cmdReSubmit" onclick="cmdReSubmit_Click" runat="server" CssClass="OutputText" Width="100%" Text="Re-Submit" CausesValidation="False"></asp:Button>
                                        </td>
                                        <td width="12.5%">
                                            <asp:Button id="cmdIgnoreResubmit" onclick="cmdIgnoreResubmit_Click" runat="server" CssClass="OutputText" Width="100%" Text="Ignore Re-submit" CausesValidation="False"></asp:Button>
                                        </td>
                                        <td width="12.5%">
                                            <div align="center">
                                                <asp:Button id="cmdSubmit1" onclick="cmdSubmit_Click" runat="server" CssClass="OutputText" Width="100%" Text="Submit"></asp:Button>
                                            </div>
                                        </td>
                                        <td width="12.5%">
                                            <div align="right">
                                                <asp:Button id="Button1" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="100%" Text="Back" CausesValidation="False"></asp:Button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 11px" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td>
                                            <p>
                                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <p>
                                                                    <asp:LinkButton id="lnkAttachment" onclick="lnkAttachment_Click" runat="server" CssClass="OutputText" Width="100%" CausesValidation="False">Click here to add / edit
attachment.</asp:LinkButton>
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" OnItemCommand="ItemCommand" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged" PageSize="50" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" AutoGenerateColumns="False" cellpadding="4" BorderColor="Black">
                                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                                    <Columns>
                                                        <asp:TemplateColumn Visible="False">
                                                            <ItemTemplate>
                                                                <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                                        <asp:TemplateColumn HeaderText="Action">
                                                            <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                            <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            <ItemTemplate>
                                                                <asp:ImageButton id="ImgView" ToolTip="View this item" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                                                <asp:ImageButton id="ImgDelete" ToolTip="Delete this item" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server"></asp:ImageButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </p>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <p align="center">
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td colspan="4">
                                            <p>
                                                <table style="HEIGHT: 15px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="50%">
                                                                <p>
                                                                    <asp:CheckBox id="chkUrgent" runat="server" CssClass="OutputText" Text="URGENT"></asp:CheckBox>
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdViewWUL" onclick="cmdViewWUL_Click" runat="server" CssClass="OutputText" Text="Where Use List" CausesValidation="False"></asp:Button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <span><label><asp:Label id="Label2" runat="server" cssclass="LabelNormal">Supplier</asp:Label></label></span></td>
                                        <td>
                                            <asp:TextBox id="txtSearchSupplier" onkeydown="KeyDownHandler(cmdSearchSupplier)" onclick="GetFocus(txtSearchSupplier)" runat="server" CssClass="OutputText" Width="75px">-- Search --</asp:TextBox>
                                            <asp:Button id="cmdSearchSupplier" onclick="cmdSearchSupplier_Click" runat="server" CssClass="OutputText" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                            <asp:DropDownList id="cmbVenCodeC" runat="server" CssClass="OutputText" Width="232px" OnSelectedIndexChanged="cmbVenCodeC_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                            <asp:Label id="lblVenCode" runat="server" width="100%" cssclass="OutputText" visible="False"></asp:Label></td>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label9" runat="server">SSER No</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblSSERNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td width="12%" bgcolor="silver">
                                            <span><label><span><label><asp:Label id="Label3" runat="server" cssclass="LabelNormal">Contact</asp:Label></label></span></label></span></td>
                                        <td width="48%">
                                            <asp:TextBox id="txtCntPerson" onclick="GetFocus(txtCntPerson)" runat="server" CssClass="OutputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            <asp:Label id="lblCntPerson" runat="server" width="100%" cssclass="OutputText" visible="False"></asp:Label></td>
                                        <td width="15%" bgcolor="silver">
                                            <asp:Label id="Label11" runat="server">SSER Date</asp:Label></td>
                                        <td width="25%">
                                            <asp:Label id="lblSSERDate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <span><label><asp:Label id="Label4" runat="server" cssclass="LabelNormal">Email</asp:Label></label></span></td>
                                        <td>
                                            <asp:TextBox id="txtEMail" onclick="GetFocus(txtEMail)" runat="server" CssClass="OutputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            <asp:Label id="lblEMail" runat="server" width="100%" cssclass="OutputText" visible="False"></asp:Label></td>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Required Date</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblReqDate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label23" runat="server" cssclass="LabelNormal">Part No From</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtPartFrom" onkeydown="KeyDownHandler(cmdpartFrom)" onclick="GetFocus(txtPartFrom)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                            <asp:Button id="cmdpartFrom" onclick="cmdpartFrom_Click" runat="server" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                            <asp:DropDownList id="cmbPartFrom" runat="server" CssClass="OutputText" Width="232px" OnSelectedIndexChanged="cmbPartFrom_SelectedIndexChanged" autopostback="true"></asp:DropDownList>
                                            <asp:Label id="lblPartFrom" runat="server" width="100%" cssclass="OutputText" visible="False"></asp:Label></td>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Sample Qty</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtSampleQty" onclick="GetFocus(txtSampleQty)" runat="server" CssClass="OutputText"></asp:TextBox>
                                            <asp:Label id="lblSampleQty" runat="server" width="100%" cssclass="OutputText" visible="False"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Part No To</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtPartTo" onkeydown="KeyDownHandler(cmdPartTo)" onclick="GetFocus(txtPartTo)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                            <asp:Button id="cmdPartTo" onclick="cmdPartTo_Click" runat="server" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                            <asp:DropDownList id="cmbPartTo" runat="server" CssClass="OutputText" Width="232px"></asp:DropDownList>
                                            <asp:Label id="lblPartTo" runat="server" width="100%" cssclass="OutputText" visible="False"></asp:Label></td>
                                        <td bgcolor="silver" rowspan="4">
                                            <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Reason</asp:Label></td>
                                        <td>
                                            <asp:CheckBox id="chkNewPart" runat="server" Text="New Part"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblPartDesc" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        <td>
                                            <asp:CheckBox id="chkReSubmit" runat="server" Text="Re-Submit"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Specification</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblPartSpec" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        <td>
                                            <asp:CheckBox id="chkAddSource" runat="server" Text="Add Source"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Manufacturer</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtMfg" onclick="GetFocus(txtMfg)" runat="server" CssClass="OutputText" Width="100%" MaxLength="50"></asp:TextBox>
                                            <asp:Label id="lblMfg" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        <td>
                                            <asp:CheckBox id="chkCostDown" runat="server" Text="Cost Down"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label19" runat="server" cssclass="LabelNormal">Mgf. part No</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblMFGPartNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label17" runat="server" cssclass="LabelNormal">Iss/Sub By</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label59" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                        <td colspan="3">
                                            <asp:TextBox id="txtRemarks" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label60" runat="server" cssclass="LabelNormal">Ref. Model</asp:Label></td>
                                        <td colspan="3">
                                            <asp:Label id="lblRefModel" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <p>
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td colspan="5">
                                            <asp:Label id="Label57" runat="server" cssclass="OutputText">Part II : Manufacturing
                                            Engineering / R&D Test (To be completed by ME / R&D, tick where applicable)</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td width="25%" bgcolor="silver">
                                            <asp:Label id="Label16" runat="server" cssclass="LabelNormal">Test Analysis</asp:Label></td>
                                        <td width="5%" bgcolor="silver">
                                            <asp:Label id="Label20" runat="server" cssclass="LabelNormal">ACC</asp:Label></td>
                                        <td width="5%" bgcolor="silver">
                                            <asp:Label id="Label21" runat="server" cssclass="LabelNormal">REJ</asp:Label></td>
                                        <td width="5%" bgcolor="silver">
                                            <asp:Label id="Label22" runat="server" cssclass="LabelNormal">N/A</asp:Label></td>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label24" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="rdDM1" runat="server" cssclass="LabelNormal">1. Dimension Measurement</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbDM1" runat="server" Enabled="False" GroupName="DimMea"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbDM2" runat="server" Enabled="False" GroupName="DimMea"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbDM3" runat="server" Enabled="False" GroupName="DimMea"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtDimMea" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label26" runat="server" cssclass="LabelNormal">2. Initial Measurement</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbIM1" runat="server" Enabled="False" GroupName="IniMea"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbIM2" runat="server" Enabled="False" GroupName="IniMea"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbIM3" runat="server" Enabled="False" GroupName="IniMea"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtIniMea" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label27" runat="server" cssclass="LabelNormal">3. Environment Test</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbET1" runat="server" Enabled="False" GroupName="EnvTest"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbET2" runat="server" Enabled="False" GroupName="EnvTest"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbET3" runat="server" Enabled="False" GroupName="EnvTest"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtEnvTest" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label28" runat="server" cssclass="LabelNormal">4. Mechanical Test</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbMT1" runat="server" Enabled="False" GroupName="MechTest"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbMT2" runat="server" Enabled="False" GroupName="MechTest"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbMT3" runat="server" Enabled="False" GroupName="MechTest"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtMechTest" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label29" runat="server" cssclass="LabelNormal">5. Endurance Test</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbEndT1" runat="server" Enabled="False" GroupName="EndTest"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbEndT2" runat="server" Enabled="False" GroupName="EndTest"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbEndT3" runat="server" Enabled="False" GroupName="EndTest"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtEndTest" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label30" runat="server" cssclass="LabelNormal">6. Safety Check</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbSC1" runat="server" Enabled="False" GroupName="SafetyCheck"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbSC2" runat="server" Enabled="False" GroupName="SafetyCheck"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbSC3" runat="server" Enabled="False" GroupName="SafetyCheck"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtSafetyCheck" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label31" runat="server" cssclass="LabelNormal">7. Material Analysis</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbMA1" runat="server" Enabled="False" GroupName="MatAnaly"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbMA2" runat="server" Enabled="False" GroupName="MatAnaly"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbMA3" runat="server" Enabled="False" GroupName="MatAnaly"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtMatAnaly" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label32" runat="server" cssclass="LabelNormal">8. Functional Aspect</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbFA1" runat="server" Enabled="False" GroupName="FuncAspect"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbFA2" runat="server" Enabled="False" GroupName="FuncAspect"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbFA3" runat="server" Enabled="False" GroupName="FuncAspect"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtFuncAspect" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver" colspan="5">
                                            <asp:Label id="Label33" runat="server" cssclass="LabelNormal">9. Product Safety</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label37" runat="server" cssclass="LabelNormal">a). Regulatory Compliance</asp:Label></td>
                                        <td colspan="4">
                                            <p>
                                                <table style="HEIGHT: 20px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:CheckBox id="chkUL" runat="server" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                <asp:Label id="Label10" runat="server" cssclass="OutputText">UL</asp:Label></td>
                                                            <td>
                                                                <asp:CheckBox id="chkETL" runat="server" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                <asp:Label id="Label15" runat="server" cssclass="OutputText">ETL/FCC</asp:Label></td>
                                                            <td>
                                                                <asp:CheckBox id="chkCSA" runat="server" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                <asp:Label id="Label25" runat="server" cssclass="OutputText">CSA</asp:Label></td>
                                                            <td>
                                                                <asp:CheckBox id="chkCE" runat="server" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                <asp:Label id="Label36" runat="server" cssclass="OutputText">CE</asp:Label></td>
                                                            <td>
                                                                <asp:CheckBox id="chkPendingFileApproval" runat="server" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                <asp:Label id="Label40" runat="server" cssclass="OutputText">Pending File Approval</asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="5">
                                                                <p>
                                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="30%">
                                                                                    <asp:CheckBox id="chkMEOthers" runat="server" CssClass="OutputText" Width="100%" Text="Others, please specify" Enabled="False"></asp:CheckBox>
                                                                                </td>
                                                                                <td width="70%">
                                                                                    <asp:TextBox id="txtMEOthers" runat="server" CssClass="OutputText" Width="100%" Enabled="False"></asp:TextBox>
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
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label38" runat="server" cssclass="LabelNormal">b). Applicant</asp:Label></td>
                                        <td colspan="4">
                                            <asp:Label id="txtMEApplicant" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label39" runat="server" cssclass="LabelNormal">c). File Number</asp:Label></td>
                                        <td colspan="4">
                                            <asp:Label id="txtMEFileNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <p>
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td bgcolor="silver" colspan="3">
                                            <asp:Label id="Label34" runat="server" cssclass="LabelNormal">Engineer</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td width="20%">
                                            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblMEEngBy" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblMEEngDate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td width="47%">
                                            <asp:Label id="txtMEEngRem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        <td width="33%">
                                            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:RadioButton id="rbMEEngAcc" runat="server" CssClass="OutputText" Text="Accepted" Enabled="False" GroupName="rbMEEng"></asp:RadioButton>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:RadioButton id="rbMEEngRej" runat="server" CssClass="OutputText" Text="Rejected" Enabled="False" GroupName="rbMEEng"></asp:RadioButton>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="OutputText" colspan="2">
                                                            <asp:RadioButton id="rbMEEngCon" runat="server" CssClass="OutputText" Text="Conditional approve " Enabled="False" GroupName="rbMEEng"></asp:RadioButton>
                                                            &nbsp;<asp:TextBox id="TextBox14" runat="server" CssClass="OutputText" Width="47px" Enabled="False"></asp:TextBox>
                                                            &nbsp;pcs</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver" colspan="3">
                                            <asp:Label id="Label35" runat="server" cssclass="LabelNormal">HOD</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblMEHODBy" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblMEHODDate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td>
                                            <asp:Label id="txtMEHODRem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        <td>
                                            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:RadioButton id="rbMEHODAcc" runat="server" CssClass="OutputText" Text="Accepted" Enabled="False" GroupName="rbMEHOD"></asp:RadioButton>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:RadioButton id="rbMEHODRej" runat="server" CssClass="OutputText" Text="Rejected" Enabled="False" GroupName="rbMEHOD"></asp:RadioButton>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <p>
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td colspan="5">
                                            <asp:Label id="Label58" runat="server" cssclass="OutputText">Part III : Quality Assurance
                                            Test (To be completed by QA, tick where applicable)</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td width="30%" bgcolor="silver">
                                            <asp:Label id="Label41" runat="server" cssclass="LabelNormal">Test Analysis</asp:Label></td>
                                        <td width="5%" bgcolor="silver">
                                            <asp:Label id="Label42" runat="server" cssclass="LabelNormal">ACC</asp:Label></td>
                                        <td width="5%" bgcolor="silver">
                                            <asp:Label id="Label43" runat="server" cssclass="LabelNormal">REJ</asp:Label></td>
                                        <td width="5%" bgcolor="silver">
                                            <asp:Label id="Label44" runat="server" cssclass="LabelNormal">N/A</asp:Label></td>
                                        <td width="55%" bgcolor="silver">
                                            <asp:Label id="Label45" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label46" runat="server" cssclass="LabelNormal">1). Color</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbCol1" runat="server" Enabled="False" GroupName="Color"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbCol2" runat="server" Enabled="False" GroupName="Color"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbCol3" runat="server" Enabled="False" GroupName="Color"></asp:RadioButton>
                                        </td>
                                        <td width="100%">
                                            <asp:Label id="txtQAcolor" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label47" runat="server" cssclass="LabelNormal">2). Cosmetic Appearance</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbCosApp1" runat="server" Enabled="False" GroupName="CosApp"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbCosApp2" runat="server" Enabled="False" GroupName="CosApp"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbCosApp3" runat="server" Enabled="False" GroupName="CosApp"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtQACosApp" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label48" runat="server" cssclass="LabelNormal">3). Packing</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbPack1" runat="server" Enabled="False" GroupName="Pack"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbPack2" runat="server" Enabled="False" GroupName="Pack"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbPack3" runat="server" Enabled="False" GroupName="Pack"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtQAPack" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label49" runat="server" cssclass="LabelNormal">4). </asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbQAothers1" runat="server" Enabled="False" GroupName="QAOthers"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbQAothers2" runat="server" Enabled="False" GroupName="QAOthers"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbQAothers3" runat="server" Enabled="False" GroupName="QAOthers"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:Label id="txtQAOthers" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <p>
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td bgcolor="silver" colspan="3">
                                            <asp:Label id="Label54" runat="server" cssclass="LabelNormal">Engineer</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td width="20%">
                                            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblQAEngBy" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblQAEngDate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td width="43%">
                                            <asp:Label id="txtQAEngRem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        <td width="33%">
                                            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:RadioButton id="rbQAEngApp" runat="server" CssClass="OutputText" Enabled="False" GroupName="QAEng"></asp:RadioButton>
                                                            <asp:Label id="Label50" runat="server" cssclass="OutputText">Accepted</asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:RadioButton id="rbQAEngRej" runat="server" CssClass="OutputText" Enabled="False" GroupName="QAEng"></asp:RadioButton>
                                                            <asp:Label id="Label51" runat="server" cssclass="OutputText">Rejected</asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver" colspan="3">
                                            <asp:Label id="Label56" runat="server" cssclass="LabelNormal">HOD</asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblQAHODBy" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblQAHODDate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td>
                                            <asp:Label id="txtQAHODRem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        <td>
                                            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:RadioButton id="rbQAHODApp" runat="server" CssClass="OutputText" Enabled="False" GroupName="QAHOD"></asp:RadioButton>
                                                            <asp:Label id="Label52" runat="server" cssclass="OutputText">Accepted</asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:RadioButton id="rbQAHODRej" runat="server" CssClass="OutputText" Enabled="False" GroupName="QAHOD"></asp:RadioButton>
                                                            <asp:Label id="Label53" runat="server" cssclass="OutputText">Rejected</asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <p>
                            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td width="12.5%">
                                            <asp:Button id="cmdPrintTraveller" onclick="cmdPrintTraveller_Click" runat="server" CssClass="OutputText" Width="100%" Text="Print Traveller" CausesValidation="False"></asp:Button>
                                        </td>
                                        <td width="12.5%">
                                            <div align="center">
                                                <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" CssClass="OutputText" Width="100%" Text="Update SSER"></asp:Button>
                                            </div>
                                        </td>
                                        <td width="12.5%">
                                            <div align="center">
                                                <asp:Button id="cmdPrintSSER1" onclick="cmdPrintSSER_Click" runat="server" CssClass="OutputText" Width="100%" Text="Print SSER" CausesValidation="False"></asp:Button>
                                            </div>
                                        </td>
                                        <td width="12.5%">
                                            <asp:Button id="cmdRemove1" onclick="cmdRemove_Click" runat="server" CssClass="OutputText" Width="100%" Text="Remove SSER" CausesValidation="False"></asp:Button>
                                        </td>
                                        <td width="12.5%">
                                            <asp:Button id="cmdReSubmit1" onclick="cmdReSubmit_Click" runat="server" CssClass="OutputText" Width="100%" Text="Re-Submit" CausesValidation="False"></asp:Button>
                                        </td>
                                        <td width="12.5%">
                                            <asp:Button id="cmdIgnoreResubmit1" onclick="cmdIgnoreResubmit_Click" runat="server" CssClass="OutputText" Width="100%" Text="Ignore Re-submit" CausesValidation="False"></asp:Button>
                                        </td>
                                        <td width="12.5%">
                                            <div align="center">
                                                <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" CssClass="OutputText" Width="100%" Text="Submit"></asp:Button>
                                            </div>
                                        </td>
                                        <td width="12.5%">
                                            <div align="right">
                                                <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="100%" Text="Back" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
