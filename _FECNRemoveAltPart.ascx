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
            Dissql ("Select PM.Part_No, PM.Part_No + '|' + PM.Part_Desc as [Desc] from Part_Master PM,BOM_D BOM where BOM.Model_No = '" & trim(lblModelNo.text) & "' and PM.Part_No = BOM.Part_No order by PM.Part_No asc","Part_No","Desc",cmbPartNo)
    
            lblPartSpec.text = reqCOM.GetFieldVal("Select Part_Spec from part_master where part_no = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
            lblPartDesc.text = reqCOM.GetFieldVal("Select Part_Desc from part_master where part_no = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Desc")
    
            'lblAltPartSpec.text = reqCOM.GetFieldVal("Select Part_Spec from part_master where part_no = '" & trim(cmbAltPartNo.selectedItem.value) & "';","Part_Spec")
            'lblAltPartDesc.text = reqCOM.GetFieldVal("Select Part_Desc from part_master where part_no = '" & trim(cmbAltPartNo.selectedItem.value) & "';","Part_Desc")
            'lblAltMfgPartNo.text = reqCOM.GetFieldVal("Select M_Part_No from part_master where part_no = '" & trim(cmbAltPartNo.selectedItem.value) & "';","M_Part_No")
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
        Dim ReqCom as ERp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim RsPart as SQLDataReader = ReqCOM.ExeDataReader("Select part_Spec,Part_Desc,M_Part_No from Part_master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';")
        Do while RsPart.read
            lblPartSpec.text = rsPart("Part_Spec").tostring
            lblPartDesc.text = rsPart("Part_Desc").tostring
        loop
        Dissql ("Select PM.Part_No, PM.Part_No + '|' + PM.Part_Desc as [Desc] from BOM_Alt BA,Part_Master PM where BA.Model_No = '" & trim(lblModelNo.text) & "' and BA.Main_Part = '" & trim(cmbPartNo.selectedItem.value) & "' and PM.Part_No = BA.Part_No order by PM.Part_No asc","Part_No","Desc",cmbAltPartNo)
        lblAltPartSpec.text = ""
        lblAltPartDesc.text = ""
        lblAltMfgPartNo.text = ""
    
        On error resume next
            lblAltPartSpec.text = reqCOM.GetFieldVal("Select Part_Spec from part_master where part_no = '" & trim(cmbAltPartNo.selectedItem.value) & "';","Part_Spec")
            lblAltPartDesc.text = reqCOM.GetFieldVal("Select Part_Desc from part_master where part_no = '" & trim(cmbAltPartNo.selectedItem.value) & "';","Part_Desc")
            lblAltMfgPartNo.text = reqCOM.GetFieldVal("Select M_Part_No from part_master where part_no = '" & trim(cmbAltPartNo.selectedItem.value) & "';","M_Part_No")
    
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub Save_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERp_Gtm.Erp_gtm = new Erp_Gtm.ERP_Gtm
            Dim StrSql as string
            'FECN_NO,MAIN_PART_B4,ALT_PART_B4,PART_DESC_B4,PART_SPEC_B4,M_PART_NO_B4,P_USAGE_B4,P_LEVEL_B4,P_LOCATION_B4,MAIN_PART,ALT_PART,PART_DESC,PART_SPEC,M_PART_NO,P_USAGE,P_LEVEL,P_LOCATION,TYPE_CHANGE,REASON_CHANGE,FECN_EFFECT,LOT_NO,LOT_DET,LOT_QTY
            Try
                StrSql = "Insert into FECN_D(FECN_NO,MAIN_PART_B4,ALT_PART_B4,PART_DESC_B4,PART_SPEC_B4,"
                StrSql = StrSql + "M_PART_NO_B4,P_USAGE_B4,P_LEVEL_B4,P_LOCATION_B4,MAIN_PART,ALT_PART,"
                StrSql = StrSql + "PART_DESC,PART_SPEC,M_PART_NO,P_USAGE,P_LEVEL,P_LOCATION,TYPE_CHANGE) "
    
                StrSql = StrSql + "Select '" & trim(lblFECNNo.text) & "','" & trim(cmbPartNo.selectedItem.value) & "','" & cmbAltPartNo.selectedItem.value & "','" & lblAltPartDesc.text & "','" & lblAltPartSpec.text & "',"
                StrSql = StrSql + "'" & lblAltMfgPartNo.text & "',0,'-','-','-','-',"
                StrSql = StrSql + "'-','-','-',0,"
                StrSql = StrSql + "'-',"
                StrSql = StrSql + "'-','Remove Alt Part'"
                'StrSql = StrSql + "from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';"
                ReqCOM.ExecuteNonQuery(StrSql)
                Response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
            Catch Err as exception
            '    label3.text = err.tostring
            end try
        end if
    End Sub
    
    Sub cmbAltPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCom as ERp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim rsPart as SQLDataReader
    
        RsPart = ReqCOM.ExeDataReader("Select Part_Spec,Part_Desc,M_Part_No from Part_Master where Part_No = '" & trim(cmbAltPartNo.selectedItem.value) & "';")
        Do while RsPart.read
            lblAltPartSpec.text = RsPart("Part_Spec").tostring
            lblAltPartDesc.text = RsPart("Part_Desc").tostring
            lblAltMfgPartNo.text = RsPart("M_Part_No").tostring
        loop
        'RsPart.dispose()
        rsPart.close()
    
    
        'lblAltPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
        'lblAltPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
    
    End Sub

</script>
<p align="center">
    <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">REMOVE ALTERNATE
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
                                    <asp:Label id="Label5" runat="server" width="116px" cssclass="LabelNormal">FECN No</asp:Label></td>
                                <td>
                                    <asp:Label id="lblFECNNo" runat="server" width="472px" cssclass="OutputText"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label4" runat="server" width="116px" cssclass="LabelNormal">Model No</asp:Label></td>
                                <td>
                                    <asp:Label id="lblModelNo" runat="server" width="472px" cssclass="OutputText"></asp:Label></td>
                            </tr>
                        </tbody>
                    </table>
                    <p>
                        <table style="HEIGHT: 71px" width="100%" border="1">
                            <tbody>
                                <tr>
                                    <td>
                                        <asp:Label id="Label9" runat="server" width="116px" cssclass="LabelNormal">Part No</asp:Label></td>
                                    <td>
                                        <asp:DropDownList id="cmbPartNo" runat="server" autopostback="true" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" Width="473px" CssClass="OutputText"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label6" runat="server" width="116px" cssclass="LabelNormal">Description</asp:Label></td>
                                    <td>
                                        <asp:Label id="lblPartDesc" runat="server" width="472px" cssclass="OutputText"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label7" runat="server" width="116px" cssclass="LabelNormal">Specification</asp:Label></td>
                                    <td>
                                        <asp:Label id="lblPartSpec" runat="server" width="472px" cssclass="OutputText"></asp:Label></td>
                                </tr>
                            </tbody>
                        </table>
                    </p>
                    <p>
                        <table style="HEIGHT: 71px" width="100%" border="1">
                            <tbody>
                                <tr>
                                    <td>
                                        <asp:Label id="Label10" runat="server" width="116px" cssclass="LabelNormal">Part No</asp:Label></td>
                                    <td>
                                        <asp:DropDownList id="cmbAltPartNo" runat="server" autopostback="true" OnSelectedIndexChanged="cmbAltPartNo_SelectedIndexChanged" Width="473px" CssClass="OutputText"></asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label11" runat="server" width="116px" cssclass="LabelNormal">Description</asp:Label></td>
                                    <td>
                                        <asp:Label id="lblAltPartDesc" runat="server" width="472px" cssclass="OutputText"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label12" runat="server" width="116px" cssclass="LabelNormal">Specification</asp:Label></td>
                                    <td>
                                        <asp:Label id="lblAltPartSpec" runat="server" width="472px" cssclass="OutputText"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label id="Label2" runat="server" width="116px" cssclass="LabelNormal">Mgf Part
                                        No</asp:Label></td>
                                    <td>
                                        <asp:Label id="lblAltMfgPartNo" runat="server" width="472px" cssclass="OutputText"></asp:Label></td>
                                </tr>
                            </tbody>
                        </table>
                    </p>
                    <p>
                        <table style="HEIGHT: 11px" width="100%">
                            <tbody>
                                <tr>
                                    <td>
                                        <asp:Button id="Save" onclick="Save_Click" runat="server" Width="134px" CausesValidation="True" Text="Save"></asp:Button>
                                    </td>
                                    <td>
                                        <div align="right">
                                            <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="134px" CausesValidation="False" Text="Cancel"></asp:Button>
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