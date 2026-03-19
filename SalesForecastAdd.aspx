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
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            lblLotNo.text = ReqCOM.GetDocumentNo("FORECAST_NO")
            FillYear()
            Dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust order by Cust_Code asc","Cust_Code","Desc",cmbCustCode)
            dissql ("Select MODEL_CODE,Model_Code + '|' + Model_Desc as [Desc] from Model_Master where Cust_Code = '" & trim(cmbCustCode.selectedItem.value) & "' order by MODEL_CODE asc","MODEL_CODE","Desc",cmbModelNo)
            dissql ("Select COLOR_DESC from Color order by COLOR_DESC asc","COLOR_DESC","COLOR_DESC",cmbColor)
            dissql ("Select PACK_DESC from Pack order by PACK_DESC asc","PACK_DESC","PACK_DESC",cmbPacking)
            lblForecastDate.text = format(now,"MM/dd/yy")
        end if
    End Sub
    
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
    
    SUb FillYear()
        Dim i as integer
        Dim CurrYear as integer = Year(now)
    
        cmbYear.items.clear
        For i = 0 to 5
            cmbYear.ITEMS.ADD(NEW LISTITEM(cint(CurrYear) + i))
        Next i
    End Sub
    
    Sub cmbAdd_Click(sender As Object, e As EventArgs)
        If page.isvalid = true then
            Dim DateTemp as datetime
            DateTemp = cmbMonth.selecteditem.value & "/1/" & cmbYear.selecteditem.text
    
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim strsql as string
            Dim CurrUP as decimal
            strsql = "insert into SO_FORECAST_M("
            strsql = strsql + "LOT_NO,FORECAST_MONTH,FORECAST_YEAR,CUST_CODE,"
            strsql = strsql + "MODEL_NO,ORDER_QTY,Invoice_UP,forecast_date,Color_Desc,Pack_Code,"
            strsql = strsql + "REM,DATE_TEMP,CREATE_BY,CREATE_DATE) select "
            strsql = strsql + "'" & trim(lblLotno.text) & "',"
            strsql = strsql + "'" & trim(cmbMonth.selecteditem.text) & "',"
            strsql = strsql + "'" & trim(cmbYear.selectedItem.text) & "',"
            strsql = strsql + "'" & trim(cmbCustCode.selecteditem.VALUE) & "',"
            strsql = strsql + "'" & trim(cmbModelno.selecteditem.VALUE) & "',"
            strsql = strsql + "" & trim(txtOrderQty.text) & ","
            strsql = strsql + "" & trim(txtInvoiceUP.text) & ","
            strsql = strsql + "'" & now & "',"
            strsql = strsql + "'" & cmbColor.selectedItem.value & "',"
            strsql = strsql + "'" & cmbPacking.selectedItem.value & "',"
            strsql = strsql + "'" & trim(txtRem.text) & "',"
            strsql = strsql + "'" & DateTemp & "',"
            strsql = strsql + "'" & trim(request.cookies("U_ID").value) & "',"
            strsql = strsql + "'" & NOW & "'"
            ReqCOM.ExecuteNonQuery(strsql)
            ReqCOM.ExecuteNonQuery("Update Main set ForeCast_No = Forecast_no + 1")
            response.redirect("SalesForecastDet.aspx?ID=" & ReqCOm.GetFieldVal("Select Seq_No from SO_Forecast_M where Lot_No = '" & trim(lblLotNo.text) & "';","Seq_No"))
        end if
    End Sub
    
    Sub cmbModelNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        txtInvoiceUP.text = format(cdec(ReqCOM.GetFieldVal("Select Inv_UP from Model_Master where Model_Code = '" & trim(cmbModelNo.selectedItem.value) & "'","Inv_UP")),"##,##0.00")
    End Sub
    
    Sub cmbCustCode_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        dissql ("Select MODEL_CODE,Model_Code + '|' + Model_Desc as [Desc] from Model_Master where Cust_Code = '" & trim(cmbCustCode.selectedItem.value) & "' order by MODEL_CODE asc","MODEL_CODE","Desc",cmbModelNo)
        txtInvoiceUP.text = format(cdec(ReqCOM.GetFieldVal("Select Inv_UP from Model_Master where Model_Code = '" & trim(cmbModelNo.selectedItem.value) & "'","Inv_UP")),"##,##0.00")
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("SalesForecast.aspx")
    End Sub
    
    Sub txtForecastDate_TextChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ValDuplicateForecast(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim DateTemp as Datetime
        DateTemp = cmbMonth.selecteditem.value & "/1/" & cmbYear.selecteditem.text
        if ReqCOM.FuncCheckDuplicate("Select Model_No from SO_FORECAST_M where Date_Temp = '" & DateTemp & "' and Model_No = '" & trim(cmbModelNo.selectedItem.value) & "';","Model_No") = true then
            e.isvalid = false
        else
            e.isvalid = true
        End if
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
            <table style="HEIGHT: 21px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label8" runat="server" width="100%" cssclass="FormDesc">NEW SALES FORECAST
                                REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="ValOrderQty" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid order quantity." ControlToValidate="txtOrderQty" Display="Dynamic" ForeColor=" " EnableClientScript="False"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:comparevalidator id="ValOrderQtyFormat" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid order quantity." ControlToValidate="txtOrderQty" Display="Dynamic" ForeColor=" " EnableClientScript="False" Type="Double" Operator="DataTypeCheck"></asp:comparevalidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid model no." ControlToValidate="cmbModelNo" Display="Dynamic" ForeColor=" " EnableClientScript="False"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:CustomValidator id="DuplicateForecast" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="Forecast already exist." Display="Dynamic" ForeColor=" " EnableClientScript="False" OnServerValidate="ValDuplicateForecast"></asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Customer." ControlToValidate="cmbCustCode" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Model No." ControlToValidate="cmbModelNo" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                </p>
                                                <table style="HEIGHT: 125px" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label2" runat="server" width="111px" cssclass="LabelNormal">Issued
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblForecastDate" runat="server" width="446px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label1" runat="server" width="111px" cssclass="LabelNormal">Forecast
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" width="446px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label9" runat="server" width="111px" cssclass="LabelNormal">Forecast
                                                                Month</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbMonth" runat="server" Width="187px" CssClass="OutputText">
                                                                    <asp:ListItem Value="1">January</asp:ListItem>
                                                                    <asp:ListItem Value="2">February</asp:ListItem>
                                                                    <asp:ListItem Value="3">March</asp:ListItem>
                                                                    <asp:ListItem Value="4">April</asp:ListItem>
                                                                    <asp:ListItem Value="5">May</asp:ListItem>
                                                                    <asp:ListItem Value="6">June</asp:ListItem>
                                                                    <asp:ListItem Value="7">July</asp:ListItem>
                                                                    <asp:ListItem Value="8">August</asp:ListItem>
                                                                    <asp:ListItem Value="9">September</asp:ListItem>
                                                                    <asp:ListItem Value="10">October</asp:ListItem>
                                                                    <asp:ListItem Value="11">November</asp:ListItem>
                                                                    <asp:ListItem Value="12">December</asp:ListItem>
                                                                </asp:DropDownList>
                                                                <asp:DropDownList id="cmbYear" runat="server" Width="187px" CssClass="OutputText"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label3" runat="server" width="111px" cssclass="LabelNormal">Cust. Code</asp:Label></td>
                                                            <td colspan="1">
                                                                <asp:DropDownList id="cmbCustCode" runat="server" Width="446px" CssClass="OutputText" OnSelectedIndexChanged="cmbCustCode_SelectedIndexChanged" autopostback="true"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label4" runat="server" width="111px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                            <td colspan="1">
                                                                <asp:DropDownList id="cmbModelNo" runat="server" Width="446px" CssClass="OutputText" OnSelectedIndexChanged="cmbModelNo_SelectedIndexChanged" AUTOPOSTBACK="TRUE"></asp:DropDownList>
                                                            </td>
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
                                                                <asp:Label id="Label5" runat="server" width="111px" cssclass="LabelNormal">Forecast
                                                                Qty</asp:Label> 
                                                            </td>
                                                            <td>
                                                                <asp:TextBox id="txtOrderQty" runat="server" Width="446px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label6" runat="server" width="111px" cssclass="LabelNormal">Unit Price</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtInvoiceUP" runat="server" Width="178px" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label7" runat="server" width="111px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtRem" runat="server" Width="446px" CssClass="OutputText" Height="67px" TextMode="MultiLine"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmbAdd" onclick="cmbAdd_Click" runat="server" Width="174px" Text="Save as new forecast"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="174px" Text="Cancel" CausesValidation="False"></asp:Button>
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
