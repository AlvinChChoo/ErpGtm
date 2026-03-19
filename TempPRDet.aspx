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
    
            if ReqCOM.FuncCheckDuplicate("Select Buyer_Code from Buyer where U_ID='" & trim(request.cookies("U_ID").value) & "';","Buyer_Code") = true then
                If SortField = "" then SortField = "PR.Part_No"
                lblPRNo.text = ReqCOM.GetFieldVal("Select PR_NO from pr_M where Seq_No = " & request.params("ID") & ";","PR_NO")
                lblBuyerCode.text = ReqCOM.GetFieldVal("Select Buyer_Code from Buyer where U_ID='" & trim(request.cookies("U_ID").value) & "';","Buyer_Code")
                lblBuyerName.text = Request.cookies("U_ID").value
                LoadBuyerApprovedParts()
                LoadDataWithSource()
                LoadDataWithoutSource()
            Else
                response.redirect("UnauthorisedUser.aspx")
            End if
        end if
    End Sub
    
    Sub LoadBuyerApprovedParts()
        Dim SortSeq as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim StrSql as string = "SELECT PM.Part_Desc,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.BUYER_APPROVAL,BUYER_PROCESS,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Code],Ven_Name as [Ven_Name] FROM pr_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr.pr_date is not null and PR.Buyer_Approval = 'Y' and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "' order by " & SortField & " " & SortSeq
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        dtgBuyerApprovedParts.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
        dtgBuyerApprovedParts.DataBind()
        'Response.write(StrSql)
    end sub
    
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
    
    Sub LoadDataWithSource()
        Dim SortSeq as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim StrSql as string = "SELECT PR.Ven_Code,PM.Part_Desc,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.BUYER_APPROVAL,BUYER_PROCESS,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Code],Ven_Name as [Ven_Name] FROM pr_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr.pr_date is not null and PR.PR_QTY > 0 and pr.Buyer_approval = 'N' and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "' order by " & SortField & " " & SortSeq
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Sub LoadDataWithoutSource()
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "SELECT PM.Part_Spec + '|' + PM.Part_Desc as [Desc],PM.Buyer_Code, PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no FROM pr_d PR,Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.part_no = pm.part_no and pr.pr_date is null and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "' order by pr.part_no asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        Dim DV as New DataView(resExePagedDataSet.Tables("pr1"))
        Dim SortSeq as String
        dtgPartWithoutSource.DataSource=DV
        dtgPartWithoutSource.DataBind()
        'Response.write(StrSql)
    end sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("PartAddNew.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
    
            E.Item.Cells(3).Text = format(cdate(E.Item.Cells(3).Text),"MM/dd/yy")
            E.Item.Cells(4).Text = format(cdate(E.Item.Cells(4).Text),"MM/dd/yy")
            E.Item.Cells(8).Text = cint(E.Item.Cells(8).Text)
            E.Item.Cells(9).Text = format(cdec(E.Item.Cells(9).Text),"##,##0.000")
            E.Item.Cells(12).Text = format(E.Item.Cells(9).Text * E.Item.Cells(8).Text,"##,##0.00")
    
            Dim PRQty as Label = CType(e.Item.FindControl("PRQty"), Label)
            Dim BuyerApproval as Label = CType(e.Item.FindControl("BuyerApproval"), Label)
            Dim QtyToBuy as TextBox = CType(e.Item.FindControl("QtyToBuy"), TextBox)
            E.Item.Cells(11).Text = format(E.Item.Cells(9).Text * QtyToBuy.Text,"##,##0.00")
    
        End if
    End Sub
    
    Protected Sub FormatNoSourceRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ReqDate as Label = CType(e.Item.FindControl("ReqDate"), Label)
            ReqDate.text = format(cdate(ReqDate.text),"MM/dd/yyyy")
        End if
    End Sub
    
    Protected Sub FormatBuyer(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(5).Text = cint(E.Item.Cells(5).Text)
            E.Item.Cells(7).Text = cint(E.Item.Cells(7).Text)
            E.Item.Cells(8).Text = format(cdec(E.Item.Cells(8).Text),"##,##0.0000")
            E.Item.Cells(10).Text = format(E.Item.Cells(8).Text * E.Item.Cells(7).Text,"##,##0.00")
            Dim BuyerApproval as Label = CType(e.Item.FindControl("BuyerApproval"), Label)
    
            Dim QtyToBuy as label = CType(e.Item.FindControl("QtyToBuy"), label)
            E.Item.Cells(9).Text = format(E.Item.Cells(8).Text * QtyToBuy.Text,"##,##0.00")
        End if
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub SplitVendor(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
        response.redirect("SplitPurchase.aspx?ID=" & SeqNo.text)
    End sub
    
    Sub dtgPartWithoutSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdApproval_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim i As Integer
            For i = 0 To dtgPartWithSource.Items.Count - 1
                Dim QtyToBuy As TextBox = CType(dtgPartWithSource.Items(i).FindControl("QtyToBuy"), TextBox)
                Dim quantity as Integer
                Dim SeqNo As Label = Ctype(dtgPartWithSource.Items(i).FindControl("lblSeqNo"), Label)
    
                Try
                    quantity = CInt(QtyToBuy.Text)
                    ReqCOM.ExecuteNonQuery("Update PR_D set Qty_To_Buy = " & Quantity & " where Seq_no = " & SeqNo.text & ";")
                    ReqCOM.ExecuteNonQuery("Update PR_D set variance = Qty_To_Buy - PR_Qty where Seq_no = " & SeqNo.text & ";")
                Catch
                End Try
            Next
    
        response.redirect("BuyerApproval.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        LoadDataWithSource()
    End Sub
    
    Sub cmdBuyerApproval_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim i As Integer
        Dim strSql as string
    
        StrSql = "Update PR_D set Buyer_Ind = 'N' from Part_Source PS, Part_Master PM where PS.Part_No = PM.Part_no and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "';"
        ReqCOM.ExecuteNonQuery(StrSql)
    
        For i = 0 To dtgPartWithSource.Items.Count - 1
    
            Dim remove As CheckBox = CType(dtgPartWithSource.Items(i).FindControl("Remove"), CheckBox)
            If remove.Checked = true Then
                Try
                    Dim QtyToBuy As TextBox = CType(dtgPartWithSource.Items(i).FindControl("QtyToBuy"), TextBox)
                    Dim quantity as Integer
                    Dim SeqNo As Label = Ctype(dtgPartWithSource.Items(i).FindControl("lblSeqNo"), Label)
    
                    quantity = CInt(QtyToBuy.Text)
                    ReqCOM.ExecuteNonQuery("Update PR_D set Qty_To_Buy = " & Quantity & ",Buyer_Ind = 'Y' where Seq_no = " & SeqNo.text & ";")
                    ReqCOM.ExecuteNonQuery("Update PR_D set variance = Qty_To_Buy - PR_Qty where Seq_no = " & SeqNo.text & ";")
                Catch err as exception
                End Try
            end if
        Next
    
        response.redirect("BuyerApproval.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub dtgBuyerApprovedParts_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim i As Integer
        For i = 0 To dtgPartWithSource.Items.Count - 1
            Dim PRQty as Label = CType(dtgPartWithSource.Items(i).FindControl("PRQty"), Label)
            Dim BuyerApproval as Label = CType(dtgPartWithSource.Items(i).FindControl("BuyerApproval"), Label)
            Dim QtyToBuy as TextBox = CType(dtgPartWithSource.Items(i).FindControl("QtyToBuy"), TextBox)
    
            dtgPartWithSource.Items(i).Cells(11).Text = format(dtgPartWithSource.Items(i).Cells(9).Text * QtyToBuy.Text,"##,##0.00")
            dtgPartWithSource.Items(i).Cells(8).Text = QtyToBuy.text - PRQty.text
            dtgPartWithSource.Items(i).Cells(12).Text = dtgPartWithSource.Items(i).Cells(8).Text * dtgPartWithSource.Items(i).Cells(9).Text
        Next
    End Sub
    
    Sub ValQty(sender As Object, e As ServerValidateEventArgs)
        Dim i As Integer
    
        For i = 0 To dtgPartWithSource.Items.Count - 1
        dtgPartWithSource.Items(i).CssClass = ""
                Dim QtyToBuy As TextBox = CType(dtgPartWithSource.Items(i).FindControl("QtyToBuy"), TextBox)
                Dim PRQty As Label = CType(dtgPartWithSource.Items(i).FindControl("PRQty"), Label)
                Dim MaxQty As Label = CType(dtgPartWithSource.Items(i).FindControl("MaxQty"), Label)
    
                'if (cdec(QtyToBuy.text) >= cdec(PRQty.text)) and (cdec(QtyToBuy.text) <= cdec(MaxQty.text)) then
    
                if (cdec(QtyToBuy.text) < cdec(PRQty.text)) then
                     CheckQty.ErrorMessage = "Input error on line no : " & i + 1
                    dtgPartWithSource.Items(i).CssClass = "PartSource"
                    e.isvalid = false
                elseif cdec(QtyToBuy.text) > cdec(MaxQty.text) then
                    CheckQty.ErrorMessage = "Input error on line no : " & i + 1
                    dtgPartWithSource.Items(i).CssClass = "PartSource"
                    e.isvalid = false
                end if
            Next
    End Sub
    
    Sub lnkPartsWithoutSource_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
            Dim PRProcessingDay as integer = ReqCOM.GetFieldVal("Select PR_PROCESSING_DAYS from main","PR_PROCESSING_DAYS")
            Dim PRNo as integer = trim(lblPRNo.text)
            Dim MRPNo as integer = ReqCOM.GetFieldVal("Select MRP_NO from PR_M where PR_No = " & PRNo & ";","MRP_NO")
            Dim Strsql, SchDays as string
            Dim PRDate, BOMDate as date
            Dim FirstSupplierSeqNo,VenCode as string
            Dim TotalOrderQty,i,StdPack,MOQ,LeadTime,ReqQty,OrderQty,QtyToBuy,ReelTobuy,Quantity as integer
            Dim UP as Decimal
    
            Dim RsPR as SqlDataReader = ReqCOM.ExeDataReader("Select * from PR_D where PR_NO = " & PRNo & ";")
                Do while rsPR.read
                    BOMDate = rsPR("BOM_Date").toString
                    SchDays = rsPR("SCH_Days").toString
                loop
    
                For i = 0 to dtgPartWithoutSource.Items.Count - 1
                    Dim PartNo as Label = CType(dtgPartWithoutSource.Items(i).findControl("PartNo"), Label)
                    Dim PRQty as Label = CType(dtgPartWithoutSource.Items(i).findControl("PRQty"), Label)
                    Dim ReqDate as Label = CType(dtgPartWithoutSource.Items(i).findControl("ReqDate"), Label)
                    Dim SeqNo as Label = CType(dtgPartWithoutSource.Items(i).findControl("SeqNo"), Label)
    
                    Try
                        if ReqCOM.FuncCheckDuplicate("Select Part_No from Part_Source where Part_No = '" & PartNo.text & "';","Part_No") = true then
                            FirstSupplierSeqNo = ReqCOM.GetFieldVal("Select Top 1 Seq_No from Part_Source where Part_No = '" & PartNo.text & "' order by Ven_Seq asc","Seq_No")
                            VenCode = ReqCOM.GetFieldVal("Select Ven_Code from Part_Source where Seq_No = " & FirstSupplierSeqNo & ";","Ven_Code")
                            Dim RsSource as SQLDataReader = ReqCOM.ExeDataReader("Select * from Part_Source where Seq_No = " & FirstSupplierSeqNo & ";")
    
                            do while rsSource.read
                                ReqQty = cint(PRQty.text)
                                StdPack = rsSource("STD_PACK_QTY")
                                MOQ = rsSource("MIN_ORDER_QTY")
                                LeadTime = rsSource("LEAD_TIME")
                                UP = rsSource("UP")
                            Loop
    
    
                            if cint(ReqQty) <= cint(MOQ) then
                                OrderQty = cint(MOQ)
                                QtyToBuy = QtyToBuy + cint(MOQ)
                            ElseIf cint(ReqQty) > cint(MOQ) then
                                ReelTobuy = Math.Ceiling(cint(ReqQty) / cint(StdPack))
                                OrderQty = cint(StdPack) * cint(ReelToBuy)
                                QtyToBuy = QtyToBuy + cint(OrderQty)
                            end if
    
                            PRDate = DateAdd(DateInterval.Day, -cint(LeadTime) * 7, DateValue(cdate(ReqDate.text)))
                            StrSql = "Insert into PR_D(MRP_NO,PR_NO,PART_NO,Req_Date,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,PR_DATE,BOM_DATE,SCH_DAYS,UP,VEN_CODE,LEAD_TIME,VARIANCE) "
                            StrSql = StrSql + "Select " & cint(MRPNo) & "," & PRNo & ",'" & trim(PartNo.text) & "','" & trim(ReqDate.text) & "'," & cint(OrderQty) & "," & PRProcessingDay & "," & cint(ReqQty) & ",'" & PRDate & "','" & BOMDate & "'," & SchDays & "," & UP & ",'" & trim(VenCode) & "'," & cint(LeadTime) * 7 & "," & cint(QtyToBuy) & " - " & cint(ReqQty) & ";"
                            ReqCOM.ExecuteNonQuery(StrSql)
                            reqCOM.ExecuteNonQuery("Delete from PR_D where seq_no = " & SeqNo.text & ";")
                            Response.redirect("PRDet.aspx?ID=" & Request.params("ID"))
                            RsSource.close
                        End if
                    Catch Err as exception
                        response.write(Err.tostring())
                    End Try
                next
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("TempPR.aspx")
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
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 18px" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="77px">PR No.</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPRNo" runat="server" cssclass="OutputText" width="373px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="77px">Buyer Code</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblBuyerCode" runat="server" cssclass="OutputText" width="373px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="77px">Buyer Name</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblBuyerName" runat="server" cssclass="OutputText" width="373px"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 25px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center"><asp:Label id="Label9" runat="server">Parts without source</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="dtgPartWithoutSource" runat="server" width="100%" OnSelectedIndexChanged="dtgPartWithoutSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatNoSourceRow">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SeqNo" runat="server" visible="false" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="PART NO">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="Desc" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="REQ DATE">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="ReqDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "REQ_DATE") %>' dataformatstring="{0:d}" /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="PR QTY">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PRQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_QTY") %>' dataformatstring="{0:f}" /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p>
                                                                        <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <asp:LinkButton id="lnkPartsWithoutSource" onclick="lnkPartsWithoutSource_Click" runat="server">Click here</asp:LinkButton>
                                                                                        &nbsp; <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="537px">to
                                                                                        refresh part list.</asp:Label></td>
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
                                                    <table style="HEIGHT: 19px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label8" runat="server" cssclass="PartWithSourceLabel" width="100%">Buyer
                                                                        Approved Part(s)</asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="dtgBuyerApprovedParts" runat="server" width="100%" OnSelectedIndexChanged="dtgBuyerApprovedParts_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatBuyer" OnSortCommand="SortGrid" AllowSorting="True" OnEditCommand="SplitVendor">
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
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 15px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label3" runat="server" cssclass="PartWithSourceLabel" width="100%">Parts
                                                                        With Source(s)</asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:CustomValidator id="CheckQty" runat="server" OnServerValidate="ValQty" ForeColor=" " Display="Dynamic" ErrorMessage="Please re-confirm the on hold qty for the highlighted item(s)." CssClass="ErrorText" EnableClientScript="False" Width="100%"></asp:CustomValidator>
                                                                    </p>
                                                                    <p>
                                                                        <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatRow" OnSortCommand="SortGrid" AllowSorting="True" OnEditCommand="SplitVendor">
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
                                                                                <asp:TemplateColumn HeaderText="PR QTY">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PRQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_QTY") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="QTY TO BUY(a)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <asp:TextBox id="QtyToBuy" runat="server" align="right" Columns="8" MaxLength="6" Text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' width="48px" />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="MOQ">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="MaxQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>' /> 
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
                                                                                <asp:BoundColumn DataField="Ven_Code" HeaderText="Supplier"></asp:BoundColumn>
                                                                                <asp:BoundColumn HeaderText="Amt(a*c)" DataFormatString="{0:f}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn HeaderText="Var(Amt)(b*c)">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:EditCommandColumn ButtonType="PushButton" UpdateText="" CancelText="" EditText="Split"></asp:EditCommandColumn>
                                                                                <asp:TemplateColumn HeaderText="Select">
                                                                                    <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                                    <ItemTemplate>
                                                                                        <center>
                                                                                            <asp:CheckBox id="Remove" runat="server" />
                                                                                        </center>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="143px" Text="Update PR List"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdBuyerApproval" onclick="cmdBuyerApproval_Click" runat="server" Width="167px" Text="Buyer Approval"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="127px" Text="Back"></asp:Button>
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
