<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
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
            LoadDataHeader
            lblTargetCost.text = ReqCOM.GetFieldVal("select sum(std_up*P_Usage) as [TargetCost] from bom_quote_d where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' and main = 'MAIN'","TargetCost")
            if lblTargetCost.text <> "<NULL>" then lblTargetCost.text = format(cdec(lblTargetCost.text),"##,##0.00000")
            ProcLoadBOMQuote
            intPageSize.Text = "20"
            intCurrIndex.Text = "0"
            DataBind
        end if
    End Sub
    
    
    Sub ProcLoadBOMQuote()
        Dim StrSql as string = "Select * from BOM_Quote_D where " & trim(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' order by main_part,main desc"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"BOM_Quote_D")
        dtlBOMQuote.DataSource=resExePagedDataSet.Tables("BOM_Quote_D").DefaultView
        dtlBOMQuote.DataBind()
    end sub
    
    Private Sub DataBind()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim ProdCat as string
        Dim objConn As New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim objDA As New SqlDataAdapter("Select * from BOM_Quote_D where " & trim(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' order by main_part,main desc", objConn)
        Dim objDS As New DataSet()
    
        objDA.Fill(objDS)
        intRecordCount.Text = CStr(objDS.Tables(0).Rows.Count)
        objDS = Nothing
        objDS = New DataSet()
    
        objDA.Fill (objDS, Cint(intCurrIndex.Text), CInt(intPageSize.Text), "GiftProdList")
        dtlBOMQuote.DataSource = objDS.Tables(0).DefaultView
        dtlBOMQuote.DataBind()
        objConn.Close()
        PrintStatus()
        FormatBOMQuoteItem
    End Sub
    
    Private Sub PrintStatus()
        'lblStatus.Text = "Total Records:<b>" & intRecordCount.Text
        'lblStatus.Text += "</b> - Showing Page:<b> "
        'lblStatus.Text += CStr(CInt(CInt(intCurrIndex.Text) / CInt(intPageSize.Text)+1))
        'lblStatus.Text += "</b> of <b>"
        'lblStatus.Text = lblStatus.Text & Math.Ceiling(cint(intRecordCount.Text) / cint(intPageSize.Text))
        'lblStatus.Text += "</b>"
    
        lblStatus.Text = "Page "
        lblStatus.Text += CStr(CInt(CInt(intCurrIndex.Text) / CInt(intPageSize.Text)+1))
        lblStatus.Text += " of "
        lblStatus.Text = lblStatus.Text & Math.Ceiling(cint(intRecordCount.Text) / cint(intPageSize.Text))
    End Sub
    
    Sub LoadDataHeader
        Dim strSql as string
        strsql ="select * from BOM_Quote_M where Seq_no = '" & trim(request.params("ID")) & "';"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while result.read
            lblBOMQuoteNo.text = result("BOM_Quote_No").tostring
            lblCustCode.text = result("Cust_Code").tostring
            lblCustName.text = result("Cust_Name").tostring
            lblModelNo.text = result("Model_No").tostring
            lblModelDesc.text = result("Model_Desc").tostring
            lblTargetCost.text = result("Target_Cost").tostring
            lblModelFrom.text = result("Import_Model_No").tostring
            lblBOMQuoteRev.text = result("BOM_Quote_Rev").tostring
            lblSubmitBy.text = result("Submit_By").tostring
        loop
    
        if trim(lblSubmitBy.text) = "" then cmdSubmit.enabled = true:cmdRemove.enabled = true
        if trim(lblSubmitBy.text) <> "" then cmdSubmit.enabled = false:cmdRemove.enabled = false
    
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("BOMQuote.aspx")
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        'Dim i as integer
        'Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        'Dim Remove As CheckBox
        'Dim MainPart As Label
    
        'For i = 0 To GridControl1.Items.Count - 1
        '    Remove = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
        '    MainPart = CType(GridControl1.Items(i).FindControl("MainPart"), Label)
        '    if Remove.checked = true then ReqCOM.ExecutenonQuery("Delete from BOM_Quote_D where main_Part = '" & trim(MainPart.text) & "' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "';")
        'next i
    
        'ShowAlert("Selected parts have been removed from this quotation.")
        'redirectPage("BOMQuoteDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdViewRpt_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=" & trim(cmbReport.selecteditem.value) & "&BOMQuoteNo=" & trim(lblBOMQuoteNo.text))
    End Sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        DataBind
    End Sub
    
    Sub cmdCurrRate_Click(sender As Object, e As EventArgs)
        ShowReport("PopUpBOMQuoteCurr.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub FormatBOMQuoteItem()
        Dim StdDate,OriUPAmt,MainPart,Main,ItemNo As Label
        Dim i,RowSeq as integer
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        RowSeq = 1
    
        For i = 0 To dtlBOMQuote.Items.Count - 1
            MainPart = CType(dtlBOMQuote.Items(i).FindControl("MainPart"), Label)
            Main = CType(dtlBOMQuote.Items(i).FindControl("Main"), Label)
            ItemNo = CType(dtlBOMQuote.Items(i).FindControl("ItemNo"), Label)
    
            if trim(Main.text) = "MAIN" then
                ItemNo.text = RowSeq
                RowSeq = RowSeq + 1
            elseif trim(Main.text) <> "MAIN" then
                ItemNo.text = ""
            End if
    
            StdDate = CType(dtlBOMQuote.Items(i).FindControl("StdDate"), Label)
            OriUPAmt = CType(dtlBOMQuote.Items(i).FindControl("OriUPAmt"), Label)
            if trim(StdDate.text) <> "" then StdDate.text = format(cdate(StdDate.text),"dd/MM/yy")
            if trim(OriUPAmt.text) <> "" then OriUPAmt.text = format(cdec(OriUPAmt.text),"##,##0.00000")
        Next i
    End sub
    
    Sub cmdAddNewPart_Click(sender As Object, e As EventArgs)
        Response.redirect("BOMQuotePartAddNew.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        'procLoadGridData
    End Sub
    
    Sub MoveFirst_Click(sender As Object, e As EventArgs)
        intCurrIndex.Text = "0"
        DataBind()
    End Sub
    
    Sub ShowPrevious_Click(sender As Object, e As EventArgs)
        intCurrIndex.Text = Cstr(Cint(intCurrIndex.Text) - CInt(intPageSize.Text))
        If CInt(intCurrIndex.Text) < 0 Then intCurrIndex.Text = "0"
        DataBind()
    End Sub
    
    Sub MoveLast_Click(sender As Object, e As EventArgs)
        Dim tmpInt as Integer
        tmpInt = CInt(intRecordCount.Text) Mod CInt(intPageSize.Text)
    
        If tmpInt > 0 Then
            intCurrIndex.Text = Cstr(CInt(intRecordCount.Text) - tmpInt)
        Else
            intCurrIndex.Text = Cstr(CInt(intRecordCount.Text) - CInt(intPageSize.Text))
        End If
        DataBind()
    End Sub
    
    Sub ShowNext_Click(sender As Object, e As EventArgs)
        If CInt(intCurrIndex.Text) + 1 < CInt(intRecordCount.Text) Then
        intCurrIndex.Text = CStr(CInt(intCurrIndex.Text) + CInt(intPageSize.Text))
        End If
        DataBind()
    End Sub
    
    Sub Button1_Click_1(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p align="center">
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="767">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <erp:HEADER id="UserControl1" runat="server"></erp:HEADER>
                            </div>
                            <div align="center">
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    BOM Quote Header</td>
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
                                                                                <td width="23%" bgcolor="silver">
                                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="100%">Quotation
                                                                                    #</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblBOMQuoteNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="100%">Revision</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblBOMQuoteRev" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="100%">Model Details</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label><asp:Label id="lblModelFrom" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="100%">Customer</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCustName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="100%">Target Cost
                                                                                    (RM)</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblTargetCost" runat="server" cssclass="OutputText"></asp:Label><asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal" width="100%">View Report</asp:Label></td>
                                                                                <td>
                                                                                    <asp:DropDownList id="cmbReport" runat="server" Width="455px" CssClass="OutputText">
                                                                                        <asp:ListItem Value="BOMQUOTETARGETCOSTSORTBYPARTNO">Report By G-Tek P/N with Target Cost (Sort by G-Tek P/N)</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTETARGETCOSTSORTBYDESCRIPTION">Report By Description with Target Cost (Sort by Description)</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTETARGETCOSTSORTBYORIGINALCURRENCY">Report By Original Currency with Target Cost (Sort by Original Currency)</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTETARGETCOSTSORTBYVENDOR">Report By Vendor with Target Cost (Sort by Vendor)</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTETARGETVSLOWESTCOSTSORTBYPARTNO">Target VS Actual Lowest Variance List</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTETARGETVSHIGHESTCOSTSORTBYPARTNO">Target VS Actual Highest Variance List</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTETARGETVSSOURCINGAVGCOSTSORTBYPARTNO">Target VS Sourcing Average Variance List</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTETARGETVS1STVDRCOSTSORTBYPARTNO">Target VS 1st Vendor Variance List</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTESOURCINGAVGCOSTSORTBYPARTNO">Report By G-Tek P/N with Sourcing Average Cost (Sort by G-Tek P/N)</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTE1STVENDORCOSTSORTBYPARTNO">Report By G-Tek P/N with 1st Vendor Cost (Sort by G-Tek P/N)</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTEHIGHESTCOSTSORTBYPARTNO">Report By G-Tek P/N with Actual Highest Cost (Sort by G-Tek P/N)</asp:ListItem>
                                                                                        <asp:ListItem Value="BOMQUOTELOWESTCOSTSORTBYPARTNO">Report By G-Tek P/N with Actual Lowest Cost (Sort by G-Tek P/N)</asp:ListItem>
                                                                                    </asp:DropDownList>
                                                                                    &nbsp;<asp:Button id="cmdViewRpt" onclick="cmdViewRpt_Click" runat="server" Width="43px" CssClass="Submit_Button" Text="GO"></asp:Button>
                                                                                </td>
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
                                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr height="28">
                                                                                <td class="SideTableHeading" background="Frame-Top-center.jpg">
                                                                                    BOM Quote Part List</td>
                                                                                <td background="Frame-Top-center.jpg">
                                                                                    <div align="right">
                                                                                    </div>
                                                                                </td>
                                                                                <td background="Frame-Top-center.jpg">
                                                                                    <div align="right">
                                                                                        <asp:Button id="MoveFirst" onclick="MoveFirst_Click" runat="server" CssClass="Submit_Button" Text="<<" ToolTip="First Page"></asp:Button>
                                                                                        <asp:Button id="ShowPrevious" onclick="ShowPrevious_Click" runat="server" CssClass="Submit_Button" Text="<" ToolTip="Previous Page"></asp:Button>
                                                                                        <asp:Label id="intRecordCount" runat="server" cssclass="SideTableHeading" width="61px" visible="False" forecolor="Black"></asp:Label><asp:Label id="intPageSize" runat="server" visible="False"></asp:Label><asp:Label id="lblStatus" runat="server" cssclass="SideTableHeading" forecolor="White" font-bold="True" backcolor="Transparent"></asp:Label><asp:Label id="intCurrIndex" runat="server" width="65px" visible="False"></asp:Label>
                                                                                        <asp:Button id="ShowNext" onclick="ShowNext_Click" runat="server" CssClass="Submit_Button" Text=">" ToolTip="Next Page"></asp:Button>
                                                                                        <asp:Button id="MoveLast" onclick="MoveLast_Click" runat="server" CssClass="Submit_Button" Text=">>" ToolTip="Last Page"></asp:Button>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <br />
                                                                        <table style="HEIGHT: 16px" width="98%" align="center" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label15" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp;<asp:TextBox id="txtSearch" runat="server" Width="149px" CssClass="Input_Box"></asp:TextBox>
                                                                                            &nbsp; <asp:Label id="Label16" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp; 
                                                                                            <asp:DropDownList id="cmbSearchField" runat="server" Width="172px" CssClass="Input_Box">
                                                                                                <asp:ListItem Value="Part_No">G-TEK PART NO</asp:ListItem>
                                                                                                <asp:ListItem Value="Part_Desc">DESCRIPTION</asp:ListItem>
                                                                                                <asp:ListItem Value="Part_Spec">SPECIFICATION</asp:ListItem>
                                                                                                <asp:ListItem Value="MFG_NAME">MFG NAME</asp:ListItem>
                                                                                                <asp:ListItem Value="MFG_MPN">MFG MPN</asp:ListItem>
                                                                                                <asp:ListItem Value="CUST_PART_NO">CUSTOMER PART NO</asp:ListItem>
                                                                                                <asp:ListItem Value="STD_VEN_NAME">VENDOR NAME</asp:ListItem>
                                                                                                <asp:ListItem Value="STD_LT">LEAD TIME</asp:ListItem>
                                                                                            </asp:DropDownList>
                                                                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                            <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" Width="58px" CssClass="Submit_Button" Text="GO" CausesValidation="False"></asp:Button>
                                                                                            &nbsp; 
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p align="center">
                                                                        <asp:DataList id="dtlBOMQuote" runat="server" Width="98%" Height="101px" CellPadding="1" BorderWidth="0px" RepeatColumns="1" Font-Size="XX-Small" Font-Names="Arial">
                                                                            <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                            <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                            <ItemTemplate>
                                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" >
                                                                                    <tr>
                                                                                        <td width= "20" valign= "top">
                                                                                            <asp:Label id="ItemNo" cssclass="ERrorText" runat="server" /> <asp:Label id="MainPart" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Main_Part") %>' /> <asp:Label id="Main" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Main") %>' /> 
                                                                                        </td>
                                                                                        <td>
                                                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                <tbody>
                                                                                                    <tr>
                                                                                                        <td bgcolor="silver" width= "80">
                                                                                                            <asp:Hyperlink ID="HyperlinkView" ToolTip="View Details" imageURL="view.gif" Runat="Server" NavigateUrl= <%#"javascript:PRPartDet=window.open('BOMQuotePartDet.aspx?id=" + DataBinder.Eval(Container.DataItem,"Seq_No").ToString() + "','PRPartDet','resizable=1,scrollbars=1,height=250,width = 757');PRPartDet.focus()" %>></asp:Hyperlink>
                                                                                                            Part No 
                                                                                                        </td>
                                                                                                        <td width= "100">
                                                                                                            <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                                                        </td>
                                                                                                        <td bgcolor="silver" width= "80">
                                                                                                            Cust. Part No 
                                                                                                        </td>
                                                                                                        <td width= "80">
                                                                                                            <asp:Label id="CustPartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Cust_Part_No") %>' /> 
                                                                                                        </td>
                                                                                                        <td bgcolor="silver" width= "40">
                                                                                                            Mfg. 
                                                                                                        </td>
                                                                                                        <td width= "80">
                                                                                                            <asp:Label id="MFGName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG_Name") %>' /> 
                                                                                                        </td>
                                                                                                        <td bgcolor="silver" width= "40">
                                                                                                            MPN 
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <asp:Label id="MFGMPN" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG_MPN") %>' /> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </tbody>
                                                                                            </table>
                                                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                <tr>
                                                                                                    <td bgcolor="silver" width= "80">
                                                                                                        Spec / Desc 
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <asp:Label id="PartDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> - <asp:Label id="PartSpec" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>' /> 
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                <tr>
                                                                                                    <td bgcolor="silver" width= "80">
                                                                                                        Supplier</td>
                                                                                                    <td>
                                                                                                        <asp:Label id="StdVenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Ven_Name") %>' /> 
                                                                                                    </td>
                                                                                                    <td bgcolor="silver" width= "70">
                                                                                                        Lead Time</td>
                                                                                                    <td width= "40">
                                                                                                        <asp:Label id="StdLT" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "STD_LT") %>' /> 
                                                                                                    </td>
                                                                                                    <td bgcolor="silver" width= "40">
                                                                                                        SPQ</td>
                                                                                                    <td width= "40">
                                                                                                        <asp:Label id="StdSPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "STD_SPQ") %>' /> 
                                                                                                    </td>
                                                                                                    <td bgcolor="silver" width= "40">
                                                                                                        MOQ</td>
                                                                                                    <td width= "40">
                                                                                                        <asp:Label id="StdMOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "STD_MOQ") %>' /> 
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                <tr>
                                                                                                    <td bgcolor= "silver" width= "40">
                                                                                                        Date</td>
                                                                                                    <td width= "60">
                                                                                                        <asp:Label id="StdDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Date") %>' /> 
                                                                                                    </td>
                                                                                                    <td bgcolor= "silver" width= "60">
                                                                                                        Ori Curr</td>
                                                                                                    <td width= "40">
                                                                                                        <asp:Label id="Std_Curr_Code" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "std_Curr_Code") %>' /> 
                                                                                                    </td>
                                                                                                    <td bgcolor= "silver" width= "40">
                                                                                                        U/P</td>
                                                                                                    <td width= "80">
                                                                                                        <asp:Label id="StdOriUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Ori_UP") %>' /></td>
                                                                                                    <td bgcolor= "silver" width= "60">
                                                                                                        Usage</td>
                                                                                                    <td width= "80">
                                                                                                        <asp:Label id="PUsage" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") %>' /></td>
                                                                                                    <td bgcolor= "silver" width= "40">
                                                                                                        Amt</td>
                                                                                                    <td width= "60">
                                                                                                        <asp:Label id="OriUPAmt" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") * DataBinder.Eval(Container.DataItem, "std_ori_up")%>' /> 
                                                                                                    </td>
                                                                                                    <td bgcolor= "silver" width= "80">
                                                                                                        Amt (RM)</td>
                                                                                                    <td></td>
                                                                                                </tr>
                                                                                            </table>
                                                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                                <tr>
                                                                                                    <td width= "80" bgcolor= "silver">
                                                                                                        Remarks</td>
                                                                                                    <td>
                                                                                                        <asp:Label id="Rem" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>' /></td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
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
                                                    <br />
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="98%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdAddNewPart" onclick="cmdAddNewPart_Click" runat="server" Width="115px" CssClass="Submit_Button" Text="Add New Part"></asp:Button>
                                                                        <asp:Button id="Button1" onclick="Button1_Click_1" runat="server" Width="115px" CssClass="Submit_Button" Text="Refresh"></asp:Button>
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="115px" CssClass="submit_button" Text="Submit"></asp:Button>
                                                                        <asp:Button id="cmdCurrRate" onclick="cmdCurrRate_Click" runat="server" Width="115px" CssClass="submit_button" Text="Conversion Rate"></asp:Button>
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="148px" CssClass="submit_button" Text="Remove selected part"></asp:Button>
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="115px" CssClass="submit_button" Text="Back"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </p>
                                <p>
                                </p>
                                <p>
                                </p>
                                <p>
                                    <Footer:Footer id="Footer" runat="server"></Footer:Footer>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
