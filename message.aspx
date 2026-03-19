<%@ Page Language="VB" Debug="true" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    
       'MsgBox "Hello, World!"
    
        'if request.cookies("U_ID") is nothing then
        '    response.redirect("AccessDenied.aspx")
        'else
        '    lblUser.text = "Current User : " + request.cookies("U_ID").value
        '    Dim OurCommand as sqlcommand
        '    Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        '    procLoadGridData ("SELECT * FROM PAYTERM")
        '    lblMaxRec.text = cint(ReqGetFieldVal.GetFieldVal("Select Grid_Max_Rec from Main","Grid_Max_Rec"))
        'end if
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
    msgbox "df"
    'var rtn=clickme()
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="VBScript">
<!--

    Sub cmdClickMe_OnClick()
        MsgBox "Hello, World!"
    End Sub

-->

</script>
    </HEAD>
<BODY>
<FORM runat="server">
<P><INPUT type=button value="Click Me!" name=cmdClickMe> </P>
<P></P>&nbsp; 
<P>&nbsp;&nbsp;&nbsp;&nbsp; <asp:Button id=Button1 onclick=Button1_Click runat="server" Text="Button"></asp:Button></P></FORM></BODY></HTML>
