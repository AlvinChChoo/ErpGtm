<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
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
        if ispostback = false then
            Dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust order by Cust_Code asc","Cust_Code","Desc",cmbCustCode)
            Dissql ("Select Prod_Type_Code, Prod_Type_Desc as [Desc] from Prod_Type order by Prod_Type_Code asc","Prod_Type_Code","Desc",cmbProdType)
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

    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim StrSql as string
            StrSql = "Insert into Model_Master"
            StrSql = StrSql + "(Model_Code,cust_part_no,Model_Desc,Cust_Code,Revision_No,Brand_Name,PartList_No,"
            StrSql = StrSql + "Prod_Type_Code,Model_Grp,UP,Create_By,Create_Date) "
            StrSql = StrSql + "Select '" & trim(txtModelCode.text) & "',"
            StrSql = StrSql + "'" & trim(txtCustPartNo.text) & "',"
            StrSql = StrSql + "'" & trim(txtModelDesc.text) & "',"
            StrSql = StrSql + "'" & trim(cmbCustCode.selectedItem.value) & "',"
            StrSql = StrSql + "1.00,"
            StrSql = StrSql + "'" & trim(txtBrandName.text) & "',"
            StrSql = StrSql + "'" & trim(txtPartListNo.text) & "',"
            StrSql = StrSql + "'" & trim(cmbProdtype.selectedItem.value) & "',"
            StrSql = StrSql + "'" & trim(txtModelGrp.text) & "',"
            StrSql = StrSql + "" & trim(txtUP.text) & ","
            StrSql = StrSql + "'" & trim(request.cookies("U_ID").value) & "',"
            StrSql = StrSql + "'" & Now & "'"

            ReqCOM.ExecuteNonQuery(StrSql)
            StrSql = "Select Seq_No from Model_Master where Model_Code = '" & trim(txtModelCode.text) & "';"
            response.redirect("ModelDet.aspx?ID=" + ReqCOM.GetFieldVal(StrSql,"Seq_No"))
        end if
    End Sub

    Sub cmbProdtype_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub

    Sub ValDuplicateModel(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.FuncCheckDuplicate("Select Model_Code from Model_Master where Model_Code = '" & trim(txtModelCode.text) & "';","Model_Code") = true then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Model.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form  runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <IBUYSPY:HEADER id="UserControl1" runat="server"></IBUYSPY:HEADER>
                            </div>
                            <div align="center">
                                <div align="center">
                                    <asp:CustomValidator id="CustomValidator1" runat="server" OnServerValidate="ValDuplicateModel" CssClass="ErrorText" ForeColor=" " ErrorMessage="Selected Models already exist." Display="Dynamic" Width="100%"></asp:CustomValidator>
                                </div>
                                <div align="center">
                                    <asp:RequiredFieldValidator id="valModelCode" runat="server" CssClass="ErrorText" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Model Color." Display="Dynamic" Width="100%" ControlToValidate="txtModelCode"></asp:RequiredFieldValidator>
                                </div>
                                <div align="center">
                                    <asp:RequiredFieldValidator id="ValModelDesc" runat="server" CssClass="ErrorText" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Description." Display="Dynamic" Width="100%" ControlToValidate="txtModelDesc"></asp:RequiredFieldValidator>
                                </div>
                                <div align="center">
                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Product Type." Display="Dynamic" Width="100%" ControlToValidate="cmbProdtype"></asp:RequiredFieldValidator>
                                </div>
                                <div align="center">
                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Customer " Display="Dynamic" Width="100%" ControlToValidate="cmbCustCode"></asp:RequiredFieldValidator>
                                </div>
                                <div align="center">
                                    <asp:CompareValidator id="CompareValidator1" runat="server" CssClass="ErrorText" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Unit Price." Display="Dynamic" Width="100%" ControlToValidate="txtUP" EnableClientScript="False" Operator="DataTypeCheck" Type="Currency"></asp:CompareValidator>
                                </div>
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
                                                                    Model Details</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <br />
                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="80%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="116px">Model Code</asp:Label></td>
                                                                                <td colspan="3">
                                                                                    <p>
                                                                                        <asp:TextBox id="txtModelCode" runat="server" CssClass="Input_Box" Width="216px"></asp:TextBox>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="116px">Description</asp:Label>&nbsp;&nbsp;</td>
                                                                                <td colspan="3">
                                                                                    <p>
                                                                                        <asp:TextBox id="txtModelDesc" runat="server" CssClass="Input_Box" Width="382px"></asp:TextBox>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="116px">Customer</asp:Label></td>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:DropDownList id="cmbCustCode" runat="server" CssClass="Input_Box"></asp:DropDownList>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal">Customer Part No</asp:Label></td>
                                                                                <td>
                                                                                    <asp:TextBox id="txtCustPartNo" runat="server" CssClass="Input_Box" Width="216px"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="116px">Partlist
                                                                                    No</asp:Label></td>
                                                                                <td>
                                                                                    <asp:TextBox id="txtPartListNo" runat="server" CssClass="Input_Box" Width="216px"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="116px">Brand Name</asp:Label></td>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:TextBox id="txtBrandName" runat="server" CssClass="Input_Box" Width="216px"></asp:TextBox>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="116px">Model Group</asp:Label></td>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:TextBox id="txtModelGrp" runat="server" CssClass="Input_Box" Width="216px"></asp:TextBox>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="116px">Product
                                                                                    Type</asp:Label></td>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:DropDownList id="cmbProdtype" runat="server" CssClass="Input_Box" OnSelectedIndexChanged="cmbProdtype_SelectedIndexChanged"></asp:DropDownList>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="116px">Unit Price</asp:Label></td>
                                                                                <td>
                                                                                    <p>
                                                                                        <asp:TextBox id="txtUP" runat="server" CssClass="Input_Box" Width="216px"></asp:TextBox>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <p>
                                                                        <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="80%" align="center">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="Server" Width="143px" autopostback="true" Text="Save as New Model"></asp:Button>
                                                                                        </p>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="right">
                                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="143px" Text="Back" CausesValidation="False"></asp:Button>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        <br />
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <p align="center">
                                                        <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <p>
                                                                        </p>
                                                                        <p>
                                                                            &nbsp;
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
                            </div>
                            <footer:footer id="footer" runat="server"></footer:footer>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
