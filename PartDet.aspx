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
        if page.ispostback = false then loaddata()
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
    
    Sub LoadData()
        Dim strSql as string = "SELECT * FROM Part_Master WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
        Dim PartType,TariffCode,MfgName,ObsolutePart,UOM,Color,UID as string
        Dim BuyerCode as string
    
        Dissql ("Select Tariff_Code,Tariff_Code + ' - ' + Tariff_Desc as [Desc] from Tariff order by Tariff_Code asc","Tariff_Code","Desc",CmbTariffCode)
        Dissql ("Select Mfg_Name,Mfg_Name as [MName] from MFG order by Mfg_Name asc","Mfg_Name","MName",CmbMfgName)
        Dissql ("Select UOM,UOM + ' - ' + UOM_DESC as [UOM_DESC] from UOM order by UOM asc","UOM","UOM_DESC",CmbUOM)
        Dissql ("Select upper(Buyer_Code) as [Buyer_Code] from Buyer where U_ID <> '-' order by seq_no asc","Buyer_Code","Buyer_Code",cmbBuyer)
    
        do while ResExeDataReader.read
            lblPartNo.text = trim(ResExeDataReader("Part_No").tostring)
            txtDescription.text= trim(ResExeDataReader("Part_Desc").tostring)
            txtSpecification.text= trim(ResExeDataReader("Part_Spec").tostring)
            Color = trim(ResExeDataReader("Part_Color").toString)
            txtCustPartNo.text= trim(ResExeDataReader("Cust_Part_No").tostring)
    
            MfgName = ReqExeDataReader.GetFieldVal("Select Mfg_Name as [MName] from Mfg where Mfg_Name = '" & trim(ResExeDataReader("Mfg").tostring) & "';","MName").tostring
            If Not (cmbMfgName.Items.FindByValue(MfgName.tostring)) Is Nothing Then cmbMfgName.Items.FindByValue(MfgName.tostring).Selected = True
    
            txtMPartNo.text= trim(ResExeDataReader("M_Part_No").tostring)
            txtRefModel.text= trim(ResExeDataReader("Ref_Model").tostring)
            txtMinLevel.text = trim(ResExeDataReader("Min_Level").tostring)
            txtMaxLevel.text = trim(ResExeDataReader("Max_Level").tostring)
            txtRefModel.text = trim(ResExeDataReader("Ref_Model").tostring)
            UID = trim(ResExeDataReader("Buyer_Code").tostring)
            UOM = trim(ResExeDataReader("UOM").tostring)
    
    
            if trim(ResExeDataReader("CONSIGN_PART")) = "Y" then chkConsign.checked = true
            if trim(ResExeDataReader("CONSIGN_PART")) = "N" then chkConsign.checked = false
    
            if trim(ResExeDataReader("Supply_Type")) = "MAKE" then chkMake.checked = true
            if trim(ResExeDataReader("Supply_Type")) = "BUY" then chkMake.checked = false
    
            PartType = trim(ResExeDataReader("Part_Type").tostring)
            ObsolutePart = trim(ResExeDataReader("Obsolute_Part").tostring)
            cmbBuyer.items.FindByValue(ucase(trim(ResExeDataReader("Buyer_Code")))).selected = true
    
            if trim(ResExeDataReader("Launch").tostring) = "Y" then chkLaunch.checked = true
    
            if isdbnull(ResExeDataReader("std_cost_rd")) = true then
                chkLaunch.enabled = true
            elseif cdec(ResExeDataReader("std_cost_rd")) > 0 then
                chkLaunch.enabled = false
            elseif cdec(ResExeDataReader("std_cost_rd")) = 0 then
                chkLaunch.enabled = true
            end if
    
            TariffCode = ReqExeDataReader.GetFieldVal("Select Tariff_Code as [Desc] from Tariff where Tariff_Code = '" & trim(ResExeDataReader("Tariff_Code").tostring) & "';","Desc").tostring
            If Not (cmbTariffCode.Items.FindByValue(TariffCode.tostring)) Is Nothing Then cmbTariffCode.Items.FindByValue(TariffCode.tostring).Selected = True
        loop
    
        If Not (cmbPartType.Items.FindByText(PartType.tostring)) Is Nothing Then cmbPartType.Items.FindByValue(PartType.tostring).Selected = True
    
        UOM = ReqExeDataReader.GetFieldVal("Select UOM from UOM where UOM = '" & trim(UOM) & "';","UOM")
        If Not (cmbUOM.Items.FindByValue(UOM.tostring)) Is Nothing Then cmbUOM.Items.FindByValue(UOM.tostring).Selected = True
     End sub
    
     Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim strsql as string
            Dim ReqCOM as erp_gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            strsql = "Update Part_Master set Part_Desc = '" & trim(txtDescription.text.replace("'","`")) & "',"
            strsql = strsql + "Part_Spec = '" & trim(txtSpecification.text.replace("'","`")) & "',"
            strsql = strsql + "Cust_Part_No = '" & trim(txtCustPartNo.text) & "',"
            strsql = strsql + "Min_Level = " & txtminLevel.text & ","
            strsql = strsql + "Mfg = '" & trim(cmbMfgName.selectedItem.value) & "',"
            strsql = strsql + "Max_Level = " & txtMaxLevel.text & ","
            strsql = strsql + "UOM = '" & trim(cmbUOM.selectedItem.value) & "',"
            strsql = strsql + "M_Part_No = '" & trim(txtMPartNo.text.replace("'","`")) & "',"
            strsql = strsql + "Tariff_Code = '" & trim(cmbTariffCode.selectedItem.value) & "',"
            strsql = strsql + "Part_Type = '" & trim(cmbPartType.selecteditem.value) & "',"
            strsql = strsql + "MODIFY_BY = '" & (request.cookies("U_ID").value) & "',"
            strsql = strsql + "BUYER_CODE = '" & trim(cmbBuyer.SelectedItem.value) & "',"
            strsql = strsql + "Ref_Model = '" & trim(txtRefModel.text) & "',"
    
            if chkConsign.checked = true then strsql = strsql + "Consign_Part = 'Y',"
            if chkConsign.checked = false then strsql = strsql + "Consign_Part = 'N',"
    
    
            if chkMake.checked = true then strsql = strsql + "Supply_Type = 'MAKE',"
            if chkMake.checked = false then strsql = strsql + "Supply_Type = 'BUY',"
    
    
            if chkLaunch.checked = true then strsql = strsql + "Launch = 'Y',"
            if chkLaunch.checked = false then strsql = strsql + "Launch = 'N',"
    
            strsql = strsql + "MODIFY_DATE = '" & now & "' "
            strsql = strsql + "where Part_No = '" & trim(lblPartNo.text.replace("'","`")) & "'"
            Dim ReqExecutenonQuery as Erp_Gtm.erp_gtm = new Erp_Gtm.Erp_Gtm
            reqExecuteNonQuery.ExecuteNonQuery(strsql)
    
            if chkLaunch.checked = true then ReqCom.ExecuteNonQuery("Update Part_Master set Date_Launch = '" & now & "' where part_no = '" & trim(lblPartNo.text) & "';")
            if chkLaunch.checked = false then  ReqCom.ExecuteNonQuery("Update Part_Master set Date_Launch = null where part_no = '" & trim(lblPartNo.text) & "';")
    
            LoadData
            ShowAlert("Part details saved successfully.")
            redirectPage()
        end if
    End Sub
    
    Sub redirectPage
        Dim strScript as string
        Dim ReturnURL as string
        ReturnURL= "PartDet.aspx?ID=" & Request.params("ID")
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

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                                    <asp:RequiredFieldValidator id="valDesc" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="txtDescription" ErrorMessage="You don't seem to have supplies a valid Part Description." Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="valSpecification" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="txtSpecification" ErrorMessage="You don't seem to have supplies a valid Part Specification." Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="cmbTariffCode" ErrorMessage="You don't seem to have supplies a valid Tariff Code" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="cmbBuyer" ErrorMessage="You don't seem to have supplies a valid Buyer Code." Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="cmbPartType" ErrorMessage="You don't seem to have supplies a valid Part Type" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="CMBUOM" ErrorMessage="You don't seem to have supplies a valid Unit" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="txtMinLevel" ErrorMessage="You don't seem to have supplies a valid Min Level" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="txtMaxLevel" ErrorMessage="You don't seem to have supplies a valid Max level" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="txtMinLevel" ErrorMessage="CompareValidator" Width="100%" CssClass="ErrorText" Type="Integer" Operator="GreaterThan" ValueToCompare="0">You don't seem to have supplied a valid Min. Level</asp:CompareValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CompareValidator id="CompareValidator2" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="txtMaxLevel" ErrorMessage="CompareValidator" Width="100%" CssClass="ErrorText" Type="Integer" Operator="GreaterThan" ValueToCompare="0">You don't seem to have supplied a valid Max. Level</asp:CompareValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" ForeColor=" " Display="Dynamic" ControlToValidate="txtRefModel" ErrorMessage="You don't seem to have supplies a valid Ref. Model." Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                </div>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="74px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left"><asp:Label id="lblPartNo" runat="server" width="393px" cssclass="OutputText" align="left"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" width="92px" cssclass="LabelNormal">Mfg Part
                                                                No</asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtMPartNo" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Customer Part No</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtCustPartno" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" width="92px" cssclass="LabelNormal">Manufacturer</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:DropDownList id="cmbMfgName" runat="server" CssClass="OutputText"></asp:DropDownList>
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
                                                                    <asp:TextBox id="txtDescription" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
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
                                                                    <asp:TextBox id="txtSpecification" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label16" runat="server" width="74px" cssclass="LabelNormal">Ref. Model</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtRefModel" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
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
                                                                    <asp:TextBox id="txtMinLevel" runat="server" Width="174px" CssClass="OutputText"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label11" runat="server" width="74px" cssclass="LabelNormal">Max Level</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtMaxLevel" runat="server" Width="174px" CssClass="OutputText"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label17" runat="server" width="74px" cssclass="LabelNormal">Consign
                                                                ?</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:CheckBox id="chkConsign" runat="server"></asp:CheckBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Make ?</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:CheckBox id="chkMake" runat="server"></asp:CheckBox>
                                                                &nbsp; 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label15" runat="server" width="74px" cssclass="LabelNormal">Launch
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
                                                                    <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" CssClass="OutputText" Text="Update Part Details"></asp:Button>
                                                                </td>
                                                                <td width="50%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="174px" CssClass="OutputText" Text="Back" CausesValidation="False"></asp:Button>
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
