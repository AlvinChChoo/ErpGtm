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

    public PreviousUP as decimal
    public PreviousQty as long

        Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.ispostback = false then txtYear.text = Year(now)
        End Sub

        Sub cmdEdit_Click(sender As Object, e As EventArgs)
            Response.redirect("SalesForecastEdit.aspx")
        End Sub

        Sub cmdUpdate_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
            Dim SFASNo as string = ReqCOM.GetDocumentNo("SFAS_No")
            Dim ForecastDate as date = cint(cmbMonth.selecteditem.value) & "/1/" & cint(txtYear.text)
            ReqCOM.ExecuteNonQuery("Insert into SFAS_M(SFAS_NO,FORECAST_DATE,SFAS_STATUS) Select '" & trim(SFASNo) & "','" & CDATE(ForecastDate) & "','PENDING SUBMISSION'")
            ReqCOM.ExecuteNonQuery("Update Main set SFAS_No = SFAS_No + 1")
            Response.redirect("SFASDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from SFAS_M where SFAS_No = '" & trim(SFASNo) & "';","Seq_No"))
        End Sub

        Sub ValForecastYear(sender As Object, e As ServerValidateEventArgs)
            e.isvalid = false
            if isdate(cmbmonth.selectedItem.value & "/1/" & txtYear.text) = true then e.isvalid =true
        End Sub

        Sub cmdBack_Click(sender As Object, e As EventArgs)
            response.redirect("SFAS.aspx")
        End Sub

        Sub LinkButton5_Click(sender As Object, e As EventArgs)
            Response.redirect("SalesForecast1.aspx")
        End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SALES FORECAST
                                APPROVAL SHEET</asp:Label>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid month " Display="Dynamic" ControlToValidate="cmbMonth" EnableClientScript="False" Width="100%" ForeColor=" "></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Forecast Year." Display="Dynamic" ControlToValidate="txtYear" EnableClientScript="False" Width="100%" ForeColor=" "></asp:RequiredFieldValidator>
                                <asp:CustomValidator id="ValidateYear" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid Forecast Year." Display="Dynamic" Width="100%" ForeColor=" " OnServerValidate="ValForecastYear"></asp:CustomValidator>
                            </p>
                            <p align="center">
                                <table cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server">Month / Year</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbMonth" runat="server" CssClass="OutputText" Width="140px">
                                                                    <asp:ListItem Value="1">January</asp:ListItem>
                                                                    <asp:ListItem Value="2">February</asp:ListItem>
                                                                    <asp:ListItem Value="3">March</asp:ListItem>
                                                                    <asp:ListItem Value="4">April</asp:ListItem>
                                                                    <asp:ListItem Value="5">May</asp:ListItem>
                                                                    <asp:ListItem Value="6">June</asp:ListItem>
                                                                    <asp:ListItem Value="7">July</asp:ListItem>
                                                                    <asp:ListItem Value="8">August</asp:ListItem>
                                                                    <asp:ListItem Value="9">September</asp:ListItem>
                                                                    <asp:ListItem Value="10">October</asp:ListItem>
                                                                    <asp:ListItem Value="11">November</asp:ListItem>
                                                                    <asp:ListItem Value="12">December</asp:ListItem>
                                                                </asp:DropDownList>
                                                                &nbsp;/
                                                                <asp:TextBox id="txtYear" runat="server" CssClass="OutputText" Width="82px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 19px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="153px" Text="Update Forecast Qty"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="124px" Text="Back" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
