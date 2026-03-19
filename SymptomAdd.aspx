<%@ Page Language="VB" Debug="true" %>
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
        if page.ispostback = false then lblDate.text = format(Now,"MM/dd/yy")
        Dissql ("select Category_ID from KBCategory order by Category_ID asc","Category_ID",cmbCategory)
    End Sub
    
    Sub LoadSymptomsData
    
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    SUb Dissql(ByVal strSql As String,FName as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = trim(FName)
            .DataTextField = trim(FName)
            .DataBind()
        end with
        ResExeDataReader.close()
    
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
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("KnowledgeBase.aspx")
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
    
            StrSql = "Insert into KBProblems(TRANS_DATE,U_ID,CATEGORY_ID,SYMPTOMS,CAUSES,RESOLUTION,WORKAROUND,APPLIES_TO) "
            StrSql = StrSql + "Select '" & lblDate.text & "','" & trim(ucase(txtU_ID.text)) & "','" & trim(cmbCategory.selecteditem.value) & "','" & trim(txtSymptoms.text) & "','" & trim(txtCauses.text) & "','" & trim(txtResolution.text) & "','" & trim(txtWorkaround.text) & "','" & trim(txtAppliedTo.text) & "'"
    
            ReqCOM.executeNonQuery(StrSql)
            Response.cookies("AlertMessage").value = "The selected symptom have been saved."
            Response.redirect("SymptomDetails.aspx?ID=" & cint(ReqCOM.GetFieldVal("Select Seq_No from KBProblems where Symptoms = '" & trim(txtSymptoms.text) & "';","Seq_No")))
    
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
            <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">NEW SYMPTOM
                                REGISTRATION</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 137px" cellspacing="0" cellpadding="0" width="80%" align="center" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top">
                                            </td>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="emailRequired" runat="server" CssClass="ErrorText" Width="100%" Display="dynamic" ControlToValidate="txtU_ID" ErrorMessage="You don't seem to have supplied a valid User ID."></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="passwordRequired" runat="server" CssClass="ErrorText" Width="100%" Display="Dynamic" ControlToValidate="txtPwd" ErrorMessage="You don't seem to have supplied a valid Password."></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" CssClass="ErrorText" Width="100%" Display="Dynamic" ErrorMessage="Login Failed." OnServerValidate="ValLoginAc" EnableClientScript="False"></asp:CustomValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CustomValidator id="ValPasswordInput" runat="server" CssClass="ErrorText" Width="100%" Display="Dynamic" ErrorMessage="Invalid User Password." OnServerValidate="ValPasswordInput_ServerValidate"></asp:CustomValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CustomValidator id="CustomValidator2" runat="server" CssClass="ErrorText" Width="100%" Display="Dynamic" ErrorMessage="Invalid User ID." OnServerValidate="CustomValidator2_ServerValidate"></asp:CustomValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" Display="Dynamic" ControlToValidate="txtSymptoms" ErrorMessage="You don't seem to have supplied a valid Symptom" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" Display="Dynamic" ControlToValidate="cmbCategory" ErrorMessage="You don't seems to have supplied a valid Category" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                </div>
                                                <p>
                                                    <table style="HEIGHT: 218px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label2" runat="server" width="126px" cssclass="LabelNormal">Date Posted</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left"><asp:Label id="lblDate" runat="server" width="318px" cssclass="OutputText"></asp:Label>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label4" runat="server" width="126px" cssclass="LabelNormal">Category</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left">
                                                                            <asp:DropDownList id="cmbCategory" runat="server" CssClass="OutputText" Width="484px"></asp:DropDownList>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label5" runat="server" width="126px" cssclass="LabelNormal">Symptoms</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left">
                                                                            <div align="left">
                                                                                <asp:TextBox id="txtSymptoms" runat="server" CssClass="OutputText" Width="484px" Height="67px" TextMode="MultiLine"></asp:TextBox>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label6" runat="server" width="126px" cssclass="LabelNormal">Causes</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left">
                                                                            <asp:TextBox id="txtCauses" runat="server" CssClass="OutputText" Width="484px" Height="67px" TextMode="MultiLine"></asp:TextBox>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label7" runat="server" width="126px" cssclass="LabelNormal">Resolution</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <p align="left">
                                                                            <asp:TextBox id="txtResolution" runat="server" CssClass="OutputText" Width="484px" Height="67px" TextMode="MultiLine"></asp:TextBox>
                                                                        </p>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label8" runat="server" width="126px" cssclass="LabelNormal">Workaround</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left">
                                                                            <asp:TextBox id="txtWorkAround" runat="server" CssClass="OutputText" Width="484px" Height="67px" TextMode="MultiLine"></asp:TextBox>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label9" runat="server" width="126px" cssclass="LabelNormal">Applied
                                                                        To</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <asp:TextBox id="txtAppliedTo" runat="server" CssClass="OutputText" Width="484px" Height="67px" TextMode="MultiLine"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 39px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label10" runat="server" width="93px" cssclass="LabelNormal"> User ID</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:TextBox id="txtU_ID" runat="server" CssClass="OutputText" Width="182px" size="25"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label11" runat="server" width="93px" cssclass="LabelNormal">Password </asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:TextBox id="txtPwd" runat="server" CssClass="OutputText" Width="182px" size="25" textmode="Password"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="178px" Text="Save as new Symptom"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="169px" Text="Cancel"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
