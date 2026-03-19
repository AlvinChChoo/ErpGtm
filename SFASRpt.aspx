<%@ Page Language="VB" Debug="true" %>
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
    
        End if
    End Sub
    
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
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdShowRpt_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ForecastDate1,ForecastDate2,ForecastDate3,ForecastDate4,ForecastDate5,ForecastDate6,ForecastDate7 as date
        Dim StrSql as string
        Dim i as integer
    
        if ReqCOM.FuncCheckDuplicate("Select SFAS_No from SFAS_M where sfas_no = '" & trim(txtSFASNo.text) & "';","SFAS_No") = false then
            ShowAlert("You don't seem to have supplied a valid SFAS #.")
            Exit sub
        end if
    
    
        ReqCOM.ExecutenonQuery("Truncate table SFAS_Report")
    
            Dim cnnExeDataReader As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            cnnExeDataReader.Open()
            StrSql = "Select distinct(Forecast_Date) as [ForecastDate] from SFAS_D where sfas_no = '" & trim(txtSFASNo.text) & "' order by ForecastDate asc;"
            Dim myCommand As SqlCommand = New SqlCommand(StrSql, cnnExeDataReader )
            Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
            i = 1
            do while result.read
                if i = 1 then ForecastDate1 = result("ForecastDate").tostring
                if i = 2 then ForecastDate2 = result("ForecastDate").tostring
                if i = 3 then ForecastDate3 = result("ForecastDate").tostring
                if i = 4 then ForecastDate4 = result("ForecastDate").tostring
                if i = 5 then ForecastDate5 = result("ForecastDate").tostring
                if i = 6 then ForecastDate6 = result("ForecastDate").tostring
                if i = 7 then ForecastDate7 = result("ForecastDate").tostring
                i = i + 1
            loop
            cnnExeDataReader.close
            cnnExeDataReader.dispose
            ReqCOm.ExecuteNonQuery("insert into sfas_report(Model_No,forecast_date1,forecast_date2,forecast_date3,forecast_date4,forecast_date5,forecast_date6,forecast_date7) select distinct(model_no),'" & cdate(ForecastDate1) & "','" & cdate(ForecastDate2) & "','" & cdate(ForecastDate3) & "','" & cdate(ForecastDate4) & "','" & cdate(ForecastDate5) & "','" & cdate(ForecastDate6) & "','" & cdate(ForecastDate7) & "' from sfas_d where sfas_no = '" & trim(txtSFASNo.text) & "'")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set SFAS_Report.Forecast_Qty1 = sfas_d.forecast_qty, SFAS_Report.forecast_up1 = sfas_d.up from sfas_report,sfas_d where sfas_report.forecast_date1 = '" & cdate(forecastdate1) & "' and sfas_d.sfas_no = '" & trim(txtSFASNo.text) & "' and sfas_report.model_no = sfas_d.model_no and sfas_report.forecast_date1 = sfas_d.forecast_date")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set SFAS_Report.Forecast_Qty2 = sfas_d.forecast_qty, SFAS_Report.forecast_up2 = sfas_d.up from sfas_report,sfas_d where sfas_report.forecast_date2 = '" & cdate(forecastdate2) & "' and sfas_d.sfas_no = '" & trim(txtSFASNo.text) & "' and sfas_report.model_no = sfas_d.model_no and sfas_report.forecast_date2 = sfas_d.forecast_date")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set SFAS_Report.Forecast_Qty3 = sfas_d.forecast_qty, SFAS_Report.forecast_up3 = sfas_d.up from sfas_report,sfas_d where sfas_report.forecast_date3 = '" & cdate(forecastdate3) & "' and sfas_d.sfas_no = '" & trim(txtSFASNo.text) & "' and sfas_report.model_no = sfas_d.model_no and sfas_report.forecast_date3 = sfas_d.forecast_date")
            ReqCOm.ExecuteNonQuery("Update SFAS_Report set SFAS_Report.Cust_Code = Model_Master.cust_code,SFAS_Report.UP = Model_Master.up from model_master,sfas_report where SFAS_Report.Model_No = Model_Master.Model_Code")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set sfas_report.CUrr_Code = cust.curr_code,sfas_report.cust_name = cust.cust_name from sfas_report,cust where sfas_report.cust_Code = cust.cust_code")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set Backlog_qty = 0, Actual_Qty1 = 0,actual_up1 = 0, Actual_Qty2 = 0,actual_up2 = 0, Actual_Qty3 = 0,actual_up3 = 0, Actual_Qty4 = 0,actual_up4 = 0, Actual_Qty5 = 0,actual_up5 = 0, Actual_Qty6 = 0,actual_up6 = 0, Actual_Qty7 = 0,actual_up7 = 0")
    
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set sfas_report.Actual_Qty1 = so_models_m.order_qty,sfas_report.actual_up1 = so_models_m.invoice_up from sfas_report,so_models_m where sfas_report.model_no = so_models_m.model_no and month(so_models_m.Req_Date) = month(sfas_report.Forecast_Date1) and year(so_models_m.Req_Date) = year(sfas_report.Forecast_Date1)")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set sfas_report.Actual_Qty2 = so_models_m.order_qty,sfas_report.actual_up2 = so_models_m.invoice_up from sfas_report,so_models_m where sfas_report.model_no = so_models_m.model_no and month(so_models_m.Req_Date) = month(sfas_report.Forecast_Date2) and year(so_models_m.Req_Date) = year(sfas_report.Forecast_Date2)")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set sfas_report.Actual_Qty3 = so_models_m.order_qty,sfas_report.actual_up3 = so_models_m.invoice_up from sfas_report,so_models_m where sfas_report.model_no = so_models_m.model_no and month(so_models_m.Req_Date) = month(sfas_report.Forecast_Date3) and year(so_models_m.Req_Date) = year(sfas_report.Forecast_Date3)")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set sfas_report.Actual_Qty4 = so_models_m.order_qty,sfas_report.actual_up4 = so_models_m.invoice_up from sfas_report,so_models_m where sfas_report.model_no = so_models_m.model_no and month(so_models_m.Req_Date) = month(sfas_report.Forecast_Date4) and year(so_models_m.Req_Date) = year(sfas_report.Forecast_Date4)")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set sfas_report.Actual_Qty5 = so_models_m.order_qty,sfas_report.actual_up5 = so_models_m.invoice_up from sfas_report,so_models_m where sfas_report.model_no = so_models_m.model_no and month(so_models_m.Req_Date) = month(sfas_report.Forecast_Date5) and year(so_models_m.Req_Date) = year(sfas_report.Forecast_Date5)")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set sfas_report.Actual_Qty6 = so_models_m.order_qty,sfas_report.actual_up6 = so_models_m.invoice_up from sfas_report,so_models_m where sfas_report.model_no = so_models_m.model_no and month(so_models_m.Req_Date) = month(sfas_report.Forecast_Date6) and year(so_models_m.Req_Date) = year(sfas_report.Forecast_Date6)")
            ReqCOM.ExecuteNonQuery("Update SFAS_Report set sfas_report.Actual_Qty7 = so_models_m.order_qty,sfas_report.actual_up7 = so_models_m.invoice_up from sfas_report,so_models_m where sfas_report.model_no = so_models_m.model_no and month(so_models_m.Req_Date) = month(sfas_report.Forecast_Date7) and year(so_models_m.Req_Date) = year(sfas_report.Forecast_Date7)")
    
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_qty1 = null where forecast_qty1 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_up1 = null where forecast_up1 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_qty1 = null where actual_qty1 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_up1 = null where actual_up1 = 0")
    
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_qty2 = null where forecast_qty2 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_up2 = null where forecast_up2 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_qty2 = null where actual_qty2 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_up2 = null where actual_up2 = 0")
    
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_qty3 = null where forecast_qty3 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_up3 = null where forecast_up3 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_qty3 = null where actual_qty3 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_up3 = null where actual_up3 = 0")
    
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_qty4 = null where forecast_qty4 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_up4 = null where forecast_up4 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_qty4 = null where actual_qty4 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_up4 = null where actual_up4 = 0")
    
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_qty5 = null where forecast_qty5 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_up5 = null where forecast_up5 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_qty5 = null where actual_qty5 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_up5 = null where actual_up5 = 0")
    
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_qty6 = null where forecast_qty6 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_up6 = null where forecast_up6 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_qty6 = null where actual_qty6 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_up6 = null where actual_up6 = 0")
    
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_qty7 = null where forecast_qty7 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set forecast_up7 = null where forecast_up7 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_qty7 = null where actual_qty7 = 0")
            ReqCOM.ExecuteNonQuery("update sfas_report set actual_up7 = null where actual_up7 = 0")
    
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_qty1 = 0 where forecast_qty1 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_up1 = 0 where forecast_up1 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_qty1 = 0 where actual_qty1 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_up1 = 0 where actual_up1 is null")
    
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_qty2 = 0 where forecast_qty2 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_up2 = 0 where forecast_up2 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_qty2 = 0 where actual_qty2 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_up2 = 0 where actual_up2 is null")
    
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_qty3 = 0 where forecast_qty3 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_up3 = 0 where forecast_up3 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_qty3 = 0 where actual_qty3 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_up3 = 0 where actual_up3 is null")
    
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_qty4 = 0 where forecast_qty4 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_up4 = 0 where forecast_up4 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_qty4 = 0 where actual_qty4 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_up4 = 0 where actual_up4 is null")
    
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_qty5 = 0 where forecast_qty5 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_up5 = 0 where forecast_up5 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_qty5 = 0 where actual_qty5 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_up5 = 0 where actual_up5 is null")
    
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_qty6 = 0 where forecast_qty6 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_up6 = 0 where forecast_up6 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_qty6 = 0 where actual_qty6 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_up6 = 0 where actual_up6 is null")
    
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_qty7 = 0 where forecast_qty7 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set forecast_up7 = 0 where forecast_up7 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_qty7 = 0 where actual_qty7 is null")
            ReqCOM.ExecuteNonQuery("Update sfas_report set actual_up7 = 0 where actual_up7 is null")
    
    
    
            ShowReport("PopupReportViewer.aspx?RptName=SFAS&Month1=" & cdate(ForecastDate1) & "&Month2=" & cdate(ForecastDate2) & "&Month3=" & cdate(ForecastDate3) & "&Month4=" & cdate(ForecastDate4) & "&Month5=" & cdate(ForecastDate5) & "&Month6=" & cdate(ForecastDate6) & "&Month7=" & cdate(ForecastDate7))
            redirectPage("SFASRpt.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" size="4"> 
            <table style="HEIGHT: 38px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="3">
                            <font color="red"><strong>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                            </strong></font></td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" backcolor="" forecolor="">SALES
                                FORECAST APPROVAL SHEET</asp:Label>
                            </p>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 70%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="70%" align="center" border="0">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center">
                                                                        <table style="HEIGHT: 31px" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server" width="100%">SFAS #</asp:Label></td>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:TextBox id="txtSFASNo" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                    <div align="center">
                                                                    </div>
                                                                    <div align="center">
                                                                    </div>
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdShowRpt" onclick="cmdShowRpt_Click" runat="server" Text="Show Report"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="97px" Text="Back"></asp:Button>
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
                            <p>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
            </font>
        </p>
    </form>
</body>
</html>
