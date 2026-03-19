<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="IBuySpy" TagName="MRF" Src="_MRFDet.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
                if page.ispostback = false then ShowMRFDet
            End Sub
    
             SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
                 Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                 Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
                 with obj
                     .items.clear
                     .DataSource = ResExeDataReader
                     .DataValueField = FValue
                     .DataTextField = FText
                     .DataBind()
                 end with
                 ResExeDataReader.close()
             End Sub
    
    
    
    
    
             Sub cmdBack_Click(sender As Object, e As EventArgs)
                 response.redirect("MRF.aspx")
             End Sub
    
             Sub ShowMRFDet()
                 Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
                 lblJONo.text = ""
                 Dim RsSO as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 * from MRF_M where Seq_No = " & request.params("ID") & ";")
                 Do while rsSo.read
                     lblmrfNo.text = rsSO("MRF_NO").tostring
                     lblJONo.text = rsSO("JO_No").tostring
                     lblSection.text = rsSO("P_Level")
    
                     if isdbnull(rsSO("Submit_Date")) = false then
                         lblSubmitBy.text = rsSO("Submit_By").tostring
                         lblSubmitDate.text = format(cdate(rsSO("Submit_Date")),"dd/MM/yy (hh:mm:ss)")
                     elseif isdbnull(rsSO("Submit_Date")) = true then
                         lblSubmitBy.text = ""
                         lblSubmitDate.text = ""
                     end if
    
                     if isdbnull(rsSO("App1_Date")) = false then
                         lblApp1Date.text = format(cdate(rsSO("App1_Date")),"dd/MM/yy (hh:mm:ss)")
                         lblApp1By.text = rsSO("App1_By")
                     elseif isdbnull(rsSO("App1_Date")) = true then
                         lblApp1by.text = ""
                         lblApp1Date.text = ""
                     end if
    
                     if isdbnull(rsSO("App2_Date")) = false then
                         lblApp2Date.text = format(cdate(rsSO("App2_Date")),"dd/MM/yy (hh:mm:ss)")
                         lblApp2By.text = rsSO("App2_By")
                     elseif isdbnull(rsSO("App2_Date")) = true then
                         lblApp2by.text = ""
                         lblApp2Date.text = ""
                     end if
    
                     if isdbnull(rsSO("App3_Date")) = false then
                         lblApp3Date.text = format(cdate(rsSO("App3_Date")),"dd/MM/yy (hh:mm:ss)")
                         lblApp3By.text = rsSO("App1_By")
                     elseif isdbnull(rsSO("App3_Date")) = true then
                         lblApp3by.text = ""
                         lblApp3Date.text = ""
                     end if
    
                     if isdbnull(rsSO("App4_Date")) = false then
                         lblApp4Date.text = format(cdate(rsSO("App4_Date")),"dd/MM/yy (hh:mm:ss)")
                         lblApp4By.text = rsSO("App4_By")
                     elseif isdbnull(rsSO("App4_Date")) = true then
                         lblApp4by.text = ""
                         lblApp4Date.text = ""
                     end if
                     'if trim(lblSubmitDate.text) <> "" then
                     '    cmdApproved.enabled = false
                     'elseif trim(lblSubmitDate.text) = "" then
                     '    cmdApproved.enabled = true
                     'end if
                 Loop
                 RsSO.Close
                 lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_MODELS_M where lot_no in (select lot_NO from job_order_m where jo_no = '" & trim(lblJONo.text) & "')","Model_No")
                 lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
                 lblRevision.text = ReqCOM.GetFieldVal("Select top 1 revision from bom_m where model_no = '" & trim(lblModelNo.text) & "' order by revision desc","Revision")
             End sub
    
             Sub ShowAlert(Msg as string)
                 Dim strScript as string
                 strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
                 If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
             End sub
    
              Sub lnkMRFItem_Click(sender As Object, e As EventArgs)
                  ShowPopup("PopupMRFItem.aspx?ID=" & Request.params("ID"))
              End Sub
    
              Sub ShowPopup(ReturnURL as string)
                  Dim Script As New System.Text.StringBuilder
                  Script.Append("<script language=javascript>")
                  Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
                  Script.Append("</script" & ">")
                  RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
              End sub
    
     Sub Calculate(sender as Object,e as DataGridCommandEventArgs)
         Dim ExtraIssued As Label = CType(e.Item.FindControl("ExtraIssued"), Label)
         Dim QtyToStore As Textbox = CType(e.Item.FindControl("QtyToStore"), Textbox)
         Dim QtyToIR As Textbox = CType(e.Item.FindControl("QtyToIR"), Textbox)
         Dim QtyScrap As Textbox = CType(e.Item.FindControl("QtyScrap"), Textbox)
         Dim QtyOtherScrap As Textbox = CType(e.Item.FindControl("QtyOtherScrap"), Textbox)
    
         QtyToStore.text = clng(ExtraIssued.text) - clng(QtyToIR.text) - clng(QtyScrap.text) - clng(QtyOtherScrap.text)
     End sub
    
     Sub cmdPrint_Click(sender As Object, e As EventArgs)
         ShowReport("PopupReportViewer.aspx?RptName=MRF&ID=" & request.params("ID"))
         redirectPage("MRFDet.aspx?ID=" & Request.params("ID"))
     End Sub
    
     Sub ShowReport(ReturnURL as string)
         Dim Script As New System.Text.StringBuilder
         Script.Append("<script language=javascript>")
         Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        'Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
         Script.Append("</script" & ">")
         RegisterStartupScript("ShowExistingSupplier", Script.ToString())
     End sub
    
     Sub redirectPage(ReturnURL as string)
         Dim strScript as string
         strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
         If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
     End sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">MRF DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:Label id="lblStatus" runat="server" width="344px" visible="False">Label</asp:Label> 
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 70%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="70%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" width="126px" cssclass="LabelNormal">MRF NO</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:Label id="lblMRFNo" runat="server" width="126px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="126px" cssclass="LabelNormal">Job Order
                                                                    No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblJONo" runat="server" width="126px" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp; 
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" width="126px" cssclass="LabelNormal">Section</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSection" runat="server" width="126px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" width="126px" cssclass="LabelNormal">Model No
                                                                    / Desc</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                    /&nbsp; <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label><asp:Label id="lblRevision" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="1">
                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal">Submit By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="126px" cssclass="LabelNormal">Approved
                                                                    By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" width="126px" cssclass="LabelNormal">PCMC By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" width="126px" cssclass="LabelNormal">IQC by/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" width="126px" cssclass="LabelNormal">Store By/Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <IBUYSPY:MRF id="UserControl1" runat="server"></IBUYSPY:MRF>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="cmdPrint" onclick="cmdPrint_Click" runat="server" Width="153px" Text="Print"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="181px" Text="Back"></asp:Button>
                                                                    </div>
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
        <p align="left">
        </p>
    </form>
</body>
</html>
