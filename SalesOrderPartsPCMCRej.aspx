<%@ Page Language="VB" Debug="TRUE" %>
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
            Dim strSql as string = "SELECT * FROM SO_PART_M WHERE SEQ_NO = " & request.params("ID")  & ";"
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
    
            do while ResExeDataReader.read
                lblCustCode.text = ReqExeDataReader.GetFieldVal("Select CUST_CODE + ' (' + Cust_Name + ')' AS [CUST_NAME] from Cust where Cust_Code = '" & trim(ResExeDataReader("Cust_Code")) & "';","Cust_Name")
                lblLotNo.text = ResExeDataReader("LOT_NO")
                lblSODate.text = format(cdate(ResExeDataReader("SO_DATE")),"MM/dd/yyyy")
                lblDelDate.text = format(ResExeDataReader("req_date"),"MM/dd/yy")
            Loop
        End if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesOrderPartsDetPCMC.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        If page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Update SO_PART_M set CSD_App_By = null,CSD_App_Date = null, PCMC_Rej_By = '" & trim(txtUserID.text) & "',PCMC_Rej_Date = '" & now & "', PCMC_REJ_REM = '" & txtRejRem.text & "' where Seq_No = " & request.params("ID") & ";")
            Response.redirect("SalesOrderPartApp.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub ValLoginAc(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOm.FuncCheckDuplicate("Select U_ID from User_Profile where U_ID = '" & trim(txtUserID.text) & "' and Pwd = '" & trim(txtPwd.text) & "';","U_ID") = true then
            e.isvalid = true
        else
            e.isvalid = false
        end if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label5" runat="server" cssclass="Instruction" width="100%">Please provide
                            user anthentication and reject remarks</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" EnableClientScript="False" ControlToValidate="txtUserID" ErrorMessage="You don't seem to have supplied a valid User ID." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                            <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" EnableClientScript="False" ControlToValidate="txtPwd" ErrorMessage="You don't seem to have supplied a valid Password." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                            <asp:CustomValidator id="CustomValidator1" runat="server" EnableClientScript="False" ErrorMessage="Unvalid user authentication." Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" OnServerValidate="ValLoginAc"></asp:CustomValidator>
                                            <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtRejRem" ErrorMessage="RequiredFieldValidator" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                            <table style="HEIGHT: 28px" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="134px">Lot No </asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="134px">Issued
                                                            Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblSODate" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="134px">Cust. Code
                                                            / Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblCustCode" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="134px">Req. Del.
                                                            Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblDelDate" runat="server" cssclass="OutputText" width="323px"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                            </p>
                                            <table style="HEIGHT: 28px" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="">Remarks</asp:Label></td>
                                                        <td>
                                                            <asp:TextBox id="txtRejRem" runat="server" Width="433px" CssClass="OutputText"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="">User ID</asp:Label></td>
                                                        <td>
                                                            <asp:TextBox id="txtUserID" runat="server" Width="205px" CssClass="OutputText"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="">Password</asp:Label></td>
                                                        <td>
                                                            <asp:TextBox id="txtPwd" runat="server" Width="205px" CssClass="OutputText" TextMode="Password"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <p>
                                                                    <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="190px" Text="Reject this Sales Order"></asp:Button>
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="179px" Text="Cancel" CausesValidation="False"></asp:Button>
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
