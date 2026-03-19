<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="System.Web.Mail" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.isPostBack = false then
                Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                loadGridData
                ProcLoadGridData
                gridcontrol1.visible = true
                lblAmount.text = "Total Amount  :  " & format(clng(ReqCOm.GetFieldVal("select sum(qty_to_buy*up) as [TotalAmt] from buyer_sr_d where sr_no = '" & trim(lblSRNo.text) & "';","TotalAmt")),"##,##0.00")
             End if
         End Sub
    
        Sub loadGridData()
            Dim strSql as string = "SELECT * FROM Buyer_SR_M where SEQ_NO = " & request.params("ID") & ";"
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
                do while ResExeDataReader.read
                    lblSRNo.text = ResExeDataReader("SR_NO")
                    txtRemarks.text = ResExeDataReader("Submit_rem").tostring
                    if isdbnull(ResExeDataReader("Submit_By")) = false then lblSubmitby.text = ucase(ResExeDataReader("Submit_By"))
                    if isdbnull(ResExeDataReader("Submit_Date")) = false then lblSubmitDate.text = format(cdate(ResExeDataReader("Submit_Date")),"dd/MMM/yy")
    
                    if isdbnull(ResExeDataReader("App1_By")) = false then lblApp1By.text = ucase(ResExeDataReader("App1_By"))
                    if isdbnull(ResExeDataReader("App1_Date")) = false then lblApp1Date.text = format(cdate(ResExeDataReader("App1_Date")),"dd/MMM/yy")
                    If isdbnull(ResExeDataReader("app1_Rem")) = true then lblApp1Rem.text = "-"
                    If isdbnull(ResExeDataReader("app1_Rem")) = false then lblApp1Rem.text = ResExeDataReader("App1_Rem").tostring
    
                    if isdbnull(ResExeDataReader("App2_By")) = false then lblApp2By.text = ucase(ResExeDataReader("App2_By"))
                    if isdbnull(ResExeDataReader("App2_Date")) = false then lblApp2Date.text = format(cdate(ResExeDataReader("App2_Date")),"dd/MMM/yy")
                    If isdbnull(ResExeDataReader("app2_Rem")) = true then lblApp2Rem.text = "-"
                    If isdbnull(ResExeDataReader("app2_Rem")) = false then lblApp2Rem.text = ResExeDataReader("App2_Rem").tostring
    
                    if isdbnull(ResExeDataReader("App3_By")) = false then lblApp3By.text = ucase(ResExeDataReader("App3_By"))
                    if isdbnull(ResExeDataReader("App3_Date")) = false then lblApp3Date.text = format(cdate(ResExeDataReader("App3_Date")),"dd/MMM/yy")
                    If isdbnull(ResExeDataReader("app3_Rem")) = true then lblApp3Rem.text = "-"
                    If isdbnull(ResExeDataReader("app3_Rem")) = false then lblApp3Rem.text = ResExeDataReader("App3_Rem").tostring
    
                    ProcLoadAtt
    
                    if isdbnull(ResExeDataReader("Submit_date")) = false then
                        cmdSubmit.enabled = false
                        cmddelete.enabled = false
                        cmdUpdate.enabled = false
                        lnkAttachment.enabled = false
                        cmdRefreshAtt.enabled = false
                    elseif isdbnull(ResExeDataReader("Submit_date")) = true then
                        cmdSubmit.enabled = true
                        cmddelete.enabled = true
                        cmdUpdate.enabled = true
                        lnkAttachment.enabled = true
                        cmdRefreshAtt.enabled = true
                        if cint(dtgUPASAttachment.items.count) = 0 then
                            cmdSubmit.enabled = false
                        Else
                            cmdSubmit.enabled = true
                        End if
                    end if
    
                    if trim(ResExeDataReader("SR_Status")) = "REJECTED" then
                        if trim(ResExeDataReader("Regenerate")) = "N" then
                            cmdResubmit.enabled = true
                            cmdIgnoreResubmit.enabled = true
                        end if
                     end if
                 loop
         end sub
    
        Sub ProcLoadGridData()
            Dim SortSeq as String
            Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
            Dim StrSql as string = "SELECT ven.curr_code,ven.ven_name,pr.rem,PR.Calculated_qty,PR.Ven_Code,pr.net_eta,PM.Part_Desc,PM.Buyer_Code,PR.VARIANCE,PR.ETA_Date,PR.QTY_TO_BUY,PR.Req_Qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Code],Ven_Name as [Ven_Name] FROM Buyer_SR_d PR, vendor ven, Part_Master PM WHERE pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr.SR_No = '" & trim(lblSRNo.text) & "' order by PR.ETA_Date" & SortSeq
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"Buyer_SR_D")
            GridControl1.DataSource=resExePagedDataSet.Tables("Buyer_SR_D").DefaultView
            GridControl1.DataBind()
        end sub
    
         Sub cmdMain_Click(sender As Object, e As EventArgs)
             response.redirect("Main.aspx")
         End Sub
    
         Sub cmdAddNew_Click(sender As Object, e As EventArgs)
             response.redirect("CustomerAddNew.aspx")
         End Sub
    
         Sub cmdDelete_Click(sender As Object, e As EventArgs)
             Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
             ReqCOM.ExecuteNonQuery("Delete from Buyer_SR_M where SR_No = '" & trim(lblSRNo.text) & "';")
             response.redirect("BuyerSpecialRequest.aspx")
         End Sub
    
        Sub cmdUpdate_Click(sender As Object, e As EventArgs)
            if page.isvalid  = true then
                UpdateDetails
                Response.redirect("BuyerSpecialRequestDet.aspx?ID=" & Request.params("ID"))
            End if
        End Sub
    
        Sub UpdateDetails()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim QtyToBuy as textbox
            Dim ReqQty,MaxQty,lblSeqNo as label
            Dim strSql as string
            Dim i as integer
    
            ReqCom.ExecutenonQuery("Update Buyer_SR_M set Submit_Rem = '" & trim(replace(txtRemarks.text,"'","`")) & "' where SR_No = '" & trim(lblSRNo.text) & "';")
    
            For i = 0 To gridcontrol1.Items.Count - 1
                QtyToBuy = CType(gridcontrol1.Items(i).FindControl("QtyToBuy"), textbox)
                ReqQty = CType(gridcontrol1.Items(i).FindControl("ReqQty"), Label)
                MaxQty = CType(gridcontrol1.Items(i).FindControl("MaxQty"), Label)
                lblSeqNo = CType(gridcontrol1.Items(i).FindControl("lblSeqNo"), Label)
                ReqCOM.ExecuteNonQuery("Update Buyer_SR_D set Qty_To_Buy = " & QtyToBuy.text & " where Seq_No = " & lblSeqNo.text & ";")
    
    
            next i
            ReqCOM.ExecuteNonQuery("Update Buyer_SR_D set Variance = Qty_To_Buy - Req_Qty where SR_No = '" & trim(lblSRNo.text) & "';")
        End sub
    
        Sub cmdBack_Click(sender As Object, e As EventArgs)
            Response.redirect("BuyerSpecialRequest.aspx")
        End Sub
    
        Sub cmdSubmit_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then
                Dim MReceiver,MSender,cc as string
                Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                UpdateDetails
                ReqCOM.ExecuteNonQuery("update buyer_sr_d set buyer_sr_d.min_order_qty = part_source.min_order_qty,buyer_sr_d.std_pack_qty = part_source.std_pack_qty from buyer_sr_d,part_source where buyer_sr_d.part_no = part_source.part_no and buyer_sr_d.ven_code = part_source.ven_code and buyer_sr_d.sr_no = '" & trim(lblSRNo.text) & "';")
                ReqCOm.ExecuteNonQuery("Update Buyer_SR_M set Submit_By = '" & trim(Request.cookies("U_ID").value) & "' ,Submit_Date = '" & now & "',SR_Status = 'PENDING APPROVAL' where sr_no = '" & trim(lblSRNo.text) & "';")
                MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select U_ID from authority where app_type = 'APP1' and module_name = 'BUYERSR')","Email")
                MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
                GenerateMail(MSender,MReceiver,CC,trim(lblSRNo.text),"Y")
                ShowAlert ("Selected SR has been submitted.")
                redirectPage("BuyerSpecialRequestDet.aspx?ID=" & Request.params("ID"))
            End if
        End Sub
    
        Sub ShowAlert(Msg as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
            RedirectPage("BuyerSpecialRequestDet.aspx?ID=" & Request.params("ID"))
        End sub
    
        Sub redirectPage(ReturnURL as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
            If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
        End sub
    
        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(3).Text = format(cdate(E.Item.Cells(3).Text),"dd/MM/yy")
            E.Item.Cells(4).Text = format(cdate(E.Item.Cells(4).Text),"dd/MM/yy")
            E.Item.Cells(8).Text = cint(E.Item.Cells(8).Text)
    
            E.Item.Cells(9).Text = format(cdec(E.Item.Cells(9).Text),"##,##0.000")
            E.Item.Cells(13).Text = format(E.Item.Cells(9).Text * E.Item.Cells(8).Text,"##,##0.00")
    
            Dim PRQty as Label = CType(e.Item.FindControl("PRQty"), Label)
            Dim MaxQty as Label = CType(e.Item.FindControl("MaxQty"), Label)
            Dim BuyerApproval as Label = CType(e.Item.FindControl("BuyerApproval"), Label)
            Dim QtyToBuy as TextBox = CType(e.Item.FindControl("QtyToBuy"), TextBox)
            E.Item.Cells(12).Text = format(E.Item.Cells(9).Text * QtyToBuy.Text,"##,##0.00")
            MaxQty.text = format(clng(MaxQty.text),"##,##0")
            e.item.cssclass = ""
            if trim(lblSubmitDate.text) <> "" then QtyToBuy.enabled = false
            End if
        End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        loadGridData()
    End Sub
    
        Sub SplitVendor(sender as Object,e as DataGridCommandEventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim SeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
    
            if lblSubmitDate.text <> "" then showAlert("S/R already submitted.\nNo editing of supplier is allowed.")
            if lblSubmitDate.text = "" then response.redirect("SplitPurchaseBuyerSR.aspx?ID=" & SeqNo.text & "&ReturnID=" & Request.params("ID"))
    
    
        End sub
    
          Sub OurPager(sender as object,e as datagridpagechangedeventargs)
              gridcontrol1.CurrentPageIndex = e.NewPageIndex
              loadGridData()
          end sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub lnkAttachment_Click(sender As Object, e As EventArgs)
        ShowPopup("PopupBuyerSRAtt.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
    End sub
    
    Sub ProcLoadAtt()
        Dim StrSql as string = "Select * from BUYER_SR_ATTACHMENT where SR_NO = '" & trim(lblSRNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"BUYER_SR_ATTACHMENT")
        dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("BUYER_SR_ATTACHMENT").DefaultView
        dtgUPASAttachment.DataBind()
    end sub
    
    Sub cmdRefreshAtt_Click(sender As Object, e As EventArgs)
        Response.redirect("BuyerSpecialRequestDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdResubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SRNo as string = ReqCOM.GetDocumentNo("BUYER_SR_NO")
        Dim StrSql as string
        Dim NewSeqNo as long
        StrSql = "Insert into Buyer_SR_M(SR_NO,REMARKS,MODIFY_BY,MODIFY_DATE,SUBMIT_BY,SR_STATUS,BUYER_CODE,REGENERATE,OLD_SR_NO) select '" & trim(SRNo) & "',REMARKS,MODIFY_BY,MODIFY_DATE,SUBMIT_BY,'PENDING SUBMISSION',BUYER_CODE,'N',SR_NO from Buyer_SR_M where SR_NO = '" & trim(lblSRNo.text) & "';"
        ReqCOM.executeNonQuery(StrSql)
    
        StrSql = "Insert into BUYER_SR_ATTACHMENT(FILE_NAME,FILE_DESC,SR_NO,FILE_SIZE) select FILE_NAME,FILE_DESC,'" & trim(SRNo) & "',FILE_SIZE from BUYER_SR_attachment where sr_no = '" & trim(lblSRNo.text) & "';"
        ReqCOM.executeNonQuery(StrSql)
    
        StrSql = "Insert into BUYER_SR_D(SR_NO,PART_NO,LOT_NO,SO_QTY,P_USAGE,CAL_QTY,REQ_QTY,ETA_DATE,CALCULATED_QTY,VEN_CODE,VARIANCE,QTY_TO_BUY,PR_DATE,UP,LEAD_TIME,NET_ETA,PROCESS_DAYS) "
        StrSql = StrSql + "Select '" & trim(SRNo) & "',PART_NO,LOT_NO,SO_QTY,P_USAGE,CAL_QTY,REQ_QTY,ETA_DATE,CALCULATED_QTY,VEN_CODE,VARIANCE,QTY_TO_BUY,PR_DATE,UP,LEAD_TIME,NET_ETA,PROCESS_DAYS from BUYER_SR_D where sr_no = '" & trim(lblSRNo.text) & "';"
        ReqCOM.executeNonQuery(StrSql)
    
        ReqCOM.ExecuteNonQuery("Update Main set BUYER_SR_NO = BUYER_SR_NO + 1")
        ReqCOM.ExecuteNonQuery("Update BUYER_SR_M set Regenerate = 'Y' where SR_NO = '" & trim(lblSRNo.text) & "';")
        NewSeqNo = ReqCOM.GetFieldVal("Select Seq_No from BUYER_SR_M where SR_NO = '" & trim(SRNo) & "';","Seq_No")
        ShowAlert("S/R has been re-submitted.\nNew S/R no : " & trim(SRNo))
        RedirectPage ("BuyerSpecialRequestDet.aspx?ID=" & trim(NewSeqNo))
    End Sub
    
    Sub cmdIgnoreResubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonquery("Update BUYER_SR_M set Regenerate = 'I' where SR_NO = '" & trim(lblSRNo.text) & "';")
        Response.redirect("BuyerSpecialRequestDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub GenerateMail(Sender as string, Receiver as string,CC as string,DOcNo as string,SRStatus as string)
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrMsg as string
        Dim TotalQty as decimal
        Dim TotalAmt as Decimal
        Dim POTotal as Decimal
        Dim ObjAttachment as MailAttachment
    
        if SRStatus = "Y" then
            StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
            StrMsg = StrMsg + "There is a New Special Request (from Buyer) pending for your approval." & vblf & vblf & vblf
            StrMsg = StrMsg + "The special request reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
            StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=BuyerSRApp1Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from Buyer_SR_M where SR_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
            StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
            StrMsg = StrMsg + "Regards," & vblf & vblf
            StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
            objEmail.Subject  = "Special Request Pending Approval : " & DOcNo
        Elseif SRStatus = "N" then
        end if
    
        objEmail.To       = trim(Receiver)
        objEmail.From     = trim(Sender)
        objEmail.CC       = trim(CC)
    
        objEmail.Body     = StrMsg
        objEmail.Priority = MailPriority.High
    
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub
    
    Sub ValQtyToBuy_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim QtyToBuy as textbox
        Dim ReqQty,MaxQty,lblSeqNo as label
        Dim i as integer
        For i = 0 To gridcontrol1.Items.Count - 1
            QtyToBuy = CType(gridcontrol1.Items(i).FindControl("QtyToBuy"), textbox)
            ReqQty = CType(gridcontrol1.Items(i).FindControl("ReqQty"), Label)
            MaxQty = CType(gridcontrol1.Items(i).FindControl("MaxQty"), Label)
            if (clng(QtyToBuy.text) > clng(MaxQty.text)) or (clng(QtyToBuy.text) < clng(ReqQty.text)) then
                e.isvalid = false
                ValQtyToBuy.errormessage = "Input error line " & i + 1
                'ShowAlert("Input error line " & i + 1
                exit sub
            end if
        next i
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">SPECIAL REQUEST
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <asp:CustomValidator id="ValQtyToBuy" runat="server" CssClass="ErrorText" OnServerValidate="ValQtyToBuy_ServerValidate" ForeColor=" " Display="Dynamic" ErrorMessage="Invalid Loose Quantity specified." Width="100%"></asp:CustomValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid remarks." Width="100%" ControlToValidate="txtRemarks"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                </div>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="70%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">SR No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSRNo" runat="server" width="315px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Submitted By/Date/Remarks</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSubmitBy" runat="server" width="" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox id="txtRemarks" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">App1 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp1By" runat="server" width="" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp1Rem" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">App2 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp2By" runat="server" width="" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp2Rem" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">App3 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp3By" runat="server" width="" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp3Rem" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 77px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td valign="top">
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
                                                                                                            <p>
                                                                                                                <asp:LinkButton id="lnkAttachment" onclick="lnkAttachment_Click" runat="server" Width="100%" CausesValidation="False">Click here to add / edit
attachment.</asp:LinkButton>
                                                                                                            </p>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <div align="right">
                                                                                                                <asp:Button id="cmdRefreshAtt" onclick="cmdRefreshAtt_Click" runat="server" CausesValidation="False" Text="Refresh Attachment"></asp:Button>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </tbody>
                                                                                            </table>
                                                                                        </p>
                                                                                        <p>
                                                                                            <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" HeaderStyle-CssClass="CartListHead" ItemStyle-CssClass="CartListItem" AlternatingItemStyle-CssClass="CartListItemAlt" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged" PageSize="50" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False">
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
                                                                                                    <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadBuyerSRAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                                                </Columns>
                                                                                            </asp:DataGrid>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:DataGrid id="gridcontrol1" runat="server" width="100%" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PageSize="20" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False" OnItemDataBound="FormatRow" Font-Size="XX-Small" Font-Name="Verdana" Font-Names="Verdana" AllowPaging="True" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" OnPageIndexChanged="OurPager" OnEditCommand="SplitVendor" PagerStyle-HorizontalAligh="Right" OnSortCommand="SortGrid">
                                                                                                <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                                                <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                                                <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                                                <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                                                <Columns>
                                                                                                    <asp:TemplateColumn Visible="False">
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:BoundColumn DataField="PART_NO" SortExpression="PR.Part_No" HeaderText="PART NO"></asp:BoundColumn>
                                                                                                    <asp:BoundColumn DataField="PART_Desc" SortExpression="PM.Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                                    <asp:BoundColumn DataField="ETA_DATE" HeaderText="ETA" DataFormatString="{0:d}">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    </asp:BoundColumn>
                                                                                                    <asp:BoundColumn DataField="NET_ETA" HeaderText="TPR DATE" DataFormatString="{0:d}">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    </asp:BoundColumn>
                                                                                                    <asp:TemplateColumn HeaderText="TPR QTY">
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="ReqQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Qty") %>' /> 
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:TemplateColumn HeaderText="QTY TO BUY(a)">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:TextBox id="QtyToBuy" css="css" class="outputtext" runat="server" align="right" Columns="8" MaxLength="6" Text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' width="48px" />
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:TemplateColumn HeaderText="SUGGESTED QTY">
                                                                                                        <ItemTemplate>
                                                                                                            <asp:Label id="MaxQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CALCULATED_QTY") %>' /> 
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:BoundColumn DataField="VARIANCE" HeaderText="VAR(Qty)(b)" DataFormatString="{0:f}">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    </asp:BoundColumn>
                                                                                                    <asp:BoundColumn DataField="UP" HeaderText="U/P(c)">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    </asp:BoundColumn>
                                                                                                    <asp:BoundColumn DataField="Curr_Code" HeaderText="Curr"></asp:BoundColumn>
                                                                                                    <asp:BoundColumn DataField="Ven_Name" HeaderText="Supplier"></asp:BoundColumn>
                                                                                                    <asp:BoundColumn HeaderText="Amt(a*c)" DataFormatString="{0:f}">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    </asp:BoundColumn>
                                                                                                    <asp:BoundColumn HeaderText="Var(Amt)(b*c)">
                                                                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                                    </asp:BoundColumn>
                                                                                                    <asp:TemplateColumn HeaderText="Remarks">
                                                                                                        <HeaderStyle horizontalalign="left"></HeaderStyle>
                                                                                                        <ItemStyle horizontalalign="left"></ItemStyle>
                                                                                                        <ItemTemplate>
                                                                                                            <asp:TextBox id="Rem" TextMode="MultiLine" css="css" class="outputtext" runat="server" align="right" Columns="30" MaxLength="100" Text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>' />
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                    <asp:EditCommandColumn ButtonType="PushButton" UpdateText="" CancelText="" EditText="Split"></asp:EditCommandColumn>
                                                                                                    <asp:TemplateColumn Visible="False" HeaderText="Select">
                                                                                                        <HeaderTemplate>
                                                                                                            <input id="chkAllItems" type="checkBox" onclick="CheckAllDataGridCheckBoxs('Remove',document.forms[0].chkAllItems.checked)" />
                                                                                                        </HeaderTemplate>
                                                                                                        <ItemTemplate>
                                                                                                            <center>
                                                                                                                <asp:CheckBox id="Remove" runat="server" checked="true" />
                                                                                                            </center>
                                                                                                        </ItemTemplate>
                                                                                                    </asp:TemplateColumn>
                                                                                                </Columns>
                                                                                                <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                                            </asp:DataGrid>
                                                                                        </p>
                                                                                        <p align="right">
                                                                                            <asp:Label id="lblAmount" runat="server" cssclass="Instruction" font-names="Aharoni">Label</asp:Label>
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
                                                <p>
                                                    <table style="HEIGHT: 30px" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="102px" Text="Submit"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" Width="140px" CausesValidation="False" Text="Delete S/R" Enabled="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="129px" Text="Update S/R" Enabled="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Button id="cmdResubmit" onclick="cmdResubmit_Click" runat="server" Width="140px" CausesValidation="False" Text="Re-Submit" Enabled="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdIgnoreResubmit" onclick="cmdIgnoreResubmit_Click" runat="server" Width="140px" CausesValidation="False" Text="Ignore Re-submit" Enabled="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="101px" CausesValidation="False" Text="Back"></asp:Button>
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
    </form>
</body>
</html>
