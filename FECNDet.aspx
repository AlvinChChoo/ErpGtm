<%@ Page Language="VB" Debug="TRUE" %>
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

    Public RecNo as integer
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Dim oListmechPIC As ListItemCollection = cmbMechPIC.Items
        Dim oListElecPIC As ListItemCollection = cmbElecPIC.Items
        cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this FECN ?')==false) return false;")
        cmdDelete.attributes.add("onClick","javascript:if(confirm('Are you sure you want to delete this FECN from the system ?')==false) return false;")
        RecNo = 0
        If Page.IsPostBack = false Then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim ElecPIC,MechPIC as string
            dissql ("Select U_ID from Part_Type_PIC where Part_Type = 'ELECTRICAL'","U_ID","U_ID",cmbElecPic)
            dissql ("Select U_ID from Part_Type_PIC where Part_Type = 'MECHANICAL'","U_ID","U_ID",cmbMechPic)
            oListElecPIC.Add(New ListItem(""))
            oListmechPIC.Add(New ListItem(""))
            LoadFECNMain()
            LoadFECNDet()
            ProcLoadGridData
            FormatRow
        end if
    End Sub
    
    Sub UpdateFECNAltB4()
        Dim StrSql as string = "Select rtrim(PM.PART_NO) + '-' + rtrim(PM.PART_DESC) + '-' + rtrim(PM.PART_SPEC) + '-' + rtrim(PM.M_Part_No) as [PartDesc],FA.REF_SEQ from FECN_Alt FA,PART_MASTER PM where FA.FECN_No = '" & trim(lblFECNNo.text) & "' and pm.part_no = fa.part_no and status = 'B'"
        Dim RefAltB4 as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        ReqCOM.ExecuteNonQuery("Update FECN_D set Ref_Alt_B4 = '' where fecn_no = '" & trim(lblFECNNo.text) & "';")
        do while drGetFieldVal.read
            RefAltB4 = drGetFieldVal("PartDesc") & vblf
            ReqCOM.ExecuteNonQUery("Update FECN_D set Ref_Alt_b4 = Ref_Alt_B4 + '" & trim(RefAltB4) & "' where Seq_No = " & drGetFieldVal("Ref_Seq") & ";")
        loop
    
        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
    End sub
    
    Sub UpdateFECNAltAfter()
        Dim StrSql as string = "Select rtrim(PM.PART_NO) + '-' + rtrim(PM.PART_DESC) + '-' + rtrim(PM.PART_SPEC) + '-' + rtrim(PM.M_Part_No) as [PartDesc],FA.REF_SEQ from FECN_Alt FA,PART_MASTER PM where FA.FECN_No = '" & trim(lblFECNNo.text) & "' and pm.part_no = fa.part_no and status = 'A'"
        Dim RefAlt as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        ReqCOM.ExecuteNonQuery("Update FECN_D set Ref_Alt = '' where fecn_no = '" & trim(lblFECNNo.text) & "';")
    
        do while drGetFieldVal.read
            RefAlt = drGetFieldVal("PartDesc") & vblf
            ReqCOM.ExecuteNonQUery("Update FECN_D set Ref_Alt = Ref_Alt + '" & trim(RefAlt) & "' where Seq_No = " & drGetFieldVal("Ref_Seq") & ";")
        loop
    
        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
    End sub
    
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
    
    sub LoadFECNMain
        Dim strSql,MechPIC,ElecPIC as string
        strsql ="select * from FECN_M where Seq_no = '" & trim(request.params("ID")) & "';"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while result.read
    
            lblModelNo.text= result("MODEL_NO")
            lblModelNo.text= result("MODEL_NO") & " (" & ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc") & ")"
            txtPartListNo.text= result("PARTLIST_NO")
            lblBOMRev.text= result("BOM_REV")
            txtECNNo.text= result("ECN_NO")
            txtCustECNNo.text = result("CUST_ECN_NO")
            lblFECNNo.text = result("FECN_NO")
            lblFECNStatus.text = result("FECN_Status").toupper()
            txtRemarks.text = result("Submit_Rem").tostring
    
            txtPCBRevFrom.text = result("PCB_Rev_From").tostring
            txtPCBRevTo.text = result("PCB_Rev_To").tostring
    
            if isdbnull(result("Prepared_Date")) = false then
                lblPreparedBy.text= result("Prepared_By").tostring
                lblPreparedDate.text= format(cdate(result("Prepared_Date")),"dd/MM/yy")
            end if
    
    
            if isdbnull(result("Submit_Date")) = false then
                lblSubmitBy.text= result("Submit_By").tostring
                lblSubmitDate.text= format(cdate(result("Submit_Date")),"dd/MM/yy")
            end if
    
            if isdbnull(result("App1_Date")) = false then
                lblApp1By.text= result("App1_By").tostring
                lblApp1dATE.text=format(cdate(result("App1_Date")),"dd/MM/yy")
                lblApp1Rem.text = result("App1_Rem").tostring
            else
                lblapp1Rem.text = "-"
            end if
    
            if isdbnull(result("App2_Date")) = false then
                lblApp2By.text= result("App2_By").tostring
                lblApp2Date.text= format(cdate(result("App2_Date")),"dd/MM/yy")
                lblApp2Rem.text = result("App2_Rem").tostring
            else
                lblapp2Rem.text = "-"
            end if
    
            if isdbnull(result("App3_Date")) = false then
                lblApp3By.text= result("App3_By").tostring
                lblApp3Date.text= format(cdate(result("App3_Date")),"dd/MM/yy")
                lblApp3Rem.text = result("App3_Rem").tostring
            else
                lblapp3Rem.text = "-"
            end if
    
            if isdbnull(result("App4_Date")) = false then
                lblApp4By.text= result("App4_By").tostring
                lblApp4Date.text= format(cdate(result("App4_Date")),"dd/MM/yy")
                lblApp4Rem.text = result("App4_Rem").tostring
            else
                lblapp4Rem.text = "-"
            end if
    
            if isdbnull(result("App5_Date")) = false then
                lblApp5By.text= result("App5_By").tostring
                lblApp5Date.text= format(cdate(result("App5_Date")),"dd/MM/yy")
                lblApp5Rem.text = result("App5_Rem").tostring
            else
                lblapp5Rem.text = "-"
            end if
    
            if isdbnull(result("App6_Date")) = false then
                lblApp6By.text= result("App6_By").tostring
                lblApp6Date.text= format(cdate(result("App6_Date")),"dd/MM/yy")
                lblApp6Rem.text = result("App6_Rem").tostring
            else
                lblapp6Rem.text = "-"
            end if
    
            if result("TO_GTT").tostring = "Y" then chkToGtt.checked = true
            if result("TO_GTT").tostring = "N" then chkToGtt.checked = false
    
    
            if trim(result("Cust_Req").tostring) = "Y" then chkCustReq.checked = true
            if trim(result("DESIGN_cHANGE").tostring) = "Y" then chkDesignChange.checked = true
            if trim(result("COST_DOWN").tostring) = "Y" then chkCostDown.checked = true
            if trim(result("NO_SOURCE").tostring) = "Y" then chkNoSource.checked = true
            if trim(result("SIMPLIFY_PROCESS").tostring) = "Y" then chkSimplifyProcess.checked = true
            if trim(result("Lead_Free").tostring) = "Y" then chkLeadFree.checked = true
            if trim(result("others1").tostring) = "Y" then chkOthers.checked = true
            txtOthers.text = result("others").tostring
    
            if trim(ucase(result("FECN_Status").tostring)) = "REJECTED" then
                if ISDBNULL(result("new_fecn_no")) = true then
                    cmdResubmit.enabled = true
                    cmdIgnoreResubmit.enabled = true
                Elseif ISDBNULL(result("new_fecn_no")) = false then
                    cmdResubmit.enabled = false
                    cmdIgnoreResubmit.enabled = false
                eND IF
            else
                cmdResubmit.enabled = false
                cmdIgnoreResubmit.enabled = false
            End if
    
            if isdbnull(result("Elec_Pic")) = false then
                ElecPIC = ReqCOm.GetFieldVal("Select Elec_Pic from FECN_M where FECN_NO = '" & trim(result("FECN_No")) & "';","Elec_PIC")
                cmbElecPIC.items.FindByValue(ElecPIC).selected = true
            elseif isdbnull(result("Elec_Pic")) = true then
                cmbElecPIC.Items.FindByText("").Selected = True
            end if
    
            if isdbnull(result("MECH_PIC")) = false then
                MECHPIC = ReqCOm.GetFieldVal("Select MECH_PIC from FECN_M where FECN_NO = '" & trim(result("FECN_No")) & "';","MECH_Pic")
                cmbMECHPIC.items.FindByValue(MECHPIC).selected = true
            Elseif isdbnull(result("MECH_PIC")) = true then
                cmbMechPIC.Items.FindByText("").Selected = True
            end if
    
            if isdbnull(result("Submit_Date")) = true then
                lnkNewMainPart.enabled = true
                lnkRemoveMainPart.enabled = true
                lnkEditPart.enabled = true
                lnkPartDetails.enabled = true
                cmdSubmit.enabled = true
                cmdUpdate.enabled = true
                cmbmechPIC.enabled = true
                cmbElecPIC.enabled = true
                lnkNewMainPart.enabled = true
                lnkRemoveMainPart.enabled = true
                lnkEditPart.enabled = true
                cmdDelete.enabled = true
                cmdUpdate.enabled = true
                cmdSubmit.enabled = true
                cmbmechPIC.enabled = true
                cmbElecPIC.enabled = true
                lnkNewMainPart.enabled = true
                lnkRemoveMainPart.enabled = true
                lnkEditPart.enabled = true
                cmdAddAtt.enabled = true
                cmdRefreshAtt.enabled = true
                UpdateFECNAltB4()
                UpdateFECNAltAfter
            elseif isdbnull(result("Submit_Date")) = false then
                lnkNewMainPart.enabled = false
                lnkRemoveMainPart.enabled = false
                lnkEditPart.enabled = false
                lnkPartDetails.enabled = false
                cmbmechPIC.enabled = false
                cmbElecPIC.enabled = false
                cmdUpdate.enabled = false
                cmdSubmit.enabled = false
                lnkNewMainPart.enabled = false
                lnkRemoveMainPart.enabled = false
                lnkEditPart.enabled = false
                cmdDelete.enabled = false
                cmdAddAtt.enabled = false
                cmdRefreshAtt.enabled = false
            end if
    
            if ucase(trim(result("MODEL_NO"))) = "COMMON" then
                lnkPartDetails.enabled = true
                lnkNewMainPart.enabled = false
                lnkRemoveMainPart.enabled = false
                lnkEditPart.enabled = false
            else
                lnkPartDetails.enabled = false
                lnkNewMainPart.enabled = true
                lnkRemoveMainPart.enabled = true
                lnkEditPart.enabled = true
            end if
    
            if ucase(result("fecn_status")) = "REJECTED" then
                lnkPartDetails.enabled = false
                lnkNewMainPart.enabled = false
                lnkRemoveMainPart.enabled = false
                lnkEditPart.enabled = false
            end if
    
            if ucase(trim(result("MODEL_NO"))) = "COMMON" then
                lnkNewMainPart.enabled = false
                lnkRemoveMainPart.enabled = false
                lnkEditPart.enabled = false
            end if
        loop
    end sub
    
    sub LoadFECNDet()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        Dim strSql as string
        strsql ="select * from FECN_D where FECN_No = '" & lblFecNNo.text & "' order by seq_no asc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
    Sub cmdAddNewItem_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ViewDet(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
        Dim ChangeType As Label = CType(e.Item.FindControl("lblChangeType"), Label)
        Select case ucase(ChangeType.text)
            case "ADD MAIN PART" : response.redirect("FECNNewPartView.aspx?ID=" & cint(SeqNo.text))
            case "REMOVE MAIN PART" : response.redirect("FECNRemovePartView.aspx?ID=" & cint(SeqNo.text))
            case "ADD ALT PART" : response.redirect("FECNAddAltView.aspx?ID=" & cint(SeqNo.text))
            case "REMOVE ALT PART" : response.redirect("FECNRemoveAltView.aspx?ID=" & cint(SeqNo.text))
        End Select
    End SUb
    
    Sub lnkNewMainPart_Click(sender As Object, e As EventArgs)
        response.redirect("FECNAddMainPart.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub lnkRemoveMainPart_Click(sender As Object, e As EventArgs)
        response.redirect("FECNRemoveMainPart.aspx?ID=" + Request.params("ID"))
    End Sub
    
    Sub lnkEditPart_Click(sender As Object, e As EventArgs)
        Response.redirect("FECNEditMainPart.aspx?ID=" & request.params("ID"))
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("FECN.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim MReceiver,MSender,CC as string
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
            UpdateDetails
            StrSql = "Update FECN_M set Submit_by = '" & trim(request.cookies("U_ID").value) & "', Submit_date = '" & now & "',fecn_status = 'PENDING APPROVAL' where fecn_no = '" & trim(lblFecnNo.text) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            UpdateFECNAltB4()
            UpdateFECNAltAfter
    
            if trim(cmbElecPIC.selecteditem.value) <> "" then
                MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(cmbElecPIC.selecteditem.value) & "';","Email")
                MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
            elseif trim(cmbElecPIC.selecteditem.value) = "" then
                ReqCOM.ExecuteNonQuery("Update FECN_M set App1_By = 'N/A',App1_Date = '" & now & "',App1_Status = 'Y' where FECN_No = '" & trim(lblFecnNo.text) & "';")
            End if
    
            if trim(cmbMechPIC.selecteditem.value) <> "" then
                MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(cmbMechPIC.selecteditem.value) & "';","Email")
                MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
            Elseif trim(cmbMechPIC.selecteditem.value) = "" then
                ReqCOM.ExecuteNonQuery("Update FECN_M set App2_By = 'N/A',App2_Date = '" & now & "',App2_Status = 'Y' where FECN_No = '" & trim(lblFecnNo.text) & "';")
            End if
    
            ReqCOM.ExecuteNonQuery("UPDATE FECN_D SET FECN_D.UP_B4 = PART_MASTER.Std_Cost_purc FROM FECN_D,PART_MASTER WHERE PART_MASTER.PART_NO = FECN_D.MAIN_PART_B4 AND FECN_D.MAIN_PART_B4 <> '-' and fecn_d.fecn_no = '" & trim(lblFECNNo.text) & "';")
            ReqCOM.ExecuteNonQuery("UPDATE FECN_D SET FECN_D.UP = PART_MASTER.Std_Cost_purc FROM FECN_D,PART_MASTER WHERE PART_MASTER.PART_NO = FECN_D.MAIN_PART AND FECN_D.MAIN_PART <> '-' and fecn_d.fecn_no = '" & trim(lblFECNNo.text) & "'")
            Response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub GenerateMail(Sender as string, Receiver as string,CC as string,DOcNo as string,PIC as string)
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrMsg as string
        Dim ObjAttachment as MailAttachment
    
        StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
        StrMsg = StrMsg + "There is a New FECN pending for your approval." & vblf & vblf & vblf
        StrMsg = StrMsg + "FECN Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
        if trim(PIC) = "MECH" then StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=FECNApp1.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from FECN_M where FECN_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
        if trim(PIC) = "ELEC" then StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=FECNApp2.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from FECN_M where FECN_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
        StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
        StrMsg = StrMsg + "Regards," & vblf & vblf
        StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
        objEmail.Subject  = "FECN Approval : " & DOcNo
    
        objEmail.To       = trim(Receiver)
        objEmail.From     = trim(Sender)
        objEmail.CC       = trim(CC)
        objEmail.Body     = StrMsg
        objEmail.Priority = MailPriority.High
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Delete from FECN_M where FECN_NO = '" & trim(lblFECNNo.text) & "';")
        Response.cookies("AlertMessage").value = "Selected FECN has been deleted from the system."
        Response.redirect("AlertMessage.aspx?ReturnURL=FECN.aspx")
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim i As Integer
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ToGtt,CustReq, DesignChange,CostDown,NoSource,SimplifyProcess,StrSql,Others1 as string
        if page.isvalid = true then
            CustReq = iif((chkCustReq.checked=true),"Y","N")
            DesignChange = iif((chkDesignChange.checked=true),"Y","N")
    
            ToGtt = iif((chkToGtt.checked=true),"Y","N")
            CostDown = iif((chkCostDown.checked=true),"Y","N")
            NoSource = iif((chkNoSource.checked=true),"Y","N")
            SimplifyProcess = iif((chkSimplifyProcess.checked=true),"Y","N")
            Others1 = iif((chkOthers.checked=true),"Y","N")
            ReqCom.executeNonQuery("Update FECN_M set Submit_Rem = '" & trim(replace(txtRemarks.text,"'","`")) & "',Cust_Req = '" & trim(CustReq) & "',Design_Change = '" & trim(DesignChange) & "',Cost_Down = '" & trim(CostDown) & "',NO_Source = '" & trim(NoSource) & "',Simplify_Process = '" & trim(SimplifyProcess) & "',Others = '" & trim(txtOthers.text) & "',Others1 = '" & trim(Others1) & "' where FECN_No = '" & trim(lblFECNNo.text) & "';")
    
            For i = 0 To MyList.Items.Count - 1
                Dim SeqNo As Label = CType(MyList.Items(i).FindControl("SeqNo"), Label)
                Dim remove As CheckBox = CType(MyList.Items(i).FindControl("Remove"), CheckBox)
                If remove.Checked = true Then ReqCOM.ExecuteNonQuery("Delete from FECN_D where Seq_No = '" & trim(SeqNo.text) & "';")
            Next
    
            ReqCOM.ExecuteNonQUery("Delete from FECN_alt where ref_seq not in (select seq_no from fecn_d where fecn_no = '" & trim(lblFECNNo.text) & "') AND fecn_no = '" & trim(lblFECNNo.text) & "'")
            UpdateDetails
            Response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub UpdateDetails()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ToGtt,CustReq,DesignChange,CostDown,NoSource,SimplifyProcess,Others,LeadFree as string
    
        if chkCustReq.checked = false then CustReq = "N"
        if chkCustReq.checked = true then CustReq = "Y"
    
        if chkDesignChange.checked = false then DesignChange = "N"
        if chkDesignChange.checked = true then DesignChange = "Y"
    
        if chkCostDown.checked = false then CostDown = "N"
        if chkCostDown.checked = true then CostDown = "Y"
    
        if chkToGTT.checked = false then ToGtt = "N"
        if chkToGTT.checked = true then ToGtt = "Y"
    
        if chkNoSource.checked = false then NoSource = "N"
        if chkNoSource.checked = true then NoSource = "Y"
    
        if chkSimplifyProcess.checked = false then SimplifyProcess = "N"
        if chkSimplifyProcess.checked = true then SimplifyProcess = "Y"
    
        if chkLeadFree.checked = false then LeadFree = "N"
        if chkLeadFree.checked = true then LeadFree = "Y"
    
        if chkOthers.checked = false then Others = "N"
        if chkOthers.checked = true then Others = "Y"
    
        ReqCOM.ExecuteNonQuery("Update FECN_M set Submit_Rem = '" & trim(replace(txtRemarks.text,"'","`")) & "',Cust_ECN_NO = '" & trim(txtCustECNNo.text) & "',Cust_Req = '" & trim(CustReq) & "',TO_GTT = '" & trim(ToGTT) & "',Design_Change = '" & trim(DesignChange) & "',cost_down = '" & trim(CostDown) & "',Lead_Free = '" & trim(LeadFree) & "',no_source = '" & trim(NoSource) & "',simplify_process = '" & trim(SimplifyProcess) & "',others1 = '" & trim(Others) & "',ECN_NO = '" & trim(txtECNNo.text) & "',PartList_No = '" & trim(txtPartListNo.text) & "',PCB_Rev_From = '" & replace(trim(txtPCBRevFrom.text),"'","`") & "', PCB_Rev_To = '" & replace(trim(txtPCBRevTo.text),"'","`") & "' where FECN_NO = '" & trim(lblFECNNo.text) & "';")
        if trim(cmbElecPic.selecteditem.value) <> "" then ReqCOM.ExecuteNonQuery("Update FECN_M set Elec_PIC = '" & trim(cmbElecPIC.selecteditem.value) & "' where FECN_NO = '" & trim(lblFECNNo.text) & "';")
        if trim(cmbElecPic.selecteditem.value) = "" then ReqCOM.ExecuteNonQuery("Update FECN_M set Elec_PIC = null where FECN_NO = '" & trim(lblFECNNo.text) & "';")
        if trim(cmbMechPic.selecteditem.value) <> "" then ReqCOM.ExecuteNonQuery("Update FECN_M set Mech_PIC = '" & trim(cmbMechPIC.selecteditem.value) & "' where FECN_NO = '" & trim(lblFECNNo.text) & "';")
        if trim(cmbMechPic.selecteditem.value) = "" then ReqCOM.ExecuteNonQuery("Update FECN_M set Mech_PIC = null where FECN_NO = '" & trim(lblFECNNo.text) & "';")
    
        if ReqCOM.funcCheckDuplicate("Select top 1 Imp_Type from fecn_d where imp_type = 'Immediate' and fecn_no = '" & trim(lblFECNNo.text) & "';","Imp_Type") = true
            ReqCOM.ExecuteNonQUery("Update FECN_M set Urgent = 'Y' where fecn_no = '" & trim(lblFECNNo.text) & "';")
        else
            ReqCOM.ExecuteNonQUery("Update FECN_M set Urgent = 'N' where fecn_no = '" & trim(lblFECNNo.text) & "';")
        end if
    End sub
    
    Sub FormatRow()
        Dim PartDet as string
        Dim i As Integer
        Dim ETADate,MinOrderQty,StdPackQty,UP,QtyToBuy,ReqQty,Diff,Amt,RowNo As Label
        Dim PartSpecB4,MPartNoB4,PUsageB4,PLevelB4,PLocationB4,MAINPARTB4,RefAltPartB4,MFG,MFGB4 As Label
        Dim PartSpec,MPartNo,PUsage,PLevel,PLocation,MAINPART,RefAltPart As Label
        Dim PartDescB4,PartDesc As Textbox
    
    
        For i = 0 To MyList.Items.Count - 1
            PartDescB4 = CType(MyList.Items(i).FindControl("PartDescB4"), Textbox)
            PartSpecB4 = CType(MyList.Items(i).FindControl("PartSpecB4"), Label)
            MPartNoB4 = CType(MyList.Items(i).FindControl("MPartNoB4"), Label)
            MainPartB4 = CType(MyList.Items(i).FindControl("MainPartB4"), Label)
            PLocationB4 = CType(MyList.Items(i).FindControl("PLocationB4"), Label)
            PUsageB4 = CType(MyList.Items(i).FindControl("PUsageB4"), Label)
            PLevelB4 = CType(MyList.Items(i).FindControl("PLevelB4"), Label)
            RefAltPartB4 = CType(MyList.Items(i).FindControl("RefAltPartB4"), Label)
            PartDesc = CType(MyList.Items(i).FindControl("PartDesc"), Textbox)
            PartSpec = CType(MyList.Items(i).FindControl("PartSpec"), Label)
            MPartNo = CType(MyList.Items(i).FindControl("MPartNo"), Label)
            MainPart = CType(MyList.Items(i).FindControl("MainPart"), Label)
            PLocation = CType(MyList.Items(i).FindControl("PLocation"), Label)
            PUsage = CType(MyList.Items(i).FindControl("PUsage"), Label)
            PLevel = CType(MyList.Items(i).FindControl("PLevel"), Label)
            RefAltPart = CType(MyList.Items(i).FindControl("RefAltPart"), Label)
            MFG = CType(MyList.Items(i).FindControl("MFG"), Label)
            MFGB4 = CType(MyList.Items(i).FindControl("MFGB4"), Label)
    
            if trim(MPartNo.text) = "<NULL>" then MPartNo.text = "-"
            if trim(MPartNoB4.text) = "<NULL>" then MPartNoB4.text = "-"
    
            if trim(MainPartB4.text) = "-" then PartDescB4.text = "N/A"
            if trim(MainPartB4.text) <> "-" then PartDescB4.text = "Part #           : " & trim(MainPartB4.text) & vblf & "DESC/SPEC    : " & trim(PartDescB4.text) & " /(" & trim(PartSpecB4.text) & ")" & vblf & "MPN/MFG       : " & trim(MPartNoB4.text) & "/" & trim(MfgB4.text) & vblf & "Usage/Level  : " & cdec(PUsageB4.text) & " (" & trim(PLevelB4.text) & ")" & vblf & "Location        : " & trim(PLocationB4.text) & vblf & vblf & "Alt Part         : " & vblf & trim(RefAltPartB4.text)
    
            if trim(MainPart.text) = "-" then PartDesc.text = "N/A"
            if trim(MainPart.text) <> "-" then PartDesc.text = "Part #           : " & trim(MainPart.text) & vblf & "DESC/SPEC    : " & trim(PartDesc.text) & " /(" & trim(PartSpec.text) & ")" & vblf & "MPN/MFG       : " & trim(MPartNo.text) & "/" & trim(MFGB4.text) & vblf & "Usage/Level  : " & cdec(PUsage.text) & " (" & trim(PLevel.text) & ")" & vblf & "Location        : " & trim(PLocation.text) & vblf & vblf & "Alt Part         : " & vblf & trim(RefAltPart.text)
    
            RowNo = CType(MyList.Items(i).FindControl("RowNo"), Label)
            RowNo.text = i + 1
        Next
    End sub
    
    Sub PIC_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        if trim(cmbMechPIC.selecteditem.value) = "" and trim(cmbElecPIC.selecteditem.value) = "" then e.isvalid = false
    End Sub
    
    Sub cmdResubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim FECNNo as string = ReqCOM.GetDocumentNo("FECN_NO")
        Dim StrSql as string
        Dim NewSeqNo as long
    
        StrSql = "Insert into FECN_M(FECN_NO,PCB_REV_FROM,PCB_REV_TO,DEPT_CODE,MODEL_NO,ECN_NO,BOM_REV,PARTLIST_NO,FECN_DATE,CUST_ECN_NO,PREPARED_BY,elec_pic,mech_pic,PREPARED_DATE,CUST_REQ,DESIGN_CHANGE,COST_DOWN,NO_SOURCE,SIMPLIFY_PROCESS,Lead_Free,OTHERS1,OTHERS,SUBMIT_REM) "
        StrSql = StrSql + "Select '" & trim(FECNNo) & "',PCB_REV_FROM,PCB_REV_TO,DEPT_CODE,MODEL_NO,ECN_NO,BOM_REV,PARTLIST_NO,FECN_DATE,CUST_ECN_NO,'" & trim(request.cookies("U_ID").value) & "',elec_pic,mech_pic,'" & now & "',CUST_REQ,DESIGN_CHANGE,COST_DOWN,NO_SOURCE,SIMPLIFY_PROCESS,Lead_Free,OTHERS1,OTHERS,SUBMIT_REM from FECN_M where FECN_NO = '" & trim(lblFECNNo.text) & "';"
        ReqCOM.executeNonQuery(StrSql)
    
        StrSql = "Update FECN_M set NEW_FECN_NO = '" & trim(FECNNo) & "',rEGENERATE = 'Y' where seq_no = " & cint(request.params("ID")) & ";"
        ReqCOM.executeNonQuery(StrSql)
    
        StrSql = "Insert into FECN_Attachment(FILE_NAME,FILE_DESC,FECN_NO,FILE_SIZE) select FILE_NAME,FILE_DESC,'" & trim(FECNNo) & "',FILE_SIZE from fecn_attachment where fecn_no = '" & trim(lblFECNNo.text) & "';"
        ReqCOM.executeNonQuery(StrSql)
    
        StrSql = "Select * from FECN_D where fecn_No = '" & trim(lblFECNNo.text) & "' order by seq_no asc;"
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while drGetFieldVal.read
            StrSql = "Insert into FECN_d(FECN_NO,MAIN_PART_B4,ALT_PART_B4,PART_DESC_B4,PART_SPEC_B4,M_PART_NO_B4,P_USAGE_B4,P_LEVEL_B4,P_LOCATION_B4,MAIN_PART,ALT_PART,PART_DESC,PART_SPEC,M_PART_NO,P_USAGE,P_LEVEL,P_LOCATION,TYPE_CHANGE,REASON_CHANGE,FECN_EFFECT,LOT_NO,LOT_DET,LOT_QTY,IMP_TYPE,REF_ALT,REF_ALT_B4) "
            StrSql = StrSql + "Select '" & trim(FECNNo) & "',MAIN_PART_B4,ALT_PART_B4,PART_DESC_B4,PART_SPEC_B4,M_PART_NO_B4,P_USAGE_B4,P_LEVEL_B4,P_LOCATION_B4,MAIN_PART,ALT_PART,PART_DESC,PART_SPEC,M_PART_NO,P_USAGE,P_LEVEL,P_LOCATION,TYPE_CHANGE,REASON_CHANGE,FECN_EFFECT,LOT_NO,LOT_DET,LOT_QTY,IMP_TYPE,REF_ALT,REF_ALT_B4 from FECN_d where Seq_No = " & trim(drGetFieldVal("Seq_No")) & ";"
            ReqCOM.executeNonQuery(StrSql)
    
    
            if ReqCOM.funcCheckDuplicate("Select FECN_No from FECN_Alt where Ref_Seq = " & clng(drGetFieldVal("Seq_No")) & ";","FECN_No") = true then
                NewSeqNo = ReqCOM.GetFieldVal("Select top 1 Seq_No from FECN_D order by seq_no desc","Seq_No")
                ReqCOm.ExecuteNonQuery("Insert into fecn_alt(FECN_NO,MAIN_PART,PART_NO,STATUS,REF_SEQ) select '" & TRIM(FECNNo) & "',MAIN_PART,PART_NO,STATUS," & clng(NewSeqNo) & " from fecn_alt where ref_seq = " & drGetFieldVal("Seq_No") & ";")
            end if
        loop
    
        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
        UpdateFECNAltB4()
        UpdateFECNAltAfter
    
        ReqCOM.ExecuteNonQuery("Update Main set FECN_NO = FECN_NO + 1")
        Response.redirect("FECNDet.aspx?ID=" & ReqCOM.GEtFieldVal("Select Seq_No from FECN_M where fecn_no = '" & trim(FECNNo) & "';","Seq_No"))
    End Sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
    End sub
    
    
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from fecn_ATTACHMENT where fecn_NO = '" & trim(lblfecnNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"fecn_ATTACHMENT")
        dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("fecn_ATTACHMENT").DefaultView
        dtgUPASAttachment.DataBind()
    end sub
    
    Sub cmdRefreshAtt_Click(sender As Object, e As EventArgs)
        ProcLoadGridData
    End Sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub CustomValidator1_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        if (chkCustReq.checked = false and chkDesignChange.checked = false and chkCostDown.checked = false and chkNoSource.checked = false and chkSimplifyProcess.checked = false and chkOthers.checked = false and chkLeadFree.checked = false) then e.isvalid = false
    End Sub
    
    Sub lnkPartDetails_Click(sender As Object, e As EventArgs)
        response.redirect("FECNEditPartDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdIgnoreResubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQUery("Update FECN_M set Regenerate = 'N',New_Fecn_No = '' where fecn_no = '" & trim(lblFECNNo.text) & "';")
        Response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowSelection(s as object,e as DataListCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim MainPartB4 as string = trim(e.commandArgument)
        Dim ModelNo as string = ReqCOM.GetFieldVal("Select Model_No from FECN_M where FECN_No = '" & trim(lblFECNNo.text) & "';","Model_No")
    
        Dim SeqNo as string = ReqCom.GetFieldVal("Select top 1 Seq_No from BOM_D where Part_No = '" & trim(MainPartB4) & "' and Model_No = '" & trim(ModelNo) & "' order by Revision desc","Seq_No")
    
        if trim(SeqNo) <> "<NULL>" then
            ShowReport("PopupAlternatePart.aspx?ID=" & SeqNo)
            redirectPage("FECNDet.aspx?ID=" & Request.params("ID"))
        elseif trim(SeqNo) = "<NULL>" then
            ShowAlert("No alternate part available.")
            redirectPage("FECNDet.aspx?ID=" & Request.params("ID"))
        end if
    end sub
    
    Sub ShowAlert(Msg as string)
          Dim strScript as string
          strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
       If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
       End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        UpdateFECNAltB4()
        UpdateFECNAltAfter()
    End Sub
    
    Sub LinkButton4_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub lnkRemoveAltPart_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("DownloadFECNAttachment.aspx?ID=" & clng(SeqNo.text))
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQuery("Delete from FECN_Attachment where Seq_No = " & clng(SeqNo.text) & ";") : Response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
    end sub
    
    Sub cmdAddAtt_Click(sender As Object, e As EventArgs)
        ShowPopup("popupFECNAtt.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub UserControl2_Load(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 3px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">FECN DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="PIC" runat="server" OnServerValidate="PIC_ServerValidate" EnableClientScript="False" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have select a valid Electrical or Mechanical PIC." Width="100%" CssClass="ErrorText"></asp:CustomValidator>
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" OnServerValidate="CustomValidator1_ServerValidate" EnableClientScript="False" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid reason of change." Width="100%" CssClass="ErrorText"></asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <asp:CheckBox id="chkToGTT" runat="server" CssClass="OutputText" Text="E-Mail to GTT Document Control (Chien@gtek.com.tw,sandy@gtek.com.tw,doc@gtek.com.tw)"></asp:CheckBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width="25%" bgcolor="silver">
                                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">FECN No</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblFECNNo" runat="server" width="" font-bold="True" font-size="Larger"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="">Model No/Description</asp:Label></td>
                                                                                <td>
                                                                                    <p align="left">
                                                                                        <asp:Label id="lblModelNo" runat="server" font-bold="True" font-size="Larger"></asp:Label>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label15" runat="server" cssclass="LabelNormal" width="116px">PCBA Rev.
                                                                                    From</asp:Label></td>
                                                                                <td>
                                                                                    <asp:TextBox id="txtPCBRevFrom" runat="server" Width="241px" CssClass="OutputText"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label22" runat="server" cssclass="LabelNormal" width="116px">PCBA Rev.
                                                                                    To</asp:Label></td>
                                                                                <td>
                                                                                    <asp:TextBox id="txtPCBRevTo" runat="server" Width="241px" CssClass="OutputText"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="116px">ECN No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left">
                                                                                        <asp:TextBox id="txtECNNo" onkeydown="GetFocusWhenEnter(txtCustECNNo)" onclick="GetFocus(txtECNNo)" runat="server" Width="241px" CssClass="OutputText"></asp:TextBox>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="">Cust. ECN No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left">
                                                                                        <asp:TextBox id="txtCustECNNo" onkeydown="GetFocusWhenEnter(txtPartListNo)" onclick="GetFocus(txtCustECNNo)" runat="server" Width="241px" CssClass="OutputText"></asp:TextBox>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="126px">Partlist
                                                                                    No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left">
                                                                                        <asp:TextBox id="txtPartListNo" onclick="GetFocus(txtPartListNo)" runat="server" Width="241px" CssClass="OutputText"></asp:TextBox>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="126px">Electrical
                                                                                    (PIC)</asp:Label></td>
                                                                                <td>
                                                                                    <asp:DropDownList id="cmbElecPIC" runat="server" Width="241px" CssClass="outputText"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="126px">Mechanical
                                                                                    (PIC)</asp:Label></td>
                                                                                <td>
                                                                                    <asp:DropDownList id="cmbMechPIC" runat="server" Width="241px" CssClass="outputText"></asp:DropDownList>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="124px">Reason
                                                                                    of change</asp:Label></td>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:CheckBox id="chkCustReq" runat="server" CssClass="OutputText" Text="Customer Request"></asp:CheckBox>
                                                                                        &nbsp; 
                                                                                        <asp:CheckBox id="chkDesignChange" runat="server" CssClass="OutputText" Text="Design Change"></asp:CheckBox>
                                                                                        &nbsp; 
                                                                                        <asp:CheckBox id="chkCostDown" runat="server" CssClass="OutputText" Text="Cost Down"></asp:CheckBox>
                                                                                        &nbsp; 
                                                                                        <asp:CheckBox id="chkNoSource" runat="server" CssClass="OutputText" Text="No Source"></asp:CheckBox>
                                                                                        <asp:CheckBox id="chkLeadFree" runat="server" CssClass="OutputText" Text="Lead Free"></asp:CheckBox>
                                                                                        <asp:CheckBox id="chkSimplifyProcess" runat="server" CssClass="OutputText" Text="Simplify Process"></asp:CheckBox>
                                                                                        &nbsp; 
                                                                                        <asp:CheckBox id="chkOthers" runat="server" CssClass="OutputText" Text="Others, pls specify"></asp:CheckBox>
                                                                                        &nbsp; 
                                                                                        <asp:TextBox id="txtOthers" runat="server" Width="152px" CssClass="OutputText"></asp:TextBox>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="124px">BOM Rev. </asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblBOMRev" runat="server" cssclass="OutputText" width="299px"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="124px">FECN Status</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblFECNStatus" runat="server" cssclass="OutputText" width="260px"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal" width="124px">Prepared
                                                                                    By</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPreparedBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblPreparedDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="124px">Submit
                                                                                    By</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="124px">Remarks</asp:Label></td>
                                                                                <td>
                                                                                    <asp:TextBox id="txtRemarks" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal" width="126px">Verified(Electrical)</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp1Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label17" runat="server" cssclass="LabelNormal" width="126px">Verified(Mechanical)</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp2Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label18" runat="server" cssclass="LabelNormal" width="126px">R&D HOD
                                                                                    By</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp3Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label19" runat="server" cssclass="LabelNormal" width="126px">PCMC</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp4Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label20" runat="server" cssclass="LabelNormal" width="126px">Costing</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp5By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp5Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblApp5Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label21" runat="server" cssclass="LabelNormal" width="126px">M.D.</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblApp6By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblApp6Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblApp6Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                    </div>
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
                                                    <table style="HEIGHT: 11px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <div align="left">
                                                                                            <asp:Button id="cmdRefreshAtt" onclick="cmdRefreshAtt_Click" runat="server" Width="190px" CssClass="OutputText" Text="Refresh Attachment List" CausesValidation="False"></asp:Button>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="right">
                                                                                            <asp:Button id="cmdAddAtt" onclick="cmdAddAtt_Click" runat="server" CssClass="OutputText" Text="Add Attachment" CausesValidation="False"></asp:Button>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" OnItemCommand="ItemCommand" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged" BorderColor="Black" GridLines="None" cellpadding="4" AutoGenerateColumns="False" HeaderStyle-CssClass="CartListHead" ItemStyle-CssClass="CartListItem" AlternatingItemStyle-CssClass="CartListItemAlt" PageSize="50">
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
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
                                                                                        <asp:ImageButton id="ImgView" ToolTip="View this attachment" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                                                                        <asp:ImageButton id="ImgDelete" ToolTip="Delete this attachment" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server"></asp:ImageButton>
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
                                                    <table style="HEIGHT: 12px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:LinkButton id="lnkNewMainPart" onclick="lnkNewMainPart_Click" runat="server" Width="100%" CssClass="OutputText" Enabled="False">Click here to add new Main Part</asp:LinkButton>
                                                                        <asp:LinkButton id="lnkRemoveMainPart" onclick="lnkRemoveMainPart_Click" runat="server" Width="100%" CssClass="OutputText" Enabled="False">Click here to remove Main Part</asp:LinkButton>
                                                                        <asp:LinkButton id="lnkEditPart" onclick="lnkEditPart_Click" runat="server" Width="100%" CssClass="OutputText" Enabled="False">Click here to edit BOM Details (e.g. Part No,Location, Usage, Level, add and remove alternate part)</asp:LinkButton>
                                                                        <asp:LinkButton id="LinkButton4" onclick="LinkButton4_Click" runat="server" Width="100%" CssClass="OutputText" Enabled="False" Visible="False">Click here to add new Alternate Part</asp:LinkButton>
                                                                        <asp:LinkButton id="lnkRemoveAltPart" onclick="lnkRemoveAltPart_Click" runat="server" Width="100%" CssClass="OutputText" Enabled="False" Visible="False">Click here to remove Alternate Part</asp:LinkButton>
                                                                        <asp:LinkButton id="lnkPartDetails" onclick="lnkPartDetails_Click" runat="server" Width="100%" CssClass="OutputText" Enabled="False">Click here to edit part details (e.g. Specification, Description, MPN)</asp:LinkButton>
                                                                    </p>
                                                                    <p align="center">
                                                                        <asp:DataList id="MyList" runat="server" Width="100%" OnItemCommand="ShowSelection" OnSelectedIndexChanged="MyList_SelectedIndexChanged" Font-Names="Arial" Font-Size="XX-Small" RepeatColumns="1" BorderWidth="0px" CellPadding="1" Height="101px">
                                                                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                            <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                            <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                            <ItemTemplate>
                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label id="RowNo" visible="true" runat="server" text='11' cssclass="ErrorText" /> <span class="OutputText">Remove
                                                                                                this item </span> 
                                                                                                <asp:CheckBox id="Remove" runat="server" />
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:LinkButton font-size="xx-small" id="myLinkBtns" text='View Part Details' CssClass="OutputText" CommandArgument='<%# Container.DataItem("Seq_No")%>' runat="server" />
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListLabel">Type Of Changes : </span><span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Type_CHANGE") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListLabel">Implementation : </span><span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Imp_Type") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListLabel">Implementation Qty : </span><span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Imp_Qty") %> </span> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="5">
                                                                                                <span class="ListLabel">Reason of change : </span><span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "REASON_CHANGE") %> </span> <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                            </td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                    <tr>
                                                                                        <td valign="top" width= "20%">
                                                                                            <span class="OutputText">Before </span> 
                                                                                        </td>
                                                                                        <td width= "80%">
                                                                                            <asp:textbox id="PartDescB4" width= "100%" CssClass="ListOutput" runat="server" height="150px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "PART_DESC_B4") %>'></asp:textbox>
                                                                                            <asp:Label id="MAINPARTB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART_B4") %>'></asp:Label> <asp:Label id="PUSAGEB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_USAGE_B4") %>'></asp:Label> <asp:Label id="PLOCATIONB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LOCATION_B4") %>'></asp:Label> <asp:Label id="PartSpecB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_SPEC_B4") %>'></asp:Label> <asp:Label id="PLEVELB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LEVEL_B4") %>'></asp:Label> <asp:Label id="MPARTNOB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_PART_NO_B4") %>'></asp:Label> <asp:Label id="RefAltPartB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ref_Alt_B4") %>'></asp:Label> <asp:Label id="MFGB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG_B4") %>'></asp:Label> 
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td valign="top">
                                                                                            <span class="OutputText">After</span> 
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:textbox id="PartDesc" CssClass="ListOutput" runat="server" width= "700px" height="150px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "PART_DESC") %>'></asp:textbox>
                                                                                            <asp:Label id="MAINPART" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART") %>'></asp:Label> <asp:Label id="PUSAGE" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_USAGE") %>'></asp:Label> <asp:Label id="PLOCATION" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LOCATION") %>'></asp:Label> <asp:Label id="PartSpec" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_SPEC") %>'></asp:Label> <asp:Label id="PLEVEL" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LEVEL") %>'></asp:Label> <asp:Label id="MPARTNO" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_PART_NO") %>'></asp:Label> <asp:Label id="RefAltPart" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ref_Alt") %>'></asp:Label> <asp:Label id="MFG" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG") %>'></asp:Label> 
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                                <br />
                                                                            </ItemTemplate>
                                                                            <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                        </asp:DataList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="16%">
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="100%" Text="Update Details"></asp:Button>
                                                                </td>
                                                                <td width="16%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="100%" Text="Submit"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="16%">
                                                                    <asp:Button id="cmdIgnoreResubmit" onclick="cmdIgnoreResubmit_Click" runat="server" Width="100%" Text="Ignore Re-submit" Enabled="False"></asp:Button>
                                                                </td>
                                                                <td width="16%">
                                                                    <asp:Button id="cmdResubmit" onclick="cmdResubmit_Click" runat="server" Width="100%" Text="Re-Submit" Enabled="False"></asp:Button>
                                                                </td>
                                                                <td width="16%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" Width="100%" Text="Delete FECN" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="16%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="100%" Text="Back"></asp:Button>
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
                            <asp:Button id="Button1" onclick="Button1_Click" runat="server" Text="Button" Visible="False"></asp:Button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>