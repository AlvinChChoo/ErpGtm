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
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            LoadData()
            Dissql("Select Curr_Code,Curr_Desc from bom_quote_curr where curr_code <> '-' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' order by curr_Desc","Curr_Code","Curr_Desc",cmbOriCurr)
    
            Dim strSql as string = "Select Part_No,Seq_No,P_Usage from BOM_Quote_D where bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' and Det_gEN = 'N'"
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
            do while drGetFieldVal.read
                txtSearchPart.text = trim(drGetFieldVal("Part_No"))
                txtPUsage.text = drGetFieldVal("P_Usage")
                SearchPart
                UpdateImporedPart
                ReqCOM.ExecuteNonQUery("Delete from BOM_Quote_D where seq_no = " & clng(drGetFieldVal("Seq_No")) & ";")
            loop
    
            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
    
    
    
            ReqCOM.ExecuteNonQUery("update bom_quote_d set bom_quote_d.mfg_mpn = part_master.m_part_no,bom_quote_d.cust_part_no = part_master.Cust_Part_No,bom_quote_d.part_desc = part_master.Part_Desc,bom_quote_d.part_spec = part_master.Part_Spec from bom_quote_d,part_master where bom_quote_d.part_no = part_master.part_no and bom_quote_d.bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
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
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        SearchPart()
        if cmbPartNo.selectedindex <> -1 then lblMainPart.text = trim(cmbPartNo.selecteditem.value)
    End Sub
    
    Sub SearchPart()
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        cmbPartNo.items.clear
        Dissql ("Select distinct(Part_No),Part_No, Part_No + '|' + Part_Desc as [Desc] from Part_Master where Part_No like '%" & trim(txtSearchPart.text) & "%';","Part_No","Desc",cmbPartNo)
    
        if cmbPartNo.selectedindex = -1 then
            txtSearchPart.text = "-- Search --"
        elseif cmbPartNo.selectedindex <> -1 then
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
                txtPUsage.text = "4"
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
    
    Sub UpdateImporedPart()
        Dim i as integer
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim HighestCost as decimal
        Dim WACTemp,StdCostTemp,AverageCostTemp,HighestUP,LowestUP,PartNoTemp,PartNo,MainPartT,PartNoT as String
    
        MainPartT = trim(cmbPartNo.selecteditem.value)
        SaveDet(MainPartT,cmbPartNo.selecteditem.value)
        UpdateLowestVendor(MainPartT,cmbPartNo.selecteditem.value)
        UpdateHighestVendor(MainPartT,cmbPartNo.selecteditem.value)
    
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand("Select Part_No from Part_Master where part_no in (Select distinct(Part_No) from BOM_Alt where Main_Part = '" & trim(cmbPartNo.selecteditem.value) & "')", myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while drGetFieldVal.read
            PartNo = drGetFieldVal("Part_No")
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
            'UpdateLowestVendor(MainPartT,cmbPartNo.selecteditem.value)
            'UpdateHighestVendor(MainPartT,cmbPartNo.selecteditem.value)
            UpdatePricingDet(MainPartT)
    
    
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub UpdateStdCost(MainPartT as string,PartNo as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim strSql as string = "Select top 1 * from part_master where part_no = '" & trim(PartNo) & "';"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        do while drGetFieldVal.read
    
            'StrSql = "Update BOM_Quote_D set std_date = '" & drGetFieldVal("Cost_Date") & "',std_ori_up = " & drGetFieldVal("ori_std_cost_purc") & ",std_curr_code = '" & trim(drGetFieldVal("std_cost_purc_curr_code").tostring) & "',std_Ven_Name = '" & trim(drGetFieldVal("ref_supp_purc").tostring) & "',std_Ven_Code = '" & trim(drGetFieldVal("ref_supp_purc").tostring) & "',std_lt = " & drGetFieldVal("lead_time_purc") & ",std_spq = " & drGetFieldVal("spq_purc") & ",std_moq = " & drGetFieldVal("moq_purc").tostring & " where part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';"
            'StrSql = "Update BOM_Quote_D set std_ori_up = " & drGetFieldVal("ori_std_cost_purc") & ",std_curr_code = '" & trim(drGetFieldVal("std_cost_purc_curr_code").tostring) & "',std_Ven_Name = '" & trim(drGetFieldVal("ref_supp_purc").tostring) & "',std_Ven_Code = '" & trim(drGetFieldVal("ref_supp_purc").tostring) & "',std_lt = " & drGetFieldVal("lead_time_purc") & ",std_spq = " & drGetFieldVal("spq_purc") & ",std_moq = " & drGetFieldVal("moq_purc").tostring & " where part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';"
            'ReqCOM.ExecuteNonQuery(StrSql)
    
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub UpdateLastQuote(MainPartT as string,PartNo as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim BOMQuoteDate as date
        Dim strSql as string = "Select top 1 * from BOM_Quote_D where part_no = '" & trim(PartNo) & "' and bom_quote_no in (select bom_quote_no from bom_quote_m where bom_quote_status = 'APPROVED') order by Seq_No desc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        do while drGetFieldVal.read
            BOMQuoteDate = ReqCOM.GetFieldVal("Select App3_Date from bom_quote_M where bom_quote_no = '" & trim(drGetFieldVal("BOM_Quote_No")) & "';","App3_Date")
            StrSql = "Update BOM_Quote_D set last_quote_date = '" & cdate(BOMQuoteDate) & "',last_quote_ori_up = " & drGetFieldVal("Target_Ori_Up") & ",last_quote_curr_code = '" & trim(drGetFieldVal("target_ori_curr").tostring) & "',last_quote_ref_no = '" & trim(drGetFieldVal("bom_quote_no").tostring) & "',last_quote_Ven_Name = '" & trim(drGetFieldVal("ven_name").tostring) & "',last_quote_Ven_Code = '" & trim(drGetFieldVal("ven_code").tostring) & "',last_quote_lt = " & drGetFieldVal("lead_time") & ",last_quote_spq = " & drGetFieldVal("SPQ") & ",last_quote_moq = " & drGetFieldVal("MOQ").tostring & " where part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub Update1stVendor(MainPartT as string,PartNo as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim strSql as string = "Select top 1 ps.up_app_date,ps.up_app_no,ven.curr_code,PS.UP_APP_NO,ven.ven_name,PS.Ven_Code,ps.UP,ps.lead_time,ps.up_app_date,ps.std_pack_qty,ps.min_order_qty,ps.ori_up from Part_Source PS,vendor ven where ps.ven_code = ven.ven_code and PS.part_no = '" & trim(PartNo) & "' order by PS.ven_seq asc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        do while drGetFieldVal.read
            if isdbnull(drGetFieldVal("UP_APP_Date")) = false then
                StrSql = "Update BOM_Quote_D set first_date = '" & trim(drGetFieldVal("up_app_date")) & "',FIRST_ref_no = '" & trim(drGetFieldVal("up_app_no")) & "',FIRST_curr_code = '" & trim(drGetFieldVal("Curr_Code")) & "',FIRST_Ven_Name = '" & trim(drGetFieldVal("Ven_Name")) & "',FIRST_Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "',FIRST_ori_up = " & cdec(drGetFieldVal("UP")) & ",FIRST_lt = " & drGetFieldVal("Lead_Time") & ",FIRST_spq = " & drGetFieldVal("Std_Pack_Qty") & ",FIRST_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPartT) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';"
                ReqCOM.ExecuteNonQuery(StrSql)
            elseif isdbnull(drGetFieldVal("UP_APP_Date")) = true then
                StrSql = "Update BOM_Quote_D set FIRST_ref_no = '" & trim(drGetFieldVal("up_app_no")) & "',first_curr_code = '" & trim(drGetFieldVal("Curr_Code")) & "',first_Ven_Name = '" & trim(drGetFieldVal("Ven_Name")) & "',first_Ven_Code = '" & trim(drGetFieldVal("Ven_Code")) & "',first_ori_up = " & cdec(drGetFieldVal("UP")) & ",first_lt = " & drGetFieldVal("Lead_Time") & ",first_spq = " & drGetFieldVal("Std_Pack_Qty") & ",first_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPartT) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';"
                ReqCOM.ExecuteNonQuery(StrSql)
            end if
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub UpdateStdCostDet()
    
    End Sub
    
    Sub UpdatePricingDet(MainPartT as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim WACDate as date
        WACDate = ReqCOM.GetFieldVal("Select Last_WAC_Date from Main","Last_WAC_Date")
        Dim strSql as string = "Select top 1 * from BOM_Quote_D where Main_Part = '" & trim(MainPartT) & "' and BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        do while drGetFieldVal.read
            UpdateLastQuote(trim(drGetFieldVal("Main_Part")),trim(drGetFieldVal("Part_No")))
            UpdateStdCost(trim(drGetFieldVal("Main_Part")),trim(drGetFieldVal("Part_No")))
    
            if reqCOM.FuncCheckDuplicate("Select top 1 Part_No from part_Source where part_no = '" & trim(drGetFieldVal("Part_No")) & "';","Part_No") = true then
                Update1stVendor(trim(drGetFieldVal("Main_Part")),trim(drGetFieldVal("Part_No")))
                UpdateLowestVendor(trim(drGetFieldVal("Main_Part")),trim(drGetFieldVal("Part_No")))
                UpdateHighestVendor(trim(drGetFieldVal("Main_Part")),trim(drGetFieldVal("Part_No")))
            End if
    
    
    
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set BOM_Quote_D.lowest_up = BOM_Quote_D.lowest_ori_up * BOM_Quote_curr.rate / BOM_Quote_curr.unit_conv from BOM_Quote_D,BOM_Quote_Curr where bom_quote_d.bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' and bom_quote_d.main_part = '" & trim(drGetFieldVal("Main_Part")) & "' and bom_quote_curr.curr_code = bom_quote_d.lowest_curr_code")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set BOM_Quote_D.highest_up = BOM_Quote_D.highest_ori_up * BOM_Quote_curr.rate / BOM_Quote_curr.unit_conv from BOM_Quote_D,BOM_Quote_Curr where bom_quote_d.bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' and bom_quote_d.main_part = '" & trim(drGetFieldVal("Main_Part")) & "' and bom_quote_curr.curr_code = bom_quote_d.highest_curr_code")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set BOM_Quote_D.First_up = BOM_Quote_D.First_ori_up * BOM_Quote_curr.rate / BOM_Quote_curr.unit_conv from BOM_Quote_D,BOM_Quote_Curr where bom_quote_d.bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' and bom_quote_d.main_part = '" & trim(drGetFieldVal("Main_Part")) & "' and bom_quote_curr.curr_code = bom_quote_d.First_curr_code")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set BOM_Quote_D.last_quote_up = BOM_Quote_D.last_quote_ori_up * BOM_Quote_curr.rate / BOM_Quote_curr.unit_conv from BOM_Quote_D,BOM_Quote_Curr where bom_quote_d.bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' and bom_quote_d.main_part = '" & trim(drGetFieldVal("Main_Part")) & "' and bom_quote_curr.curr_code = bom_quote_d.last_quote_curr_code")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set bom_quote_d.wac = part_master.wac_cost from part_master,bom_quote_d where part_master.part_no = bom_quote_d.part_no and bom_quote_d.part_no = '" & trim(drGetFieldVal("Part_No")) & "' and bom_quote_d.main_part = '" & trim(drGetFieldVal("Main_Part")) & "' and bom_quote_d.bom_quote_no ='" & trim(lblBOMQuoteNo.text) & "';")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set bom_quote_d.wac_Date = '" & cdate(WACDate) & "' where bom_quote_d.part_no = '" & trim(drGetFieldVal("Part_No")) & "' and bom_quote_d.main_part = '" & trim(drGetFieldVal("Main_Part")) & "' and bom_quote_d.bom_quote_no ='" & trim(lblBOMQuoteNo.text) & "';")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set average_hi_low = (Highest_ori_UP + Lowest_ori_up)/2 where bom_quote_d.part_no = '" & trim(drGetFieldVal("Part_No")) & "' and bom_quote_d.main_part = '" & trim(drGetFieldVal("Main_Part")) & "' and bom_quote_d.bom_quote_no ='" & trim(lblBOMQuoteNo.text) & "';")
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub SaveDet(MainPartT as string,PartNoT as string)
        Dim StrSql as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if trim(MainPartT) = trim(PartNoT) then
            StrSql = "Insert into BOM_Quote_D(Main,Main_Part,BOM_QUOTE_NO,PART_NO,P_USAGE,TARGET_ORI_CURR,TARGET_ORI_UP,TARGET_UP_RM,VEN_CODE,VEN_NAME,LEAD_TIME,SPQ,MOQ,LOWEST_UP,HIGHEST_UP,REM) "
            StrSql = StrSql & "Select 'MAIN','" & trim(MainPartT) & "','" & trim(lblBomQuoteNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "'," & trim(txtPUsage.text) & ",'" & trim(cmbOriCurr.selecteditem.value) & "'," & trim(txtOriUP.text) & ",'" & format(cdec(txtUPRM.text),"####0.00000") & "','" & trim(lblVenCode.text) & "','" & trim(txtVenName.text) & "'," & clng(txtLeadTime.text) & ",'" & clng(txtSPQ.text) & "','" & clng(txtMOQ.text) & "'," & cdec(txtLowestUP.text) & "," & cdec(txtHighestUP.text) & ",'" & trim(txtRem.text) & "'"
            ReqCOM.ExecuteNonQuery(StrSql)
        elseif trim(MainPartT) <> trim(PartNoT) then
            StrSql = "Insert into BOM_Quote_D(Main,Main_Part,BOM_QUOTE_NO,PART_NO,P_USAGE,TARGET_ORI_CURR,TARGET_ORI_UP,TARGET_UP_RM,VEN_CODE,VEN_NAME,LEAD_TIME,SPQ,MOQ,LOWEST_UP,HIGHEST_UP,REM) "
            StrSql = StrSql & "Select 'ALT','" & trim(MainPartT) & "','" & trim(lblBomQuoteNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "'," & trim(txtPUsage.text) & ",'" & trim(cmbOriCurr.selecteditem.value) & "'," & trim(txtOriUP.text) & ",'" & trim(txtUPRM.text) & "','" & trim(lblVenCode.text) & "','" & trim(txtVenName.text) & "'," & clng(txtLeadTime.text) & ",'" & clng(txtSPQ.text) & "','" & clng(txtMOQ.text) & "'," & cdec(txtLowestUP.text) & "," & cdec(txtHighestUP.text) & ",'" & trim(txtRem.text) & "'"
            ReqCOM.ExecuteNonQuery(StrSql)
        end if
    End sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub CalculateQty()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim Rate as Decimal
        Rate = ReqCOM.GetFieldVal("Select Rate/Unit_Conv as [Rate] from Curr where Curr_Code = '" & trim(cmbOriCurr.selecteditem.value) & "';","Rate")
        txtUPRm.text = format(cdec(cdec(txtOriUP.text) * Rate),"##,##0.00000")
        txtHighestAmt.text = txtPUsage.text * txtHighestUP.text
        txtLowestAmt.text = txtPUsage.text * txtLowestUP.text
    End Sub
    
    
    Sub UpdateHighestVendorTemp(MainPart as string,PartNo as string)
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
                StrSql = "Update BOM_Quote_D set Highest_Ref_No = '" & trim(drGetFieldVal("UP_APP_No").tostring) & "',Highest_curr_code = '" & trim(drGetFieldVal("Curr_Code").tostring) & "',Highest_Ven_Name = '" & trim(drGetFieldVal("Ven_Name").tostring) & "',Highest_Ven_Code = '" & trim(drGetFieldVal("Ven_Code").tostring) & "',highest_ori_up = " & cdec(drGetFieldVal("UP")) & ",highest_lt = " & drGetFieldVal("Lead_Time") & ",highest_spq = " & drGetFieldVal("Std_Pack_Qty") & ",highest_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';"
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
            if isdbnull(drGetFieldVal("UP_APP_Date")) = true then ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set lowest_ref_no = '" & trim(drGetFieldVal("UP_APP_No").tostring) & "', Lowest_curr_code = '" & trim(drGetFieldVal("Curr_Code").tostring) & "',Lowest_Ven_Name = '" & trim(drGetFieldVal("Ven_Name").tostring) & "',Lowest_Ven_Code = '" & trim(drGetFieldVal("Ven_Code").tostring) & "',Lowest_ori_up = " & cdec(drGetFieldVal("UP")) & ",lowest_lt = " & drGetFieldVal("Lead_Time") & ",lowest_spq = " & drGetFieldVal("Std_Pack_Qty") & ",lowest_moq = " & drGetFieldVal("Min_Order_Qty") & " where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(PartNo) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub UpdateLowestVendorTemp(MainPart as string,PartNo as string)
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
    
    Sub lnkBOMQuote_Click(sender As Object, e As EventArgs)
        Response.redirect("BOMQuoteDet.aspx?ID=" & clng(Request.params("ID")))
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
            <table style="HEIGHT: 3px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                            </p>
                            <p align="center">
                            </p>
                            <p align="center">
                            </p>
                            <p align="center">
                            </p>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="Instruction" width="">Selected Model
                                has been imported successfully.</asp:Label>
                            </p>
                            <p align="center">
                                <asp:LinkButton id="lnkBOMQuote" onclick="lnkBOMQuote_Click" runat="server" Width="100%">Click here to view BOM Quotation in details</asp:LinkButton>
                            </p>
                            <p align="center">
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <p>
            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td width="25%">
                            <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="128px" visible="False">Quotation
                            #</asp:Label></td>
                        <td width="75%" colspan="3">
                            <p>
                                <asp:Label id="lblBOMQuoteNo" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblSelPartNo" runat="server" cssclass="OutputText" visible="False"></asp:Label>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label11" runat="server" cssclass="LabelNormal" visible="False">Revision</asp:Label></td>
                        <td colspan="3">
                            <asp:Label id="lblBOMQuoteRev" runat="server" cssclass="OutputText" width="100%" visible="False"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label16" runat="server" cssclass="LabelNormal" visible="False">Model
                            Details</asp:Label></td>
                        <td colspan="3">
                            <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" visible="False"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblVenCode" runat="server" cssclass="OutputText" visible="False"></asp:Label><asp:Label id="lblMainPart" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="131px" visible="False">Part
                            #</asp:Label></td>
                        <td colspan="3">
                            <p>
                                <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" Width="78px" Visible="False" CssClass="OutputText">-- Search --</asp:TextBox>
                                <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Visible="False" CssClass="OutputText" CausesValidation="False" Height="20px" Text="GO"></asp:Button>
                                <asp:DropDownList id="cmbPartNo" runat="server" Width="355px" Visible="False" CssClass="OutputText" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="122px" visible="False">Usage</asp:Label></td>
                        <td>
                            <p>
                                <asp:TextBox id="txtPUsage" runat="server" Width="163px" Visible="False" CssClass="ReqText"></asp:TextBox>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="122px" visible="False">Target
                            Ori. Curr</asp:Label></td>
                        <td>
                            <p>
                                <asp:DropDownList id="cmbOriCurr" runat="server" Width="163px" Visible="False" CssClass="ReqText"></asp:DropDownList>
                                <asp:Label id="txtOriCurr1" runat="server" visible="False"></asp:Label>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label23" runat="server" cssclass="LabelNormal" width="100%" visible="False">Target
                            Unit Cost(Ori. Curr)</asp:Label></td>
                        <td>
                            <p>
                                <asp:TextBox id="txtOriUP" runat="server" Width="163px" Visible="False" CssClass="ReqText"></asp:TextBox>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="122px" visible="False">Target
                            Unit Cost(RM)</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtUPRM" runat="server" Width="163px" Visible="False" CssClass="OutputText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label27" runat="server" cssclass="LabelNormal" width="122px" visible="False">Target
                            Amt(Ori. Curr)</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtOriAmt" runat="server" Width="163px" Visible="False" CssClass="OutputText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label28" runat="server" cssclass="LabelNormal" width="122px" visible="False">Target
                            Amt (RM)</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtAmtRM" runat="server" Width="163px" Visible="False" CssClass="OutputText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label29" runat="server" cssclass="LabelNormal" width="122px" visible="False">Supplier</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtVenName" runat="server" Width="163px" Visible="False" CssClass="OutputText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label30" runat="server" cssclass="LabelNormal" width="122px" visible="False">Lead
                            Time</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtLeadTime" runat="server" Width="163px" Visible="False" CssClass="ReqText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label31" runat="server" cssclass="LabelNormal" width="122px" visible="False">SPQ</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtSPQ" runat="server" Width="163px" Visible="False" CssClass="ReqText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label32" runat="server" cssclass="LabelNormal" width="122px" visible="False">SPQ/Usage</asp:Label></td>
                        <td>
                            <asp:Label id="lblSPQUsage" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label33" runat="server" cssclass="LabelNormal" width="122px" visible="False">MOQ</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtMOQ" runat="server" Width="163px" Visible="False" CssClass="ReqText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label34" runat="server" cssclass="LabelNormal" width="122px" visible="False">MOQ/Usage</asp:Label></td>
                        <td>
                            <asp:Label id="lblMOQUsage" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label35" runat="server" cssclass="LabelNormal" width="122px" visible="False">Lowest
                            U. Cost(RM)</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtLowestUP" runat="server" Width="163px" Visible="False" CssClass="ReqText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label36" runat="server" cssclass="LabelNormal" width="122px" visible="False">Lowest
                            Amt(RM)</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtLowestAmt" runat="server" Width="163px" Visible="False" CssClass="OutputText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label37" runat="server" cssclass="LabelNormal" width="122px" visible="False">Highest
                            U.Cost(RM)</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtHighestUP" runat="server" Width="163px" Visible="False" CssClass="ReqText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label38" runat="server" cssclass="LabelNormal" width="122px" visible="False">Highest
                            Amt(RM)</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtHighestAmt" runat="server" Width="163px" Visible="False" CssClass="OutputText"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label id="Label39" runat="server" cssclass="LabelNormal" width="122px" visible="False">Remarks</asp:Label></td>
                        <td>
                            <asp:TextBox id="txtRem" runat="server" Width="100%" Visible="False" CssClass="OutputText"></asp:TextBox>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <p>
            <asp:DataGrid id="GridControl1" runat="server" width="100%" Visible="False" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next">
                <FooterStyle cssclass="GridFooter"></FooterStyle>
                <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                <ItemStyle cssclass="GridItem"></ItemStyle>
                <Columns>
                    <asp:TemplateColumn Visible="False">
                        <ItemTemplate>
                            <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderText="Part No">
                        <ItemTemplate>
                            <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderText="Description">
                        <ItemTemplate>
                            <asp:Label id="PartDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderText="Specification">
                        <ItemTemplate>
                            <asp:Label id="PartSpec" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>' /> 
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderText="WAC">
                        <ItemTemplate>
                            <asp:Label id="WACCost" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Wac_Cost") %>' /> 
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderText="Std Cost">
                        <ItemTemplate>
                            <asp:Label id="StdCostRD" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Cost_Rd") %>' /> 
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderText="Highest U/P">
                        <ItemTemplate>
                            <asp:Label id="HighestUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Highest_UP") %>' /> 
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderText="Lowest U/P">
                        <ItemTemplate>
                            <asp:Label id="LowestUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lowest_Up") %>' /> 
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderText="Average">
                        <ItemTemplate>
                            <asp:Label id="AverageActualHiLo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Average_Actual_Hi_Lo") %>' /> 
                        </ItemTemplate>
                    </asp:TemplateColumn>
                </Columns>
            </asp:DataGrid>
        </p>
        <p>
        </p>
        <p>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
