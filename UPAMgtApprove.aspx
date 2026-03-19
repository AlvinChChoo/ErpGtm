<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    
        IF page.ispostback=false then
            Dim ReqCOm as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim RsUPASM as SqlDataReader = ReqCOm.ExeDataReader("Select * from UPAS_M where Seq_No = '" & trim(request.params("ID")) & "';")
            cmdYes.attributes.add("onClick","javascript:if(confirm('You will not be able to undo the changes after approval.\nAre you sure you want to Approve this Unit Price Approval Sheet ?')==false) return false;")
    
            Do while RsUPASM.read
                lblUPASNo.text = RsUPASM("UPAS_NO").tostring
                lblAppBy.text = trim(Request.cookies("U_ID").value)
            loop
            RsUPASM.Close
        end if
    End Sub
    
    Sub cmdNo_Click(sender As Object, e As EventArgs)
        response.redirect("UPAMgtAppDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdYes_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReturnURL as string
            Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim VenSeq as integer
            ReqCOM.ExecuteNonQuery ("Update UPAS_D set SEQ_IND = 1 where upas_no = '" & trim(lblUPASNo.text) & "' and ACT = 'DELETE';")
            ReqCOM.ExecuteNonQuery ("Update UPAS_D set SEQ_IND = 2 where upas_no = '" & trim(lblUPASNo.text) & "' and ACT = 'EDIT';")
            ReqCOM.ExecuteNonQuery ("Update UPAS_D set SEQ_IND = 3 where upas_no = '" & trim(lblUPASNo.text) & "' and ACT = 'ADD';")
            ReqCOM.ExecuteNonQuery("Update UPAS_D set a_ori_up = 0 where a_ori_up is null and upas_no = '" & trim(lblUPASNo.text) & "';")
    
            Dim StrSql as string = "Select * from UPAS_D where UPAS_NO = '" & trim(lblUPASNo.text) & "' order by SEQ_IND,Seq_No asc"
            Dim rsUPA as SQLDataReader = ReqCOM.ExeDataReader(StrSql)
    
            Do while rsUPA.read
    
                Select case ucase(trim(rsUPA("ACT")))
                    Case "ADD"
                            ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 4 where Ven_Seq = 3 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                            ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 3 where Ven_Seq = 2 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                            ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 2 where Ven_Seq = 1 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                            StrSql = "Insert into Part_Source(PART_NO,VEN_CODE,LEAD_TIME,UP_APP_NO,UP_APP_DATE,FOC_PCTG,STD_PACK_QTY,MIN_ORDER_QTY,UP,CREATE_BY,CREATE_DATE,VEN_SEQ,CANCEL_LT,ORI_VEN_NAME,ORI_CURR_CODE,ORI_UP,RESCHEDULE_LT) "
                            StrSql = StrSql & "Select PART_NO,A_VEN_CODE,A_LEAD_TIME,UPAS_NO,'" & now & "',A_FOC_PCTG,A_STD_PACK,A_MIN_ORDER_QTY,A_UP,'" & trim(request.cookies("U_ID").value) & "','" & now & "',1,A_CANCEL_LT,A_ORI_VEN_NAME,A_ORI_CURR_CODE,A_ORI_UP,A_RESCHEDULE_LT from UPAS_D where Seq_no = " & rsUPA("Seq_No") & ";"
                            ReqCOM.ExecuteNonQuery(StrSql)
                    Case "DELETE"
                        if ReqCOM.FuncCheckDuplicate("Select Ven_Seq from Part_Source where Ven_Code = '" & trim(rsUPA("Ven_Code")) & "' AND Part_No = '" & trim(rsUPA("Part_No")) & "' and std_pack_qty = " & rsUPA("std_pack") & " and min_order_qty = " & rsUPA("min_order_qty") & ";","Ven_Seq") = true then
                            VenSeq = ReqCOM.GetFieldVal("Select Ven_Seq from Part_Source where Ven_Code = '" & trim(rsUPA("Ven_Code")) & "' AND Part_No = '" & trim(rsUPA("Part_No")) & "' and std_pack_qty = " & rsUPA("std_pack") & " and min_order_qty = " & rsUPA("min_order_qty") & ";","Ven_Seq")
                            StrSql = "Delete from Part_Source where Ven_Code = '" & trim(rsUPA("Ven_Code")) & "' and Part_No = '" & trim(rsUPA("Part_No")) & "' and std_pack_qty = " & rsUPA("std_pack") & " and min_order_qty = " & rsUPA("min_order_qty") & ";"
                            ReqCOM.ExecuteNonQuery(StrSql)
    
                            if VenSeq = 1 then
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 1 where Ven_Seq = 2 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 2 where Ven_Seq = 3 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                            elseif VenSeq = 2 then
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 2 where Ven_Seq = 3 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                            end if
                        End if
                    Case "EDIT"
                        if ReqCOM.FuncCheckDuplicate("Select Ven_Seq from Part_Source where Ven_Code = '" & trim(rsUPA("Ven_Code")) & "' AND Part_No = '" & trim(rsUPA("Part_No")) & "' and std_pack_qty = " & rsUPA("std_pack") & " and min_order_qty = " & rsUPA("min_order_qty") & ";","Ven_Seq") = true then
                            VenSeq = ReqCOM.GetFieldVal("Select Ven_Seq from Part_Source where Ven_Code = '" & trim(rsUPA("Ven_Code")) & "' AND Part_No = '" & trim(rsUPA("Part_No")) & "' and std_pack_qty = " & rsUPA("std_pack") & " and min_order_qty = " & rsUPA("min_order_qty") & ";","Ven_Seq")
                            if VenSeq = 2 then
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 4 where Ven_Seq = 1 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 5 where Ven_Seq = 2 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 2 where Ven_Seq = 4 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 1 where Ven_Seq = 5 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                            Elseif VenSeq = 3 then
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 4 where Ven_Seq = 1 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 5 where Ven_Seq = 2 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 6 where Ven_Seq = 3 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 2 where Ven_Seq = 4 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 3 where Ven_Seq = 5 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                                ReqCOM.ExecuteNonQuery("Update Part_Source set Ven_Seq = 1 where Ven_Seq = 6 and Part_No = '" & trim(rsUPA("Part_No")) & "';")
                            end if
    
                            'Delete Item B4 Change
                                StrSql = "Delete from Part_Source where Ven_Code = '" & trim(rsUPA("Ven_Code")) & "' and Part_No = '" & trim(rsUPA("Part_No")) & "' and std_pack_qty = " & rsUPA("std_pack") & " and min_order_qty = " & rsUPA("min_order_qty") & ";"
                                ReqCOM.ExecuteNonQuery(StrSql)
    
                            'Add Item After Change
                                StrSql = "Insert into Part_Source(PART_NO,VEN_CODE,LEAD_TIME,UP_APP_NO,UP_APP_DATE,FOC_PCTG,STD_PACK_QTY,MIN_ORDER_QTY,UP,CREATE_BY,CREATE_DATE,VEN_SEQ,CANCEL_LT,ORI_VEN_NAME,ORI_CURR_CODE,ORI_UP,RESCHEDULE_LT) "
                                StrSql = StrSql & "Select PART_NO,A_VEN_CODE,A_LEAD_TIME,UPAS_NO,'" & now & "',A_FOC_PCTG,A_STD_PACK,A_MIN_ORDER_QTY,A_UP,'" & trim(request.cookies("U_ID").value) & "','" & now & "',1,A_CANCEL_LT,A_ORI_VEN_NAME,A_ORI_CURR_CODE,A_ORI_UP,A_RESCHEDULE_LT from UPAS_D where Seq_no = " & rsUPA("Seq_No") & ";"
                                ReqCOM.ExecuteNonQuery(StrSql)
                        End if
                End select
            loop
    
            ReqCOM.executenonquery("Update UPAS_M set UPAS_STATUS = 'APPROVED', MGT_BY='" & TRIM(request.cookies("U_ID").value) & "',MGT_date = '" & now & "',MGT_REM = '" & TRIM(txtReason.text) & "' where seq_no = " & cint(request.params("ID")) & ";")
            ReqCOm.ExecuteNonQuery("Update UPAS_M set Entry_By = '" & trim(request.cookies("U_ID").value) & "',Entry_Date = '" & now & "' where UPAS_No = '" & trim(lblUPASNo.text) & "';")
            ReqCom.ExecuteNonQuery("UPDATE UPAS_D SET UPAS_D.DATE_EXPIRED = UPAS_M.MGT_DATE + UPAS_D.VALIDITY FROM UPAS_M,UPAS_D WHERE UPAS_M.UPAS_NO = UPAS_D.UPAS_NO and upas_d.validity > 0 and upas_m.upas_no = '" & trim(lblUPASNo.text) & "';")
            rsUPA.close
            GeneratePendingMail()
            ReturnURL = "upaMgtAppDet.aspx?ID=" & Request.params("ID")
            ShowAlert ("The selected Unit Price Approval Sheet have been approved successfully.")
            redirectPage(ReturnURl)
        End if
    End Sub
    
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
    
    Sub GenerateAttachment
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim RptnAME as string = "UPA"
        Dim repDoc As New ReportDocument()
        repDoc.Load(Mappath("") + "\Report\" & trim(RptName) & ".rpt")
        Dim subRepDoc As New ReportDocument()
        Dim myDBName as string = "erp_gtm"
        Dim myOwner as string = "dbo"
        Dim crSections As Sections
        Dim crSection As Section
        Dim crReportObjects As ReportObjects
        Dim crReportObject As ReportObject
        Dim crSubreportObject As SubreportObject
        Dim crDatabase As Database
        Dim crTables As Tables
        Dim crTable As CrystalDecisions.CrystalReports.Engine.Table
        Dim RptTitle as string
        Dim crLogOnInfo As TableLogOnInfo
        Dim crConnInfo As New ConnectionInfo()
    
        crDatabase = repDoc.Database
        crTables = crDatabase.Tables
    
        For Each crTable In crTables
            With crConnInfo
                .ServerName = ConfigurationSettings.AppSettings("ServerName")
                .DatabaseName = ConfigurationSettings.AppSettings("DatabaseName")
                .UserID = ConfigurationSettings.AppSettings("UserID")
                .Password = ConfigurationSettings.AppSettings("Password")
            End With
    
            crLogOnInfo = crTable.LogOnInfo
            crLogOnInfo.ConnectionInfo = crConnInfo
            crTable.ApplyLogOnInfo(crLogOnInfo)
    
        Next
        crTable.Location = myDBName & "." & myOwner & "." & crTable.Location.Substring(crTable.Location.LastIndexOf(".") + 1)
        crSections = repDoc.ReportDefinition.Sections
    
        For Each crSection In crSections
            crReportObjects = crSection.ReportObjects
            For Each crReportObject In crReportObjects
                If crReportObject.Kind = ReportObjectKind.SubreportObject Then
                    crSubreportObject = CType(crReportObject, SubreportObject)
                    subRepDoc = crSubreportObject.OpenSubreport(crSubreportObject.SubreportName)
                    crDatabase = subRepDoc.Database
                    crTables = crDatabase.Tables
                        For Each crTable In crTables
                            With crConnInfo
                                .ServerName = ConfigurationSettings.AppSettings("ServerName")
                                .DatabaseName = ConfigurationSettings.AppSettings("DatabaseName")
                                .UserID = ConfigurationSettings.AppSettings("UserID")
                                .Password = ConfigurationSettings.AppSettings("Password")
                            End With
    
                            crLogOnInfo = crTable.LogOnInfo
                            crLogOnInfo.ConnectionInfo = crConnInfo
                            crTable.ApplyLogOnInfo(crLogOnInfo)
                        Next
                    crTable.Location = myDBName & "." & myOwner & "." & crTable.Location.Substring(crTable.Location.LastIndexOf(".") + 1)
                End If
            Next
        Next
    
        Dim StrExportFile as string = Server.MapPath(".") & "\Report\UPA.pdf"
        repDoc.ExportOptions.ExportDestinationType = ExportDestinationType.DiskFile
        repDoc.ExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat
    
        Dim objOptions as DiskFileDestinationOptions = New DiskFileDestinationOptions
        objOptions.DiskFilename = strExportFile
        repDoc.ExportOptions.DestinationOptions = objOptions
        repDoc.export()
        objoptions = nothing
        repDoc = nothing
    End sub
    
    Sub GeneratePendingMail()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim TotalQty,TotalAmt,POTotal as decimal
        Dim FromName,FromEmail,ToName,ToEmail,CC,StrMsg,EmailSubject as string
    
        FromName = trim(request.cookies("U_ID").value)
        ToName = ReqCOM.GetFieldVal("select Submit_By from UPAS_M where UPAS_NO = '" & trim(lblUPASNo.text) & "';","Submit_By")
    
        FromEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(FromName) & "';","EMail")
        ToEmail = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID = '" & trim(ToName) & "';","EMail")
    
        EmailSubject  = "Unit Price Approval Complete loop : " & lblUPASNo.text
    
        StrMsg = "Dear Everyone" & vblf & vblf & vblf
        StrMsg = StrMsg + "Please be informed that the Unit Price Approval Sheet has been approved by all parties" & vblf & vblf & vblf
        StrMsg = StrMsg + "Please refer to the attachment for details on this approval." & vblf & vblf & vblf
        StrMsg = StrMsg + "For assistance, please contact " & Request.cookies("U_ID").value & vblf  & vblf
        StrMsg = StrMsg + "Regards," & vblf & vblf
        StrMsg = StrMsg + Request.cookies("U_ID").value
    
        CC = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID in (select Purc_By from UPAS_M where UPAS_No = '" & trim(lblUPASNo.text) & "')","EMail")
        CC = CC & ";" & ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID in (select ACC1_By from UPAS_M where UPAS_No = '" & trim(lblUPASNo.text) & "')","EMail")
        CC = CC & ";" & ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID in (select ACC2_By from UPAS_M where UPAS_No = '" & trim(lblUPASNo.text) & "')","EMail")
    
        ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(FromName) & "','" & trim(ToName) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(StrMsg) & "','UPA','Y','" & trim(lblUPASNo.text) & "','" & trim(CC) & "'")
    End sub
    
    Sub GenerateMailBackup()
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim TotalQty,TotalAmt,POTotal as decimal
        Dim ObjAttachment as MailAttachment
        Dim Sender,Receiver,CC,StrMsg as string
    
        Sender = trim(request.cookies("U_ID").value)
        Receiver = ReqCOM.GetFieldVal("select Submit_By from UPAS_M where UPAS_NO = '" & trim(lblUPASNo.text) & "';","Submit_By")
    
        ReqCOM.ExecuteNonQuery("Update UPAS_M set UPA_MAIL_ATT = 'N'")
        ReqCOM.ExecuteNonQuery("Update UPAS_M set UPA_MAIL_ATT = 'Y' where UPAS_NO = '" & trim(lblUPASNo.text) & "';")
        GenerateAttachment
    
        CC = ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID in (select Purc_By from UPAS_M where UPAS_No = '" & trim(lblUPASNo.text) & "')","EMail")
        CC = CC & ";" & ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID in (select ACC1_By from UPAS_M where UPAS_No = '" & trim(lblUPASNo.text) & "')","EMail")
        CC = CC & ";" & ReqCOM.GetFieldVal("Select Email from User_Profile where U_ID in (select ACC2_By from UPAS_M where UPAS_No = '" & trim(lblUPASNo.text) & "')","EMail")
    
        StrMsg = "Dear Everyone" & vblf & vblf & vblf
        StrMsg = StrMsg + "Please be informed that the Unit Price Approval Sheet has been approved by all parties" & vblf & vblf & vblf
        StrMsg = StrMsg + "Please refer to the attachment for details on this approval." & vblf & vblf & vblf
        StrMsg = StrMsg + "For assistance, please contact " & Request.cookies("U_ID").value & vblf  & vblf
        StrMsg = StrMsg + "Regards," & vblf & vblf
        StrMsg = StrMsg + Request.cookies("U_ID").value
        objEmail.Subject  = "Unit Price Approval Complete loop : " & lblUPASNo.text
    
        objEmail.To       = trim(Receiver)
        objEmail.CC       = CC
        objEmail.From     = trim(Sender)
        objEmail.Subject  = "UPA No : " & lblUPASNo.text
        objEmail.Body     = StrMsg
        ObjAttachment = New MailAttachment ((Mappath("") + "\Report\UPA.pdf"))
        objEmail.Attachments.ADD(ObjAttachment)
        objEmail.Priority = MailPriority.High
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label5" runat="server" width="100%" cssclass="FormDesc">UNIT PRICE
                                APPROVAL SHEET APPROVAL</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" EnableClientScript="False" Display="Dynamic" ControlToValidate="txtReason" Visible="False" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Approval Remarks" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" width="128px" cssclass="LabelNormal">Approval
                                                                    Sheet No</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblUPASNo" runat="server" width="480px" cssclass="OutputText"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="128px" cssclass="LabelNormal">Approved
                                                                    By</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblAppBy" runat="server" width="356px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="128px" cssclass="LabelNormal">Reason
                                                                    for approval</asp:Label></td>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtReason" runat="server" CssClass="OutputText" Width="100%" MaxLength="600"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 21px" width="100%" align="right">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="cmdYes" onclick="cmdYes_Click" runat="server" Width="153px" Text="Submit"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdNo" onclick="cmdNo_Click" runat="server" Width="122px" Text="Cancel" CausesValidation="False"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
