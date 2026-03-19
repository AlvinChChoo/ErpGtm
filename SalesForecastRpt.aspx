<%@ Page Language="VB" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.isPostBack = false then
                Dissql ("Select distinct(CUst_Code) from SO_FORECAST_M order by Cust_Code asc","Cust_Code","Cust_Code",cmbSONo)
                ShowReport()
            End if
        End Sub

        Sub Button1_Click(sender As Object, e As EventArgs)
            UpdateForecastData()
            ShowReport()
        End Sub

        Sub UpdateForecastData()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            DIm StrSql as string
            Dim RsForecast as SQLDataReader
            Dim RsActual as SQLDataReader
            Dim ActualQty as decimal
            Dim ActualUP as decimal
            Dim ActualSls as decimal
            Dim ForecastMonth as integer

            ReqCOM.executeNonQuery("Delete from so_forecast_temp")
            StrSql = "Insert into SO_FORECAST_TEMP(CUST_CODE,FORECAST_DATE,MODEL_NO,Forecast,FORECAST_MONTH,FORECAST_YEAR,DATE_TEMP,TITLE2,ROW_TYPE) "
            StrSql = StrSql + "Select CUST_CODE,FORECAST_DATE,MODEL_NO,Order_Qty,FORECAST_MONTH,FORECAST_YEAR,DATE_TEMP,'QTY','Q' from SO_FORECAST_M"
            ReqCOM.executeNonQuery(StrSql)
            StrSql = "Insert into SO_FORECAST_TEMP(CUST_CODE,FORECAST_DATE,MODEL_NO,COLOR_DESC,PACK_CODE,Forecast,INVOICE_UP,REM,FORECAST_MONTH,FORECAST_YEAR,DATE_TEMP,TITLE2,ROW_TYPE) "
            StrSql = StrSql + "Select CUST_CODE,FORECAST_DATE,MODEL_NO,COLOR_DESC,PACK_CODE,ORDER_QTY*INVOICE_UP,INVOICE_UP,REM,FORECAST_MONTH,FORECAST_YEAR,DATE_TEMP,'AMT','A' from SO_FORECAST_M"
            ReqCOM.executeNonQuery(StrSql)
            RsForecast = ReqCOM.ExeDataReader("Select * from SO_FORECAST_TEMP order by seq_no asc")
            do while rsForecast.read
                if trim(rsForecast("Row_Type")) = "Q" then
                    ForecastMonth = month(rsForecast("Date_Temp"))
                    if ReqCOM.FuncCheckDuplicate("SELECT order_qty FROM SO_MODEL_M WHERE MODEL_NO = '" & rsForecast("Model_No") & "' and month(So_Date) = " & cint(ForecastMonth) & "  ;","order_qty") = true then
                        ActualQty = ReqCOM.GetFieldVal("SELECT SUM(order_qty) as Actual_qty FROM SO_MODEL_M WHERE MODEL_NO = '" & rsForecast("Model_No") & "' and month(So_Date) = " & cint(ForecastMonth) & "  ;","Actual_Qty")
                    else
                        ActualQty = 0
                    End if
                    ReqCOM.ExecuteNonQuery("Update SO_FORECAST_TEMP set Actual = " & ActualQty & " where seq_no = " & rsForecast("Seq_No") & ";")
                elseif trim(rsForecast("Row_Type")) = "A" then
                    ForecastMonth = month(rsForecast("Date_Temp"))
                    if ReqCOM.FuncCheckDuplicate("SELECT order_qty FROM SO_MODEL_M WHERE MODEL_NO = '" & rsForecast("Model_No") & "' and month(So_Date) = " & cint(ForecastMonth) & "  ;","order_qty") = true then

                        ActualQty = ReqCOM.GetFieldVal("SELECT Order_Qty FROM SO_MODEL_M WHERE MODEL_NO = '" & rsForecast("Model_No") & "' and month(So_Date) = " & cint(ForecastMonth) & "  ;","Order_Qty")
                        ActualUP = ReqCOM.GetFieldVal("SELECT Invoice_UP FROM SO_MODEL_M WHERE MODEL_NO = '" & rsForecast("Model_No") & "' and month(So_Date) = " & cint(ForecastMonth) & "  ;","Invoice_Up")
                        ActualSls = ActualQty*ActualUP
                    else
                        ActualSls = 0
                    End if
                    ReqCOM.ExecuteNonQuery("Update SO_FORECAST_TEMP set Actual = " & ActualSls & " where seq_no = " & rsForecast("Seq_No") & ";")
                End if
            Loop
            RsForecast.close
            ReqCOM.ExecuteNonQuery("Update SO_FORECAST_TEMP set variance = Forecast - actual")
            ReqCOM.ExecuteNonQuery("Update SO_FORECAST_TEMP set TITLE1 = FORECAST_MONTH + ',' + cast(FORECAST_YEAR as char(20))")
        End sub

        Sub ShowReport()
            Dim logOnInfo As New TableLogOnInfo()
            Dim i As Integer
            Dim Report as New ReportDocument()

            Report.Load(Mappath("") + "\" + "SalesForecast.rpt")
            For i = 0 To report.Database.Tables.Count - 1
                logOnInfo.ConnectionInfo.ServerName = "ws-alvin"
                logOnInfo.ConnectionInfo.DatabaseName = "DTF"
                logOnInfo.ConnectionInfo.UserID = "alvin"
                logOnInfo.ConnectionInfo.Password = "791205"
                report.Database.Tables.Item(i).ApplyLogOnInfo(logOnInfo)
            Next i
            CrystalReportViewer1.SelectionFormula = "{SO_FORECAST_TEMP.CUST_CODE} = '" & trim(cmbSONo.selectedItem.value) & "';"
            CrystalReportViewer1.ReportSource = Report
            CrystalReportViewer1.RefreshReport()
        End sub

         SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)

            with obj
                .items.clear
                .DataSource = ResExeDataReader
                .DataValueField = trim(FValue)
                .DataTextField = trim(FText)
                .DataBind()
             end with
             ResExeDataReader.close()
        End Sub

    Sub CrystalReportViewer1_Init(sender As Object, e As EventArgs)
    End Sub

</script>
<html>
<head>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form method="post" runat="server">
        <font face="Verdana" size="4">
        <table style="HEIGHT: 21px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;<asp:Label id="label" runat="server" width="150px" cssclass="LabelNormal">Customer
                        Code</asp:Label>&nbsp;
                        <asp:DropDownList id="cmbSONo" runat="server" Width="307px"></asp:DropDownList>
                        &nbsp;&nbsp;&nbsp;
                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="110px" Text="GO"></asp:Button>
                    </td>
                </tr>
                <tr>
                    <td>
                        <center>
                            <CR:CrystalReportViewer id="CrystalReportViewer1" runat="server" width="100%" height="50px" pagetotreeratio="4" borderstyle="Dotted" borderwidth="1px" EnableDatabaseLogonPrompt="False" EnableParameterPrompt="False" OnInit="CrystalReportViewer1_Init" HasToggleGroupTreeButton="False" HasCrystalLogo="False" DisplayGroupTree="False"></CR:CrystalReportViewer>
                        </center>
                    </td>
                </tr>
            </tbody>
        </table>
        </font>
    </form>
</body>
</html>
