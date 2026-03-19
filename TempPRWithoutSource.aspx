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
                'lblPRNo.text = ReqCOM.GetFieldVal("Select PR_NO from tpr_M where Seq_No = " & request.params("ID") & ";","PR_NO")
                lblBuyerCode.text = ReqCOM.GetFieldVal("Select Buyer_Code from Buyer where U_ID='" & trim(request.cookies("U_ID").value) & "';","Buyer_Code")
                'lblBuyerName.text = Request.cookies("U_ID").value
                LoadDataWithoutSource()
            Else
                response.redirect("UnauthorisedUser.aspx")
            End if
        end if
    End Sub

    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        dtgPartWithoutSource.CurrentPageIndex = e.NewPageIndex
        LoadDataWithoutSource()
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

    Sub LoadDataWithoutSource()
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        'Dim StrSql as string = "SELECT PM.Part_Spec + '|' + PM.Part_Desc as [Desc],PM.Buyer_Code, PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no FROM tpr_d PR,Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.part_no = pm.part_no and pr.pr_date is null and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "' order by pr.part_no asc"
        Dim StrSql as string = "SELECT PM.Part_Spec + '|' + PM.Part_Desc as [Desc],PM.Buyer_Code, PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no FROM tpr_d PR,Part_Master PM WHERE pr.part_no = pm.part_no and pr.pr_date is null and PM.Buyer_Code = '" & trim(lblBuyerCode.text) & "' order by pr.part_no asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        Dim DV as New DataView(resExePagedDataSet.Tables("pr1"))
        Dim SortSeq as String
        dtgPartWithoutSource.DataSource=DV
        dtgPartWithoutSource.DataBind()
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

    Sub dtgPartWithoutSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("TempPR.aspx")
    End Sub

    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
                if page.isvalid = true then
                Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
                Dim PRProcessingDay as integer = ReqCOM.GetFieldVal("Select PR_PROCESSING_DAYS from main","PR_PROCESSING_DAYS")
                'Dim PRNo as integer = trim(lblPRNo.text)
                'Dim MRPNo as integer = ReqCOM.GetFieldVal("Select MRP_NO from tpr_M where PR_No = " & PRNo & ";","MRP_NO")
                Dim MRPNo as integer = ReqCOM.GetFieldVal("Select MRP_NO from tpr_M","MRP_NO")
                Dim Strsql, SchDays as string
                Dim PRDate, BOMDate as date
                Dim FirstSupplierSeqNo,VenCode as string
                Dim TotalOrderQty,i,StdPack,MOQ,LeadTime,ReqQty,OrderQty,QtyToBuy,ReelTobuy,Quantity as integer
                Dim UP as Decimal

                'Dim RsPR as SqlDataReader = ReqCOM.ExeDataReader("Select * from tpr_d where PR_NO = " & PRNo & ";")
                Dim RsPR as SqlDataReader = ReqCOM.ExeDataReader("Select * from tpr_d")
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
                                'StrSql = "Insert into tpr_d(MRP_NO,PR_NO,PART_NO,Req_Date,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,PR_DATE,BOM_DATE,SCH_DAYS,UP,VEN_CODE,LEAD_TIME,VARIANCE) "
                                StrSql = "Insert into tpr_d(MRP_NO,PART_NO,Req_Date,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,PR_DATE,BOM_DATE,SCH_DAYS,UP,VEN_CODE,LEAD_TIME,VARIANCE) "
                                'StrSql = StrSql + "Select " & cint(MRPNo) & "," & PRNo & ",'" & trim(PartNo.text) & "','" & trim(ReqDate.text) & "'," & cint(OrderQty) & "," & PRProcessingDay & "," & cint(ReqQty) & ",'" & PRDate & "','" & BOMDate & "'," & SchDays & "," & UP & ",'" & trim(VenCode) & "'," & cint(LeadTime) * 7 & "," & cint(QtyToBuy) & " - " & cint(ReqQty) & ";"
                                StrSql = StrSql + "Select " & cint(MRPNo) & ",'" & trim(PartNo.text) & "','" & trim(ReqDate.text) & "'," & cint(OrderQty) & "," & PRProcessingDay & "," & cint(ReqQty) & ",'" & PRDate & "','" & BOMDate & "'," & SchDays & "," & UP & ",'" & trim(VenCode) & "'," & cint(LeadTime) * 7 & "," & cint(QtyToBuy) & " - " & cint(ReqQty) & ";"

                                ReqCOM.ExecuteNonQuery(StrSql)
                                reqCOM.ExecuteNonQuery("Delete from tpr_d where seq_no = " & SeqNo.text & ";")
                                Response.redirect("PRDet.aspx?ID=" & Request.params("ID"))
                                RsSource.close
                            End if
                        Catch Err as exception
                            response.write(Err.tostring())
                        End Try
                    next
            End if
    End Sub

    Sub LinkButton2_Click(sender As Object, e As EventArgs)
        response.redirect("TempPRWithoutSource.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub LinkButton3_Click(sender As Object, e As EventArgs)
        response.redirect("TempPRApprovedParts.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub LinkButton4_Click(sender As Object, e As EventArgs)
        response.redirect("TempPRPendingApproval.aspx?ID=" & Request.params("ID"))
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <div id="dek">
    </div>
    <script type="text/javascript">

    Xoffset=-60;
    Yoffset= 20;
    var old,skn,iex=(document.all),yyy=-1000;
    var ns4=document.layers
    var ns6=document.getElementById&&!document.all
    var ie4=document.all

    if (ns4)
        skn=document.dek
    else if (ns6)
        skn=document.getElementById("dek").style
    else if (ie4)
        skn=document.all.dek.style

    if(ns4)document.captureEvents(Event.MOUSEMOVE);
    else
    {
        skn.visibility="visible"
        skn.display="none"
    }
    document.onmousemove=get_mouse;

    function popup(msg,bak)
    {
        var content="<TABLE  WIDTH=150 BORDER=1 BORDERCOLOR=black CELLPADDING=2 CELLSPACING=0 "+
        "BGCOLOR="+bak+"><TD ALIGN=center><FONT COLOR=black SIZE=2>"+msg+"</FONT></TD></TABLE>";
        yyy=Yoffset;
        if(ns4){skn.document.write(content);skn.document.close();skn.visibility="visible"}
        if(ns6){document.getElementById("dek").innerHTML=content;skn.display=''}
        if(ie4){document.all("dek").innerHTML=content;skn.display=''}
    }

    function get_mouse(e)
    {
        var x=(ns4||ns6)?e.pageX:event.x+document.body.scrollLeft;
        skn.left=x+Xoffset;
        var y=(ns4||ns6)?e.pageY:event.y+document.body.scrollTop;
        skn.top=y+yyy;
    }

    function kill()
    {
        yyy=-1000;
        if(ns4){skn.visibility="hidden";}
        else if (ns6||ie4)
        skn.display="none"
    }
</script>
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">TEMPORARY PURCHASE
                                REQUISITION - PARTS WITHOUT SOURCE</asp:Label>
                                <table style="HEIGHT: 16px" bordercolor="gray" cellspacing="0" cellpadding="0" width="100%" bgcolor="silver" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="33%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton2" onmouseover="popup('Show all the parts without supplier. Buyer need to find supplier before approval','yellow')" onclick="LinkButton2_Click" onmouseout="kill()" runat="server" BackColor="#FF8080" Font-Bold="True" CausesValidation="False" ForeColor="White" Width="100%">PARTS WITHOUT SOURCE</asp:LinkButton>
                                                </p>
                                            </td>
                                            <td width="34%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton3" onmouseover="popup('Parts that have been approved by buyer.','yellow')" onclick="LinkButton3_Click" onmouseout="kill()" runat="server" Font-Bold="True" CausesValidation="False" ForeColor="White" Width="100%">PARTS APPROVED</asp:LinkButton>
                                                </p>
                                            </td>
                                            <td width="33%">
                                                <p align="center">
                                                    <asp:LinkButton id="LinkButton4" onmouseover="popup('Parts that are pending for buyer approval.','yellow')" onclick="LinkButton4_Click" onmouseout="kill()" runat="server" Font-Bold="True" CausesValidation="False" ForeColor="White" Width="100%">PENDING PART APPROVAL</asp:LinkButton>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithoutSource" runat="server" width="100%" OnSelectedIndexChanged="dtgPartWithoutSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatNoSourceRow" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" OnPageIndexChanged="OurPager" AllowPaging="True">
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
                                                    <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Width="111px" Text="Refresh List"></asp:Button>
                                                                    <asp:Label id="lblBuyerCode" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
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
