<%@ Page Language="VB" %>
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
        if page.ispostback = false then loaddata()
    End Sub
    
    Sub LoadData
        Dim strSql as string = "SELECT * FROM SO_MODELS_M WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
    
        do while ResExeDataReader.read
            lblCustCode.text = ResExeDataReader("Cust_Code")
            lblCustName.text = ReqExeDataReader.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(lblCustCode.text) & "';","Cust_Name")
            lblLotNo.text = ResExeDataReader("LOT_NO")
            lblSODate.text = format(cdate(ResExeDataReader("SO_DATE")),"dd/MM/yy")
            lblModelNo.text = ResExeDataReader("Model_No")
            lblModelName.text = ReqExeDataReader.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
    
            lblReqDate.text = format(cdate(ResExeDataReader("req_date")),"dd/MM/yy")
            lblOrderQty.text = ResExeDataReader("ORDER_QTY").tostring
    
            txtReqDate.text = format(cdate(ResExeDataReader("req_date")),"dd/MM/yy")
            txtOrderQty.text = ResExeDataReader("ORDER_QTY").tostring
        loop
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim MSender,MReceiver as string
    
            ReqCOm.ExecuteNonQuery("Update SO_Models_M set req_date = '" & cdate(ReqCom.FormatDate(txtReqDate.text)) & "',ORDER_QTY = " & clng(txtOrderQty.text) & " where lot_no = '" & trim(lblLotNo.text) & "';")
            MSender = trim(request.cookies("U_ID").value)
            MReceiver = "AngSN, TanCY"
            GeneratePendingEmailList(MSender,MReceiver,trim(lblLotNo.text))
            ShowAlert("Sales Order Details updated.")
            redirectPage("SalesOrderModelAmend.aspx?ID=" & Request.params("ID"))
    
        End if
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderModelDet.aspx?ID=" & clng(Request.params("ID")))
    End Sub
    
    Sub GeneratePendingEmailList(Sender as string, Receiver as string,DOcNo as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim FromEmail,ToEmail,EmailSubject,EmailContent as string
        EmailContent = "Dear " & trim(Receiver) & vblf & vblf
        EmailContent = EmailContent + "There is an amendment for Sales Order(Lot No # : " & trim(DOcNo) & ")." & vblf & vblf
        EmailContent = EmailContent & "The amendment are as below" & vblf
        EmailContent = EmailContent & vbtab & "Order Qty : " & clng(lblOrderQty.text) & " to " & clng(txtOrderQty.text) & vblf
        EmailContent = EmailContent & vbtab & "Req. Del. Date : " & trim(lblReqDate.text) & " to " & trim(txtReqDate.text) & vblf & vblf
        EmailContent = EmailContent + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=SalesOrderModelDetPCMC.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from SO_Models_M where Lot_No = '" & trim(DOcNo) & "';","Seq_No") & " to view the details." & vblf & vblf
        EmailContent = EmailContent + "Regards," & vblf
        EmailContent = EmailContent + trim(Sender)
        EmailSubject = "S/O Amendment : " & DOcNo
        FromEmail = trim(ReqCOM.GetFieldVal("Select top 1 EMail from User_Profile where U_ID = '" & trim(Sender) & "';","Email"))
        ToEmail = "AngSN@g-tek.com.my;TanCY@g-tek.com.my"
        ReqCOM.ExecuteNonQuery("Insert into pending_email(FROM_EMAIL,FROM_NAME,TO_NAME,TO_EMAIL,EMAIL_SUBJECT,EMAIL_CONTENT,MODULE_NAME,ADD_ATT,REF_NO,CC) select '" & trim(FromEmail) & "','" & trim(Sender) & "','" & trim(Receiver) & "','" & trim(ToEmail) & "','" & trim(EmailSubject) & "','" & trim(EmailContent) & "','S/O Model','N','" & trim(DOcNo) & "','" & trim(FromEmail) & "'")
    End sub
    
    Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        e.isvalid = true
        if ReqCOM.ISDate(trim(txtReqDate.text)) = false then e.isvalid = false
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                            <asp:Label id="Label1" runat="server" width="100%" cssclass="fORMdESC">SALES ORDER
                            DETAILS - BY MODEL</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="76%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <div align="center">
                                                <asp:RequiredFieldValidator id="ValOrderQty" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Order Quantity." ControlToValidate="txtOrderQty" EnableClientScript="False"></asp:RequiredFieldValidator>
                                            </div>
                                            <div align="center">
                                                <asp:comparevalidator id="ValOrderQtyFormat" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Order Qty." ControlToValidate="txtOrderQty" EnableClientScript="False" Operator="DataTypeCheck" Type="Integer"></asp:comparevalidator>
                                            </div>
                                            <div align="center">
                                                <asp:CustomValidator id="ValDateInput" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Req. Del Date." EnableClientScript="False" OnServerValidate="ValDateInput_ServerValidate"></asp:CustomValidator>
                                            </div>
                                            <div align="center">
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Order Quantity." ControlToValidate="txtOrderQty"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Cust. Req. Date." ControlToValidate="txtReqDate"></asp:RequiredFieldValidator>
                                            </div>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="100%" cssclass="LabelNormal">Lot No </asp:Label></td>
                                                            <td width="70%">
                                                                <asp:Label id="lblLotNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" width="100%" cssclass="LabelNormal">Issued Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSODate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" width="100%" cssclass="LabelNormal">Cust. Code
                                                                / Name</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCustname" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label17" runat="server" width="100%" cssclass="LabelNormal">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                            </td>
                                                            <td bgcolor="silver">
                                                                <div align="center"><asp:Label id="Label8" runat="server" cssclass="LabelNormal">Before
                                                                    Changes</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td bgcolor="silver">
                                                                <div align="center"><asp:Label id="Label9" runat="server" cssclass="LabelNormal">AfterChanges</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Order Qty.</asp:Label></td>
                                                            <td>
                                                                <div align="center"><asp:Label id="lblOrderQty" runat="server" cssclass="OutputText"></asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtOrderQty" runat="server" CssClass="OutputText" Width="118px"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Req. Del. Date (dd/MM/yy)</asp:Label></td>
                                                            <td>
                                                                <div align="center"><asp:Label id="lblReqDate" runat="server" cssclass="OutputText"></asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div align="center">
                                                                    <asp:TextBox id="txtReqDate" runat="server" CssClass="OutputText" Width="118px"></asp:TextBox>
                                                                </div>
                                                            </td>
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
                                                                    <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" CssClass="OutputText" Width="138px" Text="Update Changes"></asp:Button>
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" CssClass="OutputText" Width="118px" Text="Back" CausesValidation="False"></asp:Button>
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
