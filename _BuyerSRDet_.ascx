<%@ Control Language="VB" Debug="true" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    sub LoadSRDet()
         Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
         Dim StrSql as string = "Select srd.min_order_qty,srd.std_pack_qty,srd.up,srd.up*srd.qty_to_buy as [Amt],pm.part_spec,ven.Ven_Name,srd.rem,srd.qty_to_buy,srd.eta_date,SRD.Lot_No, SRD.Seq_No,SRD.REQ_QTY,PM.Part_Desc as [Desc],PM.Part_No as Part_No,SRD.REQ_QTY as [TotalQty] from Buyer_SR_D SRD,Part_Master PM,vendor ven where srd.ven_code = ven.ven_code and SRD.SR_No = '" & trim(lblSRNo.text) & "' and SRD.Part_No = PM.Part_No order by srd.part_no asc"
         Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
         myConnection.Open()
         Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
         Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
         MyList.DataSource = result
         MyList.DataBind()
    end sub
    
    
         Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
             Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
             lblSRNo.text = ReqCOM.GetFieldVal("Select SR_No from Buyer_SR_M where Seq_No = " & Request.params("ID") & "","SR_No")
             LoadSRDet()
             FormatRow()
             lblAmount.text = "Total Purchase Amount  :  " & format(cdec(ReqCOm.GetFieldVal("select sum(qty_to_buy*up) as [TotalAmt] from Buyer_sr_d where sr_no = '" & trim(lblSRNo.text) & "';","TotalAmt")),"##,##0.00")
         End Sub
    
         Sub FormatRow()
             Dim i As Integer
             Dim ETADate,MinOrderQty,StdPackQty,UP,QtyToBuy,ReqQty,Diff,Amt As Label
    
             For i = 0 To MyList.Items.Count - 1
                 ETADate = CType(MyList.Items(i).FindControl("ETADate"), Label)
                 MinOrderQty = CType(MyList.Items(i).FindControl("MinOrderQty"), Label)
                 StdPackQty = CType(MyList.Items(i).FindControl("StdPackQty"), Label)
                 UP = CType(MyList.Items(i).FindControl("UP"), Label)
                 QtyToBuy = CType(MyList.Items(i).FindControl("QtyToBuy"), Label)
                 ReqQty = CType(MyList.Items(i).FindControl("ReqQty"), Label)
                 Diff = CType(MyList.Items(i).FindControl("Diff"), Label)
                 Amt = CType(MyList.Items(i).FindControl("Amt"), Label)
                 ETADate.text = format(cdate(ETADate.text),"dd/MM/yy")
                 MinOrderQty.text = format(clng(MinOrderQty.text),"##,##0")
                 StdPackQty.text = format(clng(StdPackQty.text),"##,##0")
                 QtyToBuy.text = format(clng(QtyToBuy.text),"##,##0")
                 ReqQty.text = format(clng(ReqQty.text),"##,##0")
                 Diff.text = clng(QtyToBuy.text) - clng(ReqQty.text)
                 Amt.text = format(cdec(cdec(QtyToBuy.text) * cdec(UP.text)),"##,##0.00")
             Next
         End sub

</script>
<p align="center">
    <asp:Label id="Label2" runat="server" width="100%" cssclass="SectionHeader">SPECIAL
    REQUEST DETAILS</asp:Label> 
    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
        <tbody>
            <tr>
                <td>
                    <p>
                        <asp:DataList id="MyList" runat="server" Width="100%" RepeatColumns="1" BorderWidth="0px" CellPadding="1" Height="101px" OnSelectedIndexChanged="MyList_SelectedIndexChanged">
                            <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                            <EditItemStyle font-size="XX-Small"></EditItemStyle>
                            <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                            <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                            <ItemStyle font-size="XX-Small"></ItemStyle>
                            <ItemTemplate>
                                <table width="100%" border= "0">
                                    <tr>
                                        <td>
                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border= "1">
                                                <tr>
                                                    <td bgcolor="silver" width= "30%">
                                                        <span class="LabelNormal">Part No </span> 
                                                    </td>
                                                    <td width= "70%">
                                                        <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Part_No") %> </span> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">Description</span> 
                                                    </td>
                                                    <td>
                                                        <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Desc") %> </span> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">Specification</span> 
                                                    </td>
                                                    <td>
                                                        <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Part_Spec") %> </span> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">Remarks</span> 
                                                    </td>
                                                    <td>
                                                        <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Rem") %> </span> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">Supplier</span> 
                                                    </td>
                                                    <td>
                                                        <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Ven_Name") %> </span> 
                                                    </td>
                                                </tr>
                                            </table>
                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border= "1">
                                                <tr>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">ETA</span> 
                                                    </td>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">Req Qty</span> 
                                                    </td>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">Purc. Qty.</span> 
                                                    </td>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">Diff</span> 
                                                    </td>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">U/P</span> 
                                                    </td>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">Amt.</span> 
                                                    </td>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">MOQ</span> 
                                                    </td>
                                                    <td bgcolor="silver">
                                                        <span class="LabelNormal">SPQ</span> </span> 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label id="ETADate" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "eta_date") %>'></asp:Label> 
                                                    </td>
                                                    <td>
                                                        <asp:Label id="ReqQty" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Qty") %>'></asp:Label> 
                                                    </td>
                                                    <td>
                                                        <asp:Label id="QtyToBuy" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>'></asp:Label> 
                                                    </td>
                                                    <td>
                                                        <asp:Label id="Diff" cssclass="ListOutput" runat="server" ></asp:Label> 
                                                    </td>
                                                    <td>
                                                        <asp:Label id="UP" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>'></asp:Label> 
                                                    </td>
                                                    <td>
                                                        <asp:Label id="Amt" cssclass="ListOutput" runat="server" ></asp:Label> 
                                                    </td>
                                                    <td>
                                                        <asp:Label id="MinOrderQty" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Min_Order_Qty") %>'></asp:Label> 
                                                    </td>
                                                    <td>
                                                        <asp:Label id="StdPackQty" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "std_pack_qty") %>'></asp:Label> 
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <br />
                            </ItemTemplate>
                            <HeaderStyle font-size="XX-Small"></HeaderStyle>
                        </asp:DataList>
                    </p>
                    <p>
                        <table style="HEIGHT: 9px" width="100%">
                            <tbody>
                                <tr>
                                    <td>
                                        <asp:Label id="lblSRNo" runat="server" visible="False"></asp:Label></td>
                                    <td>
                                        <div align="right"><asp:Label id="lblAmount" runat="server" cssclass="Instruction" font-names="Aharoni"></asp:Label>
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
<p align="center">
</p>