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
        cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this FECN ?')==false) return false;")
        If Page.IsPostBack = false Then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            LoadFECNMain()
            LoadFECNDet()
            ProcLoadGridData()
            FormatRow
        end if
    End Sub
    
    
    
    sub LoadFECNMain()
        Dim strSql as string
        strsql ="select * from FECN_M where Seq_no = '" & trim(request.params("ID")) & "';"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while result.read
            lblModelNo.text= result("MODEL_NO")
            lblModelNo.text= result("MODEL_NO") & " (" & ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc") & ")"
            lblPartListNo.text= result("PARTLIST_NO")
            lblBOMRev.text= result("BOM_REV")
            lblECNNo.text= result("ECN_NO")
            lblCustECNNo.text = result("CUST_ECN_NO")
            lblFECNNo.text = result("FECN_NO")
            lblSubmitRem.text = result("Submit_Rem").tostring
            lblFECNStatus.text = result("FECN_Status").toupper()
            lblPCBRevFrom.text = result("PCB_Rev_From").tostring
            lblPCBRevTo.text = result("PCB_Rev_To").tostring
    
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
    
            if result("TO_GTT_MGT").tostring = "Y" then chkToGTTMgt.checked = true
            if result("TO_GTT_MGT").tostring = "N" then chkToGTTMgt.checked = false
    
    
            if trim(result("Cust_Req").tostring) = "Y" then chkCustReq.checked = true
            if trim(result("DESIGN_cHANGE").tostring) = "Y" then chkDesignChange.checked = true
            if trim(result("COST_DOWN").tostring) = "Y" then chkCostDown.checked = true
            if trim(result("NO_SOURCE").tostring) = "Y" then chkNoSource.checked = true
            if trim(result("SIMPLIFY_PROCESS").tostring) = "Y" then chkSimplifyProcess.checked = true
            if trim(result("Lead_Free").tostring) = "Y" then chkLeadFree.checked = true
    
            if trim(result("Others1").tostring) = "Y" then chkOthers.checked = true
    
            txtOthers.text = result("others").tostring
    
            if isdbnull(result("App5_Date")) = true then
                cmdSubmit.enabled = true
                lblRem.visible = true
                txtRem.visible = true
                rbApprove.visible = true
                rbReject.visible = true
            elseif isdbnull(result("App5_Date")) = false then
                cmdSubmit.enabled = false
                lblRem.visible = false
                txtRem.visible = false
                rbApprove.visible = false
                rbReject.visible = false
            end if
        loop
    end sub
    
    Sub FormatRow()
        Dim PartDet as string
        Dim i As Integer
        Dim ETADate,MinOrderQty,StdPackQty,UP,QtyToBuy,ReqQty,Diff,Amt,RowNo As Label
        Dim PartSpecB4,MPartNoB4,PUsageB4,PLevelB4,PLocationB4,MAINPARTB4,RefAltPartB4 As Label
        Dim PartSpec,MPartNo,PUsage,PLevel,PLocation,MAINPART,RefAltPart,mfg,mfgb4 As Label
        Dim PartDescB4,PartDesc As Textbox
        Dim UPB4,AmountC,Amount as label
    
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
    
            if trim(MFG.text) = "<NULL>" then MFG.text = "-"
            if trim(MFGB4.text) = "<NULL>" then MFGB4.text = "-"
    
            if trim(MPartNo.text) = "<NULL>" then MPartNo.text = "-"
            if trim(MPartNoB4.text) = "<NULL>" then MPartNoB4.text = "-"
    
            if trim(MainPartB4.text) = "-" then PartDescB4.text = "N/A"
            if trim(MainPartB4.text) <> "-" then PartDescB4.text = "Part #           : " & trim(MainPartB4.text) & vblf & "DESC/SPEC    : " & trim(PartDescB4.text) & " /(" & trim(PartSpecB4.text) & ")" & vblf & "MPN/MFG       : " & trim(MPartNoB4.text) & "/" & trim(MFGB4.text) & vblf & "Usage/Level  : " & cdec(PUsageB4.text) & " (" & trim(PLevelB4.text) & ")" & vblf & "Location        : " & trim(PLocationB4.text) & vblf & vblf & "Alt Part         : " & vblf & trim(RefAltPartB4.text)
    
            if trim(MainPart.text) = "-" then PartDesc.text = "N/A"
            if trim(MainPart.text) <> "-" then PartDesc.text = "Part #           : " & trim(MainPart.text) & vblf & "DESC/SPEC    : " & trim(PartDesc.text) & " /(" & trim(PartSpec.text) & ")" & vblf & "MPN/MFG       : " & trim(MPartNo.text) & "/" & trim(mfg.text) & vblf & "Usage/Level  : " & cdec(PUsage.text) & " (" & trim(PLevel.text) & ")" & vblf & "Location        : " & trim(PLocation.text) & vblf & vblf & "Alt Part         : " & vblf & trim(RefAltPart.text)
    
            AmountC  = Ctype(MyList.Items(i).FindControl("AmountC"), label)
            UPB4  = Ctype(MyList.Items(i).FindControl("UPB4"), label)
            PUsageB4  = Ctype(MyList.Items(i).FindControl("PUsageB4"), label)
            RowNo = CType(MyList.Items(i).FindControl("RowNo"), Label)
            RowNo.text = i + 1
    
            if UPB4.text <> "" and PUsageB4.text <> "" then
                AmountC.text = "(Amount : " & format(cdec(UPB4.text) * cdec(PUsageB4.text),"##,##0.0000") & ")"
            End if
    
    
            Amount  = Ctype(MyList.Items(i).FindControl("Amount"), label)
            UP  = Ctype(MyList.Items(i).FindControl("UP"), label)
            PUsage  = Ctype(MyList.Items(i).FindControl("PUsage"), label)
            if UP.text <> "" and PUsage.text <> "" then
                Amount.text = "(Amount : " & format(cdec(UP.text) * cdec(PUsage.text),"##,##0.0000") & ")"
            End if
        next
    end sub
    
    
    sub LoadFECNDet()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        Dim strSql as string
    
        ReqCom.executeNonQuery("update fecn_d set fecn_d.up = part_master.std_cost_rd from part_master,fecn_d where fecn_d.main_part = part_master.part_no and fecn_d.fecn_no = '" & trim(lblFECNNo.text) & "';")
        ReqCom.executeNonQuery("update fecn_d set fecn_d.up_b4 = part_master.std_cost_rd from part_master,fecn_d where fecn_d.main_part_b4 = part_master.part_no and fecn_d.fecn_no = '" & trim(lblFECNNo.text) & "';")
    
        strsql ="select * from FECN_D where FECN_No = '" & lblFecNNo.text & "' order by seq_no asc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("FECNApp5.aspx")
    End Sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub GenerateBOMComparisionHistory()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ModelNo as string = ReqCOM.GetFieldVal("Select Model_No from FECN_M where FECN_No = '" & trim(lblFECNNo.text) & "';","Model_No")
        Dim BomRev as decimal = ReqCOM.GetFieldVal("Select top 1 revision from bom_M where Model_No = '" & trim(ModelNo) & "' order by revision desc","revision")
        Dim strSql as string
        Dim rs as SqldataReader = ReqCom.ExeDataReader("Select * from FECN_D where FECN_No = '" & trim(lblFecNNo.text) & "';")
    
        ReqCOM.ExecuteNonQUery("Delete from fecn_bom_comparison_history where fecn_no = '" & trim(lblFECNNo.text) & "';")
        ReqCOM.ExecuteNonQuery ("insert into fecn_bom_comparison_history(MODEL_NO,PART_NO,P_LEVEL,P_USAGE,P_USAGE1,fecn_no) select MODEL_NO,PART_NO,P_LEVEL,P_USAGE,p_usage,'" & trim(lblFECNNo.text) & "' from bom_d where model_no = '" & trim(ModelNo) & "' and Revision = " & BomRev & ";")
        do while rs.read
            if trim(rs("TYPE_CHANGE")) = "Add Main Part" then
                Strsql = "insert into fecn_bom_comparison_history(MODEL_NO,PART_NO,P_USAGE,P_USAGE1,fecn_no) select '" & trim(ModelNo) & "',Main_Part,0,P_Usage,'" & trim(lblFECNNo.text) & "' from fecn_d where Seq_No = " & rs("Seq_No") & ";"
                reqCOM.ExecuteNonQuery(StrSql)
            end if
    
            if trim(rs("TYPE_CHANGE")) = "Remove Main Part" then
                StrSql = "Update FECN_BOM_COMPARISON_HISTORY set P_USAGE1 = 0 where Part_No = '" & trim(rs("main_Part_b4")) & "';"
                reqCOM.ExecuteNonQuery(StrSql)
            end if
    
            if trim(rs("TYPE_CHANGE")) = "Edit Main Part" then
                if trim(rs("main_part_b4")) = trim(rs("main_part")) then
                    StrSql = "Update FECN_BOM_COMPARISON_HISTORY set P_USAGE1 = " & RS("P_Usage") & " where Part_No = '" & trim(rs("main_Part")) & "';"
                    reqCOM.ExecuteNonQuery(StrSql)
                end if
    
                if trim(rs("main_part_b4")) <> trim(rs("main_part")) then
                    StrSql = "Update FECN_BOM_COMPARISON_HISTORY set P_USAGE1 = 0 where Part_No = '" & trim(rs("main_Part_b4")) & "';"
                    reqCOM.ExecuteNonQuery(StrSql)
                    StrSql = "Insert into FECN_BOM_COMPARISON_HISTORY(MODEL_NO,PART_NO,P_LEVEL,P_USAGE,Revision,P_USAGE1,FECN_No) "
                    StrSql = StrSql + "Select '" & trim(ModelNo) & "','" & trim(rs("main_Part")) & "','" & trim(rs("P_Level")) & "',0,0," & rs("P_Usage") & ",'" & trim(lblFECNNo.text) & "';"
                    reqCOM.ExecuteNonQuery(StrSql)
                end if
            end if
        loop
    
        ReqCOM.ExecuteNonQuery("update fecn_bom_comparison_HISTORY set fecn_bom_comparison_HISTORY.wac_cost = part_master.wac_cost,fecn_bom_comparison_HISTORY.std_cost = part_master.std_cost_rd from part_master,fecn_bom_comparison_HISTORY where part_master.part_no = fecn_bom_comparison_HISTORY.part_no and fecn_bom_comparison_HISTORY.fecn_no = '" & trim(lblFECNNo.text) & "';")
    
    End sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim MReceiver,MSender,CC,FECNStatus as string
        Dim ModelNo,ToGttMgt as string
    
        if page.isvalid = true then
            if rbApprove.checked = true then
                if chkToGTTMgt.checked = true then ToGttMgt = "Y"
                if chkToGTTMgt.checked = false then ToGttMgt = "N"
    
                ReqCOM.ExecuteNonQuery("Update FECN_M set To_Gtt_Mgt = '" & trim(ToGttMgt) & "',App5_By = '" & trim(request.cookies("U_ID").value) & "',App5_Date = '" & now & "',App5_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App5_Status = 'Y' where fecn_no = '" & trim(lblFECNNo.text) & "';")
                MReceiver = ReqCOM.GetFieldVal("Select U_ID from authority where app_type = 'APP6' and module_name = 'FECN'","U_ID")
                MSender = trim(request.cookies("U_ID").value)
    
                GeneratePendingEmailList(MSender, MReceiver,CC,trim(lblFECNNo.text),"Y")
    
                ModelNo = ucase(ReqCOM.GetFieldVal("Select Model_No from FECN_M where FECN_No = '" & trim(lblFECNNo.text) & "';","Model_No"))
    
                if ModelNo <> "COMMON" then GenerateBOMComparisionHistory()
    
                ShowAlert ("FECN sumbitted for further approval.")
                redirectPage("FECNApp5Det.aspx?ID=" & Request.params("ID"))
            elseif rbReject.checked = true then
                GenerateBOMComparisionHistory()
                ReqCOM.ExecuteNonQuery("Update FECN_M set App5_By = '" & trim(request.cookies("U_ID").value) & "',App5_Date = '" & now & "',App5_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App5_Status = 'N',FECN_Status = 'REJECTED' where fecn_no = '" & trim(lblFECNNo.text) & "';")
                MReceiver = trim(lblSubmitBy.text)
                MSender = trim(request.cookies("U_ID").value)
    
                CC = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp4By.text) & "';","Email")
                CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp1By.text) & "';","Email")
                if trim(lblApp1By.text) <> "N/A" then CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp1By.text) & "';","Email")
                if trim(lblApp2By.text) <> "N/A" then CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp2By.text) & "';","Email")
    
                GeneratePendingEmailList(MSender, MReceiver,CC,trim(lblFECNNo.text),"N")
    
                ShowAlert ("Selected FECN has been rejected.")
                redirectPage("FECNApp5Det.aspx?ID=" & Request.params("ID"))
            end if
        end if
    End Sub
    
    Sub GeneratePendingEmailList(Sender as string, Receiver as string,CC as string,DOcNo as string,SSERStat as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim FromEmail,ToEmail,EmailSubject,EmailContent as string
    
        if SSERStat = "Y" then
            EmailContent = "Dear " & trim(Receiver) & vblf & vblf & vblf
            EmailContent = EmailContent + "There is a New FECN pending for your approval." & vblf & vblf & vblf
            EmailContent = EmailContent + "FECN Reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
            EmailContent = EmailContent + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=FECNApp6Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from FECN_M where FECN_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
            EmailContent = EmailContent + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            EmailContent = EmailContent + "Regards," & vblf & vblf
            EmailContent = EmailContent + trim(Sender) & vblf & vblf
    
            EmailSubject = "FECN Approval : " & DOcNo & " (Model No : " & trim(lblModelNo.text) & ")"
    
    
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
    
            EmailSubject = "FECN Rejected : " & trim(DOcNo)
    
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
    
    Sub cmdBomCost_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ModelNo as string = ReqCOM.GetFieldVal("Select Model_No from FECN_M where FECN_No = '" & trim(lblFECNNo.text) & "';","Model_No")
        Dim BomRev as decimal
    
        if trim(ModelNo) <> "COMMON" then BomRev = ReqCOM.GetFieldVal("Select top 1 revision from bom_M where Model_No = '" & trim(ModelNo) & "' order by revision desc","revision")
    
            Dim strSql as string
        Dim rs as SqldataReader = ReqCom.ExeDataReader("Select * from FECN_D where FECN_No = '" & trim(lblFecNNo.text) & "';")
        ReqCOM.ExecuteNonQuery ("TRUNCATE TABLE fecn_bom_comparison")
        ReqCOM.ExecuteNonQuery ("insert into fecn_bom_comparison(MODEL_NO,PART_NO,P_LEVEL,P_USAGE,P_USAGE1) select MODEL_NO,PART_NO,P_LEVEL,P_USAGE,p_usage from bom_d where model_no = '" & trim(ModelNo) & "' and Revision = " & BomRev & ";")
    
        do while rs.read
            if trim(rs("TYPE_CHANGE")) = "Add Main Part" then
                Strsql = "insert into fecn_bom_comparison(MODEL_NO,PART_NO,P_USAGE,P_USAGE1) select '" & trim(ModelNo) & "',Main_Part,0,P_Usage from fecn_d where Seq_No = " & rs("Seq_No") & ";"
                reqCOM.ExecuteNonQuery(StrSql)
            end if
    
            if trim(rs("TYPE_CHANGE")) = "Remove Main Part" then
                StrSql = "Update FECN_BOM_COMPARISON set P_USAGE1 = 0 where Part_No = '" & trim(rs("main_Part_b4")) & "';"
                reqCOM.ExecuteNonQuery(StrSql)
            end if
    
            if trim(rs("TYPE_CHANGE")) = "Edit Main Part" then
                if trim(rs("main_part_b4")) = trim(rs("main_part")) then
                    StrSql = "Update FECN_BOM_COMPARISON set P_USAGE1 = " & RS("P_Usage") & " where p_level = '" & trim(rs("P_Level")) & "' and Part_No = '" & trim(rs("main_Part_B4")) & "';"
                    reqCOM.ExecuteNonQuery(StrSql)
                elseif trim(rs("main_part_b4")) <> trim(rs("main_part")) then
                    StrSql = "Update FECN_BOM_COMPARISON set P_USAGE1 = 0 where p_level = '" & trim(rs("P_Level")) & "' and Part_No = '" & trim(rs("main_Part_b4")) & "';"
                    reqCOM.ExecuteNonQuery(StrSql)
                    StrSql = "Insert into FECN_BOM_COMPARISON(MODEL_NO,PART_NO,P_LEVEL,P_USAGE,Revision,P_USAGE1) "
                    StrSql = StrSql + "Select '" & trim(ModelNo) & "','" & trim(rs("main_Part")) & "','" & trim(rs("P_Level")) & "',0,0," & rs("P_Usage") & ";"
                    reqCOM.ExecuteNonQuery(StrSql)
                end if
            end if
        loop
        ShowReport("PopupReportViewer.aspx?RptName=FECNBOMCost")
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub ShowDetails(s as object,e as DataListCommandEventArgs)
        Dim PartNo As Label = CType(e.Item.FindControl("MAINPARTB4"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim Script As New System.Text.StringBuilder
        Dim StrSql as string
    
        if e.commandArgument = "BOMCostRD" then
            UpdateLatestBOMRev(PartNo.text)
            UpdateBOMCost
            Script.Append("<script language=javascript>")
            Script.Append("pupUp=window.open('PopUpBOMCostRD.aspx?PartNo=" & trim(PartNo.text) & "&FECNNo=" & trim(lblFECNno.text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=700,height=250');")
            Script.Append("</script" & ">")
            RegisterStartupScript("BOMCost", Script.ToString())
        elseif e.commandArgument = "BOMCostWAC" then
            UpdateLatestBOMRev(PartNo.text)
            UpdateBOMWACCost
            Script.Append("<script language=javascript>")
            Script.Append("pupUp=window.open('PopUpBOMWACCost.aspx?PartNo=" & trim(PartNo.text) & "&FECNNo=" & trim(lblFECNno.text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=700,height=250');")
            Script.Append("</script" & ">")
            RegisterStartupScript("BOMCost", Script.ToString())
        end if
    end sub
    
    Sub UpdateLatestBOMRev(PartNo as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rs as SQLDataReader
        Dim cnn As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ModelNo as string = ReqCOM.GetFieldVal("Select Model_No from FECN_M where FECN_No = '" & trim(lblFECNNo.text) & "';","Model_No")
        ReqCOM.ExecuteNonQuery("Update BOM_M set Ind = 'N'")
        ReqCOM.ExecuteNonQuery("Update BOM_M set ind = 'Y' from BOM_M, BOM_D where BOM_D.Part_No = '" & trim(PartNo) & "' and BOM_M.Model_No = BOM_D.Model_No and BOM_M.Revision = BOM_D.Revision")
        ReqCOM.ExecuteNonQuery("Update BOM_M set Ind = 'Y' where Model_No = '" & trim(ModelNo) & "';")
        cnn.Open()
        Dim cmd As SqlCommand = New SqlCommand("Select * from BOM_M where ind = 'Y'", cnn )
        rs = cmd.ExecuteReader(CommandBehavior.CloseConnection)
    
        Do while rs.read
            ReqCOm.ExecutenonQuery("Update BOM_M set Ind = 'N' where ind = 'Y' and Model_No = '" & trim(rs("Model_No")) & "' and Revision < " & rs("Revision") & ";")
        Loop
    
        cmd.dispose()
        rs.close()
        cnn.Close()
        cnn.Dispose()
    End sub
    
    Sub UpdateBOMCost()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        StrSql = "Update BOM_D set bom_d.part_up_rpt = part_master.std_cost_rd from part_master where part_master.part_no = bom_d.part_no"
        ReqCOM.executeNonQuery(StrSql)
    End sub
    
    Sub UpdateBOMWACCost()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
    
        StrSql = "Update BOM_D set bom_d.part_up_rpt = part_master.WAC_Cost from part_master where part_master.part_no = bom_d.part_no"
        ReqCOM.executeNonQuery(StrSql)
    End sub
    
    Sub cmdViewHistory_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=FECNBOMCostHistory&FECNNo=" & trim(lblFECNNo.text))
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
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <asp:CheckBox id="chkToGTTMgt" runat="server" Text="E-Mail to GTT (Ms Regina)" CssClass="OutputText"></asp:CheckBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <asp:CheckBox id="chkToGTT" runat="server" Text="E-Mail to GTT Document Control (Chien@gtek.com.tw,sandy@gtek.com.tw,doc@gtek.com.tw)" CssClass="OutputText" Enabled="False"></asp:CheckBox>
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
                                                                                        <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="423px" font-size="Larger" font-bold="True"></asp:Label>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="116px">PCBA Rev.
                                                                                    From</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPCBRevFrom" runat="server" cssclass="OutputText" width="423px"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal" width="116px">PCBA Rev.
                                                                                    To</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPCBRevTo" runat="server" cssclass="OutputText" width="423px"></asp:Label></td>
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
                                                                                    <asp:CheckBox id="chkCustReq" runat="server" Text="Customer Request" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkDesignChange" runat="server" Text="Design Change" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkCostDown" runat="server" Text="Cost Down" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkNoSource" runat="server" Text="No Source" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                    <asp:CheckBox id="chkLeadFree" runat="server" Text="Lead Free" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    &nbsp;<asp:CheckBox id="chkSimplifyProcess" runat="server" Text="Simplify Process" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkOthers" runat="server" Text="Others, pls specify" CssClass="OutputText" Enabled="False"></asp:CheckBox>
                                                                                    <asp:TextBox id="txtOthers" runat="server" CssClass="OutputText" Enabled="False" Width="433px" TextMode="MultiLine"></asp:TextBox>
                                                                                </td>
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
                                                <p align="center">
                                                    <asp:Label id="Label11" runat="server" cssclass="SectionHeader" width="96%">FECN ATTACHMENT</asp:Label> 
                                                    <table class="sideboxnotop" style="HEIGHT: 13px" width="96%" align="center">
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
                                                                                <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadFECNAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 27px" cellspacing="0" cellpadding="0" width="96%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center"><asp:Label id="Label12" runat="server" cssclass="SectionHeader" width="100%">FECN
                                                                        DETAILS</asp:Label>
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
                                                                                        <asp:DataList id="MyList" runat="server" Width="100%" OnSelectedIndexChanged="MyList_SelectedIndexChanged" OnItemCommand="ShowDetails" Font-Names="Arial" Font-Size="XX-Small" RepeatColumns="1" BorderWidth="0px" CellPadding="1" Height="101px">
                                                                                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                                            <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                                                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                                            <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                                            <ItemTemplate>
                                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <asp:Label id="RowNo" visible="true" cssclass="ErrorText" runat="server" text='11' /> <span class="ListLabel"> 
                                                                                                            <asp:LinkButton id="Edit1" CommandArgument='BOMCostRD' runat="server" Font-Size="X-Small" cssclass="OutputText">BOM Cost (R&D Std. Cost)</asp:LinkButton>
                                                                                                            </span> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:LinkButton id="Edit2" CommandArgument='BOMCostWAC' runat="server" Font-Size="X-Small" cssclass="OutputText">BOM Cost (WAC Cost)</asp:LinkButton>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <span class="ListLabel">Type Of Changes : </span><span class="ListOutput"><asp:Label id="typechange" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "TYPE_CHANGE") %>'></asp:Label> </span> 
                                                                                                            <asp:CheckBox id="Remove" runat="server" visible= "false" />
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <span class="ListLabel">Implementation : </span><span class="ListOutput"></span> <asp:Label id="ImpType" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "imp_type") %>'></asp:Label> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <span class="ListLabel">After Lot : </span><span class="ListOutput"></span> <asp:Label id="LotNo" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>'></asp:Label> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <span class="ListLabel">Implementation Qty : </span> <asp:Label id="ImpQty" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "imp_qty") %>'></asp:Label> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <span class="ListLabel">Fecn Effect : </span><span class="ListOutput"></span> <asp:Label id="FECNEffect" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FECN_Effect") %>'></asp:Label> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <span class="ListLabel">Qty Effected : </span> <asp:Label id="QtyEffect" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "qty_effect") %>'></asp:Label> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="2">
                                                                                                            <span class="ListLabel">Reason of change : </span><span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "REASON_CHANGE") %> </span> <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <span class="ListLabel">Current Std. Cost (RM) : </span><span class="ListOutput"></span> <asp:Label id="UPB4" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP_B4") %>'></asp:Label><asp:Label id="PUsageB4" visible="false" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "p_usage_b4") %>'></asp:Label> <asp:Label id="AmountC" visible="true" cssclass="ListOutput" runat="server" ></asp:Label> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <span class="ListLabel">New Std. Cost (RM) : </span> <asp:Label id="UP" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>'></asp:Label> <asp:Label id="PUsage" cssclass="ListOutput" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") %>'></asp:Label> <asp:Label id="Amount" cssclass="ListOutput" runat="server" visible= "true" ></asp:Label> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                    <tr>
                                                                                                        <td valign="top">
                                                                                                            <span class="OutputText">Before </span> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:textbox id="PartDescB4" CssClass="ListOutput" runat="server" width= "700px" height="150px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "PART_DESC_B4") %>'></asp:textbox>
                                                                                                            <asp:Label id="MAINPARTB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART_B4") %>'></asp:Label> <asp:Label id="PUSAGEB41" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_USAGE_B4") %>'></asp:Label> <asp:Label id="PLOCATIONB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LOCATION_B4") %>'></asp:Label> <asp:Label id="PartSpecB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_SPEC_B4") %>'></asp:Label> <asp:Label id="PLEVELB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LEVEL_B4") %>'></asp:Label> <asp:Label id="MPARTNOB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_PART_NO_B4") %>'></asp:Label> <asp:Label id="RefAltPartB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ref_Alt_B4") %>'></asp:Label> <asp:Label id="MFGB4" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG_B4") %>'></asp:Label> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td valign="top">
                                                                                                            <span class="OutputText">After</span> 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:textbox id="PartDesc" CssClass="ListOutput" runat="server" width= "700px" height="150px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "PART_DESC") %>'></asp:textbox>
                                                                                                            <asp:Label id="MAINPART" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART") %>'></asp:Label> <asp:Label id="PUSAGE11" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_USAGE") %>'></asp:Label> <asp:Label id="PLOCATION" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LOCATION") %>'></asp:Label> <asp:Label id="PartSpec" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_SPEC") %>'></asp:Label> <asp:Label id="PLEVEL" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_LEVEL") %>'></asp:Label> <asp:Label id="MPARTNO" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_PART_NO") %>'></asp:Label> <asp:Label id="RefAltPart" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ref_Alt") %>'></asp:Label> <asp:Label id="MFG" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG") %>'></asp:Label> 
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
                                                                    <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="100%" TextMode="MultiLine" Height="56px" MaxLength="600"></asp:TextBox>
                                                                </td>
                                                                <td width="20%">
                                                                    <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:RadioButton id="rbApprove" runat="server" Text="Approve" CssClass="OutputText" GroupName="Status"></asp:RadioButton>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:RadioButton id="rbReject" runat="server" Text="Reject" CssClass="OutputText" GroupName="Status"></asp:RadioButton>
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
                                                                <td width="25%">
                                                                    <div align="left">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Text="Submit" Width="90%"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdBomCost" onclick="cmdBomCost_Click" runat="server" Text="View BOM Cost" Width="90%"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdViewHistory" onclick="cmdViewHistory_Click" runat="server" Text="BOM Cost History" Width="90%"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="90%"></asp:Button>
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
    <!-- Insert content here -->
</body>
</html>