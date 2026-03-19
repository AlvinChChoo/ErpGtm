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

    Public RecordCount as integer
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            RecordCount = 0
            If SortField = "" then SortField = "PR.Part_No"
            LoadDataWithSource()
            Label2.text = RecordCount & " items have being selected for PR explosion"
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
        Dim StrSql as string = "SELECT PR.PR_IND_NO,PM.Buyer_Code,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.part_no,ven.ven_code as [Ven_Name],PR.Seq_No FROM pr_Temp PR, vendor ven, Part_Master PM WHERE pr.ven_code = ven.ven_code and PR.PR_Seq = " & Request.params("ID") & " and PR.Part_No = PM.Part_No order by " & SortField & " " & SortSeq
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            RecordCount = RecordCount + 1
            E.Item.Cells(3).Text = format(cdate(E.Item.Cells(3).Text),"MM/dd/yy")
            E.Item.Cells(4).Text = format(cdate(E.Item.Cells(4).Text),"MM/dd/yy")
            E.Item.Cells(5).Text = cint(E.Item.Cells(5).Text)
            E.Item.Cells(6).Text = cint(E.Item.Cells(6).Text)
            E.Item.Cells(7).Text = cint(E.Item.Cells(7).Text)
            E.Item.Cells(8).Text = format(cdec(E.Item.Cells(8).Text),"##,##0.0000")
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
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        LoadDataWithSource()
    End Sub
    
    Sub cmdNext_Click(sender As Object, e As EventArgs)
    
        If page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
            Dim VenCode,CurrCode, ShipTerm, PayTerm as string
            Dim i As Integer
            Dim RsPO as SQLDataReader = ReqCOM.ExeDataReader("Select Distinct(Ven_Code) from PR_Temp where Pr_Seq = " & Request.params("ID") & ";" )
            Dim RSOpenPO as SQLDataReader
            Dim TotalPOQty as long
            Dim PONo as string
    
            RSOpenPO = ReqCom.ExeDataReader("Select Distinct(Part_No) as [part_No],Sum(Qty_To_Buy) as [Qty_To_Buy] from pr_temp group by part_no")
            Do while rsOpenPO.read
                ReqCOM.ExecuteNonQuery("Update Part_Master set Open_PO = Open_PO + " & cdec(RSOpenPO("Qty_To_Buy")) & " where part_no = '" & trim(RSOpenPO("Part_No")) & "';")
            loop
    
            Do while RsPO.read
                PONo = ReqCOM.GetDocumentNo("PO_No")
                VenCode = RsPO("Ven_Code")
                CurrCode = ReqCom.GetFieldVal("Select Curr_Code from Cust where Cust_Code = '" & trim(VenCode) & "';","Curr_Code")
                ShipTerm = ReqCom.GetFieldVal("Select Ship_Term from Cust where Cust_Code = '" & trim(VenCode) & "';","Ship_Term")
                PayTerm = ReqCom.GetFieldVal("Select Pay_Term from Cust where Cust_Code = '" & trim(VenCode) & "';","Pay_Term")
                strSql = "Insert into PO_M(VEN_CODE,PO_NO,PO_DATE,CURR_CODE,SHIP_TERM,PAY_TERM,PR_Seq,Create_By,Create_Date) "
                StrSql = StrSql + "Select '" & trim(VenCode) & "','" & trim(PONo) & "','" & now & "','" & CurrCode & "','" & trim(ShipTerm) & "','" & trim(PayTerm) & "'," & Request.params("ID") & ",'" & trim(request.cookies("U_ID").value) & "','" & now & "';"
                ReqCOM.ExecuteNonQuery(StrSql)
                StrSql = "Insert into PO_D(PO_NO,PART_NO,DEL_DATE,prev_del_date,ORDER_QTY,UP) "
                StrSql = StrSql + "Select '" & trim(PONo) & "',Part_No,REQ_Date,Reeq_Date,QTY_TO_BUY,UP from PR_TEMP where PR_Seq = " & Request.params("ID") & " and ven_Code = '" & trim(VenCode) & "';"
                ReqCOM.ExecuteNonQuery(StrSql)
                StrSql = "Update PR1_D set PR1_D.PO_NO = " & PONO & " from PR1_D,PR_TEMP where PR_TEMP.PR_IND_NO = PR1_D.SEQ_NO"
                ReqCOM.ExecuteNonQuery(StrSql)
                ReqCOM.ExecuteNonQuery("Update Main set PO_NO = PO_NO + 1")
            Loop
    
    
    
            Response.redirect("POExplosion3.aspx?ID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("POExplosion.aspx")
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("POExplosion1.aspx?ID=" & Request.params("ReturnID"))
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
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="Instruction"></asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnItemDataBound="FormatRow" AllowSorting="True" OnSortCommand="SortGrid" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_IND_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
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
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label1" runat="server" cssclass="Instruction">Are you sure to explode
                                                    these items to Purchase Order ?</asp:Label>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdNext" onclick="cmdNext_Click" runat="server" Width="53px" Text="Yes"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="53px" Text="No" CausesValidation="False"></asp:Button>
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
