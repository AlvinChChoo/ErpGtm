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
        cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this Document ?')==false) return false;")
        cmdSubmit1.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this Document ?')==false) return false;")
    
        if page.ispostback = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim rsSSER as SQLDataReader = ReqCOM.ExeDataReader("Select * from SSER_M where Seq_No = " & Request.params("ID") & "")
            Dim oList As ListItemCollection
    
            do while rsSSER.read
                lblSSERNo.text = rsSSER("SSER_No").tostring
                lblSSERDate.text = format(rsSSER("SSER_Date"),"dd/MMM/yy")
                lblSubmitBy.text = rsSSER("Submit_By").tostring
                if isdbnull(rsSSER("Submit_Date")) = false then lblSubmitDate.text = format(rsSSER("Submit_Date"),"dd/MMM/yy")
                lblPartFrom.text = rsSSER("part_no_from").tostring
                lblPartTo.text = rsSSER("part_no_to").tostring
                lblReqDate.text = format(cdate(rsSSER("Req_Date")),"dd/MMM/yy")
                lblSampleQty.text = rsSSER("Sample_Qty").tostring
                lblMFG.text = rsSSER("manufacturer").tostring
                lblMFGPartNo.text = rsSSER("Mfg_Part_No").tostring
                lblPartDesc.text = rsSSER("Part_Desc").tostring
                lblPartSpec.text = rsSSER("part_Spec").tostring
                lblCntPerson.text = rsSSER("CNT_Person").tostring
                lblEMail.text = rsSSER("EMail").tostring
    
                lblRefModel.text = rsSSER("Ref_Model").tostring
    
                lblVenCode.text = trim(rsSSER("Ven_Code").tostring)
                lblVenCode.text = trim(lblVenCode.text) & " (" & reqCom.getFieldVal("Select Ven_Name from Vendor where Ven_Code = '" & trim(lblVenCode.text) & "';","Ven_Name") & ")"
                lblRem.text = rsSSER("Submit_Rem").tostring
                txtAppQty.text = rsSSER("ME_ENG_QTY").tostring
                txtDimMea.text = rsSSER("ME_DIA_MEA_REM").tostring
                txtIniMea.text = rsSSER("ME_INIT_MEA_REM").tostring
                txtEnvTest.text = rsSSER("ME_ENV_TEST_REM").tostring
                txtMechTest.text = rsSSER("ME_MECH_TEST_REM").tostring
                txtEndTest.text = rsSSER("ME_END_TEST_REM").tostring
                txtMatAnaly.text = rsSSER("ME_MAT_ANALY_REM").tostring
                txtSafetyCheck.text = rsSSER("ME_SAFE_CHECK_REM").tostring
                txtSafetyCheck.text = rsSSER("ME_SAFE_CHECK_REM").tostring
                txtFuncAspect.text = rsSSER("ME_FUNC_ASPECT_REM").tostring
                txtMEOthers.text = rsSSER("ME_OTHERS").tostring
                txtMEApplicant.text = rsSSER("ME_APPLICANT").tostring
                txtMEFileNo.text = rsSSER("ME_FILE_NO").tostring
                txtQAColor.text = rsSSER("QA_color_rem").tostring
                txtQACosApp.text = rsSSER("QA_Cos_App_rem").tostring
                txtQAPack.text = rsSSER("QA_Pack_rem").tostring
                txtQAEngRem.text = rsSSER("QA_Eng_Rem").tostring
                lblQAEngBy.text = rsSSER("QA_Eng_By").tostring
                if isdbnull(rsSSER("QA_Eng_Date")) = false then lblQAEngDate.text = format(cdate(rsSSER("QA_Eng_Date")),"dd/MMM/yy")
                lblMEEngBy.text = rsSSER("ME_ENG_BY").tostring
                txtMEEngRem.text = rsSSER("ME_ENG_Rem").tostring
                txtMEHODRem.text = rsSSER("ME_HOD_Rem").tostring
                lblMEHODBy.text = rsSSER("ME_HOD_BY").tostring
    
                if isdbnull(rsSSER("ME_HOD_Date")) = false then lblMEHODDate.text = format(cdate(rsSSER("ME_HOD_Date")),"dd/MMM/yy")
    
                if rsSSER("ME_HOD_Stat").tostring = "Y" then
                    rbMEHodAcc.checked = true
                elseif rsSSER("ME_HOD_Stat").tostring = "N" then
                    rbMEHodRej.checked = true
                Else
                    rbMEHodAcc.checked = true
                End if
    
                if isdbnull(rsSSER("ME_ENG_DATE")) = false then lblMEEngDate.text = format(cdate(rsSSER("ME_ENG_DATE")),"dd/MMM/yy")
                if rsSSER("UL").tostring = "Y" then chkUL.Checked = true else chkUL.Checked = false
                if rsSSER("ETL").tostring = "Y" then chkETL.Checked = true else chkETL.Checked = false
                if rsSSER("CSA").tostring = "Y" then chkCSA.Checked = true else chkCSA.Checked = false
                if rsSSER("CE").tostring = "Y" then chkCE.Checked = true else chkCE.Checked = false
                if rsSSER("PEN_FILE_APP").tostring = "Y" then chkPendingFileApproval.Checked = true else chkPendingFileApproval.Checked = false
                if rsSSER("ME_Others").tostring = "Y" then chkMeOthers.Checked = true else chkMeOthers.Checked = false
                if isdbnull(rsSSER("QA_HOD_By")) = false then lblQAHODBy.text = rsSSER("QA_HOD_By").tostring
                if isdbnull(rsSSER("QA_HOD_Date")) = false then lblQAHODDate.text = format(cdate(rsSSER("QA_HOD_Date")),"dd/MMM/yy")
                if isdbnull(rsSSER("QA_HOD_Rem")) = false then txtQAHODRem.text = rsSSER("QA_HOD_Rem")
    
                if isdbnull(rsSSER("URGent")) = false then
                    if rsSSER("URGent") = "Y" then chkUrgent.checked = true else chkUrgent.checked = false
                end if
        if TRIM(rsSSER("NEW_PART").TOSTRING) = "N" then chkNewPart.checked = false
        if TRIM(rsSSER("NEW_PART").TOSTRING) = "Y" then chkNewPart.checked = true
    
        if TRIM(rsSSER("RE_SUBMIT").TOSTRING) = "N" then chkReSubmit.checked = false
        if TRIM(rsSSER("RE_SUBMIT").TOSTRING) = "Y" then chkReSubmit.checked = true
    
        if TRIM(rsSSER("ADD_SOURCE").TOSTRING) = "N" then chkAddSource.checked = false
        if TRIM(rsSSER("ADD_SOURCE").TOSTRING) = "Y" then chkAddSource.checked = true
    
        if TRIM(rsSSER("COST_DOWN").TOSTRING) = "N" then chkCostDown.checked = false
        if TRIM(rsSSER("COST_DOWN").TOSTRING) = "Y" then chkCostDown.checked = true
    
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
    
                if isdbnull(rsSSER("ME_ENG_Stat")) = false then
                    if rsSSER("ME_ENG_Stat") = 1 then rbMEEngAcc.checked = true
                    if rsSSER("ME_ENG_Stat") = 2 then rbMEEngRej.checked = true
                    if rsSSER("ME_ENG_Stat") = 3 then rbMEEngCon.checked = true
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
            loop
    
            if trim(lblQAEngBy.text) = "" then
                rbCol1.enabled = true
                rbCol2.enabled = true
                rbCol3.enabled =  true
                txtQAcolor.enabled =  true
    
                rbCosApp1.enabled =  true
                rbCosApp2.enabled =  true
                rbCosApp3.enabled =  true
                txtQACosApp.enabled =  true
    
                rbPack1.enabled =  true
                rbPack2.enabled =  true
                rbPack3.enabled =  true
                txtQAPack.enabled =  true
    
                rbQAothers1.enabled =  true
                rbQAothers2.enabled =  true
                rbQAothers3.enabled =  true
                txtQAOthers.enabled =  true
    
                txtQAEngRem.enabled =  true
    
                rbQAEngApp.enabled =  true
                rbQAEngRej.enabled =  true
    
                cmdUpdate.enabled =  true
                cmdUpdate1.enabled =  true
    
                cmdSubmit.enabled =  true
                cmdSubmit1.enabled =  true
            Else
                rbCol1.enabled = false
                rbCol2.enabled = false
                rbCol3.enabled = false
                txtQAcolor.enabled = false
    
                rbCosApp1.enabled = false
                rbCosApp2.enabled = false
                rbCosApp3.enabled = false
                txtQACosApp.enabled = false
    
                rbPack1.enabled = false
                rbPack2.enabled = false
                rbPack3.enabled = false
                txtQAPack.enabled = false
    
                rbQAothers1.enabled = false
                rbQAothers2.enabled = false
                rbQAothers3.enabled = false
                txtQAOthers.enabled = false
    
                txtQAEngRem.enabled = false
    
                rbQAEngApp.enabled = false
                rbQAEngRej.enabled = false
    
                cmdUpdate.enabled = false
                cmdUpdate1.enabled = false
    
                cmdSubmit.enabled = false
                cmdSubmit1.enabled = false
            end  if
    
    
            ProcLoadGridData
        end if
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            SaveDetails()
            ShowAlert("Records Updated.")
            redirectPage("SSERQAEngDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub SaveDetails()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim QAColor,QACosApp,QAPack as integer
        Dim StrSql,QAEngStat as string
    
        if rbcol1.checked = true then QAColor = 1
        if rbcol2.checked = true then QAColor = 2
        if rbcol3.checked = true then QAColor = 3
    
        if RBcOSaPP1.checked = true then QACosApp = 1
        if RBcOSaPP2.checked = true then QACosApp = 2
        if RBcOSaPP3.checked = true then QACosApp = 3
    
        if rbPack1.checked = true then QAPack = 1
        if rbPack2.checked = true then QAPack = 2
        if rbPack3.checked = true then QAPack = 3
    
        if rbQAEngApp.checked = true then QAEngStat = "Y"
        if rbQAEngRej.checked = true then QAEngStat = "N"
    
    
        Strsql = "Update SSER_M set QA_color_rem = '" & trim(replace(txtQAColor.text,"'","`")) & "',"
        Strsql = Strsql & "QA_Cos_App_rem = '" & trim(replace(txtQACosApp.text,"'","`")) & "',"
        Strsql = Strsql & "QA_Pack_rem = '" & trim(replace(txtQAPack.text,"'","`")) & "',"
    
        Strsql = Strsql & "QA_Eng_Rem = '" & trim(replace(txtQAEngRem.text,"'","`")) & "',"
    
        if rbQAEngApp.checked = true then Strsql = Strsql & "SSER_Stat = 'PENDING APPROVAL',"
        if rbQAEngRej.checked = true then Strsql = Strsql & "SSER_Stat = 'REJECTED',"
        Strsql = Strsql & "QA_Color_Stat = " & QAColor & ","
        Strsql = Strsql & "QA_COS_APP_stat = " & QACosApp & ","
        Strsql = Strsql & "QA_pack_stat = " & QAPack & ","
        Strsql = Strsql & "QA_Eng_Stat = '" & QAEngStat & "' where SSER_NO = '" & trim(lblSSERNo.text) & "';"
        ReqCOm.ExecuteNonQuery(StrSql)
    End sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from SSER_ATTACHMENT where SSER_NO = '" & trim(lblSSERNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SSER_ATTACHMENT")
        dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("SSER_ATTACHMENT").DefaultView
        dtgUPASAttachment.DataBind()
    end sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim MReceiver, MSender,cc as string
            SaveDetails()
            ReqCOM.ExecuteNonQuery("Update SSER_M set QA_Eng_Date = '" & now & "',QA_Eng_By = '" & trim(request.cookies("U_ID").value) & "' where SEQ_NO = " & request.params("ID") & ";")
    
            if (rbQAEngApp.checked = true) or (rbMeEngCon.checked = true) then
                MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select U_ID from authority where app_type = 'QA HOD' and module_name = 'SSER')","Email")
                MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
                GenerateMail(MSender,MReceiver,CC,trim(lblSSERNo.text),"Y")
            elseif rbQAEngRej.checked = true then
                MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select Submit_By from SSER_M where SSER_NO = '" & trim(lblSSERNo.text) & "')","Email")
                MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select qa_eng_by from SSER_M where SSER_NO = '" & trim(lblSSERNo.text) & "')","Email")
                CC = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select me_eng_by from SSER_M where SSER_NO = '" & trim(lblSSERNo.text) & "')","Email")
                CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select me_hod_by from SSER_M where SSER_NO = '" & trim(lblSSERNo.text) & "')","Email")
                GenerateMail(MSender,MReceiver,CC,trim(lblSSERNo.text),"N")
            End if
    
            Response.redirect("SSERQAEngDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub GenerateMail(Sender as string, Receiver as string,CC as string,DOcNo as string,SSERStat as string)
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrMsg as string
        Dim TotalQty as decimal
        Dim TotalAmt as Decimal
        Dim POTotal as Decimal
        Dim ObjAttachment as MailAttachment
    
        if SSERStat = "Y" then
            StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
            StrMsg = StrMsg + "There is a New Part Approval pending for your approval." & vblf & vblf & vblf
            StrMsg = StrMsg + "Part Approval Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
            StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=SSERQAHODDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from SSER_M where SSER_No = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
            StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            StrMsg = StrMsg + "Regards," & vblf & vblf
            StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
            objEmail.Subject  = "Approval Sheet No : " & DOcNo
        Elseif SSERStat = "N" then
            StrMsg = "Dear " &  ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
            StrMsg = StrMsg + "There is a part approval rejected by QA Engineer." & vblf & vblf & vblf
            StrMsg = StrMsg + "Part Approval Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
            StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            StrMsg = StrMsg + "Regards," & vblf & vblf
            StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
            objEmail.Subject  = "Part Approval Rejected : " & DOcNo
        end if
    
        objEmail.To       = trim(Receiver)
        objEmail.From     = trim(Sender)
        objEmail.cc     = trim(cc)
        objEmail.Body     = StrMsg
        objEmail.Priority = MailPriority.High
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("SSERQAEng.aspx")
    End Sub
    
    Sub cmdPrintSSER_Click(sender As Object, e As EventArgs)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open('PopUpReportViewer.aspx?RptName=SSER&SSERNo=" & trim(lblSSERNo.text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowSSER", Script.ToString())
    End Sub
    
    Sub ValRemForRejectedItem_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        e.isvalid = true
    
        if rbCol2.checked = true then
            if trim(txtQAColor.text) = "" then ValRemForRejectedItem.ErrorMessage = "You don't seem to have supplied a valid remarks for Color." : e.isvalid = false:Exit sub
        End if
    
        if rbCosApp2.checked = true then
            if trim(txtQACosApp.text) = "" then ValRemForRejectedItem.ErrorMessage = "You don't seem to have supplied a valid remarks for Cosmetic Appearance." : e.isvalid = false:Exit sub
        End if
    
        if rbPack2.checked = true then
            if trim(txtQAPack.text) = "" then ValRemForRejectedItem.ErrorMessage = "You don't seem to have supplied a valid remarks for Packing." : e.isvalid = false:Exit sub
        End if
    End Sub
    
    Sub ValNAVal_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim NACount as integer
        e.isvalid = true
    
        if rbCol1.checked = false then
            if rbCol2.checked = false then
                if rbCol3.checked = false then ValNAVal.ErrorMessage = "You don't seem to have supplied a valid status for Color." : e.isvalid = false:Exit sub
            end if
        End if
    
        if rbCosApp1.checked = false then
            if rbCosApp2.checked = false then
                if rbCosApp3.checked = false then ValNAVal.ErrorMessage = "You don't seem to have supplied a valid status for Cosmetic Appearance." : e.isvalid = false:Exit sub
            End if
        End if
    
        if rbPack1.checked = false then
            if rbPack2.checked = false then
                if rbPack3.checked = false then  ValNAVal.ErrorMessage = "You don't seem to have supplied a valid status for Packing." : e.isvalid = false:Exit sub
            End if
        End if
    
        NACount = 0
    
        if rbCol3.checked = true then NACount = NACount + 1
        if rbCosApp3.checked = true then NACount = NACount + 1
        if rbPack3.checked = true then NACount = NACount + 1
    
        if NACount = 3 then ValNAVal.ErrorMessage = "All the testing status cannot be N/A." : e.isvalid = false:Exit sub
    End Sub
    
    Sub cmdViewWUL_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ProcessWhereUseList(lblPartFrom.text,lblPartTo.text)
        ShowReport("PopupReportViewer.aspx?RptName=WhereUseList&PartNoFrom=" & trim(lblPartFrom.text) & "&PartNoTo=" & trim(lblPartTo.text))
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
                            <asp:Label id="Label1" runat="server" cssclass="fORMdESC" width="100%">SAMPLE SUBMISSION
                            & EVALUATION REPORT (SSER)</asp:Label>
                        </p>
                        <p>
                            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td width="25%">
                                            <asp:Button id="cmdUpdate1" onclick="cmdUpdate_Click" runat="server" Text="Update SSER"></asp:Button>
                                        </td>
                                        <td width="25%">
                                            <div align="center">
                                                <asp:Button id="cmdPrintSSER" onclick="cmdPrintSSER_Click" runat="server" Text="Print" CausesValidation="False" Width="88px"></asp:Button>
                                            </div>
                                        </td>
                                        <td>
                                            <asp:Button id="cmdViewWUL1" onclick="cmdViewWUL_Click" runat="server" Text="Where Use List" CausesValidation="False"></asp:Button>
                                        </td>
                                        <td width="25%">
                                            <div align="center">
                                                <asp:Button id="cmdSubmit1" onclick="cmdSubmit_Click" runat="server" Text="Submit" Width="98px"></asp:Button>
                                            </div>
                                        </td>
                                        <td width="25%">
                                            <div align="right">
                                                <asp:Button id="Button3" onclick="cmdBack_Click" runat="server" Text="Back" CausesValidation="False" Width="101px"></asp:Button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <div align="center">
                            <asp:CustomValidator id="ValRemForRejectedItem" runat="server" Width="100%" Display="Dynamic" ForeColor=" " EnableClientScript="False" OnServerValidate="ValRemForRejectedItem_ServerValidate" CssClass="ErrorText"></asp:CustomValidator>
                        </div>
                        <div align="center">
                            <asp:CustomValidator id="ValNAVal" runat="server" Width="100%" Display="Dynamic" ForeColor=" " EnableClientScript="False" OnServerValidate="ValNAVal_ServerValidate" CssClass="ErrorText"></asp:CustomValidator>
                        </div>
                        <div align="center">
                            <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Display="Dynamic" ForeColor=" " EnableClientScript="False" CssClass="ErrorText" ControlToValidate="txtQAEngRem" ErrorMessage="You don't seem to have supplied a valid Remarks."></asp:RequiredFieldValidator>
                        </div>
                        <p align="center">
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td>
                                            <p>
                                                <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False" HeaderStyle-CssClass="CartListHead" ItemStyle-CssClass="CartListItem" AlternatingItemStyle-CssClass="CartListItemAlt" PageSize="50" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged">
                                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                                    <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                    <Columns>
                                                        <asp:TemplateColumn visible="false">
                                                            <ItemTemplate>
                                                                <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                                        <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                                        <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadSSERAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
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
                                            <asp:CheckBox id="chkUrgent" runat="server" Text="URGENT" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label62" runat="server" cssclass="LabelNormal">Ref. Model</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblRefModel" runat="server" cssclass="OutputText"></asp:Label></td>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label61" runat="server">SSER No</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblSSERNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td width="12%" bgcolor="silver">
                                            <span><label><asp:Label id="Label58" runat="server" cssclass="LabelNormal">Supplier</asp:Label></label></span></td>
                                        <td width="48%">
                                            <asp:Label id="lblVenCode" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td width="15%" bgcolor="silver">
                                            <asp:Label id="Label11" runat="server">SSER Date</asp:Label></td>
                                        <td width="25%">
                                            <asp:Label id="lblSSERDate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <span><label><asp:Label id="Label9" runat="server" cssclass="LabelNormal">Contact</asp:Label></label></span></td>
                                        <td>
                                            <asp:Label id="lblCntPerson" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Required Date</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblReqDate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Email</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblEMail" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Sample Qty</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblSampleQty" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label23" runat="server" cssclass="LabelNormal">Part No From</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblPartFrom" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td bgcolor="silver" rowspan="4">
                                            <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Reason</asp:Label></td>
                                        <td>
                                            <asp:CheckBox id="chkNewPart" runat="server" Text="New Part" Enabled="False"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Part No To</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblPartTo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td>
                                            <asp:CheckBox id="chkReSubmit" runat="server" Text="Re-Submit" Enabled="False"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblPartDesc" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td>
                                            <asp:CheckBox id="chkAddSource" runat="server" Text="Add Source" Enabled="False"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Specification</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblPartSpec" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td>
                                            <asp:CheckBox id="chkCostDown" runat="server" Text="Cost Down" Enabled="False"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Manufacturer</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblMfg" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label17" runat="server" cssclass="LabelNormal">Iss/Sub By</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label19" runat="server" cssclass="LabelNormal">Mgf. part No</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblMFGPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label18" runat="server" cssclass="LabelNormal">Submitted Date</asp:Label></td>
                                        <td>
                                            <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                        <td colspan="3">
                                            <asp:Label id="lblRem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <p>
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td colspan="5">
                                            <asp:Label id="Label59" runat="server" cssclass="OutputText">Part II : Manufacturing
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
                                            <asp:Label id="txtDimMea" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                            <asp:Label id="txtIniMea" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                            <asp:Label id="txtEnvTest" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                            <asp:Label id="txtMechTest" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                            <asp:Label id="txtEndTest" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                            <asp:Label id="txtSafetyCheck" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                            <asp:Label id="txtMatAnaly" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                            <asp:Label id="txtFuncAspect" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                                                &nbsp;<asp:Label id="Label10" runat="server" cssclass="OutputText">UL</asp:Label></td>
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
                                                                                <td width="25%">
                                                                                    <asp:CheckBox id="chkMEOthers" runat="server" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:Label id="Label50" runat="server" cssclass="OutputText">Others, please specify</asp:Label></td>
                                                                                <td width="70%">
                                                                                    <asp:Label id="txtMEOthers" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                            <asp:Label id="txtMEApplicant" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label39" runat="server" cssclass="LabelNormal">c). File Number</asp:Label></td>
                                        <td colspan="4">
                                            <asp:Label id="txtMEFileNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                                            <asp:Label id="lblMEEngBy" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblMEEngDate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td width="47%">
                                            <asp:Label id="txtMEEngRem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td width="33%">
                                            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:RadioButton id="rbMEEngAcc" runat="server" CssClass="OutputText" Enabled="False" GroupName="rbMEEng"></asp:RadioButton>
                                                            &nbsp; <asp:Label id="Label51" runat="server" cssclass="OutputText">Accepted</asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:RadioButton id="rbMEEngRej" runat="server" CssClass="OutputText" Enabled="False" GroupName="rbMEEng"></asp:RadioButton>
                                                            &nbsp; <asp:Label id="Label52" runat="server" cssclass="OutputText">Rejected</asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td class="OutputText" colspan="2">
                                                            <asp:RadioButton id="rbMEEngCon" runat="server" CssClass="OutputText" Enabled="False" GroupName="rbMEEng"></asp:RadioButton>
                                                            &nbsp;<asp:Label id="Label53" runat="server" cssclass="OutputText">Conditional </asp:Label>&nbsp;<asp:TextBox id="txtAppQty" runat="server" Width="47px" CssClass="OutputText" Enabled="False"></asp:TextBox>
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
                                                            <asp:Label id="lblMEHODBy" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblMEHODDate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td>
                                            <asp:Label id="txtMEHODRem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td>
                                            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:RadioButton id="rbMEHODAcc" runat="server" CssClass="OutputText" Enabled="False" GroupName="rbMEHOD"></asp:RadioButton>
                                                            &nbsp; <asp:Label id="Label55" runat="server" cssclass="OutputText">Accepted</asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:RadioButton id="rbMEHODRej" runat="server" CssClass="OutputText" Enabled="False" GroupName="rbMEHOD"></asp:RadioButton>
                                                            &nbsp; <asp:Label id="Label57" runat="server" cssclass="OutputText">Rejected</asp:Label></td>
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
                                            <asp:Label id="Label60" runat="server" cssclass="OutputText">Part III : Quality Assurance
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
                                            <asp:RadioButton id="rbCol1" runat="server" GroupName="Color"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbCol2" runat="server" GroupName="Color"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbCol3" runat="server" GroupName="Color"></asp:RadioButton>
                                        </td>
                                        <td width="100%">
                                            <asp:TextBox id="txtQAcolor" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label47" runat="server" cssclass="LabelNormal">2). Cosmetic Appearance</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbCosApp1" runat="server" GroupName="CosApp"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbCosApp2" runat="server" GroupName="CosApp"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbCosApp3" runat="server" GroupName="CosApp"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:TextBox id="txtQACosApp" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label48" runat="server" cssclass="LabelNormal">3). Packing</asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbPack1" runat="server" GroupName="Pack"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbPack2" runat="server" GroupName="Pack"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbPack3" runat="server" GroupName="Pack"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:TextBox id="txtQAPack" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label49" runat="server" cssclass="LabelNormal">4). </asp:Label></td>
                                        <td>
                                            <asp:RadioButton id="rbQAothers1" runat="server" GroupName="QAOthers"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbQAothers2" runat="server" GroupName="QAOthers"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:RadioButton id="rbQAothers3" runat="server" GroupName="QAOthers"></asp:RadioButton>
                                        </td>
                                        <td>
                                            <asp:TextBox id="txtQAOthers" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                        </td>
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
                                                            <asp:Label id="lblQAEngBy" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblQAEngDate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td width="43%">
                                            <asp:TextBox id="txtQAEngRem" runat="server" Width="100%" CssClass="OutputText" Height="76px" TextMode="MultiLine"></asp:TextBox>
                                        </td>
                                        <td width="33%">
                                            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:RadioButton id="rbQAEngApp" runat="server" Text="Accepted" CssClass="OutputText" GroupName="QAEng"></asp:RadioButton>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:RadioButton id="rbQAEngRej" runat="server" Text="Rejected" CssClass="OutputText" GroupName="QAEng"></asp:RadioButton>
                                                        </td>
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
                                                            <asp:Label id="lblQAHODBy" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblQAHODDate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td>
                                            <asp:Label id="txtQAHODRem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                        <td>
                                            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:RadioButton id="rbQAHODApp" runat="server" Text="Accepted" CssClass="OutputText" Enabled="False" GroupName="QAHOD"></asp:RadioButton>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:RadioButton id="rbQAHODRej" runat="server" Text="Rejected" CssClass="OutputText" Enabled="False" GroupName="QAHOD"></asp:RadioButton>
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
                            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td width="25%">
                                            <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Text="Update SSER"></asp:Button>
                                        </td>
                                        <td width="25%">
                                            <p align="center">
                                                <asp:Button id="Button1" onclick="cmdPrintSSER_Click" runat="server" Text="Print" CausesValidation="False" Width="88px"></asp:Button>
                                            </p>
                                        </td>
                                        <td>
                                            <asp:Button id="Button2" onclick="cmdViewWUL_Click" runat="server" Text="Where Use List" CausesValidation="False"></asp:Button>
                                        </td>
                                        <td width="25%">
                                            <div align="center">
                                                <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Text="Submit" Width="98px"></asp:Button>
                                            </div>
                                        </td>
                                        <td width="25%">
                                            <div align="right">
                                                <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" CausesValidation="False" Width="101px"></asp:Button>
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
