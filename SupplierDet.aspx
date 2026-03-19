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
            Dissql("select rtrim(upper(country)) as [country] from country order by country","country","country",cmbVenCountry)
            Dissql("select rtrim(upper(Curr_Code)) as [curr_code], upper(Curr_Desc) as [curr_desc] from Curr order by Curr_Desc asc","Curr_Code","Curr_Desc",cmbCurr_Code)
            Dissql("select rtrim(upper(shipterm_code)) as [shipterm_code],shipterm_desc from SHIPTERM order by shipterm_desc asc","shipterm_code","shipterm_desc",cmbShipTerm)
            Dissql("select rtrim(upper(PAYTERM_DESC)) as [payterm_desc] from payterm order by PAYTERM_DESC asc","PAYTERM_DESC","PAYTERM_DESC",cmbPayTerm)
            LoadSupplierData
        end if
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string,FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = ucase(trim(FValue))
            .DataTextField = ucase(trim(FText))
            .DataBind()
        end with
        ResExeDataReader.close()
        Dim oList As ListItemCollection = obj.Items
        oList.Add(New ListItem(""))
    End Sub
    
    Sub LoadSupplierData()
        Dim ReqCOM as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        lblSuppCode.text = trim(reqCOM.GetFieldVal("Select Ven_Code from Vendor where Seq_No = " & request.params("ID") & ";","Ven_Code"))
        Dim strSql as string = "SELECT * FROM Vendor WHERE Ven_Code = '" & trim(lblSuppCode.text)  & "';"
        Dim State,Country,CurrencyCode,PayTerm, ShipTerm as string
        Dim ResExeDataReader as SQLDataReader = ReqCOM.ExeDataReader(strSql)
    
        do while ResExeDataReader.read
            lblSuppCode.text = ResExeDataReader("VEN_CODE").toString
            txtSuppName.text = ResExeDataReader("VEN_NAME").toString
            txtWebSite.text = ResExeDataReader("WEB_SITE").toString
            txtRem.text = ResExeDataReader("REM").toString
            txtVenAdd1.text = ResExeDataReader("Add1").toString
            txtVenAdd2.text = ResExeDataReader("Add2").toString
            txtVenAdd3.text = ResExeDataReader("Add3").toString
            txtContactPerson.text = trim(ResExeDataReader("Contact_Person").toString)
            txtSSERMailTo.text = trim(ResExeDataReader("EMail_SSER").toString)
            txtPOmailTo.text = trim(ResExeDataReader("Email_PO").toString)
            State = ResExeDataReader("Ven_State").toString
            txtTel1.text = trim(ResExeDataReader("Tel1").toString)
            txtFax1.text = trim(ResExeDataReader("Fax1").toString)
            txtS1Title.text = ResExeDataReader("S1_TITLE").toString
            txtS1Name.text = ResExeDataReader("S1_NAME").toString
            txtS1EMail.text = ResExeDataReader("S1_EMAIL").toString
            txtS1Tel.text = ResExeDataReader("S1_TEL1").toString
            txtS1Ext.text = ResExeDataReader("S1_EXT1").toString
            txtS1Fax.text = ResExeDataReader("S1_FAX1").toString
            txtDestination.text = ResExeDataReader("Destination").toString
            txtSparePctg.text = ResExeDataReader("Spare_Pctg").toString
            txtS2Title.text = ResExeDataReader("S2_TITLE").toString
            txtS2Name.text = ResExeDataReader("S2_NAME").toString
            txtS2EMail.text = ResExeDataReader("S2_EMAIL").toString
            txtS2Tel.text = ResExeDataReader("S2_TEL1").toString
            txtS2Ext.text = ResExeDataReader("S2_EXT1").toString
            txtS2Fax.text = ResExeDataReader("S2_FAX1").toString
            txtA1Title.text = ResExeDataReader("A1_TITLE").toString
            txtA1Name.text = ResExeDataReader("A1_NAME").toString
            txtA1EMail.text = ResExeDataReader("A1_EMAIL").toString
            txtA1Tel.text = ResExeDataReader("A1_TEL1").toString
            txtA1Ext.text = ResExeDataReader("A1_EXT1").toString
            txtA1Fax.text = ResExeDataReader("A1_FAX1").toString
            txtA2Title.text= ResExeDataReader("A2_TITLE").toString
            txtA2Name.text= ResExeDataReader("A2_NAME").toString
            txtA2EMail.text= ResExeDataReader("A2_EMAIL").toString
            txtA2Tel.text= ResExeDataReader("A2_TEL1").toString
            txtA2Ext.text= ResExeDataReader("A2_EXT1").toString
            txtA2Fax.text= ResExeDataReader("A2_FAX1").toString
            txtO1Title.text = ResExeDataReader("O1_TITLE").toString
            txtO1Name.text = ResExeDataReader("O1_NAME").toString
            txtO1EMail.text = ResExeDataReader("O1_EMAIL").toString
            txtO1Tel.text = ResExeDataReader("O1_TEL1").toString
            txtO1Ext.text = ResExeDataReader("O1_EXT1").toString
            txtO1Fax.text = ResExeDataReader("O1_FAX1").toString
            txtO2Title.text = ResExeDataReader("O2_TITLE").toString
            txtO2Name.text = ResExeDataReader("O2_NAME").toString
            txtO2EMail.text = ResExeDataReader("O2_EMAIL").toString
            txtO2Tel.text = ResExeDataReader("O2_TEL1").toString
            txtO2Ext.text = ResExeDataReader("O2_EXT1").toString
            txtO2Fax.text = ResExeDataReader("O2_FAX1").toString
    
    
    
            cmbShipTerm.Items.FindByValue(trim(ucase(ResExeDataReader("SHIP_TERM")))).Selected = True
    
            cmbPayTerm.Items.FindByValue(trim(ucase(ResExeDataReader("Pay_Term")))).Selected = True
            cmbCurr_Code.Items.FindByValue(trim(ucase(ResExeDataReader("Curr_Code")))).Selected = True
    
            'cmbVenCountry.Items.FindByValue(trim(ucase(ResExeDataReader("Ven_Country")))).Selected = True
    
            lblCreateBy.text = ResExeDataReader("Create_By").toString
            if isdbnull(ResExeDataReader("Create_Date")) = false then lblCreateDate.text = format(cdate(ResExeDataReader("Create_Date").toString),"dd/MMM/yy")
    
            lblModifyBy.text = ResExeDataReader("Modify_By").toString
            if isdbnull(ResExeDataReader("Modify_Date")) = false then lblModifyDate.text = format(cdate(ResExeDataReader("Modify_Date").toString),"dd/MMM/yy")
    
            if trim(ResExeDataReader("LOC")) = "L" then cmbLocation.Items.FindByValue("L").Selected = True
            if trim(ResExeDataReader("LOC")) = "S" then cmbLocation.Items.FindByValue("S").Selected = True
            if trim(ResExeDataReader("LOC")) = "F" then cmbLocation.Items.FindByValue("F").Selected = True
            if trim(ResExeDataReader("LOC")) = "G" then cmbLocation.Items.FindByValue("G").Selected = True
            if trim(ResExeDataReader("LOC")) = "Z" then cmbLocation.Items.FindByValue("Z").Selected = True
        loop
        response.write(Payterm)
    end sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid= true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
    
            StrSql = "Update Vendor set VEN_CODE = '" & trim(lblSuppCode.text) & "',"
            StrSql = StrSql + "VEN_NAME = '" & trim(txtSuppName.text) & "',"
            StrSql = StrSql + "ADD1 = '" & trim(txtVenAdd1.text) & "',"
            StrSql = StrSql + "ADD2 = '" & trim(txtVenAdd2.text) & "',"
            StrSql = StrSql + "ADD3 = '" & trim(txtVenAdd3.text) & "',"
            StrSql = StrSql + "VEN_COUNTRY = '" & trim(cmbVenCountry.selectedItem.value) & "',"
            StrSql = StrSql + "Contact_Person = '" & trim(txtContactPerson.text) & "',"
            StrSql = StrSql + "Email_SSER = '" & trim(txtSSERMailTo.text) & "',"
            StrSql = StrSql + "EMail_PO = '" & trim(txtPOmailTo.text) & "',"
            StrSql = StrSql + "TEL1 = '" & trim(txtTel1.text) & "',"
            StrSql = StrSql + "FAX1 = '" & trim(txtFax1.text) & "',"
            StrSql = StrSql + "SHIP_TERM = '" & trim(cmbShipTerm.selectedItem.value) & "',"
            StrSql = StrSql + "DESTINATION = '" & trim(txtDestination.text) & "',"
    
            if txtSparePctg.text = "" then txtSparePctg.text = "0":StrSql = StrSql + "SPARE_PCTG = " & trim(txtSparePctg.text) & ","
    
            StrSql = StrSql + "PAY_TERM = '" & trim(cmbPayTerm.selectedItem.value) & "',"
            StrSql = StrSql + "CURR_CODE = '" & trim(cmbCurr_Code.SelectedItem.value) & "',"
            StrSql = StrSql + "WEB_SITE = '" & trim(txtWebSite.text) & "',"
            StrSql = StrSql + "REM = '" & trim(txtRem.text) & "',"
            StrSql = StrSql + "S1_TITLE = '" & trim(txtS1Title.text) & "',"
            StrSql = StrSql + "S1_NAME = '" & trim(txtS1Name.text) & "',"
            StrSql = StrSql + "S1_EMAIL = '" & trim(txtS1EMail.text) & "',"
            StrSql = StrSql + "S1_TEL1 = '" & trim(txtS1Tel.text) & "',"
            StrSql = StrSql + "S1_EXT1 = '" & trim(txtS1Ext.text) & "',"
            StrSql = StrSql + "S1_FAX1 = '" & trim(txtS1Fax.text) & "',"
            StrSql = StrSql + "S2_TITLE = '" & trim(txtS2Title.text) & "',"
            StrSql = StrSql + "S2_NAME = '" & trim(txtS2Name.text) & "',"
            StrSql = StrSql + "S2_EMAIL = '" & trim(txtS2EMail.text) & "',"
            StrSql = StrSql + "S2_TEL1 = '" & trim(txtS2Tel.text) & "',"
            StrSql = StrSql + "S2_EXT1 = '" & trim(txtS2Ext.text) & "',"
            StrSql = StrSql + "S2_FAX1 = '" & trim(txtS2Fax.text) & "',"
            StrSql = StrSql + "A1_TITLE = '" & trim(txtA1Title.text) & "',"
            StrSql = StrSql + "A1_NAME = '" & trim(txtA1Name.text) & "',"
            StrSql = StrSql + "A1_EMAIL = '" & trim(txtA1EMail.text) & "',"
            StrSql = StrSql + "A1_TEL1 = '" & trim(txtA1Tel.text) & "',"
            StrSql = StrSql + "A1_EXT1 = '" & trim(txtA1Ext.text) & "',"
            StrSql = StrSql + "A1_FAX1 = '" & trim(txtA1Fax.text ) & "',"
            StrSql = StrSql + "A2_TITLE = '" & trim(txtA2Title.text) & "',"
            StrSql = StrSql + "A2_NAME = '" & trim(txtA2Name.text) & "',"
            StrSql = StrSql + "A2_EMAIL = '" & trim(txtA2EMail.text) & "',"
            StrSql = StrSql + "A2_TEL1 = '" & trim(txtA2Tel.text) & "',"
            StrSql = StrSql + "A2_EXT1 = '" & trim(txtA2Ext.text) & "',"
            StrSql = StrSql + "A2_FAX1 = '" & trim(txtA2Fax.text) & "',"
            StrSql = StrSql + "O1_TITLE = '" & trim(txtO1Title.text) & "',"
            StrSql = StrSql + "O1_NAME = '" & trim(txtO1Name.text) & "',"
            StrSql = StrSql + "O1_EMAIL = '" & trim(txtO1EMail.text) & "',"
            StrSql = StrSql + "O1_TEL1 = '" & trim(txtO1Tel.text) & "',"
            StrSql = StrSql + "O1_EXT1 = '" & trim(txtO1Ext.text) & "',"
            StrSql = StrSql + "O1_FAX1 = '" & trim(txtO1Fax.text) & "',"
            StrSql = StrSql + "O2_TITLE = '" & trim(txtO2Title.text) & "',"
            StrSql = StrSql + "O2_NAME = '" & trim(txtO2Name.text) & "',"
            StrSql = StrSql + "O2_EMAIL = '" & trim(txtO2EMail.text) & "',"
            StrSql = StrSql + "O2_TEL1 = '" & trim(txtO2Tel.text) & "',"
            StrSql = StrSql + "O2_EXT1 = '" & trim(txtO2Ext.text) & "',"
            StrSql = StrSql + "O2_FAX1 = '" & trim(txtO2Fax.text) & "',"
            StrSql = StrSql + "MODIFY_BY = '" & trim(request.cookies("U_ID").value) & "',"
            StrSql = StrSql + "MODIFY_DATE = '" & now & "'"
            StrSql = StrSql + " where Seq_No = " & request.params("ID") & ";"
    
            ReqCOM.executenonQuery(StrSql)
            response.redirect("SupplierDet.aspx?ID=" & Request.params("ID"))
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
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" forecolor="" backcolor="" width="100%">SUPPLIER
                                DETAILS</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 497px" cellspacing="0" cellpadding="0" width="80%" align="center" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <div>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtVenAdd1" EnableClientScript="False" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid address." ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <div>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ControlToValidate="cmbPayTerm" EnableClientScript="False" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid payment term." ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <div>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ControlToValidate="cmbShipTerm" EnableClientScript="False" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid shipping term." ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <div>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" ControlToValidate="cmbCurr_Code" EnableClientScript="False" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid currency code." ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <div>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtVenAdd1" EnableClientScript="False" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid address." ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <div>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" ControlToValidate="txtTel1" EnableClientScript="False" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid tel. no" ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <div>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator8" runat="server" ControlToValidate="txtFax1" EnableClientScript="False" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid fax no." ForeColor=" " CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                </div>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="110px">Supplier
                                                                    Code</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="left"><asp:Label id="lblSuppCode" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="110px">Supplier
                                                                    Name</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                                <td colspan="3">
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtSuppName" runat="server" CssClass="OutputText" Width="100%" MaxLength="60"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="3">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="110px">Address</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtVenAdd1" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtVenAdd2" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtVenAdd3" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="110px">Country</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:DropDownList id="cmbVenCountry" runat="server" CssClass="OutputText" Width="235px"></asp:DropDownList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="110px">Currency
                                                                    Code</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:DropDownList id="cmbCurr_Code" runat="server" CssClass="OutputText" Width="235px"></asp:DropDownList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label24" runat="server" cssclass="LabelNormal" width="110px">Payment
                                                                    Term</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList id="cmbPayTerm" runat="server" CssClass="OutputText" Width="235px"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label25" runat="server" cssclass="LabelNormal" width="110px">Shipping
                                                                    Term</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList id="cmbShipTerm" runat="server" CssClass="OutputText" Width="235px"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label28" runat="server" cssclass="LabelNormal" width="110px">Destination</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtDestination" runat="server" CssClass="OutputText" Width="235px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label45" runat="server" cssclass="LabelNormal" width="126px">Location</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:DropDownList id="cmbLocation" runat="server" CssClass="OutputText" Width="235px">
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
                                                                    <asp:Label id="Label29" runat="server" cssclass="LabelNormal" width="126px">Spare
                                                                    Percentage</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtSparePctg" runat="server" CssClass="OutputText" Width="235px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label42" runat="server" cssclass="LabelNormal" width="126px">Contact
                                                                    Person</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtContactPerson" runat="server" CssClass="OutputText" Width="235px" MaxLength="60"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label43" runat="server" cssclass="LabelNormal">SSER Mail to</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtSSERMailTo" runat="server" CssClass="OutputText" Width="235px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label44" runat="server" cssclass="LabelNormal">P/O Mail to</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtPOMailTo" runat="server" CssClass="OutputText" Width="235px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="110px">Tel</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtTel1" runat="server" CssClass="OutputText" Width="235px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="110px">Fax</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtFax1" runat="server" CssClass="OutputText" Width="235px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="110px">Web Site</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtWebSite" runat="server" CssClass="OutputText" Width="235px"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="110px">Remarks</asp:Label></td>
                                                                <td colspan="3">
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
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
                                                                </td>
                                                                <td width="38%" bgcolor="silver">
                                                                    <div align="center"><asp:Label id="Label30" runat="server" cssclass="LabelNormal" width="220px">SALES
                                                                        (1)</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td width="38%" bgcolor="silver">
                                                                    <div align="center"><asp:Label id="Label31" runat="server" cssclass="LabelNormal" width="220px">SALES
                                                                        (2)</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="110px">Title</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS1Title" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS2Title" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="110px">Name</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS1Name" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS2Name" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal" width="110px">E-Mail</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS1EMail" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS2EMail" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label15" runat="server" cssclass="LabelNormal" width="110px">Tel</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS1Tel" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS2Tel" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal" width="110px">Ext</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS1Ext" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS2Ext" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label17" runat="server" cssclass="LabelNormal" width="110px">Fax</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS1Fax" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtS2Fax" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
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
                                                                </td>
                                                                <td width="38%" bgcolor="silver">
                                                                    <div align="center"><asp:Label id="Label32" runat="server" cssclass="LabelNormal" width="220px">ACCOUNTS
                                                                        (1)</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td width="38%" bgcolor="silver">
                                                                    <div align="center"><asp:Label id="Label33" runat="server" cssclass="LabelNormal" width="220px">ACCOUNTS
                                                                        (2)</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label34" runat="server" cssclass="LabelNormal" width="110px">Title</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA1Title" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA2Title" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label35" runat="server" cssclass="LabelNormal" width="110px">Name</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA1Name" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA2Name" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label36" runat="server" cssclass="LabelNormal" width="110px">E-Mail</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA1EMail" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA2EMail" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label37" runat="server" cssclass="LabelNormal" width="110px">Tel</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA1Tel" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA2Tel" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label38" runat="server" cssclass="LabelNormal" width="110px">Ext</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA1Ext" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA2Ext" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label39" runat="server" cssclass="LabelNormal" width="110px">Fax</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA1Fax" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtA2Fax" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
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
                                                                </td>
                                                                <td width="38%" bgcolor="silver">
                                                                    <div align="center"><asp:Label id="Label18" runat="server" cssclass="LabelNormal" width="220px">OTHERS
                                                                        (1)</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td width="38%" bgcolor="silver">
                                                                    <div align="center"><asp:Label id="Label19" runat="server" cssclass="LabelNormal" width="220px">OTHERS
                                                                        (2)</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label20" runat="server" cssclass="LabelNormal" width="110px">Title</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO1Title" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO2Title" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label21" runat="server" cssclass="LabelNormal" width="110px">Name</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO1Name" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO2Name" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label22" runat="server" cssclass="LabelNormal" width="110px">E-Mail</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO1EMail" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO2EMail" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label23" runat="server" cssclass="LabelNormal" width="110px">Tel</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO1Tel" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO2Tel" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label40" runat="server" cssclass="LabelNormal" width="110px">Ext</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO1Ext" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO2Ext" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label41" runat="server" cssclass="LabelNormal" width="110px">Fax</asp:Label></td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO1Fax" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtO2Fax" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
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
                                                                    <asp:Label id="Label26" runat="server" cssclass="LabelNormal" width="162px">Created
                                                                    By / Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="lblCreateDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label27" runat="server" cssclass="LabelNormal" width="161px">Modified
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
    </form>
</body>
</html>
