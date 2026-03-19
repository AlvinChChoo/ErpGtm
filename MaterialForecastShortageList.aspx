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
                procLoadGridData()
            end if
        End Sub

        Sub ProcLoadGridData()
            Dim SortSeq as String
            Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
            Dim CurrMRPNo as integer = ReqCOM.GetFieldVal("Select MRP_FORECAST_No from Main","MRP_FORECAST_No") - 1
            ReqCOM.executeNonQuery("Update MRP_FORECAST_D set POST='NO',Qty = On_Hold")
            lblShortageMsg.visible = false
            Dim StrSql as string = "SELECT pr.On_Hold,PM.WIP,PR.Earliest_Date,PR.Lot_No,PR.Model_No, PM.PART_DESC + '|' + PM.PART_SPEC AS [PART_DESC],PM.BUYER_CODE,PR.SEQ_NO,PR.PART_NO,PR.BOM_DATE,PR.eta_date,PR.QTY FROM MRP_Forecast_D PR,PART_MASTER PM WHERE PR.PART_NO = PM.PART_NO and PR.Source = 'PR' and PR.MRP_NO = " & CurrMRPNo & " and Qty > 0 ORDER BY " & SortField & " " & SortSeq
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MRP_Forecast_D")
            cmdUpdate.enabled = True
            Button1.enabled = True
            dtgShortage.visible = true
            dtgShortage.DataSource=resExePagedDataSet.Tables("MRP_Forecast_D").DefaultView
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
                 'E.Item.Cells(6).Text = format(cdate(e.Item.Cells(6).Text),"MM/dd/yy")
                 'E.Item.Cells(5).Text = format(cdate(e.Item.Cells(5).Text),"MM/dd/yy")
                 'e.Item.Cells(7).Text = cint(e.Item.Cells(7).Text)
                 'e.Item.Cells(8).Text = cint(e.Item.Cells(8).Text)
                 'if e.Item.Cells(3).Text = "" then e.Item.Cells(3).Text = "-"
                 'Dim Quantity As textbox = CType(e.Item.FindControl("Quantity"), textbox)
                 'Quantity.text = "0"
                 'e.Item.Cells(10).Text=cint(e.Item.Cells(8).Text)-cint(Quantity.text)
                 'Dim Source As Label = CType(e.Item.FindControl("lblSource"), Label)

                 'Dim Sel As CheckBox = CType(e.Item.FindControl("Select"), CheckBox)
                'Sel.checked = true

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
                'quantity = CInt(Qty.Text)


                Try
                    quantity = CInt(OnHoldQty.Text)

                    'if Sel.checked = true then
                        'Check for on-hold qty
                        ReqCOm.ExecuteNonQuery("Update MRP_Forecast_D set ON_HOLD = " & cint(OnHoldQty.text) & ",Release='YES' where Seq_No = " & SeqNo.text & ";")
                    'End if

                    'If isnumeric(OnHoldQty.text) = true Then
                    '    Dim SeqNo As Label = Ctype(dtgShortage.Items(i).FindControl("lblSeqNo"), Label)
                    '    ReqCOm.ExecuteNonQuery("Update MRP_D set ON_HOLD = " & cint(OnHoldQty.text) & " where Seq_No = " & SeqNo.text & ";")
                    'End If
                Catch
             '        MyError.Text = "There has been a problem with one or more of your inputs."
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
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim i As Integer
            For i = 0 To dtgShortage.Items.Count - 1
                Dim OnHoldQty As TextBox = CType(dtgShortage.Items(i).FindControl("Quantity"), TextBox)
                Dim Sel As CheckBox = CType(dtgShortage.Items(i).FindControl("Select"), CheckBox)
                Dim quantity as Integer
                Dim SeqNo As Label = Ctype(dtgShortage.Items(i).FindControl("lblSeqNo"), Label)

                Try
                    quantity = CInt(OnHoldQty.Text)
                    'ReqCOm.ExecuteNonQuery("Update MRP_D set ON_HOLD = " & cint(OnHoldQty.text) & ", Qty = " & cint(OnHoldQty.text) & ", POST='YES' where Seq_No = " & SeqNo.text & ";")
                    ReqCOm.ExecuteNonQuery("Update MRP_Forecast_D set ON_HOLD = " & cint(OnHoldQty.text) & ", POST='YES' where Seq_No = " & SeqNo.text & ";")
                    ReqCOM.executeNonQuery("Update MRP_Forecast_D set Release_type = 'FULL' where On_Hold = 0 AND SEQ_NO = " & SeqNo.text & ";")
                Catch
                End Try
            Next

            '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


        'Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim PRNo as string = ReqCOM.GetFieldVal("Select PR_NO from main","PR_NO")
        Dim MRPNo as integer = cint(ReqCOM.GetFieldVal("Select MRP_NO from main","MRP_NO")) - 1
        Dim StrSql,CurrVendor as string
        Dim CurrUP as decimal

        StrSql = "Insert into PR_M(PR_NO,MRP_NO,STATUS,SOURCE,CREATE_BY,CREATE_DATE) Select '" & trim(PRNo) & "'," & MRPNo & ",'OPEN','MRP','" & trim(request.cookies("U_ID").value) & "','" & now & "';"
        ReqCOm.ExecuteNonQuery(StrSql)

        'StrSql = "insert into PR_D(Part_No,PR_QTY,Sch_Days,PR_NO,MRP_NO,BOM_DATE) select distinct(Part_No),sum(Qty-On_Hold),Max(Sch_Days)," & PRNo & "," & MRPNo & ",Min(BOM_Date) from MRP_D where source = 'PR' and mrp_no = " & MRPNo & " group by month(bom_date),part_no"
        StrSql = "insert into PR_D(Part_No,PR_QTY,Sch_Days,PR_NO,MRP_NO,BOM_DATE) select distinct(Part_No),sum(Qty-On_Hold),Max(Sch_Days)," & PRNo & "," & MRPNo & ",Min(BOM_Date) from MRP_Forecast_D where source = 'PR' and POST = 'YES' group by month(bom_date),part_no"
        ReqCOM.executeNonQuery(StrSql)

        'ReqCOM.executeNonQuery("Update MRP_D set Release = 'NO'")
        'Update PR (Vendor Code and Unit Price)
            Dim RsPR1 as SQLDataReader = ReqCOM.ExeDataReader("Select * from PR_D where PR_NO = '" & PRNo & "';")
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

                            ReqCOM.ExecuteNonQuery("Update Part_Source set QTY_TO_BUY = Std_Pack_Qty * " & ReelToBuy & " where Part_No = '" & trim(rsPr1("Part_No")) & "' and Ven_Code = '" & trim(rsPartSource("Ven_Code")) & "';")
                        end if
                    loop

                    CurrUP = ReqCOM.GetFieldVal("SELECT TOP 1 up*Qty_To_Buy,UP FROM PART_SOURCE WHERE PART_NO = '" & trim(RsPR1("Part_No")) & "' ORDER BY seq_no ASC","UP")
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

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">MATERIAL SHORTAGE
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <asp:Label id="lblShortageMsg" runat="server" width="100%">There are no parts to display.</asp:Label>
                            </p>
                            <p align="center">
                                <asp:DataGrid id="dtgShortage" runat="server" width="100%" OnItemDataBound="FormatRow" AutoGenerateColumns="False" Font-Size="XX-Small" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="100" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Font-Names="Verdana" Height="35px" AllowSorting="True" OnSortCommand="SortGrid">
                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                    <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="ID">
                                            <ItemTemplate>
                                                <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="LOT_NO" SortExpression="LOT_NO" HeaderText="LOT NO"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="MODEL_NO" SortExpression="MODEL_NO" HeaderText="MODEL NO"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="PART_NO" SortExpression="PR.PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="PART_DESC" HeaderText="DESCRIPTION/SPEC"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="WIP" HeaderText="WIP">
                                            <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                            <ItemStyle horizontalalign="Right"></ItemStyle>
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="QTY" HeaderText="QTY" DataFormatString="{0:n}">
                                            <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                            <ItemStyle horizontalalign="Right"></ItemStyle>
                                        </asp:BoundColumn>
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
                            <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                <tbody>
                                    <tr>
                                        <td>
                                            <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click_1" runat="server" Text="Update" Width="121px"></asp:Button>
                                        </td>
                                        <td>
                                            <div align="right">
                                                <asp:Button id="Button1" onclick="Button1_Click_1" runat="server" Text="Release to Purchasing" Width="186px" CausesValidation="False"></asp:Button>
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
        <p align="left">
        </p>
    </form>
</body>
</html>
