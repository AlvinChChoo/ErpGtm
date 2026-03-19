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
            Dim DefUOM as string = "PCE"
            if page.ispostback = false then
                Dissql ("Select Buyer_Code from Buyer where U_ID <> '-' order by seq_no asc","Buyer_Code","Buyer_Code",cmbBuyer)
                Dissql ("Select Tariff_Code,Tariff_Code + ' - ' + Tariff_Desc as [Desc] from Tariff order by Tariff_Code asc","Tariff_Code","Desc",CmbTariffCode)
                Dissql ("Select UOM,UOM + ' - ' + UOM_DESC AS [UOM_DESC] from UOM order by UOM_DESC asc","UOM","UOM_DESC",CmbUOM)
                CmbUOM.Items.FindByValue(DefUOM.tostring).Selected = True
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
    
         Sub cmbUpdate_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then
                Dim strsql as string
                Dim ReqCOM as erp_gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                Dim ReturnURL as string
                Dim ConditionalApp as integer  = -1
    
                if ReqCOm.funcCheckDuplicate("Select SSER_No from Part_App_Range where Part_No_From <= '" & trim(txtPartNo.text) & "' and Part_No_To >= '" & trim(txtPartNo.text) & "';","SSER_No") = true then ConditionalApp = 0
    
                StrSql = "Insert into Part_Master(Part_No,Cust_Part_No,Part_Desc,Part_Spec,Min_Level,Mfg,Max_Level,UOM,M_Part_No,Tariff_Code,Part_Type,BUYER_CODE,Conditional_App,REF_MODEL,Consign_Part,Supply_Type,LAUNCH,CREATE_BY,CREATE_DATE) "
                StrSql = StrSql & "Select '" & trim(txtPartNo.text) & "','" & trim(txtCustPartNo.text) & "','" & trim(txtDescription.text.replace("'","`")) & "',"
                StrSql = StrSql & "'" & trim(txtSpecification.text.replace("'","`")) & "',"
                StrSql = StrSql & "" & txtminLevel.text & ",'" & txtMfg.text & "',"
                StrSql = StrSql & "" & txtMaxLevel.text & ",'" & trim(cmbUOM.selectedItem.value) & "',"
                StrSql = StrSql & "'" & trim(txtMPartNo.text.replace("'","`")) & "',"
                StrSql = StrSql & "'" & trim(cmbTariffCode.selectedItem.value) & "',"
                StrSql = StrSql & "'" & trim(cmbPartType.selecteditem.value) & "',"
                StrSql = StrSql & "'" & trim(cmbBuyer.SelectedItem.value) & "',"
                StrSql = StrSql & "" & cdec(ConditionalApp) & ",'" & TRIM(txtRefModel.text) & "',"
    
                if chkConsign.checked = true then strsql = strsql & "'Y',"
                if chkConsign.checked = false then strsql = strsql & "'N',"
    
                if chkMake.checked = true then strsql = strsql & "'MAKE',"
                if chkMake.checked = false then strsql = strsql & "'BUY',"
    
                if chkLaunch.checked = true then StrSql = StrSql & "'Y',"
                if chkLaunch.checked = false then StrSql = StrSql & "'N',"
    
                StrSql = StrSql & "'" & TRIM(request.cookies("U_ID").value) & "','" & now & "'"
                ReqCOM.ExecutenonQuery(StrSql)
    
                if chkLaunch.checked = true then ReqCom.ExecutenonQuery("Update part_Master set date_launch = '" & now & "' where part_no = '" & trim(txtPartNo.text) & "';")
    
                ReturnURL = "PartDet.aspx?ID=" & ReqCOm.GetFieldVal("Select Seq_No from Part_Master where Part_no = '" & trim(txtPartNo.text) & "';","Seq_No")
                ShowAlert("Part details saved successfully.")
                redirectPage(ReturnURL)
            end if
         End Sub
    
        Sub redirectPage(ReturnURL as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
            If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
        End sub
    
    
        Sub ShowAlert(Msg as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        End sub
    
        Sub cmdMain_Click(sender As Object, e As EventArgs)
            response.redirect("Main.aspx")
        End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Part.aspx")
    End Sub
    
    Sub ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        If ReqCOM.FuncCheckDuplicate("Select Part_No from Part_Master where Part_No = '" & trim(txtPartNo.text.replace("'","`")) & "';","Part_No") = true then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub UserControl2_Load(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" forecolor="" cssclass="FormDesc">PART
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtPartNo" ErrorMessage="You don't seem to have supplied a valid Part No." EnableClientScript="False" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtSpecification" ErrorMessage="You don't seem to have supplied a valid Specification" EnableClientScript="False" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ControlToValidate="cmbTariffCode" ErrorMessage="You don't seem to have supplied a valid Tariff Code" EnableClientScript="False" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ControlToValidate="cmbBuyer" ErrorMessage="You don't seem to have supplied a valid Buyer." EnableClientScript="False" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" ControlToValidate="cmbPartType" ErrorMessage="You don't seem to have supplied a valid Part Type." EnableClientScript="False" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" ControlToValidate="CMBUOM" ErrorMessage="You don't seem to have supplied a valid Unit." EnableClientScript="False" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator8" runat="server" ControlToValidate="txtMinLevel" ErrorMessage="You don't seem to have supplied a valid Min Level" EnableClientScript="False" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator9" runat="server" ControlToValidate="txtMaxLevel" ErrorMessage="You don't seem to have supplied a valid Max level." EnableClientScript="False" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" ControlToValidate="txtMinLevel" ErrorMessage="You don seem to have supplied a valid Min level." Type="Integer" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" " Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator2" runat="server" ControlToValidate="txtMaxLevel" ErrorMessage="You don seem to have supplied a valid Max level." Type="Integer" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" " Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" ControlToValidate="txtPartNo" ErrorMessage="Part No already Exist." CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" " OnServerValidate="ServerValidate">
                                    'Part No' already exist.
                                </asp:CustomValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator10" runat="server" ControlToValidate="txtRefModel" ErrorMessage="You don't seem to have supplied a valid Ref. Model" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                </div>
                                                <div align="center">
                                                </div>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="74px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtPartNo" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" width="92px" cssclass="LabelNormal">Mfg Part
                                                                No</asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtMPartNo" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Customer Part No</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtCustPartno" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" width="92px" cssclass="LabelNormal">Manufacturer</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtMfg" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label6" runat="server" width="74px" cssclass="LabelNormal">Description</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtDescription" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label7" runat="server" width="74px" cssclass="LabelNormal">Specification</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtSpecification" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Reference Model</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtRefModel" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" width="74px" cssclass="LabelNormal">Tariff Code</asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:DropDownList id="cmbTariffCode" runat="server" CssClass="OutputText"></asp:DropDownList>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label13" runat="server" width="74px" cssclass="LabelNormal">Buyer</asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:DropDownList id="cmbBuyer" runat="server" CssClass="OutputText"></asp:DropDownList>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" width="74px" cssclass="LabelNormal">Part Type</asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:DropDownList id="cmbPartType" runat="server" CssClass="OutputText">
                                                                        <asp:ListItem Value="Mechanical">Mechanical</asp:ListItem>
                                                                        <asp:ListItem Value="Electrical">Electrical</asp:ListItem>
                                                                        <asp:ListItem Value="Plastic">Plastic</asp:ListItem>
                                                                        <asp:ListItem Value="Packing">Packing</asp:ListItem>
                                                                        <asp:ListItem Value="Others">Others</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label8" runat="server" width="74px" cssclass="LabelNormal">Unit</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <p align="left">
                                                                    <asp:DropDownList id="CMBUOM" runat="server" CssClass="OutputText"></asp:DropDownList>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label10" runat="server" width="74px" cssclass="LabelNormal">Min Level</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtMinLevel" runat="server" CssClass="OutputText" Width="141px">1</asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label15" runat="server" width="74px" cssclass="LabelNormal">Max Level</asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtMaxLevel" runat="server" CssClass="OutputText" Width="141px">1</asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label17" runat="server" width="74px" cssclass="LabelNormal" bgcolor="silver">Consign
                                                                ?</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:CheckBox id="chkConsign" runat="server"></asp:CheckBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label16" runat="server" cssclass="LabelNormal" bgcolor="silver">Make
                                                                ?</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:CheckBox id="chkMake" runat="server"></asp:CheckBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label11" runat="server" width="74px" cssclass="LabelNormal">Launch
                                                                    ?</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:CheckBox id="chkLaunch" runat="server"></asp:CheckBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="50%">
                                                                    <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" CssClass="OutputText" Width="148px" Text="Save as new Part"></asp:Button>
                                                                </td>
                                                                <td width="50%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="148px" Text="Back" CausesValidation="False"></asp:Button>
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
            <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtDescription" ErrorMessage="You don't seem to have supplied a valid Description." EnableClientScript="False" CssClass="ErrorText" Width="100%" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
        </p>
    </form>
</body>
</html>
