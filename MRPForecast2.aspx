<%@ Page Language="VB" %>

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
            if request.cookies("U_ID") is nothing then
                response.redirect("AccessDenied.aspx")
            else
                Dim OurCommand as sqlcommand
                Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm

                procLoadSOModel()

                if gridcontrol1.items.count = 0 then
                    label1.visible = true
                    gridcontrol1.visible = false
                else
                    label1.visible = false
                    gridcontrol1.visible = true
                end if

                if gridcontrol1.items.count = 0 then
                    cmdNext.enabled = false
                end if

            end if
        end if
    End Sub

    Sub procLoadSOModel()
        Dim StrSql as string
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        StrSql = "SELECT Cust.Cust_Name, SO.Seq_No,SO.Lot_No,SO.Cust_Code,SO.Order_Qty,MM.Model_Desc,SO.FORECAST_MONTH,SO.FORECAST_YEAR FROM SO_FORECAST_M SO,Model_Master MM, cust WHERE SO.SEL = 'YES' AND MM.Model_Code = SO.Model_No and cust.Cust_code = so.cust_code ORDER BY SO.LOT_NO"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"SO_FORECAST_M")
        GridControl1.DataSource=resExePagedDataSet.Tables("SO_FORECAST_M").DefaultView
        GridControl1.DataBind()
    end sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub

    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub

    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderModelAdd.aspx")
    End Sub

    Sub cmdNext_Click(sender As Object, e As EventArgs)
        response.redirect("MRPForecast3.aspx")
    End Sub

    Sub Menu1_Load(sender As Object, e As EventArgs)
    End Sub

    Sub UserControl2_Load(sender As Object, e As EventArgs)
    End Sub

    Sub GridControl2_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub

    Sub cmdPrevious_Click(sender As Object, e As EventArgs)
        response.redirect("MRP2.aspx")
    End Sub

    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

    Protected Sub FormatRowModel(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            e.Item.Cells(1).Text = format(cdate(e.Item.Cells(1).Text),"MM/dd/yy")
            e.Item.Cells(4).Text = format(cint(e.Item.Cells(4).Text),"##0")
            e.Item.Cells(5).Text = format(cdate(e.Item.Cells(5).Text),"MM/dd/yy")
            e.Item.Cells(6).Text = format(cdate(e.Item.Cells(6).Text),"MM/dd/yy")
        End If
    End Sub

    Protected Sub FormatRowPart(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            e.Item.Cells(1).Text = format(cdate(e.Item.Cells(1).Text),"MM/dd/yy")
            e.Item.Cells(2).Text = format(cdate(e.Item.Cells(2).Text),"MM/dd/yy")
        End If
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 30px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">Step 3 of 4
                                : Please confirm on the selected Sales Order for MRP run</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 43px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="Label4" runat="server" width="100%" cssclass="Instruction">Sales Order
                                                    (By Model) </asp:Label>
                                                </p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:Label id="Label1" runat="server" width="310px" visible="False" font-size="X-Small" font-bold="True">"There
                                                    are no Sales Order to display."</asp:Label>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" Font-Size="XX-Small" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Font-Names="Verdana" Height="35px" PageSize="100">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="ID">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="LOT_NO" HeaderText="LOT NO"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Model_Desc" HeaderText="MODEL"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CUST_Name" HeaderText="Customer"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ORDER_QTY" HeaderText="Lot Qty.">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="FORECAST_MONTH" HeaderText="Month">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="FORECAST_YEAR" HeaderText="Year">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                                <table style="HEIGHT: 25px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Button id="cmdPrevious" onclick="cmdPrevious_Click" runat="server" Text="Previous" Width="151px"></asp:Button>
                                            </td>
                                            <td>
                                                <div align="center">
                                                    <asp:Button id="cmdNext" onclick="cmdNext_Click" runat="server" Text="Next" Width="151px"></asp:Button>
                                                </div>
                                            </td>
                                            <td>
                                                <p align="right">
                                                    <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Text="Cancel" Width="151px"></asp:Button>
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
