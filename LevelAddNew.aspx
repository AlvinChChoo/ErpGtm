<%@ Page Language="VB" %>
<script runat="server">

    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
            Dim ReqCom as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            if page.isvalid = true then
                ReqCOM.ExecuteNonQuery("Insert into P_Level(Level_Code,Level_Desc,PC_Sch_Days) select '" & trim(txtLevel.text) & "','" & trim(txtDesc.text) & "','" & trim(txtSchDays.text) & "';")
    
                txtLevel.text = ""
                txtDesc.text = ""
                txtSchDays.text = ""
                ShowAlert ("New level updated.")
            end if
        End Sub
    
    Sub ValDuplicateLevel(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select Level_Code from P_Level where Level_Code = '" & trim(txtLevel.text) & "';","Level_Code") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdExit_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body>
    <form runat="server">
        <p>
        </p>
        <p>
        </p>
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="80%" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <asp:CustomValidator id="CustomValidator1" runat="server" ControlToValidate="txtLevel" Display="Dynamic" CssClass="ErrorText" ForeColor=" " Width="100%" OnServerValidate="ValDuplicateLevel">
                                    'Level' already exist.
                                </asp:CustomValidator>
                            </div>
                            <div align="center">
                                <asp:RequiredFieldValidator id="valLevel" runat="server" ControlToValidate="txtLevel" Display="Dynamic" CssClass="ErrorText" ForeColor=" " Width="100%" ErrorMessage="You don't seem to have supplied a valid Level"></asp:RequiredFieldValidator>
                            </div>
                            <div align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtDesc" Display="Dynamic" CssClass="ErrorText" ForeColor=" " Width="100%" ErrorMessage="You don't seem to have supplied a valid Description."></asp:RequiredFieldValidator>
                            </div>
                            <div align="center">
                                <asp:CompareValidator id="CompareValidator1" runat="server" ControlToValidate="txtSchDays" CssClass="ErrorText" ForeColor=" " Width="100%" ErrorMessage="You don't seem to have supplied a valid Schedule Days" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                            </div>
                            <div align="center">
                                <asp:CompareValidator id="CompareValidator2" runat="server" ControlToValidate="txtSchDays" CssClass="ErrorText" ForeColor=" " Width="100%" ErrorMessage="You don't seem to have supplied a valid Schedule Days" Operator="GreaterThan" Type="Integer" ValueToCompare="0"></asp:CompareValidator>
                            </div>
                            <div align="center">
                            </div>
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td width="25%" bgcolor="silver">
                                            <asp:Label id="Label3" runat="server" width="113px" cssclass="LabelNormal">Level Code</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtLevel" runat="server" Width="359px" MaxLength="100"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label10" runat="server" width="135px" cssclass="LabelNormal">Description</asp:Label></td>
                                        <td>
                                            <asp:TextBox id="txtDesc" runat="server" Width="359px" MaxLength="100"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="silver">
                                            <asp:Label id="Label9" runat="server" width="135px" cssclass="LabelNormal">Schedule
                                            Days</asp:Label></td>
                                        <td width="100%">
                                            <asp:TextBox id="txtSchDays" runat="server" Width="162px" MaxLength="100"></asp:TextBox>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <p>
                                <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td width="50%">
                                                <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Width="141px" Text="Add New"></asp:Button>
                                            </td>
                                            <td width="50%">
                                                <div align="right">
                                                    <asp:Button id="cmdExit" onclick="cmdExit_Click" runat="server" Width="85px" Text="Exit" CausesValidation="False"></asp:Button>
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
        <!-- Insert content here -->
    </form>
</body>
</html>
