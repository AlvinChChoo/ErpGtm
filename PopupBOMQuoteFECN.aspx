<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="FECNDet" TagName="FECNDet" Src="_BOMQuoteFECN_.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Web.Mail" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    
    End Sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub
    
    Sub cmdImplement_Click(sender As Object, e As EventArgs)
    '    Dim strsql as string = "select * from fecn_d where fecn_no in (select fecn_no from fecn_m where model_no = '" & trim(Request.params("ModelNo")) & "' and fecn_status = 'PENDING APPROVAL')"
    
    '    Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
    '    myConnection.Open()
    '    Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
    '    Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
    '    do while drGetFieldVal.read
    
    '        if trim(drGetFieldVal("Main_Part_B4")) <> "-" then
    '            ReqCOM.ExecuteNonQUery("Update BOM_Quote_D where BOM_Quote_No = '" & trim() & "' and Part_No = '" &  & "';")
    '        end if
    '
    '        'drGetFieldVal("Main_Part_B4")
    '        'drGetFieldVal("P_Usage_B4")
    '
    '        'drGetFieldVal("Main_Part")
    '        'drGetFieldVal("P_Usage")
    
    '    loop
    
    '    drGetFieldVal.close()
    '    myCommand.dispose()
    '    myConnection.Close()
    '    myConnection.Dispose()
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 3px" cellspacing="0" cellpadding="0" width="80%">
                <tbody>
                    <tr>
                        <td>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <FECNDet:FECNDet id="FECNDet" runat="server"></FECNDet:FECNDet>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="50%">
                                                                    <asp:Button id="cmdImplement" onclick="cmdImplement_Click" runat="server" Text="Implement FECN Changes" Width="189px"></asp:Button>
                                                                </td>
                                                                <td width="50%">
                                                                    <p align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Text="Cancel" Width="158px"></asp:Button>
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
