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
            LoadData()
            Dissql("Select Curr_Code,Curr_Desc from bom_quote_curr where curr_code <> '-' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' order by curr_Desc","Curr_Code","Curr_Desc",cmbOriCurr)
        end if
    End Sub
    
    Sub ShowAlt()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "Select * from Part_Master where part_no in (Select distinct(Part_No) from BOM_Alt where Main_Part = '" & trim(cmbPartNo.selecteditem.value) & "') or part_no = '" & trim(cmbPartNo.selecteditem.value) & "';"
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_Master")
        GridControl1.DataSource=resExePagedDataSet.Tables("Part_Master").DefaultView
        GridControl1.DataBind()
    End sub
    
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
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("BOMQuoteDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        SearchPart()
        if cmbPartNo.selectedindex <> -1 then lblMainPart.text = trim(cmbPartNo.selecteditem.value)
    
    
    
    End Sub
    
    Sub SearchPart()
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        cmbPartNo.items.clear
        Dissql ("Select distinct(Part_No),Part_No, Part_No + '|' + Part_Desc as [Desc] from Part_Master where Part_No like '%" & trim(txtSearchPart.text) & "%';","Part_No","Desc",cmbPartNo)
    
        if cmbPartNo.selectedindex = -1 then
            'txtSearchPart.text = "-- Search --"
            txtSearchPart.text = "-- fuck --"
    
            txtPUsage.text = "0"
            txtOriUP.text = "0"
            txtLeadTime.text = "0"
            txtmoq.text = "0"
            txtSPQ.text = "0"
            txtLowestUP.text = "0"
            txtHighestUP.text = "0"
            txtLeadTime.text = "0"
            txtLowestAmt.text = "0"
            txtHighestUP.text = "0"
            txtHighestAmt.text = "0"
            txtPartDesc.text = ""
            txtPartSpec.text = ""
            txtMfgMPN.text = ""
            txtCustPartNo.text = ""
            txtPartSpec.text = ""
            txtPartDesc.text = ""
    
        elseif cmbPartNo.selectedindex <> -1 then
            txtPartDesc.text = ReqCOm.GetFieldVal("Select Part_Desc from Part_Master where part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Part_Desc")
            txtPartSpec.text = ReqCOm.GetFieldVal("Select Part_Spec from Part_Master where part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","Part_Spec")
            txtMfgMPN.text = ReqCOm.GetFieldVal("Select M_Part_No from Part_Master where part_no = '" & trim(cmbPartNo.selecteditem.value) & "';","M_Part_No")
    
            ShowAlt
            ShowAltCost
            ShowAlt
            ShowCostDet
        end if
    End sub
    
    Sub ShowCostDet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim Rate,UnitConv as decimal
    
        if trim(lblSelPartNo.text) <> "" then
            if ReqCOm.GetFieldVal("Select Highest_UP from Part_Master where part_no = '" & trim(lblSelPartNo.text) & "'","Highest_UP") = 0 then
                cmbOriCurr.Items.Clear
                Dissql("Select Curr_Code,Curr_Desc from bom_quote_curr where curr_code <> '-' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' order by curr_Desc","Curr_Code","Curr_Desc",cmbOriCurr)
                cmbOriCurr.Items.FindByValue("RM").Selected = True
                txtPUsage.text = "0"
                txtOriUP.text = "0"
                txtLeadTime.text = "0"
                txtmoq.text = "0"
                txtSPQ.text = "0"
                txtLowestUP.text = "0"
                txtHighestUP.text = "0"
                txtLeadTime.text = "0"
                txtLowestAmt.text = "0"
                txtHighestUP.text = "0"
                txtHighestAmt.text = "0"
            else
                Dim StrSql as string = "Select top 1 * from Part_Source where Part_No = '" & trim(lblSelPartNo.text) & "' order by ven_seq asc"
                Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
                cnnGetFieldVal.Open()
                Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnGetFieldVal )
                Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
                Dim CurrCode as string
                do while drGetFieldVal.read
                    lblVenCode.text = drGetFieldVal("Ven_Code")
                    CurrCode = ReqCOM.GetFieldVal("Select Curr_Code from Vendor where ven_Code = '" & trim(lblVenCOde.text) & "';","Curr_Code")
                    cmbOriCurr.Items.Clear
                    Dissql("Select Curr_Code,Curr_Desc from bom_quote_curr where curr_code <> '-' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' order by curr_Desc","Curr_Code","Curr_Desc",cmbOriCurr)
                    cmbOriCurr.Items.FindByValue(trim(CurrCode)).Selected = True
                    txtOriUP.text = drGetFieldVal("UP")
                    Rate = ReqCOM.GetFieldVal("Select Rate from BOM_Quote_Curr where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and Curr_Code = '" & trim(cmbOriCurr.selecteditem.value) & "';","Rate")
                    UnitConv = ReqCOM.GetFieldVal("Select Unit_Conv from BOM_Quote_Curr where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and Curr_Code = '" & trim(cmbOriCurr.selecteditem.value) & "';","Unit_Conv")
                    txtUPRM.text = (txtOriUP.text * Rate ) / UnitConv
                    txtLeadTime.text = clng(drGetFieldVal("Lead_Time"))
                    txtSPQ.text = clng(drGetFieldVal("Std_Pack_Qty"))
                    txtVenName.text = ReqCOM.GetFieldVal("Select Ven_Name from Vendor where ven_code = '" & trim(lblVenCOde.text) & "';","Ven_Name")
                    txtmoq.text = clng(drGetFieldVal("Min_Order_Qty"))
                loop
    
                myCommand.dispose()
                drGetFieldVal.close()
                cnnGetFieldVal.Close()
                cnnGetFieldVal.Dispose()
    
                txtLowestUP.text = ReqCOM.GetFieldVal("Select Lowest_UP from Part_Master where part_no = '" & trim(lblSelPartNo.text) & "';","Lowest_UP")
                txtHighestUP.text = ReqCOM.GetFieldVal("Select Highest_UP from Part_Master where part_no = '" & trim(lblSelPartNo.text) & "';","Highest_UP")
                txtSPQ.enabled = false
                txtmoq.enabled = false
                txtLowestUP.enabled = false
                txtHighestUP.enabled = false
                txtLeadTime.enabled = false
                txtHighestAmt.enabled = false
                txtLowestAmt.enabled = false
            End if
        end if
    End sub
    
    Sub ShowAltCost()
        Dim SeqNo as long
        Dim HighestCost as decimal
        Dim WACTemp,StdCostTemp,AverageCostTemp,HighestUP,LowestUP as string
        Dim PartNoTemp as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        Dim i as integer
        Dim PartNo As Label
    
        HighestCost = 0
        SeqNo = 0
    
        For i = 0 To GridControl1.Items.Count - 1
            PartNo = CType(GridControl1.Items(i).FindControl("PartNo"), Label)
            ReqCOM.ExecuteNonQuery("Update Part_Master set Average_Actual_Hi_Lo = 0,Highest_UP=0,Lowest_Up = 0 where part_no = '" & trim(PartNo.text) & "';")
    
            WACTemp = ReqCOM.GetFieldVal("Select WAC_Cost from Part_Master where Part_No = '" & trim(PartNo.text) & "';","WAC_Cost")
            if trim(WACTemp) <> "<NULL>" then
                if cdec(WACTemp) > HighestCost then HighestCost = WacTemp:PartNoTemp = trim(PartNo.text)
    
            end if
    
            StdCostTemp = ReqCOM.GetFieldVal("Select Std_Cost_RD from Part_Master where Part_No = '" & trim(PartNo.text) & "';","Std_Cost_RD")
            if trim(StdCostTemp) <> "<NULL>" then
                if cdec(StdCostTemp) > HighestCost then HighestCost = StdCostTemp:PartNoTemp = trim(PartNo.text)
            end if
    
    
            HighestUP = ReqCOM.GetFieldVal("Select max(UP) as [UP] from Part_Source where part_no = '" & trim(PartNo.text) & "';","UP")
            if trim(HighestUP) <> "<NULL>" then
                LowestUP = ReqCOM.GetFieldVal("Select min(UP) as [UP] from Part_Source where part_no = '" & trim(PartNo.text) & "';","UP")
                AverageCostTemp = (cdec(HighestUP) + cdec(LowestUP)) / 2
                ReqCOM.ExecuteNonQuery("Update Part_Master set Highest_Up = " & cdec(HighestUP) & ", Lowest_UP = " & cdec(LowestUP) & ", Average_Actual_Hi_Lo = " & AverageCostTemp & " where Part_No = '" & trim(PartNo.text) & "';")
                if cdec(AverageCostTemp) > HighestCost then HighestCost = AverageCostTemp:PartNoTemp = trim(PartNo.text)
            end if
        Next i
    
        lblSelPartNo.text = trim(PartNoTemp)
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
            SaveDet(MainPartT,cmbPartNo.selecteditem.value)
    
    
    
            UpdateLowestVendor(MainPartT,cmbPartNo.selecteditem.value)
            UpdateHighestVendor(MainPartT,cmbPartNo.selecteditem.value)
    'UpdateHighestVendor
    
    
    
    
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand("Select Part_No from Part_Master where part_no in (Select distinct(Part_No) from BOM_Alt where Main_Part = '" & trim(cmbPartNo.selecteditem.value) & "')", myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
            do while drGetFieldVal.read
                PartNo = drGetFieldVal("Part_No")
                response.write (PartNo)
                txtSearchPart.text = trim(PartNo)
                SearchPart
                ReqCOM.ExecuteNonQuery("Update Part_Master set Average_Actual_Hi_Lo = 0,Highest_UP=0,Lowest_Up = 0 where part_no = '" & trim(PartNo) & "';")
    
                WACTemp = ReqCOM.GetFieldVal("Select WAC_Cost from Part_Master where Part_No = '" & trim(PartNo) & "';","WAC_Cost")
                if trim(WACTemp) <> "<NULL>" then
                    if cdec(WACTemp) > HighestCost then HighestCost = WacTemp:PartNoTemp = trim(PartNo)
                end if
    
                StdCostTemp = ReqCOM.GetFieldVal("Select Std_Cost_RD from Part_Master where Part_No = '" & trim(PartNo) & "';","Std_Cost_RD")
                if trim(StdCostTemp) <> "<NULL>" then
                    if cdec(StdCostTemp) >   HighestCost then HighestCost = StdCostTemp:PartNoTemp = trim(PartNo)
                end if
    
                HighestUP = ReqCOM.GetFieldVal("Select max(UP) as [UP] from Part_Source where part_no = '" & trim(PartNo) & "';","UP")
                if trim(HighestUP) <> "<NULL>" then
                    LowestUP = ReqCOM.GetFieldVal("Select min(UP) as [UP] from Part_Source where part_no = '" & trim(PartNo) & "';","UP")
                    AverageCostTemp = (cdec(HighestUP) + cdec(LowestUP)) / 2
                    ReqCOM.ExecuteNonQuery("Update Part_Master set Highest_Up = " & cdec(HighestUP) & ", Lowest_UP = " & cdec(LowestUP) & ", Average_Actual_Hi_Lo = " & AverageCostTemp & " where Part_No = '" & trim(PartNo) & "';")
                    if cdec(AverageCostTemp) > HighestCost then HighestCost = AverageCostTemp:PartNoTemp = trim(PartNo)
                end if
                CalculateQty
                SaveDet(MainPartT,cmbPartNo.selecteditem.value)
                UpdateLowestVendor(MainPartT,cmbPartNo.selecteditem.value)
                UpdateHighestVendor(MainPartT,cmbPartNo.selecteditem.value)
            loop
            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
            response.redirect("BOMQuoteDet.aspx?ID=" & ReqCOM.getFieldVal("select Seq_No from bom_quote_m where bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';","Seq_No"))
        end if
    End Sub
    
    Sub SaveDet(MainPartT as string,PartNoT as string)
        Dim StrSql as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if trim(MainPartT) = trim(PartNoT) then
            StrSql = "Insert into BOM_Quote_D(Main,Main_Part,BOM_QUOTE_NO,PART_NO,MFG_MPN,CUST_PART_NO,PART_DESC,PART_SPEC,MFG_NAME,P_USAGE,TARGET_ORI_CURR,TARGET_ORI_UP,TARGET_UP_RM,VEN_CODE,VEN_NAME,LEAD_TIME,SPQ,MOQ,LOWEST_UP,HIGHEST_UP,REM) "
            StrSql = StrSql & "Select 'MAIN','" & trim(MainPartT) & "','" & trim(lblBomQuoteNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "','" & trim(txtMFGMpn.text) & "','" & trim(txtCustPartNo.text) & "','" & trim(txtPartDesc.text) & "','" & trim(txtPartSpec.text) & "','" & trim(txtMFGName.text) & "'," & trim(txtPUsage.text) & ",'" & trim(cmbOriCurr.selecteditem.value) & "'," & trim(txtOriUP.text) & ",'" & trim(txtUPRM.text) & "','" & trim(lblVenCode.text) & "','" & trim(txtVenName.text) & "'," & clng(txtLeadTime.text) & ",'" & clng(txtSPQ.text) & "','" & clng(txtMOQ.text) & "'," & cdec(txtLowestUP.text) & "," & cdec(txtHighestUP.text) & ",'" & trim(txtRem.text) & "'"
            ReqCOM.ExecuteNonQuery(StrSql)
        elseif trim(MainPartT) <> trim(PartNoT) then
            StrSql = "Insert into BOM_Quote_D(Main,Main_Part,BOM_QUOTE_NO,PART_NO,MFG_MPN,CUST_PART_NO,PART_DESC,PART_SPEC,MFG_NAME,P_USAGE,TARGET_ORI_CURR,TARGET_ORI_UP,TARGET_UP_RM,VEN_CODE,VEN_NAME,LEAD_TIME,SPQ,MOQ,LOWEST_UP,HIGHEST_UP,REM) "
            StrSql = StrSql & "Select 'ALT','" & trim(MainPartT) & "','" & trim(lblBomQuoteNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "','" & trim(txtMFGMpn.text) & "','" & trim(txtCustPartNo.text) & "','" & trim(txtPartDesc.text) & "','" & trim(txtPartSpec.text) & "','" & trim(txtMFGName.text) & "'," & trim(txtPUsage.text) & ",'" & trim(cmbOriCurr.selecteditem.value) & "'," & trim(txtOriUP.text) & ",'" & trim(txtUPRM.text) & "','" & trim(lblVenCode.text) & "','" & trim(txtVenName.text) & "'," & clng(txtLeadTime.text) & ",'" & clng(txtSPQ.text) & "','" & clng(txtMOQ.text) & "'," & cdec(txtLowestUP.text) & "," & cdec(txtHighestUP.text) & ",'" & trim(txtRem.text) & "'"
            ReqCOM.ExecuteNonQuery(StrSql)
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
        txtHighestAmt.text = txtPUsage.text * txtHighestUP.text
        txtLowestAmt.text = txtPUsage.text * txtLowestUP.text
        lblMOQUsage.text = clng(txtMOQ.text / txtPUsage.text)
        lblSPQUsage.text = clng(txtSPQ.text / txtPUsage.text)
        txtOriAmt.text = txtOriUP.text * txtPUsage.text
        txtAmtRM.text = txtUPRM.text * txtPUsage.text
    End Sub
    
    
    Sub UpdateHighestVendor(MainPart as string,PartNo as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim strSql as string = "Select top 1 ven.curr_code,ven.ven_name,PS.Ven_Code,ps.UP,ps.lead_time,ps.up_app_date,ps.std_pack_qty,ps.min_order_qty from Part_Source PS,vendor ven where ps.ven_code = ven.ven_code and PS.part_no = '" & trim(PartNo) & "' order by PS.UP desc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while drGetFieldVal.read
            if isdbnull(drGetFieldVal("UP_APP_Date")) = false then ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Highest_curr_code = '" & trim(drGetFieldVal("Curr_Code")) & "',Highest_Ven_Name = '" & trim(drGetFieldVal("Ven_Name")) & "',Highest_Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "',highest_ori_up = " & cdec(drGetFieldVal("UP")) & ",highest_lt = " & drGetFieldVal("Lead_Time") & ",highest_date = '" & cdate(drGetFieldVal("UP_APP_Date")) & "',highest_spq = " & drGetFieldVal("Std_Pack_Qty") & ",highest_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
            if isdbnull(drGetFieldVal("UP_APP_Date")) = true then ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Highest_curr_code = '" & trim(drGetFieldVal("Curr_Code")) & "',Highest_Ven_Name = '" & trim(drGetFieldVal("Ven_Name")) & "',Highest_Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "',highest_ori_up = " & cdec(drGetFieldVal("UP")) & ",highest_lt = " & drGetFieldVal("Lead_Time") & ",highest_spq = " & drGetFieldVal("Std_Pack_Qty") & ",highest_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    
    Sub UpdateLowestVendor(MainPart as string,PartNo as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim strSql as string = "Select top 1 ven.curr_code,ven.ven_name,PS.Ven_Code,ps.UP,ps.lead_time,ps.up_app_date,ps.std_pack_qty,ps.min_order_qty from Part_Source PS,vendor ven where ps.ven_code = ven.ven_code and PS.part_no = '" & trim(PartNo) & "' order by PS.UP asc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while drGetFieldVal.read
            if isdbnull(drGetFieldVal("UP_APP_Date")) = false then ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Lowest_curr_code = '" & trim(drGetFieldVal("Curr_Code")) & "',Lowest_Ven_Name = '" & trim(drGetFieldVal("Ven_Name")) & "',Lowest_Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "',Lowest_ori_up = " & cdec(drGetFieldVal("UP")) & ",lowest_lt = " & drGetFieldVal("Lead_Time") & ",lowest_date = '" & cdate(drGetFieldVal("UP_APP_Date")) & "',lowest_spq = " & drGetFieldVal("Std_Pack_Qty") & ",lowest_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
            if isdbnull(drGetFieldVal("UP_APP_Date")) = true then ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Lowest_curr_code = '" & trim(drGetFieldVal("Curr_Code")) & "',Lowest_Ven_Name = '" & trim(drGetFieldVal("Ven_Name")) & "',Lowest_Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "',Lowest_ori_up = " & cdec(drGetFieldVal("UP")) & ",lowest_lt = " & drGetFieldVal("Lead_Time") & ",lowest_spq = " & drGetFieldVal("Std_Pack_Qty") & ",lowest_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub

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
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">BOM
                                QUOTATION DETAILS</asp:Label>
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
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator6" runat="server" ControlToValidate="txtHighestUP" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Highest Unit Cost." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator7" runat="server" ControlToValidate="txtLowestUP" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Lowest Unit Cost." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" ControlToValidate="txtSPQ" Display="Dynamic" ForeColor=" " ErrorMessage="SPQ must be an integer value." CssClass="ErrorText" Width="100%" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator2" runat="server" ControlToValidate="txtMOQ" Display="Dynamic" ForeColor=" " ErrorMessage="MOQ must be an integer value." CssClass="ErrorText" Width="100%" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator3" runat="server" ControlToValidate="txtLeadTime" Display="Dynamic" ForeColor=" " ErrorMessage="Lead Time must be an integer value." CssClass="ErrorText" Width="100%" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator4" runat="server" ControlToValidate="txtPUsage" Display="Dynamic" ForeColor=" " ErrorMessage="Usage must be an integer value." CssClass="ErrorText" Width="100%" Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator5" runat="server" ControlToValidate="txtOriUP" Display="Dynamic" ForeColor=" " ErrorMessage="Target Unit Price must be a currency value." CssClass="ErrorText" Width="100%" Type="Double" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator6" runat="server" ControlToValidate="txtHighestUP" Display="Dynamic" ForeColor=" " ErrorMessage="Highest Unit Price must be a currency value." CssClass="ErrorText" Width="100%" Type="Double" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator7" runat="server" ControlToValidate="txtLowestUP" Display="Dynamic" ForeColor=" " ErrorMessage="Lowest Unit Price must be an currency value." CssClass="ErrorText" Width="100%" Type="Double" Operator="DataTypeCheck"></asp:CompareValidator>
                                                    <asp:CompareValidator id="CompareValidator8" runat="server" ControlToValidate="txtPUsage" Display="Dynamic" ForeColor=" " ErrorMessage="Usage Must be greater than 0." CssClass="ErrorText" Width="100%" Type="Integer" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
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
                                                                        <asp:Label id="lblBOMQuoteNo" runat="server" cssclass="OutputText"></asp:Label><asp:Label id="lblSelPartNo" runat="server" cssclass="OutputText"></asp:Label>
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
                                                                    <p>
                                                                        <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" CausesValidation="False" Height="20px" Text="GO"></asp:Button>
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
                                                                        <asp:TextBox id="txtOriUP" runat="server" CssClass="ReqText" Width="163px"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="122px">Target
                                                                    Unit Cost(RM)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtUPRM" runat="server" CssClass="OutputText" Width="163px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label27" runat="server" cssclass="LabelNormal" width="122px">Target
                                                                    Amt(Ori. Curr)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtOriAmt" runat="server" CssClass="OutputText" Width="163px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label28" runat="server" cssclass="LabelNormal" width="122px">Target
                                                                    Amt (RM)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtAmtRM" runat="server" CssClass="OutputText" Width="163px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label29" runat="server" cssclass="LabelNormal" width="122px">Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtVenName" runat="server" CssClass="OutputText" Width="163px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label30" runat="server" cssclass="LabelNormal" width="122px">Lead Time</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtLeadTime" runat="server" CssClass="ReqText" Width="163px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label31" runat="server" cssclass="LabelNormal" width="122px">SPQ</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtSPQ" runat="server" CssClass="ReqText" Width="163px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label32" runat="server" cssclass="LabelNormal" width="122px">SPQ/Usage</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSPQUsage" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label33" runat="server" cssclass="LabelNormal" width="122px">MOQ</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtMOQ" runat="server" CssClass="ReqText" Width="163px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label34" runat="server" cssclass="LabelNormal" width="122px">MOQ/Usage</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMOQUsage" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label35" runat="server" cssclass="LabelNormal" width="122px">Lowest
                                                                    U. Cost(RM)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtLowestUP" runat="server" CssClass="ReqText" Width="163px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label36" runat="server" cssclass="LabelNormal" width="122px">Lowest
                                                                    Amt(RM)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtLowestAmt" runat="server" CssClass="OutputText" Width="163px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label37" runat="server" cssclass="LabelNormal" width="122px">Highest
                                                                    U.Cost(RM)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtHighestUP" runat="server" CssClass="ReqText" Width="163px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label38" runat="server" cssclass="LabelNormal" width="122px">Highest
                                                                    Amt(RM)</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtHighestAmt" runat="server" CssClass="OutputText" Width="163px"></asp:TextBox>
                                                                    &nbsp; 
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
                                                <p align="center">
                                                    <asp:Label id="Label10" runat="server" cssclass="SectionHeader" width="100%">MAIN
                                                    AND ALTERNATE PART COMPARISON</asp:Label> 
                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Part No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Description">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Specification">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartSpec" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "WAC">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="WACCost" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Wac_Cost") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Std Cost">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="StdCostRD" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Cost_Rd") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Highest U/P">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="HighestUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Highest_UP") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Lowest U/P">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="LowestUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lowest_Up") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText= "Average">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="AverageActualHiLo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Average_Actual_Hi_Lo") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                        <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="10%" bgcolor="red">
                                                                                    </td>
                                                                                    <td>
                                                                                        <p>
                                                                                            &nbsp; <asp:Label id="Label13" runat="server" cssclass="OutputText" width="100%">Main
                                                                                            Part</asp:Label>
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
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="136px" CausesValidation="False" Text="Back"></asp:Button>
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
