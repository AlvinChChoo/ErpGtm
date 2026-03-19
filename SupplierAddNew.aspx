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
        if ispostback = false then
            Dissql("SELECT CURR_CODE,curr_code + ' - ' + curr_desc as [desc] FROM CURR ORDER BY CURR_CODE ASC","CURR_CODE","desc",cmbCurr_Code)
            Dissql("SELECT PayTerm_Desc,Seq_No FROM payterm ORDER BY payterm_desc ASC","payterm_desc","payterm_desc",cmbPayterm)
            Dissql("SELECT shipterm_Code,shipterm_desc FROM shipterm ORDER BY shipterm_desc ASC","shipterm_Code","shipterm_desc",cmbShipTerm)
            Dissql("select rtrim(upper(country)) as [country] from country order by country","country","country",cmbVenCountry)
        end if
    End Sub
    
    
    Sub Button2_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdSave_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            txtVenCode.text = txtVenCode.text
            ReqCOM.ExecuteNonQuery("Insert into Vendor(LOC,contact_person,email1,email2,Add1,Add2,Add3,Tel1,Fax1,Pay_Term,Ship_Term,Ven_Code,Ven_Name,Curr_Code,ven_country,Create_By,Create_Date) Select '" & trim(cmbLocation.selecteditem.value) & "','" & trim(txtContactPerson.text) & "','" & trim(txtEmail1.text) & "','" & trim(txtEmail2.text) & "','" & trim(txtAdd1.text) & "','" & trim(txtAdd2.text) & "','" & trim(txtAdd3.text) & "','" & trim(txtTel.text) & "','" & trim(txtFax.text) & "','" & trim(cmbPayterm.selecteditem.value) & "','" & trim(cmbShipTerm.selecteditem.value) & "','" & trim(txtVenCode.text) & "','" & trim(txtVenName.text) & "','" & trim(cmbCurr_Code.selectedItem.value) & "','" & trim(cmbVenCountry.selecteditem.value) & "','" & trim(request.cookies("U_ID").value) & "','" & trim(now) & "';")
            ReqCOM.ExecuteNonQuery("Update Main set Ven_Code = Ven_Code + 1")
            Response.redirect("SupplierDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from Vendor where Ven_Code = '" & trim(txtVencode.text) & "';","Seq_No"))
        end if
    End Sub
    
    
         SUb Dissql(ByVal strSql As String,FValue as string,FName as string,Obj as Object)
             Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
             Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
             with obj
                 .items.clear
                 .DataSource = ResExeDataReader
                 .DataValueField = trim(FValue.toUpper())
                 .DataTextField = trim(FName.toUpper())
                 .DataBind()
             end with
             ResExeDataReader.close()
         End Sub
    
    
    Sub ValDuplicateVenCode(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        If reqCOM.funcCheckDuplicate("Select * from Vendor where Ven_Code = '" & trim(txtVenCode.text) & "';","Ven_Code") = true then
            e.isvalid = false
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Supplier.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" backcolor="" forecolor="" cssclass="FormDesc">NEW
                                SUPPLIER REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="70%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div>
                                                    <asp:CustomValidator id="DuplicateVenCode" runat="server" CssClass="ErrorText" ErrorMessage="Supplier Code already exist." ForeColor=" " Display="Dynamic" EnableClientScript="False" OnServerValidate="ValDuplicateVenCode"></asp:CustomValidator>
                                                </div>
                                                <div>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid supplier name." ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="txtVenName"></asp:RequiredFieldValidator>
                                                </div>
                                                <div>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid currency code." ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="cmbCurr_Code"></asp:RequiredFieldValidator>
                                                </div>
                                                <div>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid address." ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="txtAdd1"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid payment term" ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="cmbPayTerm"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid shipping term" ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="cmbShipTerm"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid tel no" ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="txtTel"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator8" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid fax no" ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="txtFax"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid contact person" ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="txtContactPerson"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator9" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid email" ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="txtEmail1"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator10" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid location" ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="cmbLocation"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator11" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Supplier Code." ForeColor=" " Display="Dynamic" Width="100%" ControlToValidate="txtVenCode"></asp:RequiredFieldValidator>
                                                </div>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Supplier Code </asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtVenCode" runat="server" CssClass="OutputText" Width="100%" MaxLength="20"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Supplier Name </asp:Label></td>
                                                            <td colspan="3">
                                                                <div align="left">
                                                                    <asp:TextBox id="txtVenName" runat="server" CssClass="OutputText" Width="100%" MaxLength="60"></asp:TextBox>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="3">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Address</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtAdd1" runat="server" CssClass="OutputText" Width="100%" MaxLength="50"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtAdd2" runat="server" CssClass="OutputText" Width="100%" MaxLength="50"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtAdd3" runat="server" CssClass="OutputText" Width="100%" MaxLength="50"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Country</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:DropDownList id="cmbVenCountry" runat="server" CssClass="OutputText" Width="235px"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Payment Term</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:DropDownList id="cmbPayTerm" runat="server" CssClass="OutputText" Width="315px"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Shipping Term</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:DropDownList id="cmbShipTerm" runat="server" CssClass="OutputText" Width="315px"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Currency Code</asp:Label></td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:DropDownList id="cmbCurr_Code" runat="server" CssClass="OutputText" Width="315px"></asp:DropDownList>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Location</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:DropDownList id="cmbLocation" runat="server" CssClass="OutputText" Width="315px">
                                                                    <asp:ListItem Value="L">Local</asp:ListItem>
                                                                    <asp:ListItem Value="S">Singapore</asp:ListItem>
                                                                    <asp:ListItem Value="F">Foreign</asp:ListItem>
                                                                    <asp:ListItem Value="G">GPB</asp:ListItem>
                                                                    <asp:ListItem Value="Z">FTZ</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Contact Person</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtContactPerson" runat="server" CssClass="OutputText" Width="315px" MaxLength="60"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label10" runat="server" cssclass="LabelNormal">Email 1</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtEmail1" runat="server" CssClass="OutputText" Width="315px" MaxLength="50"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Email 2</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtEmail2" runat="server" CssClass="OutputText" Width="315px" MaxLength="50"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Tel</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtTel" runat="server" CssClass="OutputText" Width="315px" MaxLength="20"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Fax</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:TextBox id="txtFax" runat="server" CssClass="OutputText" Width="315px" MaxLength="20"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    &nbsp; 
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="160px" Text="Save as new supplier"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="117px" Text="Back" CausesValidation="False"></asp:Button>
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
