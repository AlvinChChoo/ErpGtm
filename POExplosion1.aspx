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
            If SortField = "" then SortField = "PR.Part_No"
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            lblPRNo.text = ReqCOM.GetFieldVal("Select approval_no from pr_approval where Seq_No = " & request.params("ID") & ";","approval_no")
            LoadDataWithSource()
    
            IF ReqCOM.funcCheckDuplicate("Select PO_EXP from pr_approval where approval_no = '" & trim(lblPRNo.text) & "' and po_exp = 'Y'","po_exp") = true then
                cmdConvert.visible = false
            else
                cmdConvert.visible = true
            End if
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
        'Dim StrSql as string = "SELECT PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Name] FROM pr_d PR, vendor ven, Part_Master PM WHERE PR.PR_NO = " & lblPRNo.text & " and pr.PO_No is null and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and PR.Approval_No > 0 order by " & SortField & " " & SortSeq
    
        'Dim StrSql as string = "SELECT PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Name] FROM pr1_d PR, vendor ven, Part_Master PM WHERE pr.PO_No is null and pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and PR.Approval_No = '" & trim(lblPRNo.text) & "' order by " & SortField & ",PR.PR_Date " & SortSeq
        Dim StrSql as string = "SELECT PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_code as [Ven_Name] FROM pr1_d PR, vendor ven, Part_Master PM WHERE pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and PR.Approval_No = '" & trim(lblPRNo.text) & "' order by " & SortField & ",PR.PR_Date " & SortSeq
    
    
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"pr1")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("pr1").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
            E.Item.Cells(3).Text = format(cdate(E.Item.Cells(3).Text),"MM/dd/yy")
            E.Item.Cells(4).Text = format(cdate(E.Item.Cells(4).Text),"MM/dd/yy")
            E.Item.Cells(5).Text = cint(E.Item.Cells(5).Text)
            E.Item.Cells(6).Text = cint(E.Item.Cells(6).Text)
            E.Item.Cells(7).Text = cint(E.Item.Cells(7).Text)
            E.Item.Cells(8).Text = format(cdec(E.Item.Cells(8).Text),"##,##0.0000")
    
            'Dim Sel As CheckBox = CType(e.Item.FindControl("Sel"), CheckBox)
            'Sel.checked = true
    
            'Dim Quantity As textbox = CType(e.Item.FindControl("Quantity"), textbox)
            'Quantity.text = cint(Quantity.text)
    
        End if
    End Sub
    
         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
    Sub SplitVendor(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ApprovalNo as Integer = ReqCOM.GetFieldVal("Select Approval_No from pr1_d where Seq_No = " & cint(e.Item.cells(0).text) & ";","Approval_No")
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
    
    Sub cmdConvert_Click(sender As Object, e As EventArgs)
        If page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
            reqcom.executeNonQuery("Truncate Table PR_Temp")
            Dim i As Integer
            Dim PRTemp as integer = ReqCOM.GetFIeldVal("Select PR_Temp from main","PR_Temp")
            For i = 0 To dtgPartWithSource.Items.Count - 1
                Dim SeqNo As Label = CType(dtgPartWithSource.Items(i).FindControl("lblSeqNo"), Label)
                Dim Sel As CheckBox = CType(dtgPartWithSource.Items(i).FindControl("Sel"), CheckBox)
                Dim StrSql as string
                StrSql = "Insert into PR_Temp(PR_IND_NO,PR_SEQ,MRP_NO,PR_NO,PART_NO,SO_TYPE,REQ_DATE,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,VARIANCE,PR_DATE,PO_NO,BOM_DATE,SCH_DAYS,UP,NET_TOTAL,VEN_CODE,LEAD_TIME,CREATE_DATE,CREATE_BY) Select Seq_No," & PRTemp & ", MRP_NO,PR_NO,PART_NO,SO_TYPE,REQ_DATE,QTY_TO_BUY,PROCESS_DAYS,PR_QTY,VARIANCE,PR_DATE,PO_NO,BOM_DATE,SCH_DAYS,UP,NET_TOTAL,VEN_CODE,LEAD_TIME,'" & NOW & "','" & request.cookies("U_ID").value & "' from pr1_d where Seq_No = " & cint(SeqNo.text) & ";"
                response.write(StrSql)
                ReqCOM.ExecuteNonQuery(StrSql)
            Next
            ReqCOm.executeNonQuery("Update PR_Approval set PO_EXP = 'Y' where Approval_No = '" & trim(lblPRNo.text) & "';")
            ReqCOm.executeNonQuery("Update Main set PR_Temp = PR_Temp + 1")
            Response.redirect("POExplosion2.aspx?ID=" & PRTemp & "&ReturnID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("POExplosion.aspx")
    End Sub
    
    Sub ProcValSel(sender As Object, e As ServerValidateEventArgs)
        Dim i As Integer
    
        For i = 0 To dtgPartWithSource.Items.Count - 1
    
            Dim Sel As CheckBox = CType(dtgPartWithSource.Items(i).FindControl("Sel"), CheckBox)
            Dim StrSql as string
            Try
                If Sel.Checked = true Then
                    e.isvalid = true :Exit sub
                end if
            Catch Err as Exception
    
            End Try
        Next
        e.isvalid = false
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
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">PO Explosion</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
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
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
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
                                                                                <asp:TemplateColumn HeaderText="">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
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
                                                                    <p>
                                                                        <table style="HEIGHT: 17px" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <div align="left">
                                                                                            <asp:Button id="cmdConvert" onclick="cmdConvert_Click" runat="server" Text="Convert to P/O" Width="181px"></asp:Button>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div align="right">
                                                                                            <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Text="Cancel" Width="181px" CausesValidation="False"></asp:Button>
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
