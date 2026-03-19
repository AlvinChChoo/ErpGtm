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
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.isPostBack = false then
                loadGridData
                ProcLoadGridData
                ProcLoadAtt
            End if
        End Sub
    
        Sub loadGridData()
            Dim strSql as string = "SELECT * FROM SR_M where SEQ_NO = " & request.params("ID") & ";"
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
                do while ResExeDataReader.read
                    lblSRNo.text = ResExeDataReader("SR_NO")
                    txtRemarks.text = ResExeDataReader("Remarks").tostring
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
    
                    if isdbnull(ResExeDataReader("Submit_date")) = false then
                        cmdSubmit.enabled = false
                        cmddelete.enabled = false
                        cmdUpdate.enabled = false
                    else
                        cmdSubmit.enabled = true
                        cmddelete.enabled = true
                        cmdUpdate.enabled = true
                    end if
    
                    if trim(ResExeDataReader("SR_Status")) = "REJECTED" then
                        if trim(ResExeDataReader("Regenerate")) = "N" then
                            cmdResubmit.enabled = true
                            cmdIgnoreResubmit.enabled = true
                            cmdUpdate.enabled = true
                        end if
                    end if
                loop
            end sub
    
            Sub ProcLoadGridData()
                Dim StrSql as string = "Select srd.rem,srd.ven_code,srd.qty_to_buy,srd.eta_date,srd.spare_qty,SRD.Lot_No, SRD.Seq_No,SRD.REQ_QTY,PM.Part_Desc as [Desc],PM.Part_No as Part_No,SRD.REQ_QTY + srd.spare_qty as [TotalQty] from SR_D SRD,Part_Master PM where SRD.SR_No = '" & trim(lblSRNo.text) & "' and SRD.Part_No = PM.Part_No order by srd.seq_no asc"
                Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
                Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SR_D")
                GridControl1.DataSource=resExePagedDataSet.Tables("SR_D").DefaultView
                GridControl1.DataBind()
            end sub
    
            Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
            End Sub
    
            Sub cmdMain_Click(sender As Object, e As EventArgs)
                response.redirect("Main.aspx")
            End Sub
    
            Sub cmdAddNew_Click(sender As Object, e As EventArgs)
                response.redirect("CustomerAddNew.aspx")
            End Sub
    
    
            Sub cmdDelete_Click(sender As Object, e As EventArgs)
                Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                ReqCOM.ExecuteNonQuery("Delete from SR_M where SR_No = '" & trim(lblSRNo.text) & "';")
                response.redirect("SpecialRequest.aspx")
            End Sub
    
            Sub cmdUpdate_Click(sender As Object, e As EventArgs)
                Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
                Dim i As Integer
                Dim remove As CheckBox
                Dim SeqNo As Label
                Dim Rems,ReqQty,SpareQty as textbox
    
                ReqCOM.ExecuteNonQuery("Update SR_M set Remarks = '" & trim(txtRemarks.text) & "' where SR_No = '" & trim(lblSRNo.text) & "';")
    
                For i = 0 To GridControl1.Items.Count - 1
                    remove = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
                    SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
                    Rems = CType(GridControl1.Items(i).FindControl("Rems"), textbox)
    
                    ReqQty = CType(GridControl1.Items(i).FindControl("ReqQty"), textbox)
                    SpareQty = CType(GridControl1.Items(i).FindControl("SpareQty"), textbox)
    
                    if trim(SpareQty.text) = "" then SpareQty.text = "0"
                    If remove.Checked = true Then
                        ReqCOM.ExecuteNonQuery("Delete from SR_D where Seq_No = " & SeqNo.text & ";")
                    Else
                        ReqCOM.ExecuteNonQuery("Update SR_D set rem = '" & trim(Rems.text) & "',Req_Qty = " & cdec(ReqQty.text) & ",spare_qty = " & cdec(SpareQty.text) & " where seq_no = " & SeqNo.text & ";")
                    end if
                Next
                Response.redirect("PCMCSpecialRequestDet.aspx?ID=" & Request.params("ID"))
            End Sub
    
            Sub cmdBack_Click(sender As Object, e As EventArgs)
                Response.redirect("PCMCSpecialRequest.aspx")
            End Sub
    
            Sub cmdSubmit_Click(sender As Object, e As EventArgs)
                Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim MReceiver,MSender,cc as string
                ReqCOM.ExecuteNonQuery("Update SR_M set Submit_Date = '" & now & "',Submit_by = '" & trim(request.cookies("U_ID").value) & "',SR_Status = 'PENDING APPROVAL' where SR_No = '" & trim(lblSRNo.text) & "';")
    
                'ReqCOM.ExecuteNonQuery("Update SR_M set App1_By = '" & trim(request.cookies("U_ID").value) & "',App1_Date = '" & now & "',App1_Status='Y' where SR_No = '" & trim(lblSRNo.text) & "';")
                MReceiver = ReqCOM.GetFieldVal("Select Buyer_Code from SR_M where sr_no = '" & trim(lblSRNo.text) & "';","Buyer_Code")
                MReceiver = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID in (Select U_ID from Buyer where Buyer_Code = '" & trim(MReceiver) & "')","Email")
    
                MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Email")
                GenerateMail(MSender,MReceiver,CC,trim(lblSRNo.text),"Y")
    
                ShowAlert("S/R submitted for approval.")
                redirectPage("PCMCSpecialRequestDet.aspx?ID=" & Request.params("ID"))
             End Sub
    
         Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
             If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                Dim ETADate As Label = CType(e.Item.FindControl("ETADate"), Label)
                Dim Diff As Label = CType(e.Item.FindControl("Diff"), Label)
                Dim SpareQty As textbox = CType(e.Item.FindControl("SpareQty"), textbox)
                Dim ReqQty As textbox = CType(e.Item.FindControl("ReqQty"), textbox)
                Dim TotalQty As Label = CType(e.Item.FindControl("TotalQty"), Label)
                Dim QtyToBuy As Label = CType(e.Item.FindControl("QtyToBuy"), Label)
                Dim Rems As textbox = CType(e.Item.FindControl("Rems"), textbox)
                Dim Remove As checkbox = CType(e.Item.FindControl("Remove"), checkbox)
    
                if SpareQty.text = "" then SpareQty.text = "0"
                Diff.text = cdec(QtyToBuy.text) - (cdec(SpareQty.text) + cdec(ReqQty.text))
                ETADate.text = format(cdate(ETADate.text),"dd/MM/yy")
                ReqQty.text = format(cdec(ReqQty.text),"####0")
             End if
         End Sub
    
         Sub lnkAttachment_Click(sender As Object, e As EventArgs)
             ShowPopup("PopupPCMCSRAtt.aspx?ID=" & Request.params("ID"))
         End Sub
    
         Sub cmdRefreshAtt_Click(sender As Object, e As EventArgs)
             ProcLoadAtt
         End Sub
    
         Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    
         End Sub
    
         Sub ShowPopup(ReturnURL as string)
             Dim Script As New System.Text.StringBuilder
             Script.Append("<script language=javascript>")
             Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
             Script.Append("</script" & ">")
             RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
         End sub
    
         Sub ProcLoadAtt()
             Dim StrSql as string = "Select * from SR_ATTACHMENT where SR_NO = '" & trim(lblSRNo.text) & "';"
             Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
             Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SR_ATTACHMENT")
             dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("SR_ATTACHMENT").DefaultView
             dtgUPASAttachment.DataBind()
         end sub
    
         Sub cmdIgnoreResubmit_Click(sender As Object, e As EventArgs)
             Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             ReqCOM.ExecuteNonquery("Update SR_M set Regenerate = 'I' where SR_NO = '" & trim(lblSRNo.text) & "';")
             Response.redirect("PCMCSpecialRequestDet.aspx?ID=" & Request.params("ID"))
         End Sub
    
         Sub cmdResubmit_Click(sender As Object, e As EventArgs)
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim SRNo as string = ReqCOM.GetDocumentNo("SR_NO")
             Dim StrSql as string
             Dim NewSeqNo as long
             StrSql = "Insert into SR_M(SR_NO,REMARKS,MODIFY_BY,MODIFY_DATE,SUBMIT_BY,SR_STATUS,BUYER_CODE,REGENERATE,OLD_SR_NO) select '" & trim(SRNo) & "',REMARKS,MODIFY_BY,MODIFY_DATE,SUBMIT_BY,'PENDING SUBMISSION',BUYER_CODE,'N',SR_NO from SR_M where SR_NO = '" & trim(lblSRNo.text) & "';"
             ReqCOM.executeNonQuery(StrSql)
    
             StrSql = "Insert into SR_ATTACHMENT(FILE_NAME,FILE_DESC,SR_NO,FILE_SIZE) select FILE_NAME,FILE_DESC,'" & trim(SRNo) & "',FILE_SIZE from sr_attachment where sr_no = '" & trim(lblSRNo.text) & "';"
             ReqCOM.executeNonQuery(StrSql)
    
             StrSql = "Insert into SR_D(SR_NO,PART_NO,LOT_NO,SO_QTY,P_USAGE,CAL_QTY,REQ_QTY,SPARE_QTY,ETA_DATE,CALCULATED_QTY,VEN_CODE,VARIANCE,QTY_TO_BUY,PR_DATE,UP,LEAD_TIME,NET_ETA,PROCESS_DAYS) "
             StrSql = StrSql + "Select '" & trim(SRNo) & "',PART_NO,LOT_NO,SO_QTY,P_USAGE,CAL_QTY,REQ_QTY,SPARE_QTY,ETA_DATE,CALCULATED_QTY,VEN_CODE,VARIANCE,QTY_TO_BUY,PR_DATE,UP,LEAD_TIME,NET_ETA,PROCESS_DAYS from SR_D where sr_no = '" & trim(lblSRNo.text) & "';"
             ReqCOM.executeNonQuery(StrSql)
    
             ReqCOM.ExecuteNonQuery("Update Main set SR_NO = SR_NO + 1")
             ReqCOM.ExecuteNonQuery("Update SR_M set Regenerate = 'Y' where SR_NO = '" & trim(lblSRNo.text) & "';")
             NewSeqNo = ReqCOM.GetFieldVal("Select Seq_No from SR_M where SR_NO = '" & trim(SRNo) & "';","Seq_No")
    
             ShowAlert("S/R has been re-submitted.\nNew S/R no : " & trim(SRNo))
             RedirectPage ("PCMCSpecialRequestDet.aspx?ID=" & trim(NewSeqNo))
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
             StrMsg = StrMsg + "There is a New Special Request (from PCMC) pending for your approval." & vblf & vblf & vblf
             StrMsg = StrMsg + "The special request reference no is " & trim(DOcNo) & ". Please use this reference for future reference." & vblf & vblf & vblf
             StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=PCMCSRApp1Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from SR_M where SR_NO = '" & trim(DOcNo) & "';","Seq_No") & " to view the details."   & vblf & vblf
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

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">SPECIAL REQUEST
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">SR No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSRNo" runat="server" cssclass="OutputText" width="315px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Submitted By / Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox id="txtRemarks" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">App1 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp1By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp1Rem" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">App2 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp2By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp2Rem" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">App3 By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp3By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblApp3Rem" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 77px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td valign="top">
                                                                    <p>
                                                                        &nbsp; 
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
                                                                                            <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" HeaderStyle-CssClass="CartListHead" ItemStyle-CssClass="CartListItem" AlternatingItemStyle-CssClass="CartListItemAlt" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="50" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged">
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
                                                                                                    <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadPCMCSRAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                                                </Columns>
                                                                                            </asp:DataGrid>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="2" GridLines="Vertical" BorderColor="Black" PageSize="50" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AllowPaging="false" Font-Names="Verdana" Font-Name="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatRow">
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn visible="false">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="Part_No" HeaderText="Part No"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Desc" HeaderText="Part Description"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Lot_No" HeaderText="J/O No"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="ETA Date">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ETADate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ETA_DATE") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Supplier">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="VenCode" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Code") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Spare Qty">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:TextBox id="SpareQty" css="css" class="outputtext" runat="server" align="right" Columns="8" MaxLength="6" Text='<%# DataBinder.Eval(Container.DataItem, "SPARE_QTY") %>' width="48px" />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Req Qty">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:TextBox id="ReqQty" css="css" class="outputtext" runat="server" align="right" Columns="8" MaxLength="6" Text='<%# DataBinder.Eval(Container.DataItem, "Req_Qty") %>' width="48px" />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Suggested Qty">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="QtyToBuy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Diff.">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="Diff" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QTY_TO_BUY") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Remarks">
                                                                                    <HeaderStyle horizontalalign="left"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="left"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:TextBox id="Rems" TextMode="MultiLine" css="css" class="outputtext" runat="server" align="right" Columns="30" MaxLength="100" Text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Remove">
                                                                                    <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <center>
                                                                                            <asp:CheckBox id="Remove" runat="server" />
                                                                                        </center>
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
                                                <p>
                                                    <table style="HEIGHT: 30px" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="102px" Text="Submit" Enabled="False"></asp:Button>
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
                                                                    <asp:Button id="cmdResubmit" onclick="cmdResubmit_Click" runat="server" Width="140px" CausesValidation="False" Text="Re-Submit" Enabled="False"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Button id="cmdIgnoreResubmit" onclick="cmdIgnoreResubmit_Click" runat="server" Width="140px" CausesValidation="False" Text="Ignore Re-submit" Enabled="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="101px" Text="Back"></asp:Button>
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
