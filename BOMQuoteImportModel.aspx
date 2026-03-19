<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            lblBomQuoteNo.text = ReqCOM.getFieldVal("Select BOM_Quote_No from BOM_Quote_M where Seq_No = " & request.params("ID") & ";","BOM_Quote_No")
    
            LoadFECNDet
            FormatRow
    
        End if
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
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
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("BOMQuoteDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        'Dissql ("Select MODEL_CODE,Model_Code + '|' + Model_Desc as [Desc] from Model_Master where model_code in (select model_no from bom_m where model_no like '%" & trim(txtSearch.text) & "%') order by MODEL_CODE asc","MODEL_CODE","Desc",cmbModelNo)
        'txtSearch.text = "--Search--"
    
    
        'if cmbModelNo.selectedindex = -1 then
        '    MyList.visible = false
        '    ShowAlert ("You don't seem to have supplied a valid Model No or Model Description. \nPls try again.")
        'elseif cmbModelNo.selectedindex <> -1 then
        '    MyList.visible = true
        '    LoadFECNDet
        '    FormatRow
        'end if
    
    End Sub
    
    Sub cmdImport_Click(sender As Object, e As EventArgs)
        ImportBOM
    End Sub
    
    Sub ImportBOM()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        Dim Rev as decimal
    
        If ReqCOM.FuncCheckDuplicate("Select Top 1 Part_No from BOM_D where model_no = '" & trim(request.params("ModelNo")) & "' and Part_No not in (Select Part_No from Part_Master)","Part_No") = false then
            Rev = ReqCOM.GetFieldVal("Select Top 1 Revision from BOM_M where Model_No = '" & trim(request.params("ModelNo")) & "';","Revision")
            StrSql = "Insert into BOM_Quote_D(PART_NO,main_part,P_Usage,BOM_QUOTE_NO,DET_GEN) select distinct(PART_NO),Part_No,sum(P_Usage),'" & trim(lblBOMQuoteNo.text) & "','N' from BOM_D where Model_No = '" & trim(request.params("ModelNo")) & "' and Revision = " & cdec(Rev) & " and part_no not in (Select Part_No from BOM_Quote_D where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "') group by Part_No"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Insert into BOM_Quote_D(PART_NO,main_part,P_Usage,BOM_QUOTE_NO,DET_GEN) select Part_No,Main_Part,2,'" & trim(lblBOMQuoteNo.text) & "','N' from BOM_Alt where Model_No = '" & trim(request.params("ModelNo")) & "' and Revision = " & cdec(Rev) & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            ReqCOM.ExecuteNonQUery("Update BOM_Quote_M set Import_Model_No = '" & trim(request.params("ModelNo")) & "' where bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
            Response.redirect("BOMQuoteUpdateCostDet.aspx?ID=" & Request.params("ID"))
    
    
    
        Else
            ShowAlert("Some of the parts in the selected model are not in part master.\nPlease make sure all the parts are properly maintained before import.")
        end if
    End Sub
    
    Sub ImportBOMWithFECN()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        Dim Rev as decimal
    
        If ReqCOM.FuncCheckDuplicate("Select Top 1 Part_No from BOM_D where model_no = '" & trim(request.params("ModelNo")) & "' and Part_No not in (Select Part_No from Part_Master)","Part_No") = false then
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Det_Gen = 'Y' where bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
            Rev = ReqCOM.GetFieldVal("Select Top 1 Revision from BOM_M where Model_No = '" & trim(request.params("ModelNo")) & "';","Revision")
            StrSql = "Insert into BOM_Quote_D(PART_NO,MAIN_PART,P_Usage,BOM_QUOTE_NO,DET_GEN) select distinct(PART_NO),PART_NO,sum(P_Usage),'" & trim(lblBOMQuoteNo.text) & "','N' from BOM_D where Model_No = '" & trim(request.params("ModelNo")) & "' and Revision = " & cdec(Rev) & " and part_no not in (Select Part_No from BOM_Quote_D where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "') group by Part_No"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            '''''''''''''''''''''''
    
            strsql = "select * from fecn_d where fecn_no in (select fecn_no from fecn_m where model_no = '" & trim(Request.params("ModelNo")) & "' and fecn_status = 'PENDING APPROVAL')"
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
            do while drGetFieldVal.read
    
                if trim(drGetFieldVal("Main_Part_B4")) <> "-" then
                    ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set p_usage = p_usage - " & drGetFieldVal("P_Usage_b4") & " where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and Main_Part = '" & trim(drGetFieldVal("Main_Part_B4")) & "';")
                End if
    
                if trim(drGetFieldVal("Main_Part")) <> "-" then
    
                        if ReqCOM.FuncCheckDuplicate("Select top 1 Part_no from BOM_Quote_D where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and Main_Part = '" & trim(drGetFieldVal("Main_Part")) & "';","Part_No") = true then
                            ReqCOM.ExecuteNonQUery("Update BOM_Quote_D set p_usage = p_usage + " & drGetFieldVal("P_Usage") & " where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and Main_Part = '" & trim(drGetFieldVal("Main_Part")) & "';")
                        else
                            StrSql = "Insert into BOM_Quote_D(PART_NO,P_Usage,BOM_QUOTE_NO,DET_GEN) select '" & trim(drGetFieldVal("Main_Part")) & "'," & cdec(drGetFieldVal("P_Usage")) & ",'" & trim(lblBOMQuoteNo.text) & "','N'"
                            ReqCOM.ExecuteNonQuery(StrSql)
                        end if
    
    
                end if
            loop
            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
    
    
            ReqCOM.ExecuteNonQUery("Update BOM_Quote_M set Import_Model_No = '" & trim(request.params("ModelNo")) & "' where bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
            response.redirect("BOMQuoteUpdateImportedPart.aspx?ID=" & Request.params("ID") & "&ModelNo=" & trim(Request.params("ModelNo")))
        Else
            ShowAlert("Some of the parts in the selected model are not in part master.\nPlease make sure all the parts are properly maintained before import.")
        end if
    End Sub
    
    Sub UpdatePartDet
        Dim StrSql as string
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        StrSql = "Update BOM_Quote_D set BOM_Quote_D.mfg_name = Part_Master.mfg,BOM_Quote_D.MFG_MPN = Part_Master.M_Part_No,BOM_Quote_D.Main_Part = Part_Master.Part_No,BOM_Quote_D.CUST_PART_NO = Part_Master.CUST_PART_NO,BOM_Quote_D.Part_Desc = Part_Master.Part_Desc,BOM_Quote_D.Part_Spec = Part_Master.Part_Spec from BOM_Quote_D,Part_Master where BOM_Quote_D.part_no = part_master.part_No and BOM_Quote_D.BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and BOM_QUOTE_D.Part_Desc is null"
        ReqCOM.ExecuteNonQuery(StrSql)
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    
    sub LoadFECNDet()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        Dim strSql as string
    
        strsql ="select * from fecn_d where fecn_no in (select fecn_no from fecn_m where model_no = '" & trim(request.params("ModelNo")) & "' and fecn_status = 'PENDING APPROVAL')"
    
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub FormatRow()
        Dim PartDet as string
        Dim i As Integer
        Dim ETADate,MinOrderQty,StdPackQty,UP,QtyToBuy,ReqQty,Diff,Amt,RowNo As Label
        Dim PartSpecB4,MPartNoB4,PUsageB4,PLevelB4,PLocationB4,MAINPARTB4,RefAltPartB4 As Label
        Dim PartSpec,MPartNo,PUsage,PLevel,PLocation,MAINPART,RefAltPart As Label
        Dim PartDescB4,PartDesc As Textbox
    
    
        For i = 0 To MyList.Items.Count - 1
            PartDescB4 = CType(MyList.Items(i).FindControl("PartDescB4"), Textbox)
            PartSpecB4 = CType(MyList.Items(i).FindControl("PartSpecB4"), Label)
            MPartNoB4 = CType(MyList.Items(i).FindControl("MPartNoB4"), Label)
            MainPartB4 = CType(MyList.Items(i).FindControl("MainPartB4"), Label)
            PLocationB4 = CType(MyList.Items(i).FindControl("PLocationB4"), Label)
            PUsageB4 = CType(MyList.Items(i).FindControl("PUsageB4"), Label)
            PLevelB4 = CType(MyList.Items(i).FindControl("PLevelB4"), Label)
            RefAltPartB4 = CType(MyList.Items(i).FindControl("RefAltPartB4"), Label)
            PartDesc = CType(MyList.Items(i).FindControl("PartDesc"), Textbox)
            PartSpec = CType(MyList.Items(i).FindControl("PartSpec"), Label)
            MPartNo = CType(MyList.Items(i).FindControl("MPartNo"), Label)
            MainPart = CType(MyList.Items(i).FindControl("MainPart"), Label)
            PLocation = CType(MyList.Items(i).FindControl("PLocation"), Label)
            PUsage = CType(MyList.Items(i).FindControl("PUsage"), Label)
            PLevel = CType(MyList.Items(i).FindControl("PLevel"), Label)
            RefAltPart = CType(MyList.Items(i).FindControl("RefAltPart"), Label)
    
            if trim(MPartNo.text) = "<NULL>" then MPartNo.text = "-"
            if trim(MPartNoB4.text) = "<NULL>" then MPartNoB4.text = "-"
    
            if trim(MainPartB4.text) = "-" then PartDescB4.text = "N/A"
            if trim(MainPartB4.text) <> "-" then PartDescB4.text = "Part #           : " & trim(MainPartB4.text) & vblf & "DESC/SPEC    : " & trim(PartDescB4.text) & " /(" & trim(PartSpecB4.text) & ")" & vblf & "MPN              : " & trim(MPartNoB4.text) & vblf & "Usage/Level  : " & cdec(PUsageB4.text) & " (" & trim(PLevelB4.text) & ")" & vblf & "Location        : " & trim(PLocationB4.text) & vblf & vblf & "Alt Part         : " & vblf & trim(RefAltPartB4.text)
    
            if trim(MainPart.text) = "-" then PartDesc.text = "N/A"
            if trim(MainPart.text) <> "-" then PartDesc.text = "Part #           : " & trim(MainPart.text) & vblf & "DESC/SPEC    : " & trim(PartDesc.text) & " /(" & trim(PartSpec.text) & ")" & vblf & "MPN              : " & trim(MPartNo.text) & vblf & "Usage/Level  : " & cdec(PUsage.text) & " (" & trim(PLevel.text) & ")" & vblf & "Location        : " & trim(PLocation.text) & vblf & vblf & "Alt Part         : " & vblf & trim(RefAltPart.text)
    
            RowNo = CType(MyList.Items(i).FindControl("RowNo"), Label)
            RowNo.text = i + 1
        Next
    End sub
    
    Sub Button2_Click(sender As Object, e As EventArgs)
        ImportBOMWithFECN
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        ImportBOM
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" siz