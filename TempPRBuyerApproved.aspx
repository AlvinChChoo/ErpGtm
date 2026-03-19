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
        if page.isPostBack = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            if request.cookies("U_ID") is nothing then response.redirect("SignIn.aspx")
            If SortField = "" then SortField = "PR.Part_No"
            lblPRNo.text = ReqCOM.GetFieldVal("Select PR_NO from pr_M where Seq_No = " & request.params("ID") & ";","PR_NO")
            LoadDataWithSource()
            LoadDataWithoutSource()
            LoadPartsSubmitted()
        end if
    End Sub
    
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
    
    Sub LoadPartsSubmitted()
        Dim SortSeq as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim StrSql as string = "SELECT PM.BUYER_CODE,PM.Part_Desc,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.BUYER_APPROVAL,BUYER_PROCESS,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Code],Ven_Name as [Ven_Name] FROM pr_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr.Buyer_Approval = 'Y' and PR.PR_APP_SUBMITTED = 'YES' order by " & SortField & " " & SortSeq
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        dtgPartsSubmitted.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
        dtgPartsSubmitted.DataBind()
    end sub
    
    
    Sub LoadDataWithSource()
        Dim SortSeq as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim StrSql as string = "SELECT PM.Part_Desc,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.BUYER_APPROVAL,BUYER_PROCESS,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Code],Ven_Name as [Ven_Name] FROM pr_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr.Buyer_Approval = 'Y' and PR.PR_APP_SUBMITTED = 'N' and pr.part_no in (select Part_No from part_Source) order by " & SortField & " " & SortSeq
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Sub LoadDataWithoutSource()
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "SELECT PM.Part_Spec + '|' + PM.Part_Desc as [Desc],PM.Buyer_Code, PM.Buyer_Code,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no FROM pr_d PR,Part_Master PM WHERE pr.pr_qty > 0 and PR.PR_NO = " & lblPRNo.text & " and pr.part_no = pm.part_no and pr.Buyer_Approval = 'N' order by pr.part_no asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        Dim DV as New DataView(resExePagedDataSet.Tables("pr1"))
        Dim SortSeq as String
        dtgPartWithoutSource.DataSource=DV
        dtgPartWithoutSource.DataBind()
    end sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("PartAddNew.aspx")
    End Sub
    
    Protected Sub FormatApproval(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
         If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
    
            E.Item.Cells(3).Text = format(cdate(E.Item.Cells(3).Text),"MM/dd/yy")
            E.Item.Cells(4).Text = format(cdate(E.Item.Cells(4).Text),"MM/dd/yy")
            E.Item.Cells(5).Text = cint(E.Item.Cells(5).Text)
            E.Item.Cells(7).Text = cint(E.Item.Cells(7).Text)
            E.Item.Cells(8).Text = format(cdec(E.Item.Cells(8).Text),"##,##0.0000")
            E.Item.Cells(10).Text = format(E.Item.Cells(8).Text * E.Item.Cells(7).Text,"##,##0.00")
    
            Dim QtyToBuy as Label = CType(e.Item.FindControl("QtyToBuy"), Label)
            E.Item.Cells(9).Text = format(E.Item.Cells(8).Text * QtyToBuy.Text,"##,##0.00")
        End if
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim TotalAmt as decimal = lblTotalAmt.text
            Dim TotalVar as decimal = lblTotalVar.text
    
            E.Item.Cells(3).Text = format(cdate(E.Item.Cells(3).Text),"MM/dd/yy")
            E.Item.Cells(4).Text = format(cdate(E.Item.Cells(4).Text),"MM/dd/yy")
            E.Item.Cells(5).Text = cint(E.Item.Cells(5).Text)
            E.Item.Cells(7).Text = cint(E.Item.Cells(7).Text)
            E.Item.Cells(8).Text = format(cdec(E.Item.Cells(8).Text),"##,##0.0000")
            E.Item.Cells(10).Text = format(E.Item.Cells(8).Text * E.Item.Cells(7).Text,"##,##0.00")
    
            Dim QtyToBuy as Label = CType(e.Item.FindControl("QtyToBuy"), Label)
            E.Item.Cells(9).Text = format(E.Item.Cells(8).Text * QtyToBuy.Text,"##,##0.00")
    
            TotalAmt = TotalAmt + E.Item.Cells(9).Text
            TotalVar = TotalVar + E.Item.Cells(10).Text
    
            lblTotalAmt.text = format(TotalAmt,"##,##0.00")
            lblTotalVar.text = format(TotalVar ,"##,##0.00")
    
            if E.Item.Cells(10).Text > 0 then e.Item.CssClass = "PartSource"
            'if cint(e.item.cells(9).text) = 0 then e.Item.CssClass = "PartSource"
        End if
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithoutSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdApproval_Click(sender As Object, e As EventArgs)
        response.redirect("PRApproval.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        LoadDataWithSource()
    End Sub
    
    Sub cmdUpdateSource_Click(sender As Object, e As EventArgs)
    
        'Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
    
    
        'Dim StrSql as string = "SELECT PM.Part_Spec + '|' + PM.Part_Desc as [Desc],PM.Buyer_Code, PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no FROM pr_d PR,Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.part_no = pm.part_no and pr.pr_date is null and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "' order by pr.part_no asc"
        'Dim StrSql as string = "SELECT PR.part_no FROM pr_d PR,Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.part_no = pm.part_no and pr.pr_date is null and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "' order by pr.part_no asc"
    
        'Dim StrSql as string = "SELECT PR.part_no FROM pr_d PR,Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.part_no = pm.part_no and pr.pr_date is null and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "' order by pr.part_no asc"
    
        'Dim rsSource as SQLDataReader = ReqCOM.exeDataReader(StrSql)
    
        'do while rsSource.read
        '    response.write(rsSource("Part_No"))
        'Loop
    
    
    
        'Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        'Dim DV as New DataView(resExePagedDataSet.Tables("pr1"))
        'Dim SortSeq as String
        'dtgPartWithoutSource.DataSource=DV
        'dtgPartWithoutSource.DataBind()
    
    
    
    
        '    Dim TotalOrderQty as integer
        '    Dim PRProcessingDay as integer = ReqCOM.GetFieldVal("Select PR_PROCESSING_DAYS from main","PR_PROCESSING_DAYS")
        '    Dim i as integer
        '    Dim PRNo as integer = ReqCOM.GetFieldVal("Select PR_No from PR_D where seq_no = " & request.params("ID") & ";","PR_No")
        '    Dim MRPNo as integer = ReqCOM.GetFieldVal("Select MRP_NO from PR_M where PR_No = " & PRNo & ";","MRP_NO")
        '    Dim Strsql, SchDays as string
        '    Dim ReqDate, PRDate, BOMDate as date
        '    Dim RsPR as SqlDataReader = ReqCOM.ExeDataReader("Select * from PR_D where PR_NO = " & PRNo & ";")
    
        '    Do while rsPR.read
        '        BOMDate = rsPR("BOM_Date").toString
        '        SchDays = rsPR("SCH_Days").toString
        '    loop
    
        '    For i = 0 to dtgPartSource.Items.Count - 1
        '        Dim Quantity as Textbox = CType(dtgPartSource.Items(i).findControl("Quantity"), Textbox)
        '        Dim StdPack as Label = CType(dtgPartSource.Items(i).findControl("StdPack"), Label)
        '        Dim MOQ as Label = CType(dtgPartSource.Items(i).findControl("MOQ"), Label)
        '        Dim Supplier as Label = CType(dtgPartSource.Items(i).findControl("Supplier"), Label)
        '        Dim LeadTime as Label = CType(dtgPartSource.Items(i).findControl("LeadTime"), Label)
        '        Dim UP as Label = CType(dtgPartSource.Items(i).findControl("UP"), Label)
        '        Dim OrderQty as Label = CType(dtgPartSource.Items(i).findControl("OrderQty"), Label)
        '        if cint(Quantity.text) <> 0 then
    
         '           PRDate = DateAdd(DateInterval.Day, -cint(LeadTime.text) * 7, DateValue(cdate(lblETA.text)))
         '           StrSql = "Insert into PR_D(MRP_NO,PR_NO,PART_NO,Req_Date,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,PR_DATE,BOM_DATE,SCH_DAYS,UP,VEN_CODE,LEAD_TIME,VARIANCE) "
         '           StrSql = StrSql + "Select " & cint(MRPNo) & "," & PRNo & ",'" & trim(lblPartNo.text) & "','" & trim(lblETA.text) & "'," & cint(OrderQty.text) & "," & PRProcessingDay & "," & cint(Quantity.text) & ",'" & PRDate & "','" & BOMDate & "'," & SchDays & "," & UP.text & ",'" & trim(Supplier.text) & "'," & cint(LeadTime.text) * 7 & "," & cint(OrderQty.text) & " - " & cint(Quantity.text) & ";"
         '           ReqCOM.ExecuteNonQuery(StrSql)
         '       end if
         '   next
         '   reqCOM.ExecuteNonQuery("Delete from PR_D where seq_no = " & cint(request.params("ID")) & ";")
         '   Response.redirect("PRDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from PR_M where PR_NO = " & cint(PRNo) & ";","Seq_No"))
    
    End Sub
    
    Sub dtgPartsSubmitted_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cndBack_Click(sender As Object, e As EventArgs)
        response.redirect("TempPRHOD.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table height="100%" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">PURCHASE REQUISITION
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 18px" width="80%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="77px">PR No.</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPRNo" runat="server" cssclass="OutputText" width="373px"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 5px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="Label1" runat="server" cssclass="PartWithoutSourceLabel" width="100%">ATTENTION
                                                                        : Part(s) not approved by buyer.</asp:Label>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="dtgPartWithoutSource" runat="server" width="100%" OnSelectedIndexChanged="dtgPartWithoutSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Desc" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Buyer_Code" HeaderText="BUYER"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="REQ_DATE" HeaderText="REQ DATE" DataFormatString="{0:d}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PR_QTY" HeaderText="PR QTY" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p>
                                                                        <asp:Button id="cmdUpdateSource" onclick="cmdUpdateSource_Click" runat="server" Text="Update Source" Width="155px"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="Label4" runat="server" cssclass="PartWithSourceLabel" width="100%">Part(s)
                                                                        submitted for approval.</asp:Label>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="dtgPartsSubmitted" runat="server" width="100%" OnSelectedIndexChanged="dtgPartsSubmitted_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatApproval">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="PART_NO" SortExpression="PR.Part_No" HeaderText="PART NO"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PART_Desc" SortExpression="PR.Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="REQ_DATE" HeaderText="REQ DATE" DataFormatString="{0:d}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PR_DATE" HeaderText="PR DATE" DataFormatString="{0:d}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PR_QTY" HeaderText="PR QTY" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="QTY TO BUY(a)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="QtyToBuy" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="VARIANCE" HeaderText="VAR(Qty)(b)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="UP" HeaderText="U/P(c)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn HeaderText="Amt(a*c)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn HeaderText="Var(Amt)(b*c)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="Buyer App.">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="BuyerApproval" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Buyer_Code") %>' /> 
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
                                                    <table style="HEIGHT: 20px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="Label3" runat="server" cssclass="PartWithSourceLabel" width="100%">Part(s)
                                                                        approved by buyer.</asp:Label>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatRow" OnSortCommand="SortGrid" AllowSorting="True">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="PART_NO" SortExpression="PR.Part_No" HeaderText="PART NO"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PART_Desc" SortExpression="PR.Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="REQ_DATE" HeaderText="REQ DATE" DataFormatString="{0:d}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PR_DATE" HeaderText="PR DATE" DataFormatString="{0:d}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PR_QTY" HeaderText="PR QTY" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="QTY TO BUY(a)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="QtyToBuy" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="VARIANCE" HeaderText="VAR(Qty)(b)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="UP" HeaderText="U/P(c)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn HeaderText="Amt(a*c)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn HeaderText="Var(Amt)(b*c)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p align="left">
                                                                        <asp:Label id="Label7" runat="server" cssclass="Legend" width="100%">Highlighted items
                                                                        indicates parts with variances.</asp:Label>
                                                                    </p>
                                                                    <p align="right">
                                                                        <asp:Label id="Label6" runat="server" cssclass="Instruction" width="253px">Total Amt</asp:Label><asp:Label id="lblTotalAmt" runat="server" cssclass="Instruction" width="183px">0</asp:Label>
                                                                    </p>
                                                                    <p align="right">
                                                                        <asp:Label id="Label9" runat="server" cssclass="Instruction" width="256px">Total Var
                                                                        (Amount)</asp:Label><asp:Label id="lblTotalVar" runat="server" cssclass="Instruction" width="183px">0</asp:Label>
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
                                                                    <p align="left">
                                                                        <asp:Button id="cmdApproval" onclick="cmdApproval_Click" runat="server" Text="Submit For Approval" Width="160px" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cndBack" onclick="cndBack_Click" runat="server" Text="Back" Width="137px"></asp:Button>
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
