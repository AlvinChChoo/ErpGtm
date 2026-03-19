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
             if page.ispostback = false then
                 Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                 Dim CurrCode as string
                 Dim HighUP,LowUP as decimal
                 if trim(Request.params("MainPartB4")) <> "-" then
                     Dim rs1 as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 * from Part_Master where Seq_no = '" & Request.params("ID") & "';")
                     Do while rs1.read
                        lblPartSpec.text = rs1("Part_Spec")
                        lblPartDesc.text = rs1("Part_Desc")
                        lblPartNo.text = rs1("Part_No")
                        lblMfgPartNo.text = rs1("M_Part_No")
                        lblMFGName.text = rs1("MFG")
                        lblRefModel.text = rs1("Ref_Model").tostring
    
                        lblRefSuppRD.text = rs1("REF_SUPP_RD").tostring
                        lblRawMatCostRD.text = rs1("Raw_Mat_Cost_RD").tostring
                        lblRawMatRD.text = rs1("Raw_Mat_RD").tostring
                        lblMOQRD.text = rs1("MOQ_RD").tostring
                        lblSPQRD.text = rs1("SPQ_RD").tostring
                        lblStdCostRD.text = rs1("Std_Cost_RD").tostring
                        lblCurrCodeRD.text = rs1("Std_Cost_rd_curr_code").tostring
                        lblOriStdCostRD.text = rs1("Ori_Std_cost_rd").tostring
                        lblUOMRD.text = rs1("UOM_rd").tostring
                        lblLeadTimeRD.text = rs1("Lead_Time_RD").tostring
                        ' if cdec(lblStdCostRD.text) = 0 then lblStdCostRD.text = "":Label20.visible = false:lblCurrCodeRD.text = ""
                        if cdec(lblOriStdCostRD.text) = 0 then lblOriStdCostRD.text = ""
    
                        'txtRefSuppPurc.text = rs1("REF_SUPP_Purc").tostring
                        txtRawMatCostPurc.text = rs1("Raw_Mat_Cost_Purc").tostring
                        txtRawMatPurc.text = rs1("Raw_Mat_Purc").tostring
                        txtMOQPurc.text = rs1("MOQ_Purc").tostring
                        txtSPQPurc.text = rs1("SPQ_Purc").tostring
                        lblStdCostPurc.text = rs1("Std_Cost_Purc").tostring
                        txtOriStdCostPurc.text = rs1("Ori_Std_cost_Purc").tostring
                        txtUOMPurc.text = rs1("UOM_purc").tostring
                        txtLeadTimePurc.text = rs1("Lead_Time_purc").tostring
                        if cdec(txtOriStdCostPurc.text) = 0 then txtOriStdCostPurc.text = ""
                        if cdec(lblStdCostPurc.text) = 0 then lblStdCostPurc.text = ""
                        Dissql("Select * from Curr where curr_code <> '-'","Curr_Code","Curr_Desc",cmbCurrCodePurc)
    
                        'lblWAC.text = format(cdec(rs1("WAC_Cost")),"##,##0.00000")
    
                        if isdbnull(rs1("WAC_Cost")) = false then lblWAC.text = format(cdec(rs1("WAC_Cost")),"##,##0.00000")
                        if isdbnull(rs1("WAC_Cost")) = true then lblWAC.text = "0"
    
                        lblStdDate.text = rs1("Purc_Cost_Date").tostring
                        lblStdUP.text = rs1("Std_Cost_Purc").tostring
                        lblStdCurr.text = rs1("Std_Cost_Purc_Curr_Code").tostring
                        lblStdOriUP.text = rs1("Ori_Std_Cost_Purc").tostring
                        lblStdLT.text = rs1("Lead_Time_Purc").tostring
                        lblStdSPQ.text = rs1("SPQ_Purc").tostring
                        lblStdMOQ.text = rs1("MOQ_Purc").tostring
                        lblStdVenName.text = rs1("Ref_Supp_Purc").tostring
    
    
                        if isdbnull(rs1("Std_Cost_purc_curr_code")) = false then
                            CurrCode = rs1("Std_Cost_purc_curr_code").tostring
                            CurrCode = ReqCom.GetFieldVal("Select Curr_Code from Curr where Curr_Code = '" & trim(CUrrCOde) & "';","Curr_Code")
                            cmbCurrCodePurc.Items.FindByValue(CurrCode).Selected = True
                        end if
    
                     loop
                     rs1.close()
                 end if
                Update1stSupplier
                UpdateHighUP
                UpdateLowUP
                UpdateLastQuote
    
                if trim(lblHighUP.text) <> "" then HighUP = cdec(lblHighUP.text)
                if trim(lblHighUP.text) = "" then HighUP = 0
    
                if trim(lblLowUP.text) <> "" then LowUP = cdec(lblLowUP.text)
                if trim(lblLowUP.text) = "" then LowUP = 0
    
    
    
                 lblAverageHiLo.text = format(cdec((cdec(HighUP) + cdec(LowUP))/2),"##,##0.00000")
                 lblWACDate.text = format(cdate(ReqCOM.GetFieldVal("select Last_WAC_Date from Main","Last_WAC_Date")),"dd/MM/yy")
    
             end if
         End Sub
    
         Sub cmdBack_Click(sender As Object, e As EventArgs)
             Response.redirect("PartWithoutStdCost.aspx")
         End Sub
    
         Sub cmdUpdate_Click(sender As Object, e As EventArgs)
             if page.isvalid = true then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim StdCost as decimal
                StdCost = ReqCOM.GetFieldVal("select top 1 Std_Cost_RD from part_Master where part_no = '" & trim(lblPartNo.text) & "';","Std_Cost_RD")
                if Cdec(StdCost) = 0 then
                    if trim(cmbSearchVen.selecteditem.value) = trim(cmbSearchVen.selecteditem.text) then ReqCOM.ExecuteNonQuery("Update Part_Master set std_cost_purc = " & cdec(lblStdCostPurc.text) & ",ori_std_cost_purc = " & cdec(txtOriStdCostPurc.text) & ",std_cost_purc_curr_code = '" & trim(cmbCurrCodePurc.selecteditem.value) & "',SPQ_Purc = " & clng(txtSPQPurc.text) & ",moq_purc = " & clng(txtMOQPurc.text) & ",raw_mat_purc = '" & trim(txtRawMatPurc.text) & "',raw_mat_cost_purc = " & cdec(txtRawMatCostPurc.text) & ",Ref_Supp_Purc = '" & trim(cmbSearchVen.selecteditem.text) & "',Ref_Supp_code_Purc = 'TempSupplier',std_cost_rd = " & cdec(lblStdCostPurc.text) & ",ori_std_cost_rd = " & cdec(txtOriStdCostPurc.text) & ",std_cost_rd_curr_code = '" & trim(cmbCurrCodePurc.selecteditem.value) & "',SPQ_rd = " & clng(txtSPQPurc.text) & ",moq_rd = " & clng(txtMOQPurc.text) & ",raw_mat_rd = '" & trim(txtRawMatPurc.text) & "',raw_mat_cost_rd = " & cdec(txtRawMatCostPurc.text) & ",Ref_Supp_rd = '" & trim(cmbSearchVen.selecteditem.text) & "',Ref_Supp_Code_rd = 'TempSupplier',uom_purc = '" & trim(txtUOMPurc.text) & "',uom_rd = '" & trim(txtUOMPurc.text) & "',Lead_Time_RD = " & clng(txtLeadTimePurc.text) & ", Lead_Time_Purc = " & clng(txtLeadTimePurc.text) & " where seq_no = " & request.params("ID") & ";")
                    if trim(cmbSearchVen.selecteditem.value) <> trim(cmbSearchVen.selecteditem.text) then ReqCOM.ExecuteNonQuery("Update Part_Master set std_cost_purc = " & cdec(lblStdCostPurc.text) & ",ori_std_cost_purc = " & cdec(txtOriStdCostPurc.text) & ",std_cost_purc_curr_code = '" & trim(cmbCurrCodePurc.selecteditem.value) & "',SPQ_Purc = " & clng(txtSPQPurc.text) & ",moq_purc = " & clng(txtMOQPurc.text) & ",raw_mat_purc = '" & trim(txtRawMatPurc.text) & "',raw_mat_cost_purc = " & cdec(txtRawMatCostPurc.text) & ",Ref_Supp_Purc = '" & trim(cmbSearchVen.selecteditem.text) & "',Ref_Supp_code_Purc = '" & trim(cmbSearchVen.selecteditem.value) & "',std_cost_rd = " & cdec(lblStdCostPurc.text) & ",ori_std_cost_rd = " & cdec(txtOriStdCostPurc.text) & ",std_cost_rd_curr_code = '" & trim(cmbCurrCodePurc.selecteditem.value) & "',SPQ_rd = " & clng(txtSPQPurc.text) & ",moq_rd = " & clng(txtMOQPurc.text) & ",raw_mat_rd = '" & trim(txtRawMatPurc.text) & "',raw_mat_cost_rd = " & cdec(txtRawMatCostPurc.text) & ",Ref_Supp_rd = '" & trim(cmbSearchVen.selecteditem.text) & "',Ref_Supp_Code_rd = '" & trim(cmbSearchVen.selecteditem.value) & "',uom_purc = '" & trim(txtUOMPurc.text) & "',uom_rd = '" & trim(txtUOMPurc.text) & "',Lead_Time_RD = " & clng(txtLeadTimePurc.text) & ", Lead_Time_Purc = " & clng(txtLeadTimePurc.text) & " where seq_no = " & request.params("ID") & ";")
                    ShowAlert("Std. Cost Updated.")
                    redirectPage("PopupPartStdCost.aspx?ID=" & Request.params("ID"))
                elseif Cdec(StdCost) <> 0 then
                    if trim(cmbSearchVen.selecteditem.value) = trim(cmbSearchVen.selecteditem.text) then ReqCOM.ExecuteNonQuery("Update Part_Master set std_cost_purc = " & cdec(lblStdCostPurc.text) & ",ori_std_cost_purc = " & cdec(txtOriStdCostPurc.text) & ",std_cost_purc_curr_code = '" & trim(cmbCurrCodePurc.selecteditem.value) & "',SPQ_Purc = " & clng(txtSPQPurc.text) & ",moq_purc = " & clng(txtMOQPurc.text) & ",raw_mat_purc = '" & trim(txtRawMatPurc.text) & "',raw_mat_cost_purc = " & cdec(txtRawMatCostPurc.text) & ",Ref_Supp_Purc = '" & trim(cmbSearchVen.selecteditem.text) & "',Ref_Supp_Code_Purc = 'TempSupplier',uom_purc = '" & trim(txtUOMPurc.text) & "',Lead_Time_Purc = " & clng(txtLeadTimePurc.text) & " where seq_no = " & request.params("ID") & ";")
                    if trim(cmbSearchVen.selecteditem.value) <> trim(cmbSearchVen.selecteditem.text) then ReqCOM.ExecuteNonQuery("Update Part_Master set std_cost_purc = " & cdec(lblStdCostPurc.text) & ",ori_std_cost_purc = " & cdec(txtOriStdCostPurc.text) & ",std_cost_purc_curr_code = '" & trim(cmbCurrCodePurc.selecteditem.value) & "',SPQ_Purc = " & clng(txtSPQPurc.text) & ",moq_purc = " & clng(txtMOQPurc.text) & ",raw_mat_purc = '" & trim(txtRawMatPurc.text) & "',raw_mat_cost_purc = " & cdec(txtRawMatCostPurc.text) & ",Ref_Supp_Purc = '" & trim(cmbSearchVen.selecteditem.text) & "',Ref_Supp_Code_Purc = '" & trim(cmbSearchVen.selecteditem.value) & "',uom_purc = '" & trim(txtUOMPurc.text) & "',Lead_Time_Purc = " & clng(txtLeadTimePurc.text) & " where seq_no = " & request.params("ID") & ";")
                    ShowAlert("Std. Cost Updated.")
                    redirectPage("PopupPartStdCost.aspx?ID=" & Request.params("ID"))
                end if
             end if
         End Sub
    
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
    
         Sub cmdCalculatePurc_Click(sender As Object, e As EventArgs)
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim Rate,UnitConv as decimal
    
             Rate = ReqCOM.GetFieldVal("Select Rate from Curr where curr_code = '" & trim(cmbCurrCodePurc.selecteditem.value) & "';","Rate")
             UnitConv = ReqCOM.GetFieldVal("Select Unit_Conv from Curr where curr_code = '" & trim(cmbCurrCodePurc.selecteditem.value) & "';","Unit_Conv")
    
             lblStdCostPurc.text = format(cdec((txtOriStdCostPurc.text * Rate) / UnitConv),"##,##0.0000")
         End Sub
    
        Sub redirectPage(ReturnURL as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
            If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
        End sub
    
        Sub Update1stSupplier()
            Dim Rate as decimal
            Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim strSql as string = "Select top 1 * from Part_Source where Part_No = '" & trim(lblPartNo.text) & "' order by ven_seq asc;"
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            do while drGetFieldVal.read
                lbl1stDate.text = drGetFieldVal("UP_APP_Date").tostring
                if trim(lbl1stDate.text) <> "" then lbl1stDate.text = format(cdate(lbl1stDate.text),"dd/MM/yy")
                lbl1stOriUP.text = format(cdec(drGetFieldVal("UP").tostring))
                lbl1stLT.text = clng(drGetFieldVal("Lead_Time").tostring)
                lbl1stSPQ.text = clng(drGetFieldVal("Std_Pack_Qty").tostring)
                lbl1stMOQ.text = clng(drGetFieldVal("Min_Order_Qty").tostring)
                lbl1stOriCurr.text = ReqCOM.GetFieldVal("select Curr_Code from Vendor where ven_code = '" & drGetFieldVal("Ven_Code") & "';","Curr_Code")
                lbl1stRefNo.text = drGetFieldVal("UP_APP_No").tostring
                lbl1stVenName.text = ReqCOM.GetFieldVal("select Ven_Name from Vendor where ven_code = '" & drGetFieldVal("Ven_Code") & "';","Ven_Name")
                Rate = ReqCOM.GetFieldVal("select Rate / Unit_Conv as [Rate] from Curr where curr_code = '" & trim(lbl1stOriCurr.text) & "';","Rate")
                lbl1stUP.text = format(cdec(cdec(drGetFieldVal("UP")) * cdec(Rate)),"##,##0.00000")
            loop
            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End sub
    
        Sub UpdateHighUP()
            Dim Rate as decimal
            Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim strSql as string = "Select top 1 * from Part_Source where Part_No = '" & trim(lblPartNo.text) & "' order by UP desc"
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            do while drGetFieldVal.read
                lblhighDate.text = drGetFieldVal("UP_APP_Date").tostring
                if trim(lblhighDate.text) <> "" then lblhighDate.text = format(cdate(lblhighDate.text),"dd/MM/yy")
                lblhighOriUP.text = format(cdec(drGetFieldVal("UP").tostring))
                lblhighLT.text = clng(drGetFieldVal("Lead_Time").tostring)
                lblhighSPQ.text = clng(drGetFieldVal("Std_Pack_Qty").tostring)
                lblhighMOQ.text = clng(drGetFieldVal("Min_Order_Qty").tostring)
                lblhighOriCurr.text = ReqCOM.GetFieldVal("select Curr_Code from Vendor where ven_code = '" & drGetFieldVal("Ven_Code") & "';","Curr_Code")
                lblhighRefNo.text = drGetFieldVal("UP_APP_No").tostring
                lblhighVenName.text = ReqCOM.GetFieldVal("select Ven_Name from Vendor where ven_code = '" & drGetFieldVal("Ven_Code") & "';","Ven_Name")
                Rate = ReqCOM.GetFieldVal("select Rate / Unit_Conv as [Rate] from Curr where curr_code = '" & trim(lbl1stOriCurr.text) & "';","Rate")
                lblhighUP.text = format(cdec(cdec(drGetFieldVal("UP")) * cdec(Rate)),"##,##0.00000")
            loop
            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End sub
    
        Sub UpdateLowUP()
            Dim Rate as decimal
            Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim strSql as string = "Select top 1 * from Part_Source where Part_No = '" & trim(lblPartNo.text) & "' order by UP asc"
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            do while drGetFieldVal.read
                lblLowDate.text = drGetFieldVal("UP_APP_Date").tostring
                if trim(lblLowDate.text) <> "" then lblLowDate.text = format(cdate(lblLowDate.text),"dd/MM/yy")
                lblLowOriUP.text = format(cdec(drGetFieldVal("UP").tostring))
                lblLowLT.text = clng(drGetFieldVal("Lead_Time").tostring)
                lblLowSPQ.text = clng(drGetFieldVal("Std_Pack_Qty").tostring)
                lblLowMOQ.text = clng(drGetFieldVal("Min_Order_Qty").tostring)
                lblLowOriCurr.text = ReqCOM.GetFieldVal("select Curr_Code from Vendor where ven_code = '" & drGetFieldVal("Ven_Code") & "';","Curr_Code")
                lblLowRefNo.text = drGetFieldVal("UP_APP_No").tostring
                lblLowVenName.text = ReqCOM.GetFieldVal("select Ven_Name from Vendor where ven_code = '" & drGetFieldVal("Ven_Code") & "';","Ven_Name")
                Rate = ReqCOM.GetFieldVal("select Rate / Unit_Conv as [Rate] from Curr where curr_code = '" & trim(lbl1stOriCurr.text) & "';","Rate")
                lblLowUP.text = format(cdec(cdec(drGetFieldVal("UP")) * cdec(Rate)),"##,##0.00000")
            loop
            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End sub
    
        Sub UpdateLastQuote()
            Dim Rate as decimal
            Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim strSql as string = "Select top 1 * from BOM_Quote_D where Part_No = '" & trim(lblPartNo.text) & "' order by bom_quote_no desc"
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            do while drGetFieldVal.read
                lblLastQuoteUP.text = drGetFieldVal("target_up_rm").tostring
                lblLastQuoteCurr.text = drGetFieldVal("target_ori_curr").tostring
                lblLastQuoteOriUP.text = drGetFieldVal("target_ori_up").tostring
                lblLastQuoteLT.text = drGetFieldVal("lead_time").tostring
                lblLastQuoteSPQ.text = drGetFieldVal("SPQ").tostring
                lblLastQuoteMOQ.text = drGetFieldVal("MOQ").tostring
                lblLastQuoteVenName.text = drGetFieldVal("Ven_Name").tostring
                lblLastQuoteRefNo.text = drGetFieldVal("BOM_Quote_No").tostring
    
                lblLastQuoteDate.text = ReqCOM.GetFieldVal("Select App3_Date from BOM_Quote_M where BOM_Quote_No = '" & trim(lblLastQuoteRefNo.text) & "';","App3_Date")
                if trim(lblLastQuoteDate.text) <> "<NULL>" then lblLastQuoteDate.text = format(cdate(lblLastQuoteDate.text),"dd/MM/yy")
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
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
    
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
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                            </p>
                            <p>
                                <table style="HEIGHT: 71px" width="98%" align="center">
                                    <tbody>
                                        <tr>
                                            <td width="50%">
                                                <p align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" EnableClientScript="False" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Std Cost." ForeColor=" " Display="Dynamic" ControlToValidate="txtOriStdCostPurc"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" EnableClientScript="False" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid SPQ." ForeColor=" " Display="Dynamic" ControlToValidate="txtSPQPurc"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" EnableClientScript="False" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Unit." ForeColor=" " Display="Dynamic" ControlToValidate="txtUOMPurc"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" EnableClientScript="False" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid MOQ." ForeColor=" " Display="Dynamic" ControlToValidate="txtMOQPurc"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" EnableClientScript="False" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Raw Material." ForeColor=" " Display="Dynamic" ControlToValidate="txtRawMatPurc"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" EnableClientScript="False" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Raw Material Cost." ForeColor=" " Display="Dynamic" ControlToValidate="txtRawMatCostPurc"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" EnableClientScript="False" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid MOQ." ForeColor=" " Display="Dynamic" ControlToValidate="txtMOQPurc" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator2" runat="server" EnableClientScript="False" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid SPQ." ForeColor=" " Display="Dynamic" ControlToValidate="txtSPQPurc" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator3" runat="server" EnableClientScript="False" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Std. Cost" ForeColor=" " Display="Dynamic" ControlToValidate="txtOriStdCostPurc" Type="Double" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator4" runat="server" EnableClientScript="False" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Raw Material Cost." ForeColor=" " Display="Dynamic" ControlToValidate="txtRawMatCostPurc" Type="Double" Operator="DataTypeCheck"></asp:CompareValidator>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center"><asp:Label id="Label10" runat="server" cssclass="FormDesc" width="100%">Part
                                                                        Details </asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Part #</asp:Label></td>
                                                                <td width="75%">
                                                                    <div align="left"><asp:Label id="lblPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblPartDesc" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal">Specification</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblPartSpec" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Manufacturer part No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMfgPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label39" runat="server" cssclass="LabelNormal">Manufacturer Name</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMFGName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Ref. model</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblRefModel" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center"><asp:Label id="Label12" runat="server" cssclass="FormDesc" width="100%">R
                                                                        & D Standard Cost Details </asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Currency</asp:Label></td>
                                                                <td width="75%">
                                                                    <div align="left">
                                                                        <div align="left"><asp:Label id="lblCurrCodeRD" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Std. Cost (In Ori. Curr)</asp:Label></td>
                                                                <td>
                                                                    <div align="left">
                                                                        <div align="left"><asp:Label id="lblOriStdCostRD" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Std. Cost (RM)</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblStdCostRD" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Ref. Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblRefSuppRD" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Raw Material Description</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblRawMatRD" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal">Raw Material Cost</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblRawMatCostRD" runat="server" cssclass="OutputText"></asp:Label>&nbsp; <asp:Label id="Label20" runat="server" cssclass="OutputText">per</asp:Label>&nbsp;<asp:Label id="lblUOMRD" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">SPQ.</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSPQRD" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">MOQ.</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMOQRD" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label26" runat="server" cssclass="LabelNormal">Lead Time (wks)</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLeadTimeRD" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center"><asp:Label id="Label15" runat="server" cssclass="FormDesc" width="100%">Purchasing
                                                                        Standard Cost Details </asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label18" runat="server" cssclass="LabelNormal">Currency</asp:Label></td>
                                                                <td width="75%">
                                                                    <div align="left">
                                                                        <asp:DropDownList id="cmbCurrCodePurc" runat="server" CssClass="OutputText" Width="184px"></asp:DropDownList>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label17" runat="server" cssclass="LabelNormal">Std. Cost (In Ori. Curr)</asp:Label></td>
                                                                <td>
                                                                    <div align="left">
                                                                        <div align="left">
                                                                            <asp:TextBox id="txtOriStdCostPurc" runat="server" CssClass="OutputText" Width="184px"></asp:TextBox>
                                                                            &nbsp; 
                                                                            <asp:Button id="cmdCalculatePurc" onclick="cmdCalculatePurc_Click" runat="server" CssClass="OutputText" Width="89px" CausesValidation="False" Text="Calculate"></asp:Button>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label19" runat="server" cssclass="LabelNormal">Std. Cost (RM)</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblStdCostPurc" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label25" runat="server" cssclass="LabelNormal">Ref. Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSearchVen" onkeydown="KeyDownHandler(cmdSearchVen)" onclick="GetFocus(txtSearchVen)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdSearchVen" onclick="cmdSearchVen_Click" runat="server" CssClass="OutputText" CausesValidation="False" Text="GO" Height="20px"></asp:Button>
                                                                    &nbsp; 
                                                                    <asp:DropDownList id="cmbSearchVen" runat="server" CssClass="OutputText" Width="438px" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label23" runat="server" cssclass="LabelNormal">Raw Material Description</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRawMatPurc" runat="server" CssClass="OutputText" Width="184px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label24" runat="server" cssclass="LabelNormal">Raw Material Cost</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRawMatCostPurc" runat="server" CssClass="OutputText" Width="184px"></asp:TextBox>
                                                                    &nbsp;<asp:Label id="Label27" runat="server" cssclass="OutputText">per</asp:Label>&nbsp;<asp:TextBox id="txtUOMPurc" runat="server" CssClass="OutputText" Width="79px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label21" runat="server" cssclass="LabelNormal">SPQ.</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSPQPurc" runat="server" CssClass="OutputText" Width="184px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label22" runat="server" cssclass="LabelNormal">MOQ.</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtMOQPurc" runat="server" CssClass="OutputText" Width="184px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label28" runat="server" cssclass="LabelNormal">Lead Time (wks)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtLeadTimePurc" runat="server" CssClass="OutputText" Width="184px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                </td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label29" runat="server" cssclass="LabelNormal">DD/MM/YY</asp:Label></td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label30" runat="server" cssclass="LabelNormal">IN RM</asp:Label></td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label31" runat="server" cssclass="LabelNormal">Ori. Curr</asp:Label></td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label32" runat="server" cssclass="LabelNormal">Ori. Cost</asp:Label></td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label33" runat="server" cssclass="LabelNormal">L/T</asp:Label></td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label34" runat="server" cssclass="LabelNormal">SPQ</asp:Label></td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label35" runat="server" cssclass="LabelNormal">MOQ</asp:Label></td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label36" runat="server" cssclass="LabelNormal">Supplier</asp:Label></td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label37" runat="server" cssclass="LabelNormal">Quote/UPA #</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label38" runat="server" cssclass="LabelNormal">Standard</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStdDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStdUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStdCurr" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStdOriUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStdLT" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStdSPQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStdMOQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblStdVenName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td rowspan="1">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label40" runat="server" cssclass="LabelNormal">Last Quote</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLastQuoteDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLastQuoteUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLastQuoteCurr" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLastQuoteOriUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLastQuoteLT" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLastQuoteSPQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLastQuoteMOQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLastQuoteVenName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLastQuoteRefNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label41" runat="server" cssclass="LabelNormal">1st Supp.</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lbl1stDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lbl1stUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lbl1stOriCurr" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lbl1stOriUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lbl1stLT" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lbl1stSPQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lbl1stMOQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lbl1stVenName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lbl1stRefNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label42" runat="server" cssclass="LabelNormal">Actual Lowest</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblHighDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblHighUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblHighOriCurr" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblHighOriUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblHighLT" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblHighSPQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblHighMOQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblHighVenName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblHighRefNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label43" runat="server" cssclass="LabelNormal">Actual Highest</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLowDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLowUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLowOriCurr" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLowOriUP" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLowLT" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLowSPQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLowMOQ" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLowVenName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLowRefNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label44" runat="server" cssclass="LabelNormal">Average Actual Hi Lo</asp:Label></td>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblAverageHiLo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td colspan="7" rowspan="2">
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label45" runat="server" cssclass="LabelNormal">WAC</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblWACDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblWAC" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="90px" Text="Update"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="90px" CausesValidation="False" Text="Back"></asp:Button>
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
