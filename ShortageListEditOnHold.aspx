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

    'Dim ShowAlert as string
    
        Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.ispostback = false then
                    If SortField = "" then SortField = "MRP_No"
                    procLoadGridData()
                    if dtgShortage.items.count = 0 then
                        button2.visible = false
                        cmdNo.visible = false
                        dtgShortage.visible = false
                        lblShortageMsg.visible = true
                    else
                        button2.visible = true
                        cmdNo.visible = true
                        dtgShortage.visible = true
                        lblShortageMsg.visible = false
                    End if
            end if
        End Sub
    
        Sub OurPager(sender as object,e as datagridpagechangedeventargs)
            dtgShortage.CurrentPageIndex = e.NewPageIndex
            ProcLoadGridData()
        end sub
    
        Sub ProcLoadGridData()
            Dim SortSeq as String
            SortSeq = IIF((SortAscending=True),"Asc","Desc")
            Dim StrSql as string = "SELECT pr.On_Hold,pr.P_Level,pr.Sch_Days,PM.WIP,PR.Earliest_Date,PR.Lot_No,PR.Model_No, PM.PART_DESC + '|' + PM.PART_SPEC AS [PART_DESC],PM.BUYER_CODE,PR.SEQ_NO,PR.PART_NO,PR.BOM_DATE,PR.eta_date,PR.QTY FROM MRP_D PR,PART_MASTER PM WHERE " & trim(cmbField.selectedItem.value) & " like '%" & trim(txtSearch.text) & "%' and PR.PART_NO = PM.PART_NO ORDER BY " & SortField & " " & SortSeq
            Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
            Dim CurrMRPNo as integer = ReqCOM.GetFieldVal("Select MRP_No from Main","Mrp_No") - 1
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MRP_D")
    
            ReqCOM.executeNonQuery("Update MRP_D set POST='N',Qty = On_Hold")
            lblShortageMsg.visible = false
    
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
    
        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                Dim supplierLT as integer
                Dim NetETA as date
                Dim ETA as Date
                E.Item.Cells(7).Text = format(cdate(e.Item.Cells(7).Text),"dd/MMM/yy")
                E.Item.Cells(8).Text = format(cdate(e.Item.Cells(8).Text),"dd/MMM/yy")
    
                Dim ActualQty As Label = CType(e.Item.FindControl("ActualQty"), Label)
                ActualQty.text = cint(ActualQty.text)
                if e.Item.Cells(3).Text = "" then e.Item.Cells(3).Text = "-"
                Dim Quantity As textbox = CType(e.Item.FindControl("Quantity"), textbox)
                Quantity.text = "0"
    
                if ReqCom.funcCheckDuplicate("Select top 1 Ven_Code from Part_Source where Part_no = '" & trim(e.item.cells(3).text) & "' order by ven_seq asc","Ven_Code") = true then
                    e.item.cells(12).text = ReqCom.GetFieldVal("Select top 1 Ven_Code from Part_Source where Part_no = '" & trim(e.item.cells(3).text) & "' order by ven_seq asc","Ven_Code")
                    e.item.cells(13).text = ReqCom.GetFieldVal("Select top 1 Lead_Time from Part_Source where Part_no = '" & trim(e.item.cells(3).text) & "'  order by ven_seq asc","Lead_Time")
                    supplierLT = cint(e.item.cells(13).text) * 7
                    ETA = cdate(e.item.cells(8).text)
    
                    NetETA = dateadd(DateInterval.day,-supplierLT,ETA)
                    e.item.cssclass = ""
                    if cdate(neteta) < now then e.item.cssclass = "Variance"
                end if
            End if
        End Sub
    
        Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
            SortField = CStr(e.SortExpression)
            ProcLoadGridData()
        End Sub
    
    
    Sub ShowAlert(Msg as string)
    
        Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
    
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
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
    
    Sub cmdNo_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        procLoadGridData
    End Sub
    
    Sub Button2_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim i As Integer
                For i = 0 To dtgShortage.Items.Count - 1
                    Dim OnHoldQty As TextBox = CType(dtgShortage.Items(i).FindControl("Quantity"), TextBox)
                    Dim quantity as Integer
                    Dim SeqNo As Label = Ctype(dtgShortage.Items(i).FindControl("lblSeqNo"), Label)
    
                        quantity = CInt(OnHoldQty.Text)
                        ReqCOm.ExecuteNonQuery("Update MRP_D set ON_HOLD = " & cint(OnHoldQty.text) & ", POST='Y' where Seq_No = " & SeqNo.text & ";")
                Next
    
                Dim PRNo as string = ReqCOM.GetDocumentNo("PR_NO")
                Dim MRPNo as integer = cint(ReqCOM.GetFieldVal("Select MRP_NO from main","MRP_NO")) - 1
                Dim StrSql,CurrVendor as string
                Dim CurrUP as decimal
                Dim ReqQty as decimal
    
    
    
    
                    Dim rsTemp as SQLDataReader
                    rsTemp = ReqCOM.ExeDataReader("Select MRP_D.Seq_No from tpr_d, mrp_d WHERE MONTH(MRP_D.ETA_Date) = MONTH(TPR_D.Req_DATE) and mrp_d.part_no = tpr_d.part_no and mrp_d.post='Y'")
                    Do while rsTemp.read
                        ReqCOM.ExecuteNonQuery("Update TPR_D set Tpr_D.PR_No = '" & trim(PRNo) & "',TPR_D.PR_Qty = TPR_D.PR_QTY + (MRP_D.QTY-MRP_D.ON_HOLD) from tpr_d, mrp_d WHERE MONTH(MRP_D.ETA_Date) = MONTH(TPR_D.Req_DATE) and mrp_d.part_no = tpr_d.part_no and mrp_d.post='Y' and mrp_d.Seq_No = " & cint(rsTemp("Seq_No")) & ";")
                        ReqCOM.ExecuteNonQuery("Update MRP_D set Post = 'N' where Seq_no = " & cint(rsTemp("Seq_No")) & ";")
                    loop
    
    
    
                    StrSql = "Insert into TPR_M(PR_NO,MRP_NO,STATUS,SOURCE,CREATE_BY,CREATE_DATE) Select '" & trim(PRNo) & "'," & MRPNo & ",'OPEN','MRP','" & trim(request.cookies("U_ID").value) & "','" & now & "';"
                    ReqCOm.ExecuteNonQuery(StrSql)
    
                    ReqCOM.executeNonQuery("insert into TPR_D(Part_No,PR_QTY,Sch_Days,PR_NO,MRP_NO,BOM_DATE) select distinct(Part_No),sum(Qty-On_Hold),Max(Sch_Days)," & PRNo & "," & MRPNo & ",Min(ETA_DATE) from MRP_D where POST = 'Y' group by month(ETA_DATE),part_no")
                        Dim RsPR1 as SQLDataReader = ReqCOM.ExeDataReader("Select * from TPR_D where PR_NO = '" & PRNo & "';")
                        Dim RsPartSource as SQLDataReader
                        Dim QtyToBuy as integer
                       Dim Temp as string
                       Dim ReelTobuy as integer
                        Do while RsPR1.read
    
                            ReqCOM.ExecuteNonQuery("Update Part_Source set Qty_To_Buy = 0")
                            ReqQty = cdec(RsPR1("PR_QTY"))
                            RsPartSource = ReqCOM.ExeDataReader("Select top 1 * from Part_Source where Part_No = '" & trim(rsPR1("Part_No")) & "' and  ven_seq = 1")
                                Do while rsPartSource.read
                                    if ReqQty <= RsPartSource("Min_Order_Qty") then ReqQty = cdec(RsPartSource("Min_Order_Qty"))
    
                                        ReelTobuy = Math.Ceiling(ReqQty / RSPartSource("STD_Pack_Qty"))
                                        ReqCOM.ExecuteNonQuery("Update Part_Source set QTY_TO_BUY = Std_Pack_Qty * " & ReelToBuy & " where Seq_No = " & RsPartSource("Seq_No") & ";")
                                        CurrVendor = RsPartSource("Ven_Code")
                                        CurrUP = RsPartSource("UP")
                                        QtyToBuy = RsPartSource("Std_Pack_Qty") * ReelToBuy
    
    
    
    
    
                                    'if ReqQty <= RsPartSource("Min_Order_Qty") then
                                    '    ReqCOM.ExecuteNonQuery("Update Part_Source set QTY_TO_BUY = Min_Order_Qty where Seq_No = " & rsPartSource("Seq_No") & ";")
                                    '    CurrUP = RsPartSource("UP")
                                    '    QtyToBuy = RsPartSource("Min_Order_Qty")
                                    '    CurrVendor = RsPartSource("Ven_Code")
                                    'ElseIf ReqQty > RsPartSource("Min_Order_Qty") then
                                    '    Dim ReelTobuy as integer = Math.Ceiling(ReqQty / RSPartSource("STD_Pack_Qty"))
                                    '    ReqCOM.ExecuteNonQuery("Update Part_Source set QTY_TO_BUY = Std_Pack_Qty * " & ReelToBuy & " where Seq_No = " & RsPartSource("Seq_No") & ";")
                                    '    CurrVendor = RsPartSource("Ven_Code")
                                    '    CurrUP = RsPartSource("UP")
                                    '    QtyToBuy = RsPartSource("Std_Pack_Qty") * ReelToBuy
                                    'end if
                                loop
                            'ReqCOM.ExecuteNonQuery("Update TPR_D set UP = " & CurrUP & ",Qty_To_Buy = " & QtyToBuy & ", Ven_Code = '" & trim(CurrVendor) & "' where Part_No = '" & trim(RsPR1("Part_No")) & "' and MRP_No = " & MRPNo & ";")
                            ReqCOM.ExecuteNonQuery("Update TPR_D set UP = " & CurrUP & ",Qty_To_Buy = " & QtyToBuy & ", Ven_Code = '" & trim(CurrVendor) & "' where sEQ_nO = " & CINT(RsPR1("Seq_No")) & ";")
                        loop
    
                        ReqCOM.ExecuteNonQuery("Update TPR_D set SCH_DAYS = 0 where sch_days is null")
                        ReqCOM.ExecuteNonQUery("Update TPR_D set Process_days = 5  where MRP_No = " & MRPNo & ";")
                        ReqCOM.ExecuteNonQuery("Update TPR_D set TPR_D.Lead_Time = PS.Lead_Time * 7 from Part_Source PS,TPR_D where TPR_D.Ven_Code = PS.Ven_Code and TPR_D.Part_No = PS.Part_No and MRP_No = " & MRPNo & ";")
                        ReqCOM.ExecuteNonQuery("Update TPR_D set REQ_Date = BOM_Date where MRP_No = " & MRPNo & ";")
                        ReqCOM.ExecuteNonQuery("Update TPR_D set PR_Date = Req_Date - Lead_Time where MRP_No = " & MRPNo & ";")
                        ReqCOM.ExecuteNonQuery("Update TPR_D set Variance = QTY_TO_BUY - PR_QTY where MRP_NO = " & MRPNo & ";")
                        ReqCOM.ExecuteNonQuery("Update TPR_M set TO_PURC = 'YES' where MRP_NO = " & MRPNo & ";")
                        ReqCOM.ExecuteNonQuery("delete from TPR_D where pr_qty = 0")
                        ReqCOM.ExecuteNonQuery("Update Main set PR_NO = PR_NO + 1")
                        ReqCOM.executeNonQuery("Update MRP_D set POST='N',Qty = On_Hold")
                        ReqCOM.ExecuteNonQuery("Delete from MRP_D where Qty = 0")
                        Response.cookies("AlertMessage").value = "Selected parts have been submitted to purchasing for PR processing"
    
                        response.redirect("AlertMessage.aspx?ReturnURL=ShortageListEditOnHold.aspx")
                        'Selected parts have been submitted to purchasing for PR processing.
                        Response.redirect("MaterialShortageSubmit.aspx?ID=" & request.params("ID"))
                End if
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table bordercolor="white" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">MATERIAL SHORTAGE
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="lblShortageMsg" runat="server" cssclass="Instruction" width="100%">There
                                                    are no parts to display.</asp:Label>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 11px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label1" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:TextBox id="txtSearch" runat="server" CssClass="OutputText" Width="178px"></asp:TextBox>
                                                                        &nbsp;&nbsp;&nbsp; &nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">FROM</asp:Label>&nbsp;&nbsp;&nbsp;
                                                                        &nbsp; 
                                                                        <asp:DropDownList id="cmbField" runat="server" CssClass="OutputText" Width="162px">
                                                                            <asp:ListItem Value="PR.PART_NO">PART NO</asp:ListItem>
                                                                            <asp:ListItem Value="PR.MODEL_NO">MODEL NO</asp:ListItem>
                                                                            <asp:ListItem Value="PR.LOT_NO">LOT NO</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                        <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" CssClass="outputText" Text="SEARCH"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="left">
                                                    <asp:CustomValidator id="CheckOnHoldQty" runat="server" CssClass="ErrorText" Width="100%" EnableClientScript="False" ErrorMessage="Please re-confirm the on hold qty for the highlighted item(s)." Display="Dynamic" ForeColor=" " OnServerValidate="ValOnHoldQty"></asp:CustomValidator>
                                                </p>
                                                <p align="center">
                                                    <asp:DataGrid id="dtgShortage" runat="server" OnSortCommand="SortGrid" AllowSorting="True" Height="35px" Font-Names="Verdana" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PageSize="10" BorderColor="White" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" OnPageIndexChanged="OurPager" AllowPaging="True">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="LOT_NO" SortExpression="LOT_NO" HeaderText="LOT NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="MODEL_NO" SortExpression="MODEL_NO" HeaderText="MODEL NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_NO" SortExpression="PR.PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="PART_DESC" HeaderText="DESCRIPTION/SPEC"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="P_Level" HeaderText="Level"></asp:BoundColumn>
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
                                                            <asp:BoundColumn HeaderText="Supplier">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn HeaderText="L/T (Weeks)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 20px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="Button2" onclick="Button2_Click" runat="server" Width="184px" Text="Submit Parts to Purchasing"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdNo" onclick="cmdNo_Click" runat="server" Width="115px" Text="Back"></asp:Button>
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
    </form>
</body>
</html>
