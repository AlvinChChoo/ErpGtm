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
        response.redirect ("SupplierSurveyForm.aspx")
    End Sub

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then
            cmdRemove.attributes.add("onClick","javascript:if(confirm('Are you sure you want to remove this Supplier Information from the system ?')==false) return false;")

            dissql ("Select Shipterm_Desc from ShipTerm order by Shipterm_Desc asc","Shipterm_Desc","Shipterm_Desc",cmbShipTerm)
            dissql ("Select payterm_desc from payterm order by payterm_desc asc","payterm_desc","payterm_desc",cmbPayterm)
            dissql ("Select CURR_CODE,CURR_DESC from CURR order by CURR_DESC asc","CURR_CODE","CURR_DESC",cmbCurr)
            dissql ("Select delivery_mode from delivery_mode order by delivery_mode asc","delivery_mode","delivery_mode",cmbDelMode)
            LoadData
            ProcLoadGridData
        End if
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

    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            UpdateDetails
            ShowAlert("Records Updated.")
            redirectPage("SupplierSurveyFormDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub

    Sub UpdateDetails
        Dim StrSql as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM

        StrSql = "Update Vendor_Info "
        StrSql = StrSql + "Set COMPANY_NAME = '" & trim(txtCompanyName.text) & "',"
        StrSql = StrSql + "ADD1 = '" & trim(txtAdd1.text) & "',"
        StrSql = StrSql + "ADD2 = '" & trim(txtAdd2.text) & "',"
        StrSql = StrSql + "ADD3 = '" & trim(txtAdd3.text) & "',"
        StrSql = StrSql + "TEL1 = '" & trim(txtTel.text) & "',"
        StrSql = StrSql + "FAX1 = '" & trim(txtFax.text) & "',"
        StrSql = StrSql + "EMAIL = '" & trim(txtEMail.text) & "',"
        StrSql = StrSql + "EMAIL_PO = '" & trim(txtEMailPO.text) & "',"
        StrSql = StrSql + "EMAIL_SSER = '" & trim(txtEMailSSER.text) & "',"
        StrSql = StrSql + "REG_NO = '" & trim(txtRegNo.text) & "',"
        StrSql = StrSql + "MAIN_SHAREHOLDER = '" & trim(txtMainShareholder.text) & "',"
        StrSql = StrSql + "SALES = '" & trim(txtSales.text) & "',"
        StrSql = StrSql + "TOTAL_EMP = " & trim(txtTotalEmp.text) & ","
        StrSql = StrSql + "TYPE_OF_OWNERSHIP = '" & trim(cmbTypeOfOwner.selecteditem.value) & "',"

        if txtAuthorisedCap.text = "" then StrSql = StrSql + "AUTHORISED_CAP = null,"
        if txtAuthorisedCap.text <> "" then StrSql = StrSql + "AUTHORISED_CAP = " & trim(txtAuthorisedCap.text) & ","

        if txtPaidUpcap.text = "" then StrSql = StrSql + "PAID_UP_CAP = null,"
        if txtPaidUpcap.text <> "" then StrSql = StrSql + "PAID_UP_CAP = " & trim(txtPaidUpcap.text) & ","


        StrSql = StrSql + "SPARE_PCTG = " & trim(txtSparePctg.text) & ","
        StrSql = StrSql + "PLACE_OF_DEPARTURE = '" & trim(cmbPlaceOfDeparture.selecteditem.value) & "',"
        StrSql = StrSql + "FORMATION_YEAR = " & trim(txtFormationYear.text) & ","
        StrSql = StrSql + "TYPE_OF_BIZ1 = '" & trim(txtTypeOfBiz1.text) & "',"
        StrSql = StrSql + "TYPE_OF_BIZ2 = '" & trim(txtTypeOfBiz2.text) & "',"
        StrSql = StrSql + "TYPE_OF_BIZ3 = '" & trim(txtTypeOfBiz3.text) & "',"

        if txtTurnOver1.text = "" then strsql = StrSql + "TURN_OVER1 = null,"
        if txtTurnOver1.text <> "" then strsql = StrSql + "TURN_OVER1 = " & trim(txtTurnOver1.text) & ","

        if txtTurnOver2.text = "" then strsql = StrSql + "TURN_OVER2 = null,"
        if txtTurnOver2.text <> "" then strsql = StrSql + "TURN_OVER2 = " & trim(txtTurnOver2.text) & ","

        if txtTurnOver3.text = "" then strsql = StrSql + "TURN_OVER3 = null,"
        if txtTurnOver3.text <> "" then strsql = StrSql + "TURN_OVER3 = " & trim(txtTurnOver3.text) & ","

        if txtAnnualTurnover.text = "" then StrSql = StrSql + "ANNUAL_TURNOVER = null,"
        if txtAnnualTurnover.text <> "" then StrSql = StrSql + "ANNUAL_TURNOVER = " & trim(txtAnnualTurnover.text) & ","

        StrSql = StrSql + "MAJOR_CUST1 = '" & trim(txtMajorCust1.text) & "',"

        if txtAnnualSales1.text = "" then StrSql = StrSql + "ANNUAL_SALES1 = null,"
        if txtAnnualSales1.text <> "" then StrSql = StrSql + "ANNUAL_SALES1 = " & trim(txtAnnualSales1.text) & ","

        if txtPctgOfTotal1.text = "" then StrSql = StrSql + "PCTG_OF_TOTAL1 = null,"
        if txtPctgOfTotal1.text <> "" then StrSql = StrSql + "PCTG_OF_TOTAL1 = " & trim(txtPctgOfTotal1.text) & ","

        StrSql = StrSql + "MAJOR_CUST2 = '" & trim(txtMajorCust2.text) & "',"

        if txtAnnualSales2.text = "" then StrSql = StrSql + "ANNUAL_SALES2 = null,"
        if txtAnnualSales2.text <> "" then StrSql = StrSql + "ANNUAL_SALES2 = " & trim(txtAnnualSales2.text) & ","

        if txtPctgOfTotal2.text = "" then StrSql = StrSql + "PCTG_OF_TOTAL2 = null,"
        if txtPctgOfTotal2.text <> "" then StrSql = StrSql + "PCTG_OF_TOTAL2 = " & trim(txtPctgOfTotal2.text) & ","

        StrSql = StrSql + "MAJOR_CUST3 = '" & trim(txtMajorCust3.text) & "',"

        if txtAnnualSales3.text = "" then StrSql = StrSql + "ANNUAL_SALES3 = null,"
        if txtAnnualSales3.text <> "" then StrSql = StrSql + "ANNUAL_SALES3 = " & trim(txtAnnualSales3.text) & ","

        if txtPctgOfTotal3.text = "" then StrSql = StrSql + "PCTG_OF_TOTAL3 = null,"
        if txtPctgOfTotal3.text <> "" then StrSql = StrSql + "PCTG_OF_TOTAL3 = " & trim(txtPctgOfTotal3.text) & ","

        StrSql = StrSql + "MAJOR_CUST4 = '" & trim(txtMajorCust4.text) & "',"

        if txtAnnualSales4.text = "" then StrSql = StrSql + "ANNUAL_SALES4 = null,"
        if txtAnnualSales4.text <> "" then StrSql = StrSql + "ANNUAL_SALES4 = " & trim(txtAnnualSales4.text) & ","

        if txtPctgOfTotal4.text = "" then StrSql = StrSql + "PCTG_OF_TOTAL4 = null,"
        if txtPctgOfTotal4.text <> "" then StrSql = StrSql + "PCTG_OF_TOTAL4 = " & trim(txtPctgOfTotal4.text) & ","

        StrSql = StrSql + "MAJOR_CUST5 = '" & trim(txtMajorCust5.text) & "',"

        if txtAnnualSales5.text = "" then StrSql = StrSql + "ANNUAL_SALES5 = null,"
        if txtAnnualSales5.text <> "" then StrSql = StrSql + "ANNUAL_SALES5 = " & trim(txtAnnualSales5.text) & ","

        if txtPctgOfTotal5.text = "" then StrSql = StrSql + "PCTG_OF_TOTAL5 = null,"
        if txtPctgOfTotal5.text <> "" then StrSql = StrSql + "PCTG_OF_TOTAL5 = " & trim(txtPctgOfTotal5.text) & ","

        StrSql = StrSql + "PRODUCT_TYPE1 = '" & trim(txtProductType1.text) & "',"
        StrSql = StrSql + "PRODUCT_TYPE2 = '" & trim(txtProductType2.text) & "',"
        StrSql = StrSql + "PRODUCT_TYPE3 = '" & trim(txtProductType3.text) & "',"

        if txtProductionCapacity1.text = "" then StrSql = StrSql + "PRODUCTION_CAPACITY1 = null,"
        if txtProductionCapacity1.text <> "" then StrSql = StrSql + "PRODUCTION_CAPACITY1 = " & txtProductionCapacity1.text & ","

        if txtProductionCapacity2.text = "" then StrSql = StrSql + "PRODUCTION_CAPACITY2 = null,"
        if txtProductionCapacity2.text <> "" then StrSql = StrSql + "PRODUCTION_CAPACITY2 = " & txtProductionCapacity2.text & ","

        if txtProductionCapacity3.text = "" then StrSql = StrSql + "PRODUCTION_CAPACITY3 = null,"
        if txtProductionCapacity3.text <> "" then StrSql = StrSql + "PRODUCTION_CAPACITY3 = " & txtProductionCapacity3.text & ","


        StrSql = StrSql + "PAYMENT_TERM = '" & trim(cmbPayTerm.selecteditem.value) & "',"
        StrSql = StrSql + "DELIVERY_MODE = '" & trim(cmbDelMode.selecteditem.value) & "',"
        StrSql = StrSql + "SHIPPING_TERM = '" & trim(cmbShipTerm.selecteditem.value) & "',"
        StrSql = StrSql + "CURRENCY = '" & trim(cmbCurr.selecteditem.value) & "',"
        StrSql = StrSql + "BANKER_NAME = '" & trim(txtBankername.text) & "',"
        StrSql = StrSql + "BANKER_ADD1 = '" & trim(txtBankerAdd1.text) & "',"
        StrSql = StrSql + "BANKER_ADD2 = '" & trim(txtBankerAdd2.text) & "',"
        StrSql = StrSql + "BANKER_ADD3 = '" & trim(txtBankerAdd3.text) & "',"
        StrSql = StrSql + "BANKER_AC_NO = '" & trim(txtBankerACNo.text) & "',"
        StrSql = StrSql + "SUBMIT_REM = '" & trim(txtSubmitRem.text) & "'"
        StrSql = StrSql + " where seq_no = " & request.params("ID") & ";"
        Reqcom.executenonquery(strsql)
    End sub

    sub LoadData
        Dim Payment_Term,Del_Mode,Ship_Term,Curr as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rsSupplier as SqldataReader = ReqCOM.ExeDataReader("Select Top 1 * from Vendor_Info where Seq_No = " & request.params("ID") & ";")

        do while rsSupplier.read
                lblRefNo.text = rsSupplier("Ref_No").TOSTRING
                txtCompanyName.text = rsSupplier("Company_Name").TOSTRING
                txtAdd1.text = rsSupplier("Add1").TOSTRING
                txtAdd2.text = rsSupplier("Add2").TOSTRING
                txtAdd3.text = rsSupplier("Add3").TOSTRING
                txtTel.text = rsSupplier("TEL1").TOSTRING
                txtFax.text = rsSupplier("FAX1").TOSTRING
                txtEMail.text = rsSupplier("EMAIL").TOSTRING
                txtEMailPO.text = rsSupplier("EMAIL_PO").TOSTRING
                txtEMailSSER.text = rsSupplier("EMAIL_SSER").TOSTRING
                txtRegNo.text = rsSupplier("REG_NO").TOSTRING


                txtMainShareholder.text = rsSupplier("MAIN_SHAREHOLDER").TOSTRING
                txtSales.text = rsSupplier("SALES").TOSTRING
                txtTotalEmp.text = rsSupplier("TOTAL_EMP").TOSTRING

                if isdbnull(rsSupplier("TYPE_OF_OWNERSHIP")) = false then
                    if rsSupplier("TYPE_OF_OWNERSHIP") = "Manufacturer" then cmbTypeOfOwner.items.FindByValue("Manufacturer").SELECTED = TRUE
                    if rsSupplier("TYPE_OF_OWNERSHIP") = "DISTRIBUTOR" then cmbTypeOfOwner.items.FindByValue("DISTRIBUTOR").SELECTED = TRUE
                end if

                txtAuthorisedCap.text = rsSupplier("AUTHORISED_CAP").TOSTRING
                txtPaidUpcap.text = rsSupplier("PAID_UP_CAP").TOSTRING
                txtSparePctg.text = rsSupplier("SPARE_PCTG").TOSTRING

                if isdbnull(rsSupplier("PLACE_OF_DEPARTURE")) = false then
                    if rsSupplier("PLACE_OF_DEPARTURE") = "L" then cmbPlaceOfDeparture.items.FindByValue("L").SELECTED = TRUE
                    if rsSupplier("PLACE_OF_DEPARTURE") = "F" then cmbPlaceOfDeparture.items.FindByValue("F").SELECTED = TRUE
                    if rsSupplier("PLACE_OF_DEPARTURE") = "S" then cmbPlaceOfDeparture.items.FindByValue("S").SELECTED = TRUE
                end if

                txtFormationYear.text = rsSupplier("FORMATION_YEAR").TOSTRING
                txtTypeOfBiz1.text = rsSupplier("TYPE_OF_BIZ1").TOSTRING
                txtTypeOfBiz2.text = rsSupplier("TYPE_OF_BIZ2").TOSTRING
                txtTypeOfBiz3.text = rsSupplier("TYPE_OF_BIZ3").TOSTRING
                txtTurnOver1.text = rsSupplier("TURN_OVER1").TOSTRING
                txtTurnOver2.text = rsSupplier("TURN_OVER2").TOSTRING
                txtTurnOver3.text = rsSupplier("TURN_OVER3").TOSTRING
                txtAnnualTurnover.text = rsSupplier("ANNUAL_TURNOVER").tostring
                txtMajorCust1.text = rsSupplier("MAJOR_CUST1").TOSTRING
                txtAnnualSales1.text = rsSupplier("ANNUAL_SALES1").TOSTRING
                txtPctgOfTotal1.text = rsSupplier("PCTG_OF_TOTAL1").TOSTRING

                txtMajorCust2.text = rsSupplier("MAJOR_CUST2").TOSTRING
                txtAnnualSales2.text = rsSupplier("ANNUAL_SALES2").TOSTRING
                txtPctgOfTotal2.text = rsSupplier("PCTG_OF_TOTAL2").TOSTRING
                txtMajorCust3.text = rsSupplier("MAJOR_CUST3").TOSTRING
                txtAnnualSales3.text = rsSupplier("ANNUAL_SALES3").TOSTRING
                txtPctgOfTotal3.text = rsSupplier("PCTG_OF_TOTAL3").TOSTRING
                txtMajorCust4.text = rsSupplier("MAJOR_CUST4").TOSTRING
                txtAnnualSales4.text = rsSupplier("ANNUAL_SALES4").TOSTRING

                txtPctgOfTotal4.text = rsSupplier("PCTG_OF_TOTAL4").TOSTRING
                txtMajorCust5.text = rsSupplier("MAJOR_CUST5").TOSTRING
                txtAnnualSales5.text = rsSupplier("ANNUAL_SALES5").TOSTRING
                txtPctgOfTotal5.text = rsSupplier("PCTG_OF_TOTAL5").TOSTRING
                txtProductType1.text = rsSupplier("PRODUCT_TYPE1").TOSTRING
                txtProductType2.text = rsSupplier("PRODUCT_TYPE2").TOSTRING
                txtProductType3.text = rsSupplier("PRODUCT_TYPE3").TOSTRING


                txtProductionCapacity1.text = rsSupplier("PRODUCTION_CAPACITY1").TOSTRING
                txtProductionCapacity2.text = rsSupplier("PRODUCTION_CAPACITY2").TOSTRING
                txtProductionCapacity3.text = rsSupplier("PRODUCTION_CAPACITY3").TOSTRING

                if isdbnull(rsSupplier("PAYMENT_TERM")) = false then
                    Payment_Term = ReqCOM.GetFieldVal("Select Payterm_Desc from Payterm where Payterm_Desc = '" & trim(rsSupplier("PAYMENT_TERM")) & "';","Payterm_Desc")
                    cmbPayTerm.items.FindByText(Payment_Term).SELECTED = TRUE
                end if

                if isdbnull(rsSupplier("DELIVERY_MODE")) = false then
                    Del_Mode = ReqCOM.GetFieldVal("Select delivery_mode from delivery_mode where delivery_mode = '" & trim(rsSupplier("DELIVERY_MODE")) & "';","DELIVERY_MODE")
                    cmbDelMode.items.FindByText(Del_Mode).SELECTED = TRUE
                end if

                if isdbnull(rsSupplier("SHIPPING_TERM")) = false then
                    Ship_Term = ReqCOM.GetFieldVal("Select SHIPTERM_DESC from shipterm where SHIPTERM_DESC = '" & trim(rsSupplier("SHIPPING_TERM")) & "';","SHIPTERM_DESC")
                    cmbShipTerm.items.FindByText(Ship_Term).SELECTED = TRUE
                end if

                if isdbnull(rsSupplier("CURRENCY")) = false then
                    Curr = ReqCOM.GetFieldVal("Select CURR_CODE from curr where CURR_CODE = '" & trim(rsSupplier("CURRENCY")) & "';","CURR_CODE")
                    cmbCurr.items.FindByValue(Curr).SELECTED = TRUE
                end if

                txtBankername.text = rsSupplier("BANKER_NAME").TOSTRING
                txtBankerAdd1.text = rsSupplier("BANKER_ADD1").TOSTRING
                txtBankerAdd2.text = rsSupplier("BANKER_ADD2").TOSTRING
                txtBankerAdd3.text = rsSupplier("BANKER_ADD3").TOSTRING
                txtBankerACNo.text = rsSupplier("BANKER_AC_NO").TOSTRING
                txtSubmitRem.text = rsSupplier("SUBMIT_REM").TOSTRING

                lblSubmitBy.text = rsSupplier("Submit_by").TOSTRING
                if isdbnull(rsSupplier("submit_date")) = false then lblSubmitDate.text = format(cdate(rsSupplier("submit_date").TOSTRING),"dd/MMM/yy")


                lblApp1Rem.text = rsSupplier("App1_Rem").tostring
                lblApp2Rem.text = rsSupplier("App2_Rem").tostring
                lblApp3Rem.text = rsSupplier("App3_Rem").tostring

                lblApp1Status.text = rsSupplier("App1_Status").tostring
                lblApp2Status.text = rsSupplier("App2_Status").tostring
                lblApp3Status.text = rsSupplier("App3_Status").tostring

                lblApp1By.text = rsSupplier("App1_By").tostring
                lblApp2By.text = rsSupplier("App2_By").tostring
                lblApp3By.text = rsSupplier("App3_By").tostring

                if isdbnull(rsSupplier("App1_Date")) = false then lblApp1Date.text = format(cdate(rsSupplier("App1_Date")),"dd/MMM/yyyy")
                if isdbnull(rsSupplier("App2_Date")) = false then lblApp2Date.text = format(cdate(rsSupplier("App2_Date")),"dd/MMM/yyyy")
                if isdbnull(rsSupplier("App3_Date")) = false then lblApp3Date.text = format(cdate(rsSupplier("App3_Date")),"dd/MMM/yyyy")


                if isdbnull(rsSupplier("submit_date")) = false then
                    cmdUpdate.enabled = false
                    cmdUpdateSubmit.enabled = false
                    cmdRemove.enabled = false
                    cmdResubmit.enabled = false
                    cmdIgnore.enabled =false

                else
                    cmdUpdate.enabled = true
                    cmdUpdateSubmit.enabled = true
                    cmdRemove.enabled = true
                    cmdResubmit.enabled = true
                    cmdIgnore.enabled = true
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

    Sub cmdUpdateSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            UpdateDetails

            ReqCOM.ExecuteNonQUery("Update Vendor_Info set Submit_Date = '" & now & "',SI_STATUS = 'PENDING APPROVAL' where Seq_No = " & request.params("ID") & ";")
            ShowAlert("Supplier Information Submitted.")
            redirectPage("SupplierSurveyFormDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub

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

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                <asp:Label id="Label63" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">SUPPLIER
                                INFORMATION</asp:Label>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Company Name." ForeColor=" " Display="Dynamic" ControlToValidate="txtCompanyName"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Address." ForeColor=" " Display="Dynamic" ControlToValidate="txtAdd1"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Tel No." ForeColor=" " Display="Dynamic" ControlToValidate="txtTel"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Fax No" ForeColor=" " Display="Dynamic" ControlToValidate="txtFax"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid E-mail." ForeColor=" " Display="Dynamic" ControlToValidate="txtEMail"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid E-Mail(for P/O)" ForeColor=" " Display="Dynamic" ControlToValidate="txtEMailPO"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid E-Mail (for part approval)." ForeColor=" " Display="Dynamic" ControlToValidate="txtEMailSSER"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator8" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Main Shareholder" ForeColor=" " Display="Dynamic" ControlToValidate="txtMainShareholder"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator9" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Sales Contact Person." ForeColor=" " Display="Dynamic" ControlToValidate="txtSales"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator10" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Total Employee." ForeColor=" " Display="Dynamic" ControlToValidate="txtTotalEmp"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator11" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Type of Ownership." ForeColor=" " Display="Dynamic" ControlToValidate="cmbTypeOfOwner"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator12" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Place of Departure." ForeColor=" " Display="Dynamic" ControlToValidate="cmbPlaceOfDeparture"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator13" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Type of Business" ForeColor=" " Display="Dynamic" ControlToValidate="txtTypeOfBiz1"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator15" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Payment Term" ForeColor=" " Display="Dynamic" ControlToValidate="cmbPayTerm"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator16" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Delivery Mode." ForeColor=" " Display="Dynamic" ControlToValidate="cmbDelMode"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator14" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Shipping Term." ForeColor=" " Display="Dynamic" ControlToValidate="cmbShipTerm"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator18" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Currency Code" ForeColor=" " Display="Dynamic" ControlToValidate="cmbCurr"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator19" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Banker Name" ForeColor=" " Display="Dynamic" ControlToValidate="txtBankerName"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator20" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Banker Address." ForeColor=" " Display="Dynamic" ControlToValidate="txtBankerAdd1"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator17" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Account No" ForeColor=" " Display="Dynamic" ControlToValidate="txtBankerACNo"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator21" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Spare %." ForeColor=" " Display="Dynamic" ControlToValidate="txtSparePctg"></asp:RequiredFieldValidator>
                                <asp:CompareValidator id="CompareValidator1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Authorised Capital" ForeColor=" " Display="Dynamic" ControlToValidate="txtAuthorisedCap" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator2" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Paid Up capital." ForeColor=" " Display="Dynamic" ControlToValidate="txtPaidUpCap" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator3" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Spare Percentage" ForeColor=" " Display="Dynamic" ControlToValidate="txtSparePctg" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator4" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Formation Year." ForeColor=" " Display="Dynamic" ControlToValidate="txtFormationYear" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                
                                <asp:CompareValidator id="CompareValidator16" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Last 3 month Turn Over." ForeColor=" " Display="Dynamic" ControlToValidate="txtTurnOver1" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator17" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Last 3 month Turn Over." ForeColor=" " Display="Dynamic" ControlToValidate="txtTurnOver2" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                <asp:CompareValidator id="CompareValidator18" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Last 3 month Turn Over." ForeColor=" " Display="Dynamic" ControlToValidate="txtTurnOver3" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                            </p>
                            <p>
                                <table style="HEIGHT: 11px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:LinkButton id="lnkAttachment" onclick="lnkAttachment_Click" runat="server" Width="100%" CausesValidation="False">Click here to add / edit
attachment.</asp:LinkButton>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdRefreshAtt" onclick="cmdRefreshAtt_Click" runat="server" CausesValidation="False" Text="Refresh Attachment"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged" PageSize="50" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black">
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
                                                <div align="center"><asp:Label id="Label19" runat="server" cssclass="FormDesc" width="100%">COMPANY
                                                    PROFILE</asp:Label><asp:Label id="lblRefNo" runat="server" cssclass="LabelNormal" visible="False">Sales</asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" bgcolor="silver">
                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Company Name</asp:Label></td>
                                            <td width="30%">
                                                <asp:TextBox id="txtCompanyName" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td width="50%" bgcolor="silver" colspan="2">
                                                <asp:Label id="Label10" runat="server" cssclass="LabelNormal">Person In-Charge : -</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Address</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtAdd1" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td width="20%" bgcolor="silver">
                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Main Shareholder</asp:Label></td>
                                            <td width="30%">
                                                <asp:TextBox id="txtMainShareholder" runat="server" CssClass="outputText" Width="100%" MaxLength="40"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtAdd2" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Sales</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtSales" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtAdd3" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label16" runat="server" cssclass="LabelNormal">Total Employees</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtTotalEmp" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Tel No</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtTel" runat="server" CssClass="outputText" Width="100%" MaxLength="40"></asp:TextBox>
                                            </td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label18" runat="server" cssclass="LabelNormal">Type of Ownership</asp:Label></td>
                                            <td>
                                                <asp:DropDownList id="cmbTypeOfOwner" runat="server" CssClass="OutputText" Width="100%">
                                                    <asp:ListItem Value="Manufacturer">Manufacturer</asp:ListItem>
                                                    <asp:ListItem Value="DISTRIBUTOR">Distributor or Agent</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Fax No</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtFax" runat="server" CssClass="outputText" Width="100%" MaxLength="40"></asp:TextBox>
                                            </td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Authorised Capital</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtAuthorisedCap" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">E-Mail </asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtEMail" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Paid-up Capital</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtPaidUpCap" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">E-Mail(for P/O) </asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtEMailPO" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Spare %</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtSparePctg" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label13" runat="server" cssclass="LabelNormal">E-Mail(for part Approval)</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtEMailSSER" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label15" runat="server" cssclass="LabelNormal">Place of Departure</asp:Label></td>
                                            <td>
                                                <asp:DropDownList id="cmbPlaceOfDeparture" runat="server" CssClass="OutputText" Width="100%">
                                                    <asp:ListItem Value="L">Local</asp:ListItem>
                                                    <asp:ListItem Value="F">Foreign</asp:ListItem>
                                                    <asp:ListItem Value="S">Singapore</asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label33" runat="server" cssclass="LabelNormal">Registration No</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtRegNo" runat="server" CssClass="outputText" Width="100%" MaxLength="40"></asp:TextBox>
                                            </td>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label34" runat="server" cssclass="LabelNormal">Formation Year</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtFormationYear" runat="server" CssClass="outputText" Width="100%" MaxLength="4"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td colspan="5">
                                                <div align="center"><asp:Label id="Label20" runat="server" cssclass="FormDesc" width="100%">BUSINESS
                                                    CONDITION</asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label21" runat="server" cssclass="LabelNormal">Type of Business</asp:Label></td>
                                            <td width="30%">
                                                <asp:TextBox id="txtTypeOfBiz1" runat="server" CssClass="outputText" Width="100%" MaxLength="40"></asp:TextBox>
                                            </td>
                                            <td width="50%" bgcolor="silver" colspan="3">
                                                <asp:Label id="Label22" runat="server" cssclass="LabelNormal">Major Customers :</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtTypeOfBiz2" runat="server" CssClass="outputText" Width="100%" MaxLength="40"></asp:TextBox>
                                            </td>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label24" runat="server" cssclass="LabelNormal">Company Name</asp:Label></td>
                                            <td width="13%" bgcolor="silver">
                                                <asp:Label id="Label25" runat="server" cssclass="LabelNormal">Annual Sales</asp:Label></td>
                                            <td width="12%" bgcolor="silver">
                                                <asp:Label id="Label26" runat="server" cssclass="LabelNormal">% of total</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtTypeOfBiz3" runat="server" CssClass="outputText" Width="100%" MaxLength="40"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtMajorCust1" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtAnnualSales1" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtPctgOfTotal1" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label27" runat="server" cssclass="LabelNormal">Last 3 month Turn Over</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtTurnOver1" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtMajorCust2" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtAnnualSales2" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtPctgOfTotal2" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtTurnOver2" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtMajorCust3" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtAnnualSales3" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtPctgOfTotal3" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtTurnOver3" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtMajorCust4" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtAnnualSales4" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtPctgOfTotal4" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label31" runat="server" cssclass="LabelNormal">Annual Turnover </asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtAnnualTurnover" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtMajorCust5" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtAnnualSales5" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtPctgOfTotal5" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
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
                                                <div align="center"><asp:Label id="Label23" style="Z-INDEX: 107" runat="server" cssclass="FormDesc" width="100%">PRODUCTION
                                                    STRUCTURE (FOR MANUFACTURER ONLY)</asp:Label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="20%" bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label30" runat="server" cssclass="LabelNormal">Product Types</asp:Label></td>
                                            <td width="30%">
                                                <asp:TextBox id="txtProductType1" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td width="20%" bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label32" runat="server" cssclass="LabelNormal">Monthly Production Capacity</asp:Label></td>
                                            <td width="30%">
                                                <asp:TextBox id="txtProductionCapacity1" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtProductType2" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtProductionCapacity2" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox id="txtProductType3" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtProductionCapacity3" runat="server" CssClass="outputText" Width="100%"></asp:TextBox>
                                            </td>
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
                                                <asp:DropDownList id="cmbPayTerm" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                            </td>
                                            <td width="20%" bgcolor="silver" colspan="2">
                                                <asp:Label id="Label39" runat="server" cssclass="LabelNormal">Banker Details</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label41" runat="server" cssclass="LabelNormal">Delivery Mode</asp:Label></td>
                                            <td>
                                                <asp:DropDownList id="cmbDelMode" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                            </td>
                                            <td width="20%" bgcolor="silver">
                                                <asp:Label id="Label40" runat="server" cssclass="LabelNormal">Name</asp:Label></td>
                                            <td width="30%">
                                                <asp:TextBox id="txtBankerName" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label43" runat="server" cssclass="LabelNormal">Shipping Terms</asp:Label></td>
                                            <td>
                                                <asp:DropDownList id="cmbShipTerm" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                            </td>
                                            <td bgcolor="silver" rowspan="3">
                                                <asp:Label id="Label42" runat="server" cssclass="LabelNormal">Address</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtBankerAdd1" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label29" runat="server" cssclass="LabelNormal">Currency</asp:Label></td>
                                            <td>
                                                <asp:DropDownList id="cmbCurr" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtBankerAdd2" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" rowspan="2">
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtBankerAdd3" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label28" runat="server" cssclass="LabelNormal">Account No</asp:Label></td>
                                            <td>
                                                <asp:TextBox id="txtBankerACNo" runat="server" CssClass="outputText" Width="100%" MaxLength="60"></asp:TextBox>
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
                                                <asp:Label id="Label35" runat="server" cssclass="LabelNormal">Prepared By</asp:Label></td>
                                            <td width="75%" bgcolor="silver">
                                                <asp:Label id="Label36" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="lblSubmitBy" runat="server" cssclass="outputText" width="100%"></asp:Label><asp:Label id="lblSubmitDate" runat="server" cssclass="outputText" width="100%"></asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:TextBox id="txtSubmitRem" runat="server" CssClass="outputText" Width="100%" MaxLength="400" Height="54px"></asp:TextBox>
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
                                                <asp:Label id="Label48" runat="server" cssclass="LabelNormal">HOD Approval</asp:Label></td>
                                            <td width="50%" bgcolor="silver">
                                                <asp:Label id="Label49" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                            <td width="25%" bgcolor="silver">
                                                <asp:Label id="Label50" runat="server" cssclass="LabelNormal">Status</asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="lblApp1By" runat="server" cssclass="outputText" width="100%"></asp:Label><asp:Label id="lblApp1Date" runat="server" cssclass="outputText" width="100%"></asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:Label id="lblApp1Rem" runat="server" cssclass="outputText" width="100%"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblApp1Status" runat="server" cssclass="outputText" width="100%"></asp:Label></td>
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
                                                <div align="center"><asp:Label id="lblApp2By" runat="server" cssclass="outputText" width="100%"></asp:Label><asp:Label id="lblApp2Date" runat="server" cssclass="outputText" width="100%"></asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:Label id="lblApp2Rem" runat="server" cssclass="outputText" width="100%"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblApp2Status" runat="server" cssclass="outputText" width="100%"></asp:Label></td>
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
                                                <div align="center"><asp:Label id="lblApp3By" runat="server" cssclass="outputText" width="100%"></asp:Label><asp:Label id="lblApp3Date" runat="server" cssclass="outputText" width="100%"></asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <asp:Label id="lblApp3Rem" runat="server" cssclass="outputText" width="100%"></asp:Label></td>
                                            <td>
                                                <asp:Label id="lblApp3Status" runat="server" cssclass="outputText" width="100%"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td width="15%">
                                                <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="100%" Text="Update"></asp:Button>
                                            </td>
                                            <td width="20%">
                                                <div align="center">
                                                    <asp:Button id="cmdUpdateSubmit" onclick="cmdUpdateSubmit_Click" runat="server" Width="100%" Text="Update and Submit"></asp:Button>
                                                </div>
                                            </td>
                                            <td width="15%">
                                                <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="100%" CausesValidation="False" Text="Remove"></asp:Button>
                                            </td>
                                            <td width="15%">
                                                <asp:Button id="cmdResubmit" runat="server" Width="100%" Text="Re-submit"></asp:Button>
                                            </td>
                                            <td width="20%">
                                                <div align="center">
                                                    <asp:Button id="cmdIgnore" runat="server" Width="100%" CausesValidation="False" Text="Ignore Re-submit"></asp:Button>
                                                </div>
                                            </td>
                                            <td width="15%">
                                                <div align="right">
                                                    <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="100%" CausesValidation="False" Text="Back"></asp:Button>
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
