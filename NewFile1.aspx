<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="FECNAttachment" TagName="FECNAttachment" Src="_FECNAttachment_.ascx" %>
<%@ Register TagPrefix="FECNDet" TagName="FECNDet" Src="_FECNDet_.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Page.IsPostBack = false Then CloseIE
    End Sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body background="cp.gif" onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server" background-color:="#ff3c87" >
        <p>
        </p>
        <p>
        </p>
        <p>
            &nbsp;<asp:Button id="Button1" onclick="Button1_Click" runat="server" Text="Button"></asp:Button>
        </p>
    </form>
</body>
</html>
