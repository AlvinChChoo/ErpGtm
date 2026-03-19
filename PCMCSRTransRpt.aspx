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
            Dissql ("Select Distinct(Submit_By) as [Buyer] from SSER_M","Buyer","Buyer",cmbBuyer)
            Dim oList As ListItemCollection = cmbBuyer.Items
            oList.Add(New ListItem("ALL"))
            cmbBuyer.Items.FindByText("ALL").Selected = True
        end if
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim DateFrom,DateTo as date
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
    
            DateFrom = cint(cmbMonthfrom.selecteditem.value) & "/" & cint(txtDayFrom.text) & "/" & cint(txtYearFrom.text)
            DateTo = cint(cmbMonthTo.selecteditem.value) & "/" & cint(txtDayTo.text) & "/" & cint(txtYearTo.text)
    
            ReqCOM.ExecuteNonQuery ("Update SSER_M set reject_rem = null")
            ReqCOM.ExecuteNonQuery ("Update SSER_M set reject_rem = ME_ENG_REM where ME_ENG_Stat = 2 and sser_date >= '" & dateFrom & "' and sser_date <= '" & DateTo & "' and submit_by = '" & trim(cmbBuyer.selecteditem.value) & "';")
            ReqCOM.ExecuteNonQuery ("Update SSER_M set reject_rem = ME_HOD_REM where ME_HOD_Stat = 'N' and sser_date >= '" & dateFrom & "' and sser_date <= '" & DateTo & "' and submit_by = '" & trim(cmbBuyer.selecteditem.value) & "';")
            ReqCOM.ExecuteNonQuery ("Update SSER_M set reject_rem = QA_ENG_REM where QA_ENG_REM = 'N' and sser_date >= '" & dateFrom & "' and sser_date <= '" & DateTo & "' and submit_by = '" & trim(cmbBuyer.selecteditem.value) & "';")
            ReqCOM.ExecuteNonQuery ("Update SSER_M set reject_rem = QA_HOD_REM where QA_HOD_REM = 'N' and sser_date >= '" & dateFrom & "' and sser_date <= '" & DateTo & "' and submit_by = '" & trim(cmbBuyer.selecteditem.value) & "';")
            ShowReport("PopupReportViewer.aspx?RptName=SSERTransDetRpt&Buyer=" & cmbBuyer.selecteditem.value & "&StartDate=" & DateFrom & "&EndDate=" & DateTo)
        End if
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
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
    
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub Validator_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        e.isvalid  = true
    
        Dim DateFrom,DateTo as String
    
        DateFrom = cint(cmbMonthfrom.selecteditem.value) & "/" & cint(txtDayFrom.text) & "/" & cint(txtYearFrom.text)
        DateTo = cint(cmbMonthTo.selecteditem.value) & "/" & cint(txtDayTo.text) & "/" & cint(txtYearTo.text)
    
        if isdate(DateFrom) = false then e.isvalid = false:Validator.text = "You don't seem to have supplied a valid date from":exit sub
        if isdate(DateTo) = false then e.isvalid = false:Validator.text = "You don't seem to have supplied a valid date to":Exit sub
    
    
    
            'ReqCOM.ExecuteNonQuery ("Update SSER_M set reject_rem = null")
            'ReqCOM.ExecuteNonQuery ("Update SSER_M set reject_rem = ME_ENG_REM where ME_ENG_Stat = 2 and sser_date >= '" & dateFrom & "' and sser_date <= '" & DateTo & "' and submit_by = '" & trim(cmbBuyer.selecteditem.value) & "';")
            'ReqCOM.ExecuteNonQuery ("Update SSER_M set reject_rem = ME_HOD_REM where ME_HOD_Stat = 'N' and sser_date >= '" & dateFrom & "' and sser_date <= '" & DateTo & "' and submit_by = '" & trim(cmbBuyer.selecteditem.value) & "';")
            'ReqCOM.ExecuteNonQuery ("Update SSER_M set reject_rem = QA_ENG_REM where QA_ENG_REM = 'N' and sser_date >= '" & dateFrom & "' and sser_date <= '" & DateTo & "' and submit_by = '" & trim(cmbBuyer.selecteditem.value) & "';")
            'ReqCOM.ExecuteNonQuery ("Update SSER_M set reject_rem = QA_HOD_REM where QA_HOD_REM = 'N' and sser_date >= '" & dateFrom & "' and sser_date <= '" & DateTo & "' and submit_by = '" & trim(cmbBuyer.selecteditem.value) & "';")
            'ShowReport("PopupReportViewer.aspx?RptName=SSERTransDetRpt&Buyer=" & cmbBuyer.selecteditem.value & "&StartDate=" & DateFrom & "&EndDate=" & DateTo)
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                <asp:Label id="Label2" runat="server" forecolor="" backcolor="" width="100%" cssclass="FormDesc">PCMC
                                SR TRANSACTION REPORT</asp:Label> 
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="Validator" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="" Display="Dynamic" ForeColor=" " EnableClientScript="False" OnServerValidate="Validator_ServerValidate"></asp:CustomValidator>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="60%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 68px" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center">
                                                                        <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Issued By</asp:Label></td>
                                                                                    <td width="75%">
                                                                                        <asp:DropDownList id="cmbBuyer" runat="server" Width="100%" CssClass="OutputText"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Date From</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtDayFrom" runat="server" Width="27px" CssClass="OutputText"></asp:TextBox>
                                                                                        <asp:DropDownList id="cmbMonthFrom" runat="server" CssClass="OutputText">
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
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Date To</asp:Label></td>
                                                                                    <td>
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
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td>
                                                                                    </td>
                                                                                    <td>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
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
                        </td>
                    </tr>
                </tbody>
            </table>
            </font>
        </p>
    </form>
</body>
</html>
