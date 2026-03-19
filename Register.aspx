<%@ Page Language="VB" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        IF NOT ISPOSTBACK
            Dissql ("Select Dept from Dept order by Dept asc","Dept",cmbDept)
        else
    END IF
    End Sub
    
    SUb Dissql(ByVal strSql As String,FName as string,Obj as Object)
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
            with obj
                .items.clear
                .DataSource = ResExeDataReader
                .DataValueField = FName
                .DataTextField = FName
                .DataBind()
            end with
            ResExeDataReader.close()
        End Sub
    
    Sub cmbSave_Click(sender As Object, e As EventArgs)
        Dim reqUserProfileAdd as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        ReqUserProfileAdd.UserProfileAdd(trim(txtUserName.text),trim(txtUserID.text),trim(txtPwd.text),trim(cmbUserType.selectedItem.text),trim(cmbActive.selecteditem.text),trim(cmbCosting.selecteditem.text),trim(cmbDEPT.selecteditem.text),trim(txtPosition.text),trim(txtContactNo.text),trim(txtEMAIL.text))
    End Sub

</script>
<html>
<head>
</head>
<body>
    <form runat="Server">
        <p>
            <asp:Label id="Label1" runat="server" width="326px">Need to validate user id for duplicate.
            Maybe display in another window.</asp:Label>
        </p>
        <table style="WIDTH: 705px; HEIGHT: 233px">
            <tbody>
                <tr>
                    <td>
                        User Name</td>
                    <td>
                        <div align="left">
                            <asp:TextBox id="txtUserName" runat="server" Font-Size="XX-Small" Width="272px"></asp:TextBox>
                        </div>
                    </td>
                    <td>
                        <div align="left">
                            <asp:RequiredFieldValidator id="ValUserName" runat="server" Font-Size="9pt" Width="236px" Font-Name="verdana" ControlToValidate="txtUserName" ErrorMessage="'User Name' must not be left blank." Font-Names="verdana"></asp:RequiredFieldValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        User Type</td>
                    <td>
                        <asp:DropDownList id="cmbUserType" runat="server" Font-Size="XX-Small" Width="272px">
                            <asp:ListItem Value="USER">USER</asp:ListItem>
                            <asp:ListItem Value="ADMIN">ADMIN</asp:ListItem>
                            <asp:ListItem Value="HOD">HOD</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        Active</td>
                    <td>
                        <asp:DropDownList id="cmbActive" runat="server" Font-Size="XX-Small" Width="272px">
                            <asp:ListItem Value="YES">YES</asp:ListItem>
                            <asp:ListItem Value="NO">NO</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        View Costing</td>
                    <td>
                        <asp:DropDownList id="cmbCosting" runat="server" Font-Size="XX-Small" Width="272px">
                            <asp:ListItem Value="YES">YES</asp:ListItem>
                            <asp:ListItem Value="NO">NO</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        Department</td>
                    <td>
                        <asp:DropDownList id="cmbDept" runat="server" Font-Size="XX-Small" Width="272px"></asp:DropDownList>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        Position</td>
                    <td>
                        <div align="left">
                            <asp:TextBox id="txtPosition" runat="server" Font-Size="XX-Small" Width="272px"></asp:TextBox>
                        </div>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator id="ValPosition" runat="server" Font-Size="9pt" Font-Name="verdana" ControlToValidate="txtPosition" ErrorMessage="'Position' must not be left blank."></asp:RequiredFieldValidator>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                    </td>
                </tr>
                <tr>
                    <td>
                        Contact No&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                    </td>
                    <td>
                        <div align="left">
                            <asp:TextBox id="txtContactNo" runat="server" Font-Size="XX-Small" Width="272px" MaxLength="30" Columns="30"></asp:TextBox>
                        </div>
                    </td>
                    <td>
                        <div align="center">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        E - Mail</td>
                    <td>
                        <div align="left">
                            <asp:TextBox id="txtEMail" runat="server" Font-Size="XX-Small" Width="272px"></asp:TextBox>
                        </div>
                    </td>
                    <td>
                        <div align="left">
                            <asp:RequiredFieldValidator id="ValEMail" runat="server" Font-Size="9pt" Font-Name="verdana" ControlToValidate="txtEMail" ErrorMessage="'E-Mail' must not be left blank."></asp:RequiredFieldValidator>
                            &nbsp; 
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <p>
        </p>
        <p>
            <table style="WIDTH: 707px; HEIGHT: 70px">
                <tbody>
                    <tr>
                        <td>
                            User ID</td>
                        <td>
                            <asp:TextBox id="txtUserID" runat="server" Font-Size="XX-Small" Width="272px"></asp:TextBox>
                            &nbsp;&nbsp;&nbsp;&nbsp; 
                        </td>
                        <td>
                            <asp:RequiredFieldValidator id="ValUserID" runat="server" Font-Size="9pt" Font-Name="verdana" ControlToValidate="txtUserID" ErrorMessage="'User ID' must not be left blank."></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Password</td>
                        <td>
                            <asp:TextBox id="txtPwd" runat="server" Font-Size="XX-Small" Width="272px" TextMode="Password"></asp:TextBox>
                        </td>
                        <td>
                            <asp:RequiredFieldValidator id="ValPwd" runat="server" Font-Size="9pt" Font-Name="verdana" ControlToValidate="txtPwd" ErrorMessage="'Password' must not be left blank."></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Confirm Password&nbsp; 
                        </td>
                        <td>
                            <asp:TextBox id="txtConPwd" runat="server" Font-Size="XX-Small" Width="272px" TextMode="Password"></asp:TextBox>
                        </td>
                        <td>
                            <asp:RequiredFieldValidator id="ValConPwd" runat="server" Font-Size="9pt" Font-Name="verdana" ControlToValidate="txtConPwd" ErrorMessage="'Confirm Password' must not be left blank."></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <!-- Insert content here -->
        <p>
            <asp:RegularExpressionValidator id="ValEMailValid" runat="server" Font-Size="9pt" Font-Name="verdana" ControlToValidate="txtEmail" ErrorMessage="Must use a valid email address." Display="Dynamic" ValidationExpression="[\w\.-]+(\+[\w-]*)?@([\w-]+\.)+[\w-]+"></asp:RegularExpressionValidator>
        </p>
        <p>
            <asp:CompareValidator id="ValPwdMatch" runat="server" Font-Size="9pt" Font-Name="verdana" ControlToValidate="txtConPwd" ErrorMessage="Password fields do not match." Display="Dynamic" ControlToCompare="txtPwd"></asp:CompareValidator>
        </p>
        <p>
            <asp:Button id="cmbSave" onclick="cmbSave_Click" runat="server" Width="142px" Text="Save"></asp:Button>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
