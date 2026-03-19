<%@ Page Language="VB" Debug="true" %>
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
            if ispostback = false then
                LoadSupplierData
            End if
        End Sub
    
    Sub LoadSupplierData()
        Dim ReqCOM as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        lblSuppCode.text = trim(reqCOM.GetFieldVal("Select Ven_Code from Vendor where Seq_No = " & request.params("ID") & ";","Ven_Code"))
        Dim strSql as string = "SELECT * FROM Vendor WHERE Ven_Code = '" & trim(lblSuppCode.text)  & "';"
        Dim State,Country,CurrencyCode,PayTerm, ShipTerm as string
        Dim ResExeDataReader as SQLDataReader = ReqCOM.ExeDataReader(strSql)
    
        do while ResExeDataReader.read
            lblSuppCode.text = ResExeDataReader("VEN_CODE").toString
            lblSuppName.text = ResExeDataReader("VEN_NAME").toString
            txtWebSite.text = ResExeDataReader("WEB_SITE").toString
            lblVenAdd1.text = ResExeDataReader("Add1").toString
            lblVenAdd2.text = ResExeDataReader("Add2").toString
            lblVenAdd3.text = ResExeDataReader("Add3").toString
            txtContactPerson.text = trim(ResExeDataReader("Contact_Person").toString)
            txtEmail1.text = trim(ResExeDataReader("Email1").toString)
            txtEmail2.text = trim(ResExeDataReader("Email2").toString)
            lblCurr_Code.text = ResExeDataReader("Curr_Code").toString
            txtTel1.text = trim(ResExeDataReader("Tel1").toString)
            txtFax1.text = trim(ResExeDataReader("Fax1").toString)
            lblSparePctg.text = ResExeDataReader("Spare_Pctg").toString
            lblCreateBy.text = ResExeDataReader("Create_By").toString
            lblPayTerm.text = ResExeDataReader("Pay_Term").toString
            lblShipTerm.text = ResExeDataReader("Ship_Term").toString
            lblVenCountry.text = ResExeDataReader("Ven_Country").toString
            txtEmailPO.text = ResExeDataReader("Email_PO").tostring
            txtEmailSSER.text = ResExeDataReader("Email_SSER").tostring
            if isdbnull(ResExeDataReader("Create_Date")) = false then lblCreateDate.text = format(cdate(ResExeDataReader("Create_Date").toString),"dd/MMM/yy")
            lblModifyBy.text = ResExeDataReader("Modify_By").toString
            if isdbnull(ResExeDataReader("Modify_Date")) = false then lblModifyDate.text = format(cdate(ResExeDataReader("Modify_Date").toString),"dd/MMM/yy")
        loop
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("SupplierB.aspx")
    End Sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update Vendor set modify_by = '" & trim(request.cookies("U_ID").value) & "', Modify_Date = '" & now & "',Contact_Person = '" & trim(txtContactPerson.text) & "',Email1 = '" & trim(txtEmail1.text) & "',Email2 = '" & trim(txtEmail2.text) & "',Tel1 = '" & trim(txtTel1.text) & "',Fax1 = '" & trim(txtFax1.text) & "',Web_Site = '" & trim(txtWebsite.text) & "', Email_PO = '" & trim(txtEmailPO.text) & "',Email_SSER = '" & trim(txtEmailSSER.text) & "' where Seq_No = " & request.params("ID") & ";")
        ShowAlert("Supplier Details Updated.")
        redirectPage("SupplierBDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" backcolor="" forecolor="" cssclass="FormDesc">SUPPLIER
                                DETAILS</asp:Label>
                            </p>
                            <p>
                                <table height="0px" cellspacing="0" cellpadding="0" width="80%" align="center" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" width="110px" cssclass="LabelNormal">Supplier
                                                                    Code</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="left"><asp:Label id="lblSuppCode" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" width="110px" cssclass="LabelNormal">Supplier
                                                                    Name</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                                <td colspan="3">
                                                                    <div align="left"><asp:Label id="lblSuppName" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="3">
                                                                    <asp:Label id="Label8" runat="server" width="110px" cssclass="LabelNormal">Address</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:Label id="lblVenAdd1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <asp:Label id="lblVenAdd2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <asp:Label id="lblVenAdd3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" width="110px" cssclass="LabelNormal">Country</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblVenCountry" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" width="110px" cssclass="LabelNormal">Currency
                                                                    Code</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblCurr_Code" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label24" runat="server" width="110px" cssclass="LabelNormal">Payment
                                                                    Term</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:Label id="lblPayTerm" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label25" runat="server" width="110px" cssclass="LabelNormal">Shipping
                                                                    Term</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:Label id="lblShipTerm" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label29" runat="server" width="126px" cssclass="LabelNormal">Spare
                                                                    Percentage</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:Label id="lblSparePctg" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label42" runat="server" width="126px" cssclass="LabelNormal">Contact
                                                                    Person</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtContactPerson" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label43" runat="server" width="126px" cssclass="LabelNormal">Email
                                                                    1</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtEmail1" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label44" runat="server" width="126px" cssclass="LabelNormal">Email
                                                                    2</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtEMail2" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="110px" cssclass="LabelNormal">Tel</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtTel1" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="110px" cssclass="LabelNormal">Fax</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtFax1" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" width="110px" cssclass="LabelNormal">Web Site</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtWebSite" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" width="110px" cssclass="LabelNormal">Email (P/O)</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtEmailPO" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" width="110px" cssclass="LabelNormal">Email
                                                                    (SSER)</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtEmailSSER" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="26%" bgcolor="silver">
                                                                    <asp:Label id="Label26" runat="server" width="162px" cssclass="LabelNormal">Created
                                                                    By / Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="lblCreateDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label27" runat="server" width="161px" cssclass="LabelNormal">Modified
                                                                    By / Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblModifyBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="lblModifyDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Update Supplier Details"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="143px" Text="Back"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
