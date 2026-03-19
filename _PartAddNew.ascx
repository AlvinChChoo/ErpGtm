<%@ Control Language="VB" %>
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
                Dissql ("Select Tariff_Code,Tariff_Code + '|' + Tariff_Desc as [Desc] from Tariff order by Tariff_Code asc","Tariff_Code","Desc",CmbTariffCode)
                Dissql ("Select UOM from UOM order by UOM asc","UOM","UOM",CmbUOM)
    
                Dissql ("Select Color_Desc from Color order by Seq_No asc","Color_Desc","Color_Desc",cmbColor)
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
                try
                    Dim strsql as string
                    Dim ReqCOM as erp_gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
    
                    StrSQL = "Insert into Part_Master(Part_No,Part_Desc,Part_Spec,Tariff_Code,Part_Color,Create_By,Create_Date,UOM,Part_Type) "
                    strsql = StrSql + "Select '" & trim(txtPartNo.text) & "','" & trim(txtDescription.text) & "',"
                    strsql = strsql + "'" & trim(txtSpecification.text) & "','" & trim(cmbTariffCode.selectedItem.value) & "','" & trim(cmbColor.selectedItem.value) & "',"
                    StrSql = StrSql + "'" & trim(request.cookies("U_ID").value) & "','" & now & "',"
                    StrSql = StrSql + "'" & trim(cmbUOM.selecteditem.value) & "','" & trim(cmbPartType.selecteditem.value) & "';"
                    Dim ReqExecutenonQuery as Erp_Gtm.erp_gtm = new Erp_Gtm.Erp_Gtm
                    reqExecuteNonQuery.ExecuteNonQuery(strsql)
                    Dim PartID as STRING = ReqCOM.getFieldVal("Select Seq_No from Part_Master where Part_No = '" & trim(txtPartNo.text) & "';","Seq_No")
    
                    response.redirect("PartDet.aspx?ID=" + PartID)
                Catch err As Exception
                    response.write(err.tostring())
                End Try
            End if
         End Sub
    
         Sub txtRem_TextChanged(sender As Object, e As EventArgs)
         End Sub
    
         Sub TextBox6_TextChanged(sender As Object, e As EventArgs)
         End Sub
    
         Sub txtLotNo_TextChanged(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdMain_Click(sender As Object, e As EventArgs)
             response.redirect("Main.aspx")
         End Sub
    
         Sub cmdList_Click(sender As Object, e As EventArgs)
    
         End Sub
    
    Sub UserControl2_Load(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub Menu1_Load(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub txtShipState_TextChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub lnkList_Click(sender As Object, e As EventArgs)
        response.redirect("Part.aspx")
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Part.aspx")
    End Sub
    
    Sub ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        If ReqCOM.FuncCheckDuplicate("Select Part_No from Part_Master where Part_No = '" & trim(txtPartNo.text) & "';","Part_No") = true then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub

</script>
<p align="center">
    <asp:Label id="Label1" cssclass="FormDesc" runat="server" backcolor="" forecolor="" width="100%">NEW
    PART REGISTRATION</asp:Label>
</p>
<link href="IBuySpy.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="script.js" type="text/javascript"></script>
<table style="HEIGHT: 354px" cellspacing="0" cellpadding="0" width="70%" align="center">
    <tbody>
        <tr>
            <td valign="top" nowrap="nowrap" align="left" width="100%">
                <p>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Part No" Display="Dynamic" ControlToValidate="txtPartNo" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Unit" Display="Dynamic" ControlToValidate="CMBUOM" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Part Type" Display="Dynamic" ControlToValidate="cmbPartType" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Description" Display="Dynamic" ControlToValidate="txtDescription" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Specification." Display="Dynamic" ControlToValidate="txtSpecification" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Tariff Code" Display="Dynamic" ControlToValidate="cmbTariffCode" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                </p>
                <p>
                </p>
                <p>
                </p>
                <p>
                </p>
                <p>
                    <asp:CustomValidator id="CustomValidator1" runat="server" ForeColor=" " ErrorMessage="Part No already Exist." Display="Dynamic" ControlToValidate="txtPartNo" Width="100%" CssClass="ErrorText" Font-Name="verdana" OnServerValidate="ServerValidate">
                                    'Part No' already exist.
                                </asp:CustomValidator>
                </p>
                <p>
                    <table style="HEIGHT: 60px" width="100%" align="center" border="1">
                        <tbody>
                            <tr>
                                <td>
                                    <asp:Label id="Label2" cssclass="LabelNormal" runat="server" width="71px">Part No</asp:Label></td>
                                <td colspan="3">
                                    <div align="center">
                                        <asp:TextBox id="txtPartNo" runat="server" Width="455px" CssClass="OutputText" MaxLength="20" OnTextChanged="txtLotNo_TextChanged" Font-="Font-"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label3" cssclass="LabelNormal" runat="server" width="71px">Unit</asp:Label></td>
                                <td colspan="3">
                                    <div align="center">
                                        <asp:DropDownList id="CMBUOM" runat="server" Width="455px" CssClass="OutputText" Font-="Font-"></asp:DropDownList>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label4" cssclass="LabelNormal" runat="server" width="98px">Part Type</asp:Label></td>
                                <td colspan="3">
                                    <div align="center">
                                        <asp:DropDownList id="cmbPartType" runat="server" Width="455px" CssClass="OutputText" Font-="Font-">
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
                                <td>
                                    <asp:Label id="Label5" cssclass="LabelNormal" runat="server" width="71px">Description</asp:Label></td>
                                <td colspan="3">
                                    <div align="center">
                                        <asp:TextBox id="txtDescription" runat="server" Width="455px" CssClass="OutputText" MaxLength="100" Font-="Font-"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label8" cssclass="LabelNormal" runat="server" width="71px">Color</asp:Label></td>
                                <td colspan="3">
                                    <div align="center">
                                        <asp:DropDownList id="cmbColor" runat="server" Width="455px" CssClass="OutputText" Font-="Font-"></asp:DropDownList>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label6" cssclass="LabelNormal" runat="server" width="71px">Specification</asp:Label></td>
                                <td colspan="3">
                                    <div align="center">
                                        <asp:TextBox id="txtSpecification" runat="server" Width="455px" CssClass="OutputText" MaxLength="400" Font-="Font-" TextMode="MultiLine" Height="84px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label7" cssclass="LabelNormal" runat="server" width="71px">Tariff Code</asp:Label></td>
                                <td colspan="3">
                                    <div align="center">
                                        <asp:DropDownList id="cmbTariffCode" runat="server" Width="455px" CssClass="OutputText" Font-="Font-"></asp:DropDownList>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </p>
                <p>
                </p>
                <p>
                </p>
                <p>
                </p>
                <p>
                </p>
                <p>
                </p>
                <p>
                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                        <tbody>
                            <tr>
                                <td>
                                    <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Save as new part"></asp:Button>
                                </td>
                                <td>
                                    <div align="right">
                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="174px" Text="Cancel" CausesValidation="False"></asp:Button>
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