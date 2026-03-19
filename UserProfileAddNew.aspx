<%@ Page Language="VB" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if ispostback = false then Dissql ("Select Dept from Dept order by Dept asc","Dept","Dept",cmbDept)
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
    
    Sub cmdSave_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
            StrSql = "Insert into User_Profile(U_NAME,U_ID,PWD,DEPT_CODE,REG_DATE,CONTACT_NO,EMAIL,HOD) "
            StrSql = StrSql + "Select '" & trim(txtUserName.text) & "','" & trim(txtUserID.text) & "','" & trim(txtPwd.text) & "','" & trim(cmbDept.selectedItem.value) & "','" & now & "','" & trim(txtContactNo.text) & "','" & trim(txtEMail.text) & "','" & trim(cmbHOD.selectedItem.value) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
            response.redirect("UserProfileDet.aspx?ID=" & ReqCOM.GetFIeldVal("Select Seq_no from User_Profile where U_ID = '" & trim(txtUserID.text) & "';","Seq_No"))
        end if
    End Sub
    
    Sub ValDuplicateModel(sender As Object, e As ServerValidateEventArgs)
        if txtUserID.text <> "" then
            Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            If ReqCOm.FuncCheckDuplicate("Select U_ID from User_Profile where U_ID = '" & trim(txtUserID.text) & "';","U_ID") = true then
                e.isvalid = false
            End if
        end if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("UserProfile.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">NEW USER REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid User Name" ForeColor=" " CssClass="ErrorText" ControlToValidate="txtUserName" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid User ID" ForeColor=" " CssClass="ErrorText" ControlToValidate="txtUserID" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" Width="100%" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Department" ForeColor=" " CssClass="ErrorText" ControlToValidate="cmbDept" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" Width="100%" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid E-Mail" ForeColor=" " CssClass="ErrorText" ControlToValidate="txtEMail" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" Width="100%" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Password" ForeColor=" " CssClass="ErrorText" ControlToValidate="txtPwd" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" Width="100%" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Confirm Password" ForeColor=" " CssClass="ErrorText" ControlToValidate="txtConPwd" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" Display="Dynamic" ErrorMessage="User ID already exist." ForeColor=" " CssClass="ErrorText" OnServerValidate="ValDuplicateModel"></asp:CustomValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" Width="100%" Display="Dynamic" ErrorMessage="Password not match." ForeColor=" " CssClass="ErrorText" ControlToValidate="txtPwd" EnableClientScript="False" ControlToCompare="txtConPwd"></asp:CompareValidator>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="116px" cssclass="LabelNormal">User Name</asp:Label></td>
                                                            <td width="75%" colspan="3">
                                                                <p>
                                                                    <asp:TextBox id="txtUserName" runat="server" Width="382px" CssClass="OutputText"></asp:TextBox>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" width="116px" cssclass="LabelNormal">User ID</asp:Label>&nbsp;&nbsp;</td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:TextBox id="txtUserID" runat="server" Width="382px" CssClass="OutputText"></asp:TextBox>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" width="116px" cssclass="LabelNormal">Department</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:DropDownList id="cmbDept" runat="server" Width="382px" CssClass="OutputText"></asp:DropDownList>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" width="116px" cssclass="LabelNormal">Contact
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtContactNo" runat="server" Width="382px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" width="116px" cssclass="LabelNormal">E-Mail</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtEMail" runat="server" Width="382px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" width="116px" cssclass="LabelNormal">HOD</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbHOD" runat="server" Width="160px" CssClass="OutputText">
                                                                    <asp:ListItem Value="N">NO</asp:ListItem>
                                                                    <asp:ListItem Value="Y">YES</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" width="116px" cssclass="LabelNormal">Password</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:TextBox id="txtPwd" runat="server" Width="382px" CssClass="OutputText" TextMode="Password"></asp:TextBox>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label8" runat="server" width="116px" cssclass="LabelNormal">Confirm
                                                                Password</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:TextBox id="txtConPwd" runat="server" Width="382px" CssClass="OutputText" TextMode="Password"></asp:TextBox>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Text="Save as new User"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="119px" Text="Cancel"></asp:Button>
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
        </p>
    </form>
</body>
</html>
