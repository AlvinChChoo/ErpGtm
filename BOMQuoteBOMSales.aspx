<%@ Page Language="VB" Debug="true" %>
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
        Dim DefUOM as string = "PCE"
        if page.ispostback = false then
        end if
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim DateFrom, DateTo as date
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            DateFrom = ReqCOM.FormatDate(trim(txtDateFrom.text))
            DateTo = ReqCOM.FormatDate(trim(txtDateTo.text))
            ReqCOM.ExecuteNonQUery("Update BOM_Quote_M set ind = 'N'")
            ReqCOM.ExecuteNonQUery("Update BOM_Quote_M set ind = 'Y' where " & trim(cmbSearch.selecteditem.value) & " like '%" & trim(txtSearch.text) & "%' and App3_Date >= '" & cdate(DateFrom) & "' and App3_Date <= '" & cdate(DateTo) & "';")
    
            ReqCOM.ExecuteNonQUery("update bom_quote_curr set total_ori_up = 0,total_ori_amt = 0")
            ReqCOM.ExecuteNonQUery("truncate table bom_quote_bom_over_sales_pctg")
            ReqCOM.ExecuteNonQUery("insert into bom_quote_bom_over_sales_pctg(ori_up,up,bom_quote_no,curr_code) Select sum(bd.std_ori_up*bd.p_usage),sum(bd.std_up*bd.p_usage),bd.bom_quote_no,bd.std_curr_code from bom_quote_curr BC,BOM_Quote_D BD,BOM_QUOTE_M BM where BM.IND = 'Y' AND BM.BOM_QUOTE_NO = BD.BOM_QUOTE_NO and bc.bom_quote_no = bd.bom_quote_no and BC.curr_code = bd.std_curr_code and bd.main = 'MAIN' group by bd.bom_quote_no,bd.std_curr_code order by bd.bom_quote_no asc")
            ReqCOM.ExecuteNonQUery("update bom_quote_curr set bom_quote_curr.total_ori_up = bom_quote_bom_over_sales_pctg.Ori_UP,bom_quote_curr.total_ori_amt = bom_quote_bom_over_sales_pctg.UP from bom_quote_bom_over_sales_pctg,bom_quote_curr where bom_quote_bom_over_sales_pctg.bom_quote_no = bom_quote_curr.bom_quote_no and bom_quote_bom_over_sales_pctg.curr_code = bom_quote_curr.curr_code")
    
            ReqCOM.UpdateTotalTargetCost
    
            ShowReport ("PopupReportViewer.aspx?RptName=BOMQuoteBOMOverSalesPercentage")
        End if
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=700,height=150erious');")
    
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub ValDateInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim DateFrom,DateTo as string
    
        DateFrom = ReqCOM.FormatDate(txtDateFrom.text)
        DateTo = ReqCOM.FormatDate(txtDateTo.text)
        e.isvalid = true
    
        if isdate(DateFrom) = false then e.isvalid = false:exit sub
        if isdate(DateTo) = false then e.isvalid = false:exit sub
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" forecolor="" width="100%">BOM/SALES
                                % QUOTED REPORT</asp:Label>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="ValDateInput" runat="server" Width="100%" CssClass="ErrorText" EnableClientScript="False" OnServerValidate="ValDateInput_ServerValidate" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Date Range"></asp:CustomValidator>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <table style="HEIGHT: 13px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" cssclass="OutputText">Search for</asp:Label>&nbsp;<asp:TextBox id="txtSearch" runat="server" Width="106px" CssClass="OutputText"></asp:TextBox>
                                                                    &nbsp;<asp:Label id="Label3" runat="server" cssclass="OutputText">by</asp:Label> 
                                                                    <asp:DropDownList id="cmbSearch" runat="server" Width="126px" CssClass="OutputText">
                                                                        <asp:ListItem Value="Cust_Name">Customer Name</asp:ListItem>
                                                                        <asp:ListItem Value="Model_No">Model No</asp:ListItem>
                                                                        <asp:ListItem Value="Model_Desc">Model Description</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    &nbsp;<asp:Label id="Label4" runat="server" cssclass="OutputText">Date from</asp:Label> 
                                                                    <asp:TextBox id="txtDateFrom" runat="server" Width="77px" CssClass="OutputText"></asp:TextBox>
                                                                    &nbsp;<asp:Label id="Label5" runat="server" cssclass="OutputText">to</asp:Label> 
                                                                    <asp:TextBox id="txtDateTo" runat="server" Width="77px" CssClass="OutputText"></asp:TextBox>
                                                                    &nbsp;<asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Width="48px" CssClass="OutputText" Text="GO"></asp:Button>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <div align="left"><asp:Label id="Label6" runat="server" cssclass="ErrorText">* Date
                                                    Format : "dd/mm/yy"</asp:Label>
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
    </form>
</body>
</html>
