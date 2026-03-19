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
        if page.ispostback = false then procLoadGridData ()
    End Sub

    Sub ProcLoadGridData()
        Dim SortSeq as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim CurrMRPNo as integer = ReqCOM.GetFieldVal("Select MRP_No from Main","Mrp_No") - 1
        Dim StrSql as string = "Select * from pr1_m where App4_Date is not null order by Seq_No desc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MRP_D")
        dtgShortage.DataSource=resExePagedDataSet.Tables("MRP_D").DefaultView
        dtgShortage.DataBind()
    end sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
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
            Dim SubmitDate As Label = CType(e.Item.FindControl("SubmitDate"), Label)
            Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
            Dim App2Date As Label = CType(e.Item.FindControl("App2Date"), Label)
            Dim App3Date As Label = CType(e.Item.FindControl("App3Date"), Label)
            Dim App4Date As Label = CType(e.Item.FindControl("App4Date"), Label)
            Dim App5Date As Label = CType(e.Item.FindControl("App5Date"), Label)
            Dim Status As Label = CType(e.Item.FindControl("Status"), Label)



            if trim(SubmitDate.text) <> "" then SubmitDate.text = format(cdate(SubmitDate.text),"dd/MMM/yy")
            if trim(App1Date.text) <> "" then App1Date.text = format(cdate(App1Date.text),"dd/MMM/yy")
            if trim(App2Date.text) <> "" then App2Date.text = format(cdate(App2Date.text),"dd/MMM/yy")
            if trim(App3Date.text) <> "" then App3Date.text = format(cdate(App3Date.text),"dd/MMM/yy")
            if trim(App4Date.text) <> "" then App4Date.text = format(cdate(App4Date.text),"dd/MMM/yy")
            if trim(App5Date.text) <> "" then App5Date.text = format(cdate(App5Date.text),"dd/MMM/yy")
            if trim(Status.text) <> "COMPLETED" then e.Item.CssClass = "PartSource"
        End if
    End Sub

    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("PRApp5Det.aspx?ID=" & clng(SeqNo.text))
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
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
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="98%" OnItemCommand="ItemCommand" AllowPaging="True" Height="35px" Font-Names="Verdana" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PageSize="20" BorderColor="Gray" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="PR #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PRNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_NO") %>' /> <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' visible= "false" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Type">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PRType" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Type") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Submit By">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SubmitBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_By") %>' /> - <asp:Label id="SubmitDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Submit_Date") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Buyer">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App1By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_By") %>' /> - <asp:Label id="App1Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App1_Date") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PCMC">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App2By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_By") %>' /> - <asp:Label id="App2Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App2_Date") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Buyer HOD">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App3By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_By") %>' /> - <asp:Label id="App3Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App3_Date") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Mgt.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App4By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_By") %>' /> - <asp:Label id="App4Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App4_Date") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="P/O Gen.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="App5By" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App5_By") %>' /> - <asp:Label id="App5Date" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "App5_Date") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Status" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_STATUS") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Action">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgView" ToolTip="View this P/R" ImageUrl="View.gif" CommandArgument='VIEW' runat="server"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle mode="NumericPages"></PagerStyle>
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
        </p>
    </form>
</body>
</html>
