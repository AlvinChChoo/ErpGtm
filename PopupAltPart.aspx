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
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            lblModelNo.text = trim(Request.params("ModelNo"))
            lblPartNo.text = Trim(Request.params("PartNo"))
            lblDescription.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where part_no = '" & trim(lblPartNo.text) & "';","Part_Desc")
            lblSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where part_no = '" & trim(lblPartNo.text) & "';","Part_Spec")
            ProcLoadGridData
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "select ven.curr_code,ps.std_pack_qty,ps.min_order_qty,ps.cancel_lt,ps.reschedule_lt,BA.PART_NO,ps.lead_time,ps.up,ven.Ven_Name from bom_alt BA, part_source PS,vendor ven where ba.main_part = '" & trim(lblPartNo.text) & "' and ba.model_no = '" & trim(lblModelNo.text) & "' and ba.part_no = ps.part_no and ps.ven_code = ven.ven_code"
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_Master")
        GridControl1.DataSource=resExePagedDataSet.Tables("Part_Master").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            e.item.cells(3).text = format(cdec(e.item.cells(3).text),"##,##0.00000")
            e.item.cells(5).text = format(cdec(e.item.cells(5).text),"##,##0")
            e.item.cells(6).text = format(cdec(e.item.cells(6).text),"##,##0")
        End if
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
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label1" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">ALTERNATE
                                PART</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 62px" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label2" runat="server" width="128px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" width="342px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label3" runat="server" width="128px" cssclass="LabelNormal">Description</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblDescription" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Part No / Specification</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPartNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp; <asp:Label id="lblSpec" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="20" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="Part No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="VEN_NAME" HeaderText="Supplier"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="LEAD_TIME" HeaderText="Lead Time"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="UP" HeaderText="U/P"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Curr_Code" HeaderText="Curr"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Std_pack_Qty" HeaderText="Std Pack"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Min_Order_Qty" HeaderText="MOQ"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Cancel_LT" HeaderText="Cancel"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Reschedule_LT" HeaderText="Reschedule"></asp:BoundColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
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
