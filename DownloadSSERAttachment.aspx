<%@ Page Language="VB" Debug="true" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        LoadProductDetails()
    End Sub
    
    sub LoadProductDetails()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        lblFileName.text = ReqCOM.GetFieldVal("Select * from SSER_Attachment where Seq_No = " & request.params("ID") & ";","File_Name")
        Dim FileExt as string = "." & right(lblFileName.text,len(lblFileName.text) - (instr(lblFileName.text,".")))
    
        Dim ContentType as string = right(lblFileName.text,len(lblFileName.text) - (instr(lblFileName.text,".")))
        Dim FileName as string = lblFileName.text
    
        Response.ContentType="application/" & trim(ContentType)
        Response.AppendHeader("Content-Disposition","attachment; filename=" & trim(FileName))
        Response.WriteFile(Mappath("") + "\SSERAttachment\" + trim(lblFileName.text))
        Response.Flush()
        response.redirect("Default.aspx")
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <table style="WIDTH: 424px; HEIGHT: 8px" cellspacing="0" cellpadding="0" width="424" align="center">
            <tbody>
                <tr>
                    <td>
                        <p>
                            <asp:Label id="lblFilePath" runat="server" cssclass="OutputText" width="97px" visible="False"></asp:Label><asp:Label id="lblFileName" runat="server" cssclass="OutputText" width="97px" visible="False"></asp:Label><asp:Label id="lblFileExt" runat="server" cssclass="OutputText" width="97px" visible="False"></asp:Label>
                        </p>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>