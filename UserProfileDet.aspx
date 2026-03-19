<%@ Page Language="VB" Debug="true" %>
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
        if ispostback = false then
            Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim rsUser as SQLDataReader = ReqCOM.ExeDataReader("Select * from User_Profile where Seq_No = " & request.params("ID") & ";")
            Dim DeptCode as string
            Dissql ("Select Dept from Dept order by Dept asc","Dept","Dept",cmbDept)
            Do while rsUser.read
                lblUserName.text = rsUser("U_Name").tostring
                lblUserID.text = rsUser("U_ID").tostring
                DeptCode = rsUser("Dept_Code").tostring
                txtContactNo.text = rsUser("Contact_No").tostring
                txtUserPos.text = rsUser("U_POS").tostring
                if rsUser("View_Costing").tostring = "Y" then cmbViewUP.Items.FindByValue("Y").Selected = True else cmbViewUP.Items.FindByValue("N").Selected = True
                txtEMail.text = rsUser("EMail").tostring
                if rsUser("HOD").tostring = "Y" then cmbHOD.Items.FindByValue("Y").Selected = True else cmbHOD.Items.FindByValue("N").Selected = True
                cmbHOD.Items.FindByValue(trim(rsUser("HOD").tostring)).Selected = True
    
                if reqCOM.FuncCheckDuplicate("Select Dept from Dept where Dept = '" & trim(DeptCode) & "';","Dept") = false then
                    cmbDept.Items.FindByText("").Selected = True
                Else
                    DeptCode = ReqCOM.GetFieldVal("Select Dept from Dept where Dept = '" & trim(DeptCode) & "';","Dept").tostring
                    cmbDept.Items.FindByValue(DeptCode.tostring).Selected = True
                End if
            Loop
            ProcLoadGridData
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("SELECT * FROM Program_Group_M ORDER BY Group_Desc ASC","Program_Group_M")
        GridControl1.DataSource=resExePagedDataSet.Tables("Program_Group_M").DefaultView
        GridControl1.DataBind()
    end sub
    
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
        Dim oList As ListItemCollection = obj.Items
        oList.Add(New ListItem(""))
    End Sub
    
    Sub cmdSave_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
            Dim i As Integer
            StrSql = "Update User_Profile set Contact_No = '" & trim(txtContactNo.text) & "',U_POS = '" & trim(txtUserPos.text) & "',View_Costing= '" & trim(cmbViewUP.selecteditem.value) & "',EMail = '" & trim(txtEMail.text) & "',HOD = '" & trim(cmbHOD.selectedItem.Value) & "',Dept_Code = '" & trim(cmbDept.selectedItem.Value) & "' where seq_No = " & request.params("ID") & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
            ReqCOM.ExecuteNonQuery("Delete from User_Group where U_ID = '" & trim(lblUserID.text) & "';")
    
            For i = 0 To GridControl1.Items.Count - 1
                Dim Sel As CheckBox = CType(GridControl1.Items(i).FindControl("Select"), CheckBox)
                Dim GroupID As Label = Ctype(GridControl1.Items(i).FindControl("lblSeqNo"), Label)
                if Sel.checked = true then ReqCOM.executeNonQuery("Insert into User_Group(U_ID,Group_ID) Select '" & trim(lblUserID.text) & "'," & cint(GroupID.text) & ";")
            Next
        end if
        response.redirect("UserProfileDet.aspx?ID=" & request.params("ID"))
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("UserProfile.aspx")
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim GroupID As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
            Dim Sel As CheckBox = CType(e.Item.FindControl("Select"), CheckBox)
    
            Sel.checked = false
            if ReqCOM.FuncCheckDuplicate("Select U_ID from User_Group where U_ID = '" & trim(lblUserID.text) & "' and Group_ID = " & cint(GroupID.text) & ";","U_ID") = true then Sel.checked = true
        End if
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
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">USER PROFILE</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" Width="100%" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Department" ForeColor=" " CssClass="ErrorText" ControlToValidate="cmbDept" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" Width="100%" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid E-Mail" ForeColor=" " CssClass="ErrorText" ControlToValidate="txtEMail" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                </div>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="70%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="116px" cssclass="LabelNormal">User Name</asp:Label></td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:Label id="lblUserName" runat="server" width="382px" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" width="116px" cssclass="LabelNormal">User ID</asp:Label>&nbsp;&nbsp;</td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:Label id="lblUserID" runat="server" width="382px" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" width="116px" cssclass="LabelNormal">Department</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:DropDownList id="cmbDept" runat="server" Width="264px" CssClass="OutputText"></asp:DropDownList>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" width="116px" cssclass="LabelNormal">Contact
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtContactNo" runat="server" Width="264px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" width="116px" cssclass="LabelNormal">E-Mail</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtEMail" runat="server" Width="264px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" width="116px" cssclass="LabelNormal">Position</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtUserPos" runat="server" Width="264px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label8" runat="server" width="116px" cssclass="LabelNormal">View U/P</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbViewUP" runat="server" Width="160px" CssClass="OutputText">
                                                                    <asp:ListItem Value="N">NO</asp:ListItem>
                                                                    <asp:ListItem Value="Y">YES</asp:ListItem>
                                                                </asp:DropDownList>
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
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemDataBound="FormatRow" AutoGenerateColumns="False" cellpadding="4" GridLines="None" BorderColor="Black" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Group">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblGroup" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Group_Desc") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Allow access ?">
                                                                <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <center>
                                                                        <asp:CheckBox id="Select" runat="server" />
                                                                    </center>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Text="Update User Profile"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="119px" Text="Back"></asp:Button>
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
