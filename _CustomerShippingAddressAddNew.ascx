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
        if request.cookies("U_ID") is nothing then response.redirect("AccessDenied.aspx")
    
        if not ispostback then
            Dim ReqCOm as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            lblCustcode.text = ReqCOM.GetFieldVal("Select Cust_Code from Cust where Seq_No = " & request.params("ID") & ";","Cust_Code")
            lblCustName.text = ReqCOM.GetFieldVal("Select Cust_Name from Cust where Seq_No = " & request.params("ID") & ";","Cust_Name")
        end if
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub Button2_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub LinkButton1_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.erp_Gtm = new Erp_Gtm.Erp_Gtm
        Response.redirect("CustomerDet.aspx?ID=" + ReqCOM.GetFieldVal("Select Seq_No from Cust where Cust_Code = '" & trim(lblCustCode.text) & "';","Seq_No"))
    End Sub
    
    Sub cmbSave_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERp_Gtm.Erp_Gtm = New Erp_Gtm.Erp_Gtm
            Dim StrSql as string
            StrSQl = "Insert into Cust_Ship(Cust_Code,Ship_Co,Ship_Att,Ship_Add1,Ship_Add2,"
            StrSql = StrSql + "Ship_Add3,Ship_Country,Ship_State,Ship_Tel1,Ship_Ext1,Ship_Fax1) "
            StrSql = StrSql + "Select '" & trim(lblCustCode.text) & "','" & trim(txtCompanyName.text) & "',"
            StrSql = StrSql + "'" & trim(txtAttention.text) & "','" & trim(txtAdd1.text) & "','" & trim(txtAdd2.text) & "',"
            StrSql = StrSQL + "'" & trim(txtAdd3.text) & "','" & trim(txtCountry.text) & "',"
            StrSql = StrSQL + "'" & trim(txtState.text) & "','" & trim(txtTel.text) & "',"
            StrSql = StrSQL + "'" & trim(txtExt.text) & "','" & trim(txtFax.text) & "';"
            ReqCOM.executeNonQuery(StrSql)
            Response.redirect("CustomerDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("CustomerDet.aspx?ID=" & request.params("ID"))
    End Sub

</script>
<link href="IBuySpy.css" type="text/css" rel="stylesheet">
<p align="center">
    <asp:Label id="Label1" cssclass="FormDesc" width="100%" runat="server">ADD NEW CUSTOMER
    SHIPPING DETAILS</asp:Label>
</p>
<table style="HEIGHT: 497px" cellspacing="0" cellpadding="0" width="80%" align="center" border="0">
    <tbody>
        <tr>
            <td valign="top" nowrap="nowrap" align="left" width="100%">
                <p>
                    <asp:RequiredFieldValidator id="ValCompanyname" runat="server" EnableClientScript="False" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid company name." ControlToValidate="txtCompanyName" Display="Dynamic" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" EnableClientScript="False" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid shipping address." ControlToValidate="txtAdd1" Display="Dynamic" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" EnableClientScript="False" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid shipping state." ControlToValidate="txtState" Display="Dynamic" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" EnableClientScript="False" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid shipping country." ControlToValidate="txtCountry" Display="Dynamic" CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                </p>
                <p>
                    <table style="HEIGHT: 178px" width="100%" align="center" border="1">
                        <tbody>
                            <tr>
                                <td>
                                    <asp:Label id="Label2" cssclass="LabelNormal" width="124px" runat="server">Customer
                                    Code</asp:Label></td>
                                <td>
                                    <div align="left"><asp:Label id="lblCustCode" cssclass="OutputText" width="364px" runat="server"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label3" cssclass="LabelNormal" width="124px" runat="server">Customer
                                    Name</asp:Label></td>
                                <td>
                                    <div align="left"><asp:Label id="lblCustName" cssclass="OutputText" width="364px" runat="server"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label4" cssclass="LabelNormal" width="124px" runat="server">Company
                                    Name</asp:Label></td>
                                <td>
                                    <div align="left">
                                        <asp:TextBox id="txtCompanyName" runat="server" CssClass="OutputText" Width="466px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label5" cssclass="LabelNormal" width="124px" runat="server">Attention</asp:Label></td>
                                <td>
                                    <div align="left">
                                        <asp:TextBox id="txtAttention" runat="server" CssClass="OutputText" Width="466px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td rowspan="3">
                                    <asp:Label id="Label6" cssclass="LabelNormal" width="124px" runat="server">Address</asp:Label></td>
                                <td>
                                    <div align="left">
                                        <asp:TextBox id="txtAdd1" runat="server" CssClass="OutputText" Width="466px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div align="left">
                                        <asp:TextBox id="txtAdd2" runat="server" CssClass="OutputText" Width="466px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div align="left">
                                        <asp:TextBox id="txtAdd3" runat="server" CssClass="OutputText" Width="466px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label7" cssclass="LabelNormal" width="124px" runat="server">Country</asp:Label></td>
                                <td>
                                    <div align="left">
                                        <asp:TextBox id="txtCountry" runat="server" CssClass="OutputText" Width="466px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label8" cssclass="LabelNormal" width="124px" runat="server">State</asp:Label></td>
                                <td>
                                    <div align="left">
                                        <asp:TextBox id="txtState" runat="server" CssClass="OutputText" Width="466px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label9" cssclass="LabelNormal" width="124px" runat="server">Tel. No</asp:Label></td>
                                <td>
                                    <div align="left">
                                        <asp:TextBox id="txtTel" runat="server" CssClass="OutputText" Width="466px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label10" cssclass="LabelNormal" width="124px" runat="server">Extention</asp:Label></td>
                                <td>
                                    <div align="left">
                                        <asp:TextBox id="txtExt" runat="server" CssClass="OutputText" Width="466px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label id="Label11" cssclass="LabelNormal" width="124px" runat="server">Fax No.</asp:Label></td>
                                <td>
                                    <div align="left">
                                        <asp:TextBox id="txtFax" runat="server" CssClass="OutputText" Width="466px"></asp:TextBox>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </p>
                <p>
                    <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                        <tbody>
                            <tr>
                                <td>
                                    <asp:Button id="cmbSave" onclick="cmbSave_Click" runat="server" Width="174px" Text="Save"></asp:Button>
                                </td>
                                <td>
                                    <div align="right">
                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="174px" Text="Back" CausesValidation="False"></asp:Button>
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