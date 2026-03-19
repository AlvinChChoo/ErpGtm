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

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect ("SIApp1.aspx")
    End Sub
    
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then
            LoadData
            ProcLoadGridData
        End if
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            UpdateDetails
            ShowAlert("Records Updated.")
            redirectPage("SupplierSurveyFormDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub UpdateDetails
    
    End sub
    
    sub LoadData
        Dim Payment_Term,Del_Mode,Ship_Term,Curr as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rsSupplier as SqldataReader = ReqCOM.ExeDataReader("Select Top 1 * from Vendor_Info where Seq_No = " & request.params("ID") & ";")
    
        do while rsSupplier.read
                lblRefNo.text = rsSupplier("Ref_No").TOSTRING
                lblCompanyName.text = rsSupplier("Company_Name").TOSTRING
                lblAdd1.text = rsSupplier("Add1").TOSTRING
                lblAdd2.text = rsSupplier("Add2").TOSTRING
                lblAdd3.text = rsSupplier("Add3").TOSTRING
                lblTel.text = rsSupplier("TEL1").TOSTRING
                lblFax.text = rsSupplier("FAX1").TOSTRING
                lblEMail.text = rsSupplier("EMAIL").TOSTRING
                lblEMailPO.text = rsSupplier("EMAIL_PO").TOSTRING
                lblEMailSSER.text = rsSupplier("EMAIL_SSER").TOSTRING
                lblRegNo.text = rsSupplier("REG_NO").TOSTRING
    
    
                lblMainShareholder.text = rsSupplier("MAIN_SHAREHOLDER").TOSTRING
                lblSales.text = rsSupplier("SALES").TOSTRING
                lblTotalEmp.text = rsSupplier("TOTAL_EMP").TOSTRING
    
    
    
                IF trim(rsSupplier("TYPE_OF_OWNERSHIP")) = "Manufacturer" then lblTypeOfOwner.text = "Manufacturer"
                IF trim(rsSupplier("TYPE_OF_OWNERSHIP")) = "DISTRIBUTOR" then lblTypeOfOwner.text = "Distributor or Agent"
    
    
    
                lblAuthorisedCap.text = rsSupplier("AUTHORISED_CAP").TOSTRING
                lblPaidUpcap.text = rsSupplier("PAID_UP_CAP").TOSTRING
                lblSparePctg.text = rsSupplier("SPARE_PCTG").TOSTRING
    
                if trim(rsSupplier("PLACE_OF_DEPARTURE")) = "L" then lblPlaceOfDeparture.text = "Local"
                if trim(rsSupplier("PLACE_OF_DEPARTURE")) = "F" then lblPlaceOfDeparture.text = "Foreign"
                if trim(rsSupplier("PLACE_OF_DEPARTURE")) = "S" then lblPlaceOfDeparture.text = "Singapore"
    
    
    
                lblFormationYear.text = rsSupplier("FORMATION_YEAR").TOSTRING
                lblTypeOfBiz1.text = rsSupplier("TYPE_OF_BIZ1").TOSTRING
                lblTypeOfBiz2.text = rsSupplier("TYPE_OF_BIZ2").TOSTRING
                lblTypeOfBiz3.text = rsSupplier("TYPE_OF_BIZ3").TOSTRING
                lblTurnOver1.text = rsSupplier("TURN_OVER1").TOSTRING
                lblTurnOver2.text = rsSupplier("TURN_OVER2").TOSTRING
                lblTurnOver3.text = rsSupplier("TURN_OVER3").TOSTRING
                lblAnnualTurnover.text = rsSupplier("ANNUAL_TURNOVER").tostring
                lblMajorCust1.text = rsSupplier("MAJOR_CUST1").TOSTRING
                lblAnnualSales1.text = rsSupplier("ANNUAL_SALES1").TOSTRING
                lblPctgOfTotal1.text = rsSupplier("PCTG_OF_TOTAL1").TOSTRING
                lblMajorCust2.text = rsSupplier("MAJOR_CUST2").TOSTRING
                lblAnnualSales2.text = rsSupplier("ANNUAL_SALES2").TOSTRING
                lblPctgOfTotal2.text = rsSupplier("PCTG_OF_TOTAL2").TOSTRING
                lblMajorCust3.text = rsSupplier("MAJOR_CUST3").TOSTRING
                lblAnnualSales3.text = rsSupplier("ANNUAL_SALES3").TOSTRING
                lblPctgOfTotal3.text = rsSupplier("PCTG_OF_TOTAL3").TOSTRING
                lblMajorCust4.text = rsSupplier("MAJOR_CUST4").TOSTRING
                lblAnnualSales4.text = rsSupplier("ANNUAL_SALES4").TOSTRING
                lblPctgOfTotal4.text = rsSupplier("PCTG_OF_TOTAL4").TOSTRING
                lblMajorCust5.text = rsSupplier("MAJOR_CUST5").TOSTRING
                lblAnnualSales5.text = rsSupplier("ANNUAL_SALES5").TOSTRING
                lblPctgOfTotal5.text = rsSupplier("PCTG_OF_TOTAL5").TOSTRING
                lblProductType1.text = rsSupplier("PRODUCT_TYPE1").TOSTRING
                lblProductType2.text = rsSupplier("PRODUCT_TYPE2").TOSTRING
                lblProductType3.text = rsSupplier("PRODUCT_TYPE3").TOSTRING
                lblProductionCapacity1.text = rsSupplier("PRODUCTION_CAPACITY1").TOSTRING
                lblProductionCapacity2.text = rsSupplier("PRODUCTION_CAPACITY2").TOSTRING
                lblProductionCapacity3.text = rsSupplier("PRODUCTION_CAPACITY3").TOSTRING
                lblPayTerm.text = rsSupplier("PAYMENT_TERM").tostring
                lblDelMode.text = rsSupplier("DELIVERY_MODE").tostring
                lblShipTerm.text = rsSupplier("SHIPPING_TERM").tostring
                lblCurr.text = rsSupplier("CURRENCY").tostring
                lblBankername.text = rsSupplier("BANKER_NAME").TOSTRING
                lblBankerAdd1.text = rsSupplier("BANKER_ADD1").TOSTRING
                lblBankerAdd2.text = rsSupplier("BANKER_ADD2").TOSTRING
                lblBankerAdd3.text = rsSupplier("BANKER_ADD3").TOSTRING
                lblBankerACNo.text = rsSupplier("BANKER_AC_NO").TOSTRING
                lblSubmitRem.text = rsSupplier("SUBMIT_REM").TOSTRING
                lblSubmitBy.text = rsSupplier("Submit_by").TOSTRING
                lblSubmitDate.text = format(cdate(rsSupplier("submit_date").TOSTRING),"dd/MMM/yy")
    
                if isdbnull(rsSupplier("App1_date")) = false then
                    cmdApprove.enabled =false
                    cmdReject.enabled =false
                else
                    cmdApprove.enabled =true
                    cmdReject.enabled =true
                end if
            loop
            rsSupplier.close
    End sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Delete From Vendor_Info where Seq_No = " & request.params("ID") & ";")
        ShowAlert("Supplier Information Deleted.")
        redirectPage("SupplierSurveyForm.aspx")
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
    
         Sub ProcLoadGridData()
             Dim StrSql as string = "Select * from vendor_info_att where Ref_No = '" & trim(lblRefNo.text) & "';"
             Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
             Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"vendor_info_att")
             dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("vendor_info_att").DefaultView
             dtgUPASAttachment.DataBind()
         end sub
    
    Sub lnkAttachment_Click(sender As Object, e As EventArgs)
        ShowPopup("PopupSupplierInfoAtt.aspx?ID=" & Request.params("ID"))
    End Sub
    
         Sub ShowPopup(ReturnURL as string)
                Dim Script As New System.Text.StringBuilder
                Script.Append("<script language=javascript>")
                Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
                Script.Append("</script" & ">")
                RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
            End sub
    
    Sub cmdRefreshAtt_Click(sender As Object, e As EventArgs)
    ProcLoadGridData
    End Sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdApprove_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOm.ExecuteNonQuery("Update Vendor_Info set APP1_By = '" & trim(request.cookies("U_ID").value) & "',App1_Date = '" & now & "',APP1_Status = 'Y',App1_Rem = '" & trim(txtApp1Rem.text) & "' where Seq_No = " & Request.params("ID") & ";")
    
        ShowAlert ("Supplier Information Approved.")
        redirectPage("SIApp1Det.aspx?ID=" & Request.params("ID"))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UCcontent" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label63" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">SUPPLIER
                                INFORMATION</asp:Label>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" CssClass="Outputtext" ErrorMessage="You don't seem to have supplied a valid Remarks." ForeColor=" " Display="Dynamic" ControlToValidate="txtApp1Rem" EnableClientScript="False"></asp:RequiredFieldValidator>
                            </p>
                            <p>
                                <table style="HEIGHT: 11px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False" HeaderStyle-CssClass="CartListHead" ItemStyle-CssClass="CartListItem" AlternatingItemStyle-CssClass="CartListItemAlt" PageSize="50" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged">
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                                            <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadVendorAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td colspan="4">
                                                <div align="center"><asp:Label id="Label19" runat="server" width="100%" cssclass="FormDesc">COMPANY
                                                    PROFILE</asp:Label><asp:Label id="lblRefNo" runat="server" cssclass="LabelNormal" visible="False">Sales</asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" bgcolor="silver">
                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Company Name</asp:Label></td>
                                            <td width="30%">
                                                <asp:Label id="lblCompanyName" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td width="50%" bgcolor="silver" colspan="2">
                                                <asp:Label id="Label10" runat="server" cssclass="LabelNormal">Person In-Charge : -</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Address</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblAdd1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td width="20%" bgcolor="silver">
                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Main Shareholder</asp:Label></td>
                                            <td width="30%">
                                                <asp:Label id="lblMainShareholder" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="lblAdd2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Sales</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblSales" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="lblAdd3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label16" runat="server" cssclass="LabelNormal">Total Employees</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblTotalEmp" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Tel No</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblTel" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label18" runat="server" cssclass="LabelNormal">Type of Ownership</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblTypeOfOwner" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Fax No</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblFax" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Authorised Capital</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblAuthorisedCap" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">E-Mail </asp:Label></td>
                                            <td>
                                                <asp:Label id="lblEMail" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Paid-up Capital</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblPaidUpCap" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">E-Mail(for P/O) </asp:Label></td>
                                            <td>
                                                <asp:Label id="lblEMailPO" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Spare %</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblSparePctg" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label13" runat="server" cssclass="LabelNormal">E-Mail(for part Approval)</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblEMailSSER" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label15" runat="server" cssclass="LabelNormal">Place of Departure</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblPlaceOfDeparture" runat="server" width="100%" cssclass="lblPlaceOfDeparture"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label33" runat="server" cssclass="LabelNormal">Registration No</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblRegNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label34" runat="server" cssclass="LabelNormal">Formation Year</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblFormationYear" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td colspan="5">
                                                <div align="center"><asp:Label id="Label20" runat="server" width="100%" cssclass="FormDesc">BUSINESS
                                                    CONDITION</asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label21" runat="server" cssclass="LabelNormal">Type of Business</asp:Label></td>
                                            <td width="30%">
                                                <asp:Label id="lblTypeOfBiz1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td width="50%" bgcolor="silver" colspan="3">
                                                <asp:Label id="Label22" runat="server" cssclass="LabelNormal">Major Customers :</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="lblTypeOfBiz2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label24" runat="server" cssclass="LabelNormal">Company Name</asp:Label></td>
                                            <td width="13%" bgcolor="silver">
                                                <asp:Label id="Label25" runat="server" cssclass="LabelNormal">Annual Sales</asp:Label></td>
                                            <td width="12%" bgcolor="silver">
                                                <asp:Label id="Label26" runat="server" cssclass="LabelNormal">% of total</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="lblTypeOfBiz3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblMajorCust1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblAnnualSales1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblPctgOfTotal1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label27" runat="server" cssclass="LabelNormal">Last 3 month Turn Over</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblTurnOver1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblMajorCust2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblAnnualSales2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblPctgOfTotal2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="lblTurnOver2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblMajorCust3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblAnnualSales3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblPctgOfTotal3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="lblTurnOver3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblMajorCust4" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblAnnualSales4" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblPctgOfTotal4" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label31" runat="server" cssclass="LabelNormal">Annual Turnover </asp:Label></td>
                                            <td>
                                                <asp:Label id="lblAnnualTurnover" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblMajorCust5" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblAnnualSales5" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblPctgOfTotal5" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td colspan="4">
                                                <div align="center"><asp:Label id="Label23" style="Z-INDEX: 107" runat="server" width="100%" cssclass="FormDesc">PRODUCTION
                                                    STRUCTURE (FOR MANUFACTURER ONLY)</asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label30" runat="server" cssclass="LabelNormal">Product Types</asp:Label></td>
                                            <td width="30%">
                                                <asp:Label id="lblProductType1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td width="20%" bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label32" runat="server" cssclass="LabelNormal">Monthly Production Capacity</asp:Label></td>
                                            <td width="30%">
                                                <asp:Label id="lblProductionCapacity1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="lblProductType2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblProductionCapacity2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label id="lblProductType3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblProductionCapacity3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="20%" bgcolor="silver">
                                                <asp:Label id="Label37" runat="server" cssclass="LabelNormal">Payment Term</asp:Label></td>
                                            <td width="30%">
                                                <asp:Label id="lblPayTerm" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td width="20%" bgcolor="silver" colspan="2">
                                                <asp:Label id="Label39" runat="server" cssclass="LabelNormal">Banker Details</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label41" runat="server" cssclass="LabelNormal">Delivery Mode</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblDelMode" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td width="20%" bgcolor="silver">
                                                <asp:Label id="Label40" runat="server" cssclass="LabelNormal">Name</asp:Label></td>
                                            <td width="30%">
                                                <asp:Label id="lblBankerName" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label43" runat="server" cssclass="LabelNormal">Shipping Terms</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblShipTerm" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label42" runat="server" cssclass="LabelNormal">Address</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblBankerAdd1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label29" runat="server" cssclass="LabelNormal">Currency</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblCurr" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblBankerAdd2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" rowspan="2">
                                            </td>
                                            <td>
                                                <asp:Label id="lblBankerAdd3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label28" runat="server" cssclass="LabelNormal">Account No</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblBankerACNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label35" runat="server" cssclass="LabelNormal">Prepared By</asp:Label></td>
                                            <td width="75%" bgcolor="silver">
                                                <asp:Label id="Label36" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="lblSubmitBy" runat="server" width="100%" cssclass="outputText"></asp:Label><asp:Label id="lblSubmitDate" runat="server" width="100%" cssclass="outputText"></asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:Label id="lblSubmitRem" runat="server" width="100%" cssclass="LabelNormal">Account
                                                No</asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label48" runat="server" cssclass="LabelNormal">HOD Approval</asp:Label></td>
                                            <td width="50%" bgcolor="silver">
                                                <asp:Label id="Label49" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label50" runat="server" cssclass="LabelNormal">Status</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="lblApp1By" runat="server" width="100%" cssclass="outputText"></asp:Label><asp:Label id="lblApp1Date" runat="server" width="100%" cssclass="outputText"></asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtApp1Rem" runat="server" Height="54px" MaxLength="400" Width="100%" CssClass="outputText"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:RadioButton id="rbApp1Approve" runat="server" Width="100%" CssClass="outputText" Text="Approved" GroupName="App1"></asp:RadioButton>
                                                <asp:RadioButton id="rbApp1Reject" runat="server" Width="100%" CssClass="outputText" Text="Rejected" GroupName="App1"></asp:RadioButton>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label53" runat="server" cssclass="LabelNormal">Accounts</asp:Label></td>
                                            <td width="50%" bgcolor="silver">
                                                <asp:Label id="Label54" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label55" runat="server" cssclass="LabelNormal">Status</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="lblApp2By" runat="server" width="100%" cssclass="outputText"></asp:Label><asp:Label id="lblApp2Date" runat="server" width="100%" cssclass="outputText"></asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtApp2Rem" runat="server" Enabled="False" Height="54px" MaxLength="400" Width="100%" CssClass="outputText"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:RadioButton id="RadioButton5" runat="server" Enabled="False" Width="100%" CssClass="outputText" Text="Approved" GroupName="App2"></asp:RadioButton>
                                                <asp:RadioButton id="RadioButton6" runat="server" Enabled="False" Width="100%" CssClass="outputText" Text="Rejected" GroupName="App2"></asp:RadioButton>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label58" runat="server" cssclass="LabelNormal">Final Approval</asp:Label></td>
                                            <td width="50%" bgcolor="silver">
                                                <asp:Label id="Label59" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label60" runat="server" cssclass="LabelNormal">Status</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="lblApp3By" runat="server" width="100%" cssclass="outputText"></asp:Label><asp:Label id="lblApp3Date" runat="server" width="100%" cssclass="outputText"></asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtApp3Rem" runat="server" Enabled="False" Height="54px" MaxLength="400" Width="100%" CssClass="outputText"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:RadioButton id="RadioButton7" runat="server" Enabled="False" Width="100%" CssClass="outputText" Text="Approved" GroupName="App3"></asp:RadioButton>
                                                <asp:RadioButton id="RadioButton8" runat="server" Enabled="False" Width="100%" CssClass="outputText" Text="Rejected" GroupName="App3"></asp:RadioButton>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td width="33%">
                                                <asp:Button id="cmdApprove" onclick="cmdApprove_Click" runat="server" Width="104px" Text="Approve" CausesValidation="False"></asp:Button>
                                            </td>
                                            <td width="33%">
                                                <div align="center">
                                                    <asp:Button id="cmdReject" runat="server" Width="111px" Text="Reject"></asp:Button>
                                                </div>
                                            </td>
                                            <td width="34%">
                                                <div align="right">
                                                    <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="133px" Text="Back" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
