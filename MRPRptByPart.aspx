<%@ Page Language="VB" Debug="true" %>
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
            Dim RptName as string = trim(Request.params("RptName").tostring)
            Dim PartNo as string = trim(Request.params("PartNo").tostring)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            ReqCOM.ExecuteNonQuery("Update PO_D set BAL_TO_SHIP = Order_Qty - In_Qty where Part_No = '" & trim(PartNo) & "';")
            ReqCOM.ExecuteNonQuery("Delete from MRP_RPT")
    
    
    
    
            UpdateSOModel(PartNo)
            UpdateSOPart(PartNo)
    
             'Update Issuing Qty.
            UpdateProjectedBalQty()
    
    
    
            ShowReport(RptName,PartNo)
        End Sub
    
        Sub ShowReport(RptName,PartNo)
            Dim repDoc As New ReportDocument()
            repDoc.Load(Mappath("") + "\" & trim(RptName) & ".rpt")
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
            CrystalReportViewer1.SelectionFormula = "{Part_Master.Part_No} = '" & trim(PartNo) & "';"
            CrystalReportViewer1.ReportSource = repDoc
            CrystalReportViewer1.RefreshReport()
        End sub
    
    
    Sub CrystalReportViewer1_Init(sender As Object, e As EventArgs)
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        Response.redirect("BOMRpt.aspx")
    End Sub
    
    Sub UpdateSOModel(PartNo)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql,ModelNo, LotNo as string
        Dim OrderQty,Revision as decimal
        Dim FODDate as date
    
    
        Dim rsModel as SQLDataReader = ReqCOM.ExeDataReader("Select * from SO_Model_M where Lot_Close = 'N' order by prod_date asc")
    
        Do while rsModel.read
            ModelNo = rsModel("Model_No").toString()
            Revision = rsModel("BOM_Rev").tostring()
            LotNo = rsModel("Lot_No").tostring()
            FODDate = rsModel("Prod_Date")
            OrderQty = rsModel("Order_Qty")
            StrSql = "Insert into MRP_RPT(SO_TYPE,LOT_NO,MODEL_NO,FOD_DATE,ORDER_QTY,P_Usage,PART_NO) "
            StrSql = StrSql & "select 'MODEL','" & trim(LotNo) & "','" & TRIM(ModelNo) & "','" & FODDate & "'," & OrderQty & ",P_Usage,'" & TRIM(PartNo) & "' from BOM_D where Model_No = '" & trim(ModelNo) & "' and Revision = " & Revision & " and Part_No = '" & trim(PartNo) & "';"
            ReqCOM.executeNonQuery(StrSql)
        Loop
    
        rsModel.close()
    
    End sub
    
    Sub UpdateSOPart(PartNo)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
    
        StrSql = "Insert into MRP_RPT(SO_TYPE,LOT_NO,MODEL_NO,FOD_DATE,ORDER_QTY,P_Usage,PART_NO)"
        StrsQL = StrSql + " select 'PART',LOT_NO,'',getdate(),part_qty,1,part_No from so_part_d where part_no = '" & trim(PartNo) & "' and lot_no in (select lot_no from so_part_m where lot_close = 'N')"
        ReqCOM.ExecuteNonQuery(StrSql)
    
        StrSql = "update mrp_rpt set mrp_rpt.fod_date = so.req_date from so_part_m so, Mrp_Rpt where so.lot_no = mrp_rpt.lot_no and mrp_rpt.so_type = 'PART'"
        ReqCOM.ExecuteNonQuery(StrSql)
    End sub
    
    Sub UpdateProjectedBalQty()
        Dim ReqCOM as COM.COM = new COM.COM
    
        ReqCOM.ExecuteNonQuery("Update MRP_RPT set Req_Qty = Order_Qty * P_Usage")
    
        Dim PartBal as decimal select
    
    
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" size="4"> 
            <table style="HEIGHT: 38px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="3">
                            <a class="ErrorText" href="javascript: history.go(-1)"><font color="red"><strong>&lt;&lt;
                            Back &gt;&gt;</strong></font></a><font color="red"><strong> </strong></font></td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <p>
                                <CR:CrystalReportViewer id="CrystalReportViewer1" runat="server" DisplayGroupTree="False" HasCrystalLogo="False" HasToggleGroupTreeButton="False" OnInit="CrystalReportViewer1_Init" EnableParameterPrompt="False" EnableDatabaseLogonPrompt="False" borderwidth="1px" borderstyle="Dotted" pagetotreeratio="4" height="50px" width="100%"></CR:CrystalReportViewer>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
            </font>
        </p>
    </form>
</body>
</html>