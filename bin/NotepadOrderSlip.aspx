<%@ Page Language="VB" Debug="true" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.data" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsPostBack() Then
            if request.cookies("U_ID") is nothing then response.redirect(Configurationsettings.AppSettings("LoginDefSite"))
            LoadOrderDet
            LoadTitleDet
        End if
    End Sub
    
    Sub LoadTitleDet()
        Dim StrSql As String
        Dim strAddressStream, strContactStream As String
        Dim strAddress1, strAddress2, strTown, strPostalCode, strState, strCountry As String
        Dim strTel, strFax, strEmail As String
        Dim strHeaderID As String
    
        If Trim(lblFranchiseID.Text) = Trim(lblMemberId.Text) Then
            strHeaderID = "001000001"
        Else
            strHeaderID = lblFranchiseID.Text
        End If
    
        StrSql = "Select * from SharkMembersProfile where MembershipNo = '" & Trim(strHeaderID) & "';"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ReqCOm As ERP_GTM.ERP_GTM = New ERP_GTM.ERP_GTM
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        Do While result.Read
            lblTitleCompanyName.text = result("CompanyName")
    
            If IsDBNull(result("CompanyReg")) = False Then lblCompanyReg.Text = result("CompanyReg")
            If IsDBNull(result("CompanyTel")) = False Then strTel = result("CompanyTel")
            If IsDBNull(result("CompanyFax")) = False Then strFax = result("CompanyFax")
            If IsDBNull(result("EmailAdd")) = False Then strEmail = result("EmailAdd")
    
            strAddress1 = result("Address1")
            If IsDBNull(result("Address2")) = False Then strAddress2 = result("Address2")
            strPostalCode = result("PostalCode")
            strTown = result("Town")
            strState = result("State")
        Loop
    
        strAddressStream = strAddress1 & " " & strAddress2 & " " & strPostalCode & " " & strTown & ", " & strState & "."
        strContactStream = "Tel: " & strTel & "  Fax: " & strFax & "  Email: " & strEmail
        lblTitleAdd.Text = strAddressStream
        lblTitleContact.Text = strContactStream
    
        If Trim(strHeaderID) <> "001000001" Then
            lblTitleCompanyName.Text = "Dimiliki oleh " & lblTitleCompanyName.Text
        End If
        If lblCompanyReg.text <> "" Then
            lblCompanyReg.text = "(" & lblCompanyReg.text & ")"
        End If
    End Sub
    
    Sub PrintSlip(ByVal sender As Object, ByVal e As EventArgs)
        Dim strScript As String
        strScript = "<" & "script language=JavaScript>window.print(" & ")</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End Sub
    
    Sub LoadOrderDet()
        Dim StrSql As String
        StrSql = "Select * from SharkNotepadOrderDet where OrderNo = '" & Trim(Request.cookies("OrderNo").value) & "';"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        Do While result.Read
            lblProduct.Text = result("ProdType").ToString()
            lblMemberId.Text = result("MemberID").ToString()
            lblCompany.Text = result("CompanyName").ToString
            lblOrderDate.Text = format(cdate(result("OrderDate")),"dd/MM/yyyy")
            lblAddress1.Text = result("Address1").tostring()
            lblAddress2.Text = result("Address2").tostring()
            lblPostalCode.Text = result("PostalCode").tostring()
            lblTown.Text = result("Town").tostring()
            lblState.Text = result("State").tostring()
            lblCountry.Text = result("Country").ToString()
            lblFileName.Text = result("OrderFileName")
            lblProdSize.Text = result("ProdSize")
            lblMatType.Text = result("MatType")
            lblColorType.Text = result("ColorType")
            lblOrderQty.Text = result("OrderQty")
            lblFinishing.Text = result("Finishing")
            lblAmt.Text = format(cdec(result("OrderAmt")),"##,##0.00")
            lblOrderNo.Text = result("OrderNo")
            lblRushOrderCharges.text = format(cdec(result("RushOrderCharge")),"##,##0.00")
            lblNetAmt.Text = Format(CDec(result("TotalAmt")), "##,##0.00")
            lblDiscount.text = format(cdec(result("DiscAmt")),"##,##0.00")
            lblDeliveryDate.Text = Format(CDate(result("DeliveryDate")), "dd/MM/yyyy")
            If IsDBNull(result("FranchiseID")) = False Then lblFranchiseID.Text = result("FranchiseID")
        Loop
    End Sub

</script>
<html>
<head>
    <link href="css.css" type="text/css" rel="stylesheet" />
    <link href="inc/styles.css" type="text/css" rel="stylesheet" />
    <script language="JavaScript">
