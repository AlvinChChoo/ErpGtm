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
             if page.ispostback = false then
                 If SortField = "" then SortField = "MRP_No"
                 procLoadGridData ()
             end if
         End Sub
    
         Sub ProcLoadGridData()
            Dim SortSeq as String
            Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
            Dim CurrMRPNo as integer = ReqCOM.GetFieldVal("Select MRP_No from Main","Mrp_No") - 1
            Dim StrSql as string = "Select * from PR_Approval order by Seq_No desc"
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MRP_D")
    
            dtgShortage.DataSource=resExePagedDataSet.Tables("MRP_D").DefaultView
            dtgShortage.DataBind()
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
    
         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdUpdate_Click(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdMain_Click(sender As Object, e As EventArgs)
             response.redirect("Main.aspx")
         End Sub
    
         Sub cmdFinish_Click(sender As Object, e As EventArgs)
             response.redirect("Default.aspx")
         End Sub
    
         Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
             SortField = CStr(e.SortExpression)
             ProcLoadGridData()
         End Sub
    
         Sub cmdUpdate_Click_1(sender As Object, e As EventArgs)
    
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim i As Integer
             For i = 0 To dtgShortage.Items.Count - 1
                 Dim OnHoldQty As TextBox = CType(dtgShortage.Items(i).FindControl("Quantity"), TextBox)
    
                 Try
    
                     If isnumeric(OnHoldQty.text) = true Then
                         Dim SeqNo As Label = Ctype(dtgShortage.Items(i).FindControl("lblSeqNo"), Label)
                         ReqCOm.ExecuteNonQuery("Update MRP_D set ON_HOLD = " & cint(OnHoldQty.text) & " where Seq_No = " & SeqNo.text & ";")
    
                     End If
                 Catch
             '        MyError.Text = "There has been a problem with one or more of your inputs."
                 End Try
             Next
         End Sub
    
         Sub Button1_Click(sender As Object, e As EventArgs)
            Dim MyTrans as SQLTransaction
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As New sqlCommand
             Try
                 Dim StrSql as string = "Insert into Test(test) select 'TTT';"
                 myTrans=myConnection.BeginTransaction()
                 myCommand.Connection = myConnection
                 myCommand.CommandText = StrSQL
                 myCommand.CommandType = CommandType.Text
                 myCommand.Transaction=myTrans
                 myCommand.ExecuteNonQuery()
                 myTrans.Commit()
             Catch err as exception
                 if not myTrans is nothing then
                     myTrans.Rollback()
                     response.redirect("OrderErrorPage.aspx")
                 End if
            Finally
                myConnection.Close()
                myCommand.Dispose()
                myConnection.Dispose()
            end try
         End Sub
    
    Sub Button1_Click_1(sender As Object, e As EventArgs)
        Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim PRNo as string = ReqCOM.GetFieldVal("Select PR_NO from main","PR_NO")
        Dim MRPNo as integer = cint(ReqCOM.GetFieldVal("Select MRP_NO from main","MRP_NO")) - 1
        Dim StrSql,CurrVendor as string
        Dim CurrUP as decimal
    
        StrSql = "Insert into PR_M(PR_NO,MRP_NO,STATUS,SOURCE,CREATE_BY,CREATE_DATE) Select '" & trim(PRNo) & "'," & MRPNo & ",'OPEN','MRP','" & trim(request.cookies("U_ID").value) & "','" & now & "';"
        ReqCOm.ExecuteNonQuery(StrSql)
    
        StrSql = "insert into PR_D(Part_No,PR_QTY,Sch_Days,PR_NO,MRP_NO,BOM_DATE) select distinct(Part_No),sum(Qty-On_Hold),Max(Sch_Days)," & PRNo & "," & MRPNo & ",Min(BOM_Date) from MRP_D where source = 'PR' and mrp_no = " & MRPNo & " group by month(bom_date),part_no"
        ReqCOM.executeNonQuery(StrSql)
    
        'Update PR (Vendor Code and Unit Price)
            Dim RsPR1 as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR_D where MRP_NO = " & MRPNo & ";")
            Dim RsPartSource as SQLDataReader
            Dim QtyToBuy as integer
            Dim Temp as string
            Do while RsPR1.read
                ReqCOM.ExecuteNonQuery("Update Part_Source set Qty_To_Buy = 0")
                Dim ReqQty = RsPR1("PR_QTY")
    
                RsPartSource = ReqCOM.ExeDataReader("Select top 1 * from Part_Source where Part_No = '" & trim(rsPR1("Part_No")) & "' order by seq_no asc")
    
                    Do while rsPartSource.read
                        if ReqQty <= RsPartSource("Min_Order_Qty") then
                            ReqCOM.ExecuteNonQuery("Update Part_Source set QTY_TO_BUY = Min_Order_Qty where Part_No = '" & trim(rsPartSource("Part_No")) & "' and Ven_Code = '" & trim(rsPartSource("Ven_Code")) & "';")
                        ElseIf ReqQty > RsPartSource("Min_Order_Qty") then
                            Dim ReelTobuy as integer = Math.Ceiling(ReqQty / RSPartSource("STD_Pack_Qty"))
                            Temp = temp & "-" & ReelToBuy.tostring
                            ReqCOM.ExecuteNonQuery("Update Part_Source set QTY_TO_BUY = Std_Pack_Qty * " & ReelToBuy & " where Part_No = '" & trim(rsPr1("Part_No")) & "' and Ven_Code = '" & trim(rsPartSource("Ven_Code")) & "';")
                        end if
                    loop
    
                    CurrUP = ReqCOM.GetFieldVal("SELECT TOP 1 up*Qty_To_Buy,UP FROM PART_SOURCE WHERE PART_NO = '" & trim(RsPR1("Part_No")) & "' ORDER BY up ASC","UP")
                    QtyToBuy =  ReqCOM.GetFieldVal("Select Qty_To_Buy from Part_Source where Part_No = '" & trim(RsPR1("Part_No")) & "' and UP = " & CurrUP & " order by UP desc","Qty_To_Buy")
                    CurrVendor = ReqCOM.GetFieldVal("Select Ven_Code from Part_Source where Part_No = '" & trim(RsPR1("Part_No")) & "' and UP = " & CurrUP & " order by UP desc","Ven_Code")
                    ReqCOM.ExecuteNonQuery("Update PR_D set UP = " & CurrUP & ",Qty_To_Buy = " & QtyToBuy & ", Ven_Code = '" & trim(CurrVendor) & "' where Part_No = '" & trim(RsPR1("Part_No")) & "' and MRP_No = " & MRPNo & ";")
                loop
    
                ReqCOM.ExecuteNonQuery("Update PR_D set SCH_DAYS = 0 where sch_days is null")
                ReqCOM.ExecuteNonQUery("Update PR_D set Process_days = 5  where MRP_No = " & MRPNo & ";")
                ReqCOM.ExecuteNonQuery("Update PR_D set PR_D.Lead_Time = PS.Lead_Time * 7 from Part_Source PS,PR_D where PR_D.Ven_Code = PS.Ven_Code and PR_D.Part_No = PS.Part_No and MRP_No = " & MRPNo & ";")
                ReqCOM.ExecuteNonQuery("Update PR_D set REQ_Date = BOM_Date - Sch_Days - Process_days where MRP_No = " & MRPNo & ";")
                ReqCOM.ExecuteNonQuery("Update PR_D set PR_Date = Req_Date - Lead_Time where MRP_No = " & MRPNo & ";")
                ReqCOM.ExecuteNonQuery("Update PR_D set Variance = QTY_TO_BUY - PR_QTY where MRP_NO = " & MRPNo & ";")
                ReqCOM.ExecuteNonQuery("Update PR_M set TO_PURC = 'YES' where MRP_NO = " & MRPNo & ";")
                ReqCOM.ExecuteNonQuery("Update Main set PR_NO = PR_NO + 1")
                ProcLoadGridData()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
           Dim ApprovalDate As Label = CType(e.Item.FindControl("ApprovalDate"), Label)
           Dim ApprovedDate As Label = CType(e.Item.FindControl("ApprovedDate"), Label)
    
           ApprovalDate.text = format(CDate(ApprovalDate.text),"MM/dd/yy")
           if ApprovedDate.text <> "" then ApprovedDate.text = format(CDate(ApprovedDate.text),"MM/dd/yy")
    
        End if
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
            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">PR APPROVAL
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="98%" OnSortCommand="SortGrid" AllowSorting="True" Height="35px" Font-Names="Verdana" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PageSize="100" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:HyperLinkColumn Text="View" DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="PRApprovalListBuyerHODDet.aspx?ID={0}"></asp:HyperLinkColumn>
                                                            <asp:BoundColumn DataField="APPROVAL_NO" HeaderText="APPROVAL NO"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="SUBMISSION DATE">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="ApprovalDate" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "APPROVAL_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Date Approved">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="ApprovedDate" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "APPROVED_DATE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 17px" width="98%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <div align="right">
                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="135px"></asp:Button>
                                                                        </div>
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
        <p align="left">
            &nbsp;
        </p>
    </form>
</body>
</html>
