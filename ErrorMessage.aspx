<%@ Page Language="vb" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Configuration" %>
<script runat="server">

    Private Sub Page_Load(sender As Object, e As System.EventArgs)
        If Not Page.IsPostBack Then
            'Dim id As String = trim(Request.QueryString("ID"))
            'Dim ReqCom as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            'Dim strSql as string="Select Pic_Path from Model_Pic where Seq_No = " & request.params("ID") & ";"
            '    image1.imageurl = trim(ReqCom.GetFieldVal(strSQL,"Pic_Path"))
            lblError.text = trim(request.QueryString("ID"))
                CmdClose.Attributes.Add("onClick", "CloseWindow()")
        End If
    End Sub
    
    Sub CancelButton_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdClose_Click(sender As Object, e As EventArgs)
    End Sub

</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>View Thumbnail</title> 
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <link href="styles.css" type="text/css" rel="stylesheet" />
    <script language="javascript">
            function CloseWindow()
            {
                self.close();
            }
        </script>
</head>
<body bgcolor="#ffffff" leftmargin="5" topmargin="5">
    <form id="Calendar" method="post" runat="server">
        <table cellspacing="0" cellpadding="0" width="100%" border="0">
            <tbody>
            </tbody>
        </table>
        <div align="center">
            <table style="HEIGHT: 19px" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="lblError" runat="server" width="100%" font-size="X-Small"></asp:Label>
                            </p>
                            <p align="center">
                                &nbsp;
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center">
                                <asp:button id="CmdClose" onclick="cmdClose_Click" runat="server" Width="99px" Text="Close"></asp:button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>
