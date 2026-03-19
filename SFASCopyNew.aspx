<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
    
             if page.isPostBack = false then
                 if request.cookies("U_ID") is nothing then
                     response.redirect("AccessDenied.aspx")
                 else
                     Dim OurCommand as sqlcommand
                     Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                     procLoadGridData
                 end if
             else
                 if request.cookies("U_ID") is nothing then
                     response.redirect("AccessDenied.aspx")
                 else
                     Dim OurCommand as sqlcommand
                     Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                 end if
             end if
         End Sub
    
        Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        '    GridControl1.CurrentPageIndex = e.NewPageIndex
        '    ProcLoadGridData
        end sub
    
        Sub ProcLoadGridData
       '     'Dim StrSql as string = "select mm.cust_code,MM.MODEL_DESC,SF.MODEL_NO,sf.forecast_date,SF.FORECAST_QTY,SF.UP from SFAS_D SF, MODEL_MASTER MM where sfas_no = '" & trim(lblSFASNo.text) & "' AND MM.model_code = SF.MODEL_NO;"
       '     Dim StrSql as string = "select app1_by,app2_by,app1_date,app2_date,sfas_status,submit_by,submit_date,seq_no,SFAS_NO from SFAS_M"
       '     Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
       '     Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SR_M")
       '     GridControl1.DataSource=resExePagedDataSet.Tables("SR_M").DefaultView
       '     GridControl1.DataBind()
        end sub
    
    
    
        Sub cmdMain_Click(sender As Object, e As EventArgs)
            response.redirect("Main.aspx")
        End Sub
    
         Sub Button2_Click(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdAddNew_Click(sender As Object, e As EventArgs)
             response.redirect("CustomerAddNew.aspx")
         End Sub
    
        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            Dim ForecastDate,SubmitBy,SubmitDate,App1By,App2By,App1Date,App2Date As Label
    
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                ForecastDate = CType(e.Item.FindControl("ForecastDate"), Label)
                SubmitBy = CType(e.Item.FindControl("SubmitBy"), Label)
                SubmitDate = CType(e.Item.FindControl("SubmitDate"), Label)
                App1By = CType(e.Item.FindControl("App1By"), Label)
                App1Date = CType(e.Item.FindControl("App1Date"), Label)
                App2By = CType(e.Item.FindControl("App2By"), Label)
                App2Date = CType(e.Item.FindControl("App2Date"), Label)
    
                if trim(SubmitDate.text) <> "" then SubmitBy.text = trim(SubmitBy.text) & "-" & format(cdate(SubmitDate.text),"dd/MM/yy")
                if trim(App1Date.text) <> "" then App1By.text = trim(App1By.text) & "-" & format(cdate(App1Date.text),"dd/MM/yy")
                if trim(App2Date.text) <> "" then App2By.text = trim(App2By.text) & "-" & format(cdate(App2Date.text),"dd/MM/yy")
            End if
        End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        Response.redirect("SFAS.aspx")
    End Sub
    
    Sub cmdProceed_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim SFASNo as string = ReqCOM.GetDocumentNo("SFAS_No")
    
            ReqCOM.ExecuteNonQuery("Insert into SFAS_M(SFAS_NO,SUBMIT_REM) select '" & trim(SFASNo) & "',SUBMIT_REM from SFAS_M where SFAS_No = '" & trim(txtSFASNo.text) & "';")
            ReqCOM.ExecuteNonQuery("iNSERT INTO sfas_d(SFAS_NO,MODEL_NO,FORECAST_QTY,FORECAST_DATE,UP,AMT,SO_QTY) select '" & trim(SFASNo) & "',MODEL_NO,FORECAST_QTY,FORECAST_DATE,UP,AMT,SO_QTY from sfas_d where sfas_no = '" & trim(txtSFASNo.text) & "';")
            ReqCOM.ExecuteNonQuery("Update Main set SFAS_No = SFAS_No + 1")
            ShowAlert("New SFAS No : " & SFASNo)
            redirectPage("SFASDet.aspx?ID=" & ReqCOM.GetFIeldVal("Select Seq_No from SFAS_M where SFAS_No = '" & trim(SFASNo) & "';","Seq_No"))
        end if
    End Sub
    
    Sub ShowAlert(Msg as string)
                Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
                If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ValDuplicateLotNo(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCOM.FuncCheckDuplicate("Select sfas_no from sfas_m where sfas_no = '" & trim(txtSFASNo.text) & "';","SFAS_No") = false then e.isvalid = false
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 23px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">SALES FORECAST
                                APPROVAL SHEET</asp:Label>
                            </p>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                                <table style="HEIGHT: 9px" width="70%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="DuplicateLotNo" runat="server" ErrorMessage="You don't seem to have supplied a valid SFAS No" Display="Dynamic" ForeColor=" " EnableClientScript="False" OnServerValidate="ValDuplicateLotNo" CssClass="ErrorText" Width="100%"></asp:CustomValidator>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Current SFAS #</asp:Label></td>
                                                            <td width="70%">
                                                                <asp:TextBox id="txtSFASNo" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 16px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdProceed" onclick="cmdProceed_Click" runat="server" Width="93px" Text="Proceed"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="82px" Text="Cancel"></asp:Button>
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
                                &nbsp;&nbsp; 
                            </div>
                            <div align="center">
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
