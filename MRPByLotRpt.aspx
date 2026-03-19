<%@ Page Language="VB" Debug="TRUE" %>
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
        if page.ispostback = false then Dissql("Select DISTINCT(LOT_NO) as [lot_no] from MRP_D_net order by LOT_NO ASC","LOT_NO","LOT_NO",cmbLOTNO)
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

    Sub cmdFinish_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

    Sub cmdGO_Click(sender As Object, e As EventArgs)
        response.redirect("PopupReportViewer.aspx?RptName=MRPLot&ReturnURL=MRPByLotRpt.aspx&LotNo=" & trim(cmbLotNo.selecteditem.value))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" onkeypress="KeyPress()" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                <tbody >
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server" ></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">Material
                                Shortage List (By Lot No)</asp:Label>
                            </div>
                            <p>
                                <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="50%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="" cssclass="OutputText">LOT NO</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbLotNo" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" CssClass="OutputText" Width="120px" Text="View Report"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" CssClass="OutputText" Width="120px" Text="Back"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
