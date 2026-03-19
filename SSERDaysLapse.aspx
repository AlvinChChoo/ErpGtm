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
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
            Dim DateFrom, DateTo as date
    
            DateFrom = cint(cmbmonthfrom.selecteditem.value) & "/" & cint(txtDayFrom.text) & "/" & cint(txtYearFrom.text)
            DateTo = cint(cmbmonthto.selecteditem.value) & "/" & cint(txtDayto.text) & "/" & cint(txtYearto.text)
    
            ReqCOM.ExecuteNonQuery("Update SSER_M set Days_Lapse = null")
            ReqCOM.ExecuteNonQuery("Update SSER_M set End_Date = null")
    
    
            StrSql = "Update SSER_M set Days_Lapse = DateDiff(day,Submit_Date, qa_hod_date),End_Date = qa_hod_date where qa_hod_date is not null and days_lapse is null"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update SSER_M set Days_Lapse = DateDiff(day,Submit_Date,qa_eng_date),End_Date = qa_eng_date where qa_eng_date is not null and days_lapse is null"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update SSER_M set Days_Lapse = DateDiff(day,Submit_Date,me_hod_date),End_Date = me_hod_date where me_hod_date is not null and days_lapse is null"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update SSER_M set Days_Lapse = DateDiff(day,Submit_Date,me_eng_date),End_Date = me_eng_date where me_eng_date is not null and days_lapse is null"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update sser_m set DAYS_LAPSE = NULL WHERE URGENT = 'Y' and days_lapse < 2"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update sser_m set DAYS_LAPSE = NULL WHERE URGENT = 'N' and days_lapse < 5"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update sser_m set days_lapse = 0 where days_lapse is null"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            ShowReport("PopupReportViewer.aspx?RptName=SSERDaysLapse&DateFrom=" & DateFrom & "&DateTo=" & DateTo)
            'Response.redirect("ReportViewer.aspx?RptName=SSERDaysLapse&ReturnURl=SSERDaysLapse.aspx")
        End if
    
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub ValDateFrom_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        e.isvalid = true
        Dim DateFrom as string
    
        DateFrom = cint(cmbmonthfrom.selecteditem.value) & "/" & cint(txtDayFrom.text) & "/" & cint(txtYearFrom.text)
        if isdate(DateFrom) = false then e.isvalid = false:Exit sub
    End Sub
    
    Sub ValDateTo_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        e.isvalid = true
        Dim DateTo as string
    
        DateTo = cint(cmbmonthTo.selecteditem.value) & "/" & cint(txtDayTo.text) & "/" & cint(txtYearTo.text)
        if isdate(DateTo) = false then e.isvalid = false:Exit sub
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" backcolor="" forecolor="">SSER
                                DAYS LAPSE REPORT</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="75%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 68px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center">
                                                                        <asp:CustomValidator id="ValDateFrom" runat="server" OnServerValidate="ValDateFrom_ServerValidate" EnableClientScript="true" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid date from." Width="100%" CssClass="ErrorText"></asp:CustomValidator>
                                                                        <asp:CustomValidator id="ValDateTo" runat="server" OnServerValidate="ValDateTo_ServerValidate" EnableClientScript="true" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid date to." Width="100%" CssClass="ErrorText"></asp:CustomValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid day from." Width="100%" CssClass="Errortext" ControlToValidate="txtDayFrom"></asp:RequiredFieldValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid year from." Width="100%" CssClass="Errortext" ControlToValidate="txtYearFrom"></asp:RequiredFieldValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid day to." Width="100%" CssClass="Errortext" ControlToValidate="txtDayTo"></asp:RequiredFieldValidator>
                                                                        <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid year to." Width="100%" CssClass="Errortext" ControlToValidate="txtYearTo"></asp:RequiredFieldValidator>
                                                                        <asp:CompareValidator id="CompareValidator1" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Date From." Width="100%" CssClass="ErrorText" ControlToValidate="txtDayFrom" Type="Integer" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                                        <asp:CompareValidator id="CompareValidator2" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Date From." Width="100%" CssClass="ErrorText" ControlToValidate="txtYearFrom" Type="Integer" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                                        <asp:CompareValidator id="CompareValidator3" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Date To." Width="100%" CssClass="ErrorText" ControlToValidate="txtYearTo" Type="Integer" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                                        <asp:CompareValidator id="CompareValidator4" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Date To." Width="100%" CssClass="ErrorText" ControlToValidate="txtDayTo" Type="Integer" Operator="GreaterThan" ValueToCompare="0"></asp:CompareValidator>
                                                                    </div>
                                                                    <div align="center">
                                                                        <table style="HEIGHT: 15px" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td>
                                                                                        <div align="center"><asp:Label id="LotNo" runat="server" cssclass="OutputText">Date
                                                                                            From</asp:Label>&nbsp; 
                                                                                            <asp:TextBox id="txtDayFrom" runat="server" Width="27px" CssClass="OutputText"></asp:TextBox>
                                                                                            <asp:DropDownList id="cmbmonthFrom" runat="server" CssClass="OutputText">
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
                                                                                            <asp:TextBox id="txtYearFrom" runat="server" Width="39px" CssClass="OutputText"></asp:TextBox>
                                                                                            &nbsp; <asp:Label id="Label1" runat="server" cssclass="OutputText">To</asp:Label>&nbsp; 
                                                                                            <asp:TextBox id="txtDayTo" runat="server" Width="27px" CssClass="OutputText"></asp:TextBox>
                                                                                            <asp:DropDownList id="cmbMonthTo" runat="server" CssClass="OutputText">
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
                                                                                            <asp:TextBox id="txtYearTo" runat="server" Width="39px" CssClass="OutputText"></asp:TextBox>
                                                                                        </div>
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
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="85px" Text="View Report"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="97px" Text="Back" CausesValidation="False"></asp:Button>
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
            </font>
        </p>
    </form>
</body>
</html>
