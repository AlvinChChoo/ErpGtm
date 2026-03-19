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
            'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            'ShowMainPartDet
            'ShowAltPartDet
            'FormatRow
            'if trim(lblStdDate.text) <> "" then lblStdDate.text = format(cdate(lblStdDate.text),"dd/MM/yy")
            'lblSubmitBy.text = trim(ReqCOM.GetFIeldVal("Select Submit_By from BOM_Quote_M where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';","Submit_By"))
    
    
    
    
            'MainPartSeqNo = ReqCOM.GetFieldVal("Select Seq_No from BOM_Quote_D where main_part = '" & trim(MainPart.text) & "' and part_no = '" & trim(MainPart.text) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';","Seq_No")
            'ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set last_edited_ind_by = null where last_edited_ind_by = '" & trim(request.cookies("U_ID").value) & "'")
            'ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set last_edited_ind_by = '" & trim(request.cookies("U_ID").value) & "' where seq_no = " & MainPartSeqNo & ";")
            'ShowReport("BOMQuotePartDet.aspx?ID=" & trim(MainPartSeqNo))
            'procLoadGridData
    
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            Dim MainPartSeqNo as long
            Dim MainPart as string
    
    
    
            lblBOMQuoteNo.text = ReqCOM.GetFieldVal("Select top 1 BOM_Quote_No from BOM_Quote_D where Seq_No = " & clng(Request.params("ID")) & ";","BOM_Quote_No")
    
            MainPart = ReqCOM.GetFieldVal("select Main_Part from BOM_Quote_D where Seq_No = " & clng(request.params("ID")) & ";","Main_Part")
            MainPartSeqNo = ReqCOM.GetFieldVal("Select Seq_No from BOM_Quote_D where main_part = '" & trim(MainPart) & "' and part_no = '" & trim(MainPart) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';","Seq_No")
    
    
    
            ShowMainPartDet(MainPartSeqNo)
    
    
            ShowAltPartDet
            FormatRow
            if trim(lblStdDate.text) <> "" then lblStdDate.text = format(cdate(lblStdDate.text),"dd/MM/yy")
            lblSubmitBy.text = trim(ReqCOM.GetFIeldVal("Select Submit_By from BOM_Quote_M where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "';","Submit_By"))
    
    
        end if
    End Sub
    
    sub ShowAltPartDet()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        Dim StrSql as string = "Select * from BOM_Quote_D where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and Main_Part = '" & trim(lblMainPart.text) & "' and main_part <> Part_No"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
    Sub ShowMainPartDet(MainPartSeqNo)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        lblBOMQuoteNo.text = ReqCOM.GetFieldVal("select BOM_Quote_No from BOM_Quote_D where Seq_No = " & clng(MainPartSeqNo) & ";","BOM_Quote_No")
        lblMainPart.text = ReqCOM.GetFieldVal("select Main_Part from BOM_Quote_D where Seq_No = " & clng(MainPartSeqNo) & ";","Main_Part")
    
        Dim strSql as string = "Select * from BOM_Quote_D where Bom_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and main_part = '" & trim(lblMainPart.text) & "' AND MAIN_PART = PART_NO;"
    
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        do while drGetFieldVal.read
            lblPartNo.text = drGetFieldVal("Part_No").tostring
            lblPartDesc.text = drGetFieldVal("Part_Desc").tostring
            lblPartSpec.text = drGetFieldVal("Part_Spec").tostring
            lblCustPartNo.text = drGetFieldVal("Cust_Part_No").tostring
            lblMFGName.text = drGetFieldVal("MFG_Name").tostring
            lblMFGPartNo.text = drGetFieldVal("MFG_MPN").tostring
            lblLowDate.text = drGetFieldVal("Lowest_Date").tostring
            lblLowUP.text = drGetFieldVal("Lowest_UP").tostring
            lblLowOriCurr.text = drGetFieldVal("Lowest_Curr_Code").tostring
            lblLowOriUP.text = drGetFieldVal("Lowest_Ori_UP").tostring
            lblLowLT.text = drGetFieldVal("Lowest_Lt").tostring
            lblLowSPQ.text = drGetFieldVal("Lowest_SPQ").tostring
            lblLowMOQ.text = drGetFieldVal("Lowest_MOQ").tostring
            lblLowVenName.text = drGetFieldVal("Lowest_Ven_Name").tostring
            lblLowRefNo.text = drGetFieldVal("lowest_Ref_No").tostring
            lblHighDate.text = drGetFieldVal("Highest_Date").tostring
            lblHighUP.text = drGetFieldVal("Highest_UP").tostring
            lblHighOriCurr.text = drGetFieldVal("Highest_Curr_Code").tostring
            lblHighOriUP.text = drGetFieldVal("Highest_Ori_UP").tostring
            lblHighLT.text = drGetFieldVal("Highest_Lt").tostring
            lblHighSPQ.text = drGetFieldVal("Highest_SPQ").tostring
            lblHighMOQ.text = drGetFieldVal("Highest_MOQ").tostring
            lblHighVenName.text = drGetFieldVal("Highest_Ven_Name").tostring
            lblHighRefNo.text = drGetFieldVal("Highest_Ref_No").tostring
            lbl1stDate.text = drGetFieldVal("First_Date").tostring
            lbl1stUP.text = drGetFieldVal("First_UP").tostring
            lbl1stOriCurr.text = drGetFieldVal("First_Curr_Code").tostring
            lbl1stOriUP.text = drGetFieldVal("First_Ori_UP").tostring
            lbl1stLT.text = drGetFieldVal("First_Lt").tostring
            lbl1stSPQ.text = drGetFieldVal("First_SPQ").tostring
            lbl1stMOQ.text = drGetFieldVal("First_MOQ").tostring
            lbl1stVenName.text = drGetFieldVal("First_Ven_Name").tostring
            lbl1stRefNo.text = drGetFieldVal("First_Ref_No").tostring
            lblLastQuoteDate.text = drGetFieldVal("Last_Quote_Date").tostring
            lblLastQuoteUP.text = drGetFieldVal("Last_Quote_UP").tostring
            lblLastQuoteCurr.text = drGetFieldVal("Last_Quote_Curr_Code").tostring
            lblLastQuoteOriUP.text = drGetFieldVal("Last_Quote_Ori_UP").tostring
            lblLastQuoteLT.text = drGetFieldVal("Last_Quote_Lt").tostring
            lblLastQuoteSPQ.text = drGetFieldVal("Last_Quote_SPQ").tostring
            lblLastQuoteMOQ.text = drGetFieldVal("Last_Quote_MOQ").tostring
            lblLastQuoteVenName.text = drGetFieldVal("Last_Quote_Ven_Name").tostring
            lblLastQuoteRefNo.text = drGetFieldVal("Last_Quote_Ref_No").tostring
            lblStdDate.text = drGetFieldVal("Std_Date").tostring
            lblStdUP.text = drGetFieldVal("Std_UP").tostring
            lblStdCurr.text = drGetFieldVal("Std_Curr_Code").tostring
            lblStdOriUP.text = drGetFieldVal("Std_Ori_UP").tostring
            lblStdLT.text = drGetFieldVal("Std_Lt").tostring
            lblStdSPQ.text = drGetFieldVal("Std_SPQ").tostring
            lblStdMOQ.text = drGetFieldVal("Std_MOQ").tostring
            lblStdVenName.text = drGetFieldVal("Std_Ven_Name").tostring
            lblwacDate.text = drGetFieldVal("WAC_Date").tostring
            lblWAC.text = drGetFieldVal("WAC").tostring
            lblAverageHiLow.text = drGetFieldVal("Average_Hi_Low").tostring
            lblPUsage.text = format(cdec(drGetFieldVal("P_Usage")),"##,##0.0000")
    
            if trim(lblwacDate.text) <> "" then lblwacDate.text = format(cdate(lblwacDate.text),"dd/MM/yy")
            if trim(lblHighDate.text) <> "" then lblHighDate.text = format(cdate(lblHighDate.text),"dd/MM/yy")
            if trim(lblLowDate.text) <> "" then lblLowDate.text = format(cdate(lblLowDate.text),"dd/MM/yy")
            if trim(lbl1stDate.text) <> "" then lbl1stDate.text = format(cdate(lbl1stDate.text),"dd/MM/yy")
            if trim(lblLastQuoteDate.text) <> "" then lblLastQuoteDate.text = format(cdate(lblLastQuoteDate.text),"dd/MM/yy")
            txtRem.text = trim(drGetFieldVal("Rem").tostring)
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim lblAltRem as Textbox
        Dim chkRemove as CheckBox
        Dim SeqNo as label
        Dim i As Integer
        ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set REm = '" & trim(txtRem.text) & "' where Seq_No = " & clng(request.params("ID")) & "")
        For i = 0 To MyList.Items.Count - 1
            lblAltRem = CType(MyList.Items(i).FindControl("lblAltRem"), Textbox)
            SeqNo = CType(MyList.Items(i).FindControl("SeqNo"), Label)
    
            'Code to remove alt. part
    
            ReqCOM.ExecuteNonQuery ("Update BOM_Quote_D set Rem = '" & trim(lblAltRem.text) & "' where Seq_No = " & clng(SeqNo.text) & ";")
        Next
        ShowAlert("Item remarks updated")
        redirectPage("BOMQuotePartDet.aspx?ID=" & Request.params("ID"))
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
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub FormatRow()
        Dim i As Integer
        Dim lblAltUsage,WACDate,lblStdDate,lblLastQuoteDate,lblAlt1stDate,lblAltLowDate,lblAltHighDate as label
        For i = 0 To MyList.Items.Count - 1
            WACDate = CType(MyList.Items(i).FindControl("WACDate"), Label)
            lblStdDate = CType(MyList.Items(i).FindControl("lblStdDate"), Label)
            lblStdDate = CType(MyList.Items(i).FindControl("lblStdDate"), Label)
            lblLastQuoteDate = CType(MyList.Items(i).FindControl("lblLastQuoteDate"), Label)
            lblAlt1stDate = CType(MyList.Items(i).FindControl("lblAlt1stDate"), Label)
            lblAltLowDate = CType(MyList.Items(i).FindControl("lblAltLowDate"), Label)
            lblAltHighDate = CType(MyList.Items(i).FindControl("lblAltHighDate"), Label)
            lblAltUsage = CType(MyList.Items(i).FindControl("lblAltUsage"), Label)
            lblAltUsage.text = clng(lblAltUsage.text)
    
            if trim(WACDate.text) <> "" then WACDate.text = format(cdate(WACDate.text),"dd/MM/yy")
            if trim(lblLastQuoteDate.text) <> "" then lblLastQuoteDate.text = format(cdate(lblLastQuoteDate.text),"dd/MM/yy")
            if trim(lblAlt1stDate.text) <> "" then lblAlt1stDate.text = format(cdate(lblAlt1stDate.text),"dd/MM/yy")
            if trim(lblStdDate.text) <> "" then lblStdDate.text = format(cdate(lblStdDate.text),"dd/MM/yy")
            if trim(lblAltLowDate.text) <> "" then lblAltLowDate.text = format(cdate(lblAltLowDate.text),"dd/MM/yy")
            if trim(lblAltHighDate.text) <> "" then lblAltHighDate.text = format(cdate(lblAltHighDate.text),"dd/MM/yy")
        Next
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub lnkEdit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOM.FuncCheckDuplicate("Select Part_No from Part_Master where Part_no = '" & trim(lblPartNo.text) & "';","Part_No") = true then
            ShowReport("PopupBOMQuoteStdCost.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from part_Master where Part_No = '" & trim(lblPartNo.text) & "';","Seq_No"))
        else
            ShowReport("BOMQuotePartEdit.aspx?ID=" & clng(request.params("ID")))
        End if
    End Sub
    
    Sub lnkUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQUery("update bom_quote_d set bom_quote_d.STD_UP = part_master.std_cost_purc,bom_quote_d.STD_VEN_CODE = part_master.ref_supp_code_purc,bom_quote_d.STD_VEN_NAME = part_master.ref_supp_purc,bom_quote_d.STD_CURR_CODE = part_master.std_cost_purc_curr_code,bom_quote_d.STD_ORI_UP = part_master.ori_std_cost_purc,bom_quote_d.STD_DATE = part_master.purc_cost_date,bom_quote_d.std_lt = part_master.lead_time_purc,bom_quote_d.STD_SPQ = part_master.spq_purc,STD_MOQ = part_master.moq_purc from bom_quote_d,part_master where bom_quote_d.bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' and bom_quote_d.part_no = part_master.part_no and bom_quote_d.Part_No = '" & trim(lblPartNo.text) & "' and bom_quote_d.Main_Part = '" & trim(lblPartNo.text) & "';")
        Response.redirect("BOMQuotePartDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowSelection(s as object,e as DataListCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim MainPart,PartNo as string
        Dim REqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        MainPart = REqCOM.GetFieldVal("Select Main_Part from BOM_Quote_D where Seq_No = " & clng(SeqNo.text) & ";","Main_Part")
        PartNo = REqCOM.GetFieldVal("Select Part_No from BOM_Quote_D where Seq_No = " & clng(SeqNo.text) & ";","Part_No")
    
        if trim(ucase(e.commandArgument)) = "EDIT" then
            if ReqCOM.FuncCheckDuplicate("Select Part_No from Part_Master where Part_no = '" & trim(PartNo) & "';","Part_No") = true then
                ShowReport("PopupBOMQuoteStdCost.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from part_Master where Part_No = '" & trim(PartNo) & "';","Seq_No"))
            else
                ShowReport("BOMQuotePartEdit.aspx?ID=" & clng(SeqNo.text))
            End if
        elseif trim(ucase(e.commandArgument)) = "UPDATE" then
            ReqCOM.ExecuteNonQUery("update bom_quote_d set bom_quote_d.STD_UP = part_master.std_cost_purc,bom_quote_d.STD_VEN_CODE = part_master.ref_supp_code_purc,bom_quote_d.STD_VEN_NAME = part_master.ref_supp_purc,bom_quote_d.STD_CURR_CODE = part_master.std_cost_purc_curr_code,bom_quote_d.STD_ORI_UP = part_master.ori_std_cost_purc,bom_quote_d.STD_DATE = part_master.purc_cost_date,bom_quote_d.std_lt = part_master.lead_time_purc,bom_quote_d.STD_SPQ = part_master.spq_purc,STD_MOQ = part_master.moq_purc from bom_quote_d,part_master where bom_quote_d.bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' and bom_quote_d.part_no = part_master.part_no and bom_quote_d.Part_No = '" & trim(PartNo) & "' and bom_quote_d.Main_Part = '" & trim(MainPart) & "';")
            Response.redirect("BOMQuotePartDet.aspx?ID=" & Request.params("ID"))
        END IF
    end sub
    
    Sub cmdAddAlt_Click(sender As Object, e As EventArgs)
        Response.redirect("BOMQuotePartAddAlt.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim chkRemove as CheckBox
        Dim SeqNo as label
        Dim i As Integer
        For i = 0 To MyList.Items.Count - 1
            SeqNo = CType(MyList.Items(i).FindControl("SeqNo"), Label)
            chkRemove = CType(MyList.Items(i).FindControl("chkRemove"), CheckBox)
            if ChkRemove.Checked = true then ReqCOM.ExecuteNonQuery("Delete from BOM_Quote_D where seq_no = " & clng(SeqNo.text) & ";")
        Next
        ShowAlert("Selected alternate part(s) has been removed from This Bom Quote.")
        redirectPage("BOMQuotePartDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim MainPart as string
        ReqCOm.ExecuteNonQUery("Update BOM_Quote_D set ind = 'N'")
        ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Ind = 'Y' where Main_Part = '" & trim(lblPartNo.text) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
        ReqCOM.GetHighestStdCost
        MainPart = ReqCOm.GetFieldVal("Select main_Part from BOM_Quote_D where part_no = '" & trim(lblPartNo.text) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';","Main_Part")
        Response.redirect("BOMQuotePartDet.aspx?ID=" & ReqCOM.GetFIeldVal("Select Seq_No from BOM_Quote_D where bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' and Main_Part = '" & trim(MainPart) & "' and main = 'MAIN'","Seq_No"))
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
            <script language="javascript">

function getObj(name)
    {
        if (document.getElementById) // test if browser supports document.getElementById
            {
                this.obj = document.getElementById(name);
                this.style = document.getElementById(name).style;
            }
        else if (document.all) // test if browser supports document.all
            {
                this.obj = document.all[name];
                this.style = document.all[name].style;
            }
        else if (document.layers) // test if browser supports document.layers
            {
                this.obj = document.layers[name];
                this.style = document.layers[name].style;
            }
    }

function checkedChange()
    {
        var rbPartNo = new getObj('rbPartNo');
        var rbOthers = new getObj('rbPONo');
        var txtPartFrom = new getObj('txtPartFrom');
        var txtPartTo = new getObj('txtPartTo');
        var txtPOFrom = new getObj('txtPOFrom');
        var txtPOTo = new getObj('txtPOTo');

        if (rbPartNo.obj.checked == true)
            {
                txtPartFrom.obj.disabled = false;
                txtPartTo.obj.disabled = false;
                txtPOFrom.obj.value = "";
                txtPOTo.obj.value = "";
                txtPOFrom.obj.disabled = true;
                txtPOTo.obj.disabled = true;
            }
        else if (rbOthers.obj.checked == true)
            {
                txtPartFrom.obj.disabled = true;
                txtPartTo.obj.disabled = true;
                txtPartFrom.obj.value = "";
                txtPartTo.obj.value = "";
                txtPOFrom.obj.disabled = false;
                txtPOTo.obj.disabled = false;
            }
    }
</script>
        </p>
        <p align="center">
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="730">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="98%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Main Part</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <br />
                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="98%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="20%" bgcolor="silver">
                                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">BOM Quotation No</asp:Label>&nbsp;&nbsp; 
                                                                                </td>
                                                                                <td>
                                                                                    <asp:Label id="lblBOMQuoteNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">G-Tek Part #</asp:Label>&nbsp; 
                                                                                </td>
                                                                                <td width="75%">
                                                                                    <div align="left"><asp:Label id="lblPartNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;&nbsp; 
                                                                                        <asp:LinkButton id="lnkEdit" onclick="lnkEdit_Click" runat="server" CssClass="OutputText">[Edit]</asp:LinkButton>
                                                                                        <asp:LinkButton id="lnkUpdate" onclick="lnkUpdate_Click" runat="server" CssClass="OutputText">[Update]</asp:LinkButton>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label46" runat="server" cssclass="LabelNormal">Customer P/N</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblCustPartNo" runat="server" cssclass="OutputText"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left">
                                                                                        <div align="left"><asp:Label id="lblPartDesc" runat="server" cssclass="OutputText"></asp:Label>
                                                                                        </div>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal">Specification</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblPartSpec" runat="server" cssclass="OutputText"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Manufacturer part No</asp:Label></td>
                                                                                <td>
                                                                                    <div align="left"><asp:Label id="lblMfgPartNo" runat="server" cssclass="OutputText"></asp:Label>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label39" runat="server" cssclass="LabelNormal">Manufacturer Name</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblMFGName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Usage</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPUsage" runat="server" cssclass="OutputText"></asp:Label><asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                                <td>
                                                                                    <asp:TextBox id="txtRem" runat="server" CssClass="OutputText" Width="462px" TextMode="MultiLine"></asp:TextBox>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="98%" align="center" border="1">
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
                                                                                    <asp:Label id="Label43" runat="server" cssclass="LabelNormal">Actual Highest</asp:Label></td>
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
                                                                                    <asp:Label id="Label44" runat="server" cssclass="LabelNormal">Average Actual Hi Lo</asp:Label></td>
                                                                                <td>
                                                                                </td>
                                                                                <td>
                                                                                    <asp:Label id="lblAverageHiLow" runat="server" cssclass="OutputText"></asp:Label></td>
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
                                                                    <br />
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Alternate Part</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <br />
                                                                        <asp:DataList id="MyList" runat="server" Width="98%" Height="101px" CellPadding="1" BorderWidth="0px" RepeatColumns="1" OnSelectedIndexChanged="MyList_SelectedIndexChanged" OnItemCommand="ShowSelection">
                                                                            <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                            <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                            <ItemTemplate>
                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td bgcolor="silver"></td>
                                                                                            <td>
                                                                                                <asp:CheckBox id="chkRemove" runat="server" cssclass="OutputText" text= "Remove this alternate part"></asp:CheckBox>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label61" runat="server" cssclass="LabelNormal">G-TEk Part #</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltPartNo" runat="server" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>'></asp:Label> <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' visible= "false"></asp:Label> 
                                                                                                <asp:LinkButton font-size="xx-small" id="lnkAltEdit" text='[Edit]' CssClass="OutputText" CommandArgument='Edit' runat="server" />
                                                                                                <asp:LinkButton font-size="xx-small" id="lnkAltUpdate" text='[Update]' CssClass="OutputText" CommandArgument='Update' runat="server" />
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label91" runat="server" cssclass="LabelNormal">Customer P/N</asp:Label></td>
                                                                                            <td>
                                                                                                <div align="left"><asp:Label id="lblAltCustPartNo" runat="server" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Cust_Part_No") %>' width="100%"></asp:Label> 
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label121" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                                                                            <td>
                                                                                                <div align="left">
                                                                                                    <div align="left"><asp:Label id="lblAltPartDesc" runat="server" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' width="100%"></asp:Label> 
                                                                                                    </div>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label151" runat="server" cssclass="LabelNormal">Specification</asp:Label></td>
                                                                                            <td>
                                                                                                <div align="left"><asp:Label id="lblAltPartSpec" runat="server" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>' width="100%"></asp:Label> 
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label181" runat="server" cssclass="LabelNormal">Manufacturer part No</asp:Label></td>
                                                                                            <td>
                                                                                                <div align="left"><asp:Label id="lblAltMFGPartNo" runat="server" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "MFG_MPN") %>' width="100%"></asp:Label> 
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label201" runat="server" cssclass="LabelNormal">Manufacturer Name</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltMFGName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG_Name") %>' cssclass="OutputText"></asp:Label></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label20121" runat="server" cssclass="LabelNormal">Usage</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltUsage" runat="server" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") %>' ></asp:Label> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label2012" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Textbox id="lblAltRem" Width="462px" runat="server" CssClass="OutputText" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "REM") %>' ></asp:Textbox>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td bgcolor="silver"></td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">DD/MM/YY</asp:Label></td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">IN RM</asp:Label></td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Ori. Curr</asp:Label></td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Ori. Cost</asp:Label></td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">L/T</asp:Label></td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal">SPQ</asp:Label></td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal">MOQ</asp:Label></td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label12" runat="server" cssclass="LabelNormal">Supplier</asp:Label></td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Quote/UPA #</asp:Label></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label15" runat="server" cssclass="LabelNormal">Standard</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblStdDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Date") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblStdUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_UP") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblStdOriCurr" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Curr_Code") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblStdOriUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Ori_UP") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblStdLT" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_LT") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblStdSPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_SPQ") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblStdMOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_MOQ") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblStdRefNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Ref_No") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td rowspan="1"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label25" runat="server" cssclass="LabelNormal">Last Quote</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblLastQuoteDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "last_quote_date") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblLastQuoteUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "last_quote_up") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblLastQuoteOriCurr" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "last_quote_curr_code") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblLastQuoteOriUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "last_quote_ori_up") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblLastQuoteLT" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "last_quote_lt") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblLastQuoteSPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "last_quote_spq") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblLastQuoteMOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "last_quote_moq") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblLastQuoteVenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "last_quote_ven_name") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblLastQuoteRefNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "last_quote_ref_no") %>' cssclass="OutputText"></asp:Label></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label53" runat="server" cssclass="LabelNormal">1st Supp.</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAlt1stDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "first_date") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAlt1stUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "first_up") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAlt1stOriCurr" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "first_Curr_code") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAlt1stOriUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "first_ori_up") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAlt1stLT" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "first_lt") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAlt1stSPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "first_spq") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAlt1stMOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "first_moq") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAlt1stVenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "first_ven_name") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAlt1stRefNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "first_ref_no") %>' cssclass="OutputText"></asp:Label></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label63" runat="server" cssclass="LabelNormal">Actual Lowest</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltLowDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "lowest_Date") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltLowUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "lowest_up") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltLowOriCurr" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "lowest_curr_code") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltLowOriUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "lowest_ori_up") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltLowLT" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "lowest_lt") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltLowSPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "lowest_spq") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltLowMOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "lowest_moq") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltLowVenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "lowest_ven_name") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltLowRefNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "lowest_Ref_No") %>' cssclass="OutputText"></asp:Label></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label73" runat="server" cssclass="LabelNormal">Actual Highest</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltHighDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Highest_Date") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltHighUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Highest_UP") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltHighOriCurr" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "highest_Curr_Code") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltHighOriUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "highest_ori_up") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltHighLT" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "highest_lt") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltHighSPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "highest_spq") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltHighMOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "highest_moq") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltHighVenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "highest_ven_name") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAltHighRefNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "highest_Ref_No") %>' cssclass="OutputText"></asp:Label></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label83" runat="server" cssclass="LabelNormal">Average Actual Hi Lo</asp:Label></td>
                                                                                            <td></td>
                                                                                            <td>
                                                                                                <asp:Label id="lblAverageHiLow" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Average_Hi_Low") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td colspan="7" rowspan="2"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label85" runat="server" cssclass="LabelNormal">WAC</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="WACDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "wac_date") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label id="WAC" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "wac") %>' cssclass="OutputText"></asp:Label></td>
                                                                                        </tr>
                                                                                    </tbody>
                                                                                </table>
                                                                                <br />
                                                                            </ItemTemplate>
                                                                            <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                                        </asp:DataList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </p>
                            </div>
                            <p>
                                <table style="HEIGHT: 18px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td width="25%">
                                                <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Width="122px" Text="SWAP" CausesValidation="False"></asp:Button>
                                            </td>
                                            <td width="25%">
                                                <asp:Button id="cmdAddAlt" onclick="cmdAddAlt_Click" runat="server" Width="148px" Text="Add Alternate Part" CausesValidation="False"></asp:Button>
                                                <asp:Label id="lblMainPart" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                            <td width="25%">
                                                <div align="center">
                                                    <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="175px" Text="Remove Selected Part(s)" CausesValidation="False"></asp:Button>
                                                </div>
                                            </td>
                                            <td width="25%">
                                                <div align="right">
                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="159px" Text="Update Item Remarks" CausesValidation="False"></asp:Button>
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
