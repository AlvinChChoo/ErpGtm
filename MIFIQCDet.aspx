<%@ Page Language="VB" %>
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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim RsMIF as SQLDataReader = ReqCOM.exeDataReader("Select * from MIF_M where Seq_No = " & Request.params("ID") & ";")
    
            Do while rsMIF.read
                lblMIFNo.text = rsMIF("MIF_NO").tostring
                lblMIFDate.text = format(cdate(rsMIF("MIF_DATE")),"dd/MMM/yy")
                lblInvNo.text = rsMIF("INV_NO").tostring
                lblSupplier.text = rsMIF("VEN_CODE").tostring
                lblVenName.text = ReqCOM.GetFieldVal("Select top 1 Ven_Name from Vendor where ven_code = '" & trim(lblSupplier.text) & "';","Ven_Name")
                txtRem.text = rsMIF("REM").tostring
                lblDONo.text = rsMIF("DO_NO").tostring
                lblCustomFormNo.text = rsMIF("CUSTOM_FORM_NO").tostring
    
                if isdbnull(rsMIF("App1_Date")) = false then
                    lblApp1By.text = trim(rsMIF("App1_By").tostring)
                    lblApp1Date.text = format(cdate(rsMIF("App1_Date")),"dd/MM/yy")
                end if
    
                if isdbnull(rsMIF("App2_Date")) = false then
                    lblApp2By.text = trim(rsMIF("App2_By").tostring)
                    lblApp2Date.text = format(cdate(rsMIF("App2_Date")),"dd/MM/yy")
                end if
    
                if isdbnull(rsMIF("App2_Date")) = true then
                    cmdApprove.enabled = true
                    cmdUpdate.enabled = true
                else
                    cmdApprove.enabled = false
                    cmdUpdate.enabled = false
                end if
            Loop
            ProcLoadGridData
            FormatRowItem
        end if
    End Sub
    
    Sub FormatRowItem()
        Dim PartType As DropDownList
        Dim PartTypeTemp,RowSeq As Label
        Dim RejQty,AcceptQty,IQCRem As textbox
        Dim i as integer
    
        For i = 0 To MyList.Items.Count - 1
            PartType  = Ctype(MyList.Items(i).FindControl("PartType"), dropdownlist)
            RowSeq = CType(MyList.Items(i).FindControl("RowSeq"), Label)
            PartTypeTemp  = Ctype(MyList.Items(i).FindControl("PartTypeTemp"), label)
    
            RejQty  = Ctype(MyList.Items(i).FindControl("RejQty"), textbox)
            AcceptQty  = Ctype(MyList.Items(i).FindControl("AcceptQty"), textbox)
            IQCRem  = Ctype(MyList.Items(i).FindControl("IQCRem"), textbox)
    
            if trim(ucase(PartTypeTemp.text)) = "GENERAL" then PartType.items.FindByValue("GENERAL").selected = true
            if trim(ucase(PartTypeTemp.text)) = "PACKING" then PartType.items.FindByValue("PACKING").selected = true
            if trim(ucase(PartTypeTemp.text)) = "PLASTIC" then PartType.items.FindByValue("PLASTIC").selected = true
            if trim(ucase(PartTypeTemp.text)) = "ELECTRONIC" then PartType.items.FindByValue("ELECTRONIC").selected = true
            RowSeq.text = i + 1
    
    
            if trim(lblApp2By.text) <> "" then
                PartType.enabled = false
                AcceptQty.enabled = false
                RejQty.enabled = false
                IQCRem.enabled = false
            end if
        next
    end sub
    
    Sub cmdApprove_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            if UpdateMIF("SUBMIT") = true then
                ShowAlert("MIF Approved.")
                redirectPage("MIFIQCDet.aspx?ID=" & Request.params("ID"))
            end if
        End if
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
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("MIFApprovalList.aspx")
    End Sub
    
    Sub ValMIF(sender As Object, e As ServerValidateEventArgs)
        Dim i as integer
        Dim AccQty,RejQty,IQCRem As textbox
        Dim InQty As label
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        For i = 0 To MyList.Items.Count - 1
            AccQty = Ctype(MyList.Items(i).FindControl("AcceptQty"), Textbox)
            RejQty = Ctype(MyList.Items(i).FindControl("RejQty"), Textbox)
            IQCRem = Ctype(MyList.Items(i).FindControl("IQCRem"), Textbox)
            InQty = Ctype(MyList.Items(i).FindControl("InQty"), Label)
    
            if trim(AccQty.text) <> "" then
                if isnumeric(AccQty.text) = false then CheckMIF.ErrorMessage = "Item " & clng(i) + 1 & " : You don't seem to have supplied a valid Accepted Qty.":e.isvalid=false:exit sub
            End if
    
            if trim(RejQty.text) <> "" then
                if isnumeric(RejQty.text) = false then CheckMIF.errorMessage = "Item " & clng(i) + 1 & " : You don't seem to have supplied a valid Rejected Qty.":e.isvalid=false:exit sub
            End if
    
            if (cdec(AccQty.text) + cdec(RejQty.text)) <> cdec(InQty.text) then CheckMIF.errorMessage = "Item " & clng(i) + 1 & " : Rejected and accepted Qty. not tally.":e.isvalid=false:exit sub
    
            if cdec(RejQty.text) > 0 then
                if trim(IQCRem.text) = "" then CheckMIF.errorMessage = "Item " & clng(i) + 1 & " : You don't seem to have supplied a valid remarks for rejected qty.":e.isvalid=false:exit sub
            end if
        next
    End Sub
    
    Public Function GetSampleSize(Qty as long,PartType as string) as long
        if trim(PartType) = "Electrical" then
            If clng(Qty) = 1 then GetSampleSize = 1
            If clng(Qty) >= 2  and clng(Qty) <= 8 then GetSampleSize = 2
            If clng(Qty) >= 9 and clng(Qty) <= 15 then GetSampleSize = 3
            If clng(Qty) >= 16 and clng(Qty) <= 25 then GetSampleSize = 5
            If clng(Qty) >= 26 and clng(Qty) <= 50 then GetSampleSize = 8
            If clng(Qty) >= 51 and clng(Qty) <= 90 then GetSampleSize = 13
            If clng(Qty) >= 91 and clng(Qty) <= 150 then GetSampleSize = 20
            If clng(Qty) >= 151 and clng(Qty) <= 280 then GetSampleSize = 32
            If clng(Qty) >= 281 and clng(Qty) <= 500 then GetSampleSize = 50
            If clng(Qty) >= 501 and clng(Qty) <= 1200 then GetSampleSize = 80
            If clng(Qty) >= 1201 and clng(Qty) <= 3200 then GetSampleSize = 125
            If clng(Qty) >= 3201 and clng(Qty) <= 10000 then GetSampleSize = 200
            If clng(Qty) >= 10001 and clng(Qty) <= 35000 then GetSampleSize = 315
            If clng(Qty) >= 35001 and clng(Qty) <= 150000 then GetSampleSize = 500
            If clng(Qty) >= 150001 and clng(Qty) <= 500000 then GetSampleSize = 800
            If clng(Qty) >= 500001 then GetSampleSize = 1250
        elseif trim(PartType) <> "Electrical" then
            If clng(Qty) = 1 then GetSampleSize = 1
            If clng(Qty) >= 2 and clng(Qty) <=8 then GetSampleSize = 2
            If clng(Qty) >= 9 and clng(Qty) <=15 then GetSampleSize = 3
            If clng(Qty) >= 16 and clng(Qty) <=25 then GetSampleSize = 5
            If clng(Qty) >= 26 and clng(Qty) <=50 then GetSampleSize = 8
            If clng(Qty) >= 51 and clng(Qty) <=90 then GetSampleSize = 13
            If clng(Qty) >= 91 and clng(Qty) <=150 then GetSampleSize = 20
            If clng(Qty) >= 151 and clng(Qty) <=280 then GetSampleSize = 32
            If clng(Qty) >= 281 and clng(Qty) <=500 then GetSampleSize = 50
            If clng(Qty) >= 501 and clng(Qty) <=1200 then GetSampleSize = 80
            If clng(Qty) >= 1201 and clng(Qty) <=3200 then GetSampleSize = 125
            If clng(Qty) >= 3201 and clng(Qty) <=10000 then GetSampleSize = 200
            If clng(Qty) >= 10001 and clng(Qty) <=35000 then GetSampleSize = 315
            If clng(Qty) >= 135001 and clng(Qty) <=150000 then GetSampleSize = 500
            If clng(Qty) >= 150001 and clng(Qty) <=500000 then GetSampleSize = 800
            If clng(Qty) >= 500001 then GetSampleSize = 1250
        End if
    End function
    
    Public Function GetMajor(Qty as long,PartType as string) as string
        if trim(PartType) = "Electrical" then
            If clng(Qty) = 1 then GetMajor = "0/1"
            If clng(Qty) >= 2  and clng(Qty) <= 8 then GetMajor = "0/1"
            If clng(Qty) >= 9 and clng(Qty) <= 15 then GetMajor = "0/1"
            If clng(Qty) >= 16 and clng(Qty) <= 25 then GetMajor = "0/1"
            If clng(Qty) >= 26 and clng(Qty) <= 50 then GetMajor = "0/1"
            If clng(Qty) >= 51 and clng(Qty) <= 90 then GetMajor = "0/1"
            If clng(Qty) >= 91 and clng(Qty) <= 150 then GetMajor = "0/1"
            If clng(Qty) >= 151 and clng(Qty) <= 280 then GetMajor = "0/1"
            If clng(Qty) >= 281 and clng(Qty) <= 500 then GetMajor = "0/1"
            If clng(Qty) >= 501 and clng(Qty) <= 1200 then GetMajor = "0/1"
            If clng(Qty) >= 1201 and clng(Qty) <= 3200 then GetMajor = "1/2"
            If clng(Qty) >= 3201 and clng(Qty) <= 10000 then GetMajor = "1/2"
            If clng(Qty) >= 10001 and clng(Qty) <= 35000 then GetMajor = "2/3"
            If clng(Qty) >= 35001 and clng(Qty) <= 150000 then GetMajor = "3/4"
            If clng(Qty) >= 150001 and clng(Qty) <= 500000 then GetMajor = "5/6"
            If clng(Qty) >= 500001 then GetMajor = "7/8"
        elseif trim(PartType) <> "Electrical" then
            If clng(Qty) = 1 then GetMajor = "0/1"
            If clng(Qty) >= 2 and clng(Qty) <=8 then GetMajor = "0/1"
            If clng(Qty) >= 9 and clng(Qty) <=15 then GetMajor = "0/1"
            If clng(Qty) >= 16 and clng(Qty) <=25 then GetMajor = "0/1"
            If clng(Qty) >= 26 and clng(Qty) <=50 then GetMajor = "0/1"
            If clng(Qty) >= 51 and clng(Qty) <=90 then GetMajor = "0/1"
            If clng(Qty) >= 91 and clng(Qty) <=150 then GetMajor = "0/1"
            If clng(Qty) >= 151 and clng(Qty) <=280 then GetMajor = "0/1"
            If clng(Qty) >= 281 and clng(Qty) <=500 then GetMajor = "0/1"
            If clng(Qty) >= 501 and clng(Qty) <=1200 then GetMajor = "1/1"
            If clng(Qty) >= 1201 and clng(Qty) <=3200 then GetMajor = "1/2"
            If clng(Qty) >= 3201 and clng(Qty) <=10000 then GetMajor = "2/3"
            If clng(Qty) >= 10001 and clng(Qty) <=35000 then GetMajor = "3/4"
            If clng(Qty) >= 135001 and clng(Qty) <=150000 then GetMajor = "5/6"
            If clng(Qty) >= 150001 and clng(Qty) <=500000 then GetMajor =  "7/8"
            If clng(Qty) >= 500001 then GetMajor = "10/11"
        End if
    End function
    
    Public Function GetMinor(Qty as long,PartType as string) as string
        if trim(PartType) = "Electrical" then
            If clng(Qty) = 1 then GetMinor = "0/1"
            If clng(Qty) >= 2  and clng(Qty) <= 8 then GetMinor = "0/1"
            If clng(Qty) >= 9 and clng(Qty) <= 15 then GetMinor = "0/1"
            If clng(Qty) >= 16 and clng(Qty) <= 25 then GetMinor = "0/1"
            If clng(Qty) >= 26 and clng(Qty) <= 50 then GetMinor = "0/1"
            If clng(Qty) >= 51 and clng(Qty) <= 90 then GetMinor = "0/1"
            If clng(Qty) >= 91 and clng(Qty) <= 150 then GetMinor = "0/1"
            If clng(Qty) >= 151 and clng(Qty) <= 280 then GetMinor = "0/1"
            If clng(Qty) >= 281 and clng(Qty) <= 500 then GetMinor = "0/1"
            If clng(Qty) >= 501 and clng(Qty) <= 1200 then GetMinor = "1/2"
            If clng(Qty) >= 1201 and clng(Qty) <= 3200 then GetMinor = "1/2"
            If clng(Qty) >= 3201 and clng(Qty) <= 10000 then GetMinor = "2/3"
            If clng(Qty) >= 10001 and clng(Qty) <= 35000 then GetMinor = "3/4"
            If clng(Qty) >= 35001 and clng(Qty) <= 150000 then GetMinor = "5/6"
            If clng(Qty) >= 150001 and clng(Qty) <= 500000 then GetMinor = "7/8"
            If clng(Qty) >= 500001 then GetMinor = "10/11"
        elseif trim(PartType) <> "Electrical" then
            If clng(Qty) = 1 then GetMinor = "0/1"
            If clng(Qty) >= 2 and clng(Qty) <=8 then GetMinor = "0/1"
            If clng(Qty) >= 9 and clng(Qty) <=15 then GetMinor = "0/1"
            If clng(Qty) >= 16 and clng(Qty) <=25 then GetMinor = "0/1"
            If clng(Qty) >= 26 and clng(Qty) <=50 then GetMinor = "0/1"
            If clng(Qty) >= 51 and clng(Qty) <=90 then GetMinor = "0/1"
            If clng(Qty) >= 91 and clng(Qty) <=150 then GetMinor = "0/1"
            If clng(Qty) >= 151 and clng(Qty) <=280 then GetMinor = "0/1"
            If clng(Qty) >= 281 and clng(Qty) <=500 then GetMinor = "1/2"
            If clng(Qty) >= 501 and clng(Qty) <=1200 then GetMinor = "2/3"
            If clng(Qty) >= 1201 and clng(Qty) <=3200 then GetMinor = "2/3"
            If clng(Qty) >= 3201 and clng(Qty) <=10000 then GetMinor = "3/4"
            If clng(Qty) >= 10001 and clng(Qty) <=35000 then GetMinor = "5/6"
            If clng(Qty) >= 135001 and clng(Qty) <=150000 then GetMinor = "7/8"
            If clng(Qty) >= 150001 and clng(Qty) <=500000 then GetMinor =  "10/11"
            If clng(Qty) >= 500001 then GetMinor = "14/15"
        End if
    End function
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    sub ProcLoadGridData()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        Dim StrSql as string = "Select mif.accept_qty,mif.rej_qty,mif.foc_qty,mif.iqc_rem,pm.part_spec,pm.part_desc,mif.part_type,MIF.Date_Receive,MIF.Del_Date,pm.part_desc,MIF.Seq_No,MIF.PO_NO,MIF.PART_NO,MIF.IN_QTY from MIF_D MIF, Part_Master PM where MIF.MIF_NO = '" & trim(lblMIFNo.text) & "' and MIF.Part_No = PM.Part_No order by mif.part_no asc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            if UpdateMIF("UPDATE") = true then
                ShowAlert("MIF Updated.")
                redirectPage("MIFIQCDet.aspx?ID=" & Request.params("ID"))
            End if
        End if
    End Sub
    
    Public Function UpdateMIF(OpeState as string) as boolean
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim cnnExecuteNonQuery As SqlConnection
            Dim myTrans As SqlTransaction
            Dim i as integer
            Dim AccQty,RejQty,IQCRem As textbox
            Dim PartType As DropDownList
            Dim ScarHeader,ScarSeqNo as long
            Dim ScarNo as string
            Dim InQty,SeqNo,PartNo,PONo As label
            Dim DefPCTG as decimal
    
            try
                cnnExecuteNonQuery = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
                cnnExecuteNonQuery.open()
                myTrans = cnnExecuteNonQuery.BeginTransaction()
                Dim myCommand as New SqlCommand("", cnnExecuteNonQuery, myTrans)
    
                ScarHeader = ReqCOM.GetFieldVal("select top 1 DOC_NO_HEADER from Main","DOC_NO_HEADER")
                ScarSeqNo = ReqCOM.GetFieldVal("select top 1 SCAR_NO from Main","SCAR_NO")
    
                For i = 0 To MyList.Items.Count - 1
                    AccQty = Ctype(MyList.Items(i).FindControl("AcceptQty"), Textbox)
                    RejQty = Ctype(MyList.Items(i).FindControl("RejQty"), Textbox)
                    IQCRem = Ctype(MyList.Items(i).FindControl("IQCRem"), Textbox)
                    InQty = Ctype(MyList.Items(i).FindControl("InQty"), Label)
                    SeqNo = Ctype(MyList.Items(i).FindControl("SeqNo"), Label)
    
                    PONo = Ctype(MyList.Items(i).FindControl("PONo"), Label)
    
                    PartNo = Ctype(MyList.Items(i).FindControl("PartNo"), Label)
    
                    PartType = Ctype(MyList.Items(i).FindControl("PartType"), DropDownList)
                    myCommand.CommandText = "Update MIF_D set Rej_Qty = " & RejQty.text & ", Accept_Qty = " & AccQty.text & ",Part_Type = '" & trim(PartType.selecteditem.value) & "',IQC_Rem = '" & trim(IQCRem.text) & "' where Seq_no = " & SeqNo.text & ";"
                    myCommand.ExecuteNonQuery
    
                    if trim(ucase(OpeState)) = "SUBMIT" then
                        if clng(RejQty.text) > 0 then
                            if len(trim(ScarSeqNo)) = 1 then ScarNo = "000" & trim(ScarSeqNo)
                            if len(trim(ScarSeqNo)) = 2 then ScarNo = "00" & trim(ScarSeqNo)
                            if len(trim(ScarSeqNo)) = 3 then ScarNo = "0" & trim(ScarSeqNo)
                            ScarNo = clng(ScarHeader) & trim(ScarNo)
    
                            ScarSeqNo = ScarSeqNo + 1
                            DefPCTG = cdec(RejQty.text) + cdec(AccQty.text)
                            DefPCTG = (cdec(RejQty.text) * 100) / cdec(DefPCTG)
                            myCommand.CommandText = "Insert into SCAR(SCAR_NO,VEN_CODE,MIF_NO,DEL_DATE,DEF_QTY,DEF_PCTG,PART_NO,DEF_DESC,PO_NO,CREATE_BY,CREATE_DATE) select '" & trim(ScarNo) & "','" & trim(lblSupplier.text) & "','" & trim(lblMIFNo.text) & "','" & now & "'," & trim(RejQty.text) & "," & trim(DefPCTG) & ",'" & trim(PartNo.text) & "','" & trim(IQCRem.text) & "','" & trim(PONo.text) & "','" & trim(request.cookies("U_ID").value) & "','" & now & "'"
                            myCommand.ExecuteNonQuery
                        end if
                    End if
                next
    
                if trim(ucase(OpeState)) = "SUBMIT" then
                    myCommand.CommandText = "Update MIF_M set App2_By = '" & trim(REQUEST.COOKIES("U_ID").VALUE) & "',App2_Date = '" & now & "',MIF_Status = 'APPROVED' where MIF_NO = '" & trim(lblMIFNo.text) & "';"
                    myCommand.ExecuteNonQuery
    
                    myCommand.CommandText = "Update Main set Scar_No = " & clng(ScarSeqNo) & ";"
                    myCommand.ExecuteNonQuery
                End if
    
                ''Update Sample Size(Electrical Part)
                myCommand.CommandText = "Update MIF_D SET MIF_D.SAMPLE_SIZE=IQC_MIL_STD.QTY_VALUE FROM MIF_D,IQC_MIL_STD WHERE IQC_MIL_STD.CHECK_TYPE = 'Sample Size' AND MIF_D.PART_TYPE = 'Electrical' AND IQC_MIL_STD.PART_TYPE = 'Electrical' AND MIF_D.in_qty between IQC_MIL_STD.QTY_FROM AND IQC_MIL_STD.QTY_TO AND MIF_D.mif_no = '" & trim(lblMIFNo.text) & "';"
                myCommand.ExecuteNonQuery
    
                ''Update Sample Size(Other Part)
                myCommand.CommandText = "Update MIF_D SET MIF_D.SAMPLE_SIZE=IQC_MIL_STD.QTY_VALUE FROM MIF_D,IQC_MIL_STD WHERE IQC_MIL_STD.CHECK_TYPE = 'Sample Size' AND MIF_D.PART_TYPE <> 'Electrical' AND IQC_MIL_STD.PART_TYPE <> 'Electrical' AND MIF_D.in_qty between IQC_MIL_STD.QTY_FROM AND IQC_MIL_STD.QTY_TO AND MIF_D.mif_no = '" & trim(lblMIFNo.text) & "';"
                myCommand.ExecuteNonQuery
    
                ''Update Major(Electrical Part)
                myCommand.CommandText = "Update MIF_D SET MIF_D.Major=IQC_MIL_STD.QTY_VALUE FROM MIF_D,IQC_MIL_STD WHERE IQC_MIL_STD.CHECK_TYPE = 'Major' AND MIF_D.PART_TYPE = 'Electrical' AND IQC_MIL_STD.PART_TYPE = 'Electrical' AND MIF_D.in_qty between IQC_MIL_STD.QTY_FROM AND IQC_MIL_STD.QTY_TO AND MIF_D.mif_no = '" & trim(lblMIFNo.text) & "';"
                myCommand.ExecuteNonQuery
    
                ''Update Major(Other Part)
                myCommand.CommandText = "Update MIF_D SET MIF_D.Major=IQC_MIL_STD.QTY_VALUE FROM MIF_D,IQC_MIL_STD WHERE IQC_MIL_STD.CHECK_TYPE = 'Major' AND MIF_D.PART_TYPE <> 'Electrical' AND IQC_MIL_STD.PART_TYPE <> 'Electrical' AND MIF_D.in_qty between IQC_MIL_STD.QTY_FROM AND IQC_MIL_STD.QTY_TO AND MIF_D.mif_no = '" & trim(lblMIFNo.text) & "';"
                myCommand.ExecuteNonQuery
    
                ''Update Minor(Electrical Part)
                myCommand.CommandText = "Update MIF_D SET MIF_D.Minor=IQC_MIL_STD.QTY_VALUE FROM MIF_D,IQC_MIL_STD WHERE IQC_MIL_STD.CHECK_TYPE = 'Minor' AND MIF_D.PART_TYPE = 'Electrical' AND IQC_MIL_STD.PART_TYPE = 'Electrical' AND MIF_D.in_qty between IQC_MIL_STD.QTY_FROM AND IQC_MIL_STD.QTY_TO AND MIF_D.mif_no = '" & trim(lblMIFNo.text) & "';"
                myCommand.ExecuteNonQuery
    
                ''Update Minor(Other Part)
                myCommand.CommandText = "Update MIF_D SET MIF_D.Minor=IQC_MIL_STD.QTY_VALUE FROM MIF_D,IQC_MIL_STD WHERE IQC_MIL_STD.CHECK_TYPE = 'Minor' AND MIF_D.PART_TYPE <> 'Electrical' AND IQC_MIL_STD.PART_TYPE <> 'Electrical' AND MIF_D.in_qty between IQC_MIL_STD.QTY_FROM AND IQC_MIL_STD.QTY_TO AND MIF_D.mif_no = '" & trim(lblMIFNo.text) & "';"
                myCommand.ExecuteNonQuery
    
    
                myTrans.Commit
                UpdateMIF = true
            catch ex as exception
                UpdateMIF = false
                myTrans.Rollback()
                showalert (ex.message & "\n\nPls. contact System Administrator.")
            Finally
                cnnExecuteNonQuery.Close()
            end try
        End if
    End Function

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">MATERIAL INCOMING
                                DETAILS</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="CheckMIF" runat="server" EnableClientScript="False" ErrorMessage="" Display="Dynamic" ForeColor=" " OnServerValidate="ValMIF" Width="100%" CssClass="ErrorText"></asp:CustomValidator>
                                                </p>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" width="142px" cssclass="LabelNormal">MIF Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFDate" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" width="142px" cssclass="LabelNormal">MIF No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblMIFNo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" width="142px" cssclass="LabelNormal">Supplier</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSupplier" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblVenName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" width="142px" cssclass="LabelNormal">Invoice
                                                                    No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblInvNo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="142px" cssclass="LabelNormal">D/O No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblDONo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="142px" cssclass="LabelNormal">Custom
                                                                    Form No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCustomFormNo" runat="server" width="402px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" width="142px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" runat="server" Width="402px" CssClass="OutputText" Height="78px" TextMode="MultiLine" ReadOnly="True"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="159px" cssclass="LabelNormal">Rec. Store
                                                                    App By / Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                    -&nbsp; <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" width="142px" cssclass="LabelNormal">IQC App
                                                                    By / Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                    -&nbsp; <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td class="SectionHeader" width="40%">
                                                                    <div align="center"><asp:Label id="Label12" runat="server" cssclass="SectionHeader" height="10px">MIF
                                                                        DETAILS</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotop" style="HEIGHT: 13px" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataList id="MyList" runat="server" Width="100%" Height="101px" RepeatColumns="1" BorderWidth="0px" CellPadding="1" Font-Size="XX-Small" Font-Names="Arial" OnSelectedIndexChanged="MyList_SelectedIndexChanged">
                                                                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                            <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                            <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                            <ItemTemplate>
                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td width="18%" bgcolor= "silver">
                                                                                                <asp:Label id="RowSeq" cssclass="ErrorText" visible="true" runat="server" text='1' /> <span class="ListLabel">P/O
                                                                                                # : </span></td>
                                                                                            <td width="32%">
                                                                                                <asp:Label id="PONo" visible="TRUE" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "po_no") %>' /> 
                                                                                            </td>
                                                                                            <td width="18%" bgcolor= "silver">
                                                                                                <span class="ListLabel">Part Type : </span></td>
                                                                                            <td width="32%">
                                                                                                <asp:Label id="PartTypeTemp" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Type") %>' /> 
                                                                                                <asp:DropDownList id="PartType" runat="server" CssClass="OutputText">
                                                                                                    <asp:ListItem Value="GENERAL">General</asp:ListItem>
                                                                                                    <asp:ListItem Value="PACKING">Packing</asp:ListItem>
                                                                                                    <asp:ListItem Value="PLASTIC">Plastic</asp:ListItem>
                                                                                                    <asp:ListItem Value="ELECTRONIC">Electronic</asp:ListItem>
                                                                                                </asp:DropDownList>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor= "silver">
                                                                                                <span class="ListLabel">Part #. : </span></td>
                                                                                            <td>
                                                                                                <asp:Label id="PartNo" cssclass="OutputText" visible="true" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                                            </td>
                                                                                            <td bgcolor= "silver">
                                                                                                <span class="ListLabel">Description : </span></td>
                                                                                            <td>
                                                                                                <asp:Label id="PartDesc" cssclass="OutputText" visible="true" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor= "silver">
                                                                                                <span class="ListLabel">Specification : </span></td>
                                                                                            <td colspan="3">
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Part_Spec") %> </span> <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor= "silver">
                                                                                                <span class="ListLabel">In Qty</span></td>
                                                                                            <td>
                                                                                                <asp:Label id="InQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "IN_QTY") %>' /> 
                                                                                            </td>
                                                                                            <td bgcolor= "silver">
                                                                                                <span class="ListLabel">Acc Qty/Rej. Qty</span></td>
                                                                                            <td>
                                                                                                <asp:Textbox id="AcceptQty" CssClass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Accept_Qty") %>' width= "70px" />
                                                                                                <asp:Textbox id="RejQty" CssClass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Rej_Qty") %>' width= "70px" />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor= "silver" valign="top">
                                                                                                <span class="ListLabel">IQC Remarks</span></td>
                                                                                            <td colspan="3">
                                                                                                <asp:Textbox id="IQCRem" TextMode="MultiLine" width="550px" CssClass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "IQC_Rem") %>' />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                                <br />
                                                                            </ItemTemplate>
                                                                            <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                        </asp:DataList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdApprove" onclick="cmdApprove_Click" runat="server" Width="136px" CssClass="OutputText" Text="Update and Submit"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="136px" CssClass="OutputText" Text="Update MIF"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="136px" CssClass="OutputText" Text="Back"></asp:Button>
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
