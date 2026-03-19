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
            dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust order by Cust_Code asc","Cust_Code","Desc",cmbCustCode)
            Dissql ("Select Model_Code, Model_Code + '|' + model_Desc as [Desc] from Model_Master where Cust_Code = '" & trim(cmbCustCode.selecteditem.value) & "' order by Model_Code asc","Model_Code","Desc",cmbModelNo)
            lblSODate.text = format(cdate(Now),"dd/MM/yy")
            ShowCustDet
        end if
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderModel.aspx")
    End Sub
    
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
    
    Sub cmbShipCo_SelectedIndexChanged(sender As Object, e As EventArgs)
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
    
    Sub ShowCustDet()
        Dim ReqCOM as erp_gtm.erp_gtm = new erp_gtm.erp_gtm
        lblnotifyParty.text = ReqCOM.GetFieldVal("Select Notify_Party from Cust where Cust_Code = '" & trim(cmbCustCode.selecteditem.value) & "';","Notify_Party")
        lblPayTerm.text = ReqCOM.GetFieldVal("Select Pay_Term from Cust where Cust_Code = '" & trim(cmbCustCode.selecteditem.value) & "';","Pay_Term")
        lblConsignee.text = ReqCOM.GetFieldVal("Select Consignee from Cust where Cust_Code = '" & trim(cmbCustCode.selecteditem.value) & "';","Consignee")
    End sub
    
    Sub ValLotNo_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOM.FuncCheckDuplicate("Select Lot_No from SO_Models_M where Lot_No = '" & trim(txtLotNo.text) & "';","Lot_No") = true then e.isvalid = false
    End Sub
    
    Sub cmbCustCode_SelectedIndexChanged(sender As Object, e As EventArgs)
        ShowCustDet
        Dissql ("Select Model_Code, Model_Code + '|' + model_Desc as [Desc] from Model_Master where Cust_Code = '" & trim(cmbCustCode.selecteditem.value) & "' order by Model_Code asc","Model_Code","Desc",cmbModelNo)
    End Sub
    
    Sub cmdSave_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then SaveSO
    End Sub
    
    Sub SaveSO()
        Dim ReqCOM as erp_gtm.erp_gtm = new erp_gtm.erp_gtm
        Dim DMth,DYr,DDay,strsql,DateInput as string
        Dim UP as decimal
    
        UP = ReqCOM.GetFieldVal("select UP from model_master where model_Code = '" & trim(cmbModelNo.selecteditem.value) & "';","UP")
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
        StrSql = "Insert into SO_Models_M(model_No,LOT_NO,PO_NO,PO_Date,CUST_CODE,SO_DATE,REQ_DATE,ORDER_QTY,INVOICE_UP,REM,Create_By,Create_Date) "
        StrSql = StrSql & "Select '" & trim(cmbModelNo.selecteditem.value) & "','" & trim(txtLotNo.text) & "','" & trim(txtPONo.text) & "','" & cdate(txtPODate.text) & "','" & trim(cmbCustCode.selecteditem.value) & "','" & cdate(now) & "','" & trim(txtReqDate.text) & "'," & txtOrderQty.text & "," & cdec(UP) & ",'" & trim(replace(txtREM.text,"'","`")) & "','" & (request.cookies("U_ID").value) & "','" & now & "';"
        ReqCOM.ExecuteNonQuery(StrSql)
    
        if cmbShipCo.selectedindex = 0 then
            StrSql = "Update SO_Models_M set SHIP_CO = '" & trim(cmbShipCo.selecteditem.value) & "',"
            StrSql = StrSql & "SHIP_ATT = '" & trim(lblShipAtt.text) & "',"
            StrSql = StrSql & "SHIP_ADD1 = '" & trim(lblShipAdd1.text) & "',"
            StrSql = StrSql & "SHIP_ADD2 = '" & trim(lblShipAdd2.text) & "',"
            StrSql = StrSql & "SHIP_ADD3 = '" & trim(lblShipAdd3.text) & "',"
            StrSql = StrSql & "SHIP_STATE = '" & trim(lblShipState.text) & "',"
            StrSql = StrSql & "SHIP_COUNTRY = '" & trim(lblShipCountry.text) & "'"
            StrSql = StrSql & " where Lot_No = '" & trim(txtLotNo.text) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
        end if
    
        ShowAlert("New Sales Order Created.")
        redirectPage("SalesOrderModelDet.aspx?ID=" & ReqCom.GetFieldVal("Select Seq_No from SO_Models_M where Lot_NO = '" & trim(txtLotNo.text) & "';","Seq_No"))
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
        ToEmail = "AngSN@g-tek.com.my;TanCY@g-tek.com.my;ada@gtek.com.tw"
        ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','S/O Model','N','" & trim(DOcNo) & "','" & trim(FromEmail) & "'")
    End sub
    
    Sub cmbModelNo_SelectedIndexChanged_1(sender As Object, e As EventArgs)
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdSaveAndSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim MSender,MReceiver as string
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            SaveSO
    
            MSender = trim(request.cookies("U_ID").value)
            MReceiver = "AngSN, TanCY"
            GeneratePendingEmailList(MSender,MReceiver,trim(txtLotNo.text))
            ReqCOM.ExecuteNonQuery("Update SO_MODELS_M set CSD_App_by = '" & trim(request.cookies("U_ID").value) & "', CSD_App_Date = '" & now & "',so_status = 'PENDING APPROVAL' where Lot_No = '" & trim(txtLotNo.text) & "';")
        End if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
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
                                                <asp:RequiredFieldValidator id="ReqLotNo" runat="server" ControlToValidate="txtLotNo" ErrorMessage="You don't seem to have supplied a valid Lot No." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtPODate" ErrorMessage="You don't seem to have supplied a valid P/O Date" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtReqDate" ErrorMessage="You don't seem to have supplied a valid Req. Date" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ControlToValidate="txtOrderQty" ErrorMessage="You don't seem to have supplied a valid Order Qty" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ControlToValidate="txtPONo" ErrorMessage="You don't seem to have supplied a valid P/O No" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                <asp:CustomValidator id="ValDateInput" runat="server" ErrorMessage="" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" OnServerValidate="ValDateInput_ServerValidate" EnableClientScript="False"></asp:CustomValidator>
                                                <asp:CustomValidator id="ValLotNo" runat="server" ErrorMessage="Lot No already exist. Please select another." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" OnServerValidate="ValLotNo_ServerValidate" EnableClientScript="False"></asp:CustomValidator>
                                                <asp:CompareValidator id="CompareValidator1" runat="server" ControlToValidate="txtOrderQty" ErrorMessage="You don's seem to have supplied a valid Order Qty." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" ValueToCompare="0" Type="Integer" Operator="GreaterThan"></asp:CompareValidator>
                                            </div>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="100%">Issued Date</asp:Label></td>
                                                            <td width="70%">
                                                                <asp:Label id="lblSODate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="100%">Lot No </asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtLotNo" runat="server" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="100%">Cust. Code
                                                                / Name</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbCustCode" runat="server" Width="100%" CssClass="OutputText" autopostback="true" OnSelectedIndexChanged="cmbCustCode_SelectedIndexChanged"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label17" runat="server" cssclass="LabelNormal" width="100%">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbModelNo" runat="server" Width="100%" CssClass="OutputText" OnSelectedIndexChanged="cmbModelNo_SelectedIndexChanged_1"></asp:DropDownList>
                                                            </td>
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
                                                                <asp:Label id="Label30" runat="server" cssclass="LabelNormal" width="157px">Req. Del.
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
                                                                <asp:TextBox id="txtRem" onkeydown="GetFocusWhenEnterWithoutSelect(cmbShipCo)" runat="server" Width="100%" CssClass="OutputText" Height="89px" TextMode="MultiLine"></asp:TextBox>
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
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="2">
                                                                <p align="center">
                                                                    SHIPPING 
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="134px">Company</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbShipCo" runat="server" Width="100%" CssClass="OutputText" OnSelectedIndexChanged="cmbShipCo_SelectedIndexChanged"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label25" runat="server" cssclass="LabelNormal" width="134px">Attention</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblShipAtt" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="3">
                                                                <asp:Label id="Label26" runat="server" cssclass="LabelNormal" width="134px">Address</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblShipAdd1" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblShipAdd2" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblShipAdd3" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label27" runat="server" cssclass="LabelNormal" width="134px">State</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblShipState" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label28" runat="server" cssclass="LabelNormal" width="134px">Country</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblShipCountry" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label31" runat="server" cssclass="LabelNormal" width="134px">Prepared
                                                                by</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPreparedBy" runat="server" cssclass="OutputText" width="117px"></asp:Label><asp:Label id="lblPreparedDate" runat="server" cssclass="OutputText" width="184px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label34" runat="server" cssclass="LabelNormal" width="134px">CSD</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCSDAppBy" runat="server" cssclass="OutputText" width="117px"></asp:Label><asp:Label id="lblCSDAppDate" runat="server" cssclass="OutputText" width="184px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="lblPCMC" runat="server" cssclass="LabelNormal" width="147px">PCMC</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPCMCBy" runat="server" cssclass="OutputText" width="117px"></asp:Label><asp:Label id="lblPCMCDate" runat="server" cssclass="OutputText" width="184px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="lblPCMCRem" runat="server" cssclass="LabelNormal" width="147px">PCMC
                                                                - Remarks</asp:Label>&nbsp;</td>
                                                            <td>
                                                                <asp:Label id="txtPCMCRem" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="HEIGHT: 27px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <p>
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="138px" CssClass="OutputText" Text="Save S/O"></asp:Button>
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <p align="center">
                                                                    <asp:Button id="cmdSaveAndSubmit" onclick="cmdSaveAndSubmit_Click" runat="server" Width="138px" CssClass="OutputText" Text="Save and Submit"></asp:Button>
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="138px" CssClass="OutputText" Text="Back" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
