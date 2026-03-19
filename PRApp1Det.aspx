<%@ Page Language="VB" %>
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

    Public TotalAmt as decimal
        Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.isPostBack = false then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim ApprovalNo as integer
                TotalAmt = 0
                Dim RsApproval as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR1_M where Seq_No = " & request.params("ID") & ";")
                Do while RsApproval.read
                    lblPRNo.text = RsApproval("PR_NO").tostring
                    lblSubmitBy.text = RsApproval("Submit_By")
                    lblSubmitDate.text = format(RsApproval("Submit_Date"),"dd/MM/yy")
                    if isdbnull(rsApproval("App1_Date")) = false then lblApp1By.text = rsApproval("App1_By"):lblApp1Date.text = format(cdate(rsApproval("App1_Date")),"dd/MM/yy")
                    if isdbnull(rsApproval("App2_Date")) = false then lblApp2By.text = rsApproval("App2_By"):lblApp2Date.text = format(cdate(rsApproval("App2_Date")),"dd/MM/yy")
                    if isdbnull(rsApproval("App3_Date")) = false then lblApp3By.text = rsApproval("App3_By"):lblApp3Date.text = format(cdate(rsApproval("App3_Date")),"dd/MM/yy")
                    if isdbnull(rsApproval("App4_Date")) = false then lblApp4By.text = rsApproval("App4_By"):lblApp4Date.text = format(cdate(rsApproval("App4_Date")),"dd/MM/yy")
                    if isdbnull(rsApproval("App5_Date")) = false then lblApp5By.text = rsApproval("App5_By"):lblApp5Date.text = format(cdate(rsApproval("App5_Date")),"dd/MM/yy")
                    lblApp1Rem.text = rsApproval("App1_Rem").tostring
                    lblApp2Rem.text = rsApproval("App2_Rem").tostring
                    lblApp3Rem.text = rsApproval("App3_Rem").tostring
                    lblApp4Rem.text = rsApproval("App4_Rem").tostring
    
                    if trim(lblApp1By.text) <> "" then
                        cmdSubmit.enabled = false
                        cmdUpdate.enabled = false
                        cmdReject.enabled = false
                    End if
                Loop
                LoadPO
                FormatRow()
            end if
        End Sub
    
        Sub FormatRow()
            Dim i As Integer
            Dim ReqDate,PRDate,RowSeq,OrderQty as label
    
            For i = 0 To MyList.Items.Count - 1
                OrderQty = CType(MyList.Items(i).FindControl("OrderQty"), Label)
                ReqDate = CType(MyList.Items(i).FindControl("ReqDate"), Label)
                PRDate = CType(MyList.Items(i).FindControl("PRDate"), Label)
                RowSeq = CType(MyList.Items(i).FindControl("RowSeq"), Label)
                ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
                PRDate.text = format(cdate(PRDate.text),"dd/MM/yy")
                OrderQty.text = clng(OrderQty.text)
                RowSeq.text = i + 1
            Next
        End sub
    
    Sub ItemCommand(s as object,e as DataListCommandEventArgs)
        if UCASE(trim(e.commandArgument)) = "VIEWWUL" then
            Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
            ShowReport("PopupPRItemDet.aspx?ID=" & trim(PartNo.text))
        elseif ucase(trim(e.commandArgument)) = "SPLIT" then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim SeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
    
            if trim(lblApp1By.text) <> "" then
                ShowAlert("No editing are allowed after submission.")
                redirectPage("PRApp1Det.aspx?ID=" & Request.params("ID"))
            else
                response.redirect("SplitPurchase.aspx?ID=" & SeqNo.text)
            end if
        end if
    end sub
    
    sub LoadPO()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        'Dim StrSql as string = "SELECT pr.calculated_qty,pr.Item_Buyer_Rem,pm.part_spec,pm.m_part_no,pr.sel,PR.Item_Rem,pm.part_desc,pr.moq,pr.spq,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_NAME FROM pr1_d PR, vendor ven, Part_Master PM WHERE pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr_no = '" & trim(lblPRNo.text) & "' order by PR.Part_no,pr.req_date asc"
    
        Dim StrSql as string = "SELECT pr.lead_time,ven.curr_code,pr.calculated_qty,pr.Item_Buyer_Rem,pm.part_spec,pm.m_part_no,pr.sel,PR.Item_Rem,pm.part_desc,pr.moq,pr.spq,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_NAME FROM pr1_d PR, vendor ven, Part_Master PM WHERE pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr_no = '" & trim(lblPRNo.text) & "' order by PR.Part_no,pr.req_date asc"
    
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
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
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PRApp1.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERP_Gtm = new ERp_Gtm.Erp_Gtm
        Dim StrSql as string
        Dim Reject As CheckBox
        Dim SeqNo As Label
    
        StrSql = ""
    
        For i = 0 To MyList.Items.Count - 1
            Reject = CType(MyList.Items(i).FindControl("Rej"), CheckBox)
            SeqNo = CType(MyList.Items(i).FindControl("lblSeqNo"), Label)
    
            if Reject.checked = true then
                if trim(StrSql) = "" then
                    StrSql = trim(SeqNo.text)
                elseif trim(StrSql) <> "" then
                    StrSql = StrSql & "," & trim(SeqNo.text)
                End if
            end if
        Next i
    
        ReqCOM.ExecuteNonQuery("Update PR1_D set item_sel = Null where pr_no = '" & trim(lblPRNo.text) & "'")
        ReqCOM.ExecuteNonQuery("Update PR1_D set item_sel = 'Y' where Seq_No in (" & trim(StrSql) & ")")
        Response.redirect("PRApp1App.aspx?ID=" & Request.params("ID"))
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
        StrMsg = StrMsg + "There is a P/R submitted by Buyer pending for your approval." & vblf & vblf & vblf
        StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=PRApp2Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from PR1_M where PR_No = '" & trim(lblPRNo.text) & "';","Seq_No") & " to view the details."   & vblf & vblf
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
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            UpdateLosseQty()
            response.redirect("PRApp1Det.aspx?ID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub UpdateLosseQty()
        Dim i As Integer
        Dim SeqNo As Label
        Dim AdjQty As Textbox
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
    
        For i = 0 To MyList.Items.Count - 1
            SeqNo = CType(MyList.Items(i).FindControl("lblSeqNo"), Label)
            AdjQty = CType(MyList.Items(i).FindControl("AdjQty"), Textbox)
            ReqCOM.ExecuteNonQuery("Update pr1_d set qty_to_buy = " & clng(AdjQty.text) & " where Seq_No = " & SeqNo.text & ";")
        Next i
        ReqCOm.ExecuteNonQuery("Update PR1_D set Variance = Qty_To_Buy - PR_Qty where pr_No = '" & trim(lblPRNo.text) & "';")
    End sub
    
    Sub ValQtyInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim i as integer
        Dim PRQty,OrderQty As label
        Dim QtyToBuy As Textbox
    
        For i = 0 To MyList.Items.Count - 1
            PRQty = CType(MyList.Items(i).FindControl("PRQty"), Label)
            OrderQty = CType(MyList.Items(i).FindControl("OrderQty"), Label)
            QtyToBuy = CType(MyList.Items(i).FindControl("AdjQty"), Textbox)
            if (clng(QtyToBuy.text) < clng(PRQty.text)) or (clng(QtyToBuy.text) > clng(OrderQty.text)) then ValQtyInput.errorMessage = "Error Line " & i + 1 & " : Adjustment quantity not match." : e.isvalid = false
        Next i
    End Sub
    
    Sub cmdReject_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERP_Gtm = new ERp_Gtm.Erp_Gtm
        Dim StrSql as string
        Dim Reject As CheckBox
        Dim SeqNo As Label
    
        StrSql = ""
    
        For i = 0 To MyList.Items.Count - 1
            Reject = CType(MyList.Items(i).FindControl("Rej"), CheckBox)
            SeqNo = CType(MyList.Items(i).FindControl("lblSeqNo"), Label)
    
            if Reject.checked = true then
                if trim(StrSql) = "" then
                    StrSql = trim(SeqNo.text)
                elseif trim(StrSql) <> "" then
                    StrSql = StrSql & "," & trim(SeqNo.text)
                End if
            end if
        Next i
    
        ReqCOM.ExecuteNonQuery("Update PR1_D set item_sel = Null where pr_no = '" & trim(lblPRNo.text) & "'")
        ReqCOM.ExecuteNonQuery("Update PR1_D set item_sel = 'Y' where Seq_No in (" & trim(StrSql) & ")")
    
        Response.redirect("PRApp1Rej.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub SplitVendor(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
    
        if trim(lblApp1By.text) <> "" then
            ShowAlert("No editing are allowed after submission.")
            redirectPage("PRApp1Det.aspx?ID=" & Request.params("ID"))
        else
            response.redirect("SplitPurchase.aspx?ID=" & SeqNo.text)
        end if
    End sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
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
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">PR APPROVAL
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="ValQtyInput" runat="server" ErrorMessage="Quantity To Buy Not Tally." Display="Dynamic" ForeColor=" " CssClass="ErrorText" OnServerValidate="ValQtyInput_ServerValidate" EnableClientScript="False" Width="100%"></asp:CustomValidator>
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
                                                                    <asp:Label id="lblPRNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Submit By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblSubmitRem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Buyer By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp1Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">PCMC By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp2Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Buyer HOD By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp3Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Mgt. By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp4Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
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
                                                <p>
                                                    <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%" cssclass="SectionHeader">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="#8080ff">
                                                                </td>
                                                                <td width="40%">
                                                                    <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="SectionHeader">PURCHASE
                                                                        ORDER DETAILS</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td width="30%" bgcolor="#8080ff">
                                                                    <div align="right">
                                                                        <input class="OutputText" id="chkAll" onclick="CheckAllDataListCheckBoxes('Rej','true')" type="button" value="Check All" />
                                                                        <input class="OutputText" id="chkClearAll" onclick="ClearCheckBox('Rej')" type="button" value="Clear All" />&nbsp; 
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotop" style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataList id="MyList" runat="server" Width="100%" CellPadding="1" BorderWidth="0px" RepeatColumns="1" Height="101px" OnItemCommand="ItemCommand" OnSelectedIndexChanged="MyList_SelectedIndexChanged">
                                                                            <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                            <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                            <ItemTemplate>
                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td width= "20%" bgcolor= "silver" valign= "top">
                                                                                                <asp:Label id="lblSeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>'></asp:Label> <asp:Label id="RowSeq" runat="server" text= '1' cssclass= "ErrorText"></asp:Label> <asp:Label id="lblRejRem" runat="server" cssclass= "OutputText" text= 'Buyer Rem :' ></asp:Label> 
                                                                                            </td>
                                                                                            <td valign= "top" >
                                                                                                <asp:Label id="ItemBuyerRem" runat="server" cssclass= "OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Item_Buyer_Rem") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td width= "10%">
                                                                                                <asp:ImageButton id="ImgView" ToolTip="View Part Details" ImageUrl="View.gif" CommandArgument='VIEWWUL' runat="server"></asp:ImageButton>
                                                                                                <asp:ImageButton id="ImgSetting" ToolTip="Split Supplier" ImageUrl="Setting.gif" CommandArgument='SPLIT' runat="server"></asp:ImageButton>
                                                                                                <asp:Checkbox id="Rej" runat="server" cssclass= "OutputText"></asp:Checkbox>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width= "20%" bgcolor= "silver" valign= "top">
                                                                                                <asp:Label id="lblRejRem1" runat="server" cssclass= "OutputText" text= 'MC Rem :' ></asp:Label> 
                                                                                            </td>
                                                                                            <td colspan="3" valign= "top">
                                                                                                <asp:Label id="ItemRem" runat="server" cssclass= "OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Item_Rem") %>'></asp:Label> 
                                                                                            </td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td bgcolor="silver" width= "10%">
                                                                                                <asp:Label id="label1" runat="server" cssclass= "OutputText">Part #</asp:Label> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label id="PartNo" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>'></asp:Label> <asp:Label id="SeqNo" cssclass="ListOutput" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_no") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td bgcolor="silver" width= "10%">
                                                                                                <asp:Label id="Label4" runat="server" cssclass= "OutputText">Description</asp:Label> 
                                                                                            </td>
                                                                                            <td >
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Part_Desc") %> </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver" width= "10%">
                                                                                                <asp:Label id="Label3" runat="server" cssclass= "OutputText">Mfg Part #</asp:Label> 
                                                                                            </td>
                                                                                            <td >
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "M_part_no") %> </span> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver" width= "10%">
                                                                                                <asp:Label id="label11" runat="server" cssclass= "OutputText">Spec</asp:Label> 
                                                                                            </td>
                                                                                            <td colspan="5">
                                                                                                <asp:Label id="PartSpec" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>'></asp:Label> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver" width= "10%" >
                                                                                                <asp:Label id="label1111" runat="server" cssclass= "OutputText">Supplier</asp:Label> 
                                                                                            </td>
                                                                                            <td >
                                                                                                <asp:Label id="label1121" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Name") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td bgcolor="silver" width= "10%">
                                                                                                <asp:Label id="label1132" runat="server" cssclass= "OutputText">MOQ</asp:Label> 
                                                                                            </td>
                                                                                            <td >
                                                                                                <asp:Label id="label1142" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MOQ") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td bgcolor="silver" width= "10%">
                                                                                                <asp:Label id="label1153" runat="server" cssclass= "OutputText">SPQ</asp:Label> 
                                                                                            </td>
                                                                                            <td >
                                                                                                <asp:Label id="label1163" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SPQ") %>'></asp:Label> 
                                                                                            </td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                    <tr>
                                                                                        <td bgcolor="silver" width= "15%">
                                                                                            <asp:Label id="label11632" cssclass= "OutputText" runat="server" text='P/R Date'></asp:Label> 
                                                                                        </td>
                                                                                        <td bgcolor="silver" width= "15%">
                                                                                            <asp:Label id="label11631" cssclass= "OutputText" runat="server" text='Req. Date'></asp:Label> 
                                                                                        </td>
                                                                                        <td bgcolor="silver" width= "14%">
                                                                                            <asp:Label id="label11633" cssclass= "OutputText" runat="server" text='P/R Qty'></asp:Label> 
                                                                                        </td>
                                                                                        <td bgcolor="silver" width= "14%">
                                                                                            <asp:Label id="label11634" cssclass="OutputText" runat="server" text='Order Qty'></asp:Label> 
                                                                                        </td>
                                                                                        <td bgcolor="silver" width= "14%">
                                                                                            <asp:Label id="label11635" cssclass="OutputText" runat="server" text='U/P'></asp:Label> 
                                                                                        </td>
                                                                                        <td bgcolor="silver" width= "14%">
                                                                                            <asp:Label id="label11636" cssclass="OutputText" runat="server" text='Amt'></asp:Label> 
                                                                                        </td>
                                                                                        <td bgcolor="silver" width= "14%">
                                                                                            <asp:Label id="label116361" cssclass="OutputText" runat="server" text='Adj Qty.'></asp:Label> 
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <asp:Label id="PRDate" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Date") %>'></asp:Label> 
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label id="ReqDate" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Date") %>'></asp:Label> 
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label id="PRQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Qty") %>'></asp:Label> 
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label id="OrderQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Calculated_qty") %>'></asp:Label> 
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label id="CurrCode" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Curr_Code") %>'></asp:Label> <asp:Label id="UP" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>'></asp:Label> 
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:Label id="Amt" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") * DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>'></asp:Label> 
                                                                                        </td>
                                                                                        <td>
                                                                                            <asp:textbox id="AdjQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>'></asp:textbox>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                                <br />
                                                                            </ItemTemplate>
                                                                            <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                                        </asp:DataList>
                                                                    </p>
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
                                                                    <div align="left">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" CssClass="OutputText" Width="80%" Text="Approve selected Parts"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" CssClass="OutputText" Width="80%" Text="Update Adjustment Qty"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdReject" onclick="cmdReject_Click" runat="server" CssClass="OutputText" Width="80%" Text="Reject Selected Item" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="80%" Text="Back"></asp:Button>
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