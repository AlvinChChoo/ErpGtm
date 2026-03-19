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
            If SortField = "" then SortField = "PR.Part_No"
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            lblPRNo.text = ReqCOM.GetFieldVal("Select PR_NO from pr_M where Seq_No = " & request.params("ID") & ";","PR_NO")
            LoadDataWithSource()
            LoadDataWithoutSource()
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

    Sub LoadDataWithSource()
        Dim SortSeq as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim StrSql as string = "SELECT PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Name] FROM pr_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No order by " & SortField & " " & SortSeq
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
        dtgPartWithSource.DataBind()
    end sub

    Sub LoadDataWithoutSource()
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "SELECT PM.Part_Spec + '|' + PM.Part_Desc as [Desc], PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no FROM pr_d PR,Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.part_no = pm.part_no and pr.ven_code = '' order by pr.part_no asc"
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
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
            E.Item.Cells(3).Text = format(cdate(E.Item.Cells(3).Text),"MM/dd/yy")
            E.Item.Cells(4).Text = format(cdate(E.Item.Cells(4).Text),"MM/dd/yy")
            E.Item.Cells(5).Text = cint(E.Item.Cells(5).Text)
            E.Item.Cells(6).Text = cint(E.Item.Cells(6).Text)
            E.Item.Cells(7).Text = cint(E.Item.Cells(7).Text)
            E.Item.Cells(8).Text = format(cdec(E.Item.Cells(8).Text),"##,##0.0000")

            Dim AppNo as Label = CType(e.Item.FindControl("AppNo"), Label)
            Dim Status as Label = CType(e.Item.FindControl("Status"), Label)

            'response.write(AppNo.text)
            if cint(AppNo.Text) <= 0 then
                AppNo.Text = ""
                Status.Text = ""
            Else 'if E.Item.Cells(10).Text > 0
                e.Item.CssClass = "PRExpired"
                if Status.Text = "YES" then Status.Text = "YES" Else Status.Text = "NO"
            end if
        End if
    End Sub

         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub

    Sub SplitVendor(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ApprovalNo as Integer = ReqCOM.GetFieldVal("Select Approval_No from PR_D where Seq_No = " & cint(e.Item.cells(0).text) & ";","Approval_No")
        if ApprovalNo <> 0 then Exit sub
            response.redirect("SplitPurchase.aspx?ID=" & e.Item.cells(0).text)

    End sub

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

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">PURCHASE REQUISITION
                                DETAILS</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 18px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Label id="Label5" runat="server" width="77px" cssclass="LabelNormal">PR No.</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblPRNo" runat="server" width="107px" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                &nbsp;
                                <table style="HEIGHT: 5px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:Label id="Label1" runat="server" width="100%" cssclass="PartWithoutSourceLabel">ATTENTION
                                                    : Part without source.</asp:Label>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithoutSource" runat="server" width="100%" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" ShowFooter="True" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgPartWithoutSource_SelectedIndexChanged" Height="216px">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Desc" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="REQ_DATE" HeaderText="REQ DATE" DataFormatString="{0:d}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PR_QTY" HeaderText="PR QTY" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
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
                                                    <asp:Label id="Label3" runat="server" width="100%" cssclass="PartWithSourceLabel">Parts
                                                    With Source(s)</asp:Label>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" ShowFooter="True" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" Height="216px" OnItemDataBound="FormatRow" OnEditCommand="SplitVendor" AllowSorting="True" OnSortCommand="SortGrid">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="Seq_No" HeaderText="SEQ NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_NO" SortExpression="PR.Part_No" HeaderText="PART NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="BUYER_CODE" SortExpression="PM.Buyer_Code" HeaderText="BUYER"></asp:BoundColumn>
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
                                                            <asp:BoundColumn DataField="QTY_TO_BUY" HeaderText="BUY QTY" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="VARIANCE" HeaderText="VAR" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="UP" HeaderText="U/P">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ven_name" SortExpression="Ven.Ven_Code" HeaderText="SUPPLIER"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="App. No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="AppNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Approval_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="App?">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Approved") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="Split"></asp:EditCommandColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <asp:Label id="Label4" runat="server" width="100%" cssclass="RemarksNormal">Click
                                                    on the "Split" link if you wish to split PR to multiple suppliers</asp:Label>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Width="173px" Text="Add New Part" CausesValidation="False"></asp:Button>
                                <asp:Button id="cmdApproval" onclick="cmdApproval_Click" runat="server" Width="160px" Text="Submit For Approval" CausesValidation="False"></asp:Button>
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
