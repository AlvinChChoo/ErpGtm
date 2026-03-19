<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="PRDet" TagName="PRDet" Src="_PRDet_.ascx" %>
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
            Dim RsApproval as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR1_M where Seq_No = " & Request.params("ID") & ";")
            Do while RsApproval.read
                lblPRNo.text = RsApproval("PR_NO").tostring
                if isdbnull(rsApproval("Submit_By")) = false then lblSubmitBy.text = RsApproval("Submit_By")
                if isdbnull(rsApproval("Submit_Date")) = false then lblSubmitDate.text = format(RsApproval("Submit_Date"),"dd/MMM/yy")
                if isdbnull(rsApproval("App1_Date")) = false then lblApp1By.text = rsApproval("App1_By"):lblApp1Date.text = format(cdate(rsApproval("App1_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App2_Date")) = false then lblApp2By.text = rsApproval("App2_By"):lblApp2Date.text = format(cdate(rsApproval("App2_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App3_Date")) = false then lblApp3By.text = rsApproval("App3_By"):lblApp3Date.text = format(cdate(rsApproval("App3_Date")),"dd/MMM/yy")
                if isdbnull(rsApproval("App4_Date")) = false then lblApp4By.text = rsApproval("App4_By"):lblApp4Date.text = format(cdate(rsApproval("App4_Date")),"dd/MMM/yy")
                lblApp1Rem.text = rsApproval("App1_Rem").tostring
                lblApp2Rem.text = rsApproval("App2_Rem").tostring
                lblApp3Rem.text = rsApproval("App3_Rem").tostring
            Loop
            LoadPO()
            FormatRow()
            if trim(lblSubmitBy.text) <> "" then cmdSubmit.enabled = false
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
    
    Sub ItemCommand(s as object,e as DataListCommandEventArgs)
        Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
    
        if trim(e.commandargument) = "VIEWWUL" then
            ShowReport("PopupPRItemDet.aspx?ID=" & trim(PartNo.text))
            redirectPage("PRDet.aspx?ID=" & Request.params("ID"))
        elseif trim(e.commandargument) = "EDITPART" then
            Response.redirect("PREditPart.aspx?ID=" & clng(SeqNo.text))
        elseif trim(e.commandargument) = "COMBINEPART" then
            Response.redirect ("PRPartsCombinePurchase.aspx?PRNo=" & trim(lblPRNo.text) & "&PartNo=" & trim(PartNo.text))
        end if
    end sub
    
    sub LoadPO()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        Dim StrSql as string = "SELECT pm.open_po,pr.item_buyer_rem,pm.part_spec,pm.m_part_no,pr.sel,PR.Item_Rem,pm.part_desc,pr.moq,pr.spq,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_NAME FROM pr1_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = '" & lblPRNo.text & "' and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No order by PR.Part_No,PR.REQ_DATE asc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim lblVar As Label = CType(e.Item.FindControl("lblVar"), Label)
            Dim BuyQty As Label = CType(e.Item.FindControl("lblBuyQty"), Label)
            Dim EditPart As LinkButton = CType(e.Item.FindControl("EditPart"), LinkButton)
            Dim PartDet As Textbox = CType(e.Item.FindControl("PartDet"), Textbox)
            Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
            Dim PartDesc As Label = CType(e.Item.FindControl("PartDesc"), Label)
            Dim ReqDate As Label = CType(e.Item.FindControl("lblReqDate"), Label)
            Dim PRDate As Label = CType(e.Item.FindControl("lblPRDate"), Label)
            Dim PRQty As Label = CType(e.Item.FindControl("lblPRQty"), Label)
            Dim QtyDet As Textbox = CType(e.Item.FindControl("QtyDet"), Textbox)
            Dim VenDet As Textbox = CType(e.Item.FindControl("VenDet"), Textbox)
            Dim lblBuyQty As label = CType(e.Item.FindControl("lblBuyQty"), label)
            Dim MOQ As label = CType(e.Item.FindControl("MOQ"), label)
            Dim SPQ As label = CType(e.Item.FindControl("SPQ"), label)
            Dim VenCode As Label = CType(e.Item.FindControl("VenName"), Label)
            Dim UP As label = CType(e.Item.FindControl("lblUP"), label)
            Dim Amt As label = CType(e.Item.FindControl("lblAmt"), label)
    
            Amt.text = format(BuyQty.text * UP.text,"##,##0.00")
            ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
            PRDate.text = format(cdate(PRDate.text),"dd/MM/yy")
            PartDet.text = "Part # : " & trim(PartNo.text) & vblf & "Desc.  : " & trim(PartDesc.text) & vblf & "Req. Date : " & trim(ReqDate.text) & vblf & "P/R Date  : " & trim(PRDate.text)
            QtyDet.text = "PR Qty     : " & PRQty.text & vblf & "Order Qty : " & lblBuyQty.text & vblf & "Unit Price  : " & UP.text & vblf & "Amount    : " & Amt.text
            VenDet.text = trim(VenCOde.text) & vblf & vblf & "MOQ : " & moq.text & vblf & "SPQ : " & spq.text
            TotalAmt = TotalAmt + Amt.text
            if trim(lblSubmitBy.text) <> "" then EditPart.enabled = false
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PR.aspx")
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
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        UpdateLowestUPDet()
        ReqCOM.ExecuteNonQUery("Update PR1_M set Submit_by = '" & trim(request.cookies("U_ID").value) & "',Submit_Date = '" & now & "' where pr_no = '" & trim(lblPRNo.text) & "';")
        Dim ReceiverName as string
    
        ReceiverName = ReqCom.GetFieldVal("Select top 1 U_ID from Buyer where Buyer_Code in (Select Buyer_Code from PR1_M where PR_No = '" & trim(lblPRNo.text) & "')","U_ID")
        GenerateMail(trim(request.cookies("U_ID").value),ReceiverName,trim(request.cookies("U_ID").value))
        ShowAlert("PR submited for buyer processing.")
        redirectPage("PRDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub GenerateMail(Sender as string, Receiver as string,CC as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim FROM_EMAIL,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT AS STRING
    
        FROM_EMAIL = ReqCOM.GetFieldVal("Select top 1 Email from User_Profile where U_ID = '" & trim(Sender) & "';","Email")
        TO_EMAIL = ReqCOM.GetFieldVal("Select top 1 Email from User_Profile where U_ID = '" & trim(Receiver) & "';","Email")
        EMAIL_SUBJECT = "P/R Pending Approval : " & trim(lblPRNo.text)
    
        EMAIL_CONTENT = "Dear " & trim(Receiver) & vblf & vblf & vblf
        EMAIL_CONTENT = EMAIL_CONTENT + "There is a P/R submitted by MC pending for your approval." & vblf & vblf & vblf
        EMAIL_CONTENT = EMAIL_CONTENT + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=PRApp1Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from PR1_M where PR_No = '" & trim(lblPRNo.text) & "';","Seq_No") & " to view the details."   & vblf & vblf
        EMAIL_CONTENT = EMAIL_CONTENT + "For assistance, please contact " & trim(Receiver) & vblf  & vblf & vblf
        EMAIL_CONTENT = EMAIL_CONTENT + "Regards," & vblf & vblf
        EMAIL_CONTENT = EMAIL_CONTENT + trim(Sender) & vblf & vblf
        ReqCOM.ExecuteNonQuery("Insert into Pending_Email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,CC,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO) select '" & trim(FROM_EMAIL) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(TO_EMAIL) & "','" & trim(CC) & "','" & trim(EMAIL_SUBJECT) & "','" & trim(EMAIL_CONTENT) & "','PR','N','" & trim(lblPRNo.text) & "';")
    End sub
    
    Sub UpdateLowestUPDet()
        Dim StrSql as string = "Select Distinct(Part_No) as [PartNo] from PR1_D where PR_No = '" & trim(lblPRNo.text) & "';"
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
        Dim RefSeq as string
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        StrSql = ""
        do while drGetFieldVal.read
            RefSeq = ReqCom.GetFieldVal("Select Top 1 Seq_No from Part_Source where Part_No = '" & trim(drGetFieldVal("PartNo")) & "' order by UP asc","Seq_No")
            if trim(RefSeq) <> "<NULL>" then
                if trim(StrSql) = "" then
                    StrSql = "Update PR1_D set Ref_Seq = " & clng(RefSeq) & " where part_no = '" & trim(drGetFieldVal("PartNo")) & "' and PR_No = '" & trim(lblPRNo.text) & "'"
                elseif trim(StrSql) <> "" then
                    StrSql = StrSql + ";Update PR1_D set Ref_Seq = " & clng(RefSeq) & " where part_no = '" & trim(drGetFieldVal("PartNo")) & "' and PR_No = '" & trim(lblPRNo.text) & "'"
                end if
            End if
        loop
    
        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
    
        if Trim(StrSql) <> "" then ReqCOM.ExecuteNonQUery(StrSql)
        ReqCOM.ExecuteNonQUery("Update PR1_D set pr1_d.ref_ven_Name = VENDOR.ven_Name,pr1_d.ref_up = part_Source.up from PR1_D,Part_Source,VENDOR where VENDOR.ven_code = part_source.ven_code and pr1_d.ref_seq = part_Source.Seq_No and pr1_D.pr_no = '" & trim(lblPRNo.text) & "'")
    End Sub
    
    Sub ShowDet(sender as Object,e as DataGridCommandEventArgs)
        if trim(e.commandargument) = "ViewWUL" then
            Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
            ShowReport("PopupPRItemDet.aspx?ID=" & trim(PartNo.text))
            redirectPage("PRDet.aspx?ID=" & Request.params("ID"))
        elseif trim(e.commandargument) = "EditPart" then
            Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
            Response.redirect("PREditPart.aspx?ID=" & clng(SeqNo.text))
        end if
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=800,height=300');")
        Script.Append("</script" & ">")
        page.RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        UpdateSelectedItem
    End Sub
    
    Sub UpdateSelectedItem()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim i as integer
        Dim StrSql as string
        Dim SeqNo As Label
        Dim MCRem As Textbox
    
        For i = 0 To MyList.Items.Count - 1
            SeqNo = CType(MyList.Items(i).FindControl("lblSeqNo"), Label)
            MCRem = CType(MyList.Items(i).FindControl("MCRem"), textbox)
            ReqCOM.ExecuteNonQuery("Update PR1_D set Item_Rem = '" & trim(MCRem.text) & "' where Seq_No = " & clng(SeqNo.text) & ";")
        Next i
        Response.redirect("PRDet.aspx?ID=" & Request.params("ID"))
    End sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdReport_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=PRSummary&ID=" & trim(lblPRNo.text) )
    End Sub
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        LoadPO()
        FormatRow()
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="70%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal">PR No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPRNo" runat="server" width="84px" cssclass="OutputText"></asp:Label></td>
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
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Approval 1 By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp1Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Approval 2 By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp2Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Approval 3 By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblApp3Rem" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">P/O Genetated By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="98%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="SectionHeader">PR
                                                                        DETAILS</asp:Label>
                                                                    </div>
                                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p>
                                                                                        <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                                                            <tbody>
                                                                                                <tr>
                                                                                                    <td width="20%">
                                                                                                        <asp:Button id="Button3" onclick="cmdSubmit_Click" runat="server" Width="100%" Text="Submit" CssClass="OutputText"></asp:Button>
                                                                                                    </td>
                                                                                                    <td width="20%">
                                                                                                        <asp:Button id="Button4" onclick="cmdRefresh_Click" runat="server" Width="100%" Text="Refresh List" CssClass="OutputText"></asp:Button>
                                                                                                    </td>
                                                                                                    <td width="20%">
                                                                                                        <div align="center" width="34%">
                                                                                                            <asp:Button id="Button5" onclick="cmdRemove_Click" runat="server" Width="100%" Text="Update Item Remark" CssClass="OutputText" CausesValidation="False"></asp:Button>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                    <td width="20%">
                                                                                                        <div align="right">
                                                                                                            <asp:Button id="Button6" onclick="cmdReport_Click" runat="server" Width="100%" Text="PR Summary Report" CssClass="OutputText"></asp:Button>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                    <td width="20%">
                                                                                                        <div align="right">
                                                                                                            <asp:Button id="Button7" onclick="cmdBack_Click" runat="server" Width="100%" Text="Back" CssClass="OutputText"></asp:Button>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </p>
                                                                                    <p>
                                                                                        <asp:DataList id="MyList" runat="server" Width="100%" OnItemCommand="ItemCommand" OnSelectedIndexChanged="MyList_SelectedIndexChanged" CellPadding="1" BorderWidth="0px" RepeatColumns="1" Height="101px">
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
                                                                                                                <asp:Label id="lblSeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>'></asp:Label> <asp:Label id="RowSeq" runat="server" text='1' cssclass= "ErrorText"></asp:Label> <asp:Label id="lblRejRem" runat="server" cssclass= "OutputText" text= 'MC Rem :' ></asp:Label> 
                                                                                                            </td>
                                                                                                            <td valign= "top">
                                                                                                                <asp:Textbox id="MCRem" runat="server" cssclass= "OutputText" width= "100%" text='<%# DataBinder.Eval(Container.DataItem, "Item_Rem") %>'></asp:Textbox>
                                                                                                            </td>
                                                                                                            <td width= "10%" valign= "top">
                                                                                                                <asp:Hyperlink ID="HyperlinkView" ToolTip="View Part Details" imageURL="view.gif" Runat="Server" NavigateUrl= <%#"javascript:PRPartDet=window.open('PopupPRItemDet.aspx?id=" + DataBinder.Eval(Container.DataItem,"Part_No").ToString() + "','PRPartDet','resizable=1,scrollbars=1,height=250');PRPartDet.focus()" %>></asp:Hyperlink>
                                                                                                                <asp:Hyperlink ID="HyperlinkSetting" ToolTip="Edit Part" imageURL="Setting.gif" Runat="Server" NavigateUrl= <%#"javascript:PRPartSetting=window.open('PREditPart.aspx?id=" + DataBinder.Eval(Container.DataItem,"Seq_No").ToString() + "','PRPartSetting','resizable=1,scrollbars=1,height=400');PRPartSetting.focus()" %>></asp:Hyperlink>
                                                                                                                <asp:Hyperlink ID="HyperlinkCombine" ToolTip="Combine Part" imageURL="Install.gif" Runat="Server" NavigateUrl= <%#"javascript:HyperlinkCombine=window.open('PRPartsCombinePurchase.aspx?id=" + DataBinder.Eval(Container.DataItem,"Seq_No").ToString() + "','HyperlinkCombine','resizable=1,scrollbars=1,height=400');HyperlinkCombine.focus()" %>></asp:Hyperlink>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                        <tr>
                                                                                                            <td width= "20%" bgcolor= "silver" valign= "top">
                                                                                                                <asp:Label id="lblBuyerRem" runat="server" cssclass= "OutputText" text= 'Buyer Rem :' ></asp:Label> 
                                                                                                            </td>
                                                                                                            <td colspan= "2" valign= "top">
                                                                                                                <asp:Textbox id="RejRem1" runat="server" ReadOnly="True" cssclass= "OutputText" width= "100%" text='<%# DataBinder.Eval(Container.DataItem, "Item_Buyer_Rem") %>'></asp:Textbox>
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
                                                                                                                <asp:Label id="label1132" runat="server">MOQ/SPQ</asp:Label> 
                                                                                                            </td>
                                                                                                            <td >
                                                                                                                <asp:Label id="label1142" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MOQ") %>'></asp:Label> / <asp:Label id="label1163" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SPQ") %>'></asp:Label> 
                                                                                                            </td>
                                                                                                            <td bgcolor="silver" width= "10%">
                                                                                                                <asp:Label id="label1153" runat="server">Open P/O</asp:Label> 
                                                                                                            </td>
                                                                                                            <td >
                                                                                                                <asp:Label id="lblOpenPO" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Open_PO") %>'></asp:Label> 
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
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <p>
                                                                        <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="20%">
                                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="100%" Text="Submit" CssClass="OutputText"></asp:Button>
                                                                                    </td>
                                                                                    <td width="20%">
                                                                                        <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Width="100%" Text="Refresh List" CssClass="OutputText"></asp:Button>
                                                                                    </td>
                                                                                    <td width="20%">
                                                                                        <div align="center" width="34%">
                                                                                            <asp:Button id="Button1" onclick="cmdRemove_Click" runat="server" Width="100%" Text="Update Item Remark" CssClass="OutputText" CausesValidation="False"></asp:Button>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td width="20%">
                                                                                        <div align="right">
                                                                                            <asp:Button id="cmdReport" onclick="cmdReport_Click" runat="server" Width="100%" Text="PR Summary Report" CssClass="OutputText"></asp:Button>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td width="20%">
                                                                                        <div align="right">
                                                                                            <asp:Button id="Button2" onclick="cmdBack_Click" runat="server" Width="100%" Text="Back" CssClass="OutputText"></asp:Button>
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
                                                <p align="center">
                                                </p>
                                                <p>
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
