<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
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
                Dim oList As ListItemCollection
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim rs as SQLDataReader
    
                rs = ReqCom.ExeDataReader("Select * from kit_lot where seq_no = " & request.params("ID") & ";")
                do while rs.read
                    lblKitLotNo.text = rs("Kit_Lot_No").tostring
                    lblStatus.text = rs("Kit_Lot_Status").tostring
                    lblLotNo.text = trim(rs("Lot_No"))
                    lblLevel.text = trim(rs("P_Level"))
                    lblReqQty.text = rs("Req_Qty")
                    lblDateToIssue.text = format(cdate(rs("Date_To_Issue")),"dd/MM/yy")
                    lblModelNo.text = ReqCOM.GetFieldVal("Select top 1 Model_No from SO_Model_M where Lot_No = '" & trim(lblLotNo.text) & "';","Model_NO")
                    lblModelDesc.text = ReqCom.GetFieldVal("Select top 1 Model_Desc from Model_Master where model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
    
                    lblApp1By.text = trim(rs("App1_By").tostring)
                    if isdbnull(rs("App1_Date")) = false then lblApp1Date.text = format(cdate(rs("App1_Date")),"dd/MM/yy")
    
                    lblApp2By.text = trim(rs("App2_By").tostring)
                    if isdbnull(rs("App2_Date")) = false then lblApp2Date.text = format(cdate(rs("App2_Date")),"dd/MM/yy")
    
                    if isdbnull(rs("App1_Date")) = true then
                        cmdsubmit.enabled = true
                    elseif isdbnull(rs("App1_Date")) = false then
                        cmdsubmit.enabled = false
                    end if
                loop
            End if
        End Sub
    
        Sub ShowAlert(Msg as string)
               Dim strScript as string
               strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
            End sub
    
         SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
         Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
         Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
         with obj
             .DataSource = ResExeDataReader
             .DataValueField = FValue
             .DataTextField = FText
             .DataBind()
         end with
         ResExeDataReader.close()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("KitLot.aspx")
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update Kit_Lot set Kit_Lot_Status = 'PENDING APPROVAL',App1_By = '" & trim(Request.cookies("U_ID").value) & "', App1_Date = '" & cdate(now) & "' where Kit_Lot_No = '" & trim(lblKitLotNo.text) & "';")
        ShowAlert("Select Kit Lot Form has been submitted.")
        redirectPage("KitLotDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
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
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">KIT LOT MATERIAL
                                FORM</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label1" runat="server" cssclass="LabelNormal">Ref
                                                                        No</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td width="70%">
                                                                    <asp:Label id="lblKitLotNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left">
                                                                        <div align="left"><asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="100%">Lot
                                                                            No</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left">
                                                                        <div align="left"><asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="100%">Level</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblLevel" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="100%">Request
                                                                        Qty.</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblReqQty" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="100%">Date to
                                                                    Issue</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblDateToIssue" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="100%">Model No/Description</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp; <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left">
                                                                        <div align="left"><asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="100%">Prod.
                                                                            By/Date</asp:Label>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <div align="left"><asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="100%">PCMC
                                                                        By/Date</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="1">
                                                                    <div align="left"><asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="100%">Status</asp:Label>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblStatus" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Text="Submit" Width="101px"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="101px"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
