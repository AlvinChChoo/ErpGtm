<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.ispostback = false then
                cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this Sales Order ?')==false) return false;")
                cmdCancelSO.attributes.add("onClick","javascript:if(confirm('Are you sure you want to cancel this Sales Order ?')==false) return false;")
                loaddata()
            end if
        End Sub
    
        Sub LoadData
            Dim strSql as string = "SELECT * FROM SO_MODELS_M WHERE SEQ_NO = " & request.params("ID")  & ";"
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
    
            do while ResExeDataReader.read
                lblCustCode.text = ResExeDataReader("Cust_Code")
                lblCustName.text = ReqExeDataReader.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(lblCustCode.text) & "';","Cust_Name")
                ShowCustDet
    
                ShowModelDet
                lblLotNo.text = ResExeDataReader("LOT_NO")
                lblSODate.text = format(cdate(ResExeDataReader("SO_DATE")),"dd/MM/yy")
                txtPONo.text = ResExeDataReader("PO_NO").tostring
                txtPODate.text = format(cdate(ResExeDataReader("po_date")),"dd/MM/yy")
                txtReqDate.text = format(cdate(ResExeDataReader("req_date")),"dd/MM/yy")
                lblModelNo.text = ResExeDataReader("Model_No")
                lblModelName.text = ReqExeDataReader.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
    
                if isdbnull(ResExeDataReader("FOL")) = false then lblFOL.text = ResExeDataReader("FOL")
    
                if len(lblFOL.text) <> 0 then lblFOL.text = format(cdate(lblFOL.text),"dd/MM/yy")
    
    
    
    
    
    
                lblPayTerm.text = ResExeDataReader("pay_term").tostring
                lblConsignee.text = ResExeDataReader("CONSIGNEE").tostring
                lblNotifyParty.text = ResExeDataReader("NOTIFY_PARTY").tostring
                txtOrderQty.text = ResExeDataReader("ORDER_QTY").tostring
                txtRem.text = ResExeDataReader("REM").tostring
    
                IF ISDBNULL(ResExeDataReader("invoice_up")) = false then lblInvoiceUP.text = format(ResExeDataReader("INVOICE_UP"),"##,##0.00")
    
                lblCSDAppBy.text = ResExeDataReader("CSD_APP_BY").tostring
                if isdbnull(ResExeDataReader("CSD_APP_DATE")) = false then lblCSDAppDate.text = format(cdate(ResExeDataReader("CSD_APP_DATE")),"dd/MM/yy")
    
                if isdbnull(ResExeDataReader("PCMC_APP_BY")) = false then
                    lblPCMC.text = "PCMC - Approved By"
                    lblPCMCBy.text = ResExeDataReader("PCMC_APP_BY").tostring
                    lblPCMCDate.text = format(cdate(ResExeDataReader("PCMC_APP_Date")),"dd/MM/yy")
                    txtPCMCRem.text = ResExeDataReader("PCMC_APP_Rem").tostring
                End if
    
                if trim(ReqExeDataReader.FuncCheckDuplicate("Select CSD_APP_By from SO_MODELS_M where lot_no = '" & trim(lblLotNo.text) & "';","CSD_APP_By")) = true then
                    cmbUpdate.enabled = false
                    cmdSubmit.enabled = false
                    cmdCancelSO.enabled = false
                    cmdUpdateAdd.enabled = false
                    AmendSO.enabled = true
                End if
            loop
        End sub
    
        Sub ShowAlert(Msg as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        End sub
    
        Sub cmbUpdate_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then
                SaVeDetails
                ShowAlert("Sales Order Details updated.")
                redirectPage("SalesOrderModelDet.aspx?ID=" & Request.params("ID"))
            End if
        End Sub
    
        Sub SaveDetails()
            if page.isvalid = true then
                Dim ReqCOM as Erp_Gtm.erp_gtm = new Erp_Gtm.Erp_Gtm
                Dim DMth,DYr,DDay,strsql,DateInput as string
    
                DateInput = txtPODate.text
                DDay = DateInput.substring(0,2)
                DMth = DateInput.substring(3,2)
                DYr = DateInput.substring(6,2)
                txtPODate.text = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
    
                DateInput = txtReqDate.text
                DDay = DateInput.substring(0,2)
                DMth = DateInput.substring(3,2)
                DYr = DateInput.substring(6,2)
                txtReqDate.text = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
    
                strsql = "Update SO_MODELS_M set LOT_NO = '" & trim(lblLotno.text) & "',"
                strsql = strsql + "PO_NO = '" & trim(txtPONo.text) & "',"
                strsql = strsql + "PO_Date = '" & cdate(txtPODate.text) & "',"
                strsql = strsql + "CUST_CODE = '" & trim(lblCustCode.text) & "',"
                'strsql = strsql + "SHIP_CO = '" & trim(cmbShipCo.selecteditem.value) & "',"
                'strsql = strsql + "SHIP_ATT = '" & trim(lblShipAtt.text) & "',"
                'strsql = strsql + "SHIP_ADD1 = '" & trim(lblShipAdd1.text) & "',"
                'strsql = strsql + "SHIP_ADD2 = '" & trim(lblShipAdd2.text) & "',"
                'strsql = strsql + "SHIP_ADD3 = '" & trim(lblShipAdd3.text) & "',"
                'strsql = strsql + "SHIP_STATE = '" & trim(lblShipState.text) & "',"
                'strsql = strsql + "SHIP_COUNTRY = '" & trim(lblShipCountry.text) & "',"
                strsql = strsql + "REQ_DATE = '" & trim(txtReqDate.text) & "',"
                strsql = strsql + "ORDER_QTY = " & txtOrderQty.text & ","
                strsql = strsql + "INVOICE_UP = " & (lblInvoiceUP.text) & ","
                strsql = strsql + "REM = '" & (txtREM.text) & "',"
                strsql = strsql + "MODIFY_BY = '" & (request.cookies("U_ID").value) & "',"
                strsql = strsql + "MODIFY_DATE = '" & now & "' "
                strsql = strsql + "where Lot_No = '" & trim(lbllotNo.text) & "'"
                ReqCOM.ExecuteNonQuery(strsql)
            End if
        End sub
    
        Sub redirectPage(ReturnURL as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
            If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
        End sub
    
        Sub cmdCancel_Click(sender As Object, e As EventArgs)
            response.redirect("SalesOrderModel.aspx")
        End Sub
    
        Sub cmdSubmit_Click(sender As Object, e As EventArgs)
            if page.isvalid =true then
                Dim SenderName,SenderEmail,ReceiverName,ReceiverEmail as string
                Dim MSender,MReceiver as string
                Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
                SenderName = trim(request.cookies("U_ID").value)
                SenderEmail = ReqCOM.GetFieldVal("Select top 1 EMail from User_Profile where U_ID='" & trim(SenderName) & "';","EMail")
                ReceiverName = ReqCOM.GetFieldvAL("sELECT u_id FROM authority where module_name = 'SO APP' and APP_TYPE = 'APP1';","u_id")
                ReceiverEmail = ReqCOM.GetFieldVal("Select top 1 EMail from User_Profile where U_ID='" & trim(ReceiverName) & "';","EMail")
                SaVeDetails
                ReqCOM.ExecuteNonQuery("Update SO_MODELS_M set CSD_App_by = '" & trim(request.cookies("U_ID").value) & "', CSD_App_Date = '" & now & "',so_status = 'PENDING APPROVAL' where Lot_No = '" & trim(lblLotNo.text) & "';")
    
    
    
                MSender = trim(request.cookies("U_ID").value)
                MReceiver = "AngSN, TanCY"
    
                GeneratePendingEmailList(MSender,MReceiver,trim(lblLotNo.text))
    
    
                ShowAlert("Selected S/O submitted for PCMC approval.")
                redirectPage("SalesOrderModelDet.aspx?ID=" & Request.params("ID"))
            end if
        End Sub
    
        Sub GeneratePendingEmailList(Sender as string, Receiver as string,DOcNo as string)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim FromEmail,ToEmail,EmailSubject,EmailContent as string
            EmailContent = "Dear " & trim(Receiver) & vblf & vblf
            EmailContent = EmailContent + "There is a New S/O for your approval(Lot No # : " & trim(DOcNo) & ")." & vblf & vblf
            EmailContent = EmailContent + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=SalesOrderModelDetPCMC.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from SO_Models_M where Lot_No = '" & trim(DOcNo) & "';","Seq_No") & " to view the details." & vblf & vblf
            EmailContent = EmailContent + "Regards," & vblf
            EmailContent = EmailContent + trim(Sender)
            EmailSubject = "S/O Approval : " & DOcNo
            FromEmail = trim(ReqCOM.GetFieldVal("Select top 1 EMail from User_Profile where U_ID = '" & trim(Sender) & "';","Email"))
            ToEmail = "AngSN@g-tek.com.my;TanCY@g-tek.com.my"
            ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','S/O Model','N','" & trim(DOcNo) & "','" & trim(FromEmail) & "'")
        End sub
    
        SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
            with obj
                .items.clear
                .DataSource = ResExeDataReader
                .DataValueField = FValue
                .DataTextField = FText
                .DataBind()
            end with
            ResExeDataReader.close()
        End Sub
    
        Sub ClearCustDet()
            lblPayTerm.text = ""
            lblNotifyParty.text = ""
            lblConsignee.text = ""
        End Sub
    
        Sub ShowCustDet()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim RsModel as SQLDataReader = ReqCOM.ExeDataReader("Select * from Cust where Cust_Code = '" & trim(lblCustCode.text) & "';")
            Do while rsModel.read
                lblPayTerm.text = rsModel("Pay_Term").tostring
                lblNotifyParty.text = rsModel("Notify_Party").tostring
                lblConsignee.text = rsModel("Consignee").tostring
            Loop
            RsModel.close()
        End sub
    
    
    
    
        Sub ClearModelDet()
            lblInvoiceUP.text = ""
        End sub
    
        Sub ShowModelDet()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim RsModel as SQLDataReader = ReqCOM.ExeDataReader("Select * from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';")
            Do while rsModel.read
                lblInvoiceUP.text = format(CDEC(rsModel("UP")),"##,##0.00")
    
            Loop
            RsModel.close()
        End sub
    
        Sub cmdCancelSO_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQUery("Delete from SO_Models_m where seq_no = " & request.params("ID") & "")
            Response.redirect("SalesOrderModel.aspx")
        End Sub
    
        Sub cmbShipCo_SelectedIndexChanged(sender As Object, e As EventArgs)
    
        End Sub
    
        Sub cmdUpdateAdd_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then
                SaVeDetails
                response.redirect("SalesOrderModelAdd.aspx")
            end if
        End Sub
    
        Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
            Dim DateInput as string
            Dim DMth,DYr,DDay as string
    
            DateInput = txtPODate.text
            if trim(DateInput.length) = 8 then
                DDay = DateInput.substring(0,2)
                DMth = DateInput.substring(3,2)
                DYr = DateInput.substring(6,2)
                DateInput = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
                if isdate(DateInput) = false then
                    e.isvalid = false
                    ValDateInput.ErrorMessage = "You don't seem to have supplied a valid P/O Date"
                end if
            else
                e.isvalid = false
                ValDateInput.ErrorMessage = "You don't seem to have supplied a valid P/O Date"
            end if
    
            DateInput = txtReqDate.text
            if trim(DateInput.length) = 8 then
                DDay = DateInput.substring(0,2)
                DMth = DateInput.substring(3,2)
                DYr = DateInput.substring(6,2)
                DateInput = trim(DMth) & "/" & trim(DDay) & "/" & trim(DYr)
                if isdate(DateInput) = false then
                    e.isvalid = false
                    ValDateInput.ErrorMessage = "You don't seem to have supplied a valid Customer Req. Date"
                end if
            else
                e.isvalid = false
                ValDateInput.ErrorMessage = "You don't seem to have supplied a valid Customer Req. Date"
            end if
        End Sub
    
    Sub AmendSO_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesOrderModelAmend.aspx?ID=" & Request.params("ID"))
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
        </p>
        <p>
        </p>
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" cssclass="fORMdESC" width="100%">SALES ORDER
                            DETAILS - BY MODEL</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="76%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <div align="center">
                                                <asp:RequiredFieldValidator id="ValPONo" runat="server" EnableClientScript="False" ControlToValidate="txtPONo" ErrorMessage="You don't seem to have supplied a valid P/O No." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                            </div>
                                            <div align="center">
                                                <asp:RequiredFieldValidator id="ValOrderQty" runat="server" EnableClientScript="False" ControlToValidate="txtOrderQty" ErrorMessage="You don't seem to have supplied a valid Order Quantity." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                            </div>
                                            <div align="center">
                                                <asp:comparevalidator id="ValOrderQtyFormat" runat="server" EnableClientScript="False" ControlToValidate="txtOrderQty" ErrorMessage="You don't seem to have supplied a valid Order Qty." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" Type="Integer" Operator="DataTypeCheck"></asp:comparevalidator>
                                            </div>
                                            <div align="center">
                                                <asp:CustomValidator id="ValDateInput" runat="server" EnableClientScript="False" ErrorMessage="" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" OnServerValidate="ValDateInput_ServerValidate"></asp:CustomValidator>
                                            </div>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="100%">Lot No </asp:Label></td>
                                                            <td width="70%">
                                                                <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="100%">Issued Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSODate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="100%">Cust. Code
                                                                / Name</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCustname" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label17" runat="server" cssclass="LabelNormal" width="100%">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="100%">FOL (dd/mm/yy)</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblFOL" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="100%">P/O No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPONo" onkeydown="GetFocusWhenEnter(txtPODay)" runat="server" Width="195px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="100%">P/O Date
                                                                (dd/mm/yy)</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPODate" runat="server" Width="195px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label30" runat="server" cssclass="LabelNormal" width="100%">Req. Del.
                                                                Date (dd/mm/yy)</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtReqDate" runat="server" Width="195px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="100%">Order Qty.</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtOrderQty" onkeydown="GetFocusWhenEnter(txtRem)" runat="server" Width="195px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label14" runat="server" cssclass="LabelNormal" width="100%">Remarks</asp:Label></td>
                                                            <td>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label19" runat="server" cssclass="LabelNormal" width="100%">Payment
                                                                Term</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPayTerm" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label16" runat="server" cssclass="LabelNormal" width="100%">Notify
                                                                Party</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblNotifyParty" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="100%">Consignee</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblConsignee" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label33" runat="server" cssclass="LabelNormal" width="100%">U/P</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblInvoiceUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label34" runat="server" cssclass="LabelNormal" width="134px">CSD</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCSDAppBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCSDAppDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox id="txtRem" onkeydown="GetFocusWhenEnterWithoutSelect(cmbShipCo)" runat="server" Width="100%" CssClass="OutputText" Height="64px" TextMode="MultiLine"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="lblPCMC" runat="server" cssclass="LabelNormal" width="147px">PCMC</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPCMCBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblPCMCDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="txtPCMCRem" runat="server" cssclass="OutputText"></asp:Label></td>
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
                            <table style="HEIGHT: 27px" cellspacing="0" cellpadding="0" width="90%">
                                <tbody>
                                    <tr>
                                        <td width="16.66%">
                                            <p>
                                                <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="100%" CssClass="OutputText" Text="Update Changes"></asp:Button>
                                            </p>
                                        </td>
                                        <td width="22.66%">
                                            <div align="center">
                                                <asp:Button id="cmdUpdateAdd" onclick="cmdUpdateAdd_Click" runat="server" Width="100%" CssClass="OutputText" Text="Update and Add Another"></asp:Button>
                                            </div>
                                        </td>
                                        <td width="16.66%">
                                            <p align="center">
                                                <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="100%" CssClass="OutputText" Text="Submit to PCMC"></asp:Button>
                                            </p>
                                        </td>
                                        <td width="14.66%">
                                            <p align="center">
                                                <asp:Button id="AmendSO" onclick="AmendSO_Click" runat="server" Width="100%" CssClass="OutputText" Text="Amend S/O" Enabled="False" CausesValidation="False"></asp:Button>
                                            </p>
                                        </td>
                                        <td width="14.66%">
                                            <div align="center">
                                                <asp:Button id="cmdCancelSO" onclick="cmdCancelSO_Click" runat="server" Width="100%" CssClass="OutputText" Text="Cancel S/O" CausesValidation="False"></asp:Button>
                                            </div>
                                        </td>
                                        <td width="14.66%">
                                            <div align="right">
                                                <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="100%" CssClass="OutputText" Text="Back" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
