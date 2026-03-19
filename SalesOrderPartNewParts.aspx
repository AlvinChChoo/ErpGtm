<%@ Page Language="VB" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then
            
        end if
    End Sub



         Sub cmbUpdate_Click(sender As Object, e As EventArgs)

         End Sub

         Sub txtRem_TextChanged(sender As Object, e As EventArgs)
         End Sub

         Sub TextBox6_TextChanged(sender As Object, e As EventArgs)
         End Sub

         Sub txtLotNo_TextChanged(sender As Object, e As EventArgs)
         End Sub

         Sub cmdMain_Click(sender As Object, e As EventArgs)
             response.redirect("Main.aspx")
         End Sub

         Sub cmdList_Click(sender As Object, e As EventArgs)
             response.redirect("SalesOrderModel.aspx")
         End Sub

    Sub cmbAdd_Click(sender As Object, e As EventArgs)
        Dim strsql as string

        strsql = "insert into SO_MODEL_M("
        strsql = strsql + "LOT_NO,PO_NO,PO_DATE,SO_DATE,CUST_CODE,BILL_ATT,"
        strsql = strsql + "BILL_ADD1,BILL_ADD2,BILL_ADD3,BILL_STATE,BILL_COUNTRY,"
        strsql = strsql + "SHIP_CO,SHIP_ATT,SHIP_ADD1,SHIP_ADD2,SHIP_ADD3,SHIP_STATE,"
        strsql = strsql + "SHIP_COUNTRY,ORDER_REV,PAY_TERM,LC_NO,LC_EXP,CONSIGNEE,"
        strsql = strsql + "NOTIFY_PARTY,MODEL_NO,PACK_CODE,COLOR_DESC,PROD_DATE,"
        strsql = strsql + "ORDER_QTY,PROD_QTY,SHIP_QTY,INVOICE_UP,CUSTOM_UP,"
        strsql = strsql + "ACC_UP,REM,APP_BY,APP_DATE,CREATED_BY,"
        strsql = strsql + "CREATED_DATE) select "
        strsql = strsql + "'" & trim(txtLotno.text) & "',"
        strsql = strsql + "'" & trim(txtPONo.text) & "',"
        strsql = strsql + "'" & trim(txtPODate.text) & "',"
        strsql = strsql + "'" & trim(txtSODate.text) & "',"
        strsql = strsql + "'" & trim(cmbCustCode.selecteditem.text) & "',"
        strsql = strsql + "'" & trim(txtBillAtt.text) & "',"
        strsql = strsql + "'" & trim(txtBillAdd1.text) & "',"
        strsql = strsql + "'" & trim(txtBillAdd2.text) & "',"
        strsql = strsql + "'" & trim(txtBillAdd3.text) & "',"
        strsql = strsql + "'" & trim(txtBillState.text) & "',"
        strsql = strsql + "'" & trim(txtBillCountry.text) & "',"
        strsql = strsql + "'" & trim(txtShipCo.text) & "',"
        strsql = strsql + "'" & trim(txtShipAtt.text) & "',"
        strsql = strsql + "'" & trim(txtShipAdd1.text) & "',"
        strsql = strsql + "'" & trim(txtShipAdd2.text) & "',"
        strsql = strsql + "'" & trim(txtShipAdd3.text) & "',"
        strsql = strsql + "'" & trim(txtShipState.text) & "',"
        strsql = strsql + "'" & trim(txtShipCountry.text) & "',"
        strsql = strsql + "'" & trim(txtOrderRev.text) & "',"
        strsql = strsql + "'" & trim(cmbPayTerm.selecteditem.text) & "',"
        strsql = strsql + "'" & trim(txtLCNo.text) & "',"
        strsql = strsql + "'" & trim(txtLCExp.text) & "',"
        strsql = strsql + "'" & trim(txtConsignee.text) & "',"
        strsql = strsql + "'" & trim(txtNotifyParty.text) & "',"
        strsql = strsql + "'" & trim(cmbModelno.selecteditem.text) & "',"
        strsql = strsql + "'" & trim(cmbpacking.selecteditem.text) & "',"
        strsql = strsql + "'" & trim(cmbColor.selecteditem.text) & "',"
        strsql = strsql + "'" & trim(txtProdDate.text) & "',"
        strsql = strsql + "" & trim(txtOrderQty.text) & ","
        strsql = strsql + "" & trim(txtProdQty.text) & ","
        strsql = strsql + "" & trim(txtShipQty.text) & ","
        strsql = strsql + "" & trim(txtInvoiceUP.text) & ","
        strsql = strsql + "" & trim(txtCustomUP.text) & ","
        strsql = strsql + "" & trim(txtAccUP.text) & ","
        strsql = strsql + "'" & trim(txtRem.text) & "',"
        strsql = strsql + "'" & trim(txtApprovedBy.text) & "',"
        strsql = strsql + "'" & trim(txtApprovedDate.text) & "',"
        strsql = strsql + "'" & trim(txtModifiedBy.text) & "',"
        strsql = strsql + "'" & trim(txtModifiedDate.text) & "'"


    label1.text = strsql


             'Dim ReqExecutenonQuery as Erp_Gtm.erp_gtm = new Erp_Gtm.Erp_Gtm
             'reqExecuteNonQuery.ExecuteNonQuery(strsql)

    End Sub

