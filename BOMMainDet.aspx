<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then loaddata
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

    Sub LoadData
        Dim ReqCom as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim StrSql as string
        Dim PartNo, Level as string
        lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from BOM_D where Seq_No = " & Request.params("ID") & ";","Model_No")
        lblDescription.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
        Dim Color,Packing as string
        Dim ResExeDataReader as SQLDataReader = ReqCOM.ExeDataReader("Select * from BOM_D where Seq_No = " & request.params("ID") & ";")
        do while ResExeDataReader.read
            PartNo = ResExeDataReader("Part_No").tostring
            txtUsage.text = ResExeDataReader("P_Usage").tostring
            Level = ResExeDataReader("P_Level").tostring
            txtLoc.text = ResExeDataReader("P_Location").tostring
            txtLotFactor1.text = ResExeDataReader("Lot_Factor1").tostring
            txtLotFactor2.text = ResExeDataReader("Lot_Factor2").tostring
            lblRevNo.text = ResExeDataReader("REvision").tostring
        loop

        Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no = '" & cstr(PartNo) & "' order by Part_No asc","Part_No","Desc",cmbPartNo)
        Dissql ("Select Level_Code from P_Level where Level_Code = '" & cstr(Level) & "' order by Level_Code asc","Level_Code","Level_Code",cmbLevel)
        StrSql = "Select Color_desc from Color where Color_Desc = '" & trim(Color) & "';"
        StrSql = "Select Pack_Desc from Pack where Pack_Desc = '" & trim(Packing) & "';"
    End sub

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
            StrSql = StrSql + "Update BOM_D set P_Usage = " & trim(txtUsage.text) & ","
            StrSql = StrSql + "P_Level = '" & trim(cmbLevel.selecteditem.value) & "',"
            StrSql = StrSql + "P_Location = '" & trim(txtLOC.text.replace("'","`")) & "',"
            StrSql = StrSql + "Lot_Factor1 = " & txtLotFactor1.text & ","
            StrSql = StrSql + "Lot_Factor2 = " & txtLotFactor2.text & " "
            StrSql = StrSql + "Where SeQ_No = " & request.params("ID") & " "
            ReqCOM.ExecuteNonQuery(StrSql)
            Response.redirect("BOMMainList.aspx?ID=" + ReqCOM.GetFieldVal("Select Seq_No from BOM_M where Model_No = '" & trim(lblModelNo.text) & "';","SEQ_No"))
        end if
    End Sub

    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Dim ReqCom as ERp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        Response.redirect("BOMMainList.aspx?ID=" + ReqCOM.GetFieldVal("Select Seq_No from BOM_M where Model_No = '" & trim(lblModelNo.text) & "' and Revision = " & cdec(lblRevNo.text) & ";","SEQ_No"))
    End Sub

    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        If ReqCOM.FuncCheckDuplicate("Select * from Part_Master where Part_No = '" & trim(txtSearchPart.text) & "';","Part_No") = true then
            cmbPartNo.items.clear
            Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no = '" & cstr(txtSearchPart.Text) & "' order by Part_No asc","Part_No","Desc",cmbPartNo)
            txtSearchPart.text = "-- Search --"
            Exit sub
        Else
            Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' order by Part_No asc","Part_No","Desc",cmbPartNo)
            txtSearchPart.text = "-- Search --"
        End if
    End Sub

    Sub cmdGo1_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        If ReqCOM.FuncCheckDuplicate("Select * from P_Level where Level_Code = '" & trim(txtSearchLevel.text) & "';","level_Code") = true then
            cmbLevel.items.clear
            Dissql ("Select Level_Code from P_Level where Level_Code = '" & cstr(txtSearchLevel.Text) & "' order by Level_Code asc","Level_Code","Level_Code",cmbLevel)
            txtSearchLevel.text = "-- Search --"
            Exit sub
        Else
            Dissql ("Select Level_Code from P_Level where Level_Code like '%" & cstr(txtSearchLevel.Text) & "%' order by Level_Code asc","Level_Code","Level_Code",cmbLevel)
            txtSearchLevel.text = "-- Search --"
        End if
    End Sub

    Sub cmdAlt_Click(sender As Object, e As EventArgs)
        Response.redirect("BOMAltList.aspx?ID=" & Request.params("ID") )
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <ERP:HEADER id="UserControl1" runat="server"></ERP:HEADER>
                            </div>
                           
                            <div align="center">
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Part Details (BOM List)</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center">
                                                                        <br />
                                                                        <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" OnServerValidate="ServerValidate" Display="Dynamic" ControlToValidate="cmbLevel" ForeColor=" " CssClass="ErrorText">
                                    'Part Location' cannot be longer than 900 character.
                                </asp:CustomValidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:RequiredFieldValidator id="ValUsage" runat="server" Width="100%" Display="Dynamic" ControlToValidate="txtUsage" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid part usage."></asp:RequiredFieldValidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:comparevalidator id="ValUsageFormat" runat="server" Width="100%" Display="Dynamic" ControlToValidate="txtUsage" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid part usage." Operator="DataTypeCheck" Type="Double"></asp:comparevalidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:RequiredFieldValidator id="ValLotFactor1" runat="server" Width="100%" Display="Dynamic" ControlToValidate="txtLotFactor1" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid lot factor 1."></asp:RequiredFieldValidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:RequiredFieldValidator id="ValLotFactor2" runat="server" Width="100%" Display="Dynamic" ControlToValidate="txtLotFactor2" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid lot factor 2."></asp:RequiredFieldValidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:comparevalidator id="ValLotFactor1Format" runat="server" Width="100%" Display="Dynamic" ControlToValidate="txtLotFactor1" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid lot factor 1." Operator="DataTypeCheck" Type="Double"></asp:comparevalidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:comparevalidator id="ValLotFactor2Format" runat="server" Width="100%" Display="Dynamic" ControlToValidate="txtlotFactor2" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid lot factor 2." Operator="DataTypeCheck" Type="Double"></asp:comparevalidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" Display="Dynamic" ControlToValidate="cmbPartNo" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Part No."></asp:RequiredFieldValidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" Display="Dynamic" ControlToValidate="cmbLevel" ForeColor=" " CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Level."></asp:RequiredFieldValidator>
                                                                        <br />
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="96%" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label2" runat="server" width="117px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                                                    <td width="75%" colspan="3">
                                                                                        <asp:Label id="lblModelNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server" width="117px" cssclass="LabelNormal">Description</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblDescription" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label13" runat="server" width="117px" cssclass="LabelNormal">Revision
                                                                                        No</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:Label id="lblRevNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label4" runat="server" width="117px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:TextBox id="txtSearchPart" runat="server" Width="78px" CssClass="Input_Box" Enabled="False">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Enabled="False" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                                        &nbsp;&nbsp;
                                                                                        <asp:DropDownList id="cmbPartNo" runat="server" Width="258px" CssClass="Input_Box"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label5" runat="server" width="117px" cssclass="LabelNormal">Level</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:TextBox id="txtSearchLevel" runat="server" Width="78px" CssClass="Input_Box" Enabled="False">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdGo1" onclick="cmdGo1_Click" runat="server" Enabled="False" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                                        &nbsp;&nbsp;
                                                                                        <asp:DropDownList id="cmbLevel" runat="server" Width="258px" CssClass="Input_Box"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label6" runat="server" width="117px" cssclass="LabelNormal">Location</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:TextBox id="txtLoc" runat="server" Width="491px" CssClass="Input_Box" Height="60px" ReadOnly="True" TextMode="MultiLine"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label7" runat="server" width="117px" cssclass="LabelNormal">Part Usage</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:TextBox id="txtUsage" runat="server" Width="87px" CssClass="Input_Box" Enabled="False"></asp:TextBox>
                                                                                        &nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label10" runat="server" width="117px" cssclass="LabelNormal">Lot Factor
                                                                                        1</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:TextBox id="txtLotFactor1" runat="server" Width="167px" CssClass="Input_Box" Enabled="False"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label11" runat="server" width="117px" cssclass="LabelNormal">Lot Factor
                                                                                        2</asp:Label></td>
                                                                                    <td colspan="3">
                                                                                        <asp:TextBox id="txtLotFactor2" runat="server" Width="167px" CssClass="Input_Box" Enabled="False"></asp:TextBox>
                                                                                        <asp:DropDownList id="cmbColor" runat="server" Width="58px" CssClass="OutputText" Enabled="False" Visible="False"></asp:DropDownList>
                                                                                        <asp:DropDownList id="cmbPacking" runat="server" Width="62px" CssClass="OutputText" Enabled="False" Visible="False"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        <br />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Update Changes" Visible="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdAlt" onclick="cmdAlt_Click" runat="server" Text="View Alternate" CausesValidation="False" Visible="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="174px" Text="Cancel" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </p>
                            </div>
                            <footer:footer id="footer" runat="server"></footer:footer>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <p>
        </p>
    </form>
</body>
</html>
