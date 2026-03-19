<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If not IsPostBack  Then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
            lblFECNNo.text = ReqCOM.GetFieldVal("Select FECN_NO from FECN_M where SEQ_NO = " & Request.params("ID") & ";","FECN_NO")
            lblModelNo.text = ReqCOm.GetFieldVal("Select Model_No from FECN_M where Seq_No = " & Request.params("ID") & ";","Model_No")
            lblRevNo.text = ReqCOM.GetFieldVal("Select max(Revision) as [Revision] from BOM_M where Model_No = '" & trim(lblModelNo.text) & "';","Revision")
        end if
    End Sub
    
    SUb Dissql(ByVal strSql As String,VName as string,FName as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = VName
            .DataTextField = FName
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim RsPart as SqlDataReader = ReqCOM.ExeDataReader("Select Part_Spec,Part_Desc,M_Part_No from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';")
        do while RsPart.read
            lblPartDesc.text = trim(RsPart("Part_Desc").ToString)
            lblPartSpec.text = trim(RsPart("Part_Spec").ToString)
            lblMfgPartNo.text = trim(RsPart("M_Part_No").ToString)
            lblPartDescA.text = trim(RsPart("Part_Desc").ToString)
            lblPartSpecA.text = trim(RsPart("Part_Spec").ToString)
            lblMfgPartNoA.text = trim(RsPart("M_Part_No").ToString)
        loop
    
        Dim RsBOM as SQLDataReader = ReqCOM.ExeDataReader("Select * from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';")
        Do while rsBOM.read
            lblUsage.text = rsBOM("P_Usage").toString
            lblLocation.text = rsBOM("P_Location").toString
            if trim(lblLocation.text) = "<NULL>" then lblLocation.text = ""
    
            txtUsage.text = rsBOM("P_Usage").toString
            txtLocation.text = rsBOM("P_Location").toString
            if trim(txtLocation.text) = "<NULL>" then txtLocation.text = ""
        loop
    
        Dissql ("Select P_Level from BOM_D BOM where BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & cdec(lblRevNo.text) & " and BOM.Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","P_Level","P_Level",cmbLevelB)
        Dissql ("Select P_Level from BOM_D BOM where BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & cdec(lblRevNo.text) & " and BOM.Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","P_Level","P_Level",cmbLevelA)
    
    End Sub
    
    Sub Save_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERp_Gtm.Erp_gtm = new Erp_Gtm.ERP_Gtm
            Dim i as integer
            Dim StrSql,RefAlt as string
            Dim SeqNo as long
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
    
            StrSql = "Insert into FECN_D(FECN_NO,MAIN_PART_B4,ALT_PART_B4,PART_DESC_B4,PART_SPEC_B4,"
            StrSql = StrSql + "M_PART_NO_B4,P_USAGE_B4,P_LEVEL_B4,P_LOCATION_B4,MAIN_PART,ALT_PART,"
            StrSql = StrSql + "PART_DESC,PART_SPEC,M_PART_NO,P_USAGE,P_LEVEL,P_LOCATION,REASON_CHANGE,Imp_Type,TYPE_CHANGE,Ref_Alt) "
            StrSql = StrSql + "Select '" & trim(lblFECNNo.text) & "','" & trim(cmbPartNo.selectedItem.Value) & "','-','" & trim(lblPartDesc.text) & "','" & trim(lblPartSpec.text) & "',"
            StrSql = StrSql + "'" & lblMfgPartNo.text & "'," & lblUsage.text & ",'" & trim(cmbLevelB.selectedItem.text) & "','" & trim(lbllocation.text) & "','" & trim(cmbpartNoAfter.selectedItem.value) & "','-',"
            StrSql = StrSql + "'" & TRIM(lblPartDescA.text) & "','" & trim(lblPartSpecA.text) & "','" & trim(lblMfgPartNoA.text) & "'," & trim(txtUsage.text) & ","
            StrSql = StrSql + "'" & TRIM(cmbLevelA.selectedItem.value) & "',"
            StrSql = StrSql + "'" & TRIM(txtLocation.text) & "','" & TRIM(replace(txtReasonChange.text,"'","`")) & "','" & trim(cmbImpType.selecteditem.value) & "','Edit Main Part','" & trim(RefAlt) & "'"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            SeqNo = ReqCOM.GetFieldVal("Select top 1 Seq_No from FECN_D order by seq_no desc","Seq_No")
    
            Dim PartNo,PartDesc,PartSpec As Label
            Dim Remove as checkbox
            RefAlt = ""
    
            For i = 0 To dtgAltB4.Items.Count - 1
                PartNo = CType(dtgAltB4.Items(i).FindControl("PartNo"), Label)
                PartDesc = CType(dtgAltB4.Items(i).FindControl("PartDesc"), Label)
                PartSpec = CType(dtgAltB4.Items(i).FindControl("PartSpec"), Label)
                ReqCOM.executeNonQuery("Insert into FECN_ALT(FECN_NO,Main_Part,Part_No,Ref_Seq,Status) select '" & TRIM(lblFECNNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "','" & trim(PartNo.text) & "'," & clng(SeqNo) & ",'B'")
                if trim(RefAlt) = "" then
                    RefAlt = trim(PartNo.text) & "-" & trim(PartDesc.text) & "-" & trim(PartSpec.text)
                else
                    RefAlt = RefAlt & vblf & trim(partNo.text) & "-" & trim(PartDesc.text) & "-" & trim(partSpec.text)
                End if
            Next i
            ReqCOM.ExecuteNonQuery("Update FECN_D set Ref_Alt_B4 = '" & trim(RefAlt) & "' where seq_no = " & SeqNo & ";")
    
            RefAlt = ""
            For i = 0 To dtgAltAfter.Items.Count - 1
                PartNo = CType(dtgAltAfter.Items(i).FindControl("PartNo"), Label)
                PartDesc = CType(dtgAltAfter.Items(i).FindControl("PartDesc"), Label)
                PartSpec = CType(dtgAltAfter.Items(i).FindControl("PartSpec"), Label)
                Remove = CType(dtgAltAfter.Items(i).FindControl("Remove"), Checkbox)
    
                if Remove.checked = false then
                    ReqCOM.executeNonQuery("Insert into FECN_ALT(FECN_NO,Main_Part,Part_No,Ref_Seq,Status) select '" & TRIM(lblFECNNo.text) & "','" & trim(cmbPartNoAfter.selecteditem.value) & "','" & trim(PartNo.text) & "'," & clng(SeqNo) & ",'A'")
                    if trim(RefAlt) = "" then
                        RefAlt = trim(PartNo.text) & "-" & trim(PartDesc.text) & "-" & trim(PartSpec.text)
                    else
                        RefAlt = RefAlt & vblf & trim(partNo.text) & "-" & trim(PartDesc.text) & "-" & trim(partSpec.text)
                    End if
                End if
            Next i
            ReqCOM.ExecuteNonQuery("Update FECN_D set Ref_Alt = '" & trim(RefAlt) & "' where seq_no = " & SeqNo & ";")
            ReqCOM.ExecuteNonQuery("Delete from FECN_ALT_VAR where U_ID = '" & trim(request.cookies("U_ID").value) & "';")
            Response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
    
        end if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        response.redirect("FECNDet.aspx?ID=" & ReqCOM.GetFIeldVal("Select Seq_No from FECN_M where FECN_No = '" & trim(lblFECNNo.text) & "';","Seq_No"))
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim PartDesc,MfgPartNo as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        reqCom.ExecuteNonQuery("Delete from FECN_ALT_VAR where u_id = '" & trim(request.cookies("U_ID").value) & "';")
        Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc]  from Part_Master where Part_No in (Select Part_No from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No like '%" & trim(txtSearchPart.text) & "%' and Revision = " & cdec(lblRevNo.text) & ")","Part_No","Desc",cmbPartNo)
        Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc]  from Part_Master where Part_No in (Select Part_No from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No like '%" & trim(txtSearchPart.text) & "%' and Revision = " & cdec(lblRevNo.text) & ")","Part_No","Desc",cmbPartNoAfter)
    
        if cmbPartNo.selectedindex <> -1 then
    
            LoadAltPartB4
            lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Desc")
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
            lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_Part_No from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","M_Part_No")
    
            lblPartDescA.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Desc")
            lblPartSpecA.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","Part_Spec")
    
            MfgPartNo = ReqCOM.GetFieldVal("Select M_Part_No from Part_Master where Part_No = '" & trim(cmbPartNoAfter.selectedItem.value) & "';","M_Part_No")
    
            if trim(MfgPartNo) = "<NULL>" then lblMfgPartNoA.text = ""
            if trim(MfgPartNo) <> "<NULL>" then lblMfgPartNoA.text = trim(MfgPartNo)
    
            txtSearchPart.text = "-- Search --"
            Dissql ("Select P_Level from BOM_D BOM where BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & cdec(lblRevNo.text) & " and BOM.Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","P_Level","P_Level",cmbLevelB)
            Dissql ("Select P_Level from BOM_D BOM where BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & cdec(lblRevNo.text) & " and BOM.Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","P_Level","P_Level",cmbLevelA)
    
    
            ReqCOM.ExecuteNonQuery("Insert into FECN_ALT_VAR(Part_No,U_ID) Select distinct(Part_No),'" & trim(request.cookies("U_ID").value) & "' from BOM_ALT where Main_Part = '" & trim(cmbPartNoAfter.selectedItem.Value) & "';")
            LoadAltPartAfter
            if cmbLevelB.selectedindex <> -1 then
                Dissql ("Select P_Level from BOM_D BOM where BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & cdec(lblRevNo.text) & " and BOM.Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';","P_Level","P_Level",cmbLevelA)
                txtUsage.text = ReqCOM.GetFieldVal("Select P_Usage from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelA.selectedItem.value) & "' and revision = " & cdec(lblRevNo.text) & ";","P_Usage")
                txtLocation.text = ReqCOM.GetFieldVal("Select P_Location from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelA.selectedItem.value) & "' and revision = " & cdec(lblRevNo.text) & ";","P_Location")
                if trim(txtLocation.text) = "<NULL>" then txtLocation.text = ""
                lblUsage.text = ReqCOM.GetFieldVal("Select P_Usage from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelB.selectedItem.value) & "' and revision = " & cdec(lblRevNo.text) & ";","P_Usage")
                lblLocation.text = ReqCOM.GetFieldVal("Select P_Location from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelB.selectedItem.value) & "' and revision = " & cdec(lblRevNo.text) & ";","P_Location")
                if trim(lblLocation.text) = "<NULL>" then lblLocation.text = ""
            Else
                txtUsage.text = ""
                txtLocation.text = ""
                lblUsage.text = ""
                lblLocation.text = ""
            end if
        else
            cmbLevelB.items.clear
            txtSearchPart.text = "-- Search --"
            lblPartDesc.text = ""
            lblPartSpec.text = ""
            lblMfgPartNo.text = ""
            lblPartDescA.text = ""
            lblPartSpecA.text = ""
            lblMfgPartNoA.text = ""
            lblUsage.text = ""
            lblLocation.text = ""
            ShowAlert("Invalid Part No selected.\nThis could be due to follwing reason\n1. Part No not exist in part master\n2. Part no not use in this model")
        end if
    End Sub
    
    Sub ShowAlert(Msg as string)
                Dim strScript as string
                strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
                If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
            End sub
    
    Sub cmbLevelB_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        txtUsage.text = ReqCOM.GetFieldVal("Select P_Usage from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelB.selectedItem.value) & "';","P_Usage")
        txtLocation.text = ReqCOM.GetFieldVal("Select P_Location from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelB.selectedItem.value) & "';","P_Location")
        if trim(txtLocation.text) = "<NULL>" then txtLocation.text = ""
        lblUsage.text = ReqCOM.GetFieldVal("Select P_Usage from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelB.selectedItem.value) & "' and revision = " & cdec(lblRevNo.text) & ";","P_Usage")
        lblLocation.text = ReqCOM.GetFieldVal("Select P_Location from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelB.selectedItem.value) & "' and revision = " & cdec(lblRevNo.text) & ";","P_Location")
        if trim(lblLocation.text) = "<NULL>" then lblLocation.text = ""
    End Sub
    
    Sub cmbLevelA_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        txtUsage.text = ReqCOM.GetFieldVal("Select P_Usage from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelA.selectedItem.value) & "';","P_Usage")
        txtLocation.text = ReqCOM.GetFieldVal("Select P_Location from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelA.selectedItem.value) & "';","P_Location")
        if trim(txtLocation.text) = "<NULL>" then txtLocation.text = ""
    End Sub
    
    Sub cmdPartNoAfter_Click(sender As Object, e As EventArgs)
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim MfgPartNo as string
    
        Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where Part_No like '%" & trim(txtPartNoAfter.text) & "%';","Part_No","Desc",cmbPartNoAfter)
        reqCom.ExecuteNonQuery("Delete from FECN_ALT_VAR where u_id = '" & trim(request.cookies("U_ID").value) & "';")
    
        if cmbPartNoAfter.selectedIndex <> -1 then
            ReqCOM.ExecuteNonQuery("Insert into FECN_ALT_VAR(Part_No,U_ID) Select distinct(Part_No),'" & trim(request.cookies("U_ID").value) & "' from BOM_ALT where Main_Part = '" & trim(cmbPartNoAfter.selectedItem.Value) & "';")
            LoadAltPartAfter
            lblPartDescA.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & trim(cmbPartNoAfter.selectedItem.value) & "';","Part_Desc")
            lblPartSpecA.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(cmbPartNoAfter.selectedItem.value) & "';","Part_Spec")
            MfgPartNo = ReqCOM.GetFieldVal("Select M_Part_No from Part_Master where Part_No = '" & trim(cmbPartNoAfter.selectedItem.value) & "';","M_Part_No")
    
            if trim(MfgPartNo) = "<NULL>" then lblMfgPartNoA.text = ""
            if trim(MfgPartNo) <> "<NULL>" then lblMfgPartNoA.text = trim(MfgPartNo)
    
            txtPartNoAfter.text = "-- Search --"
        Else
            lblPartDescA.text = ""
            lblPartSpecA.text = ""
            lblMfgPartNoA.text = ""
            txtPartNoAfter.text = "-- Search --"
            ShowAlert("Invalid Part No selected.")
        End if
    End Sub
    
    Sub cmdLevelAfter_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        Dissql ("Select level_Code from P_Level where level_Code like '%" & trim(txtLevelAfter.text) & "%' order by level_code asc","Level_Code","Level_Code",cmbLevelA)
    
        if cmbLevelA.selectedindex = -1 then
            txtLevelAfter.text = "-- Search --"
            ShowAlert("Invalid Level selected.")
        Else
            txtLevelAfter.text = "-- Search --"
        end if
    
    End Sub
    
    Sub cmbLevelA_SelectedIndexChanged_1(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        txtUsage.text = ReqCOM.GetFieldVal("Select P_Usage from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelA.selectedItem.value) & "' and revision = " & cdec(lblRevNo.text) & ";","P_Usage")
        txtLocation.text = ReqCOM.GetFieldVal("Select P_Location from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.value) & "' and P_Level = '" & trim(cmbLevelA.selectedItem.value) & "' and revision = " & cdec(lblRevNo.text) & ";","P_Location")
    End Sub
    
    Sub LoadAltPartAfter()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "Select Part_No, Part_Desc, Part_Spec,M_Part_No from Part_Master where part_no in (Select part_no from fecn_alt_var where u_id = '" & trim(request.cookies("U_ID").value) & "')"
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_Master")
        dtgAltAfter.DataSource=resExePagedDataSet.Tables("Part_Master").DefaultView
        dtgAltAfter.DataBind()
    end sub
    
    Sub LoadAltPartB4()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "Select Part_No, Part_Desc, Part_Spec, M_Part_No from Part_master where part_no in (Select Part_No from BOM_Alt where Model_No = '" & trim(lblModelNo.text) & "' and Main_Part = '" & trim(cmbPartNo.selectedItem.Value) & "' and revision = " & cdec(lblRevNo.text) & ")"
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_Master")
        dtgAltB4.DataSource=resExePagedDataSet.Tables("Part_Master").DefaultView
        dtgAltB4.DataBind()
    end sub
    
    Sub dtgAltAfter_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub lnkAddAlt_Click(sender As Object, e As EventArgs)
        ShowPopup("PopupFECNAddAlt.aspx")
    End Sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=350');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdRefreshAltPart_Click(sender As Object, e As EventArgs)
        LoadAltPartAfter()
    End Sub
    
    Sub txtSearchPart_TextChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
        </p>
        <p>
        </p>
        <p>
            <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">FECN - EDIT
                                BOM MAIN PART</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="86%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="left">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" EnableClientScript="False" ControlToValidate="txtReasonChange" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid reason of changes" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" EnableClientScript="False" ControlToValidate="cmbPartNo" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Part No (before change)" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" EnableClientScript="False" ControlToValidate="cmbPartNoAfter" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Part No (after change)" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" EnableClientScript="False" ControlToValidate="cmbLevelB" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Level (before change)" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" EnableClientScript="False" ControlToValidate="cmbLevelA" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Level (after change)" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator9" runat="server" EnableClientScript="False" ControlToValidate="txtUsage" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Usage" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator10" runat="server" EnableClientScript="False" ControlToValidate="txtLocation" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Location." Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator id="CompareValidator1" runat="server" ControlToValidate="txtUsage" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Usage." Width="100%" CssClass="ErrorText" Operator="GreaterThan" ValueToCompare="0" Type="Double"></asp:CompareValidator>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="116px">FECN No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblFECNNo" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="116px">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="116px">Last BOM
                                                                revision</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblRevNo" runat="server" cssclass="OutputText" width="116px"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p align="center">
                                                    <asp:Label id="Label9" runat="server" cssclass="SectionHeader" width="100%">Part Details
                                                    and Alternate Part (Before change)</asp:Label> 
                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="116px">Part No </asp:Label></td>
                                                                                    <td width="75%">
                                                                                        <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" Width="78px" CssClass="OutputText" OnTextChanged="txtSearchPart_TextChanged">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CausesValidation="False" Text="GO" Height="20px"></asp:Button>
                                                                                        &nbsp;&nbsp;&nbsp; 
                                                                                        <asp:DropDownList id="cmbPartNo" runat="server" Width="311px" CssClass="OutputText" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label15" runat="server" cssclass="LabelNormal" width="116px">Level</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:DropDownList id="cmbLevelB" runat="server" Width="100%" CssClass="OutputText" OnSelectedIndexChanged="cmbLevelB_SelectedIndexChanged" autopostback="true"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="116px">Description</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:Label id="lblPartDesc" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label19" runat="server" cssclass="LabelNormal" width="116px">Specification</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:Label id="lblPartSpec" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label21" runat="server" cssclass="LabelNormal" width="116px">Mfg Part
                                                                                        No</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:Label id="lblMfgPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label22" runat="server" cssclass="LabelNormal" width="116px">Usage</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:Label id="lblUsage" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label23" runat="server" cssclass="LabelNormal" width="116px">Location</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:Label id="lblLocation" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        <asp:DataGrid id="dtgAltB4" runat="server" width="100%" PageSize="20" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
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
                                                                                <asp:TemplateColumn HeaderText="MPN">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="MPN" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_Part_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label10" runat="server" cssclass="SectionHeader" width="100%">Part
                                                    Details and Alternate Part (After change)</asp:Label> 
                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="116px">Part No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtPartNoAfter" onkeydown="KeyDownHandler(cmdPartNoAfter)" onclick="GetFocus(txtPartNoAfter)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdPartNoAfter" onclick="cmdPartNoAfter_Click" runat="server" CausesValidation="False" Text="GO" Height="20px"></asp:Button>
                                                                                        <asp:DropDownList id="cmbPartNoAfter" runat="server" Width="311px" CssClass="OutputText" AutoPostBack="True"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="116px">Level</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtLevelAfter" onkeydown="KeyDownHandler(cmdLevelAfter)" onclick="GetFocus(txtLevelAfter)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdLevelAfter" onclick="cmdLevelAfter_Click" runat="server" CausesValidation="False" Text="GO" Height="20px"></asp:Button>
                                                                                        <asp:DropDownList id="cmbLevelA" runat="server" Width="311px" CssClass="OutputText" OnSelectedIndexChanged="cmbLevelA_SelectedIndexChanged_1" autopostback="true"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label14" runat="server" cssclass="LabelNormal" width="116px">Description</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:Label id="lblPartDescA" runat="server" cssclass="OutputText"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label17" runat="server" cssclass="LabelNormal" width="116px">Specification</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:Label id="lblPartSpecA" runat="server" cssclass="OutputText"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label20" runat="server" cssclass="LabelNormal" width="116px">Mfg Part
                                                                                        No</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:Label id="lblMfgPartNoA" runat="server" cssclass="OutputText"></asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label25" runat="server" cssclass="LabelNormal" width="116px">Usage</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:TextBox id="txtUsage" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="">Reason of Changes</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtReasonChange" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label27" runat="server" cssclass="LabelNormal" width="116px">Location</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:TextBox id="txtLocation" runat="server" Width="440px" CssClass="OutputText" Height="67px" TextMode="MultiLine"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="116px">Implementation</asp:Label></td>
                                                                                    <td>
                                                                                        <p>
                                                                                            <asp:DropDownList id="cmbImpType" runat="server" Width="176px" CssClass="OutputText">
                                                                                                <asp:ListItem Value="Immediate">Immediate</asp:ListItem>
                                                                                                <asp:ListItem Value="Running Change">Running Change</asp:ListItem>
                                                                                                <asp:ListItem Value="Next Lot">Next Lot</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <asp:LinkButton id="lnkAddAlt" onclick="lnkAddAlt_Click" runat="server" Width="100%" CssClass="OutputText" CausesValidation="False">Click here to add alternate part</asp:LinkButton>
                                                                        <asp:DataGrid id="dtgAltAfter" runat="server" width="100%" OnSelectedIndexChanged="dtgAltAfter_SelectedIndexChanged" PageSize="20" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <Columns>
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
                                                                                <asp:TemplateColumn HeaderText="MPN">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="MPN" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_Part_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Remove">
                                                                                    <ItemTemplate>
                                                                                        <asp:checkbox id="Remove" runat="server" />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 11px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="Save" onclick="Save_Click" runat="server" Width="134px" CausesValidation="True" Text="Save"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRefreshAltPart" onclick="cmdRefreshAltPart_Click" runat="server" Width="134px" CausesValidation="False" Text="Refresh Alt Part"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="134px" CausesValidation="False" Text="Cancel"></asp:Button>
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
