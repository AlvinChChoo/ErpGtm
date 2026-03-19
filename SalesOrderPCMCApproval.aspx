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
        Dim strSql as string = "SELECT * FROM SO_MODELS_M WHERE SEQ_NO = " & request.params("ID")  & ";"
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
            do while ResExeDataReader.read
            lblCustCode.text = ReqExeDataReader.GetFieldVal("Select CUST_CODE + ' ( ' + Cust_Name + ')' AS [Cust_Name] from Cust where Cust_Code = '" & trim(ResExeDataReader("Cust_Code")) & "';","Cust_Name")
            lblModelNo.text = ReqExeDataReader.GetFieldVal("Select MODEL_CODE + ' (' + Model_Desc + ')' AS [MODEL_DESC] from model_master where model_code = '" & trim(trim(ResExeDataReader("Model_No").tostring)) & "';","Model_Desc")
            lblLotNo.text = ResExeDataReader("LOT_NO")
            lblSODate.text = format(cdate(ResExeDataReader("SO_DATE")),"MM/dd/yyyy")
            lblOrderQty.text = ResExeDataReader("ORDER_QTY").tostring
            lblDelDate.text = format(ResExeDataReader("req_date"),"MM/dd/yy")
            Loop
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesOrderModelApp.aspx")
    End Sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        If page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Update SO_ModelS_M set PCMC_App_By = '" & trim(txtUserID.text) & "',PCMC_App_Date = '" & now & "',Prod_Date = '" & txtFOD.text & "',PCMC_App_Rem = '" & txtRem.text & "',so_status = 'APPROVED' where Seq_No = " & request.params("ID") & ";")
            Response.redirect("SalesOrderModelApp.aspx")
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
                        </p>
                        <p align="center">
                            <asp:Label id="Label13" runat="server" width="100%" cssclass="Instruction">Please
                            provide user anthentication and approval remarks</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="90%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <div align="center">
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Final online Date." ControlToValidate="txtFOD" EnableClientScript="False"></asp:RequiredFieldValidator>
                                            </div>
                                            <div align="center">
                                                <asp:comparevalidator id="CompareValidator2" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Final Online Date." ControlToValidate="txtFOD" EnableClientScript="False" Operator="DataTypeCheck" Type="Date"></asp:comparevalidator>
                                            </div>
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
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Approval Remarks." ControlToValidate="txtRem"></asp:RequiredFieldValidator>
                                            </div>
                                            <table style="HEIGHT: 28px" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label6" runat="server" width="" cssclass="LabelNormal">Lot No </asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblLotNo" runat="server" width="379px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label7" runat="server" width="" cssclass="LabelNormal">Issued Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblSODate" runat="server" width="379px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label8" runat="server" width="" cssclass="LabelNormal">Cust. Code /
                                                            Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblCustCode" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label9" runat="server" width="" cssclass="LabelNormal">Model No / Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblModelNo" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label10" runat="server" width="" cssclass="LabelNormal">Req. Del. Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblDelDate" runat="server" width="323px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label12" runat="server" width="" cssclass="LabelNormal">Lot Qty</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblOrderQty" runat="server" width="323px" cssclass="OutputText"></asp:Label></td>
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
                                                            <asp:Label id="Label5" runat="server" width="134px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                        <td>
                                                            <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="444px"></asp:TextBox>
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
