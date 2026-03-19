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
            loaddata
            if ucase(trim(lblStatus.text)) = "PENDING APPROVAL" or ucase(trim(lblStatus.text)) = "PENDING CANCELLATION" then
                cmdSubmit.enabled = true
                Label8.visible = true
                txtRem.visible = true
    
    
            Else
                cmdSubmit.enabled = false
                Label8.visible = false
                txtRem.visible = false
    
            End if
        End if
    End Sub
    
    Sub LoadData
        Dim strSql as string = "SELECT * FROM SO_MODELS_M WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
    
        do while ResExeDataReader.read
            lblCustCode.text = ResExeDataReader("Cust_Code")
            lblModelNo.text = trim(ResExeDataReader("Model_No").tostring)
            lblModelName.text = ReqExeDataReader.GetFieldVal("Select Model_Desc from model_master where model_code = '" & trim(trim(ResExeDataReader("Model_No").tostring)) & "';","Model_Desc")
    
            lblLotNo.text = ResExeDataReader("LOT_NO")
            lblSODate.text = format(cdate(ResExeDataReader("SO_DATE")),"dd/MM/yy")
            lblPONo.text = ResExeDataReader("PO_NO").tostring
            if isdbnull(ResExeDataReader("PO_DATE")) = false then lblPODate.text = format(ResExeDataReader("PO_DATE"),"dd/MM/yy")
            lblCustName.text = ReqExeDataReader.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(ResExeDataReader("Cust_Code")) & "';","Cust_Name")
            lblStatus.text = ResExeDataReader("SO_Status")
            lblCSDRem.text = ResExeDataReader("Rem").tostring()
            lblPCMCRem.text = ResExeDataReader("PCMC_APP_Rem").tostring()
            lblOrderQty.text = ResExeDataReader("ORDER_QTY").tostring
            txtFOL.text = ResExeDataReader("FOL").tostring
            if trim(txtFOL.text) <> "" then txtFOL.text = format(cdate(txtFOL.text),"dd/MM/yy")
    
            lblCSDAppBy.text = ResExeDataReader("CSD_APP_BY").tostring
            if isdbnull(ResExeDataReader("CSD_APP_DATE")) = false then lblCSDAppDate.text = format(ResExeDataReader("CSD_APP_DATE"),"dd/MM/yy")
            lblPCMCAppBy.text = ResExeDataReader("PCMC_APP_BY").tostring
            if isdbnull(ResExeDataReader("PCMC_APP_DATE")) = false then lblPCMCAppDate.text = format(ResExeDataReader("PCMC_APP_DATE"),"dd/MM/yy")
            if trim(lblDelDate.text) <> "" then lblDelDate.text = format(ResExeDataReader("req_date"),"dd/MM/yy")
        loop
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            if ucase(trim(lblStatus.text)) = "PENDING APPROVAL" then
                ReqCOM.ExecuteNonQuery("Update SO_ModelS_M set PCMC_App_By = '" & trim(request.cookies("U_ID").value) & "',PCMC_App_Date = '" & now & "',PCMC_App_Rem = '" & txtRem.text & "',SO_STATUS = 'APPROVED',pcmc_approved = 'Y',FOL = '" & cdate(ReqCOM.FormatDate(txtFOL.text)) & "' where Seq_No = " & request.params("ID") & ";")
                ShowAlert("Selected Sales Order has been approved.")
            Elseif ucase(trim(lblStatus.text)) = "PENDING CANCELLATION" then
                ReqCOM.ExecuteNonQuery("Update SO_ModelS_M set Cancel2_By = '" & trim(request.cookies("U_ID").value) & "',Cancel2_Date = '" & now & "',Cancel2_Rem = '" & txtRem.text & "',SO_STATUS = 'CANCELLED',FOL = '" & cdate(txtFOL.text) & "' where Seq_No = " & request.params("ID") & ";")
                ShowAlert("Selected Sales Order has been approved.")
            End if
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
    
    Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOM.IsDate(txtFOL.text) = true then e.isvalid = true else e.isvalid = false
    End Sub
    
    Sub cmdClose_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">SALES ORDER
                            DETAILS - PCMC APPROVAL</asp:Label>
                        </p>
                        <p align="center">
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 80%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="80%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <div align="center">
                                                <asp:CustomValidator id="ValDateInput" runat="server" Width="100%" CssClass="ErrorText" OnServerValidate="ValDateInput_ServerValidate" EnableClientScript="False" ErrorMessage="You don't seem to have supplied a valid Final Online Date" Display="Dynamic" ForeColor=" "></asp:CustomValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don seem to have supplied a valid Final Online Date." Display="Dynamic" ForeColor=" " ControlToValidate="txtFOL"></asp:RequiredFieldValidator>
                                            </div>
                                            <div align="center">
                                            </div>
                                            <div align="center">
                                            </div>
                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td width="25%" bgcolor="silver">
                                                            <asp:Label id="Label2" runat="server" width="134px" cssclass="LabelNormal">Lot No </asp:Label></td>
                                                        <td width="75%">
                                                            <asp:Label id="lblLotNo" runat="server" width="379px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label3" runat="server" width="134px" cssclass="LabelNormal">Issued
                                                            Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblSODate" runat="server" width="379px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label4" runat="server" width="134px" cssclass="LabelNormal">Cust. Code
                                                            / Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCustName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label5" runat="server" width="134px" cssclass="LabelNormal">Model No
                                                            / Desc.</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label6" runat="server" width="134px" cssclass="LabelNormal">P/O No</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblPONo" runat="server" cssclass="OutputText"></asp:Label>&nbsp; (<asp:Label id="lblPODate" runat="server" cssclass="OutputText"></asp:Label>)</td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label30" runat="server" width="134px" cssclass="LabelNormal">Req. Del.
                                                            Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblDelDate" runat="server" width="323px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label9" runat="server" width="134px" cssclass="LabelNormal">Lot Qty</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblOrderQty" runat="server" width="323px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label11" runat="server" cssclass="LabelNormal">FOL (dd/mm/yy)</asp:Label></td>
                                                        <td>
                                                            <asp:TextBox id="txtFOL" runat="server" CssClass="OutputText"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label13" runat="server" width="134px" cssclass="LabelNormal">Status</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblStatus" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label34" runat="server" cssclass="LabelNormal">CSD Approval</asp:Label></td>
                                                            <td width="75%">
                                                                <asp:Label id="lblCSDAppBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCSDAppDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblCSDRem" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label35" runat="server" cssclass="LabelNormal">PCMC Approval</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPCMCAppBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblPCMCAppDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblPCMCRem" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr valign="top">
                                                            <td valign="top" width="25%">
                                                                <asp:Label id="Label8" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtRem" runat="server" Width="100%" CssClass="OutputText" Height="41px" TextMode="MultiLine"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p align="left">
                                                <table style="HEIGHT: 13px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="50%">
                                                                <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="138px" CssClass="OutputText" Text="Submit"></asp:Button>
                                                            </td>
                                                            <td width="50%">
                                                                <div align="right">
                                                                    <asp:Button id="cmdClose" onclick="cmdClose_Click" runat="server" Width="157px" CssClass="OutputText" Text="Close" CausesValidation="False"></asp:Button>
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
