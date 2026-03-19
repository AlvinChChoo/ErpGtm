<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
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
            dissql ("Select COLOR_DESC from Color order by COLOR_DESC asc","COLOR_DESC","COLOR_DESC",cmbColor)
            dissql ("Select PACK_DESC from Pack order by PACK_DESC asc","PACK_DESC","PACK_DESC",cmbPacking)
            loaddata()
            loadTrail()
        end if
    End Sub
    
    Sub loadTrail()
        Dim StrSql as string = "SELECT * FROM FORECAST_TRAIL WHERE ID = " & request.params("ID") & ";"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"FORECAST_TRAIL")
        dtgTrail.DataSource=resExePagedDataSet.Tables("FORECAST_TRAIL").DefaultView
        dtgTrail.DataBind()
    End sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = FValue
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub LoadData
        Dim CurrCustCode,CurrModelNo as string
        Dim CurrColor as string
        Dim CurrPacking as string
        Dim strSql as string = "SELECT * FROM SO_FORECAST_M WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqCOM as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqCOM.ExeDataReader(strSql)
        do while ResExeDataReader.read
            lblLotNo.text = ResExeDataReader("LOT_NO")
            txtOrderQty.text = ResExeDataReader("ORDER_QTY").tostring
            txtRem.text = ResExeDataReader("REM").tostring
            lblInvoiceUP.text = format(ResExeDataReader("INVOICE_UP"),"##,##0.00")
            lblInvoiceTotal.text = format(cdec(lblInvoiceUP.text) * cdec(txtOrderQty.text),"##,##0.00")
            lblForecastDate.text = format(ResExeDataReader("FORECAST_DATE"),"MM/dd/yyyy")
            lblCustCode.text =  trim(ResExeDataReader("cust_code").tostring)
            lblModelNo.text = trim(ResExeDataReader("Model_No").tostring)
            lblForecastDate.text = format(cdate(ResExeDataReader("Forecast_date")),"MM/dd/yyyy")
            lblCustName.text = ReqCOM.GetFieldVal("Select Cust_Name from CUst where Cust_Code = '" & trim(lblCustCOde.text) & "';","Cust_Name")
            lblMonth.text = trim(ResExeDataReader("Forecast_month").tostring) & ", " & trim(ResExeDataReader("Forecast_year").tostring)
    
            CurrColor = ResExeDataReader("Color_desc").tostring
            If not (cmbColor.Items.findByText(CurrColor.toString)) is nothing then cmbColor.Items.FindByText(CurrColor.ToString).Selected = True
    
            CurrPacking = ResExeDataReader("Pack_Code").tostring
            If not (cmbPacking.Items.findByText(CurrPacking.toString)) is nothing then cmbPacking.Items.FindByText(CurrPacking.ToString).Selected = True
    
        loop
        ResExeDataReader.close()
    End sub
    
    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.erp_gtm = new Erp_Gtm.Erp_Gtm
            Dim ActualQty as integer
            Dim strsql as string
    
            ActualQty = ReqCOM.getFieldVal("Select Order_Qty from so_forecast_m where seq_no = " & request.params("ID") & ";","Order_Qty")
            if cint(ActualQty) <> cint(txtOrderQty.text) then
                StrSql = "Insert into Forecast_Trail(ID,Order_Qty,Create_by,Create_Date) select " & request.params("ID") & "," & cint(ActualQty) & ",'" & request.cookies("U_ID").value & "','" & now & "';"
                ReqCOM.ExecuteNonQuery(strsql)
            End if
    
            StrSql = "Update SO_FORECAST_M set Order_Qty = " & txtOrderQty.text & ",Rem = '" & trim(txtRem.text) & "',Create_by = '" & trim(request.cookies("U_ID").value) & "',Create_Date='" & now & "' where LOT_NO = '" & trim(lblLotNo.text) & "';"
    
            ReqCOM.ExecuteNonQuery(strsql)
    
    
            response.redirect("SalesForecastDet.aspx?ID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub
    
    Sub lnkList_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderModel.aspx")
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("SalesForecast.aspx")
    End Sub
    
    Sub cmbModelNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        lblInvoiceUP.text = ReqCOM.GetFieldVal("Select Inv_UP from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "'","Inv_UP")
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p>
                                <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" forecolor="" backcolor="" width="100%" cssclass="FormDesc">SALES
                                FORECAST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" EnableClientScript="False" ErrorMessage="You don't seem to have supplied a valid order quantity." ControlToValidate="txtOrderQty" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:comparevalidator id="CompareValidator1" runat="server" EnableClientScript="False" ErrorMessage="You don't seem to have supplied a valid order quantity." ControlToValidate="txtOrderQty" Display="Dynamic" ForeColor=" " Width="100%" CssClass="ErrorText" Type="Double" Operator="DataTypeCheck"></asp:comparevalidator>
                                                </p>
                                                <table style="HEIGHT: 104px" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label12" runat="server" width="107px" cssclass="LabelNormal">Issue
                                                                Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblForeCastDate" runat="server" width="446px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label2" runat="server" width="107px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                            <td colspan="1">
                                                                <asp:Label id="lblLotNo" runat="server" width="446px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label10" runat="server" width="107px" cssclass="LabelNormal">Cust.
                                                                Code</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCustCode" runat="server" width="446px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label4" runat="server" width="107px" cssclass="LabelNormal">Cust. Name</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCustName" runat="server" width="446px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label5" runat="server" width="107px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" width="446px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label14" runat="server" width="104px" cssclass="LabelNormal">Product
                                                                Color </asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbColor" runat="server" Width="395px" CssClass="OutputText"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label15" runat="server" width="118px" cssclass="LabelNormal">Packing
                                                                Option</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbPacking" runat="server" Width="395px" CssClass="OutputText"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label6" runat="server" width="107px" cssclass="LabelNormal">Forecast
                                                                Month</asp:Label></td>
                                                            <td colspan="1">
                                                                <asp:Label id="lblMonth" runat="server" width="371px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label7" runat="server" width="107px" cssclass="LabelNormal">Unit Price</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblInvoiceUP" runat="server" width="446px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label11" runat="server" width="107px" cssclass="LabelNormal">Order
                                                                Qty</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtOrderQty" runat="server" Width="252px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label8" runat="server" width="107px" cssclass="LabelNormal">Invoice
                                                                Total</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblInvoiceTotal" runat="server" width="446px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label9" runat="server" width="107px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                            <td colspan="1">
                                                                <asp:TextBox id="txtRem" runat="server" Width="446px" CssClass="OutputText" TextMode="MultiLine" Height="86px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 15px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center"><asp:Label id="Label3" runat="server" width="100%">FORECAST CHANGES</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:DataGrid id="dtgTrail" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="Order_Qty" HeaderText="ORDER QTY"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Create_By" HeaderText="MODIFIED BY"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="Create_date" HeaderText="MODIFIED DATE"></asp:BoundColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="174px" Text="Update Changes"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="174px" Text="Back" CausesValidation="False"></asp:Button>
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
        <p>
        </p>
    </form>
</body>
</html>