window.history.forward(1);
</script>
</head>
<body bottommargin="0" leftmargin="0" background="Background1.gif" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table width="100%">
                <tbody>
                </tbody>
            </table>
            <table width="846" align="center">
                <tbody>
                    <tr>
                        <td>
                            <table width="100%">
                                <tbody>
                                    <tr>
                                        <td style="WIDTH: 600px">
                                            <img height="81" src="images/logo/theShark.gif" width="220" border="0" />&nbsp;<br />
                                            <table width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblTitleCompanyName" runat="server" cssclass="f8_grey_b"></asp:Label>&nbsp;<asp:Label id="lblCompanyReg" runat="server" cssclass="f8_grey_b"></asp:Label> 
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblTitleAdd" runat="server" cssclass="f8_grey"></asp:Label>&nbsp;&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label id="lblTitleContact" runat="server" cssclass="f8_grey"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td align="middle">
                                            <label style="FONT-SIZE: 18pt; COLOR: gray; FONT-FAMILY: Verdana">ORDER SLIP</label> 
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <table cellspacing="0" cellpadding="0" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td style="WIDTH: 60%">
                                            <span class="f10_grey_i_2em"></span> 
                                            <table>
                                                <tbody>
                                                    <tr>
                                                        <td style="WIDTH: 10px">
                                                            <em><span style="FONT-SIZE: 10pt; COLOR: #666666; FONT-FAMILY: Arial"></span></em></td>
                                                        <td style="WIDTH: 150px">
                                                            <asp:Label id="lblheader2" runat="server" cssclass="f10_grey_i">Member ID</asp:Label></td>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 300px">
                                                            <asp:Label id="lblMemberId" runat="server" cssclass="f8_grey_b"></asp:Label><asp:Label id="lblFranchiseID" runat="server" cssclass="f10_grey_i" visible="false"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <br />
                                            <table width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td style="WIDTH: 10px">
                                                            <em><span style="FONT-SIZE: 10pt; COLOR: #666666; FONT-FAMILY: Arial"></span></em></td>
                                                        <td style="WIDTH: 150px">
                                                            <asp:Label id="Label15" runat="server" cssclass="f10_grey_i">Delivery Address</asp:Label></td>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 300px">
                                                            <asp:Label id="lblCompany" runat="server" cssclass="f8_grey_b">companyname</asp:Label></td>
                                                        <td style="WIDTH: 95px">
                                                        </td>
                                                        <td style="WIDTH: 95px">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 150px">
                                                        </td>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 300px">
                                                            <asp:Label id="lblAddress1" runat="server" cssclass="f8_grey">address1</asp:Label></td>
                                                        <td style="WIDTH: 95px">
                                                        </td>
                                                        <td style="WIDTH: 95px">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 150px">
                                                        </td>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 300px">
                                                            <asp:Label id="lblAddress2" runat="server" cssclass="f8_grey">address2</asp:Label></td>
                                                        <td style="WIDTH: 95px">
                                                        </td>
                                                        <td style="WIDTH: 95px">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 150px">
                                                        </td>
                                                        <td style="WIDTH: 10px">
                                                            &nbsp;</td>
                                                        <td style="WIDTH: 300px">
                                                            <asp:Label id="lblPostalCode" runat="server" cssclass="f8_grey">Poscode</asp:Label>&nbsp;<asp:Label id="lblTown" runat="server" cssclass="f8_grey">Town</asp:Label></td>
                                                        <td style="WIDTH: 95px">
                                                        </td>
                                                        <td style="WIDTH: 95px">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 150px">
                                                        </td>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 300px">
                                                            <asp:Label id="lblState" runat="server" cssclass="f8_grey">state</asp:Label></td>
                                                        <td style="WIDTH: 95px">
                                                            <asp:Label id="Label25" runat="server" cssclass="f10_grey_i">Order Date</asp:Label></td>
                                                        <td style="WIDTH: 95px">
                                                            <asp:Label id="lblOrderDate" runat="server" cssclass="f8_grey"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 150px">
                                                        </td>
                                                        <td style="WIDTH: 10px">
                                                        </td>
                                                        <td style="WIDTH: 300px">
                                                            <asp:Label id="lblCountry" runat="server" cssclass="f8_grey">country</asp:Label></td>
                                                        <td style="WIDTH: 95px">
                                                            <asp:Label id="Label20" runat="server" cssclass="f10_grey_i">Delivery Date</asp:Label></td>
                                                        <td style="WIDTH: 95px">
                                                            <asp:Label id="lblDeliveryDate" runat="server" cssclass="f8_grey"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            &nbsp; 
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <p>
                                <table bordercolor="#e0e0e0" cellspacing="0" cellpadding="0" width="100%" border="1">
                                    <tbody valign="top">
                                        <tr class="OrderFormAltItem">
                                            <td valign="center" align="middle" width="15%">
                                                <asp:Label id="Label33" runat="server" cssclass="f8_grey_b">Order No</asp:Label></td>
                                            <td valign="center" align="middle" width="70%">
                                                <asp:Label id="Label34" runat="server" cssclass="f8_grey_b">Item Specifications</asp:Label></td>
                                            <td valign="center" align="middle" width="15%">
                                                <asp:Label id="Label35" runat="server" cssclass="f8_grey_b">Amount (RM)</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td align="middle">
                                                <asp:Label id="lblOrderNo" runat="server" cssclass="LabelFont"></asp:Label></td>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 133px" bordercolor="#e0e0e0" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="200">
                                                                    <span>&nbsp;<asp:Label id="Label36" runat="server" cssclass="f10_grey_i">Product</asp:Label></span></td>
                                                                <td>
                                                                    <asp:Label id="lblProduct" runat="server" cssclass="f10_grey_i"></asp:Label>&nbsp; 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="200">
                                                                    &nbsp;</td>
                                                                <td>
                                                                    &nbsp; 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="HEIGHT: 20px">
                                                                    &nbsp;<asp:Label id="Label14" runat="server" cssclass="LabelFont">Cover Size(mm)</asp:Label></td>
                                                                <td style="HEIGHT: 20px">
                                                                    <asp:Label id="lblProdSize" runat="server" cssclass="LabelFont"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="HEIGHT: 20px">
                                                                    &nbsp;<asp:Label id="Label3" runat="server" cssclass="LabelFont">Paper Material</asp:Label></td>
                                                                <td style="HEIGHT: 20px">
                                                                    <asp:Label id="lblMatType" runat="server" cssclass="LabelFont"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="HEIGHT: 20px">
                                                                    &nbsp;<asp:Label id="Label7" runat="server" cssclass="LabelFont">Printing Colour</asp:Label></td>
                                                                <td style="HEIGHT: 20px">
                                                                    <asp:Label id="lblColorType" runat="server" cssclass="LabelFont"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="HEIGHT: 20px">
                                                                    &nbsp;<asp:Label id="Label8" runat="server" cssclass="LabelFont">Quantity</asp:Label></td>
                                                                <td style="HEIGHT: 20px">
                                                                    <asp:Label id="lblOrderQty" runat="server" cssclass="LabelFont"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="HEIGHT: 20px">
                                                                    &nbsp;<asp:Label id="Label9" runat="server" cssclass="LabelFont">Finishing</asp:Label></td>
                                                                <td style="HEIGHT: 20px">
                                                                    <asp:Label id="lblFinishing" runat="server" cssclass="LabelFont"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td style="HEIGHT: 20px">
                                                                    &nbsp;<asp:Label id="Label10" runat="server" cssclass="LabelFont">Design File Name</asp:Label></td>
                                                                <td style="HEIGHT: 20px">
                                                                    <asp:Label id="lblFileName" runat="server" cssclass="LabelFont"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                            </td>
                                            <td>
                                                <div align="right"><asp:Label id="lblAmt" runat="server" cssclass="LabelFont"></asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <table bordercolor="#e0e0e0" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td valign="top" align="right" width="15%">
                                                &nbsp;</td>
                                            <td valign="top" align="right" width="70%">
                                                <table width="250">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <div align="left"><asp:Label id="Label13" runat="server" cssclass="LabelFont">Handling
                                                                    Charges (RM)</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="left"><asp:Label id="Label16" runat="server" cssclass="LabelFont">Rush
                                                                    Order Charges (RM)</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="left"><asp:Label id="Label17" runat="server" cssclass="LabelFont">Discount
                                                                    (RM)</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div align="left"><asp:Label id="Label18" runat="server" cssclass="f8_grey_b">Total
                                                                    (RM)</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                            <td valign="top" align="right" width="15%">
                                                <table>
                                                    <tbody>
                                                        <tr>
                                                            <td style="WIDTH: 100px">
                                                                <div align="right"><asp:Label id="Label19" runat="server" cssclass="LabelFont" width="100%">0.00</asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="WIDTH: 100px">
                                                                <div align="right"><asp:Label id="lblRushOrderCharges" runat="server" cssclass="LabelFont" width="100%"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="WIDTH: 100px">
                                                                <div align="right"><asp:Label id="lblDiscount" runat="server" cssclass="LabelFont" width="100%"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="WIDTH: 100px">
                                                                <div align="right"><asp:Label id="lblNetAmt" runat="server" cssclass="f8_grey_b" width="100%"></asp:Label>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                &nbsp;</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table>
                                    <tbody>
                                        <tr>
                                            <td style="WIDTH: 399px">
                                                <asp:Label id="Label203" runat="server" cssclass="f8_grey_i">Note: This is a computer
                                                generated statement. No signature required.</asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <a href="javascript:window.print()">[Print Order Slip]</a> 
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
