<%@ Page Language="VB" Debug="true" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        lnkSetHomePage.attributes.add("onClick","javascript:this.style.behavior='url(#default#homepage)';this.setHomePage('http://gtekapp/erp/signin.aspx');")
        lnkSetBookmark.attributes.add("onClick","javascript:window.external.AddFavorite('http://gtekapp/erp/signin.aspx','G-Tek ERP Application');")
    End sub
    
    Sub cmdSignIn_Click(sender As Object, e As EventArgs)
        If Page.IsValid = True Then
            Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim ResGetFieldVal as string
                resGetFieldVal= ReqGetFieldVal.GetFieldVal("Select U_ID from User_Profile where U_ID = '" & trim(txtU_ID.text) & "' and Pwd = '" & trim(txtPwd.text) & "';","U_ID")
                If resGetFieldVal <> "" Then
                    Response.Cookies("U_ID").Value = Server.HtmlEncode(resGetFieldVal)
                    Response.Cookies("AlertMessage").Value = Server.HtmlEncode("")
                    Response.Cookies("FirstTimeToPage").Value = ("Y")
    
                    If (request.params("ReturnURL") = nothing) then
                        Response.Redirect("Default.aspx")
                    else
                        Response.redirect(request.params("ReturnURL"))
                    end if
                    Response.redirect("Default.aspx")
                End If
        End If
    End Sub
    
    Sub ValLoginAc(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOm.FuncCheckDuplicate("Select U_ID from User_Profile where U_ID = '" & trim(txtU_ID.text) & "' and Pwd = '" & trim(txtPwd.text) & "';","U_ID") = true then
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
    <link href="CssLogin.css" type="text/css" rel="stylesheet" />
</head>
<body>
    <form runat="server">
        <p>
        </p>
        <p>
        </p>
        <p>
            <table height="100%" width="80%" align="center">
                <tbody>
                    <tr>
                        <td>
                            <table style="HEIGHT: 38px" width="100%" align="center">
                                <tbody>
                                    <tr>
                                        <td rowspan="4">
                                            <asp:Image id="Image1" runat="server" Width="150px" ImageUrl="Key.jpg" Height="155px" BackColor="Transparent"></asp:Image>
                                            &nbsp;</td>
                                        <td bgcolor="#8080ff" colspan="1" forecolor="white">
                                            <p align="center">
                                                &nbsp;<asp:Label id="Label3" runat="server" forecolor="White" font-bold="True">ERP
                                                SYSTEM Sign In </asp:Label> 
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
                                                                    <asp:RequiredFieldValidator id="emailRequired" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid User ID." ControlToValidate="txtU_ID" Display="dynamic" Font-Name="verdana" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div align="center">
                                                                    <asp:RequiredFieldValidator id="passwordRequired" runat="server" Width="100%" ErrorMessage="You don't seem to have supplied a valid Password." ControlToValidate="txtPwd" Display="Dynamic" Font-Name="verdana" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div align="center">
                                                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" ErrorMessage="Login Failed." Display="Dynamic" ForeColor=" " CssClass="ErrorText" EnableClientScript="False" OnServerValidate="ValLoginAc"></asp:CustomValidator>
                                                                </div>
                                                                <div align="center">
                                                                    <asp:CustomValidator id="ValPasswordInput" runat="server" Width="100%" ErrorMessage="Invalid User Password." Display="Dynamic" ForeColor=" " CssClass="ErrorText" OnServerValidate="ValPasswordInput_ServerValidate"></asp:CustomValidator>
                                                                </div>
                                                                <div align="center">
                                                                    <asp:CustomValidator id="CustomValidator2" runat="server" Width="100%" ErrorMessage="Invalid User ID." Display="Dynamic" ForeColor=" " CssClass="ErrorText" OnServerValidate="CustomValidator2_ServerValidate"></asp:CustomValidator>
                                                                </div>
                                                                <p>
                                                                    <table style="HEIGHT: 39px" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p align="center">
                                                                                        <asp:Label id="Label1" runat="server" width="93px" cssclass="LabelNormal"> User ID</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                        <asp:TextBox id="txtU_ID" runat="server" Width="182px" CssClass="OutputText" size="25"></asp:TextBox>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <p align="center">
                                                                                        <asp:Label id="Label2" runat="server" width="93px" cssclass="LabelNormal">Password </asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                        <asp:TextBox id="txtPwd" runat="server" Width="182px" CssClass="OutputText" size="25" textmode="Password" OnTextChanged="txtPwd_TextChanged"></asp:TextBox>
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
                                            <div align="right">
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
                                            <div align="right">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <p align="center">
                                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td align="middle">
                                                                <asp:LinkButton id="lnkSetHomePage" runat="server" ForeColor="Black" CssClass="OutputText" CausesValidation="False" Font-Names="Rod" Font-Size="Smaller">Make ERP.com My Homepage</asp:LinkButton>
                                                                &nbsp;<asp:Label id="Label6" runat="server">|</asp:Label>&nbsp;<asp:LinkButton id="lnkSetBookmark" runat="server" ForeColor="Black" CssClass="OutputText" CausesValidation="False" Font-Names="Rod" Font-Size="Smaller">Bookmark ERP.com!</asp:LinkButton>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <p align="center">
                                                                    <asp:Label id="Label4" runat="server" width="100%" cssclass="OutputText">Best viewed
                                                                    using Internet Explorer 6.0 & above using 800 x 600 resolution.</asp:Label>
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
                            <div align="right">
                                <table style="HEIGHT: 12px" width="100%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="Label5" runat="server" forecolor="White"> | </asp:Label>
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
        </p>
    </form>
</body>
</html>
