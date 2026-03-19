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
        if page.ispostback = false then loaddata()
    End Sub
    
    Sub LoadData
        Dim strSql as string = "SELECT * FROM SO_MODELS_M WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
    
        do while ResExeDataReader.read
            lblCustCode.text = ReqExeDataReader.GetFieldVal("select cust_Code,Cust_Code + ' (' + cust_name + ')' as [desc] from cust where cust_Code = '" & trim(ResExeDataReader("Cust_Code")) & "';","Desc")
            lblModelNo.text =  ReqExeDataReader.GetFieldVal("Select Model_Code,Model_Code + ' ( ' + model_desc + ')' as [desc] from model_master where model_Code = '" & trim(ResExeDataReader("Model_No").tostring) & "';","Desc")
            lblLotNo.text = ResExeDataReader("LOT_NO")
            lblSODate.text = format(cdate(ResExeDataReader("SO_DATE")),"MM/dd/yyyy")
            lblOrderQty.text = ResExeDataReader("ORDER_QTY").tostring
        loop
    End sub
    
    Sub cmdProceed_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Update SO_Models_M set Cancel1_By = '" & trim(request.cookies("U_ID").value) & "',Cancel1_Date = '" & cdate(now) & "',SO_Status = 'PENDING CANCELLATION',Cancel1_Rem = '" & trim(txtCancelRem.text) & "' where seq_no = " & clng(request.params("ID")) & ";")
            ShowAlert ("Sales Order has been submitted for Cancellation approval.")
            redirectPage("SalesOrderModel.aspx")
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesOrderModelDet.aspx?ID=" & request.params("ID"))
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

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" cssclass="Instruction" width="100%">Please provide
                            user anthentication for Sales Order Cancellation</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td width="25%" bgcolor="silver">
                                                            <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="134px">Lot No </asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="134px">Issued
                                                            Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblSODate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="134px">Cust.
                                                            Code</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblCustCode" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label17" runat="server" cssclass="LabelNormal" width="134px">Model
                                                            No</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="134px">Lot Qty</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblOrderQty" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; HEIGHT: 10px; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="OutputText" width="134px">Remarks</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtCancelRem" runat="server" TextMode="MultiLine" Height="78px" Width="100%" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <table style="HEIGHT: 25px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Button id="cmdProceed" onclick="cmdProceed_Click" runat="server" Width="183px" Text="Cancel this sales order"></asp:Button>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="125px" Text="Back" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
