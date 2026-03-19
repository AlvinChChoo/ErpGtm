<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="FECNAttachment" TagName="FECNAttachment" Src="_FECNAttachment_.ascx" %>
<%@ Register TagPrefix="FECNDet" TagName="FECNDet" Src="_FECNDet_.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
         cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this FECN ?')==false) return false;")
         If Page.IsPostBack = false Then LoadFECNMain()
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
            if trim(result("Others1").tostring) = "Y" then chkOthers.checked = true
            if trim(result("Lead_Free").tostring) = "Y" then chkLeadFree.checked = true
            txtOthers.text = result("others").tostring
    
            if isdbnull(result("App6_Date")) = true then
                cmdSubmit.visible = true
                lblRem.visible = true
                txtRem.visible = true
                rbApprove.visible = true
                rbReject.visible = true
            elseif isdbnull(result("App6_Date")) = false then
                cmdSubmit.visible = false
                lblRem.visible = false
                txtRem.visible = false
                rbApprove.visible = false
                rbReject.visible = false
            end if
        loop
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("FECNApp6.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim MReceiver,MSender,CC,ModelNo as string
    
        ModelNo = ReqCOM.GetFieldVal("Select Model_No from FECN_M where fecn_no = '" & trim(lblFECNNo.text) & "';","Model_No")
    
        if rbApprove.checked = true then
            MReceiver = TRIM(lblSubmitBy.text)
            MSender = trim(request.cookies("U_ID").value)
    
            CC = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "'","Email")
            CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp5By.text) & "'","Email")
            CC = CC & ";tancy@g-tek.com.my;AngSN@g-tek.com.my"
            CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp3By.text) & "'","Email")
            CC = CC & ";gohpg@g-tek.com.my;chamyl@g-tek.com.my;shanthi@g-tek.com.my;chusv@g-tek.com.my;khawlc@g-tek.com.my;leongcc@g-tek.com.my;angsn@g-tek.com.my;horkp@g-tek.com.my;tancy@g-tek.com.my;soonmk@g-tek.com.my;noraini@g-tek.com.my;tangh@g-tek.com.my;cheahcs@g-tek.com.my;tanst@g-tek.com.my;bokjh@g-tek.com.my;alvin@g-tek.com.my"
            if chkToGTT.checked = true then CC = CC & ";Chien@gtek.com.tw;sandy@gtek.com.tw;doc@gtek.com.tw"
    
            if chkToGTTMgt.checked = true then CC = CC & ";rk@gtek.com.tw"
            if trim(lblApp2By.text) <> "N/A" then CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp2By.text) & "'","Email")
            if trim(lblApp1By.text) <> "N/A" then CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp1By.text) & "'","Email")
    
            GeneratePendingEmailList(MSender,MReceiver,CC,trim(lblFECNNo.text),"Y")
            ReqCOM.ExecuteNonQuery("Update FECN_M set App6_By = '" & trim(request.cookies("U_ID").value) & "',App6_Date = '" & cdate(now) & "',FECN_Status = 'APPROVED' where fecn_no = '" & trim(lblFECNNo.text) & "';")
    
            if ReqCOM.GetFieldVal("Select Model_No from FECN_M where fecn_no = '" & trim(lblFECNNo.text) & "';","Model_No") <> "COMMON" then
                UpdateBOM
            else
                UpdatePart
            end if
    
            ShowAlert ("Selected FECN has been submitted.")
            redirectPage("FECNApp6Det.aspx?ID=" & Request.params("ID"))
        elseif rbReject.checked = true then
            ReqCOM.ExecuteNonQuery("Update FECN_M set App6_By = '" & trim(request.cookies("U_ID").value) & "',App6_Date = '" & now & "',App6_Rem = '" & trim(replace(txtRem.text,"'","`")) & "',App6_Status = 'N',FECN_Status = 'REJECTED' where fecn_no = '" & trim(lblFECNNo.text) & "';")
            MReceiver = trim(lblSubmitBy.text)
            MSender = trim(request.cookies("U_ID").value)
    
            CC = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp5By.text) & "';","Email")
            CC = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp4By.text) & "';","Email")
            CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp3By.text) & "';","Email")
    
            if trim(lblApp1By.text) <> "N/A" then CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp1By.text) & "';","Email")
            if trim(lblApp2By.text) <> "N/A" then CC = CC & ";" & ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(lblApp2By.text) & "';","Email")
    
            GeneratePendingEmailList(MSender,MReceiver,CC,trim(lblFECNNo.text),"N")
    
            ShowAlert ("Selected FECN has been rejected.")
            redirectPage("FECNApp6Det.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub UpdatePart()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.executeNonQuery("Update Part_Master set part_master.part_desc = fecn_d.part_desc,part_master.part_spec = fecn_d.part_spec,part_master.m_part_no = fecn_d.m_part_no from Part_Master,FECN_D where part_master.part_no = fecn_d.Main_Part and fecn_d.FECN_No = '" & trim(lblFECNNo.text) & "';")
    End sub
    
    Sub UpdateBOM()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim BOMRev as decimal
        Dim NewBOMRev as decimal
        Dim ModelNo aS string
        Dim StrSql as string = "Select * from FECN_D where FECN_No = '" & trim(lblFECNNo.text) & "';"
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        ModelNo = ReqCOM.GetFieldVal("Select Top 1 Model_No from FECN_M where FECN_No = '" & trim(lblFECNNo.text) & "';","Model_No")
        BOMRev = ReqCOM.GetFieldVal("Select top 1 Revision from BOM_M where model_no = '" & trim(ModelNo) & "' order by revision desc","Revision")
        NewBOMRev = BOMRev + 0.01
        ReqCOM.ExecuteNonQuery ("insert into BOM_M(MODEL_NO,PARTLIST_NO,REVISION,EFFECTIVE_DATE,FECN_NO) select MODEL_NO,PARTLIST_NO," & cdec(NewBOMRev) & ",'" & cdate(NOW) & "',FECN_NO from bom_m where Model_No = '" & trim(ModelNo) & "' and revision = " & cdec(BOMRev) & ";")
        ReqCOM.ExecuteNonQuery ("Insert into BOM_D(MODEL_NO,PART_NO,P_LEVEL,P_LOCATION,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision) Select MODEL_NO,PART_NO,P_LEVEL,P_LOCATION,LOT_FACTOR1,LOT_FACTOR2,P_USAGE," & NewBOMRev & " from BOM_D where model_No = '" & TRIM(ModelNo) & "' and Revision = " & BOMRev & ";")
        ReqCOM.ExecuteNonQuery ("Insert into BOM_Alt(MODEL_NO,MAIN_PART,PART_NO,REVISION) select MODEL_NO,MAIN_PART,PART_NO," & NewBOMRev & " from BOM_Alt where Model_No = '" & trim(ModelNo) & "' and Revision = " & BOMRev & ";")
    
        do while drGetFieldVal.read
            'Remove Existing Part (Part Details Before Chagne)
                if trim(drGetFieldVal("Main_Part_B4")) <> "-" then ReqCOM.ExecuteNonQuery("Delete from BOM_D where Part_No = '" & trim(drGetFieldVal("Main_Part_B4")) & "' and Model_No = '" & trim(modelNo) & "' and Revision = " & NewBomRev & " and P_Level = '" & trim(drGetFieldVal("P_Level_B4")) & "';")
            'Add Part Details (Part Details after change)
                if trim(drGetFieldVal("Main_Part")) <> "-" then ReqCOM.ExecuteNonQuery("Insert into BOM_D(MODEL_NO,PART_NO,P_LEVEL,P_LOCATION,P_USAGE,Revision) select '" & trim(ModelNo) & "',MAIN_PART,P_Level,P_Location,P_Usage," & NewBOMRev & " from FECN_D where Seq_No = " & drGetFieldVal("Seq_No") & ";")
        loop
    
        ReqCOM.ExecuteNonQUery("Delete from BOM_Alt where model_no = '" & trim(modelNo) & "' and revision = " & NewBomRev & " and Main_Part in (Select Main_Part from FECN_Alt where FECN_No = '" & trim(lblFECNNo.text) & "' and Status = 'B')")
        ReqCom.ExecuteNonQuery("Insert into BOM_ALT(main_part,model_no,part_no,revision) select distinct(main_part),'" & trim(ModelNo) & "',part_no," & cdec(NewBOMRev) & " from FECN_Alt where FECN_No = '" & trim(lblFECNNo.text) & "' AND STATUS = 'A'")
    
        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
    End Sub
    
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
    
    Sub GeneratePendingEmailList(Sender as string, Receiver as string,CC as string,DOcNo as string,SSERStat as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim FromEmail,ToEmail,EmailSubject,EmailContent as string
        if SSERStat = "Y" then
            EmailContent = "Dear Everyone" & vblf & vblf & vblf
            EmailContent = EmailContent + "Please be informed that the FECN submission has been approved by all parties." & vblf & vblf & vblf
            EmailContent = EmailContent + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            EmailContent = EmailContent + "Regards," & vblf & vblf
            EmailContent = EmailContent + trim(Sender) & vblf & vblf
            EmailSubject = "FECN Complete Approval : " & DOcNo & " (Model No : " & trim(lblModelNo.text) & ")"
            FromEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Sender) & "';","Email")
            ToEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Receiver) & "';","Email")
            ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','FECN','Y','" & trim(DOcNo) & "','" & trim(CC) & "'")
        Elseif SSERStat = "N" then
            EmailContent = "Dear " & trim(Receiver) & vblf & vblf & vblf
            EmailContent = EmailContent + "There is rejected FECN." & vblf & vblf & vblf
            EmailContent = EmailContent + "FECN Reference no is " & trim(DocNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
            EmailContent = EmailContent + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            EmailContent = EmailContent + "Regards," & vblf & vblf
            EmailContent = EmailContent + trim(Sender) & vblf & vblf
            EmailSubject = "FECN Rejected : " & DOcNo
            FromEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Sender) & "';","Email")
            ToEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(Receiver) & "';","Email")
            ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','FECN','Y','" & trim(DOcNo) & "','" & trim(CC) & "'")
        end if
    End sub

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
                                                                                    <asp:CheckBox id="chkToGTTMgt" runat="server" Enabled="False" CssClass="OutputText" Text="E-Mail to GTT (Ms Regina)"></asp:CheckBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="2">
                                                                                    <asp:CheckBox id="chkToGTT" runat="server" Enabled="False" CssClass="OutputText" Text="E-Mail to GTT Document Control (Chien@gtek.com.tw,sandy@gtek.com.tw,doc@gtek.com.tw)"></asp:CheckBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width="25%" bgcolor="silver">
                                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">FECN No</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblFECNNo" runat="server" cssclass="OutputText" width="" font-bold="True" font-size="Larger"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="">Model No/Description</asp:Label></td>
                                                                                <td>
                                                                                    <p align="left">
                                                                                        <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="423px" font-bold="True" font-size="Larger"></asp:Label>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="116px">PCBA Rev
                                                                                    From</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPCBRevFrom" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="116px">PCBA Rev
                                                                                    To</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPCBRevTo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
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
                                                                                    <asp:CheckBox id="chkCustReq" runat="server" Enabled="False" CssClass="OutputText" Text="Customer Request"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkDesignChange" runat="server" Enabled="False" CssClass="OutputText" Text="Design Change"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkCostDown" runat="server" Enabled="False" CssClass="OutputText" Text="Cost Down"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkNoSource" runat="server" Enabled="False" CssClass="OutputText" Text="No Source"></asp:CheckBox>
                                                                                    &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                    <asp:CheckBox id="chkLeadFree" runat="server" Enabled="False" CssClass="OutputText" Text="Lead Free"></asp:CheckBox>
                                                                                    &nbsp;<asp:CheckBox id="chkSimplifyProcess" runat="server" Enabled="False" CssClass="OutputText" Text="Simplify Process"></asp:CheckBox>
                                                                                    <asp:CheckBox id="chkOthers" runat="server" Enabled="False" CssClass="OutputText" Text="Others, pls specify"></asp:CheckBox>
                                                                                    <asp:TextBox id="txtOthers" runat="server" Enabled="False" CssClass="OutputText" Width="152px"></asp:TextBox>
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
                                                <p>
                                                    <FECNAttachment:FECNAttachment id="FECNAttachment" runat="server"></FECNAttachment:FECNAttachment>
                                                </p>
                                                <p>
                                                    <FECNDet:FECNDet id="FECNDet" runat="server"></FECNDet:FECNDet>
                                                </p>
                                                <p align="center">
                                                    <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Label id="lblRem" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                                                                <td width="55%">
                                                                    <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="100%" Height="56px"></asp:TextBox>
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
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Text="Submit" Width="123px"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="133px"></asp:Button>
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
