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

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            'If SortField = "" then SortField = "FECN_No"
            'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            'ReqCOM.ExecuteNonQuery("Update FECN_M set REGENERATE = 'N' where REGENERATE is null")
        end if
    End Sub
    
    Sub redirectPage(ReturnURL as string)
         Dim strScript as string
         strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
         If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim Mth1,Mth2,Mth3,Mth4,Mth5,Mth6,Mth7,Mth8,Mth9,Mth10,Mth11,Mth12 as long
        Dim YR1,YR2,YR3,YR4,YR5,YR6,YR7,YR8,YR9,YR10,YR11,YR12 as long
        Dim StartDate as datetime
        Dim EndDate as datetime
    
        StartDate = format(cdate(cmbmonth.selecteditem.value & "/01/" & txtYear.text),"MM/dd/yy")
    
        EndDate = StartDate.AddMonths(1): Mth1 = EndDate.Month : Yr1 = EndDate.Year
        EndDate = StartDate.AddMonths(2): Mth2 = EndDate.Month : Yr2 = EndDate.Year
        EndDate = StartDate.AddMonths(3): Mth3 = EndDate.Month : Yr3 = EndDate.Year
        EndDate = StartDate.AddMonths(4): Mth4 = EndDate.Month : Yr4 = EndDate.Year
        EndDate = StartDate.AddMonths(5): Mth5 = EndDate.Month : Yr5 = EndDate.Year
        EndDate = StartDate.AddMonths(6): Mth6 = EndDate.Month : Yr6 = EndDate.Year
        EndDate = StartDate.AddMonths(7): Mth7 = EndDate.Month : Yr7 = EndDate.Year
        EndDate = StartDate.AddMonths(8): Mth8 = EndDate.Month : Yr8 = EndDate.Year
        EndDate = StartDate.AddMonths(9): Mth9 = EndDate.Month : Yr9 = EndDate.Year
        EndDate = StartDate.AddMonths(10): Mth10 = EndDate.Month : Yr10 = EndDate.Year
        EndDate = StartDate.AddMonths(11): Mth11 = EndDate.Month : Yr11 = EndDate.Year
        EndDate = StartDate.AddMonths(12): Mth12 = EndDate.Month : Yr12 = EndDate.Year
    
        ReqCOM.ExecuteNonQuery("truncate table open_po_rpt")
        'ReqCOM.ExecuteNonQuery("insert into open_po_rpt(cust_code,lot_no,po_no,po_date,model_no,order_qty) select cust_code,lot_no,po_no,po_date,model_no,order_qty from so_models_m where po_date between '2005-09-01 00:00:00.000' and '2006-08-01 00:00:00.000' order by po_date asc")
        ReqCOM.ExecuteNonQuery("insert into open_po_rpt(cust_code,lot_no,po_no,po_date,model_no,order_qty) select cust_code,lot_no,po_no,po_date,model_no,order_qty from so_models_m where po_date between '" & cdate(StartDate) & "' and '" & cdate(EndDate) & "' order by po_date asc")
    
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth1_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr1) & " and month(so_models_delivery.del_date) = " & clng(Mth1) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth2_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr2) & " and month(so_models_delivery.del_date) = " & clng(Mth2) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth3_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr3) & " and month(so_models_delivery.del_date) = " & clng(Mth3) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth4_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr4) & " and month(so_models_delivery.del_date) = " & clng(Mth4) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth5_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr5) & " and month(so_models_delivery.del_date) = " & clng(Mth5) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth6_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr6) & " and month(so_models_delivery.del_date) = " & clng(Mth6) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth7_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr7) & " and month(so_models_delivery.del_date) = " & clng(Mth7) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth8_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr8) & " and month(so_models_delivery.del_date) = " & clng(Mth8) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth9_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr9) & " and month(so_models_delivery.del_date) = " & clng(Mth9) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth10_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr10) & " and month(so_models_delivery.del_date) = " & clng(Mth10) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth11_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr11) & " and month(so_models_delivery.del_date) = " & clng(Mth11) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.mth12_qty = so_models_delivery.del_qty from open_po_rpt,so_models_delivery where year(so_models_delivery.del_date) = " & clng(Yr12) & " and month(so_models_delivery.del_date) = " & clng(Mth12) & " and so_models_delivery.lot_no = open_po_rpt.lot_no")
    
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set open_po_rpt.Ori_UP = Model_Master.up from open_po_rpt,model_master where open_po_rpt.model_no = model_master.model_code")
        ReqCOM.ExecuteNonQuery("Update open_po_rpt set mth1_amt = mth1_qty * ori_up,mth2_amt = mth2_qty * ori_up,mth3_amt = mth3_qty * ori_up,mth4_amt = mth4_qty * ori_up,mth5_amt = mth5_qty * ori_up,mth6_amt = mth6_qty * ori_up,mth7_amt = mth7_qty * ori_up,mth8_amt = mth8_qty * ori_up,mth9_amt = mth9_qty * ori_up,mth10_amt = mth10_qty * ori_up,mth11_amt = mth11_qty * ori_up,mth12_amt = mth12_qty * ori_up")
        ShowReport("PopupReportViewer.aspx?RptName=OpenPO&StartDate=" & format(cdate(StartDate),"MM/dd/yy"))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" backcolor="" forecolor="">OPEN
                                P/O REPORT</asp:Label>
                            </p>
                            <p align="center">
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 80%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" border="1">
                                    <tbody>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal">First Delivery Month
                                                / Year</asp:Label></td>
                                            <td>
                                                <asp:DropDownList id="cmbMonth" runat="server" Width="143px" CssClass="OutputText">
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
                                                &nbsp;/ 
                                                <asp:TextBox id="txtYear" runat="server" CssClass="OutputText"></asp:TextBox>
                                                &nbsp;&nbsp; 
                                                <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" Width="83px" CssClass="OutputText" Text="GO"></asp:Button>
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
    <!-- Insert content here -->
</body>
</html>