</script>
<html>
<head>
</head>
<body>
    <form runat="Server">
        <p>
        </p>
        <p>
            <asp:Label id="Label1" runat="server" width="413px">Label</asp:Label>
        </p>
        <p>
            <table style="WIDTH: 694px; HEIGHT: 106px" border="1">
                <tbody>
                    <tr>
                        <td>
                            <p align="center">
                                MODEL&nbsp;UNIT PRICE
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table style="WIDTH: 672px; HEIGHT: 75px">
                                <tbody>
                                    <tr>
                                        <td>
                                            Part No</td>
                                        <td colspan="3">
                                            <asp:DropDownList id="DropDownList1" runat="server" Width="307px" Font-Size="XX-Small"></asp:DropDownList>
                                        </td>
                                        <td>
                                            Quantity</td>
                                        <td>
                                            <asp:TextBox id="TextBox2" runat="server" Width="73px" Font-Size="XX-Small" Enabled="False"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Inv. U/P</td>
                                        <td>
                                            <asp:TextBox id="txtInvoiceUP" runat="server" Width="73px" Font-Size="XX-Small"></asp:TextBox>
                                        </td>
                                        <td>
                                            Qty</td>
                                        <td>
                                            <asp:TextBox id="txtQty1" runat="server" Width="73px" Font-Size="XX-Small" Enabled="False"></asp:TextBox>
                                        </td>
                                        <td>
                                            Inv. Total</td>
                                        <td>
                                            <asp:TextBox id="txtInvoiceTotal" runat="server" Width="73px" Font-Size="XX-Small" Enabled="False"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Custom U/P</td>
                                        <td>
                                            <asp:TextBox id="txtCustomUP" runat="server" Width="73px" Font-Size="XX-Small"></asp:TextBox>
                                        </td>
                                        <td>
                                            Qty&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </td>
                                        <td>
                                            <asp:TextBox id="txtQty2" runat="server" Width="73px" Font-Size="XX-Small" Enabled="False"></asp:TextBox>
                                        </td>
                                        <td>
                                            Custom Total</td>
                                        <td>
                                            <asp:TextBox id="txtCustomTotal" runat="server" Width="73px" Font-Size="XX-Small" Enabled="False"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            A/C U/P</td>
                                        <td>
                                            <asp:TextBox id="txtAccUP" runat="server" Width="73px" Font-Size="XX-Small"></asp:TextBox>
                                        </td>
                                        <td>
                                            Qty</td>
                                        <td>
                                            <asp:TextBox id="txtQty3" runat="server" Width="73px" Font-Size="XX-Small" Enabled="False"></asp:TextBox>
                                        </td>
                                        <td>
                                            A/C Total</td>
                                        <td>
                                            <asp:TextBox id="txtAccTotal" runat="server" Width="73px" Font-Size="XX-Small" Enabled="False"></asp:TextBox>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <p>
            <asp:Button id="cmbAdd" onclick="cmbAdd_Click" runat="server" Width="174px" Text="Add New Sales Order"></asp:Button>
            <asp:Button id="cmdList" onclick="cmdList_Click" runat="server" Text="Back to S/O list"></asp:Button>
            <asp:Button id="cmdMain" onclick="cmdMain_Click" runat="server" Text="Back to main"></asp:Button>
        </p>
        <p>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
