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
                If SortField = "" then SortField = "MRP_No"
                procLoadGridData()
                if dtgShortage.items.count = 0 then
                    button2.visible = false
                    cmdNo.visible = false
                    Label1.visible = false
                    dtgShortage.visible = false
                    cmdBack.visible = true
                    lblShortageMsg.visible = true
                else
                    button2.visible = true
                    cmdNo.visible = true
                    Label1.visible = true
                    dtgShortage.visible = true
                    cmdBack.visible = false
                    lblShortageMsg.visible = false
                End if
            end if
        End Sub
    
        Sub ProcLoadGridData()
            Dim SortSeq as String
            Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
            Dim CurrMRPNo as integer = ReqCOM.GetFieldVal("Select MRP_No from Main","Mrp_No") - 1
    
            SortSeq = IIF((SortAscending=True),"Asc","Desc")
            ReqCOM.executeNonQuery("Update MRP_D set POST='NO',Qty = On_Hold")
            lblShortageMsg.visible = false
            Dim StrSql as string = "SELECT pr.On_Hold,PR.Sch_Days,PM.WIP,PR.Earliest_Date,PR.Lot_No,PR.Model_No, PM.PART_DESC + '|' + PM.PART_SPEC AS [PART_DESC],PM.BUYER_CODE,PR.SEQ_NO,PR.PART_NO,PR.BOM_DATE,PR.eta_date,PR.QTY FROM MRP_D PR,PART_MASTER PM WHERE PR.PART_NO = PM.PART_NO ORDER BY " & SortField & " " & SortSeq
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MRP_D")
    
    
            dtgShortage.visible = true
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
    
        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                E.Item.Cells(6).Text = format(cdate(e.Item.Cells(6).Text),"MM/dd/yy")
                E.Item.Cells(5).Text = format(cdate(e.Item.Cells(5).Text),"MM/dd/yy")
    
                Dim ActualQty As Label = CType(e.Item.FindControl("ActualQty"), Label)
                ActualQty.text = cint(ActualQty.text)
                if e.Item.Cells(3).Text = "" then e.Item.Cells(3).Text = "-"
                Dim Quantity As textbox = CType(e.Item.FindControl("Quantity"), textbox)
                Quantity.text = "0"
                Dim Source As Label = CType(e.Item.FindControl("lblSource"), Label)
            End if
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
                Dim Sel As CheckBox = CType(dtgShortage.Items(i).FindControl("Select"), CheckBox)
                Dim quantity as Integer
                Dim SeqNo As Label = Ctype(dtgShortage.Items(i).FindControl("lblSeqNo"), Label)
    
                Try
                    quantity = CInt(OnHoldQty.Text)
                    ReqCOm.ExecuteNonQuery("Update MRP_D set ON_HOLD = " & cint(OnHoldQty.text) & ",Release='YES' where Seq_No = " & SeqNo.text & ";")
                Catch
                End Try
            Next
            response.redirect("MaterialShortageList.aspx")
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
            if page.isvalid = true then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim i As Integer
                For i = 0 To dtgShortage.Items.Count - 1
                    Dim OnHoldQty As TextBox = CType(dtgShortage.Items(i).FindControl("Quantity"), TextBox)
                    Dim quantity as Integer
                    Dim SeqNo As Label = Ctype(dtgShortage.Items(i).FindControl("lblSeqNo"), Label)
    
                    Try
                        quantity = CInt(OnHoldQty.Text)
                        ReqCOm.ExecuteNonQuery("Update MRP_D set ON_HOLD = " & cint(OnHoldQty.text) & ", POST='YES' where Seq_No = " & SeqNo.text & ";")
                        ReqCOM.executeNonQuery("Update MRP_D set Release_type = 'FULL' where On_Hold = 0 AND SEQ_NO = " & SeqNo.text & ";")
                    Catch
                    End Try
                Next
    
                'Dim PRNo as string = ReqCOM.GetFieldVal("Select PR_NO from main","PR_NO")
                Dim PRNo as string = ReqCOM.GetDocumentNo("PR_NO")
                Dim MRPNo as integer = cint(ReqCOM.GetFieldVal("Select MRP_NO from main","MRP_NO")) - 1
                Dim StrSql,CurrVendor as string
                Dim CurrUP as decimal
    
                StrSql = "Insert into PR_M(PR_NO,MRP_NO,STATUS,SOURCE,CREATE_BY,CREATE_DATE) Select '" & trim(PRNo) & "'," & MRPNo & ",'OPEN','MRP','" & trim(request.cookies("U_ID").value) & "','" & now & "';"
                ReqCOm.ExecuteNonQuery(StrSql)
                StrSql = "insert into PR_D(Part_No,PR_QTY,Sch_Days,PR_NO,MRP_NO,BOM_DATE) select distinct(Part_No),sum(Qty-On_Hold),Max(Sch_Days)," & PRNo & "," & MRPNo & ",Min(BOM_Date) from MRP_D where POST = 'YES' group by month(bom_date),part_no"
                ReqCOM.executeNonQuery(StrSql)
                    Dim RsPR1 as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR_D where PR_NO = '" & PRNo & "';")
                    Dim RsPartSource as SQLDataReader
                    Dim QtyToBuy as integer
                    Dim Temp as string
                    Do while RsPR1.read
                        ReqCOM.ExecuteNonQuery("Update Part_Source set Qty_To_Buy = 0")
                        Dim ReqQty = RsPR1("PR_QTY")
                        RsPartSource = ReqCOM.ExeDataReader("Select top 1 * from Part_Source where Part_No = '" & trim(rsPR1("Part_No")) & "' order by seq_no DESC")
                            Do while rsPartSource.read
                                if ReqQty <= RsPartSource("Min_Order_Qty") then
                                    ReqCOM.ExecuteNonQuery("Update Part_Source set QTY_TO_BUY = Min_Order_Qty where Seq_No = " & rsPartSource("Seq_No") & ";")
                                    CurrUP = RsPartSource("UP")
                                    QtyToBuy = RsPartSource("Min_Order_Qty")
                                    CurrVendor = RsPartSource("Ven_Code")
                                ElseIf ReqQty > RsPartSource("Min_Order_Qty") then
                                    Dim ReelTobuy as integer = Math.Ceiling(ReqQty / RSPartSource("STD_Pack_Qty"))
                                    'Dim ReelTobuy as integer = Math.Ceiling(ReqQty / RSPartSource("STD_Pack_Qty"))
                                    ReqCOM.ExecuteNonQuery("Update Part_Source set QTY_TO_BUY = Std_Pack_Qty * " & ReelToBuy & " where Seq_No = " & RsPartSource("Seq_No") & ";")
                                    CurrVendor = RsPartSource("Ven_Code")
                                    CurrUP = RsPartSource("UP")
    
                                    QtyToBuy = RsPartSource("Std_Pack_Qty") * ReelToBuy
                                end if
                            loop
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
    
                    ReqCOM.executeNonQuery("Update MRP_D set POST='NO',Qty = On_Hold")
                    ReqCOM.ExecuteNonQuery("Delete from MRP_D where Qty = 0")
    
                    Response.redirect("MaterialShortageSubmit.aspx?ID=" & request.params("ID"))
            End if
    End Sub
    
    Sub ValOnHoldQty(sender As Object, e As ServerValidateEventArgs)
        Dim i As Integer
        For i = 0 To dtgShortage.Items.Count - 1
            Dim Quantity As Textbox = CType(dtgShortage.Items(i).FindControl("Quantity"), Textbox)
            Dim ActualQty As Label = CType(dtgShortage.Items(i).FindControl("ActualQty"), Label)
            dtgShortage.Items(i).CssClass = ""
            if Quantity.text = "" then
                dtgShortage.Items(i).CssClass = "PartSource"
                e.isvalid = false
            elseif isnumeric(Quantity.text) = false then
                dtgShortage.Items(i).CssClass = "PartSource"
                e.isvalid = false
            Elseif cint(Quantity.text) > cint(ActualQty.text) then
                dtgShortage.Items(i).CssClass = "PartSource"
                e.isvalid = false
            end if
        Next
    End Sub
    
    Sub UserControl2_Load(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdNo_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">MATERIAL SHORTAGE
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="lblShortageMsg" runat="server" width="100%" cssclass="Instruction">There
                                                    are no parts to display.</asp:Label>
                                                </p>
                                                <p align="left">
                                                    <asp:CustomValidator id="CheckOnHoldQty" runat="server" Width="100%" OnServerValidate="ValOnHoldQty" ForeColor=" " Display="Dynamic" ErrorMessage="Please re-confirm the on hold qty for the highlighted item(s)." CssClass="ErrorText" EnableClientScript="False"></asp:CustomValidator>
                                                </p>
                                                <p align="center">
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" OnItemDataBound="FormatRow" AutoGenerateColumns="False" Font-Size="XX-Small" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="100" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Font-Names="Verdana" Height="35px" AllowSorting="True" OnSortCommand="SortGrid">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="LOT_NO" SortExpression="LOT_NO" HeaderText="LOT NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MODEL_NO" SortExpression="MODEL_NO" HeaderText="MODEL NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_NO" SortExpression="PR.PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_DESC" HeaderText="DESCRIPTION/SPEC"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="SCH_DAYS" HeaderText="SCH DAYS"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="BOM_DATE" HeaderText="FOD" DataFormatString="{0:d}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="eta_date" HeaderText="ETA" DataFormatString="{0:d}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="WIP" HeaderText="WIP">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="QTY">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ActualQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "QTY") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="On Hold Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="Quantity" runat="server" align="right" Columns="8" MaxLength="6" Text='' width="48px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label1" runat="server" cssclass="Instruction">Are you sure to submit
                                                    the above parts ?</asp:Label>
                                                </p>
                                                <p align="center">
                                                    <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="83px" Text="Back"></asp:Button>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 20px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="Button2" onclick="Button1_Click_1" runat="server" Width="62px" Text="Yes"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="cmdNo" onclick="cmdNo_Click" runat="server" Width="62px" Text="No"></asp:Button>
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
        </p>
    </form>
</body>
</html>
