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
        if page.ispostback = false then
            LoadDetail
            LoadHeader
            Dissql("Select upper(Curr_Code) as [Curr_Code],upper(Curr_Desc) as [Curr_Desc] from bom_quote_curr where curr_code <> '-' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' order by curr_Desc","Curr_Code","Curr_Desc",cmbOriCurr)
        end if
    End Sub
    
    Sub LoadDetail()
        Dim StrSql as string = "Select * from BOM_Quote_D where Seq_No = " & clng(request.params("ID")) & ";"
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        do while drGetFieldVal.read
            lblBomQuoteNo.text = drGetFieldVal("Bom_Quote_No")
            lblMainPartNo.text = drGetFieldVal("Part_No")
            lblMainPartDesc.text = drGetFieldVal("Part_Desc")
            txtPUsage.text = drGetFieldVal("P_Usage")
        loop
        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
    End sub
    
    Sub LoadHeader()
        Dim StrSql as string = "Select * from BOM_Quote_M where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';"
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
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Response.redirect("BOMQuoteDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from BOM_Quote_M where BOM_Quote_no = '" & trim(lblBOMQuoteNo.text) & "';","Seq_No"))
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        SearchPart()
        if cmbPartNo.selectedindex <> -1 then lblMainPart.text = trim(cmbPartNo.selecteditem.value)
    
    End Sub
    
    Sub SearchPart()
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        cmbPartNo.items.clear
    
        if ReqCOM.funcCheckDuplicate("Select part_no from part_master where part_no = '" & trim(txtSearchPart.text) & "';","Part_No") = false then
            Dim oList As ListItemCollection = cmbPartNo.Items
            oList.Add(New ListItem(txtSearchPart.text))
            txtSearchPart.text = "-- Search --"
            txtCustPartNo.text = ""
            txtPartDesc.text = ""
            txtPartSpec.text = ""
            txtMFGName.text = ""
            txtMFGMPN.text = ""
            txtOriUP.text = "0"
            txtUPRM.text = "0"
            txtOriAmt.text = "0"
            txtAmtRM.text = "0"
            txtLeadTime.text = "0"
            txtSPQ.text = "0"
            txtMOQ.text = "0"
            txtRem.text = ""
            txtCustPartNo.enabled = true
            txtPartDesc.enabled = true
            txtPartSpec.enabled = true
            txtMFGName.enabled = true
            txtMFGMPN.enabled = true
            txtOriUP.enabled = true
            txtUPRM.enabled = true
            txtOriAmt.enabled = true
            txtAmtRM.enabled = true
            txtLeadTime.enabled = true
            txtSPQ.enabled = true
            txtMOQ.enabled = true
            txtSearchVen.visible = true
            cmbSearchVen.items.clear
            cmbSearchVen.enabled = true
            cmdSearchVen.visible = true
        else
            Dissql ("Select distinct(Part_No),Part_No, Part_No + '|' + Part_Desc as [Desc] from Part_Master where Part_No like '%" & trim(txtSearchPart.text) & "%';","Part_No","Desc",cmbPartNo)
            txtPartDesc.text = ReqCOm.GetFieldVal("Select Part_Desc from Part_Master where part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Part_Desc")
            txtPartSpec.text = ReqCOm.GetFieldVal("Select Part_Spec from Part_Master where part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Part_Spec")
            txtMfgMPN.text = ReqCOm.GetFieldVal("Select M_Part_No from Part_Master where part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","M_Part_No")
            ShowCostDet
            txtCustPartNo.enabled = false
            txtPartDesc.enabled = false
            txtPartSpec.enabled = false
            txtMFGName.enabled = false
            txtMFGMPN.enabled = false
            txtOriUP.enabled = false
            txtUPRM.enabled = false
            txtOriAmt.enabled = false
            txtAmtRM.enabled = false
            txtLeadTime.enabled = false
            txtSPQ.enabled = false
            txtMOQ.enabled = false
            txtSearchVen.visible = false
            cmbSearchVen.enabled = false
            cmdSearchVen.visible = false
    
            Dissql ("Select Ven_Name,Ven_Code from Vendor where Ven_Code = '" & trim(lblVenCOde.text) & "';","Ven_Code","Ven_Name",cmbSearchVen)
    
            if cmbSearchVen.selectedindex = -1 then
                Dim oList As ListItemCollection = cmbSearchVen.Items
                oList.Add(New ListItem("TempSupplier"))
            end if
    
            'obj.Items.FindByText("").Selected = True
    
        end if
    End sub
    
    Sub ShowCostDet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim Rate,UnitConv as decimal
    
        if trim(cmbPartNo.selectedindex) <> -1 then
            if ReqCOM.FuncCheckDuplicate("Select top 1 ori_std_cost_purc,part_no from part_master where ori_std_cost_purc > 0 and part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Part_No") = true then
                Dim StrSql as string = "Select top 1 * from Part_Master where Part_No = '" & trim(cmbPartNo.selecteditem.value) & "';"
                Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
                cnnGetFieldVal.Open()
                Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
                Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
                Dim CurrCode as string
    
                do while drGetFieldVal.read
                    lblVenCode.text = drGetFieldVal("ref_supp_code_purc")
    
                    'CurrCode = ReqCOM.GetFieldVal("Select Curr_Code from Vendor where ven_Code = '" & trim(lblVenCOde.text) & "';","Curr_Code")
                    cmbOriCurr.Items.Clear
                    Dissql("Select Curr_Code,Curr_Desc from bom_quote_curr where curr_code <> '-' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' order by curr_Desc","Curr_Code","Curr_Desc",cmbOriCurr)
    
                    'response.write(CurrCode)
                    'cmbOriCurr.Items.FindByValue(trim(CurrCode)).Selected = True
    
                    'response.write (drGetFieldVal("Std_Cost_Purc_Curr_Code"))
                    cmbOriCurr.Items.FindByValue(trim(ucase(drGetFieldVal("Std_Cost_Purc_Curr_Code")))).Selected = True
    
                    'drGetFieldVal("ref_supp_code_purc")
    
                    'Std_Cost_Purc_Curr_Code
    
    
                    txtOriUP.text = drGetFieldVal("ori_std_cost_purc")
                    Rate = ReqCOM.GetFieldVal("Select Rate from BOM_Quote_Curr where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and Curr_Code = '" & trim(cmbOriCurr.selecteditem.value) & "';","Rate")
                    UnitConv = ReqCOM.GetFieldVal("Select Unit_Conv from BOM_Quote_Curr where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and Curr_Code = '" & trim(cmbOriCurr.selecteditem.value) & "';","Unit_Conv")
                    txtUPRM.text = (txtOriUP.text * Rate ) / UnitConv
                    txtLeadTime.text = clng(drGetFieldVal("lead_time_purc"))
                    txtSPQ.text = clng(drGetFieldVal("SPQ_Purc"))
                    txtmoq.text = clng(drGetFieldVal("MOQ_Purc"))
    
                    txtPUsage.text = ReqCOM.GetFieldVal("Select top 1 P_Usage from BOM_Quote_D where seq_no = " & clng(request.params("ID")) & ";","P_Usage")
    
                loop
                myCommand.dispose()
                drGetFieldVal.close()
                cnnGetFieldVal.Close()
                cnnGetFieldVal.Dispose()
                txtSPQ.enabled = false
                txtmoq.enabled = false
                txtLeadTime.enabled = false
                CalculateQty
            else
                cmbOriCurr.Items.Clear
                Dissql("Select Curr_Code,Curr_Desc from bom_quote_curr where curr_code <> '-' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' order by curr_Desc","Curr_Code","Curr_Desc",cmbOriCurr)
                cmbOriCurr.Items.FindByValue("RM").Selected = True
                'txtPUsage.text = "0"
                txtPUsage.text = ReqCOM.GetFieldVal("Select top 1 P_Usage from BOM_Quote_D where seq_no = " & clng(request.params("ID")) & ";","P_Usage")
                txtOriUP.text = "0"
                txtLeadTime.text = "0"
                txtmoq.text = "0"
                txtSPQ.text = "0"
                txtLeadTime.text = "0"
                CalculateQty
            End if
    
            'if ReqCOm.GetFieldVal("Select Highest_UP from Part_Master where part_no = '" & trim(cmbPartNo.selecteditem.value) & "'","Highest_UP") = 0 then
            '    cmbOriCurr.Items.Clear
            '    Dissql("Select Curr_Code,Curr_Desc from bom_quote_curr where curr_code <> '-' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' order by curr_Desc","Curr_Code","Curr_Desc",cmbOriCurr)
            '    cmbOriCurr.Items.FindByValue("RM").Selected = True
            '    txtPUsage.text = "0"
            '    txtOriUP.text = "0"
            '    txtLeadTime.text = "0"
            '    txtmoq.text = "0"
            '    txtSPQ.text = "0"
            '    txtLeadTime.text = "0"
            'else
            '    Dim StrSql as string = "Select top 1 * from Part_Source where Part_No = '" & trim(cmbPartNo.selecteditem.value) & "' order by ven_seq asc"
            '    Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            '    cnnGetFieldVal.Open()
            '    Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
            '    Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
            '    Dim CurrCode as string
            '    do while drGetFieldVal.read
            '        lblVenCode.text = drGetFieldVal("Ven_Code")
            '        CurrCode = ReqCOM.GetFieldVal("Select Curr_Code from Vendor where ven_Code = '" & trim(lblVenCOde.text) & "';","Curr_Code")
            '        cmbOriCurr.Items.Clear
            '        Dissql("Select Curr_Code,Curr_Desc from bom_quote_curr where curr_code <> '-' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' order by curr_Desc","Curr_Code","Curr_Desc",cmbOriCurr)
            '        cmbOriCurr.Items.FindByValue(trim(CurrCode)).Selected = True
            '        txtOriUP.text = drGetFieldVal("UP")
            '        Rate = ReqCOM.GetFieldVal("Select Rate from BOM_Quote_Curr where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and Curr_Code = '" & trim(cmbOriCurr.selecteditem.value) & "';","Rate")
            '        UnitConv = ReqCOM.GetFieldVal("Select Unit_Conv from BOM_Quote_Curr where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and Curr_Code = '" & trim(cmbOriCurr.selecteditem.value) & "';","Unit_Conv")
            '        txtUPRM.text = (txtOriUP.text * Rate ) / UnitConv
            '        txtLeadTime.text = clng(drGetFieldVal("Lead_Time"))
            '        txtSPQ.text = clng(drGetFieldVal("Std_Pack_Qty"))
            '        txtmoq.text = clng(drGetFieldVal("Min_Order_Qty"))
            '    loop
            '    myCommand.dispose()
            '    drGetFieldVal.close()
            '    cnnGetFieldVal.Close()
            '    cnnGetFieldVal.Dispose()
            '    txtSPQ.enabled = false
            '    txtmoq.enabled = false
            '    txtLeadTime.enabled = false
            'End if
        end if
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
            Dim i as integer
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim WACTemp,StdCostTemp,AverageCostTemp,HighestUP,LowestUP as string
            Dim HighestCost as decimal
            Dim PartNoTemp as string
            Dim PartNo as String
            Dim MainPartT,PartNoT as string
            MainPartT = trim(cmbPartNo.selecteditem.value)
    
            if trim(cmbPartNo.selecteditem.value) = trim(cmbPartNo.selecteditem.text) then
            '''''''''
            '    Dim StrSql as string
            '    Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            '    if trim(cmbSearchVen.selecteditem.value) = trim(cmbSearchVen.selecteditem.text) then
            '        StrSql = "Insert into BOM_Quote_D(Main_Part,BOM_QUOTE_NO,PART_NO,MFG_MPN,CUST_PART_NO,PART_DESC,PART_SPEC,MFG_NAME,P_USAGE,DET_GEN) "
            '        StrSql = StrSql & "Select '" & trim(MainPartT) & "','" & trim(lblBomQuoteNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "','" & trim(txtMFGMpn.text) & "','" & trim(txtCustPartNo.text) & "','" & trim(txtPartDesc.text) & "','" & trim(txtPartSpec.text) & "','" & trim(txtMFGName.text) & "'," & trim(txtPUsage.text) & ",'N'"
            '        ReqCOM.ExecuteNonQuery(StrSql)
            '    elseif trim(cmbSearchVen.selecteditem.value) <> trim(cmbSearchVen.selecteditem.text) then
            '        StrSql = "Insert into BOM_Quote_D(Main_Part,BOM_QUOTE_NO,PART_NO,P_USAGE,REM,Det_Gen) "
            '        StrSql = StrSql & "Select '" & trim(MainPartT) & "','" & trim(lblBomQuoteNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "'," & trim(txtPUsage.text) & ",'" & trim(txtRem.text) & "','N'"
            '        ReqCOM.ExecuteNonQuery(StrSql)
            '    end if
            '''''''''
                Response.redirect ("BOMQuotePartDet.aspx?ID=" & Request.params("ID"))
            elseif trim(cmbPartNo.selecteditem.value) <> trim(cmbPartNo.selecteditem.text) then
                SaveDet(trim(lblMainPartNo.text),cmbPartNo.selecteditem.value)
                response.redirect("BOMQuoteUpdateCostDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from BOM_Quote_M where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';","Seq_No"))
            end if
    
    
    
    
    
        end if
    End Sub
    
    Sub SaveDet(MainPartT as string,PartNoT as string)
        Dim StrSql as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if trim(cmbSearchVen.selecteditem.value) = trim(cmbSearchVen.selecteditem.text) then
            StrSql = "Insert into BOM_Quote_D(Main_Part,BOM_QUOTE_NO,PART_NO,MFG_MPN,CUST_PART_NO,PART_DESC,PART_SPEC,MFG_NAME,P_USAGE,DET_GEN) "
            StrSql = StrSql & "Select '" & trim(lblMainPartNo.text) & "','" & trim(lblBomQuoteNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "','" & trim(txtMFGMpn.text) & "','" & trim(txtCustPartNo.text) & "','" & trim(txtPartDesc.text) & "','" & trim(txtPartSpec.text) & "','" & trim(txtMFGName.text) & "'," & trim(txtPUsage.text) & ",'N'"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            'Update Std Cost
            ReqCOM.ExecuteNonQuery("Update bom_quote_d set bom_quote_d.std_up = part_master.std_cost_purc,bom_quote_d.std_ori_up = part_master.ori_std_cost_purc,bom_quote_d.std_curr_code = part_master.std_cost_purc_curr_code,bom_quote_d.std_spq = part_master.spq_purc,bom_quote_d.std_moq = part_master.moq_purc,bom_quote_d.std_ven_code = part_master.ref_supp_code_purc,bom_quote_d.std_ven_name = part_master.ref_supp_purc from bom_quote_d,part_master where bom_quote_d.bom_quote_no = '" & trim(lblBomQuoteNo.text) & "' and bom_quote_d.main_part = '" & trim(MainPartT) & "' and bom_quote_d.part_no = '" & trim(cmbPartNo.selecteditem.value) & "'")
        elseif trim(cmbSearchVen.selecteditem.value) <> trim(cmbSearchVen.selecteditem.text) then
            StrSql = "Insert into BOM_Quote_D(Main_Part,BOM_QUOTE_NO,PART_NO,P_USAGE,REM,Det_Gen) "
            StrSql = StrSql & "Select '" & trim(MainPartT) & "','" & trim(lblBomQuoteNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "'," & trim(txtPUsage.text) & ",'" & trim(txtRem.text) & "','N'"
            ReqCOM.ExecuteNonQuery(StrSql)
            'Update Std Cost
            'ReqCOM.ExecuteNonQuery("Update bom_quote_d set bom_quote_d.std_up = part_master.std_cost_purc,bom_quote_d.std_ori_up = part_master.ori_std_cost_purc,bom_quote_d.std_curr_code = part_master.std_cost_purc_curr_code,bom_quote_d.std_spq = part_master.spq_purc,bom_quote_d.std_moq = part_master.moq_purc,bom_quote_d.std_ven_code = part_master.ref_supp_code_purc,bom_quote_d.std_ven_name = part_master.ref_supp_purc from bom_quote_d,part_master where bom_quote_d.bom_quote_no = '" & trim(lblBomQuoteNo.text) & "' and bom_quote_d.main_part = '" & trim(MainPartT) & "' and bom_quote_d.part_no = '" & trim(cmbPartNo.selecteditem.value) & "'")
        end if
    End sub
    
    Sub cmdSaveAnother_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Response.redirect("BOMQuotePartAddNew.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
            if trim(PartNo.text) = trim(cmbPartNo.selecteditem.value) then e.Item.CssClass = "Urgent"
        End if
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
    
    Sub txtSearchPart_TextChanged(sender As Object, e As EventArgs)
    
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
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" backcolor="" forecolor="">BOM
                                QUOTATION DETAILS - ADD ALTERNATE PART</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Original Target Unit Cost." ForeColor=" " Display="Dynamic" ControlToValidate="txtOriUP"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid MOQ." ForeColor=" " Display="Dynamic" ControlToValidate="txtMOQ"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid SPQ." ForeColor=" " Display="Dynamic" ControlToValidate="txtSPQ"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid Lead Time." ForeColor=" " Display="Dynamic" ControlToValidate="txtLeadTime"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="SPQ must be an integer value." ForeColor=" " Display="Dynamic" ControlToValidate="txtSPQ" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator2" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="MOQ must be an integer value." ForeColor=" " Display="Dynamic" ControlToValidate="txtMOQ" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator3" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="Lead Time must be an integer value." ForeColor=" " Display="Dynamic" ControlToValidate="txtLeadTime" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator5" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="Target Unit Price must be a currency value." ForeColor=" " Display="Dynamic" ControlToValidate="txtOriUP" Operator="DataTypeCheck" Type="Double"></asp:CompareValidator>
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
                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="131px">Main Part
                                                                    # / Desc.</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:Label id="lblMainPartNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblMainPartDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="131px">Part #</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" CssClass="OutputText" Width="78px" OnTextChanged="txtSearchPart_TextChanged">-- Search --</asp:TextBox>
                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                        <asp:DropDownList id="cmbPartNo" runat="server" CssClass="OutputText" Width="355px" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label20" runat="server" cssclass="LabelNormal" width="131px">Customer
                                                                    Part #</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtCustPartNo" runat="server" CssClass="OutputText" Width="100%" Enabled="False"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtPartDesc" runat="server" CssClass="OutputText" Width="100%" Enabled="False"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="105px">Specification</asp:Label></td>
                                                                <td colspan="3">
                                                                    <asp:TextBox id="txtPartSpec" runat="server" CssClass="OutputText" Width="100%" Enabled="False"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="121px">Mfg Name</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtMFGName" runat="server" CssClass="OutputText" Width="100%" Enabled="False"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="122px">Manufacturer
                                                                    Part #</asp:Label></td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtMfgMPN" runat="server" CssClass="OutputText" Width="100%" Enabled="False"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="122px">Usage</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <asp:TextBox id="txtPUsage" runat="server" CssClass="ReqText" Width="163px" Enabled="False"></asp:TextBox>
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
                                                                        <asp:Button id="cmdSearchVen" onclick="cmdSearchVen_Click" runat="server" CssClass="OutputText" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
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
                                                                    <asp:Button id="cmdCalculate" onclick="cmdCalculate_Click_1" runat="server" Text="Calculate"></asp:Button>
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
                                                                        <asp:Button id="cmdSaveAndExit" onclick="cmdSaveAndExit_Click" runat="server" Text="Save and Exit"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="34%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdSaveAnother" onclick="cmdSaveAnother_Click" runat="server" Width="184px" Text="Save and Add Another Part" Visible="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="136px" Text="Back" CausesValidation="False"></asp:Button>
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
