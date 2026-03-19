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
        if page.ispostback = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            lblIssuedBy.text = ucase(request.cookies("U_ID").value)
            lblDept.text = ReqCOM.GetFieldVal("Select Dept_Code from User_Profile where U_ID = '" & trim(request.cookies("U_ID").value) & "';","Dept_Code")
            lblFECNDate.text = format(now,"MM/dd/yy")
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
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("FECN.aspx")
    End Sub
    
    Sub cmdSave_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Try
                Dim ReqCOM as Erp_Gtm.erp_Gtm = new ERP_Gtm.ERp_Gtm
                Dim StrSql as string
                txtFECNNo.text = trim(ReqCOM.GEtDocumentNo("FECN_NO"))
                StrSql = "Insert into FECN_M (FECN_NO,MODEL_NO,ECN_NO,BOM_REV,PARTLIST_NO, "
                StrSql = StrSql + "CUST_ECN_NO,PREPARED_BY,PREPARED_DATE,DEPT_CODE) "
                StrSql = StrSql + "Select '" & trim(txtFECNNo.text) & "','" & trim(cmbModelNo.selectedItem.value) & "',"
                StrSql = StrSql + "'" & trim(txtECNNo.text) & "'," & lblBOMRev.text & ","
                StrSql = StrSql + "'" & trim(txtPartListNo.text) & "','" & trim(txtCustECNNo.text) & "',"
                StrSql = StrSql + "'" & trim(request.cookies("U_ID").value) & "','" & now & "','" & TRIM(lblDept.text) & "';"
                ReqCOm.ExecuteNonQuery(StrSql)
    
                StrSql = "Update main set FECN_NO = FECN_NO + 1"
                ReqCOm.ExecuteNonQuery(StrSql)
                Response.redirect("FECNDet.aspx?ID=" + ReqCOM.GetFieldVal("Select Seq_No from FECN_M where FECN_No = '" & trim(txtFECNNo.text) & "';","Seq_No"))
            Catch Err as Exception
            End try
        end if
    End Sub
    
    Sub cmbModelNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERp_Gtm.ERp_Gtm
        lblBOMRev.text = ReqCOM.GetFieldVal("Select top 1 Revision from bom_m where Model_No = '" & trim(cmbModelNo.selecteditem.value) & "' order by revision desc","Revision")
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if UCASE(trim(txtSearch.text)) = "COMMON" then
            Dim oList As ListItemCollection = cmbModelNo.Items
            oList.Add(New ListItem("COMMON"))
            cmbModelNo.Items.FindByText("COMMON").Selected = True
        else
            dissql ("Select MODEL_CODE,Model_Code + '|' + Model_Desc as [Desc] from Model_Master where model_code in (select model_no from bom_m where model_no like '%" & trim(txtSearch.text) & "%') order by MODEL_CODE asc","MODEL_CODE","Desc",cmbModelNo)
    
            if cmbModelNo.selectedindex = 0 then txtPartListNo.text = ReqCOM.GetFieldVal("select PartList_No from model_master where model_code = '" & trim(cmbModelNo.selecteditem.value) & "';","PartList_No")
            if cmbModelNo.selectedindex <> 0 then txtPartListNo.text = ""
    
        end if
    
        if cmbModelNo.selectedIndex = 0 then
            lblBOMRev.text = ReqCOM.GetFieldVal("Select top 1 revision from bom_m where Model_no = '" & trim(cmbModelNo.selecteditem.value) & "' order by revision desc","Revision")
            if trim(lblBOMRev.text) = "<NULL>" then lblBOMRev.text = "0"
        End If
        txtSearch.text = "--Search--"
    End Sub
    
    Sub CustomValidator1_ServerValidate(sender As Object, e As ServerValidateEventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">NEW FECN REGISTRATION</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="76%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Model No." ControlToValidate="cmbModelNo" Display="Dynamic" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Customer ECN No." ControlToValidate="txtCustECNNo" Display="Dynamic" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Partlist No." ControlToValidate="txtPartListNo" Display="Dynamic" EnableClientScript="False"></asp:RequiredFieldValidator>
                                                <asp:CustomValidator id="CustomValidator1" runat="server" CssClass="ErrorText" Width="100%" ForeColor=" " ErrorMessage="Another FECN with selected model is still pending for approval." Display="Dynamic" EnableClientScript="False" OnServerValidate="CustomValidator1_ServerValidate"></asp:CustomValidator>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="">Issued By</asp:Label></td>
                                                                <td width="70%">
                                                                    <asp:Label id="lblIssuedBy" runat="server" cssclass="OutputText" width="332px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal" width="">Department</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblDept" runat="server" cssclass="OutputText" width="418px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="">FECN Date</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblFECNDate" runat="server" cssclass="OutputText" width="389px"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="">Model</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="30%">
                                                                                        <asp:TextBox id="txtSearch" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearch)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                                    </td>
                                                                                    <td width="70%">
                                                                                        <asp:DropDownList id="cmbModelNo" runat="server" CssClass="OutputText" Width="100%" autopostback="True" OnSelectedIndexChanged="cmbModelNo_SelectedIndexChanged"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                </td>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtFECNNo" runat="server" width="232px" CssClass="OutputText" Visible="False" MaxLength="20"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="">ECN No</asp:Label></td>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtECNNo" runat="server" CssClass="OutputText" Width="231px"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="">Customer ECN
                                                                    No</asp:Label></td>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:TextBox id="txtCustECNNo" runat="server" CssClass="OutputText" Width="231px"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="">Partlist No</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtPartListNo" runat="server" CssClass="OutputText" Width="231px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="">Revision No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblBOMRev" runat="server" cssclass="OutputText" width="271px"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="174px" Text="Save as new FECN"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="174px" CausesValidation="False" Text="Cancel"></asp:Button>
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
