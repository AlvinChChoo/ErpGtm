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
        Dim strSql as string = "SELECT * FROM SO_PART_M WHERE SEQ_NO = " & request.params("ID")  & ";"
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
            do while ResExeDataReader.read
            lblCustCode.text = ResExeDataReader("Cust_Code")
            lblLotNo.text = ResExeDataReader("LOT_NO")
            lblSODate.text = format(cdate(ResExeDataReader("SO_DATE")),"MM/dd/yyyy")
            lblCustName.text = ReqExeDataReader.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(ResExeDataReader("Cust_Code")) & "';","Cust_Name")
            lblDelDate.text = format(ResExeDataReader("req_date"),"MM/dd/yy")
            Loop
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesOrderPartsDetPCMC.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        If page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Update SO_PART_M set PCMC_App_By = '" & trim(txtUserID.text) & "',PCMC_APP_DATE = '" & NOW & "',PCMC_App_Rem = '" & txtRem.text & "' where Seq_No = " & request.params("ID") & ";")
            Response.redirect("SalesOrderPartsDetPCMC.aspx?ID=" & Request.params("ID"))
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
    <TITEL>
    </TITEL>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0">
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label13" runat="server" width="100%" cssclass="Instruction">Please
                            provide user anthentication and approval remarks</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <div align="center">
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid User ID." ControlToValidate="txtUserID" EnableClientScript="False"></asp:RequiredFieldValidator>
                                            </div>
                                            <div align="center">
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Password." ControlToValidate="txtPwd" EnableClientScript="False"></asp:RequiredFieldValidator>
                                            </div>
                                            <div align="center">
                                                <asp:CustomValidator id="CustomValidator1" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="Unvalid user authentication." EnableClientScript="False" OnServerValidate="ValLoginAc"></asp:CustomValidator>
                                            </div>
                                            <div align="center">
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Approval Remarks" ControlToValidate="txtRem"></asp:RequiredFieldValidator>
                                            </div>
                                            <table style="HEIGHT: 28px" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label6" runat="server" width="134px" cssclass="LabelNormal">Lot No </asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblLotNo" runat="server" width="379px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label7" runat="server" width="134px" cssclass="LabelNormal">Issued
                                                            Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblSODate" runat="server" width="379px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label8" runat="server" width="134px" cssclass="LabelNormal">Cust. Code</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblCustCode" runat="server" width="379px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label18" runat="server" width="134px" cssclass="LabelNormal">Cust.
                                                            Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblCustName" runat="server" width="379px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label10" runat="server" width="134px" cssclass="LabelNormal">Req. Del.
                                                            Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblDelDate" runat="server" width="323px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                            </p>
                                            <p>
                                            </p>
                                            <table style="HEIGHT: 28px" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label5" runat="server" width="" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                        <td>
                                                            <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="448px"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label2" runat="server" width="" cssclass="LabelNormal">User ID</asp:Label></td>
                                                        <td>
                                                            <asp:TextBox id="txtUserID" runat="server" CssClass="OutputText" Width="187px"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label3" runat="server" width="" cssclass="LabelNormal">Password</asp:Label></td>
                                                        <td>
                                                            <asp:TextBox id="txtPwd" runat="server" CssClass="OutputText" Width="187px" TextMode="Password"></asp:TextBox>
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
                                                                    <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="190px" Text="Approve this Sales Order"></asp:Button>
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
