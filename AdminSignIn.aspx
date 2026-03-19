<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="Copyright" TagName="Copyright" Src="_Copyright.ascx" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        lnkSetHomePage.attributes.add("onClick","javascript:this.style.behavior='url(#default#homepage)';this.setHomePage('http://gtekapp/erp/signin.aspx');")
        lnkSetBookmark.attributes.add("onClick","javascript:window.external.AddFavorite('http://gtekapp/erp/signin.aspx','G-Tek ERP Application');")
    End sub
    
    Sub cmdSignIn_Click(sender As Object, e As EventArgs)
        If Page.IsValid = True Then
            Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim ResGetFieldVal as string
                resGetFieldVal= ReqGetFieldVal.GetFieldVal("Select ClientID from CustomClientSetup where ClientID = '" & trim(txtU_ID.text) & "' and ClientPwd = '" & trim(txtPwd.text) & "';","ClientID")
                If resGetFieldVal <> "" Then
                    Response.Cookies("UID").Value = Server.HtmlEncode(resGetFieldVal)
                    response.redirect("AdminPage.aspx")
                End If
        End If
    End Sub
    
    Sub ValLoginAc(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOm.FuncCheckDuplicate("Select ClientID from CustomClientSetup where ClientID = '" & trim(txtU_ID.text) & "' and ClientPwd = '" & trim(txtPwd.text) & "';","ClientID") = true then
            e.isvalid = true
        else
            e.isvalid = false
        end if
    End Sub
    
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
    
    Sub CustomValidator2_ServerValidate(sender As Object, e As ServerValidateEventArgs)
    Dim compareString as string = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        Dim i as integer
        Dim CurrChar as string
        Dim Pwd as string = trim(txtU_ID.text)
    
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
    End Sub
    
    Sub cmdChangePwd_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim ReturnURL as string = "ChangePassword.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from User_Profile where U_ID = '" & trim(txtU_ID.text) & "';","Seq_No")
            Dim Script As New System.Text.StringBuilder
            Script.Append("<script language=javascript>")
            Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=650,height=250');")
            Script.Append("</script" & ">")
            RegisterStartupScript("ShowExistingSupplier", Script.ToString())
        End if
    End Sub
    
    Sub txtPwd_TextChanged(sender As Object, e As EventArgs)
    End Sub

</script>
<html>
<head>
    <link href="css.css" type="text/css" rel="stylesheet" />
    <link href="inc/styles.css" type="text/css" rel="stylesheet" />
</head>
<body onkeypress="KeyPress()">
    <form runat="server">
        <p>
        </p>
        <p>
        </p>
        <p align="center">
            <table width="450">
                <tbody>
                    <tr>
                        <td align="middle" width="445" background="login-header.gif" height="60">
                            &nbsp;<asp:Label id="Label1" runat="server" height="26px" width="350px" cssclass="f12_white_b" font-bold="False">Nexpro
                            Administrator Login</asp:Label> 
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center">
                                <table style="WIDTH: 450px; HEIGHT: 100px" bordercolor="silver" cellspacing="0" cellpadding="0" align="center" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="emailRequired" runat="server" ErrorMessage="You don't seem to have supplied a valid User ID." ControlToValidate="txtU_ID" Display="dynamic" Font-Name="verdana" ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="passwordRequired" runat="server" ErrorMessage="You don't seem to have supplied a valid Password." ControlToValidate="txtPwd" Display="Dynamic" Font-Name="verdana" ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" ErrorMessage="Login Failed." Display="Dynamic" ForeColor=" " CssClass="ErrorText" Width="100%" EnableClientScript="False" OnServerValidate="ValLoginAc"></asp:CustomValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CustomValidator id="ValPasswordInput" runat="server" ErrorMessage="Invalid User Password." Display="Dynamic" ForeColor=" " CssClass="ErrorText" Width="100%" OnServerValidate="ValPasswordInput_ServerValidate"></asp:CustomValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CustomValidator id="CustomValidator2" runat="server" ErrorMessage="Invalid User ID." Display="Dynamic" ForeColor=" " CssClass="ErrorText" Width="100%" OnServerValidate="CustomValidator2_ServerValidate"></asp:CustomValidator>
                                                </div>
                                                <table style="WIDTH: 450px; HEIGHT: 50px" align="center">
                                                    <tbody>
                                                        <tr>
                                                            <td width="40%">
                                                                <div align="right"><asp:Label id="Label8" runat="server" cssclass="f8_grey">User Name</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td width="60%">
                                                                <asp:TextBox id="txtU_ID" size="25" runat="server" CssClass="Input_box" Width="182px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="right"><asp:Label id="Label9" runat="server" cssclass="f8_grey">Password</asp:Label>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox id="txtPwd" size="25" runat="server" CssClass="Input_box" Width="182px" textmode="Password" OnTextChanged="txtPwd_TextChanged"></asp:TextBox>
                                                                &nbsp;&nbsp;&nbsp;&nbsp; 
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <div align="center">
                                                    <table style="HEIGHT: 16px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="50%">
                                                                    <asp:Button id="cmdChangePwd" onclick="cmdChangePwd_Click" runat="server" Width="146px" Enabled="False" Text="Change Password"></asp:Button>
                                                                </td>
                                                                <td width="50%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdSignIn" onclick="cmdSignIn_Click" runat="server" Width="146px" Text="Submit"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <div align="center">
                                                    <table style="HEIGHT: 16px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="100%">
                                                                    <p align="center">
                                                                        <asp:LinkButton id="lnkSetHomePage" runat="server" ForeColor="Black" CssClass="OutputText" Visible="False" CausesValidation="False" Font-Names="Rod" Font-Size="Smaller">Make ERP.com My Homepage</asp:LinkButton>
                                                                        <asp:Label id="Label6" runat="server">|</asp:Label>
                                                                        <asp:LinkButton id="lnkSetBookmark" runat="server" ForeColor="Black" CssClass="OutputText" Visible="False" CausesValidation="False" Font-Names="Rod" Font-Size="Smaller">Bookmark ERP.com!</asp:LinkButton>
                                                                    </p>
                                                                    <p align="center">
                                                                        <asp:Label id="Label4" runat="server" width="100%" cssclass="OutputText">Best viewed
                                                                        using Internet Explorer 6.0 & above using 800 x 600 resolution.</asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <copyright:copyright id="copyright" runat="server"></copyright:copyright>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
