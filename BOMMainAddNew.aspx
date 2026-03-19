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
        if page.ispostback = false then
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.Erp_Gtm
            lblModelNo.text = ReqCOM.GEtFIeldVal("Select Model_No from BOM_M where Seq_No = " & request.params("ID") & ";","Model_No")
            lblRevision.text = ReqCOM.GEtFIeldVal("Select Revision from BOM_M where Seq_No = " & request.params("ID") & ";","Revision")
            lblModelDesc.text = ReqCOM.GEtFIeldVal("Select Model_Desc from Model_master where Model_Code = '" & lblModelNo.text & "';","Model_Desc")
            FocusCtrl(txtSearchPart)
        end if
    End Sub
    
    Sub FocusCtrl(ByVal FocusControl As Control)
        Dim Script As New System.Text.StringBuilder
        Dim ClientID As String = FocusControl.ClientID
    
        Script.Append("<script language=javascript>")
        Script.Append("document.getElementById('")
        Script.Append(ClientID)
        Script.Append("').focus();")
        Script.Append("document.getElementById('")
        Script.Append(ClientID)
        Script.Append("').select();")
        Script.Append("</script" & ">")
        RegisterStartupScript("setFocus", Script.ToString())
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = trim(FValue)
            .DataTextField = trim(FText)
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Sub ServerValidate (sender As Object, value As ServerValidateEventArgs)
        if trim(txtLoc.text).length > 900 then
            Value.IsValid = false
        else
            Value.IsValid = true
        end if
    End Sub
    
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim StrSql as string
            Dim ReqCOm as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
    
            StrSql = StrSql + "Insert into BOM_d(P_Usage,Part_No,P_Level,P_Location,"
            StrSql = StrSql + "Lot_Factor1,Lot_Factor2,Revision,Model_No) "
            StrSql = StrSql + "select " & trim(txtUsage.text) & ","
            StrSql = StrSql + "'" & trim(cmbPartNo.selecteditem.value) & "',"
            StrSql = StrSql + "'" & trim(cmbLevel.selecteditem.value) & "',"
            StrSql = StrSql + "'" & trim(txtLoc.text.replace("'","`")) & "',"
            StrSql = StrSql + "" & trim(txtLotFactor1.text) & ","
            StrSql = StrSql + "" & trim(txtLotFactor2.text) & ","
            StrSql = StrSql + "" & trim(lblRevision.text) & ","
            StrSql = StrSql + "'" & trim(lblModelNo.text) & "'"
    
            ReqCOM.ExecuteNonQuery(StrSql)
            RedirectToList()
        end if
    End Sub
    
    Sub RedirectToList()
        Dim ReqCom as ERp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        Response.redirect("BOMMainDet.aspx?ID=" + ReqCOM.GetFieldVal("Select Seq_No from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and part_no = '" & trim(cmbPartNo.selecteditem.value) & "' and p_level = '" & trim(cmbLevel.selecteditem.value) & "';","SEQ_No"))
    End sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        RedirectToList()
    End Sub
    
    Sub DuplicatePart(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If ReqCOM.funcCheckDuplicate("Select Part_No from BOM_D where Part_No = '" & cmbPartNo.selectedItem.value & "' and P_Level = '" & cmbLevel.selectedItem.value & "' and Model_No = '" & lblModelNo.text & "' and Revision = " & lblRevision.text & ";","Part_No") = true then
            e.isvalid = false
        else
            e.isvalid = true
        End if
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        cmbPartNo.items.clear
        Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' order by Part_No asc","Part_No","Desc",cmbPartNo)
        txtSearchPart.text = "-- Search --"
    
        if cmbPartNo.selectedIndex <> -1 then
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from part_master where part_no = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
            GetNextControl(txtSearchLevel)
        Elseif cmbpartno.selectedindex = -1 then
            ShowAlert("Invalid Part No. Pls try another part no.")
        end if
    End Sub
    
    Sub GetNextControl(ByVal FocusControl As Control)
        Dim Script As New System.Text.StringBuilder
        Dim ClientID As String = FocusControl.ClientID
    
        Script.Append("<script language=javascript>")
        Script.Append("document.getElementById('")
        Script.Append(ClientID)
        Script.Append("').focus();")
        Script.Append("document.getElementById('")
        Script.Append(ClientID)
        Script.Append("').select();")
        Script.Append("</script" & ">")
        RegisterStartupScript("setFocus", Script.ToString())
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdGo1_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        cmbLevel.items.clear
        Dissql ("Select Level_Code from P_Level where Level_Code like '%" & cstr(txtSearchLevel.Text) & "%' order by Level_Code asc","Level_Code","Level_Code",cmbLevel)
        txtSearchLevel.text = "-- Search --"
    
        if cmbLevel.selectedIndex = 0 then
            GetNextControl(txtLoc)
        Elseif cmbLevel.selectedindex = -1 then
            ShowAlert("Invalid Level. Pls try another Level.")
        end if
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">BOM MAIN PART</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" ForeColor=" " OnServerValidate="ServerValidate" Display="Dynamic" ControlToValidate="cmbLevel" CssClass="ErrorText">
                                    'Part Location' cannot be longer than 900 character.
                                </asp:CustomValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CustomValidator id="CustomValidator2" runat="server" Width="100%" ForeColor=" " OnServerValidate="DuplicatePart" Display="Dynamic" ControlToValidate="cmbLevel" CssClass="ErrorText" ErrorMessage="Part No already exist."></asp:CustomValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:comparevalidator id="ValLotFactor1Format" runat="server" Width="100%" ForeColor=" " Display="Dynamic" ControlToValidate="txtLotFactor1" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Lot Factor 1." Operator="DataTypeCheck" Type="Double"></asp:comparevalidator>
                                                </div>
                                                <div align="center">
                                                    <asp:comparevalidator id="ValLotFactor2Format" runat="server" Width="100%" ForeColor=" " Display="Dynamic" ControlToValidate="txtlotFactor2" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Lot Factor 2." Operator="DataTypeCheck" Type="Double"></asp:comparevalidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="ValLotFactor1" runat="server" Width="100%" ForeColor=" " Display="Dynamic" ControlToValidate="txtLotFactor1" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Lot Factor 1."></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="ValLotFactor2" runat="server" Width="100%" ForeColor=" " Display="Dynamic" ControlToValidate="txtLotFactor2" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Lot Factor 2."></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" ForeColor=" " Display="Dynamic" ControlToValidate="txtUsage" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Usage."></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:comparevalidator id="CompareValidator3" runat="server" Width="100%" ForeColor=" " Display="Dynamic" ControlToValidate="txtUsage" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Usage." Operator="DataTypeCheck" Type="Double"></asp:comparevalidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" ForeColor=" " Display="Dynamic" ControlToValidate="cmbPartNo" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Part No."></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" Width="100%" ForeColor=" " Display="Dynamic" ControlToValidate="cmbLevel" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Level."></asp:RequiredFieldValidator>
                                                </div>
                                                <table style="HEIGHT: 202px" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label2" runat="server" width="135px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText">Label</asp:Label>&nbsp;&nbsp;&nbsp; <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label12" runat="server" width="135px" cssclass="LabelNormal">Revision</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:Label id="lblRevision" runat="server" width="268px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label4" runat="server" width="135px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                &nbsp;&nbsp; 
                                                                <asp:DropDownList id="cmbPartNo" runat="server" Width="284px" CssClass="OutputText"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label5" runat="server" width="135px" cssclass="LabelNormal">Level</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtSearchLevel" onkeydown="KeyDownHandler(cmdGo1)" onclick="GetFocus(txtSearchLevel)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                <asp:Button id="cmdGo1" onclick="cmdGo1_Click" runat="server" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                &nbsp;&nbsp; 
                                                                <asp:DropDownList id="cmbLevel" runat="server" Width="284px" CssClass="OutputText"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label6" runat="server" width="135px" cssclass="LabelNormal">Location</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtLoc" onkeydown="GetFocusWhenEnter(txtUsage)" runat="server" Width="419px" CssClass="OutputText" Height="60px" TextMode="MultiLine"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label7" runat="server" width="135px" cssclass="LabelNormal">Part Usage</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtUsage" onkeydown="GetFocusWhenEnter(txtLotFactor1)" runat="server" Width="75px" CssClass="OutputText"></asp:TextBox>
                                                                &nbsp;&nbsp;&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label10" runat="server" width="135px" cssclass="LabelNormal">Lot Factor
                                                                1</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtLotFactor1" onkeydown="GetFocusWhenEnter(txtLotFactor2)" runat="server" Width="167px" CssClass="OutputText">1</asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label11" runat="server" width="135px" cssclass="LabelNormal">Lot Factor
                                                                2</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtLotFactor2" runat="server" Width="167px" CssClass="OutputText">1</asp:TextBox>
                                                                <asp:DropDownList id="cmbPacking" runat="server" Width="53px" Visible="False"></asp:DropDownList>
                                                                <asp:DropDownList id="cmbColor" runat="server" Width="64px" Visible="False"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label3" runat="server" width="135px" cssclass="LabelNormal">Part Spec.</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:Label id="lblPartSpec" runat="server" width="" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Save as new part"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="174px" Text="Cancel" CausesValidation="False"></asp:Button>
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
