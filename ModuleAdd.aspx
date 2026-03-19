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
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dissql ("Select Dept from Dept order by Dept asc","Dept","Dept",cmbDept)
    
        end if
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
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim SeqNo as integer = ReqCOM.GetFieldVal("Select max(Seq_No) as [SEQNo] from mod_reg_d","SeqNo") + 1
            Dim StrSql as string = "Insert into Mod_Reg_D(Mod_Name,Mod_Desc,Dept,Seq_No) Select '" & trim(txtFormName.text) & "','" & trim(txtModuleDesc.text) & "','" & trim(cmbDept.selectedItem.value) & "'," & cint(SeqNo) & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
            Response.redirect("Module.aspx")
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Module.aspx")
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
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">NEW MODULE
                                REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="70%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Display="Dynamic" ControlToValidate="txtFormName" Width="100%" ErrorMessage="You don't seem to have supplied a valid Form Name." ForeColor=" " CssClass="ErrorText" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Display="Dynamic" ControlToValidate="txtModuleDesc" Width="100%" ErrorMessage="You don't seem to have supplied a valid Module Description." ForeColor=" " CssClass="ErrorText" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" Display="Dynamic" ControlToValidate="cmbDept" Width="100%" ErrorMessage="You don't seem to have supplied a valid Department." ForeColor=" " CssClass="ErrorText" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                </div>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="100%" cssclass="LabelNormal">Form Name</asp:Label></td>
                                                            <td width="70%" colspan="3">
                                                                <p>
                                                                    <asp:TextBox id="txtFormName" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" width="100%" cssclass="LabelNormal">Module Description</asp:Label></td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:TextBox id="txtModuleDesc" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" width="100%" cssclass="LabelNormal">Department</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:DropDownList id="cmbDept" runat="server" Width="100%" CssClass="OutputText"></asp:DropDownList>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p align="center">
                                                    <asp:Label id="Label5" runat="server" cssclass="Instruction">Are you sure to save
                                                    this new module ?</asp:Label>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="53px" Text="Yes"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="53px" Text="No" CausesValidation="False"></asp:Button>
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