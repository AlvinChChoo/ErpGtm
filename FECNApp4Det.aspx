<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="ERP" TagName="Attachment" Src="_FECNAttachment_.ascx" %>
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
        cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this FECN ?')==false) return false;")
        If Page.IsPostBack = false Then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            LoadFECNMain()
            LoadFECNDet()
            FormatRow()
            ProcLoadGridData()
            if trim(lblApp4By.text) = "" then cmdUpdate.enabled = true
            if trim(lblApp4By.text) <> "" then cmdUpdate.enabled = false
        end if
    End Sub
    
    Sub FormatRow()
        Dim PartDet as string
        Dim i As Integer
        Dim FECNEffectTemp,ETADate,MinOrderQty,StdPackQty,UP,QtyToBuy,ReqQty,Diff,Amt,RowNo As Label
        Dim PartSpecB4,MPartNoB4,PUsageB4,PLevelB4,PLocationB4,MAINPARTB4,RefAltPartB4 As Label
        Dim PartSpec,MPartNo,PUsage,PLevel,PLocation,MAINPART,RefAltPart,MFG,MFGB4 As Label
        Dim PartDescB4,PartDesc As Textbox
        Dim ImgUpdate As ImageButton
        Dim FECNEffect As DropDownList
    
        For i = 0 To MyList.Items.Count - 1
            ImgUpdate = CType(MyList.Items(i).FindControl("ImgUpdate"), ImageButton)
            FECNEffectTemp = CType(MyList.Items(i).FindControl("FECNEffectTemp"), Label)
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
    
            FECNEffect = CType(MyList.Items(i).FindControl("FECNEffect"), DropDownList)
            FECNEffect.Items.FindByValue(trim(FecnEffectTemp.text)).Selected = True
    
            if trim(MPartNo.text) = "<NULL>" then MPartNo.text = "-"
            if trim(MPartNoB4.text) = "<NULL>" then MPartNoB4.text = "-"
            if trim(MainPartB4.text) = "-" then PartDescB4.text = "N/A"
            if trim(MainPartB4.text) <> "-" then PartDescB4.text = "Part #           : " & trim(MainPartB4.text) & vblf & "DESC/SPEC    : " & trim(PartDescB4.text) & " /(" & trim(PartSpecB4.text) & ")" & vblf & "MPN/MFG      : " & trim(MPartNoB4.text) & "/" & trim(mfgB4.text) & vblf & "Usage/Level  : " & cdec(PUsageB4.text) & " (" & trim(PLevelB4.text) & ")" & vblf & "Location        : " & trim(PLocationB4.text) & vblf & vblf & "Alt Part         : " & vblf & trim(RefAltPartB4.text)
            if trim(MainPart.text) = "-" then PartDesc.text = "N/A"
            if trim(MainPart.text) <> "-" then PartDesc.text = "Part #           : " & trim(MainPart.text) & vblf & "DESC/SPEC    : " & trim(PartDesc.text) & " /(" & trim(PartSpec.text) & ")" & vblf & "MPN/MFG      : " & trim(MPartNo.text) & "/" & trim(mfg.text) & vblf & "Usage/Level  : " & cdec(PUsage.text) & " (" & trim(PLevel.text) & ")" & vblf & "Location        : " & trim(PLocation.text) & vblf & vblf & "Alt Part         : " & vblf & trim(RefAltPart.text)
            RowNo = CType(MyList.Items(i).FindControl("RowNo"), Label)
            RowNo.text = i + 1
        Next
    End sub
    
    sub LoadFECNMain()
        Dim strSql as string
        strsql ="select * from FECN_M where Seq_no = '" & trim(request.params("ID")) & "';"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while result.read
            lblModelNoTemp.text= result("MODEL_NO")
            lblModelNo.text= result("MODEL_NO")
            lblModelNo.text= result("MODEL_NO") & " (" & ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc") & ")"
            lblPartListNo.text= result("PARTLIST_NO")
            lblBOMRev.text= result("BOM_REV")
            lblECNNo.text= result("ECN_NO")
            lblCustECNNo.text = result("CUST_ECN_NO")
            lblFECNNo.text = result("FECN_NO")
            lblFECNStatus.text = result("FECN_Status").toupper()
            lblSubmitRem.text = result("submit_rem").tostring
            lblPCBRevFrom.text = result("PCB_Rev_From").tostring
            lblPCBRevTo.text = result("PCB_Rev_To").tostring
    
            txtRem.text = result("App4_Rem").tostring
    
            if isdbnull(result("Submit_Date")) = false then
                lblSubmitBy.text= result("Submit_By").tostring
                lblSubmitDate.text= format(cdate(result("Submit_Date")),"dd/MM/yy")
            end if
    
            if isdbnull(result("App1_Date")) = false then
                lblApp1By.text= result("App1_By").tostring
                lblApp1Date.text= format(cdate(result("App1_Date")),"dd/MM/yy")
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
            if trim(result("Others1").tostring) = "Y" then chkOthers.checked = true
            if trim(result("Lead_Free").tostring) = "Y" then chkLeadFree.checked = true
            lblOthers.text = "Others, pls specify : " &  result("others").tostring
    
    
            if isdbnull(result("App4_Date")) = true then
                cmdSubmit.enabled = true
                lblRem.visible = true
                txtRem.visible = true
                rbApprove.visible = true
                rbReject.visible = true
    
            elseif isdbnull(result("App4_Date")) = false then
                cmdSubmit.enabled = false
                lblRem.visible = false
                txtRem.visible = false
                rbApprove.visible = false
                rbReject.visible = false
    
            end if
    
            if result("FECN_Status") = "REJECTED" then
                cmdSubmit.enabled = false
                lblRem.visible = false
                txtRem.visible = false
                rbApprove.visible = false
                rbReject.visible = false
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
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("FECNApp4.aspx")
    End Sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim MReceiver,MSender,CC,FECNStatus as string
            Dim i as integer
            Dim ImpQty,LotNo,QtyEffect As Textbox
            Dim SeqNo As Label
            Dim FECNEffect As dropdownlist
    
            UpdateFECNItem()
    
            if rbApprove.checked = true then
                ReqCOM.ExecuteNonQuery("Update FECN_M set App4_By = '" & trim(request.cookies("U_ID").value) & "',App4_Date = '" & now & "',App4_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App4_Status = 'Y' where fecn_no = '" & trim(lblFECNNo.text) & "';")
                MReceiver = ReqCOM.GetFieldVal("Select U_ID from authority where app_type = 'APP5' and module_name = 'FECN'","U_ID")
                MSender = trim(request.cookies("U_ID").value)
                GeneratePendingEmailList(MSender,MReceiver,CC,trim(lblFECNNo.text),"Y")
                ShowAlert ("FECN sumbitted for further approval.")
                redirectPage("FECNApp4Det.aspx?ID=" & Request.params("ID"))
            elseif rbReject.checked = true then
                ReqCOM.ExecuteNonQuery("Update FECN_M set App4_By = '" & trim(request.cookies("U_ID").value) & "',App4_Date = '" & now & "',App4_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App4_Status = 'N',FECN_Status = 'REJECTED' where fecn_no = '" & trim(lblFECNNo.text) & "';")
                MReceiver = trim(lblSubmitBy.text)
                MSender = trim(request.cookies("U_ID").value)
                CC = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp3By.text) & "';","Email")
                if trim(lblApp1By.text) <> "N/A" then CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp1By.text) & "';","Email")
                if trim(lblApp2By.text) <> "N/A" then CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp2By.text) & "';","Email")
                GeneratePendingEmailList(MSender,MReceiver,CC,trim(lblFECNNo.text),"N")
                ShowAlert ("Selected FECN has been rejected")
                redirectPage("FECNApp4Det.aspx?ID=" & Request.params("ID"))
            End if
        end if
    End Sub
    
        Sub GeneratePendingEmailList(Sender as string, Receiver as string,CC as string,DOcNo as string,SSERStat as string)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim FromEmail,ToEmail,EmailSubject,EmailContent as string
    
            if SSERStat = "Y" then
                EmailContent = "Dear " & trim(Receiver) & vblf & vblf & vblf
                EmailContent = EmailContent + "There is a New FECN pending for your approval." & vblf & vblf & vblf
                EmailContent = EmailContent + "FECN Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
                EmailContent = EmailContent + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=FECNApp5Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from FECN_M where FECN_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
                EmailContent = EmailContent + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
                EmailContent = EmailContent + "Regards," & vblf & vblf
                EmailContent = EmailContent + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
    
                EmailSubject = "FECN Approval : " & trim(DOcNo) & " (Model No : " & trim(lblModelNo.text) & ")"
    
                FromEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Sender) & "';","Email")
                ToEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Receiver) & "';","Email")
    
                ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','FECN','N','" & trim(DOcNo) & "','" & trim(CC) & "'")
            Elseif SSERStat = "N" then
                EmailContent = "Dear " & trim(Receiver) & vblf & vblf & vblf
                EmailContent = EmailContent + "There is rejected FECN." & vblf & vblf & vblf
                EmailContent = EmailContent + "FECN Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
                EmailContent = EmailContent + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
                EmailContent = EmailContent + "Regards," & vblf & vblf
                EmailContent = EmailContent + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
                EmailSubject  = "FECN Rejected : " & DOcNo
                FromEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Sender) & "';","Email")
                ToEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Receiver) & "';","Email")
    
                ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','FECN','N','" & trim(DOcNo) & "','" & trim(CC) & "'")
            end if
        End sub
    
    Sub ShowAlert(Msg as string)
          Dim strScript as string
          strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
       If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
       End sub
    
       Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from fecn_ATTACHMENT where fecn_NO = '" & trim(lblfecnNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"fecn_ATTACHMENT")
        dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("fecn_ATTACHMENT").DefaultView
        dtgUPASAttachment.DataBind()
    end sub
    
    Sub ShowSelection(s as object,e as DataListCommandEventArgs)
        Dim MainPartB4, MainPart as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim ImpQty As Textbox = CType(e.Item.FindControl("ImpQty"), Textbox)
        Dim LotNo As Textbox = CType(e.Item.FindControl("LotNo"), Textbox)
        Dim QtyEffect As Textbox = CType(e.Item.FindControl("QtyEffect"), Textbox)
        Dim FECNEffect As dropdownlist = CType(e.Item.FindControl("FECNEffect"), dropdownlist)
        Dim RowNo As Label = CType(e.Item.FindControl("RowNo"), Label)
    
    
        if ucase(e.commandArgument) = "VIEW" then
            MainPartB4 = ReqCOM.GetFieldVal("Select Main_Part_B4 from FECN_D where Seq_No = " & clng(SeqNo.text) & ";","Main_Part_B4")
            if mainPartB4 = "<NULL>" or mainPartB4 = "-"  then mainPartB4 = "-"
            MainPart = ReqCOM.GetFieldVal("Select Main_Part from FECN_D where Seq_No = " & clng(SeqNo.text) & ";","Main_Part")
            if MainPart = "<NULL>" or MainPart = "-"  then MainPart = "-"
            ShowReport("PopupFECNStockStatus.aspx?MainPartB4=" & trim(MainPartB4) & "&MainPart=" & trim(MainPart) & "&ModelNo=" & trim(ReqCOM.GetFIeldVal("Select Model_No from FECN_M where fecn_no = '" & trim(lblFECNNo.text) & "';","Model_No")))
        elseif ucase(e.commandArgument) = "UPDATE" then
            if trim(LotNo.text) <> "" then
                if ReqCOm.FuncCheckDuplicate("Select top 1 Lot_No from SO_Models_M where lot_no = '" & trim(LotNo.text) & "';","Lot_No") = false then ShowAlert("Error on item " & clng(RowNo.text) & "\n\nLot No does not exist.") : exit sub
                if ReqCOm.FuncCheckDuplicate("select lot_no from so_models_m where lot_no = '" & trim(LotNo.text) & "' and model_no = '" & trim(lblModelNoTemp.text) & "';","Lot_No") = false then ShowAlert("Error on item " & clng(RowNo.text) & "\n\nModel No in Sales order does not match with this lot no.") : exit sub
            End if
    
            if trim(QtyEffect.text) = "" then QtyEffect.text = "0"
            if trim(LotNo.text) = "" then ReqCOM.ExecuteNonQuery("Update FECN_D set FECN_Effect='" & trim(FECNEffect.selecteditem.value) & "',Qty_Effect=" & QtyEffect.text & ",Imp_Qty = " & ImpQty.text & ",lot_no = null where Seq_No = " & SeqNo.text & ";")
            if trim(LotNo.text) <> "" then ReqCOM.ExecuteNonQuery("Update FECN_D set FECN_Effect='" & trim(FECNEffect.selecteditem.value) & "',Qty_Effect=" & QtyEffect.text & ",Imp_Qty = " & ImpQty.text & ",lot_No = '" & trim(LotNo.text) & "' where Seq_No = " & SeqNo.text & ";")
            Response.redirect("FECNApp4Det.aspx?ID=" & Request.params("ID"))
        End if
    end sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=550,height=500');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            UpdateFECNItem()
            Response.redirect("FECNApp4Det.aspx?ID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub UpdateFECNItem()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim PartDet as string
        Dim i As Integer
        Dim FECNEffectTemp,ETADate,MinOrderQty,StdPackQty,UP,QtyToBuy,ReqQty,Diff,Amt,RowNo As Label
        Dim PartSpecB4,MPartNoB4,PUsageB4,PLevelB4,PLocationB4,MAINPARTB4,RefAltPartB4 As Label
        Dim PartSpec,MPartNo,PUsage,PLevel,PLocation,MAINPART,RefAltPart,SeqNo As Label
        Dim PartDescB4,PartDesc,LotNo,ImpQty,QtyEffect As Textbox
        Dim ImgUpdate As ImageButton
        Dim FECNEffect As DropDownList
    
        'SAVE ITEM IF NO ERROR FOUND
        For i = 0 To MyList.Items.Count - 1
            FECNEffect = CType(MyList.Items(i).FindControl("FECNEffect"), DropDownList)
            QtyEffect = CType(MyList.Items(i).FindControl("QtyEffect"), textbox)
            SeqNo = CType(MyList.Items(i).FindControl("SeqNo"), Label)
            LotNo = CType(MyList.Items(i).FindControl("LotNo"), textbox)
            if trim(LotNo.text) = "" then ReqCOM.ExecuteNonQuery("Update FECN_D set FECN_Effect='" & trim(FECNEffect.selecteditem.value) & "',Qty_Effect=" & QtyEffect.text & ",lot_No = null where Seq_No = " & SeqNo.text & ";")
            if trim(LotNo.text) <> "" then ReqCOM.ExecuteNonQuery("Update FECN_D set FECN_Effect='" & trim(FECNEffect.selecteditem.value) & "',Qty_Effect=" & QtyEffect.text & ",lot_No = '" & trim(LotNo.text) & "' where Seq_No = " & SeqNo.text & ";")
        Next
        ReqCOM.ExecuteNonQuery("Update FECN_M set App4_Rem = '" & trim(replace(txtRem.text,"'","`")) & "' where fecn_no = '" & trim(lblFECNNo.text) & "';")
    End sub
    
    Sub ValLotNo_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim RowNo As Label
        Dim LotNo As Textbox
        Dim i as integer
    
        e.isvalid = true
        For i = 0 To MyList.Items.Count - 1
            LotNo = CType(MyList.Items(i).FindControl("LotNo"), Textbox)
            RowNo = CType(MyList.Items(i).FindControl("RowNo"), Label)
    
            if trim(LotNo.text) <> "" then
                if ReqCOm.FuncCheckDuplicate("Select top 1 Lot_No from SO_Models_M where lot_no = '" & trim(LotNo.text) & "';","Lot_No") = false then ValLotNo.errorMessage = "Error on item " & clng(RowNo.text) & ". Lot No does not exist." : e.isvalid = false :Exit sub
                if ReqCOm.FuncCheckDuplicate("select lot_no from so_models_m where lot_no = '" & trim(LotNo.text) & "' and model_no = '" & trim(lblModelNoTemp.text) & "';","Lot_No") = false then ValLotNo.errorMessage="Error on item " & clng(RowNo.text) & ". Model No in Sales order does not match with this lot no." : e.isvalid = false :Exit sub
            End if
        Next
    End Sub
    
    Sub cmdAddAtt_Click(sender As Object, e As EventArgs)
        Response.redirect ("FECNAttachment.aspx?ID=" & request.params("ID") & "&ReturnURL=FECNApp4Det.aspx?ID=" & request.params("ID"))
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
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
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
                                                    <asp:CustomValidator id="ValLotNo" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="" EnableClientScript="False" OnServerValidate="ValLotNo_ServerValidate" Width="100%" CssClass="ErrorText"></asp:CustomValidator>
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
                                                                                    <asp:CheckBox id="chkToGTT" runat="server" CssClass="OutputText" Text="E-Mail to GTT Document Control (Chien@gtek.com.tw,sandy@gtek.com.tw,doc@gtek.com.tw)" Enabled="False"></asp:CheckBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width="25%" bgcolor="silver">
                                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">FECN No</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblFECNNo" runat="server" cssclass="OutputText" width="" font-size="Larger" font-bold="True"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="">Model No/Description</asp:Label></td>
                                                                                <td>
                                                                                    <p align="left">
                                                                                        <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" font-size="Larger" font-bold="True"></asp:Label><asp:Label id="lblModelNoTemp" runat="server" cssclass="OutputText" font-size="Larger" font-bold="True"></asp:Label>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="116px">PCBA Rev
                                                                                    From</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPCBRevFrom" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal" width="116px">PCBA Rev
                                                                                    To</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPCBRevTo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="116px">ECN No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblECNNo" runat="server" cssclass="OutputText" width="116px"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="">Cust. ECN No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblCustECNNo" runat="server" cssclass="OutputText" width="116px"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="126px">Partlist
                                                                                    No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblPartListNo" runat="server" cssclass="OutputText" width="116px"></asp:Label>
                                                                                    </div>
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
                                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="124px">Reason
                                                                                    of change</asp:Label></td>
                                                                                <td>
                                                                                    <asp:CheckBox id="chkCustReq" runat="server" CssClass="OutputText" Text="Customer Request" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkDesignChange" runat="server" CssClass="OutputText" Text="Design Change" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkCostDown" runat="server" CssClass="OutputText" Text="Cost Down" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkNoSource" runat="server" CssClass="OutputText" Text="No Source" Enabled="False"></asp:CheckBox>
                                                                                    &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                    <asp:CheckBox id="chkLeadFree" runat="server" CssClass="OutputText" Text="Lead Free" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkSimplifyProcess" runat="server" CssClass="OutputText" Text="Simplify Process" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkOthers" runat="server" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    &nbsp;<asp:Label id="lblOthers" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="124px">FECN Status</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblFECNStatus" runat="server" cssclass="OutputText" width="260px"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver" rowspan="2">
                                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="124px">Submit
                                                                                    By/Date/Remarks</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                                    -&nbsp; <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblSubmitRem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                                                                    <asp:Label id="lblApp6Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="#8080ff">
                                                                    <p align="center">
                                                                    </p>
                                                                </td>
                                                                <td width="40%">
                                                                    <p align="center">
                                                                        <asp:Label id="Label11" runat="server" cssclass="SectionHeader" width="100%">FECN
                                                                        ATTACHMENT</asp:Label>
                                                                    </p>
                                                                </td>
                                                                <td bgcolor="#8080ff">
                                                                    <p align="right">
                                                                        <asp:Button id="cmdAddAtt" onclick="cmdAddAtt_Click" runat="server" CssClass="OutputText" Text="Add/Edit Attachment" CausesValidation="False"></asp:Button>
                                                                        &nbsp;&nbsp; 
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <table class="sideboxnotop" style="HEIGHT: 13px" width="100%" align="center">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged" PageSize="50" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" AutoGenerateColumns="False" cellpadding="4" BorderColor="Gray">
                                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                                            <Columns>
                                                                                                <asp:TemplateColumn Visible="False">
                                                                                                    <ItemTemplate>
                                                                                                        <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                                                                    </ItemTemplate>
                                                                                                </asp:TemplateColumn>
                                                                                                <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                                <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                                                                                <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                                                                                <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadFECNAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                                            </Columns>
                                                                                        </asp:DataGrid>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center">
                                                                        <div align="center"><asp:Label id="Label12" runat="server" cssclass="SectionHeader" width="100%">FECN
                                                                            DETAILS</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <table class="sideboxnotop" style="HEIGHT: 13px" width="100%" align="center">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:DataList id="MyList" runat="server" Width="100%" OnSelectedIndexChanged="MyList_SelectedIndexChanged" Font-Names="Arial" Font-Size="XX-Small" RepeatColumns="1" BorderWidth="0px" CellPadding="1" Height="101px" OnItemCommand="ShowSelection">
                                                                                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                                            <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                                                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                                            <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                                            <ItemTemplate>
                                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                    <tr>
                                                                                                        <td></td>
                                                                                                        <td bgcolor="silver">
                                                                                                            <asp:Label id= "LabelAct" runat="server" cssclass="OutputText" text= "Action" /> 
                                                                                                        </td>
                                                                                                        <td bgcolor="silver">
                                                                                                            <asp:Label id= "Label1" runat="server" cssclass="OutputText" text= "Type of change" /> 
                                                                                                        </td>
                                                                                                        <td bgcolor="silver">
                                                                                                            <asp:Label id= "Label2" runat="server" cssclass="OutputText" text= "Implementation" /> 
                                                                                                        </td>
                                                                                                        <td bgcolor="silver">
                                                                                                            <asp:Label id= "Label3" runat="server" cssclass="OutputText" text= "After Lot" /> 
                                                                                                        </td>
                                                                                                        <td bgcolor="silver">
                                                                                                            <asp:Label id= "Label5" runat="server" cssclass="OutputText" text= "Fecn Effect" /> 
                                                                                                        </td>
                                                                                                        <td bgcolor="silver">
                                                                                                            <asp:Label id= "Label6" runat="server" cssclass="OutputText" text= "Qty Effected" /> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <asp:Label id="RowNo" visible="true" runat="server" cssclass="ErrorText" text='11' /> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:ImageButton id="ImgView" ToolTip="View item details" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:Label id="typechange" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "TYPE_CHANGE") %>'></asp:Label> 
                                                                                                            <asp:CheckBox id="Remove" runat="server" visible= "false" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:Label id="ImpType" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "imp_type") %>'></asp:Label> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:textbox id="LotNo" Width="100%" CssClass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>'></asp:textbox>
                                                                                                            <asp:Label id="FECNEffectTemp" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FECN_EFFECT") %>'></asp:Label> <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>'></asp:Label> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:DropDownList id="FECNEffect" CssClass="OutputText" runat="server" Width="100%">
                                                                                                                <asp:ListItem Value="-">-</asp:ListItem>
                                                                                                                <asp:ListItem Value="DEAD">Dead</asp:ListItem>
                                                                                                                <asp:ListItem Value="SCRAP">Scrap</asp:ListItem>
                                                                                                                <asp:ListItem Value="EXTRA">Extra</asp:ListItem>
                                                                                                            </asp:DropDownList>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:textbox id="QtyEffect" Width="100%" CssClass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "qty_effect") %>'></asp:textbox>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                    <tr>
                                                                                                        <td></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="2">
                                                                                                            <span class="ListLabel">Reason of change : </span> <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "REASON_CHANGE") %> </span> 
                                                                                                            <ItemTemplate></ItemTemplate>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                    <tr>
                                                                                                        <td valign="top" width= "10%">
                                                                                                            <span class="OutputText">Before </span> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:textbox id="PartDescB4" CssClass="ListOutput" runat="server" width= "100%" height="150px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "PART_DESC_B4") %>'></asp:textbox>
                                                                                                            <asp:Label id="MAINPARTB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART_B4") %>'></asp:Label> <asp:Label id="PUSAGEB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_USAGE_B4") %>'></asp:Label> <asp:Label id="PLOCATIONB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LOCATION_B4") %>'></asp:Label> <asp:Label id="PartSpecB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_SPEC_B4") %>'></asp:Label> <asp:Label id="PLEVELB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LEVEL_B4") %>'></asp:Label> <asp:Label id="MPARTNOB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_PART_NO_B4") %>'></asp:Label> <asp:Label id="RefAltPartB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ref_Alt_B4") %>'></asp:Label> <asp:Label id="MFGB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG_B4") %>'></asp:Label> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td valign="top">
                                                                                                            <span class="OutputText">After</span> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:textbox id="PartDesc" CssClass="ListOutput" runat="server" width= "100%" height="150px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "PART_DESC") %>'></asp:textbox>
                                                                                                            <asp:Label id="MAINPART" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART") %>'></asp:Label> <asp:Label id="PUSAGE" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_USAGE") %>'></asp:Label> <asp:Label id="PLOCATION" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LOCATION") %>'></asp:Label> <asp:Label id="PartSpec" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_SPEC") %>'></asp:Label> <asp:Label id="PLEVEL" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LEVEL") %>'></asp:Label> <asp:Label id="MPARTNO" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_PART_NO") %>'></asp:Label> <asp:Label id="RefAltPart" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ref_Alt") %>'></asp:Label> <asp:Label id="MFG" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG") %>'></asp:Label> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </ItemTemplate>
                                                                                            <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                                        </asp:DataList>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Label id="lblRem" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                                                                <td width="55%">
                                                                    <asp:TextBox id="txtRem" runat="server" Width="100%" CssClass="OutputText" Height="56px" TextMode="MultiLine"></asp:TextBox>
                                                                </td>
                                                                <td width="20%">
                                                                    <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:RadioButton id="rbApprove" runat="server" CssClass="OutputText" Text="Approve" GroupName="Status"></asp:RadioButton>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:RadioButton id="rbReject" runat="server" CssClass="OutputText" Text="Reject" GroupName="Status"></asp:RadioButton>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="123px" Text="Submit"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="188px" Text="Update FECN Details"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="133px" Text="Back"></asp:Button>
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
    </form>
</body>
</html>