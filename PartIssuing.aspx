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
            if page.ispostback = false then
                procLoadGridData()
            end if
        End Sub

         Sub ProcLoadGridData()
            Dim SortSeq as String
            Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
            Dim StrSql as string = "Select * from MAT_ISS_M order by create_date desc"
                Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MAT_ISS_M")

                dtgShortage.visible = true
                dtgShortage.DataSource=resExePagedDataSet.Tables("MAT_ISS_M").DefaultView
                dtgShortage.DataBind()
         end sub



        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                E.Item.Cells(4).Text = format(cdate(e.Item.Cells(4).Text),"MM/dd/yy")
            End if
        End Sub

        Sub cmdNew_Click(sender As Object, e As EventArgs)
            response.redirect("PartIssuingAddNew.aspx")
        End Sub

        Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
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
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">MATERIAL ISSUING
                                RECORD</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" PageSize="20" Height="35px" Font-Names="Verdana" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:HyperLinkColumn Text="View" DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="PartIssuingDet.aspx?ID={0}"></asp:HyperLinkColumn>
                                                            <asp:BoundColumn DataField="ISSUING_NO" HeaderText="Issuing No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="LOT_NO" HeaderText="LOT NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CREATE_BY" HeaderText="Created By"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CREATE_DATE" HeaderText="Created Date"></asp:BoundColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="right">
                                                    <asp:Button id="cmdNew" onclick="cmdNew_Click" runat="server" Text="Create a new Issuing"></asp:Button>
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
