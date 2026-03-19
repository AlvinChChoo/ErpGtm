<%@ Page Language="VB" Debug="TRUE" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Public TotalAmt as decimal
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            cmdReject.attributes.add("onClick","javascript:if(confirm('Are you sure you want to REJECT the selected item ?\nYou will not be able to undo the changes after changes.')==false) return false;")
            cmdRemove.attributes.add("onClick","javascript:if(confirm('Are you sure you want to REMOVE the selected item ?\nYou will not be able to undo the changes after changes.')==false) return false;")
    
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim ApprovalNo as integer
            TotalAmt = 0
            Dim RsApproval as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR1_M where Seq_No = " & Request.params("ID") & ";")
            Do while RsApproval.read
                lblPRNo.text = RsApproval("PR_NO").tostring
                lblSubmitBy.text = RsApproval("Submit_By").tostring
                if trim(lblSubmitDate.text) <> "" then lblSubmitDate.text = format(RsApproval("Submit_Date"),"dd/MMM/yy")
    
                if isdbnull(rsApproval("App1_Date")) = false then lblApp1By.text = rsApproval("App1_By"):lblApp1Date.text = format(cdate(rsApproval("App1_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App2_Date")) = false then lblApp2By.text = rsApproval("App2_By"):lblApp2Date.text = format(cdate(rsApproval("App2_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App3_Date")) = false then lblApp3By.text = rsApproval("App3_By"):lblApp3Date.text = format(cdate(rsApproval("App3_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App4_Date")) = false then lblApp4By.text = rsApproval("App4_By"):lblApp4Date.text = format(cdate(rsApproval("App4_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App5_Date")) = false then lblApp5By.text = rsApproval("App5_By"):lblApp5Date.text = format(cdate(rsApproval("App5_Date")),"dd/MMM/yy")
    
                lblApp1Rem.text = rsApproval("App1_Rem").tostring
                lblApp2Rem.text = rsApproval("App2_Rem").tostring
                lblApp3Rem.text = rsApproval("App3_Rem").tostring
    
                if trim(lblApp1By.text) <> "" then cmdSubmit.visible = false
    
                if isdbnull(RsApproval("App2_Date")) = false then
                    cmdSubmit.visible = false
                    label1.visible = false
                    txtrem.visible = false
                    cmdReject.visible = false
                    cmdRemove.visible = false
                Else
                    cmdSubmit.visible = true
                    label1.visible = true
                    txtrem.visible = true
                    cmdReject.visible = True
                    cmdRemove.visible = True
                end if
            Loop
            LoadPO
            FormatRow
    
            lblTotal.text = "Total Amount : " & format(cdec(ReqCom.GetFieldVal("Select Sum (UP * Qty_To_Buy) as [TotalAmt] from PR1_D where PR_No = '" & trim(lblPRNo.text) & "';","TotalAmt")),"##,##0.00")
        end if
    End Sub
    
    Sub FormatRow()
        Dim i As Integer
        Dim ReqDate,PRDate,RowSeq as label
    
        For i = 0 To MyList.Items.Count - 1
            ReqDate = CType(MyList.Items(i).FindControl("ReqDate"), Label)
            PRDate = CType(MyList.Items(i).FindControl("PRDate"), Label)
            RowSeq = CType(MyList.Items(i).FindControl("RowSeq"), Label)
            ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
            PRDate.text = format(cdate(PRDate.text),"dd/MM/yy")
            RowSeq.text = i + 1
        Next
    End sub
    
    sub LoadPO()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        Dim StrSql as string = "SELECT pr.item_buyer_rem,pm.part_spec,pm.m_part_no,pr.sel,PR.Item_Rem,pm.part_desc,pr.moq,pr.spq,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_NAME FROM pr1_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No order by PR.Part_No,PR.REQ_DATE asc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim PartDet As Textbox = CType(e.Item.FindControl("PartDet"), Textbox)
            Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
            Dim PartDesc As Label = CType(e.Item.FindControl("PartDesc"), Label)
            Dim ReqDate As Label = CType(e.Item.FindControl("lblReqDate"), Label)
            Dim PRDate As Label = CType(e.Item.FindControl("lblPRDate"), Label)
            Dim QtyDet As Textbox = CType(e.Item.FindControl("QtyDet"), Textbox)
            Dim Sel As Label = CType(e.Item.FindControl("Sel"), Label)
            Dim Reject As checkbox = CType(e.Item.FindControl("Reject"), checkbox)
            Dim PRQty As Label = CType(e.Item.FindControl("lblPRQty"), Label)
            Dim BuyQty As Label = CType(e.Item.FindControl("lblBuyQty"), Label)
            Dim Amt As Label = CType(e.Item.FindControl("lblAmt"), Label)
            Dim UP As Label = CType(e.Item.FindControl("lblUP"), Label)
            Dim lblVar As Label = CType(e.Item.FindControl("lblVar"), Label)
            Dim VenCode As Label = CType(e.Item.FindControl("VenName"), Label)
            Dim MOQ As Label = CType(e.Item.FindControl("MOQ"), Label)
            Dim SPQ As Label = CType(e.Item.FindControl("SPQ"), Label)
            Dim VenDet As Textbox = CType(e.Item.FindControl("VenDet"), Textbox)
    
            ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
            PRDate.text = format(cdate(PRDate.text),"dd/MM/yy")
    
            if trim(Sel.text) = "Y" then Reject.checked = true
            Amt.text = format(BuyQty.text * UP.text,"##,##0.00")
            TotalAmt = TotalAmt + cdec(Amt.text)
            PartDet.text = "Part # : " & trim(PartNo.text) & vblf & "Desc.  : " & trim(PartDesc.text) & vblf & "Req. Date : " & trim(ReqDate.text) & vblf & "P/R Date  : " & trim(PRDate.text)
            QtyDet.text = "PR Qty     : " & PRQty.text & vblf & "Order Qty : " & BuyQty.text & vblf & "Unit Price  : " & UP.text & vblf & "Amount    : " & Amt.text
            VenDet.text = trim(VenCOde.text) & vblf & vblf & "MOQ : " & moq.text & vblf & "SPQ : " & spq.text
        End if
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PRApp2.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
            Dim MSender,MReceiver,CC as string
    
            MSender = ReqCOM.GetFieldVal("Select EMail from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","EMail")
            MReceiver = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID in (Select U_ID from authority where Module_Name = 'PR' and app_type = 'APP3')","Email")
            GenerateMail(MSender,MReceiver,CC)
    
            ReqCOM.ExecuteNonQuery("Update PR1_M set App2_By = '" & trim(request.cookies("U_ID").value) & "',App2_Date = '" & now & "',App2_Rem = '" & trim(txtRem.text) & "',App2_Status='Y' where PR_No = '" & trim(lblPRNo.text) & "';")
            ShowAlert ("SR sumbitted for further approval.")
            redirectPage("PRApp2Det.aspx?ID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub GenerateMail(Sender as string, Receiver as string,CC as string)
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrMsg as string
        Dim TotalQty as decimal
        Dim TotalAmt as Decimal
        Dim POTotal as Decimal
        Dim ObjAttachment as MailAttachment
    
        StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
        StrMsg = StrMsg + "There is a P/R pending for your approval." & vblf & vblf & vblf
        StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=PRApp3Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from PR1_M where PR_No = '" & trim(lblPRNo.text) & "';","Seq_No") & " to view the details."   & vblf & vblf
        StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
        StrMsg = StrMsg + "Regards," & vblf & vblf
        StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
        objEmail.Subject  = "P/R Pending Approval : " & trim(lblPRNo.text)
    
        objEmail.To       = trim(Receiver)
        objEmail.From     = trim(Sender)
        objEmail.CC       = trim(CC)
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
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowDet(sender as Object,e as DataGridCommandEventArgs)
        Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
        ShowReport("PopupPRItemDet.aspx?ID=" & trim(PartNo.text))
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=500,height=200');")
        Script.Append("</script" & ">")
        Page.RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdReject_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERP_Gtm = new ERp_Gtm.Erp_Gtm
        Dim PRNo as string = ReqCOM.GetDocumentNo("PR_No")
    
        ReqCOM.ExecuteNonQuery("Update pr1_d set pr_no = '" & trim(PRNo) & "' where Sel = 'Y' and pr_no = '" & trim(lblPRNo.text) & "';")
        ReqCOM.ExecuteNonQuery("Update pr1_d set Sel = 'N' where PR_No = '" & trim(PRNo) & "';")
        ReqCOM.ExecuteNonQuery("Insert into pr1_m(PR_NO,MRP_NO,PR_SOURCE,PR_DATE,STATUS,TO_PURC,SOURCE,SUBMIT_BY,SUBMIT_DATE,CREATE_BY,CREATE_DATE,Buyer_Code,PR_STATUS,PR_TYPE) select '" & trim(PRNo) & "',MRP_NO,PR_SOURCE,PR_DATE,STATUS,TO_PURC,SOURCE,SUBMIT_BY,SUBMIT_DATE,CREATE_BY,CREATE_DATE,Buyer_Code,PR_STATUS,PR_TYPE from pr1_m where pr_no = '" & trim(lblPRNo.text) & "';")
        ReqCOM.ExecuteNonQuery("Update Main set PR_No = PR_No + 1")
        ShowAlert("Selected parts has been rejected.\nNew generated PR no : " & trim(PRNo))
        redirectPage("PRApp2Det.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERP_Gtm = new ERp_Gtm.Erp_Gtm
        Dim PRNo as string = ReqCOM.GetDocumentNo("PR_No")
    
        ReqCOM.ExecuteNonQuery("Insert into pr_deleted_item(MRP_NO,PR_NO,PART_NO,SO_TYPE,REQ_DATE,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,VARIANCE,PR_DATE,PO_NO,BOM_DATE,SCH_DAYS,UP,NET_TOTAL,VEN_CODE,LEAD_TIME,BUYER_APPROVAL,BUYER_PROCESS,PR_APP_SUBMITTED,APPROVAL_NO,APPROVED,BUYER_IND,CALCULATED_QTY,REM,MOQ,SPQ,PO_GENERATED,IND,ITEM_REM) select MRP_NO,PR_NO,PART_NO,SO_TYPE,REQ_DATE,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,VARIANCE,PR_DATE,PO_NO,BOM_DATE,SCH_DAYS,UP,NET_TOTAL,VEN_CODE,LEAD_TIME,BUYER_APPROVAL,BUYER_PROCESS,PR_APP_SUBMITTED,APPROVAL_NO,APPROVED,BUYER_IND,CALCULATED_QTY,REM,MOQ,SPQ,PO_GENERATED,IND,ITEM_REM from pr1_d where pr_no = '" & trim(lblPRNo.text) & "' and sel = 'Y'")
        ReqCOM.ExecuteNonQuery("Delete from pr1_d where pr_no = '" & trim(lblPRNo.text) & "' and sel = 'Y'")
        ShowAlert("Selected parts has been removed.")
        redirectPage("PRApp2Det.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ItemCommand(s as object,e as DataListCommandEventArgs)
        Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
        ShowReport("PopupPRItemDet.aspx?ID=" & trim(PartNo.text))
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 184px" height="184" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">PR APPROVAL
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="90%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal">PR No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPRNo" runat="server" cssclass="OutputText" width="84px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Submit By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblSubmitRem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Buyer By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp1Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">PCMC By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp2Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Buyer HOD By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp3Rem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Mgt. By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">P/O Genetated By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp5By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp5Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 9px" width="98%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label3" runat="server" cssclass="SectionHeader" width="100%">PR DETAILS</asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%" align="center">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:DataList id="MyList" runat="server" CellPadding="1" BorderWidth="0px" RepeatColumns="1" Width="100%" Height="101px" OnSelectedIndexChanged="MyList_SelectedIndexChanged" OnItemCommand="ItemCommand">
                                                                                        <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                                        <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                                        <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                                        <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                                        <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                                        <ItemTemplate>
                                                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                <tbody>
                                                                                                    <tr>
                                                                                                        <td width= "20%" bgcolor= "silver">
                                                                                                            <asp:Label id="RowSeq" runat="server" text= '1' cssclass= "ErrorText"></asp:Label> <asp:Label id="lblRejRem" runat="server" cssclass= "OutputText" text= 'Rej ? / Rej Rem :' ></asp:Label>
                                                                                                        </td>
                                                                                                        <td width= "1%" >
                                                                                                            <asp:Checkbox id="Rej" runat="server" cssclass= "OutputText"></asp:Checkbox>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:Textbox id="RejRem" runat="server" cssclass= "OutputText" width= "100%" text='<%# DataBinder.Eval(Container.DataItem, "Item_Rem") %>'></asp:Textbox>
                                                                                                        </td>
                                                                                                        <td width= "1%">
                                                                                                            <asp:ImageButton id="ImgView" ToolTip="View Part Details" ImageUrl="View.gif" CommandArgument='VIEWWUL' runat="server"></asp:ImageButton>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width= "20%" bgcolor= "silver">
                                                                                                            <asp:Label id="lblBuyerRem" runat="server" cssclass= "OutputText" text= 'Buyer Rem :' ></asp:Label>
                                                                                                        </td>
                                                                                                        <td colspan= "3">
                                                                                                            <asp:Textbox id="RejRem1" runat="server" cssclass= "OutputText" width= "100%" text='<%# DataBinder.Eval(Container.DataItem, "Item_Buyer_Rem") %>'></asp:Textbox>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </tbody>
                                                                                            </table>
                                                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                <tbody>
                                                                                                    <tr>
                                                                                                        <td bgcolor="silver" width= "10%">
                                                                                                            <asp:Label id="label1" runat="server">Part #</asp:Label>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:Label id="PartNo" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>'></asp:Label> <asp:Label id="SeqNo" cssclass="ListOutput" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_no") %>'></asp:Label>
                                                                                                        </td>
                                                                                                        <td bgcolor="silver" width= "10%">
                                                                                                            <asp:Label id="Label4" runat="server">Description</asp:Label>
                                                                                                        </td>
                                                                                                        <td >
                                                                                                            <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Part_Desc") %> </span>
                                                                                                        </td>
                                                                                                        <td bgcolor="silver" width= "10%">
                                                                                                            <asp:Label id="Label3" runat="server">Mfg Part #</asp:Label>
                                                                                                        </td>
                                                                                                        <td >
                                                                                                            <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "M_part_no") %> </span>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td bgcolor="silver" width= "10%">
                                                                                                            <asp:Label id="label11" runat="server">Spec</asp:Label>
                                                                                                        </td>
                                                                                                        <td colspan="5">
                                                                                                            <asp:Label id="PartSpec" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>'></asp:Label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td bgcolor="silver" width= "10%" >
                                                                                                            <asp:Label id="label1111" runat="server">Supplier</asp:Label>
                                                                                                        </td>
                                                                                                        <td >
                                                                                                            <asp:Label id="label1121" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Name") %>'></asp:Label>
                                                                                                        </td>
                                                                                                        <td bgcolor="silver" width= "10%">
                                                                                                            <asp:Label id="label1132" runat="server">MOQ</asp:Label>
                                                                                                        </td>
                                                                                                        <td >
                                                                                                            <asp:Label id="label1142" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MOQ") %>'></asp:Label>
                                                                                                        </td>
                                                                                                        <td bgcolor="silver" width= "10%">
                                                                                                            <asp:Label id="label1153" runat="server">SPQ</asp:Label>
                                                                                                        </td>
                                                                                                        <td >
                                                                                                            <asp:Label id="label1163" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SPQ") %>'></asp:Label>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </tbody>
                                                                                            </table>
                                                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                <tr>
                                                                                                    <td bgcolor="silver" width= "18%">
                                                                                                        <asp:Label id="label11631" cssclass="LabelNormal" runat="server" text='Req. Date'></asp:Label>
                                                                                                    </td>
                                                                                                    <td bgcolor="silver" width= "18%">
                                                                                                        <asp:Label id="label11632" cssclass="LabelNormal" runat="server" text='P/R Date'></asp:Label>
                                                                                                    </td>
                                                                                                    <td bgcolor="silver" width= "16%">
                                                                                                        <asp:Label id="label11633" cssclass="LabelNormal" runat="server" text='P/R Qty'></asp:Label>
                                                                                                    </td>
                                                                                                    <td bgcolor="silver" width= "16%">
                                                                                                        <asp:Label id="label11634" cssclass="LabelNormal" runat="server" text='Order Qty'></asp:Label>
                                                                                                    </td>
                                                                                                    <td bgcolor="silver" width= "16%">
                                                                                                        <asp:Label id="label11635" cssclass="LabelNormal" runat="server" text='U/P'></asp:Label>
                                                                                                    </td>
                                                                                                    <td bgcolor="silver" width= "16%">
                                                                                                        <asp:Label id="label11636" cssclass="LabelNormal" runat="server" text='Amt'></asp:Label>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <asp:Label id="ReqDate" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Date") %>'></asp:Label>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <asp:Label id="PRDate" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Date") %>'></asp:Label>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <asp:Label id="PRQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Qty") %>'></asp:Label>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <asp:Label id="OrderQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>'></asp:Label>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <asp:Label id="UP" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>'></asp:Label>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <asp:Label id="Amt" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") * DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>'></asp:Label>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                            <br />
                                                                                        </ItemTemplate>
                                                                                        <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                                                    </asp:DataList>
                                                                                    <asp:Image id="Image1" runat="server" Width="100%" ImageUrl="Border.jpg"></asp:Image>
                                                                                    <div align="right"><asp:Label id="lblTotal" runat="server" cssclass="Instruction" width="100%"></asp:Label>
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
                                                    <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Label id="Label1" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                                                                <td width="55%">
                                                                    <asp:TextBox id="txtRem" runat="server" Width="100%" Height="56px" CssClass="OutputText" TextMode="MultiLine"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="180px" Text="Submit"></asp:Button>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdReject" onclick="cmdReject_Click" runat="server" Width="180px" Text="REJECT Selected Item" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="180px" Text="REMOVE Selected Item" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="180px" Text="Back"></asp:Button>
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