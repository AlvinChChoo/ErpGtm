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
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim StrSql as string
                ReqCOM.ExecuteNonQuery("Update BOM_M set Ind = 'N'")
    
                'Dim rs as sqlDataReader = ReqCOM.ExeDataReader("Select Seq_No,max(Revision),Model_No from bom_m group by model_no,seq_No")
                'Do while rs.read
                '    ReqCOM.ExecuteNonQuery("Update BOM_M set Ind = 'Y' where Seq_No = " & rs("Seq_No") & ";")
                'loop
    
                ReqCOM.executeNonQuery("Truncate table MRP_PART_RPT")
                StrSql = "Insert into MRP_PART_RPT(Prod_Date,lot_no,model_no,part_no,p_level,p_usage,Order_Qty) "
                StrSql = StrSql & "select so.prod_date,so.lot_no,so.model_no,bom.part_no,bom.p_level,bom.p_usage,so.order_qty from so_model_m so, bom_d bom where so.lot_close = 'N' and bom.model_no = so.model_no order by part_no, lot_no asc"
    
    
                ReqCOM.ExecuteNonQuery(StrSql)
    
    
    
                Response.redirect("ReportViewer.aspx?RptName=MRP&ReturnURL=Default.aspx")
    
            End if
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
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" backcolor="" forecolor="">MATERIAL
                                REQUIREMENT PLANNING(MRP) REPORT</asp:Label>
                            </p>
                            <p>
                            </p>
                            <p>
                                <a href="javascript:OpenCalendar('txtPODate', true)"></a>
                                <br />
                                &nbsp; 
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
