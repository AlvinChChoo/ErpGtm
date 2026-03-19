<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            Dim StrSql as string
            'Dim PartNo as string
            'PartNo = ReqCOM.GetFieldVal("Select Part_No from SR_D where seq_no = " & request.params("ID") & ";","Part_No")
    
            Dim RsSource as SQLDataReader = ReqCOM.ExeDataReader("Select * from SR_D where Seq_No = " & request.params("ID") & ";")
    
            Do while RSSource.read
                lblSRNo.text = RsSource("SR_No").tostring()
                lbllotno.text = RsSource("lot_No").tostring()
                lblPartNo.text = RsSource("Part_No").tostring()
                lblETA.text = format(RsSource("ETA_Date"),"dd/MMM/yy")
                lblPRQty.text = clng(RsSource("Req_Qty"))
                lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & trim(lblPartNo.text) & "';","Part_Desc")
                lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & trim(lblPartNo.text) & "';","Part_Spec")
                lblMfgPartNo.text = ReqCOM.GetFieldVal("Select M_Part_No from Part_Master where Part_No = '" & trim(lblPartNo.text) & "';","M_Part_No")
            loop
    
            StrSql = "Select Ven.ven_Name,ven.ven_Code ,PS.LEAD_TIME,PS.STD_PACK_qty,PS.MIN_ORDER_QTY,PS.UP from Part_Source PS,Vendor VEN where PS.Part_No = '" & trim(lblPartNo.text) & "' and ps.ven_code = ven.ven_Code order by Ven_Seq asc"
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"Part_Source")
            Dim DV as New DataView(resExePagedDataSet.Tables("Part_Source"))
            Dim SortSeq as String
            cmdUpdate.visible = false
            dtgPartSource.DataSource=DV
            dtgPartSource.DataBind()
        end if
    End Sub
    
    Sub dtgPartSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true  then
            if trim(cmdNext.text) = "Back" then
                Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
                Dim TotalOrderQty,SeqNo as integer
                Dim PRProcessingDay as integer = ReqCOM.GetFieldVal("Select PR_PROCESSING_DAYS from main","PR_PROCESSING_DAYS")
                Dim i as integer
                Dim PRNo as integer = ReqCOM.GetFieldVal("Select sr_No from SR_D where seq_no = " & request.params("ID") & ";","SR_No")
                Dim Strsql, SchDays as string
                Dim ReqDate, PRDate, BOMDate as date
    
                For i = 0 to dtgPartSource.Items.Count - 1
                    Dim Quantity as Textbox = CType(dtgPartSource.Items(i).findControl("Quantity"), Textbox)
                    Dim StdPack as Label = CType(dtgPartSource.Items(i).findControl("StdPack"), Label)
                    Dim MOQ as Label = CType(dtgPartSource.Items(i).findControl("MOQ"), Label)
                    Dim Supplier as Label = CType(dtgPartSource.Items(i).findControl("Supplier"), Label)
                    Dim LeadTime as Label = CType(dtgPartSource.Items(i).findControl("LeadTime"), Label)
                    Dim UP as Label = CType(dtgPartSource.Items(i).findControl("UP"), Label)
                    Dim OrderQty as Label = CType(dtgPartSource.Items(i).findControl("OrderQty"), Label)
    
                    if cint(Quantity.text) <> 0 then
                        PRDate = DateAdd(DateInterval.Day, -cint(LeadTime.text) * 7, DateValue(cdate(lblETA.text)))
                        StrSql = "Insert into SR_D(sr_No,lot_no,PART_NO,eta_date,QTY_TO_BUY,PROCESS_DAYS,PR_DATE,UP,VEN_CODE,LEAD_TIME,VARIANCE,req_qty) "
                        StrSql = StrSql + "Select " & PRNo & ",'" & trim(lblLotNo.text) & "','" & trim(lblPartNo.text) & "','" & trim(lblETA.text) & "'," & cint(OrderQty.text) & "," & PRProcessingDay & ",'" & PRDate & "'," & UP.text & ",'" & trim(Supplier.text) & "'," & cint(LeadTime.text) * 7 & "," & cint(OrderQty.text) & " - " & cint(Quantity.text) & "," & cint(Quantity.text) & ";"
                        ReqCOM.ExecuteNonQuery(StrSql)
                    end if
                next
    
                ReqCOm.ExecuteNonQuery("Update SR_D set SR_D.Lead_Time = PS.Lead_Time * 7 from Part_Source PS,SR_D where SR_D.Ven_Code = PS.Ven_Code and SR_D.Part_No = PS.Part_No and SR_D.SR_No = '" & trim(lblSRNo.text) & "';")
                ReqCOm.ExecuteNonQuery("Update SR_D set NET_ETA = ETA_Date - Lead_Time where  SR_No = '" & trim(lblSRno.text) & "';")
    
                ReqCOM.ExecuteNonQuery("Update SR_D set Calculated_qty = qty_to_buy where sr_No = '" & trim(lblSRno.text) & "';")
                reqCOM.ExecuteNonQuery("Delete from SR_D where seq_no = " & cint(request.params("ID")) & ";")
    
                SeqNo = ReqCOM.GetFieldVal("select Seq_No from SR_M where SR_No = '" & trim(lblSRNo.text) & "';","Seq_No")
                Response.redirect("PCMCSRApp1Det.aspx?ID=" & SeqNo)
            End if
        End if
    End Sub
    
    Protected Sub FormatRow1(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim Source As Label = CType(e.Item.FindControl("lblSource"), Label)
            Dim StdPack as Label = CType(e.Item.FindControl("StdPack"), Label)
            Dim MOQ as Label = CType(e.Item.FindControl("MOQ"), Label)
            StdPack.text = cint(StdPack.text)
            MOQ.text = cint(MOQ.text)
        end if
    End Sub
    
    Sub ValSources(sender As Object, e As ServerValidateEventArgs)
        if trim(cmdNext.text) = "Next" then
            Dim TotalPRQty,i as decimal
            TotalPRQty = 0
    
            For i = 0 to dtgPartSource.Items.Count - 1
                Dim Quantity as Textbox = CType(dtgPartSource.Items(i).findControl("Quantity"), Textbox)
                if Quantity.text = "" then Quantity.text = 0
                TotalPRQty = TotalPRQty + quantity.text
            next
    
            if TotalPRQty <> lblPRQty.text then
                e.isvalid = false
                CustomValidator1.errormessage = "PR quantity does not match."
            end if
        End if
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo as integer
        SeqNo = ReqCOM.GetFieldVal("select Seq_No from SR_M where sr_No = '" & trim(lblSRNo.text) & "';","Seq_No")
        Response.redirect("PCMCSRApp1Det.aspx?ID=" & SeqNo)
    End Sub
    
    Sub cmdNext_Click(sender As Object, e As EventArgs)
    if page.isvalid = false then exit sub
        Dim i,ReelTobuy as integer
        Dim QtyToBuy as integer = 0
        if trim(cmdNext.text) = "Next" then
    
            lblDesc.text = "2. Please confirm on the split quantity and supplier."
            For i = 0 to dtgPartSource.Items.Count - 1
                Dim OrderQty as Label = CType(dtgPartSource.Items(i).findControl("OrderQty"), label)
                Dim Quantity as textbox = CType(dtgPartSource.Items(i).findControl("Quantity"), textbox)
                Dim MOQ as Label = CType(dtgPartSource.Items(i).findControl("MOQ"), label)
                Dim StdPack as Label = CType(dtgPartSource.Items(i).findControl("StdPack"), label)
    
    
                if cint(Quantity.text) = 0 then
                    OrderQty.text = 0
                elseif cint(Quantity.text) <= cint(MOQ.text) then
                    OrderQty.text = cint(MOQ.text)
                    QtyToBuy = QtyToBuy + cint(MOQ.Text)
                ElseIf cint(Quantity.text) > cint(MOQ.text) then
                    ReelTobuy = Math.Ceiling(cint(Quantity.text) / cint(StdPack.text))
                    OrderQty.text = cint(StdPack.text) * cint(ReelToBuy)
                    QtyToBuy = QtyToBuy + cint(OrderQty.text)
                end if
                Quantity.enabled = False
            next
    
            if cint(QtyToBuy) - cdec(lblPRQty.text) > 0 then lblExcess.text = "There will be material excess of " & cint(QtyToBuy) - cdec(lblPRQty.text) & " unit(s)."
            cmdNext.text = "Back"
            cmdUpdate.visible = true
        elseif trim(cmdNext.text) = "Back" then
    
            lblDesc.text = "1. Select PR quantity for each of the supplier you want to split."
            For i = 0 to dtgPartSource.Items.Count - 1
                Dim Quantity as textbox = CType(dtgPartSource.Items(i).findControl("Quantity"), textbox)
                Dim OrderQty as Label = CType(dtgPartSource.Items(i).findControl("OrderQty"), Label)
                OrderQty.text = "0"
                Quantity.enabled = true
            next
            cmdNext.text = "Next"
            cmdUpdate.visible = false
            lblExcess.text = ""
    
        end if
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
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">SPLIT PURCHASE </asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:Label id="lblDesc" runat="server" width="100%" cssclass="Instruction">1. Select
                                                    PR quantity for each of the supplier you want to split.</asp:Label>
                                                </p>
                                                <p>
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" EnableClientScript="False" OnServerValidate="ValSources" Display="Dynamic" CssClass="ErrorText" ForeColor=" " Width="100%"></asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <asp:Label id="lblSRNo" runat="server" width="241px" visible="False">Label</asp:Label><asp:Label id="lblLotNo" runat="server" width="150px" visible="False"></asp:Label>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" bordercolor="black" cellspacing="0" cellpadding="4" border="1" table="table">
                                                        <tbody>
                                                            <tr>
                                                                <td width="20%" bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Part Details</asp:Label></td>
                                                                <td width="80%" colspan="3">
                                                                    <asp:Label id="lblPartNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="lblPartDesc" runat="server" cssclass="OutputText"></asp:Label>&nbsp;&nbsp; <asp:Label id="lblPartSpec" runat="server" cssclass="OutputText"></asp:Label>&nbsp;&nbsp; <asp:Label id="lblMfgPartNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" width="112px" cssclass="LabelNormal">ETA</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblETA" runat="server" width="161px" cssclass="OutputText"></asp:Label></td>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" width="112px" cssclass="LabelNormal">PR Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPRQty" runat="server" width="161px" cssclass="OutputText"> </asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartSource" runat="server" width="100%" OnItemDataBound="FormatRow1" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgPartSource_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Supplier">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Supplier" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "VEN_CODE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Ven_Name" HeaderText="Name"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="L/T (W)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="LeadTime" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "LEAD_TIME") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="STD PACK">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="StdPack" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "STD_PACK_qty") %>' dataformatstring="{0:g}" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MOQ">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="MOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MIN_ORDER_QTY") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="U/P">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PR QTY">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="Quantity" runat="server" align="right" Columns="8" MaxLength="6" Text='' width="60px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Order Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="OrderQty" runat="server" text='0' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <asp:Label id="lblExcess" runat="server" forecolor="Red" font-size="X-Large" font-bold="True"></asp:Label>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 15px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdNext" onclick="cmdNext_Click" runat="server" Width="123px" Text="Next"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="125px" Text="Update"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="125px" Text="Cancel" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="left">
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
