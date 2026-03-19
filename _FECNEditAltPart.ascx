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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
            lblFECNNo.text = ReqCOM.GetFieldVal("Select FECN_NO from FECN_M where SEQ_NO = " & Request.params("ID") & ";","FECN_NO")
            lblModelNo.text = ReqCOm.GetFieldVal("Select Model_No from FECN_M where Seq_No = " & Request.params("ID") & ";","Model_No")
            Dissql ("Select PM.Part_No, PM.Part_No + '|' + PM.Part_Desc as [Desc] from Part_Master PM,BOM_D bom where BOM.Model_No = '" & trim(lblModelNo.text) & "' and PM.Part_No = BOM.Part_No order by PM.Part_No asc","Part_No","Desc",cmbPartNo)
            Dissql ("Select PM.Part_No, PM.Part_No + '|' + PM.Part_Desc as [Desc] from Part_Master PM order by PM.Part_No asc","Part_No","Desc",cmbAltPartA)
            'Dissql ("Select Part_No, Part_No + '|' + Part_Desc as [Desc] from Part_Master order by Part_No asc","Part_No","Desc",cmbAltPartNo)
        end if
    End Sub
    
    Sub cmdSave_Click(sender As Object, e As EventArgs)
    
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
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dissql ("Select PM.Part_No, PM.Part_No + '|' + PM.Part_Desc as [Desc] from BOM_Alt BA,Part_Master PM where BA.Model_No = '" & trim(lblModelNo.text) & "' and BA.Main_Part = '" & trim(cmbPartNo.selectedItem.value) & "' and PM.Part_No = BA.Part_No order by PM.Part_No asc","Part_No","Desc",cmbAltPartB)
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub Save_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    'Sub cmbAltPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
    '    Dim ReqCom as ERp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    '    Dim rsPart as SQLDataReader
    
    '    RsPart = ReqCOM.ExeDataReader("Select Part_Spec,Part_Desc,M_Part_No from Part_Master where Part_No = '" & trim(cmbAltPartB.selectedItem.value) & "';")
    '    Do while RsPart.read
    '        lblAltPartSpec.text = RsPart("Part_Spec").tostring
    '        lblAltPartDesc.text = RsPart("Part_Desc").tostring
    '        lblAltMfgPartNo.text = RsPart("M_Part_No").tostring
    '    loop
    '    'RsPart.dispose()
    '    rsPart.close()
    
    
        'lblAltPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
        'lblAltPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
    
    'End Sub
    
    Sub cmbAltPartB_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rsPart as SQLDataReader = ReqCOM.ExeDataReader("Select Part_Spec,Part_Desc from Part_Master where Part_No = '" & trim(cmbAltPartB.selectedItem.value) & "';")
        Do while rsPart.read
            lblPartDescB.text = rsPart("Part_Desc").toString
            lblPartSpecB.text = rsPart("Part_Spec").toString
        loop
        rsPart.close()
    End Sub
    
    Sub cmbAltPartA_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rsPart as SQLDataReader = ReqCOM.ExeDataReader("Select Part_Desc,Part_Spec,M_Part_No from Part_Master where Part_No = '" & trim(cmbAltPartA.selectedItem.value) & "';")
        Do while rsPart.read
            lblPartSpecA.text = rsPart("Part_Spec").toString
            lblPartDescA.text = rsPart("Part_Desc").toString
            lblMfgPartNoA.text = rsPart("M_Part_No").toString
        loop
    End Sub

</script>
<p align="center">
    <asp:Label id="Label1" cssclass="FormDesc" width="100%" runat="server">REMOVE ALTERNATE
    PART</asp:Label>
</p>
<link href="IBuySpy.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="script.js" type="text/javascript"></script>
<p>
    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="94%" align="center">
        <tbody>
            <tr>
                <td>
                    <table style="HEIGHT: 48px" width="100%" border="1">
                        <tbody>
                            <tr>
                                <td>
                                    <asp:Label id="Label5" cssclass="LabelNormal" width="116px" runat="server">FECN No</asp:Label></td>
                                <td>
                                    <asp:Label id="lblFECNNo" cssclass="OutputText" width="472px" runat="server"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label4" cssclass="LabelNormal" width="116px" runat="server">Model No</asp:Label></td>
                                <td>
                                    <asp:Label id="lblModelNo" cssclass="OutputText" width="472px" runat="server"></asp:Label></td>
                            </tr>
                        </tbody>
                    </table>
                    <p>
                        <table style="HEIGHT: 71px" width="100%" border="1">
                            <tbody>
                                <tr>
                                    <td>
                                        <asp:Label id="Label9" cssclass="LabelNormal" width="116px" runat="server">Part No</asp:Label></td>
                                    <td>
                                        <asp:DropDownList id="cmbPartNo" runat="server" CssClass="OutputText" Width="473px" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="true"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label3" cssclass="LabelNormal" width="116px" runat="server">Alt Part
                                        No</asp:Label></td>
                                    <td>
                                        <asp:DropDownList id="cmbAltPartB" runat="server" CssClass="OutputText" Width="473px" OnSelectedIndexChanged="cmbAltPartB_SelectedIndexChanged" autopostback="true"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label6" cssclass="LabelNormal" width="116px" runat="server">Description</asp:Label></td>
                                    <td>
                                        <asp:Label id="lblPartDescB" cssclass="OutputText" width="472px" runat="server"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label7" cssclass="LabelNormal" width="116px" runat="server">Specification</asp:Label></td>
                                    <td>
                                        <asp:Label id="lblPartSpecB" cssclass="OutputText" width="472px" runat="server"></asp:Label></td>
                                </tr>
                            </tbody>
                        </table>
                    </p>
                    <p>
                        <table style="HEIGHT: 71px" width="100%" border="1">
                            <tbody>
                                <tr>
                                    <td>
                                        <asp:Label id="Label10" cssclass="LabelNormal" width="116px" runat="server">Alt Part
                                        No</asp:Label></td>
                                    <td>
                                        <asp:DropDownList id="cmbAltPartA" runat="server" CssClass="OutputText" Width="473px" OnSelectedIndexChanged="cmbAltPartA_SelectedIndexChanged" autopostback="true"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label11" cssclass="LabelNormal" width="116px" runat="server">Description</asp:Label></td>
                                    <td>
                                        <asp:Label id="lblPartDescA" cssclass="OutputText" width="472px" runat="server"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label12" cssclass="LabelNormal" width="116px" runat="server">Specification</asp:Label></td>
                                    <td>
                                        <asp:Label id="lblPartSpecA" cssclass="OutputText" width="472px" runat="server"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label2" cssclass="LabelNormal" width="116px" runat="server">Mgf Part
                                        No</asp:Label></td>
                                    <td>
                                        <asp:Label id="lblMfgPartNoA" cssclass="OutputText" width="472px" runat="server"></asp:Label></td>
                                </tr>
                            </tbody>
                        </table>
                    </p>
                    <p>
                        <table style="HEIGHT: 11px" width="100%">
                            <tbody>
                                <tr>
                                    <td>
                                        <asp:Button id="Save" onclick="Save_Click" runat="server" Width="134px" Text="Save" CausesValidation="True"></asp:Button>
                                    </td>
                                    <td>
                                        <div align="right">
                                            <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="134px" Text="Cancel" CausesValidation="False"></asp:Button>
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