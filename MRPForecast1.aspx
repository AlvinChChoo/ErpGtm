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
        if page.ispostback = false then procLoadGridData ()
    End Sub

    Sub ProcLoadGridData()
        Dim StrSql as string = "SELECT Cust.Cust_Name, SO.Seq_No,SO.Lot_No,SO.Cust_Code,SO.Order_Qty,MM.Model_Desc,SO.FORECAST_MONTH,SO.FORECAST_YEAR FROM SO_FORECAST_M SO,Model_Master MM, cust WHERE MM.Model_Code = SO.Model_No and cust.Cust_code = so.cust_code ORDER BY SO.LOT_NO"
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"SO_FORECAST_M")

        GridControl1.DataSource=resExePagedDataSet.Tables("SO_FORECAST_M").DefaultView
        GridControl1.DataBind()
        ReqCOM.executeNonQuery("Update SO_FORECAST_M set Sel = 'NO';")
    end sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub cmdNext_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            UpdateSelectedSO()
            response.redirect("MRPForecast2.aspx")
        end if
    End Sub

    Sub UpdateSelectedSO()
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm

        ReqCOM.ExecuteNonQuery("Update SO_MODEL_M set SEL = 'NO' WHERE sel = 'YES'")

        For i = 0 To gridcontrol1.Items.Count - 1
            Dim SeqNo As Label = Ctype(gridcontrol1.Items(i).FindControl("lblSeqNo"), Label)
            Dim Sel As Checkbox = Ctype(gridcontrol1.Items(i).FindControl("Sel"), Checkbox)
            if Sel.checked = true then ReqCOM.ExecuteNonQuery("Update SO_FORECAST_M set SEL = 'YES' where Seq_No = " & SeqNo.text & ";")
        Next
    End Sub

    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p title="100%">
            <font color="#0000a0">
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p>
                                <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">Step 1 of 5
                                : Select Sales Order (By Model) for MRP run </asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                </p>
                                                <p align="center">
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" Font-Size="XX-Small" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="100" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Font-Names="Verdana" Height="35px">
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
                                                            <asp:TemplateColumn HeaderText="Select">
                                                                <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <center>
                                                                        <asp:CheckBox id="Sel" runat="server" />
                                                                    </center>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdNext" onclick="cmdNext_Click" runat="server" Text="Next" Width="151px"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Text="Cancel" Width="151px" CausesValidation="False"></asp:Button>
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
            </font>
        </p>
    </form>
</body>
</html>
