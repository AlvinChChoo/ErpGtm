<%@ Page Language="VB" %>
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
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
    
        ReqCOM.ExecuteNonQuery("update part_master set Parts_Without_source = 'N'")
        ReqCOM.ExecuteNonQuery("update part_master set Parts_Without_source = 'Y' where SUPPLY_tYPE = 'BUY' and part_no not in (Select Part_No from Part_source)")
    
        'ReqCOM.ExecuteNonQuery("update part_master set Parts_Without_source = 'Y' where part_no not in (Select Part_No from Part_source)")
        Response.redirect("ReportViewer.aspx?RptName=PartsWithoutSources&ReturnURL=Default.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
        </p>
        <p>
        </p>
        <td>
        </td>
    </form>
</body>
</html>
