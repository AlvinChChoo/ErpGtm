<%@ Page Language="VB" %>
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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
            Dim RsFECN as SQLDataReader = ReqCOM.exeDataReader("Select * from FECN_D where Seq_No = '" & request.params("ID") & "';")
            Dim PartNo, AltPartNo as string
            Do while rsFECN.read
                PartNo = rsFECN("Main_part")
                AltPartNo = rsFECN("ALt_Part")
                lblFECNNo.text = rsFECN("FECN_NO")
            loop
    
            lblModelNo.text = ReqCOm.GetFieldVal("Select Model_No from FECN_M where FECN_NO = '" & lblFECNNo.text & "';","Model_No")
            Dissql ("Select PM.Part_No, PM.Part_No + '|' + PM.Part_Desc as [Desc] from Part_Master PM,BOM_D BOM where BOM.Model_No = '" & trim(lblModelNo.text) & "' and PM.Part_No = BOM.Part_No order by PM.Part_No asc","Part_No","Desc",cmbPartNo)
            Dissql ("Select Part_No, Part_No + '|' + Part_Desc as [Desc] from Part_Master order by Part_No asc","Part_No","Desc",cmbAltPartNo)
    
            PartNo = ReqCOM.GetFieldVal("Select Part_No from part_master where Part_No = '" & trim(PartNo) & "';","Part_No")
            cmbPartNo.Items.FindByValue(PartNo.ToString).Selected = True
    
            AltPartNo = ReqCOM.GetFieldVal("Select Part_No from part_master where Part_No = '" & trim(AltPartNo) & "';","Part_No")
            cmbAltPartNo.Items.FindByValue(AltPartNo.ToString).Selected = True
    
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
            lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
    
            lblAltPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbAltPartNo.selecteditem.value & "';","Part_Spec")
            lblAltPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbAltPartNo.selecteditem.value & "';","Part_Desc")
            lblAltMfgPartNo.text = ReqCOM.GetFieldVal("Select M_Part_No from Part_Master where Part_No = '" & cmbAltPartNo.selecteditem.value & "';","M_Part_No")
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
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCom as ERp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
        lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Response.redirect("FECNDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from FECN_M where FECN_NO = '" & trim(lblFecnNo.text) & "';","Seq_No"))
    End Sub
    
    Sub Save_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERp_Gtm.Erp_gtm = new Erp_Gtm.ERP_Gtm
            Dim StrSql as string
            Try
                StrSql = "Update FECN_D set MAIN_PART = '" & trim(cmbPartNo.selectedItem.value) & "',"
                StrSql = StrSql + "ALT_PART = '" & trim(cmbAltPartNo.selectedItem.value) & "',"
                StrSql = StrSql + "PART_DESC = '" & lblAltPartDesc.text & "',"
                StrSql = StrSql + "PART_SPEC = '" & lblAltPartSpec.text & "',"
                StrSql = StrSql + "M_PART_NO = '" & lblAltMfgPartNo.text & "' "
                StrSql = StrSql + "where seq_no = " & request.params("ID") & ";"
                ReqCOM.ExecuteNonQuery(StrSql)
                Response.redirect("FECNDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from FECN_M where FECN_NO = '" & trim(lblFecnNo.text) & "';","Seq_No"))
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
        rsPart.close()
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <table style="HEIGHT: 27px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">ADD ALTERNATE
                            PART</asp:Label>
                        </p>
                        <p>
                            <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="94%" align="center">
                                <tbody>
                                    <tr>
                                        <td>
                                            <table style="HEIGHT: 48px" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="116px">FECN No</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblFECNNo" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="116px">Model No</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                                <table style="HEIGHT: 71px" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div align="center"><asp:Label id="Label8" runat="server" width="100%">MAIN PART</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="116px">Part No</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbPartNo" runat="server" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" CssClass="OutputText" Width="473px" autopostback="true"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="116px">Description</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPartDesc" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="116px">Specification</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPartSpec" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="HEIGHT: 71px" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div align="center"><asp:Label id="Label3" runat="server" width="100%">ALTERNATE PART</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="116px">Part No</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbAltPartNo" runat="server" OnSelectedIndexChanged="cmbAltPartNo_SelectedIndexChanged" CssClass="OutputText" Width="473px" autopostback="true"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="116px">Description</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblAltPartDesc" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="116px">Specification</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblAltPartSpec" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="116px">Mgf Part
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblAltMfgPartNo" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
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
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
