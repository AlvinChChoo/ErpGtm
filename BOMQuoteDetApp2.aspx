<%@ Page Language="VB" Debug="true" %>
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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            LoadDataHeader
            procLoadGridData ()
            lblTargetCost.text = ReqCOM.GetFieldVal("select sum(std_up*P_Usage) as [TargetCost] from bom_quote_d where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' AND MAIN = 'MAIN';","TargetCost")
            if lblTargetCost.text <> "<NULL>" then lblTargetCost.text = format(cdec(lblTargetCost.text),"##,##0.00000")
    
        end if
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
        loop
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
    
    Property SortField() As String
        Get
            Dim o As Object = ViewState("SortField")
            If o Is Nothing Then
                Return [String].Empty
            End If
            Return CStr(o)
        End Get
        Set(ByVal Value As String)
            If Value = SortField Then
                SortAscending = Not SortAscending
            End If
            ViewState("SortField") = Value
        End Set
    End Property
    
    Property SortAscending() As Boolean
        Get
            Dim o As Object = ViewState("SortAscending")
    
            If o Is Nothing Then
                Return True
            End If
            Return CBool(o)
        End Get
        Set(ByVal Value As Boolean)
            ViewState("SortAscending") = Value
        End Set
    End Property
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        procLoadGridData ()
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim Remove As Checkbox = CType(e.Item.FindControl("Remove"), Checkbox)
            Dim Main As Label = CType(e.Item.FindControl("Main"), Label)
            Dim PartDet as Textbox = CType(e.Item.FindControl("PartDet"), Textbox)
            Dim PartSpec as Label = CType(e.Item.FindControl("PartSpec"), Label)
            Dim MFGMPN as Label = CType(e.Item.FindControl("MFGMPN"), Label)
            Dim MFGName as Label = CType(e.Item.FindControl("MFGName"), Label)
            Dim SWAP as LinkButton = CType(e.Item.FindControl("SWAP"), LinkButton)
            Dim OriUPAmt as Label = CType(e.Item.FindControl("OriUPAmt"), Label)
            Dim UPAmt as Label = CType(e.Item.FindControl("UPAmt"), Label)
            Dim PartNo as Label = CType(e.Item.FindControl("PartNo"), Label)
            Dim PartDesc as Label = CType(e.Item.FindControl("PartDesc"), Label)
            Dim CustPartNo as Label = CType(e.Item.FindControl("CustPartNo"), Label)
    
            Dim StdDate as Label = CType(e.Item.FindControl("StdDate"), Label)
    
            if trim(StdDate.text) <> "" then StdDate.text = format(cdate(StdDate.text),"dd/MM/yy")
    
            PartDet.text = "Part No :" & trim(PartNo.text) & vblf & "Cust. Part #:" & trim(CustPartNo.text) & vblf & "Desc :" & trim(PartDesc.text) & vblf & "Spec : " & trim(PartSpec.text) & vblf & "MFG Name :" & trim(MFGName.text) & vblf & "MFG MPN :" & trim(MFGMPN.text)
            OriUPAmt.text = format(cdec(OriUPAmt.text),"##,##0.0000")
            UPAmt.text = format(cdec(UPAmt.text),"##,##0.0000")
            if trim(Main.text) = "MAIN" Then e.item.cssclass = "BOMQuoteMainPart"
            if trim(Main.text) = "ALT" Then OriUPAmt.text = "0":UPAmt.text = "0"
        End if
    End Sub
    
    
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from BOM_Quote_D where " & trim(cmbSearchField.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "' order by main_part,main desc"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"BOM_Quote_D")
        GridControl1.DataSource=resExePagedDataSet.Tables("BOM_Quote_D").DefaultView
        GridControl1.DataBind()
        GenerateItemNo
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("BOMQuoteApp2.aspx")
    End Sub
    
    Sub lnkImportBOM_Click(sender As Object, e As EventArgs)
        Response.redirect("BOMQuoteImportModel.aspx?ID=" & Request.params("ID"))
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
    
    Sub dtgCurr_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ShowDet(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if trim(ucase(e.commandArgument)) = "VIEW" then Response.redirect("BOMQuotePartDetApp2.aspx?ID=" & trim(SeqNo.text))
        if trim(ucase(e.commandArgument)) = "SWAP" then Response.redirect("BOMQuoteSwapPart.aspx?ID=" & trim(SeqNo.text))
    End sub
    
    Sub cmdViewRpt_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=" & trim(cmbReport.selecteditem.value) & "&BOMQuoteNo=" & trim(lblBOMQuoteNo.text))
    End Sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        procLoadGridData
    End Sub
    
    Sub cmdCurrRate_Click(sender As Object, e As EventArgs)
        ShowReport("PopUpBOMQuoteCurr.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub GenerateItemNo()
        Dim i,RowSeq As Integer
        Dim ItemNo,MainPart,Main As Label
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if GridControl1.items.count > 0 then
            MainPart = CType(GridControl1.Items(0).FindControl("MainPart"), Label)
            Main = CType(GridControl1.Items(0).FindControl("Main"), Label)
            if trim(Main.text) = "MAIN" then RowSeq = ReqCOm.GetFieldVal("Select count(Main_Part) as [NoOfRec] from BOM_Quote_D where main = 'MAIN' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' and Main_Part < '" & trim(MainPart.text) & "';","NoOfRec")
            if trim(Main.text) = "ALT" then RowSeq = ReqCOm.GetFieldVal("Select count(Main_Part) as [NoOfRec] from BOM_Quote_D where main = 'MAIN' and bom_quote_no = '" & trim(lblBOMQuoteNo.text) & "' and Main_Part <= '" & trim(MainPart.text) & "';","NoOfRec")
            RowSeq = RowSeq + 1
    
            For i = 0 To GridControl1.Items.Count - 1
                ItemNo = CType(GridControl1.Items(i).FindControl("ItemNo"), Label)
                Main = CType(GridControl1.Items(i).FindControl("Main"), Label)
                if trim(MAIN.text) = "MAIN" then ItemNo.text = RowSeq:RowSeq = RowSeq + 1
                if trim(MAIN.text) = "ALT" then ItemNo.text = ""
            Next
        end if
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table height="0px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">PART LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table height="0px" cellspacing="0" cellpadding="0" width="96%" align="center" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
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
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="100%">Model No
                                                                    / Description</asp:Label></td>
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
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="100%">Target Cost</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblTargetCost" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="100%">View Report</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbReport" runat="server" Width="494px" CssClass="OutputText">
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
                                                                    <asp:Button id="cmdViewRpt" onclick="cmdViewRpt_Click" runat="server" Width="62px" CssClass="OutputText" Text="GO"></asp:Button>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <div>
                                                </div>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 16px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label15" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp;<asp:TextBox id="txtSearch" runat="server" Width="176px" CssClass="OutputText"></asp:TextBox>
                                                                        &nbsp; <asp:Label id="Label16" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp; 
                                                                        <asp:DropDownList id="cmbSearchField" runat="server" Width="172px" CssClass="OutputText">
                                                                            <asp:ListItem Value="Part_No">PART NO</asp:ListItem>
                                                                            <asp:ListItem Value="Part_Desc">DESCRIPTION</asp:ListItem>
                                                                            <asp:ListItem Value="Part_Spec">SPECIFICATION</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" Width="58px" CssClass="OutputText" Text="GO" CausesValidation="False"></asp:Button>
                                                                        &nbsp; 
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemDataBound="FormatRow" OnSortCommand="SortGrid" OnPageIndexChanged="OurPager" AllowPaging="True" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="20" OnItemCommand="ShowDet">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText= "No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ItemNo" runat="server" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="">
                                                                <HeaderStyle horizontalalign="left"></HeaderStyle>
                                                                <ItemStyle horizontalalign="left"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:LinkButton id="View" CausesValidation="False" CommandArgument='View' runat="server" Font-Size="X-Small" >View</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CustPartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Cust_Part_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Part Det.">
                                                                <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                                <ItemStyle horizontalalign="left"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:textbox id="PartDet" CssClass="ListOutput" runat="server" width= "220px" height= "100px" ReadOnly="True" TextMode="MultiLine" ></asp:textbox>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartSpec" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MFGName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG_Name") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MFGMPN" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG_MPN") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="P_Usage" HeaderText="Usage"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="std_Ven_Name" HeaderText="Supplier"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="std_curr_code" HeaderText="Ori. Curr"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="std_ori_up" HeaderText="Ori. unit Cost"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Amount">
                                                                <ItemTemplate>
                                                                    <asp:Label id="OriUPAmt" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") * DataBinder.Eval(Container.DataItem, "std_ori_up")%>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Std_UP" HeaderText="Unit Cost(RM)"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Amount(RM)">
                                                                <ItemTemplate>
                                                                    <asp:Label id="UPAmt" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") * DataBinder.Eval(Container.DataItem, "std_up")%>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="StdDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="std_LT" HeaderText="Lead Time"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="STD_SPQ" HeaderText="SPQ"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="std_MOQ" HeaderText="MOQ"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Rem" HeaderText="Remarks"></asp:BoundColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Main" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Main") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MainPart" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Main_Part") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="33%">
                                                                    <asp:Button id="cmdCurrRate" onclick="cmdCurrRate_Click" runat="server" Width="144px" Text="Conversion Rate"></asp:Button>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="123px" Text="Back"></asp:Button>
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
