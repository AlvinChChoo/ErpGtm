<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            IF page.ispostback=false then
                cmdSubmit.attributes.add("onClick","javascript:if(confirm('This will submit this UPA for approval.\nYou will not be able to edit this approval sheet after submission.\nAre you sure to continue ?')==false) return false;")
                cmdUpdateList.attributes.add("onClick","javascript:if(confirm('This action will remove the selected item from this Approval Sheet.\nYou will not be able to undo the changes made.\nAre you sure to continue ?')==false) return false;")
                cmdDelete.attributes.add("onClick","javascript:if(confirm('This UPA will be deleted from the system.\nYou will not be able to undo the changes made.\nAre you sure to continue ?')==false) return false;")
                Dim ReqCOm as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                Dim RsUPASM as SqlDataReader = ReqCOm.ExeDataReader("Select * from UPAS_M where Seq_No = '" & trim(request.params("ID")) & "';")
                Do while RsUPASM.read
                    lblUPASNo.text = RsUPASM("UPAS_NO").tostring
                    txtRem.text = RsUPASM("REM").tostring
                    if isdbnull(RsUPASM("CREATE_BY")) = false then lblCreateBy.text = RsUPASM("CREATE_BY").tostring & " (" & format(CDATE(RsUPASM("CREATE_DATE")),"MM/dd/yy") & ")" else lblCreateBy.text = "-"
                    if isdbnull(RsUPASM("SUBMIT_BY")) = false then lblSubmitBy.text = RsUPASM("SUBMIT_BY").tostring & " (" & format(cdate(RsUPASM("SUBMIT_DATE")),"MM/dd/yy") & ")" else lblSubmitBy.text = "-"
                    lblPurcRem.text = trim(RsUPASM("purc_rem").tostring)
                    lblACC1Rem.text = trim(RsUPASM("ACC1_rem").tostring)
                    lblACC2Rem.text = trim(RsUPASM("ACC2_rem").tostring)
                    lblMGTRem.text = trim(RsUPASM("Mgt_rem").tostring)
    
                    if trim(RsUPASM("UPAS_STATUS").tostring) = "REJECTED" then
                        if RsUPASM("REGENERATE") = "N" then
                            cmdReSubmit.enabled = true
                            cmdIgnoreResubmit.enabled = true
                        else
                            cmdReSubmit.enabled = false
                            cmdIgnoreResubmit.enabled = false
                        end if
                    else
                        cmdReSubmit.enabled = false
                        cmdIgnoreResubmit.enabled = false
                    End if
    
                    lblStatus.text = trim(RsUPASM("UPAS_Status").tostring)
                    if trim(RsUPASM("UPAS_Status").tostring) = "REJECTED" THEN
                        lblACC1Rem.text = trim(RsUPASM("ACC1_rem").tostring)
                        lblACC2Rem.text = trim(RsUPASM("ACC2_rem").tostring)
                        lblMGTRem.text = trim(RsUPASM("Mgt_rem").tostring)
                    else
                        lblACC1Rem.text = "-"
                        lblACC2Rem.text = "-"
                        lblMGTRem.text = "-"
                    end if
    
                    if isdbnull(RsUPASM("CREATE_BY")) = false then lblCreateBy.text = RsUPASM("CREATE_BY").tostring & " - " & format(cdate(RsUPASM("CREATE_DATE")),"dd/MMM/yy") else lblCreateBy.text = "-"
                    if isdbnull(RsUPASM("Submit_By")) = false then lblSubmitBy.text = RsUPASM("Submit_By").tostring & " - " & format(cdate(RsUPASM("Submit_Date")),"dd/MMM/yy") else lblSubmitBy.text = "-"
                    if isdbnull(RsUPASM("Purc_By")) = false then lblPurcApp.text = RsUPASM("Purc_By").tostring & " - " & format(cdate(RsUPASM("Purc_Date")),"dd/MMM/yy") else lblpurcApp.text = "-"
                    if isdbnull(RsUPASM("Acc1_By")) = false then lblAC1App.text = RsUPASM("Acc1_By").tostring & " - " & format(cdate(RsUPASM("Acc1_Date")),"dd/MMM/yy") else lblAc1App.text = "-"
                    if isdbnull(RsUPASM("Acc2_By")) = false then lblAC2App.text = RsUPASM("Acc2_By").tostring & " - " & format(cdate(RsUPASM("Acc2_Date")),"dd/MMM/yy") else lblAc2App.text = "-"
                    if isdbnull(RsUPASM("Mgt_By")) = false then lblmgtApp.text = RsUPASM("Mgt_By").tostring & " - " & format(cdate(RsUPASM("Mgt_Date")),"dd/MMM/yy") else lblmgtApp.text = "-"
                    if RsUPASM("URGENT") = "N" then chkUrgent.checked = false
                    if RsUPASM("URGENT") = "Y" then chkUrgent.checked = true
    
                    if isdbnull(RsUPASM("Submit_By")) = true then
    
                    if trim(RsUPASM("INV_Cost")) = "Y" then
                        lnkChangeDetWithoutInvCost.enabled = false
                        lnkAdd.enabled = true
                        lnkRemove.enabled = true
                        lnkEdit.enabled = true
                    elseif trim(RsUPASM("INV_Cost")) = "N" then
                        lnkChangeDetWithoutInvCost.enabled = true
                        lnkAdd.enabled = false
                        lnkRemove.enabled = false
                        lnkEdit.enabled = false
                    End if
    
                        cmdAddEditAtt.visible = true
                        cmdUpdatelist.enabled = true
                        cmdUpdate.enabled = true
                        cmdDelete.enabled = False
                        If ReqCOm.FuncCheckDuplicate("Select UPAS_No from UPAS_Attachment where UPAS_No = '" & trim(lblUPASNo.text) & "';","UPAS_No") = true then
                            cmdSubmit.enabled = true
                        else
                            cmdSubmit.enabled = false
                        end if
                        if trim(RsUPASM("Create_By")) = trim(request.cookies("U_ID").value) then cmdDelete.enabled =true else cmdDelete.enabled = false
                    elseif isdbnull(RsUPASM("Submit_By")) = false then
                        lnkadd.enabled = false
                        lnkremove.enabled = false
                        lnkedit.enabled = false
                        cmdAddEditAtt.visible = false
                        cmdSubmit.enabled = false
                        cmdUpdatelist.enabled = false
                        cmdUpdate.enabled = False
                        cmdDelete.enabled = False
                        lnkChangeDetWithoutInvCost.enabled = false
                    end if
                loop
                RsUPASM.Close
                ReqCOM.ExecuteNonQuery("Update UPAS_D set UPAS_D.Ven_Code_Temp = Vendor.Ven_Name from UPAS_D, Vendor where upas_d.Ven_Code = vendor.ven_code and UPAS_D.UPAS_No = '" & trim(lblUPASNo.text) & "';")
                ReqCOM.ExecuteNonQuery("Update UPAS_D set UPAS_D.A_Ven_Code_Temp = Vendor.Ven_Name from UPAS_D, Vendor where upas_d.A_Ven_Code = vendor.ven_code and UPAS_D.UPAS_No = '" & trim(lblUPASNo.text) & "';")
                LoadData
                FormatRow
                ProcLoadGridData
                GetRowCount
                lblTotalItem.text = "Total item : " & MyList.items.count
             end if
         End Sub
    
         sub LoadData
             Dim OurCommand as sqlcommand
             Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
             Dim ourDataAdapter as SQLDataAdapter
             dim OurDataset as new dataset()
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
             OurCommand = New SQLCommand("Select UPA.ORI_VEN_NAME,UPA.ORI_CURR_CODE,UPA.ORI_UP,UPA.A_ORI_VEN_NAME,UPA.A_ORI_CURR_CODE,UPA.A_ORI_UP,upa.validity,PM.WAC_COST,PM.OLD_WAC_COST,UPA.MIN_ORDER_QTY,UPA.A_MIN_ORDER_QTY,upa.cancel_lt,upa.a_cancel_lt,upa.reschedule_lt,upa.a_reschedule_lt,UPA.UP_RM,UPA.A_UP_RM,UPA.Curr_Code,UPA.A_Curr_Code, left(UPA.Ven_Code_temp,10) + '...' as [Ven_Code_temp],left(UPA.A_Ven_Code_Temp,10) + '...' as [A_Ven_Code_temp],PM.M_Part_No,PM.Part_Desc,PM.Part_Spec,UPA.aCT,UPA.part_no,UPA.seq_no,UPA.ven_code,UPA.up,UPA.diff_amt,UPA.lead_time,UPA.std_pack,UPA.a_ven_code,UPA.A_up,UPA.Diff_Pctg,UPA.A_Lead_Time,UPA.A_Std_pack,UPA.rem from UPAS_D UPA,Part_Master PM where UPA.UPAS_NO = '" & trim(lblUPASNo.text) & "' and UPA.Part_No = PM.Part_No order by upa.seq_no asc" ,myconnection)
             ourdataadapter=new sqldataadapter(ourcommand)
             ourDataAdapter.fill(OurDataset,"Items")
             Dim OurDataTable as new dataview(ourDataSet.Tables("Items"))
             MyList.DataSource = OurDatatable
             MyList.DataBind()
         End sub
    
         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdUpdateList_Click(sender As Object, e As EventArgs)
             Dim i As Integer
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             For i = 0 To MyList.Items.Count - 1
                 Dim SeqNo As Label = CType(MyList.Items(i).FindControl("SeqNo"), Label)
                 Dim remove As CheckBox = CType(MyList.Items(i).FindControl("Remove"), CheckBox)
                 If remove.Checked = true Then ReqCOM.ExecuteNonQuery("Delete from UPAS_D where Seq_No = '" & trim(SeqNo.text) & "';")
             Next
             Response.redirect("UnitPriceApprovalSheetDet.aspx?ID=" & Request.params("ID"))
         End Sub
    
         Sub lnkAdd_Click(sender As Object, e As EventArgs)
             response.redirect("UnitPriceApprovalSheetItemAddNew.aspx?ID=" & request.params("ID"))
         End Sub
    
         Sub lnkEdit_Click(sender As Object, e As EventArgs)
             Response.redirect("UnitPriceApprovalSheetItemEdit.aspx?ID=" & request.params("ID"))
         End Sub
    
         Sub lnkRemove_Click(sender As Object, e As EventArgs)
             response.redirect("UnitPriceApprovalSheetItemRemove.aspx?ID=" & Request.params("ID"))
         End Sub
    
         Sub cmdBack_Click(sender As Object, e As EventArgs)
             response.redirect("UnitPriceApprovalSheet.aspx")
         End Sub
    
        Sub cmdSubmit_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim Sender1 as string
            Dim objEmail as New MailMessage()
            Dim StrMsg as string
            Dim Receiver as string
            Dim Receiver1,ReturnURL as string
    
            if page.isvalid = true then
                if ReqCOM.GetFieldVal("Select Inv_Cost from UPAS_M where UPAS_No = '" & trim(lblUPASNo.text) & "';","Inv_Cost") = "Y" then
                    ReqCOM.executeNonQuery("Update UPAS_M set Rem = '" & trim(txtRem.text) & "' where UPAS_No = '" & trim(lblUPASNo.text) & "';")
                    if ReqCOM.FuncCheckDuplicate("Select EMail from User_Profile where U_ID='" & trim(request.cookies("U_ID").value) & "';","Email") = true then
                        Sender1 = ReqCOm.GetFieldVal("Select EMail from User_Profile where U_ID='" & trim(request.cookies("U_ID").value) & "';","Email")
                    Else
                        ShowAlert("Invalid Parameter Setting : Purchasing HOD E-Mail Address") : Exit sub
                    end if
    
                    if ReqCOM.FuncCheckDuplicate("select email from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email") = true then
                        Receiver1 = ReqCom.GetFieldVal("select email from User_Profile where U_ID in (Select Purchasing_HOD from main)","Email")
                    else
                        ShowAlert("Invalid Parameter Setting : Buyer E-Mail Address") : Exit sub
                    end if
    
                    ReqCOM.ExecuteNonQuery("update upas_d set ven_code = '-',curr_code = '-',ven_code_temp = '-',up = 0,ori_ven_name='-',ori_curr_code='-',ori_up=0 where ven_code = 'Label' and UPAS_No = '" & trim(lblUPASNo.text) & "';")
                    ReqCOM.ExecuteNonQuery("update upas_d set a_ven_code_temp = '-',a_curr_code = '-',a_up = 0,a_std_pack = 0,a_min_order_qty = 0,a_lead_time = 0,a_ori_ven_name = '-',a_ori_curr_code = '-', a_ori_up = 0 where a_ven_code = '-' and UPAS_No = '" & trim(lblUPASNo.text) & "';")
                    ReqCOM.ExecuteNonQuery("update upas_d set ori_ven_name = '-',ori_curr_code = '-',ori_up = 0 where ori_ven_name = '' and UPAS_No = '" & trim(lblUPASNo.text) & "';")
                    ReqCOM.ExecuteNonQuery("update upas_d set ori_ven_name = '-',ori_curr_code = '-',ori_up = 0 where ori_ven_name is null and UPAS_No = '" & trim(lblUPASNo.text) & "';")
                    ReqCOM.ExecuteNonQuery("update upas_d set a_ori_ven_name = '-',a_ori_curr_code = '-',a_ori_up = 0 where a_ori_ven_name = '';")
                    ReqCOM.ExecuteNonQuery("update upas_d set a_ori_ven_name = '-',a_ori_curr_code = '-',a_ori_up = 0 where a_ori_ven_name is null")
                    'GenerateMail()
                    ReqCOM.executeNonQuery("Update UPAS_M set SubMit_By = '" & trim(request.cookies("U_ID").value) & "',Submit_Date = '" & now & "',upas_status = 'PENDING APPROVAL' where seq_no = " & request.params("ID") & ";")
                    ReturnURL = "UnitPriceApprovalSheetDet.aspx?ID=" & Request.params("ID")
                    ShowAlert ("UPA submitted for approval.")
                    redirectPage(ReturnURl)
                Else
                    ReqCOM.ExecuteNonQuery("Update UPAS_M set submit_by = '" & trim(request.cookies("U_ID").value) & "',Submit_Date = '" & cdate(now) & "',purc_by = 'SysAdmin',purc_date = '" & cdate(now) & "',Acc1_By = 'SysAdmin',Acc1_date = '" & cdate(now) & "',Acc2_By = 'SysAdmin',Acc2_Date = '" & cdate(now) & "',MGT_By = 'SysAdmin',MGT_Date = '" & cdate(now) & "',UPAS_Status = 'APPROVED' where upas_no = '" & trim(lblUPASNo.text) & "';")
                    ReqCOM.ExecuteNonQUery("Update Part_Source set Part_Source.cancel_lt = UPAS_D.a_cancel_lt,Part_Source.reschedule_lt = UPAS_D.a_reschedule_lt,Part_Source.lead_time = UPAS_D.A_lead_time from UPAS_D,Part_Source where upas_D.upas_no = '" & trim(lblUPASNo.text) & "' and upas_d.part_no = part_source.part_no and upas_d.A_Std_Pack = Part_Source.std_pack_qty and upas_d.A_Min_Order_Qty = Part_Source.Min_Order_Qty and upas_d.UP = part_Source.up")
                end if
            end if
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
    
         Sub FormatRow()
            Dim i As Integer
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim RowCount,SeqNo,WACCost,DiffPctg,DiffAmt,Validity As Label
            Dim lnkAltEdit as LinkButton
    
            For i = 0 To MyList.Items.Count - 1
                DiffAmt = CType(MyList.Items(i).FindControl("DiffAmt"), Label)
                Validity = CType(MyList.Items(i).FindControl("Validity"), Label)
                DiffPctg = CType(MyList.Items(i).FindControl("DiffPctg"), Label)
                WACCost = CType(MyList.Items(i).FindControl("WACCost"), Label)
                SeqNo = CType(MyList.Items(i).FindControl("SeqNo"), Label)
                RowCount = CType(MyList.Items(i).FindControl("RowCount"), Label)
                lnkAltEdit = CType(MyList.Items(i).FindControl("lnkAltEdit"), LinkButton)
    
                if trim(lblSubmitBy.text) <> "-" then lnkAltEdit.enabled = false
                if trim(lblSubmitBy.text) = "-" then lnkAltEdit.enabled = true
    
                if trim(DiffAmt.text) <> "" then
                    if cdec(DiffAmt.text) > 0 then DiffAmt.CssClass = "PartSource" : DiffPctg.CssClass = "PartSource"
                End if
                DiffAmt.text = "RM " & DiffAmt.text
    
                if trim(validity.text) = 0 then
                    validity.text = "-"
                elseif trim(validity.text) <> 0 then
                    validity.text = Validity.text & " days upon approval."
                end if
    
                if trim(WACCost.text) = "" then WACCost.text = "0"
                WACCost.text = "RM " & format(cdec(WACCost.text),"##,##0.00000")
             Next
         end sub
    
        Sub GetRowCount()
            Dim RowCount As Label
            Dim i as integer
            For i = 0 to cint(MyList.items.count) - 1
                RowCount = CType(MyList.Items(i).FindControl("RowCount"), Label)
                RowCount.text = i + 1 & ".   "
            next i
        end sub
    
         Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from UPAS_ATTACHMENT where UPAS_NO = '" & trim(lblUPASNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"UPAS_ATTACHMENT")
        dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("UPAS_ATTACHMENT").DefaultView
        dtgUPASAttachment.DataBind()
    end sub
    
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
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdView_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update UPAS_D set UPAS_D.Ven_Code_Temp = Vendor.Ven_Name from UPAS_D, Vendor where upas_d.Ven_Code = vendor.ven_code and UPAS_D.UPAS_No = '" & trim(lblUPASNo.text) & "';")
        ReqCOM.ExecuteNonQuery("Update UPAS_D set UPAS_D.A_Ven_Code_Temp = Vendor.Ven_Name from UPAS_D, Vendor where upas_d.A_Ven_Code = vendor.ven_code and UPAS_D.UPAS_No = '" & trim(lblUPASNo.text) & "';")
        ShowPopup("PopupreportViewer.aspx?RptName=UPA&UPASNo=" & Trim(lblUPASNo.text) )
        ShowReport("UnitPriceApprovalSheetDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim Urgent as string
    
            If chkUrgent.checked = true then Urgent = "Y"
            If chkUrgent.checked = false then Urgent = "N"
            ReqCOM.executeNonQuery("Update UPAS_M set Rem = '" & trim(replace(txtRem.text,"'","`")) & "',Urgent='" & trim(Urgent) & "' where UPAS_No = '" & trim(lblUPASNo.text) & "';")
    
            ShowAlert ("UPA details updated.")
            redirectPage("UnitPriceApprovalSheetDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub GenerateMail()
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrMsg as string
        Dim TotalQty as decimal
        Dim TotalAmt as Decimal
        Dim POTotal as Decimal
        Dim ObjAttachment as MailAttachment
        Dim Sender as string
        Dim Receiver as string
    
        Sender = trim(request.cookies("U_ID").value)
        Receiver = ReqCOm.GetFieldVal("Select U_ID from Authority where module_name = 'UPA' and APP_TYPE = 'APP1'","U_ID")
    
        StrMsg = "Dear " & Receiver & vblf & vblf & vblf
        StrMsg = StrMsg + "There is a New Unit Price Approval Sheet pending for your approval." & vblf & vblf
        StrMsg = StrMsg + "The UPA Reference no is " & trim(lblUPASNo.text) & ". Please use this reference for future reference." & vblf & vblf
        StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=UPAAppDet.aspx?ID=" & Request.params("ID") & " to view the details."   & vblf & vblf
        StrMsg = StrMsg + "For assistance, please contact " & Sender & vblf  & vblf
        StrMsg = StrMsg + "Regards," & vblf
        StrMsg = StrMsg + Sender & vblf & vblf
    
        objEmail.To       = trim(ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(Receiver) & "';","EMail")) & ";YongYY@g-tek.com.my"
        objEmail.From     = trim(ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(Sender) & "';","EMail"))
    
        objEmail.Subject  = "UPA No : " & lblUPASNo.text
        objEmail.Body     = StrMsg
        objEmail.Priority = MailPriority.High
    
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOm.ExecuteNonQuery("Delete from UPAS_M where UPAS_No = '" & trim(lblUPASNo.text) & "';")
        ReqCom.ExecuteNonQuery("Delete from UPAS_Attachment where UPAS_No = '" & trim(lblUPASNo.text) & "';")
        Response.redirect("UnitPriceApprovalSheet.aspx")
    End Sub
    
    Sub cmdResubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim UPASNo as string = ReqCOM.GetDocumentNo("UPA_NO")
        Dim StrSql as string
    
    
        StrSql = "Insert into UPAS_M(UPAS_NO,REM,CREATE_BY,CREATE_DATE) "
        StrSql = StrSql + "Select '" & trim(UPASNo) & "',REM,Create_By,Create_Date from UPAS_M where UPAS_NO = '" & trim(lblUPASNo.text) & "';"
        ReqCOM.executeNonQuery(StrSql)
    
        StrSql = "Insert into UPAS_attachment(FILE_NAME,FILE_DESC,UPAS_NO,FILE_SIZE) "
        StrSql = StrSql + "Select FILE_NAME,FILE_DESC,'" & trim(UPASNo) & "',FILE_SIZE from upas_attachment where upas_no = '" & trim(lblUPASNo.text) & "';"
        ReqCOM.executeNonQuery(StrSql)
    
        StrSql = "Insert into UPAS_D(UPAS_NO,PART_NO,VEN_CODE,ACT,UP,STD_PACK,MIN_ORDER_QTY,LEAD_TIME,A_VEN_CODE,A_UP,A_LEAD_TIME,A_STD_PACK,A_MIN_ORDER_QTY,DIFF_AMT,DIFF_PCTG,CURR_CODE,A_CURR_CODE,UP_RM,A_UP_RM,CANCEL_LT,A_CANCEL_LT,RESCHEDULE_LT,REM,VALIDITY,A_RESCHEDULE_LT,ORI_VEN_NAME,ORI_CURR_CODE,ORI_UP,A_ORI_VEN_NAME,A_ORI_CURR_CODE,A_ORI_UP) "
        StrSql = StrSql + "Select '" & trim(UPASNo) & "',PART_NO,VEN_CODE,ACT,UP,STD_PACK,MIN_ORDER_QTY,LEAD_TIME,A_VEN_CODE,A_UP,A_LEAD_TIME,A_STD_PACK,A_MIN_ORDER_QTY,DIFF_AMT,DIFF_PCTG,CURR_CODE,A_CURR_CODE,UP_RM,A_UP_RM,CANCEL_LT,A_CANCEL_LT,RESCHEDULE_LT,REM,VALIDITY,A_RESCHEDULE_LT,ORI_VEN_NAME,ORI_CURR_CODE,ORI_UP,A_ORI_VEN_NAME,A_ORI_CURR_CODE,A_ORI_UP from upas_d where UPAS_NO = '" & trim(lblUPASNo.text) & "' order by seq_no asc"
        ReqCOM.executeNonQuery(StrSql)
    
        ReqCOM.ExecuteNonQuery("Update Main set UPA_NO = UPA_NO + 1")
        ReqCOM.ExecuteNonQuery("Update UPAS_M set Regenerate = 'Y',New_Upas_No = '" & trim(UPASNo) & "' where UPAS_NO = '" & trim(lblUPASNo.text) & "';")
        response.redirect("UnitPriceApprovalSheetCon.aspx?Act=Rev&ID=" & ReqCOM.getFieldVal("Select Seq_No from UPAS_M where UPAS_NO = '" & trim(UPASNo) & "';","Seq_No"))
    End Sub
    
    Sub cmdIgnoreResubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonquery("Update UPAS_M set Regenerate = 'I' where UPAS_NO = '" & trim(lblUPASNo.text) & "';")
        Response.redirect("UnitPriceApprovalSheetDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowDetails(s as object,e as DataListCommandEventArgs)
        Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim Script As New System.Text.StringBuilder
        Dim StrSql as string
        Dim Act As Label = CType(e.Item.FindControl("Act"), Label)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
    
        if trim(ucase(e.commandArgument)) = "EDIT" then
            if trim(ucase(Act.Text)) = "EDIT" then
                response.redirect("UPAItemEdit.aspx?ID=" & Clng(SeqNo.text))
            elseif trim(ucase(Act.Text)) = "ADD" then
                response.redirect("UPAItemAdd.aspx?ID=" & Clng(SeqNo.text))
            elseif trim(ucase(Act.Text)) = "DELETE" then
                response.redirect("UPAItemRemove.aspx?ID=" & Clng(SeqNo.text))
            end if
        elseif trim(ucase(e.commandArgument)) = "WHEREUSELIST" then
            ReqCOM.ExecuteNonQuery("Truncate Table Where_Use_M")
            ReqCOM.ExecuteNonQuery("Truncate Table Where_Use_D")
            ReqCOM.ExecuteNonQuery("Insert into Where_Use_M(MODEL_NO,PART_NO,P_LEVEL,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision) select MODEL_NO,PART_NO,P_LEVEL,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision from BOM_D where part_no = '" & trim(PartNo.text) & "';")
            ReqCOM.ExecuteNonQuery("Insert into Where_Use_D(MODEL_NO,MAIN_PART,PART_NO,REVISION) select MODEL_NO,MAIN_PART,PART_NO,REVISION from BOM_ALT where Part_No = '" & trim(PartNo.text) & "';")
    
            Dim rsWhereUse as SQLDataReader = ReqCOM.ExeDataReader("Select distinct(Model_No),Max(Revision) as [Revision] from where_use_m group by Model_No")
    
            Do while rsWhereUse.read
                ReqCOM.executeNonQuery("Delete from Where_use_m where model_no = '" & trim(rsWhereUse("Model_No")) & "' and Revision < " & rsWhereUse("Revision") & ";")
                ReqCOM.executeNonQuery("Delete from Where_use_d where model_no = '" & trim(rsWhereUse("Model_No")) & "' and Revision < " & rsWhereUse("Revision") & ";")
            loop
    
            rsWhereUse.close()
    
            StrSql = "Insert into Where_Use_M(MODEL_NO,PART_NO,P_LEVEL,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision) select MODEL_NO,PART_NO,P_LEVEL,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision from BOM_D where part_no in (select main_part from where_use_d where main_part not in(select part_no from where_use_m))"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update Part_Master set where_use_ind = 'N'"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update Part_Master set where_use_ind = 'Y' where Part_No in(Select distinct(Part_No) as [Part_No] from Where_use_m)"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            Script.Append("<script language=javascript>")
            Script.Append("pupUp=window.open('PopUpReportViewer.aspx?RptName=WhereUseListWithSupplier&PartNofrom=" & trim(PartNo.text) & "&PartNoTo=" & trim(PartNo.text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=950,height=250');")
            Script.Append("</script" & ">")
            RegisterStartupScript("NewPopUp", Script.ToString())
        End If
    end sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub lnkChangeDetWithoutInvCost_Click(sender As Object, e As EventArgs)
        Response.redirect("EditPartSource.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdAddEditAtt_Click(sender As Object, e As EventArgs)
        response.redirect("UPAAttachment.aspx?ID=" & request.params("ID") & "&ReturnURL=UnitPriceApprovalSheetDet.aspx?ID=" & Request.params("ID") )
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p align="center">
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <IBUYSPY:HEADER id="UserControl1" runat="server"></IBUYSPY:HEADER>
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Unit Price Apporval (UPA) Header</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <br />
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="80%" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="128px">Approval
                                                                                        Sheet No</asp:Label></td>
                                                                                    <td>
                                                                                        <div align="left"><asp:Label id="lblUPASNo" runat="server" cssclass="OutputText"></asp:Label>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td colspan="2">
                                                                                        <div align="right">
                                                                                            <asp:CheckBox id="chkUrgent" runat="server" CssClass="OutputText" Text="URGENT"></asp:CheckBox>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="128px">Remarks</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <div align="left">
                                                                                            <asp:TextBox id="txtRem" runat="server" CssClass="Input_Box" Width="100%" MaxLength="100"></asp:TextBox>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="128px">Status</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblStatus" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Prepared </asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText" width="384px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Submit </asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText" width="384px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver" rowspan="2">
                                                                                        <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Approved (Purc)</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblPurcApp" runat="server" cssclass="OutputText" width="384px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblPurcRem" runat="server" cssclass="OutputText" width="384px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver" rowspan="2">
                                                                                        <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Accounts 1</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblAC1App" runat="server" cssclass="OutputText" width="384px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblACC1Rem" runat="server" cssclass="OutputText" width="384px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver" rowspan="2">
                                                                                        <asp:Label id="Label81" runat="server" cssclass="LabelNormal">Accounts 2</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblAC2App" runat="server" cssclass="OutputText" width="384px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblACC2Rem" runat="server" cssclass="OutputText" width="384px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver" rowspan="2">
                                                                                        <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Approved (Mgt)</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblMgtApp" runat="server" cssclass="OutputText" width="384px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblMgtRem" runat="server" cssclass="OutputText" width="384px"></asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        <br />
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Unit Price Apporval (UPA) Attachment</td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdAddEditAtt" onclick="cmdAddEditAtt_Click" runat="server" CssClass="Submit_Button" Text="Add/Remove Attachment" Width="172px"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <br />
                                                                        <asp:DataGrid id="dtgUPASAttachment" runat="server" width="98%" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged" PageSize="50" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" AutoGenerateColumns="False" cellpadding="4" BorderColor="Gray">
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
                                                                                <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadUPAAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                        <br />
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Unit Price Apporval (UPA) Item List</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:LinkButton id="lnkAdd" onclick="lnkAdd_Click" runat="server" CssClass="OutputText" Width="">Click here to add
new source.</asp:LinkButton>
                                                                    <br />
                                                                    <asp:LinkButton id="lnkRemove" onclick="lnkRemove_Click" runat="server" CssClass="OutputText" Width="">Click here to remove
existing source.</asp:LinkButton>
                                                                    <br />
                                                                    <asp:LinkButton id="lnkEdit" onclick="lnkEdit_Click" runat="server" CssClass="OutputText" Width="">Click here to edit
existing source.</asp:LinkButton>
                                                                    <br />
                                                                    <asp:LinkButton id="lnkChangeDetWithoutInvCost" onclick="lnkChangeDetWithoutInvCost_Click" runat="server" CssClass="OutputText" Width="100%">Click here to edit sources details (Lead Time, Cancellation window, Reschedule Window)</asp:LinkButton>
                                                                    <br />
                                                                    <p align="center">
                                                                        <asp:DataList id="MyList" runat="server" Width="98%" OnSelectedIndexChanged="MyList_SelectedIndexChanged" OnItemCommand="ShowDetails" Height="101px" Font-Size="XX-Small" Font-Names="Arial" RepeatColumns="1" BorderWidth="0px" CellPadding="1">
                                                                            <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                            <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                            <ItemTemplate>
                                                                                <table border="1" width="100%" bordercolor="black" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black">
                                                                                    <tr>
                                                                                        <td>
                                                                                            <table border="0" width="100%">
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <table border="0" >
                                                                                                            <tr>
                                                                                                                <td>
                                                                                                                    <asp:LinkButton font-size="xx-small" id="lnkAltEdit" text='[Edit]' visible= "true" CssClass="OutputText" CommandArgument='Edit' runat="server" />
                                                                                                                    <asp:Label id="RowCount" visible="true" runat="server" text='' /> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    Remove this item 
                                                                                                                    <asp:CheckBox id="Remove" runat="server" />
                                                                                                                </td>
                                                                                                                <td></td>
                                                                                                                <td>
                                                                                                                    <span class="LabelNormal">Action : </span> <asp:Label id="Act" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Act") %>' /> 
                                                                                                                </td>
                                                                                                                <td></td>
                                                                                                                <td>
                                                                                                                    <asp:LinkButton id="LinkButton1" CommandArgument='WhereUseList' runat="server" Font-Size="X-Small" ForeColor="Red" Font-Bold="True">Where Use List</asp:LinkButton>
                                                                                                                    <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                                                </td>
                                                                                                                <td></td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" border="1" width="100%">
                                                                                                            <tr>
                                                                                                                <td width="25%" bgcolor="silver">
                                                                                                                    <span class="LabelNormal">Part No/Desc/Mfg. part No </span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="OutputText"><asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> ( <%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>)(<%# DataBinder.Eval(Container.DataItem, "M_Part_No")%>)</span> 
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td bgcolor="silver">
                                                                                                                    <span class="LabelNormal">Specification</span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="OutputText"><%# DataBinder.Eval(Container.DataItem, "Part_Spec") %> </span> 
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td bgcolor="silver">
                                                                                                                    <span class="LabelNormal">Remarks</span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="OutputText"><%# DataBinder.Eval(Container.DataItem, "Rem") %> </span> 
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td bgcolor="silver">
                                                                                                                    <span class="LabelNormal">Validity</span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="OutputText"><asp:Label id="Validity" cssclass= "ListOutput" width= "100%" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Validity") %>' /> </span> 
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" border='1' width="100%">
                                                                                                            <tr>
                                                                                                                <td bgcolor="silver">
                                                                                                                    <span class="ListLabel">Supplier(C) 
                                                                                                                    <br />
                                                                                                                    Supplier(N) </span> 
                                                                                                                </td>
                                                                                                                <td bgcolor="silver">
                                                                                                                    <span class="ListLabel">U/P(C) 
                                                                                                                    <br />
                                                                                                                    U/P(N) </span> 
                                                                                                                </td>
                                                                                                                <td bgcolor="silver">
                                                                                                                    <span class="ListLabel"> 
                                                                                                                    <br />
                                                                                                                    WAC</span> 
                                                                                                                </td>
                                                                                                                <td bgcolor="silver">
                                                                                                                    <span class="ListLabel">Diff(Amt) 
                                                                                                                    <br />
                                                                                                                    Diff(%) </span> 
                                                                                                                </td>
                                                                                                                <td bgcolor="silver">
                                                                                                                    <span class="ListLabel">LT/SPQ/MOQ(C) 
                                                                                                                    <br />
                                                                                                                    LT/SPQ/MOQ(N) </span> 
                                                                                                                </td>
                                                                                                                <td bgcolor="silver">
                                                                                                                    <span class="ListLabel">Can./Re-sch(C) 
                                                                                                                    <br />
                                                                                                                    Can./Re-sch(N) </span> 
                                                                                                                </td>
                                                                                                                <td bgcolor="silver">
                                                                                                                    <span class="ListLabel">Ori. Ven.(C) 
                                                                                                                    <br />
                                                                                                                    Ori. Ven. (N) </span> 
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Ven_Code_Temp") %> </span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Curr_Code") %> <%# DataBinder.Eval(Container.DataItem, "UP") %> (RM <%# DataBinder.Eval(Container.DataItem, "UP_RM") %>) </span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"></span> 
                                                                                                                </td>
                                                                                                                <td ">
                                                                                                                    <span class="ListOutput"><asp:Label id="DiffAmt" cssclass= "ListOutput" width= "100%" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Diff_Amt") %>' /> </span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Lead_Time") %> </span> / <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "STD_PACK") %> </span> / <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "MIN_ORDER_QTY") %> </span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Cancel_LT") %> </span> / <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Reschedule_lt") %> </span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "ORI_VEN_NAME") %> </span> (<span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "ORI_CURR_CODE") %> </span> <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "ORI_UP") %> </span> ) 
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_Ven_Code_Temp") %> </span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_Curr_Code") %> <%# DataBinder.Eval(Container.DataItem, "A_UP") %> (RM <%# DataBinder.Eval(Container.DataItem, "A_UP_RM") %>)</span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><asp:Label id="WACCost" cssclass= "ListOutput" width= "100%" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "WAC_COST") %>' /></span> 
                                                                                                                </td>
                                                                                                                <td >
                                                                                                                    <span class="ListOutput"><asp:Label id="DiffPctg" width= "100%" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Diff_PCTG") %>' /> </span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_Lead_Time") %> </span> / <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_STD_PACK") %> </span> / <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "a_MIN_ORDER_QTY") %> </span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_Cancel_LT") %> </span> / <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_Reschedule_LT") %> </span> 
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_ORI_VEN_NAME") %> </span> (<span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_ORI_CURR_CODE") %> </span> <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_ORI_UP") %> </span> ) 
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                                <br />
                                                                            </ItemTemplate>
                                                                            <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                                        </asp:DataList>
                                                                    </p>
                                                                    <p>
                                                                        <asp:Label id="lblTotalItem" runat="server" cssclass="Instruction" width="100%"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <p align="center">
                                                        <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                            <tbody>
                                                                <tr>
                                                                    <td width="10%">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" CssClass="OutputText" Text="Update" Width="100%"></asp:Button>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" CssClass="OutputText" Text="Submit" Width="100%"></asp:Button>
                                                                    </td>
                                                                    <td width="16%">
                                                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" CssClass="OutputText" Text="Remove this UPA" Width="100%"></asp:Button>
                                                                    </td>
                                                                    <td width="16%">
                                                                        <asp:Button id="cmdUpdateList" onclick="cmdUpdateList_Click" runat="server" CssClass="OutputText" Text="Remove UPA item" Width="100%"></asp:Button>
                                                                    </td>
                                                                    <td width="13%">
                                                                        <asp:Button id="cmdResubmit" onclick="cmdResubmit_Click" runat="server" CssClass="OutputText" Text="Re-Submit" Width="100%"></asp:Button>
                                                                    </td>
                                                                    <td width="15%">
                                                                        <asp:Button id="cmdIgnoreResubmit" onclick="cmdIgnoreResubmit_Click" runat="server" CssClass="OutputText" Text="Ignore Re-submit" Width="100%"></asp:Button>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <asp:Button id="cmdView" onclick="cmdView_Click" runat="server" CssClass="OutputText" Text="Print" Width="100%"></asp:Button>
                                                                    </td>
                                                                    <td width="10%">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Text="Back" Width="100%"></asp:Button>
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
                                    <Footer:Footer id="Footer" runat="server"></Footer:Footer>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
