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
            ShowMainPartDet
            ShowAltPartDet
            FormatRow
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
    
    Sub ShowMainPartDet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        lblBOMQuoteNo.text = ReqCOM.GetFieldVal("select BOM_Quote_No from BOM_Quote_D where Seq_No = " & clng(request.params("ID")) & ";","BOM_Quote_No")
        lblMainPart.text = ReqCOM.GetFieldVal("select Main_Part from BOM_Quote_D where Seq_No = " & clng(request.params("ID")) & ";","Main_Part")
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
    
            if isdbnull(drGetFieldVal("Lowest_Date")) = false then lblLowDate.text = format(cdate(drGetFieldVal("Lowest_Date")),"dd/MM/yy")
            lblLowUP.text = drGetFieldVal("Lowest_UP").tostring
            lblLowOriCurr.text = drGetFieldVal("Lowest_Curr_Code").tostring
            lblLowOriUP.text = drGetFieldVal("Lowest_Ori_UP").tostring
            lblLowLT.text = drGetFieldVal("Lowest_Lt").tostring
            lblLowSPQ.text = drGetFieldVal("Lowest_SPQ").tostring
            lblLowMOQ.text = drGetFieldVal("Lowest_MOQ").tostring
            lblLowVenName.text = drGetFieldVal("Lowest_Ven_Name").tostring
            lblLowRefNo.text = drGetFieldVal("lowest_Ref_No").tostring
    
            if isdbnull(drGetFieldVal("Highest_Date")) = false then lblHighDate.text = format(cdate(drGetFieldVal("Highest_Date")),"dd/MM/yy")
            lblHighUP.text = drGetFieldVal("Highest_UP").tostring
            lblHighOriCurr.text = drGetFieldVal("Highest_Curr_Code").tostring
            lblHighOriUP.text = drGetFieldVal("Highest_Ori_UP").tostring
            lblHighLT.text = drGetFieldVal("Highest_Lt").tostring
            lblHighSPQ.text = drGetFieldVal("Highest_SPQ").tostring
            lblHighMOQ.text = drGetFieldVal("Highest_MOQ").tostring
            lblHighVenName.text = drGetFieldVal("Highest_Ven_Name").tostring
            lblHighRefNo.text = drGetFieldVal("Highest_Ref_No").tostring
    
            if isdbnull(drGetFieldVal("First_Date")) = false then lbl1stDate.text = format(cdate(drGetFieldVal("First_Date")),"dd/MM/yy")
            lbl1stUP.text = drGetFieldVal("First_UP").tostring
            lbl1stOriCurr.text = drGetFieldVal("First_Curr_Code").tostring
            lbl1stOriUP.text = drGetFieldVal("First_Ori_UP").tostring
            lbl1stLT.text = drGetFieldVal("First_Lt").tostring
            lbl1stSPQ.text = drGetFieldVal("First_SPQ").tostring
            lbl1stMOQ.text = drGetFieldVal("First_MOQ").tostring
            lbl1stVenName.text = drGetFieldVal("First_Ven_Name").tostring
            lbl1stRefNo.text = drGetFieldVal("First_Ref_No").tostring
    
            if isdbnull(drGetFieldVal("Last_Quote_Date")) = false then lblLastQuoteDate.text = format(cdate(drGetFieldVal("Last_Quote_Date")),"dd/MM/yy")
            lblLastQuoteUP.text = drGetFieldVal("Last_Quote_UP").tostring
            lblLastQuoteCurr.text = drGetFieldVal("Last_Quote_Curr_Code").tostring
            lblLastQuoteOriUP.text = drGetFieldVal("Last_Quote_Ori_UP").tostring
            lblLastQuoteLT.text = drGetFieldVal("Last_Quote_Lt").tostring
            lblLastQuoteSPQ.text = drGetFieldVal("Last_Quote_SPQ").tostring
            lblLastQuoteMOQ.text = drGetFieldVal("Last_Quote_MOQ").tostring
            lblLastQuoteVenName.text = drGetFieldVal("Last_Quote_Ven_Name").tostring
            lblLastQuoteRefNo.text = drGetFieldVal("Last_Quote_Ref_No").tostring
    
            if isdbnull(drGetFieldVal("Std_Date")) = false then lblStdDate.text = format(cdate(drGetFieldVal("Std_Date")),"dd/MM/yy")
            lblStdUP.text = drGetFieldVal("Std_UP").tostring
            lblStdCurr.text = drGetFieldVal("Std_Curr_Code").tostring
            lblStdOriUP.text = drGetFieldVal("Std_Ori_UP").tostring
            lblStdLT.text = drGetFieldVal("Std_Lt").tostring
            lblStdSPQ.text = drGetFieldVal("Std_SPQ").tostring
            lblStdMOQ.text = drGetFieldVal("Std_MOQ").tostring
            lblStdVenName.text = drGetFieldVal("Std_Ven_Name").tostring
    
            if isdbnull(drGetFieldVal("WAC_Date")) = false then lblwacDate.text = format(cdate(drGetFieldVal("WAC_Date")),"dd/MM/yy")
            lblWAC.text = drGetFieldVal("WAC").tostring
    
            lblAverageHiLow.text = drGetFieldVal("Average_Hi_Low").tostring
        loop
    
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Response.redirect("BOMQuoteDetApp1.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from bom_quote_m where bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';","Seq_No"))
    End Sub
    
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
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub FormatRow()
        Dim i As Integer
        Dim WACDate,lblStdDate,lblLastQuoteDate,lblAlt1stDate,lblAltLowDate,lblAltHighDate as label
        For i = 0 To MyList.Items.Count - 1
            WACDate = CType(MyList.Items(i).FindControl("WACDate"), Label)
            lblStdDate = CType(MyList.Items(i).FindControl("lblStdDate"), Label)
            lblLastQuoteDate = CType(MyList.Items(i).FindControl("lblLastQuoteDate"), Label)
            lblAlt1stDate = CType(MyList.Items(i).FindControl("lblAlt1stDate"), Label)
            lblAltLowDate = CType(MyList.Items(i).FindControl("lblAltLowDate"), Label)
            lblAltHighDate = CType(MyList.Items(i).FindControl("lblAltHighDate"), Label)
    
            if trim(WACDate.text) <> "" then WACDate.text = format(cdate(WACDate.text),"dd/MM/yy")
            if trim(lblStdDate.text) <> "" then lblStdDate.text = format(cdate(lblStdDate.text),"dd/MM/yy")
            if trim(lblLastQuoteDate.text) <> "" then lblLastQuoteDate.text = format(cdate(lblLastQuoteDate.text),"dd/MM/yy")
            if trim(lblAlt1stDate.text) <> "" then lblAlt1stDate.text = format(cdate(lblAlt1stDate.text),"dd/MM/yy")
            if trim(lblAltLowDate.text) <> "" then lblAltLowDate.text = format(cdate(lblAltLowDate.text),"dd/MM/yy")
            if trim(lblAltHighDate.text) <> "" then lblAltHighDate.text = format(cdate(lblAltHighDate.text),"dd/MM/yy")
        Next
    End sub

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
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label3" runat="server" cssclass="SectionHeader" width="100%">MAIN PART
                                                    DETAILS</asp:Label> 
                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="LabelNormal">BOM Quotation No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblBOMQuoteNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Part #</asp:Label></td>
                                                                                    <td width="75%">
                                                                                        <div align="left"><asp:Label id="lblPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label46" runat="server" cssclass="LabelNormal">Customer P/N</asp:Label></td>
                                                                                    <td>
                                                                                        <div align="left"><asp:Label id="lblCustPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label14" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                                                                    <td>
                                                                                        <div align="left">
                                                                                            <div align="left"><asp:Label id="lblPartDesc" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                            </div>
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
                                                                                        <div align="left"><asp:Label id="lblMfgPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label39" runat="server" cssclass="LabelNormal">Manufacturer Name</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblMFGName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
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
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label4" runat="server" cssclass="SectionHeader" width="100%">ALTERNATE
                                                    PART DETAILS</asp:Label> 
                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataList id="MyList" runat="server" Width="100%" OnSelectedIndexChanged="MyList_SelectedIndexChanged" RepeatColumns="1" BorderWidth="0px" CellPadding="1" Height="101px">
                                                                            <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                            <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                            <ItemTemplate>
                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                                                    <tbody>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label61" runat="server" cssclass="LabelNormal">Part #</asp:Label></td>
                                                                                            <td width="75%">
                                                                                                <div align="left">
                                                                                                    <asp:Label id="lblAltPartNo" runat="server" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' width="100%"></asp:Label> 
                                                                                                </div>
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
                                                                                            <td>
                                                                                                <asp:Label id="lblAverageHiLow" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Average_Hi_Low") %>' cssclass="OutputText"></asp:Label></td>
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label id="Label84" runat="server" cssclass="OutputText"></asp:Label></td>
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
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblMainPart" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
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
