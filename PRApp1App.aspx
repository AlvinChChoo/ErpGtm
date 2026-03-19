<%@ Page Language="VB" Debug="TRUE" %>
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
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            lblPRNo.text = ReqCOm.GetFieldVal("select top 1 PR_No from pr1_m where Seq_No = " & trim(request.params("ID")) & ";","PR_No")
            LoadPO
            FormatRow()
            lblRem1.text = cint(MyList.items.count) & " items have been selected to approve."
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
    
    sub LoadPO()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        Dim StrSql as string = "SELECT pr.calculated_qty,pr.Item_Buyer_Rem,pm.part_spec,pm.m_part_no,pr.sel,PR.Item_Rem,pm.part_desc,pr.moq,pr.spq,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_NAME FROM pr1_d PR, vendor ven, Part_Master PM WHERE pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr_no = '" & trim(lblPRNo.text) & "' and item_sel = 'Y' order by PR.Part_no,pr.req_date asc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
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
        Response.redirect("PRApp1Det.aspx?ID=" & trim(request.params("ID")))
    End Sub
    
    Sub GenerateMail(Sender as string, Receiver as string,CC as string)
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrMsg as string
        Dim TotalQty as decimal
    
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
    
    Sub UpdateLosseQty()
        Dim i As Integer
        Dim SeqNo As Label
        Dim ItemBuyerRem,AdjQty As Textbox
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
    
        For i = 0 To MyList.Items.Count - 1
            SeqNo = CType(MyList.Items(i).FindControl("lblSeqNo"), Label)
            AdjQty = CType(MyList.Items(i).FindControl("AdjQty"), Textbox)
            ItemBuyerRem = CType(MyList.Items(i).FindControl("ItemBuyerRem"), Textbox)
            ReqCOM.ExecuteNonQuery("Update pr1_d set Item_Buyer_Rem = '" & trim(ItemBuyerRem.text) & "',qty_to_buy = " & clng(AdjQty.text) & " where Seq_No = " & SeqNo.text & ";")
        Next i
        ReqCOm.ExecuteNonQuery("Update PR1_D set Variance = Qty_To_Buy - PR_Qty where pr_No = '" & trim(lblPRNo.text) & "';")
    End sub
    
    Sub cmdReject_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim i as integer
            Dim StrSql,PRNo as string
            Dim SeqNo As Label
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim MSender as string
            Dim MReceiver as string
            Dim CC as string
    
    
            PRNo = ReqCOM.GetDocumentNo("PR_No")
            UpdateLosseQty
    
            For i = 0 To MyList.Items.Count - 1
                SeqNo = CType(MyList.Items(i).FindControl("lblSeqNo"), Label)
                if trim(StrSql) = "" then
                    StrSql = trim(SeqNo.text)
                elseif trim(StrSql) <> "" then
                    StrSql = StrSql & "," & trim(SeqNo.text)
                End if
            Next i
    
            ReqCOM.ExecuteNonQuery("Insert into pr1_m(SUBMIT_BY,SUBMIT_DATE,CREATE_BY,CREATE_DATE,APP1_BY,APP1_REM,APP1_DATE,APP1_STATUS,APP2_BY,APP2_DATE,APP2_REM,APP2_STATUS,APP3_BY,APP3_DATE,APP3_STATUS,APP3_REM,APP4_BY,APP4_DATE,APP4_STATUS,APP4_REM,Buyer_Code,PR_STATUS,APP5_BY,APP5_DATE,APP5_STATUS,APP5_REM,PR_TYPE,PR_NO) select SUBMIT_BY,SUBMIT_DATE,CREATE_BY,CREATE_DATE,'" & trim(request.cookies("U_ID").value) & "',APP1_REM,'" & cdate(now) & "',APP1_STATUS,APP2_BY,APP2_DATE,APP2_REM,APP2_STATUS,APP3_BY,APP3_DATE,APP3_STATUS,APP3_REM,APP4_BY,APP4_DATE,APP4_STATUS,APP4_REM,Buyer_Code,PR_STATUS,APP5_BY,APP5_DATE,APP5_STATUS,APP5_REM,PR_TYPE,'" & TRIM(PRNo) & "' from pr1_m where pr_no = '" & trim(lblPRNo.text) & "';")
            ReqCOM.ExecuteNonQuery("Update PR1_D set PR_No = '" & trim(PRNo) & "' where PR_No = '" & trim(lblPRNo.text) & "' and item_sel = 'Y'")
            ReqCOM.ExecuteNonQuery("Update Main set PR_No = PR_No + 1")
    
            MSender = Trim(request.cookies("U_ID").value)
            MReceiver = ReqCOM.GetFieldVal("Select Submit_By from PR1_M where pr_No = '" & trim(lblPRNo.text) & "';","Submit_By")
    
            GeneratePendingEmailList(MSender,MReceiver,trim(lblPRNo.text))
    
            ShowAlert("Selected parts has been rejected.\nNew generated PR no : " & trim(PRNo))
            redirectPage("PRApp1Det.aspx?ID=" & trim(ReqCOM.GetFieldVal("Select Seq_No from PR1_M where PR_No = '" & trim(PRNo) & "';","Seq_No")))
        End if
    End Sub
    
    Sub GeneratePendingEmailList(Sender as string, Receiver as string,DOcNo as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim FromEmail,ToEmail,EmailSubject,EmailContent as string
    
        EmailContent = "Dear " & trim(Receiver) & vblf & vblf
        EmailContent = EmailContent + "There is a P/R pending for your approval(P/R # : " & trim(DOcNo) & ")." & vblf & vblf
        EmailContent = EmailContent + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=PRApp2Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from PR1_M where PR_No = '" & trim(DOcNo) & "';","Seq_No") & " to view the details." & vblf & vblf
    
        EmailContent = EmailContent + "Regards," & vblf
        EmailContent = EmailContent + trim(Sender)
        EmailSubject = "P/R Approval : " & DOcNo
    
        FromEmail = trim(ReqCOM.GetFieldVal("Select top 1 EMail from User_Profile where U_ID = '" & trim(Sender) & "';","Email"))
        ToEmail = trim(ReqCOM.GetFieldVal("Select top 1 EMail from User_Profile where U_ID = '" & trim(Receiver) & "';","Email"))
        ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','P/R','N','" & trim(DOcNo) & "','" & trim(FromEmail) & "'")
        ''''''''''
    End sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    
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
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">P/R BUYER APPROVED
                                PARTS </asp:Label>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="ValQtyInput" runat="server" ErrorMessage="Quantity To Buy Not Tally." Display="Dynamic" ForeColor=" " CssClass="ErrorText" OnServerValidate="ValQtyInput_ServerValidate" EnableClientScript="False" Width="100%"></asp:CustomValidator>
                            </p>
                            <p align="center">
                                <asp:Label id="lblPRNo" runat="server" visible="False"></asp:Label> 
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:DataList id="MyList" runat="server" Width="90%" CellPadding="1" BorderWidth="0px" RepeatColumns="1" Height="101px" OnSelectedIndexChanged="MyList_SelectedIndexChanged">
                                                        <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                        <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                        <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                        <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                        <ItemStyle font-size="XX-Small"></ItemStyle>
                                                        <ItemTemplate>
                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                <tbody>
                                                                    <tr>
                                                                        <td width= "20%" bgcolor= "silver" valign= "top">
                                                                            <asp:Label id="RowSeq" runat="server" text= '1' cssclass= "ErrorText"></asp:Label> <asp:Label id="lblRejRem" runat="server" cssclass= "OutputText" text= 'Buyer Rem :' ></asp:Label> 
                                                                        </td>
                                                                        <td colspan="3" valign= "top">
                                                                            <asp:Textbox id="ItemBuyerRem" MaxLength="200" runat="server" cssclass= "OutputText" width= "500px" text='<%# DataBinder.Eval(Container.DataItem, "Item_Buyer_Rem") %>'></asp:Textbox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td width= "20%" bgcolor= "silver" valign= "top">
                                                                            <asp:Label id="lblRejRem1" runat="server" cssclass= "OutputText" text= 'MC Rem :' ></asp:Label> 
                                                                        </td>
                                                                        <td colspan="3" valign= "top">
                                                                            <asp:Label id="ItemRem" readonly= "true" runat="server" cssclass= "OutputText" width= "100%" text='<%# DataBinder.Eval(Container.DataItem, "Item_Rem") %>'></asp:Label> 
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                <tbody>
                                                                    <tr>
                                                                        <td bgcolor="silver" width= "10%">
                                                                            <asp:Label id="lblSeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>'> <asp:Label id="label1" runat="server">Part
                                                                            #</asp:Label> </asp:Label> 
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
                                                                    <td bgcolor="silver" width= "15%">
                                                                        <asp:Label id="label11632" cssclass="LabelNormal" runat="server" text='P/R Date'></asp:Label> 
                                                                    </td>
                                                                    <td bgcolor="silver" width= "15%">
                                                                        <asp:Label id="label11631" cssclass="LabelNormal" runat="server" text='Req. Date'></asp:Label> 
                                                                    </td>
                                                                    <td bgcolor="silver" width= "14%">
                                                                        <asp:Label id="label11633" cssclass="LabelNormal" runat="server" text='P/R Qty'></asp:Label> 
                                                                    </td>
                                                                    <td bgcolor="silver" width= "14%">
                                                                        <asp:Label id="label11634" cssclass="LabelNormal" runat="server" text='Order Qty'></asp:Label> 
                                                                    </td>
                                                                    <td bgcolor="silver" width= "14%">
                                                                        <asp:Label id="label11635" cssclass="LabelNormal" runat="server" text='U/P'></asp:Label> 
                                                                    </td>
                                                                    <td bgcolor="silver" width= "14%">
                                                                        <asp:Label id="label11636" cssclass="LabelNormal" runat="server" text='Amt'></asp:Label> 
                                                                    </td>
                                                                    <td bgcolor="silver" width= "14%">
                                                                        <asp:Label id="label116361" cssclass="LabelNormal" runat="server" text='Adj Qty.'></asp:Label> 
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
                                                                        <asp:Label id="UP" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>'></asp:Label> 
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
                                                        <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                    </asp:DataList>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="lblRem1" runat="server" width="100%" cssclass="Instruction"></asp:Label>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label1" runat="server" width="100%" cssclass="Instruction">You will
                                                    not be able to undo the changes after submission.</asp:Label><asp:Label id="Label4" runat="server" cssclass="Instruction">Are
                                                    you sure you want to proceed to submission ?</asp:Label>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 5px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdReject" onclick="cmdReject_Click" runat="server" CssClass="OutputText" Width="71px" Text="Yes"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="71px" Text="No" CausesValidation="False"></asp:Button>
                                                                    </div>
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
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="right">
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
