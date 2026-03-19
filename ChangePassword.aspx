<%@ Page Language="VB" Debug="true" %>
<script runat="server">

    Sub ValPasswordInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim compareString as string = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        Dim i as integer
        Dim CurrChar as string
        Dim Pwd as string = trim(txtPwd.text)
    
        if Pwd.length = 0 then exit sub
        For i = 0 to Pwd.length - 1
            CurrChar = Pwd.subString(i,1)
            If CompareString.indexOf(CurrChar) = -1 then
                e.isvalid = false : Exit sub
            End if
        Next i
        e.isvalid = true
    End Sub
    
    
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        Dim ClientIP As String
        ClientIP = Request.UserHostAddress
        response.write(Request.UserHostAddress)
        'Dim iphe As IPHostEntry = Dns.GetHostByName(Dns.GetHostName)
        'Response.write(ServerVariables("REMOTE_ADDR") )
        'strRemoteIP = Request.ServerVariables("REMOTE_ADDR")
        'Return iphe.AddressList
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as erp_GTM.erp_GTM = new erp_GTM.erp_GTM
            Dim StrSql = "Update User_Profile set Pwd = '" & trim(txtPwd.text) & "' where Seq_No = " & Request.params("ID") & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
            ShowAlert("User Password Accepted.")
        End if
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub

</script>
<html>
<head>
    <title>G-TEK ERP - Change Password</title>
    <link href="CssLogin.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <form runat="server">
        <p>
        </p>
        <p>
            <table style="WIDTH: 531px" width="531" align="center">
                <tbody>
                    <tr>
                        <td>
                            <table style="HEIGHT: 38px" width="100%" align="center">
                                <tbody>
                                    <tr>
                                        <td bgcolor="#8080ff" colspan="1" forecolor="white">
                                            <p align="center">
                                                &nbsp;<asp:Label id="Label3" runat="server" forecolor="White" font-bold="True">CHANGE
                                                PASSWORD</asp:Label> 
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#c0c0ff">
                                            <p>
                                                <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="98%" align="center">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <div align="center">
                                                                </div>
                                                                <div align="center">
                                                                    <asp:CompareValidator id="CompareValidator1" runat="server" CssClass="Errortext" ForeColor=" " Display="Dynamic" ControlToValidate="txtConPwd" ErrorMessage="Password not match." ControlToCompare="txtPwd"></asp:CompareValidator>
                                                                </div>
                                                                <div align="center">
                                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtConPwd" ErrorMessage="You don seem to have supplied a valid password."></asp:RequiredFieldValidator>
                                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="txtPwd" ErrorMessage="You don't seem to have supplied a valid Password."></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div align="center">
                                                                </div>
                                                                <p>
                                                                    <table style="HEIGHT: 39px" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p align="center">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="124px">Password </asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                        <asp:TextBox id="txtPwd" runat="server" Width="182px" CssClass="OutputText" size="25" textmode="Password"></asp:TextBox>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <p align="center">
                                                                                        <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="124px">Confirm
                                                                                        Password </asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                        <asp:TextBox id="txtConPwd" runat="server" Width="182px" CssClass="OutputText" size="25" TextMode="Password"></asp:TextBox>
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
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                        <td bgcolor="#8080ff">
                                            <p align="left">
                                            </p>
                                            <p align="left">
                                            </p>
                                            <p align="right">
                                                <table style="HEIGHT: 16px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="50%">
                                                            </td>
                                                            <td width="50%">
                                                                <div align="right">
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Text="Update Password"></asp:Button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <p align="center">
                                            </p>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
