<%@ Page Language="VB" %>

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
            dissql ("Select Mod_Name from Mod_Reg_M order by Mod_Name asc","Mod_Name",cmbModuleName)
            LoadData
        end if
    End Sub

    Sub LoadData()
        Dim CurrmainMod as string
        Dim ReqCOM as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim strSql as string = "SELECT * FROM Mod_Reg_D WHERE Seq_No = " & request.params("ID") & ";"
        Dim ResExeDataReader as SQLDataReader = ReqCOM.ExeDataReader(strSql)
        do while ResExeDataReader.read
            CurrMainMod = ResExeDataReader("Main_Mod").tostring
            CurrMainMod = ReqCOM.getFieldVal("Select Mod_Name from Mod_Reg_M where Mod_Name = '" & trim(CurrMainMod) & "';","Mod_Name")
            txtSubModule.text = ResExeDataReader("Mod_desc").tostring
            txtFileName.text = ResExeDataReader("Mod_Name").tostring
        loop
        'cmbModuleName.Items.FindByText(TRIM(CurrMainMod)).Selected = True
    end sub

    SUb Dissql(ByVal strSql As String,FName as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = TRIM(FName)
            .DataTextField = TRIM(FName)
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub

    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        'Dim ReqCustUpdate as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        'ReqCustUpdate.CustUpdate(trim(txtCUST_CODE.text),trim(txtCREDIT_LIMIT.text),trim(txtWEB_SITE.text),trim(txtCONSIGNEE.text),trim(txtPAY_TERM.text),trim(txtREQ_CQA.text),trim(txtREM.text),trim(txtCURR_CODE.text),trim(txtNOTIFY_PARTY.text),trim(txtFORWARDER.text),trim(txtSHIP_TERM.text),trim(txtBILL_CO.text),trim(txtBILL_ATT.text),trim(txtBILL_ADD1.text),trim(txtBILL_ADD2.text),trim(txtBILL_ADD3.text),trim(txtBILL_COUNTRY.text),trim(txtBILL_STATE.text),trim(txtBILL_TEL.text),trim(txtBILL_EXT.text),trim(txtBILL_FAX.text),trim(txtP1_TITLE.text),trim(txtP1_NAME.text),trim(txtP1_EMAIL.text),trim(txtP1_TEL.text),trim(txtP1_EXT.text),trim(txtP1_FAX.text),trim(txtP2_TITLE.text),trim(txtP2_NAME.text),trim(txtP2_EMAIL.text),trim(txtP2_TEL.text),trim(txtP2_EXT.text),trim(txtP2_FAX.text),trim(txtA1_TITLE.text),trim(txtA1_NAME.text),trim(txtA1_EMAIL.text),trim(txtA1_TEL.text),trim(txtA1_EXT.text),trim(txtA1_FAX.text),trim(txtA2_TITLE.text),trim(txtA2_NAME.text),trim(txtA2_EMAIL.text),trim(txtA2_TEL.text),trim(txtA2_EXT.text),trim(txtA2_FAX.text),trim(txtO1_TITLE.text),trim(txtO1_NAME.text),trim(txtO1_EMAIL.text),trim(txtO1_TEL.text),trim(txtO1_EXT.text),trim(txtO1_FAX.text),trim(txtO2_TITLE.text),trim(txtO2_NAME.text),trim(txtO2_EMAIL.text),trim(txtO2_TEL.text),trim(txtO2_EXT.text),trim(txtO2_FAX.text),trim(Request.cookies("U_ID").value))
        'LoadCustData
    End Sub



    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub Button2_Click(sender As Object, e As EventArgs)
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 497px" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <p>
                                &nbsp;
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
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                            <p>
                            </p>
                        </td>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p>
                                <table style="WIDTH: 100%; HEIGHT: 81px" width="100%" border="1">
                                    <tbody>
                                        <tbody>
                                            <tr>
                                                <td colspan="4">
                                                    <p align="center">
                                                        SUB MODULE REGISTRATION&nbsp;
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <font face="Verdana" size="2">Module Name</font></td>
                                                <td colspan="3">
                                                    <div align="center">
                                                        <asp:DropDownList id="cmbModuleName" runat="server" Font-Size="XX-Small" Width="318px" Font-Names="Verdana"></asp:DropDownList>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <font size="2"><font face="Verdana">Sub Module Name</font>&nbsp;&nbsp; </font></td>
                                                <td colspan="3">
                                                    <div align="center">
                                                        <asp:TextBox id="txtSubModule" runat="server" Font-Size="XX-Small" Width="318px" Font-Names="Verdana" Enabled="False"></asp:TextBox>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <font face="Verdana" size="2">File Name</font></td>
                                                <td colspan="3">
                                                    <div align="center">
                                                        <asp:TextBox id="txtFileName" runat="server" Font-Size="XX-Small" Width="318px" Font-Names="Verdana"></asp:TextBox>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </tbody>
                                </table>
                            </p>
                            <p>
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
