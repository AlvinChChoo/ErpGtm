<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.Data.SqlClient" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System.IO" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Dim LineIn as string
        Dim oFile as System.IO.File
        Dim oRead as System.IO.StreamReader
    
        oRead = oFile.OpenText(Mappath("") + “\ERPHelp\" & trim(Request.params("FileName")) & ".txt”)
    
        While oRead.Peek <> -1
            LineIn = LineIn & oRead.ReadLine()
        End While
        oRead.Close()
        lblHelp.text = LineIn
    End Sub
    
    Sub ShowSelection(s as object,e as DataListCommandEventArgs)
        ShowPopup(trim(e.commandArgument))
    end sub
    
    Sub ShowPopup(PageURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & PageURL & """,'','toolbar=1,scrollbars=1,location=0,statusbar=1,menubar=1,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    
    Sub DLStoreMembers_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub DLProductList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

</script>
<html>
<head>
    <script language="javascript" src="script.js" type="text/javascript"></script>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <td colspan="2" width="80%" valign="top">
        </td>
        <!-- Insert content here -->
        <p>
            <table class="sideboxnotop" bordercolor="gray" cellspacing="0" cellpadding="4" width="90%" align="center" border="0">
                <tbody>
                    <tr>
                        <td class="#FFD2FF" align="left">
                            <asp:Label id="lblHelp" runat="server"> </asp:Label> 
                            <div style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 3px; PADDING-TOP: 3px; TEXT-ALIGN: center" align="left">
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
