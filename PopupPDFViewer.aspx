<%@ Page Language="VB" %>
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
            ShowReport
        End Sub

        Sub ShowReport()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM

            select case ucase(request.params("RptName"))
                Case "FECN"
                ReqCOm.ExecuteNonQuery("Update FECN_M set ind = 'N'")
                ReqCOm.ExecuteNonQuery("Update FECN_M set ind = 'Y' where FECN_No = '" & clng(Request.params("FECNNo")) & "';")
                GenerateAttachment
                'Response.redirect("Report/FECN.pdf")
            Response.ContentType="application/PDF"
            Response.AppendHeader("Content-Disposition","attachment; filename=FECN.pdf")
            Response.WriteFile(Mappath("") + "\Report\FECN.pdf")
            Response.Flush()
            End select
        End sub

        sub ShowFile()
            'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            'lblFileName.text = ReqCOM.GetFieldVal("Select * from UPAS_Attachment where Seq_No = " & request.params("ID") & ";","File_Name")
            'Dim FileExt as string = "." & right(lblFileName.text,len(lblFileName.text) - (instr(lblFileName.text,".")))

            'Dim ContentType as string = right(lblFileName.text,len(lblFileName.text) - (instr(lblFileName.text,".")))
            'Dim FileName as string = lblFileName.text


            'response.redirect("Default.aspx")
        end sub

        Sub GenerateAttachment()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim RptnAME as string = Request.params("RptName")
            Dim repDoc As New ReportDocument()
            repDoc.Load(Mappath("") + "\Report\" & trim(RptName) & ".rpt")
            Dim subRepDoc As New ReportDocument()
            Dim myDBName as string = "erp_gtm"
            Dim myOwner as string = "dbo"
            Dim crSections As Sections
            Dim crSection As Section
            Dim crReportObjects As ReportObjects
            Dim crReportObject As ReportObject
            Dim crSubreportObject As SubreportObject
            Dim crDatabase As Database
            Dim crTables As Tables
            Dim crTable As CrystalDecisions.CrystalReports.Engine.Table
            Dim RptTitle as string
            Dim crLogOnInfo As TableLogOnInfo
            Dim crConnInfo As New ConnectionInfo()

            crDatabase = repDoc.Database
            crTables = crDatabase.Tables

            For Each crTable In crTables
                With crConnInfo
                    .ServerName = ConfigurationSettings.AppSettings("ServerName")
                    .DatabaseName = ConfigurationSettings.AppSettings("DatabaseName")
                    .UserID = ConfigurationSettings.AppSettings("UserID")
                    .Password = ConfigurationSettings.AppSettings("Password")
                End With
                crLogOnInfo = crTable.LogOnInfo
                crLogOnInfo.ConnectionInfo = crConnInfo
                crTable.ApplyLogOnInfo(crLogOnInfo)
            Next
            crTable.Location = myDBName & "." & myOwner & "." & crTable.Location.Substring(crTable.Location.LastIndexOf(".") + 1)
            crSections = repDoc.ReportDefinition.Sections

            For Each crSection In crSections
                crReportObjects = crSection.ReportObjects
                For Each crReportObject In crReportObjects
                    If crReportObject.Kind = ReportObjectKind.SubreportObject Then
                        crSubreportObject = CType(crReportObject, SubreportObject)
                        subRepDoc = crSubreportObject.OpenSubreport(crSubreportObject.SubreportName)
                        crDatabase = subRepDoc.Database
                        crTables = crDatabase.Tables
                            For Each crTable In crTables
                                With crConnInfo
                                    .ServerName = ConfigurationSettings.AppSettings("ServerName")
                                    .DatabaseName = ConfigurationSettings.AppSettings("DatabaseName")
                                    .UserID = ConfigurationSettings.AppSettings("UserID")
                                    .Password = ConfigurationSettings.AppSettings("Password")
                                End With

                                crLogOnInfo = crTable.LogOnInfo
                                crLogOnInfo.ConnectionInfo = crConnInfo
                                crTable.ApplyLogOnInfo(crLogOnInfo)
                            Next
                        crTable.Location = myDBName & "." & myOwner & "." & crTable.Location.Substring(crTable.Location.LastIndexOf(".") + 1)
                    End If
                Next
            Next

            Dim StrExportFile as string = Server.MapPath(".") & "\Report\" & trim(request.params("RptName")) & ".pdf"
            repDoc.ExportOptions.ExportDestinationType = ExportDestinationType.DiskFile
            repDoc.ExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat

            Dim objOptions as DiskFileDestinationOptions = New DiskFileDestinationOptions
            objOptions.DiskFilename = strExportFile
            repDoc.ExportOptions.DestinationOptions = objOptions
            repDoc.export()
            objoptions = nothing
            repDoc = nothing
        End sub

        Sub Button1_Click(sender As Object, e As EventArgs)
            Response.redirect("BOMRpt.aspx")
        End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" size="4"></font>
        </p>
    </form>
</body>
</html>
