<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=9.1.5000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="CrystalDecisions.CrystalReports" %>
<%@ import Namespace="System.Data.OleDb" %>
<%@ import Namespace="System.Exception" %>
<%@ import Namespace="System.Drawing.Printing" %>
<%@ import Namespace="CrystalDecisions.ReportSource" %>
<%@ import Namespace="System.ComponentModel" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    
    End Sub
    
    
    
        Sub CrystalReportViewer1_Init(sender As Object, e As EventArgs)
        End Sub
    
        Sub Button1_Click(sender As Object, e As EventArgs)
            Response.redirect("BOMRpt.aspx")
        End Sub
    
    Sub Button1_Click_1(sender As Object, e As EventArgs)
            Dim strDbstring As String
            Dim strSQL As String
            Dim ErrMsg As String
            Dim Fname As String
            'Oledb
            Dim dbConnection As New OleDb.OleDbConnection
            Dim MyCommand As New OleDb.OleDbCommand
            Dim MyAdapter As OleDb.OleDbDataAdapter
            Dim MyDs As New DataSet
            'crystal report
            Dim crReportDocument As ReportDocument
            Dim crExportOptions As ExportOptions
            Dim crDiskFileDestinationOptions As DiskFileDestinationOptions
            'Initialize Public variables
            'strDbstring = Session("DbString")
            dbConnection = (New DbCon).GetConnection(strDbstring)
            crReportDocument = New ReportDocument
            crDiskFileDestinationOptions = New DiskFileDestinationOptions
            Dim folder As String = ConfigurationSettings.AppSettings("Reportname")
            Dim tempfolder As String = ConfigurationSettings.AppSettings("ReportFolder")
            'lblError.Text = ""
            'lblError.Visible = False
            CrystalReportViewer1.Visible = True
    
    
    
                crReportDocument.Load(Mappath("") + "\crosstab.rpt")
                strSQL = "BAX_ORDER_REPORT"
                'MyCommand.Connection = dbConnection
                'MyCommand.CommandType = CommandType.StoredProcedure
                'MyCommand.CommandText = strSQL
                'MyCommand.Parameters.Add("@START_DATE", OleDbType.VarChar, 20).Value = Request.QueryString("From_Date")
                'MyCommand.Parameters.Add("@END_DATE", OleDbType.VarChar, 20).Value = Request.QueryString("End_Date")
                'MyAdapter = New OleDb.OleDbDataAdapter
                'MyAdapter.SelectCommand = MyCommand
    
                'dbConnection.Open()
                'MyAdapter.Fill(MyDs)
                'crReportDocument.SetDataSource(MyDs.Tables(0))
                'repDoc.Load(Mappath("") + "\Report\" & trim(RptName) & ".rpt")
                Fname = Mappath("") + "\OrdersRpt.pdf"
                crDiskFileDestinationOptions.DiskFileName = Fname
                response.write (FName)
                crExportOptions = crReportDocument.ExportOptions
                With crExportOptions
                    .DestinationOptions = crDiskFileDestinationOptions
                    .ExportDestinationType = ExportDestinationType.DiskFile
                    .ExportFormatType = ExportFormatType.PortableDocFormat
                End With
                crReportDocument.Export()
                Response.ClearContent()
                Response.ClearHeaders()
                Response.ContentType = "application/pdf"
                Response.WriteFile(Fname)
                Response.Flush()
                Response.Close()
                System.IO.File.Delete(Fname)
                Response.End()
    
    
            If Trim(ErrMsg) <> "" Then
                'lblError.Visible = True
                'lblError.Text = Trim(ErrMsg)
                CrystalReportViewer1.Visible = False
            End If
    
            'If Not MyDs Is Nothing Then MyDs = Nothing
            'If Not MyCommand Is Nothing Then MyCommand = Nothing
            'If Not MyAdapter Is Nothing Then MyAdapter = Nothing
            'If Not dbConnection Is Nothing Then dbConnection = Nothing
    
            'If Not crDiskFileDestinationOptions Is Nothing Then crDiskFileDestinationOptions = Nothing
            'If Not crExportOptions Is Nothing Then crExportOptions = Nothing
            'If Not crReportDocument Is Nothing Then crReportDocument = Nothing
    
    End Sub

</script>
<html>
<head>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form method="post" runat="server">
        <p>
            <table style="HEIGHT: 38px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="3">
                            <p>
                                <CR:CRYSTALREPORTVIEWER id="CrystalReportViewer1" runat="server" pagetotreeratio="4" borderstyle="Dotted" borderwidth="1px" EnableDatabaseLogonPrompt="False" EnableParameterPrompt="False" OnInit="CrystalReportViewer1_Init" HasToggleGroupTreeButton="False" HasCrystalLogo="False" DisplayGroupTree="False" HasSearchButton="False" HasGotoPageButton="False" HasDrillUpButton="False"></CR:CRYSTALREPORTVIEWER>
                                <asp:Button id="Button1" onclick="Button1_Click_1" runat="server" Text="Button"></asp:Button>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
