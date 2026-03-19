<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If not IsPostBack  Then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
            lblFECNNo.text = ReqCOM.GetFieldVal("Select FECN_NO from FECN_M where SEQ_NO = " & Request.params("ID") & ";","FECN_NO")
            lblModelNo.text = ReqCOm.GetFieldVal("Select Model_No from FECN_M where Seq_No = " & Request.params("ID") & ";","Model_No")
            lblRevNo.text = ReqCOM.GetFieldVal("Select max(Revision) as [Revision] from BOM_M where Model_No = '" & trim(lblModelNo.text) & "';","Revision")
        end if
    End Sub
    
    SUb Dissql(ByVal strSql As String,VName as string,FName as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = VName
            .DataTextField = FName
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim RsPart as SqlDataReader = ReqCOM.ExeDataReader("Select Part_Spec,Part_Desc,M_Part_No from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';")
        do while RsPart.read
            lblPartDesc.text = RsPart("Part_Desc").ToString
            lblPartSpec.text = RsPart("Part_Spec").ToString
            lblMfgPartNo.text = RsPart("M_Part_No").ToString
        loop
    End Sub
    
    Sub Save_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERp_Gtm.Erp_gtm = new Erp_Gtm.ERP_Gtm
            Dim StrSql as string
    
            'Try
            '    StrSql = "Insert into FECN_D(FECN_NO,MAIN_PART_B4,ALT_PART_B4,PART_DESC_B4,PART_SPEC_B4,"
            '    StrSql = StrSql + "M_PART_NO_B4,P_USAGE_B4,P_LEVEL_B4,P_LOCATION_B4,MAIN_PART,ALT_PART,"
            '    StrSql = StrSql + "PART_DESC,PART_SPEC,M_PART_NO,P_USAGE,P_LEVEL,P_LOCATION,REASON_CHANGE,TYPE_CHANGE) "
            '    StrSql = StrSql + "Select '" & trim(lblFECNNo.text) & "','" & trim(cmbPartNo.selectedItem.Value) & "','-','" & trim(lblPartDesc.text) & "','" & trim(lblPartSpec.text) & "',"
            '    StrSql = StrSql + "'" & lblMfgPartNo.text & "'," & lblUsage.text & ",'" & trim(cmbLevelB.selectedItem.text) & "','" & trim(lbllocation.text) & "','" & trim(cmbpartNo.selectedItem.value) & "','-',"
            '    StrSql = StrSql + "'" & TRIM(txtPartDesc.text) & "','" & trim(txtPartSpec.text) & "','" & trim(txtMfgPartNo.text) & "'," & trim(txtUsage.text) & ","
            '    StrSql = StrSql + "'" & TRIM(cmbLevelA.selectedItem.value) & "',"
            '    StrSql = StrSql + "'" & TRIM(txtLocation.text) & "','" & TRIM(txtReasonChange.text) & "','Edit Main Part'"
            '    ReqCOM.ExecuteNonQuery(StrSql)
            '    Response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
            'Catch Err as exception
            '    RESPONSE.WRITE(err)
            'end try
        end if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        response.redirect("FECNDet.aspx?ID=" & ReqCOM.GetFIeldVal("Select Seq_No from FECN_M where FECN_No = '" & trim(lblFECNNo.text) & "';","Seq_No"))
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        If ReqCOM.FuncCheckDuplicate("Select * from Part_Master where Part_No = '" & trim(txtSearchPart.text) & "';","Part_No") = true then
            cmbPartNo.items.clear
            Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc]  from Part_Master where Part_No = '" & trim(txtSearchPart.text) & "';","Part_No","Desc",cmbPartNo)
            lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Desc")
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
            lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_Part_No from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","M_Part_No")
            txtSearchPart.text = "-- Search --"
            Exit sub
        Else
            cmbPartNo.items.clear
            Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc]  from Part_Master where Part_No in (Select Part_No from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No like '%" & trim(txtSearchPart.text) & "%' and Revision = " & cdec(lblRevNo.text) & ")","Part_No","Desc",cmbPartNo)
            txtSearchPart.text = "-- Search --"
            if cmbPartNo.selectedIndex = 0 then
                lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Desc")
                lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
                lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_Part_No from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","M_Part_No")
            end  if
        End if
    End Sub
    
    Sub cmdPartA_Click(sender As Object, e As EventArgs)
        'Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        Dissql ("Select Part_No,Part_No as [Desc]  from Part_Master where Part_No like '%" & trim(txtPartA.text) & "%';","Part_No","Desc",cmbPartA)
        txtPartA.text = "-- Search --"
        if cmbPartA.selectedindex = 0 then
            lblpartDescA.text = ReqCOM.GetFieldVal("Select top 1 Part_Desc from Part_Master where Part_no = '" & trim(cmbPartA.selecteditem.value) & "';","Part_Desc")
            lblPartSpecA.text = ReqCOM.GetFieldVal("Select top 1 Part_Spec from Part_Master where Part_no = '" & trim(cmbPartA.selecteditem.value) & "';","Part_Spec")
            lblMfgPartNoA.text = ReqCOM.GetFieldVal("Select top 1 M_Part_No from Part_Master where Part_no = '" & trim(cmbPartA.selecteditem.value) & "';","M_Part_No")
        elseif cmbPartA.selectedindex = -1 then
            lblpartDescA.text = ""
            lblPartSpecA.text = ""
            lblMfgPartNoA.text = ""
        end if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">FECN - EDIT
                            BOM MAIN PART</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="80%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <p>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid reason of change" ForeColor=" " Display="Dynamic" ControlToValidate="txtReasonChange" EnableClientScript="False"></asp:RequiredFieldValidator>
                                            </p>
                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td width="25%" bgcolor="silver">
                                                            <asp:Label id="Label5" runat="server" width="116px" cssclass="LabelNormal">FECN No</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblFECNNo" runat="server" width="472px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label4" runat="server" width="116px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblModelNo" runat="server" width="472px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div align="center"><asp:Label id="Label10" runat="server" width="100%">BEFORE CHANGES</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label1" runat="server" width="116px" cssclass="LabelNormal">Part No </asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                &nbsp;&nbsp;&nbsp; 
                                                                <asp:DropDownList id="cmbPartNo" runat="server" CssClass="OutputText" Width="311px" AutoPostBack="True" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" width="116px" cssclass="LabelNormal">Description</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:Label id="lblPartDesc" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label19" runat="server" width="116px" cssclass="LabelNormal">Specification</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:Label id="lblPartSpec" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label21" runat="server" width="116px" cssclass="LabelNormal">Mfg Part
                                                                No</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:Label id="lblMfgPartNo" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="2">
                                                                <div align="center"><asp:Label id="Label6" runat="server" width="100%">AFTER CHANGES</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" width="116px" cssclass="LabelNormal">Part No </asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPartA" onkeydown="KeyDownHandler(cmdPartA)" onclick="GetFocus(txtPartA)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                <asp:Button id="cmdPartA" onclick="cmdPartA_Click" runat="server" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                &nbsp;&nbsp;&nbsp; 
                                                                <asp:DropDownList id="cmbPartA" runat="server" CssClass="OutputText" Width="311px" AutoPostBack="True" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="lbl" runat="server" width="116px" cssclass="LabelNormal">Change Reason</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtReasonChange" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" width="116px" cssclass="LabelNormal">Description</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:Label id="lblPartDescA" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label12" runat="server" width="116px" cssclass="LabelNormal">Specification</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:Label id="lblPartSpecA" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label14" runat="server" width="116px" cssclass="LabelNormal">Mfg Part
                                                                No</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:Label id="lblMfgPartNoA" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
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
                                                                <asp:Label id="lblRevNo" runat="server" width="116px" cssclass="LabelNormal" visible="false"></asp:Label></td>
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
        <p>
        </p>
    </form>
</body>
</html>
