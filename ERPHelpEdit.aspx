<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ExportTechnologies" Namespace="ExportTechnologies.NetComponents.RichTextEditor" Assembly="RichTextEditor" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.Data.SqlClient" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System.IO" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then ReadFile()
    End Sub
    
    
    Sub cmdcancel_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            WriteFile
        End if
    
    End Sub
    
    Sub WriteFile()
        Dim oFile as System.IO.File
        Dim oWrite as System.IO.StreamWriter
    
    
        'oWrite = oFile.CreateText(Mappath("") + “\ERPHelp\" & trim(Request.params("FileName")) & ".txt”)
    
        oWrite = oFile.CreateText(Mappath("") + “\Temp.txt”)
        oWrite.WriteLine(RTEFAQ.text)
        oWrite.Close()
    End sub
    
    Sub ReadFile()
        Dim LineIn as string
        Dim oFile as System.IO.File
        Dim oRead as System.IO.StreamReader
    
        oRead = oFile.OpenText(Mappath("") + “\ERPHelp\" & trim(Request.params("FileName")) & ".txt”)
        While oRead.Peek <> -1
            LineIn = LineIn & oRead.ReadLine()
        End While
        oRead.Close()
        RTEFAQ.text = LineIn
    
    End sub

</script>
<html>
<head>
    <script language="javascript" src="script.js" type="text/javascript"></script>
    <link href="Mystique.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl1" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p>
                            </p>
                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td>
                                            <EXPORTTECHNOLOGIES:RICHTEXTEDITOR id="RTEFAQ" runat="server" height="600" width="100%" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <p>
                                <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Text="Update" Width="107px"></asp:Button>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
    <p>
    </p>
</body>
</html>
