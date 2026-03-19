<%@ Page Language="VB" Debug="TRUE" %>
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
            if page.ispostback = false then LoadPartDet
        End Sub
    
    
        Sub LoadData()
            Dim StrSql as string = "Select * from BOM_Quote_M where Seq_No = " & clng(Request.params("ID")) & ";"
            Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            cnnGetFieldVal.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
            do while drGetFieldVal.read
                lblBomQuoteNo.text = drGetFieldVal("Bom_Quote_No")
                lblModelNo.text = drGetFieldVal("Model_No")
                lblModelDesc.text = drGetFieldVal("Model_Desc")
                lblBOMQuoteRev.text = drGetFieldVal("BOM_Quote_Rev")
            loop
            myCommand.dispose()
            drGetFieldVal.close()
            cnnGetFieldVal.Close()
            cnnGetFieldVal.Dispose()
        End sub
    
        Sub LoadPartDet()
            Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim CurrCode as string
            Dim StrSql as string = "Select * from BOM_Quote_D where Seq_No = " & clng(request.params("ID")) & ";"
            Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            cnnGetFieldVal.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            do while drGetFieldVal.read
                lblBOMQuoteNo.text = drGetFieldVal("BOM_Quote_No").tostring
    
                lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from BOM_Quote_m where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';","Model_No")
                lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from BOM_Quote_m where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';","Model_Desc")
    
                lblBOMQuoteRev.text = ReqCOM.GetFieldVal("Select BOM_Quote_Rev from BOM_Quote_m where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';","BOM_Quote_Rev")
                txtPartNo.text = drGetFieldVal("Part_No").tostring
                lblPartNo.text = drGetFieldVal("Part_No").tostring
                lblMainPart.text = drGetFieldVal("Main_Part").tostring
                txtCustPartNo.text = drGetFieldVal("Cust_Part_No").tostring
                txtPartDesc.text = drGetFieldVal("Part_Desc").tostring
                txtPartSpec.text = drGetFieldVal("Part_Spec").tostring
                txtMFGName.text = drGetFieldVal("MFG_Name").tostring
                txtMFGMPN.text = drGetFieldVal("mfg_mpn").tostring
                txtPUsage.text = drGetFieldVal("P_Usage").tostring
                txtOriUP.text = drGetFieldVal("Std_Ori_UP").tostring
                txtUPRM.text = drGetFieldVal("Std_Up").tostring
                txtLeadTime.text = drGetFieldVal("std_lt").tostring
                txtSPQ.text = drGetFieldVal("std_spq").tostring
                txtMOQ.text = drGetFieldVal("std_moq").tostring
                txtRem.text = drGetFieldVal("Rem").tostring
                if drGetFieldVal("Std_Ven_Code") = "TempSupplier" then Dissql ("Select Std_Ven_Code,std_ven_name from BOM_Quote_D where Seq_No = " & request.params("ID") & ";","Std_Ven_Code","Std_Ven_Name",cmbSearchVen)
                if drGetFieldVal("Std_Ven_Code") <> "TempSupplier" then Dissql ("Select Ven_Code,VEn_Name from Vendor where Ven_Code = '" & trim(drGetFieldVal("std_ven_Code")) & "';","Ven_Code","Ven_Name",cmbSearchVen)
                Dissql("Select Curr_Code,Curr_Desc from bom_quote_curr where curr_code <> '-' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' order by curr_Desc","Curr_Code","Curr_Desc",cmbOriCurr)
                CurrCode = ReqCOm.GetFieldVal("Select Curr_Code from Curr where Curr_Code = '" & trim(drGetFieldVal("Std_Curr_Code")) & "';","Curr_Code")
                cmbOriCurr.Items.FindByValue(CurrCode).Selected = True
                CalculateQty
            loop
            myCommand.dispose()
            drGetFieldVal.close()
            cnnGetFieldVal.Close()
            cnnGetFieldVal.Dispose()
         End sub
    
         Sub ShowAlert(Msg as string)
             Dim strScript as string
             strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
             If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
         End sub
    
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
    
         Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdSaveAndExit_Click(sender As Object, e As EventArgs)
             if page.isvalid = true then
                SaveDet
                ShowAlert("Part details saved.")
            End if
         End Sub
    
         Sub SaveDet()
            if page.isvalid = true then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Part_No = '" & trim(txtPartNo.text) & "',Cust_Part_No = '" & trim(txtCustPartNo.text) & "',Part_Desc = '" & trim(txtPartDesc.text) & "',Part_Spec = '" & trim(txtPartSpec.text) & "',MFG_Name = '" & trim(txtMFGName.text) & "',mfg_mpn = '" & trim(txtMFGMPN.text) & "',P_Usage = " & cdec(txtPUsage.text) & ",Std_Ori_UP = " & cdec(txtOriUP.text) & ",Std_Up = " & cdec(txtUPRM.text) & ",std_lt = " & clng(txtLeadTime.text) & ",std_spq = " & clng(txtSPQ.text) & ",std_moq = " & clng(txtMOQ.text) & ",Rem = '" & trim(txtRem.text) & "' where Seq_No = " & request.params("ID") & ";")
    
                if trim(ucase(lblMainPart.text)) = trim(ucase(lblPartNo.text)) then
                    'ReqCOM.ExecuteNonQuery("Update bom_quote_d set part_no = '" & trim(txtPartNo.text) & "' where Seq_No = " & clng(Request.params("ID")) & ";")
                    'ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set Main_Part = '" & trim(txtPartNo.text) & "',Part_No = '" & trim(txtPartNo.text) & "' where main_part = '" & trim(lblMainPart.text) & "' and bom_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';")
                    'ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set Main_Part = '" & trim(txtPartNo.text) & "' where main_part = '" & trim(lblMainPart.text) & "' and bom_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';")
    
                    ReqCOM.ExecuteNonQuery("Update bom_quote_d set part_no = '" & trim(txtPartNo.text) & "',main_part = '" & trim(txtPartNo.text) & "' where Seq_No = " & clng(Request.params("ID")) & ";")
                    ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set Main_Part = '" & trim(txtPartNo.text) & "' where main_part = '" & trim(lblMainPart.text) & "' and bom_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';")
                    'response.write("1")
                elseif trim(ucase(lblMainPart.text)) <> trim(ucase(lblPartNo.text)) then
                    ReqCOM.ExecuteNonQuery("Update bom_quote_d set part_no = '" & trim(txtPartNo.text) & "' where Seq_No = " & clng(Request.params("ID")) & ";")
                    'response.write("2")
                end if
            end if
         End sub
    
         Sub cmdSaveAnother_Click(sender As Object, e As EventArgs)
             if page.isvalid = true then
                 Response.redirect("BOMQuotePartAddNew.aspx?ID=" & Request.params("ID"))
             end if
         End Sub
    
         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
    
    
         Sub cmdCalculate_Click_1(sender As Object, e As EventArgs)
             CalculateQty
         End Sub
    
         Sub CalculateQty()
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim Rate as Decimal
             Rate = ReqCOM.GetFieldVal("Select Rate/Unit_Conv as [Rate] from Curr where Curr_Code = '" & trim(cmbOriCurr.selecteditem.value) & "';","Rate")
             txtUPRm.text = format(cdec(cdec(txtOriUP.text) * Rate),"##,##0.00000")
    
    
    
    
             txtOriAmt.text = txtOriUP.text * txtPUsage.text
             txtAmtRM.text = txtUPRM.text * txtPUsage.text
         End Sub
    
    
         Sub UpdateHighestVendor(MainPart as string,PartNo as string)
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim strSql as string = "Select top 1 PS.UP_APP_NO,ven.curr_code,ven.ven_name,PS.Ven_Code,ps.UP,ps.lead_time,ps.up_app_date,ps.std_pack_qty,ps.min_order_qty from Part_Source PS,vendor ven where ps.ven_code = ven.ven_code and PS.part_no = '" & trim(PartNo) & "' order by PS.UP desc"
             Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
             myConnection.Open()
             Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
             Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
             do while drGetFieldVal.read
                 if isdbnull(drGetFieldVal("UP_APP_Date")) = false then
                     StrSql = "Update BOM_Quote_D set Highest_Ref_No = '" & trim(drGetFieldVal("UP_APP_No")) & "',Highest_curr_code = '" & trim(drGetFieldVal("Curr_Code")) & "',Highest_Ven_Name = '" & trim(drGetFieldVal("Ven_Name")) & "',Highest_Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "',highest_ori_up = " & cdec(drGetFieldVal("UP")) & ",highest_lt = " & drGetFieldVal("Lead_Time") & ",highest_date = '" & cdate(drGetFieldVal("UP_APP_Date")) & "',highest_spq = " & drGetFieldVal("Std_Pack_Qty") & ",highest_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';"
                     ReqCOM.ExecuteNonQuery(StrSql)
                 elseif isdbnull(drGetFieldVal("UP_APP_Date")) = true then
                     StrSql = "Update BOM_Quote_D set Highest_Ref_No = '" & trim(drGetFieldVal("UP_APP_No")) & "',Highest_curr_code = '" & trim(drGetFieldVal("Curr_Code")) & "',Highest_Ven_Name = '" & trim(drGetFieldVal("Ven_Name")) & "',Highest_Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "',highest_ori_up = " & cdec(drGetFieldVal("UP")) & ",highest_lt = " & drGetFieldVal("Lead_Time") & ",highest_spq = " & drGetFieldVal("Std_Pack_Qty") & ",highest_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';"
                     ReqCOM.ExecuteNonQuery(StrSql)
                 end if
             loop
             drGetFieldVal.close()
             myCommand.dispose()
             myConnection.Close()
             myConnection.Dispose()
         End sub
    
    
         Sub UpdateLowestVendor(MainPart as string,PartNo as string)
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim strSql as string = "Select top 1 ps.up_app_no,ven.curr_code,ven.ven_name,PS.Ven_Code,ps.UP,ps.lead_time,ps.up_app_date,ps.std_pack_qty,ps.min_order_qty from Part_Source PS,vendor ven where ps.ven_code = ven.ven_code and PS.part_no = '" & trim(PartNo) & "' order by PS.UP asc"
             Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
             myConnection.Open()
             Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
             Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
             do while drGetFieldVal.read
                 if isdbnull(drGetFieldVal("UP_APP_Date")) = false then ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set lowest_ref_no = '" & trim(drGetFieldVal("UP_APP_No")) & "', Lowest_curr_code = '" & trim(drGetFieldVal("Curr_Code")) & "',Lowest_Ven_Name = '" & trim(drGetFieldVal("Ven_Name")) & "',Lowest_Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "',Lowest_ori_up = " & cdec(drGetFieldVal("UP")) & ",lowest_lt = " & drGetFieldVal("Lead_Time") & ",lowest_date = '" & cdate(drGetFieldVal("UP_APP_Date")) & "',lowest_spq = " & drGetFieldVal("Std_Pack_Qty") & ",lowest_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
                 if isdbnull(drGetFieldVal("UP_APP_Date")) = true then ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set lowest_ref_no = '" & trim(drGetFieldVal("UP_APP_No")) & "', Lowest_curr_code = '" & trim(drGetFieldVal("Curr_Code")) & "',Lowest_Ven_Name = '" & trim(drGetFieldVal("Ven_Name")) & "',Lowest_Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "',Lowest_ori_up = " & cdec(drGetFieldVal("UP")) & ",lowest_lt = " & drGetFieldVal("Lead_Time") & ",lowest_spq = " & drGetFieldVal("Std_Pack_Qty") & ",lowest_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
             loop
             drGetFieldVal.close()
             myCommand.dispose()
             myConnection.Close()
             myConnection.Dispose()
         End sub
    
         Sub cmdSearchVen_Click(sender As Object, e As EventArgs)
             Dissql ("Select Ven_Name,Ven_Code from Vendor where Ven_Code + Ven_Name like '%" & trim(txtSearchVen.text) & "%';","Ven_Code","Ven_Name",cmbSearchVen)
    
             if cmbSearchVen.selectedindex = -1 then
                 Dim oList As ListItemCollection = cmbSearchVen.Items
                 oList.Add(New ListItem(txtSearchVen.text))
             end if
         End Sub
    
    Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        e.isvalid = true
        if trim(ucase(txtPartNo.text)) <> trim(ucase(lblPartNo.text)) then
            if ReqCOM.FuncCheckDuplicate("Select Part_No from Part_Master where Part_No = '" & trim(txtPartNo.text) & "';","Part_No") = false then e.isvalid = false
        end if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">BOM
                                QUOTATION DETAILS - PART DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtPUsage" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Usage." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtOriUP" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Original Target Unit Cost." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtMOQ" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid MOQ." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ControlToValidate="txtSPQ" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid SPQ." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ControlToValidate="txtLeadTime" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Lead Time." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" ControlToValidate="txtSPQ" Display="Dynamic" ForeColor=" " ErrorMessage="SPQ must be an integer value." CssClass="ErrorText" Width="100%" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator2" runat="server" ControlToValidate="txtMOQ" Display="Dynamic" ForeColor=" " ErrorMessage="MOQ must be an integer value." CssClass="ErrorText" Width="100%" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator3" runat="server" ControlToValidate="txtLeadTime" Display="Dynamic" ForeColor=" " ErrorMessage="Lead Time must be an integer value." CssClass="ErrorText" Width="100%" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator4" runat="server" ControlToValidate="txtPUsage" Display="Dynamic" ForeColor=" " ErrorMessage="Usage must be an integer value." CssClass="ErrorText" Width="100%" Type="Double" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator5" runat="server" ControlToValidate="txtOriUP" Display="Dynamic" ForeColor=" " ErrorMessage="Target Unit Price must be a currency value." CssClass="ErrorText" Width="100%" Type="Double" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator8" runat="server" ControlToValidate="txtPUsage" Display="Dynamic" ForeColor=" " ErrorMessage="Usage Must be greater than 0." CssClass="ErrorText" Width="100%" Type="Double" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                    <asp:CustomValidator id="ValDateInput" runat="server" Display="Dynamic" ForeColor=" " ErrorMessage="" CssClass="ErrorText" Width="100%" EnableClientScript="False" OnServerValidate="ValDateInput_ServerValidate">You don't seem to have supplied a valid part no.</asp:CustomValidator>
                                                </p>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="128px">Quotation
                                                                    #</asp:Label></td>
                                                                <td width="75%" colspan="3">
                                                                    <p>
                                                                        <asp:Label id="lblBOMQuoteNo" runat="server" cssclass="OutputText"></asp:Label><asp:Label id="lblSelPartNo" runat="server" cssclass="OutputText" visible="False"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Revision</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:Label id="lblBOMQuoteRev" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal">Model Details</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label><asp:Label id="lblVenCode" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblMainPart" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="131px">Part #</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtPartNo" runat="server" CssClass="OutputText" Width="168px"></asp:TextBox>
                                                                    <asp:Label id="lblPartNo" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label20" runat="server" cssclass="LabelNormal" width="131px">Customer
                                                                    Part #</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtCustPartNo" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtPartDesc" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="105px">Specification</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtPartSpec" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="121px">Mfg Name</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtMFGName" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="122px">Manufacturer
                                                                    Part #</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtMfgMPN" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="122px">Usage</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <asp:TextBox id="txtPUsage" runat="server" CssClass="ReqText" Width="163px"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="122px">Target
                                                                    Ori. Curr</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <asp:DropDownList id="cmbOriCurr" runat="server" CssClass="ReqText" Width="163px"></asp:DropDownList>
                                                                        <asp:Label id="txtOriCurr1" runat="server"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label23" runat="server" cssclass="LabelNormal" width="100%">Target
                                                                    Unit Cost(Ori. Curr)</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <asp:TextBox id="txtOriUP" runat="server" CssClass="ReqText" Width="163px" Enabled="False"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="122px">Target
                                                                    Unit Cost(RM)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtUPRM" runat="server" CssClass="OutputText" Width="163px" Enabled="False"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label27" runat="server" cssclass="LabelNormal" width="122px">Target
                                                                    Amt(Ori. Curr)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtOriAmt" runat="server" CssClass="OutputText" Width="163px" Enabled="False"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label28" runat="server" cssclass="LabelNormal" width="122px">Target
                                                                    Amt (RM)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtAmtRM" runat="server" CssClass="OutputText" Width="163px" Enabled="False"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label29" runat="server" cssclass="LabelNormal" width="122px">Supplier</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <asp:TextBox id="txtSearchVen" onkeydown="KeyDownHandler(cmdSearchVen)" onclick="GetFocus(txtSearchVen)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                        <asp:Button id="cmdSearchVen" onclick="cmdSearchVen_Click" runat="server" CssClass="OutputText" CausesValidation="False" Height="20px" Text="GO"></asp:Button>
                                                                        <asp:DropDownList id="cmbSearchVen" runat="server" CssClass="OutputText" Width="355px" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label30" runat="server" cssclass="LabelNormal" width="122px">Lead Time</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtLeadTime" runat="server" CssClass="ReqText" Width="163px" Enabled="False"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label31" runat="server" cssclass="LabelNormal" width="122px">SPQ</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSPQ" runat="server" CssClass="ReqText" Width="163px" Enabled="False"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label33" runat="server" cssclass="LabelNormal" width="122px">MOQ</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtMOQ" runat="server" CssClass="ReqText" Width="163px" Enabled="False"></asp:TextBox>
                                                                    &nbsp;<asp:Button id="cmdCalculate" onclick="cmdCalculate_Click_1" runat="server" Text="Calculate"></asp:Button>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label39" runat="server" cssclass="LabelNormal" width="122px">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="33%">
                                                                    <p>
                                                                        <asp:Button id="cmdSaveAndExit" onclick="cmdSaveAndExit_Click" runat="server" Width="91px" Text="Update"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="34%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdSaveAnother" onclick="cmdSaveAnother_Click" runat="server" Width="184px" Text="Save and Add Another Part" Visible="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
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
    <!-- Insert content here -->
</body>
</html>
