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
        if page.ispostback = false then procLoadGridData ("SELECT PR.Earliest_Date,PR.Lot_No,PR.Model_No, PM.PART_DESC + '|' + PM.PART_SPEC AS [PART_DESC],PM.BUYER_CODE,PR.SEQ_NO,PR.PART_NO,PR.BOM_DATE,PR.eta_date,PR.QTY FROM MRP_FORECAST_D PR,PART_MASTER PM WHERE MRP_No= " & request.params("ID") & " AND PR.PART_NO = PM.PART_NO and PR.Source = 'PR' ORDER BY PR.Part_no ASC",dtgShortage)

    End Sub



    Sub ProcLoadGridData(StrSql as string,GridObject as object)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MRP_FORECAST_D")
        GridObject.DataSource=resExePagedDataSet.Tables("MRP_FORECAST_D").DefaultView
        GridObject.DataBind()
    end sub

    Property PartWithoutSource() As integer
        Get
            Dim o As Object = ViewState("PartWithoutSource")

            If o Is Nothing Then
                Return 0
            End If
            Return cint(o)
        End Get
        Set(ByVal Value As integer)
            ViewState("PartWithoutSource") = Value
        End Set
    End Property


    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub

    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub

    Sub cmdFinish_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then

            e.item.cells(7).text = ReqCOm.GetFieldVal("Select count(Ven_Code) as [Supplier] from Part_Source where Part_No = '" & trim(e.item.cells(1).text) & "';","Supplier")
            if cint(e.item.cells(7).text) = 0 then e.Item.CssClass = "PartSource"
            if cint(e.item.cells(7).text) = 0 then PartWithoutSource = PartWithoutSource + 1
            label1.text = "Attention : " & PartWithoutSource.tostring & " part(s) without source"

            Dim Source As Label = CType(e.Item.FindControl("lblSource"), Label)

        End if
    End Sub

    Sub UserControl2_Load(sender As Object, e As EventArgs)

    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <table style="WIDTH: 100%; HEIGHT: 100%" cellspacing="0" cellpadding="0">
            <tbody>
                <tr valign="top">
                </tr>
                <tr>
                    <td colspan="2">
                        <IBUYSPY:HEADER id="UserControl2" runat="server" OnLoad="UserControl2_Load"></IBUYSPY:HEADER>
                    </td>
                </tr>
                <tr valign="top">
                    <td valign="top">
                        <p>
                        </p>
                    </td>
                    <td valign="top">
                        <p align="center">
                            <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">Step 5 of 5
                            : MRP explosion results.</asp:Label>
                        </p>
                        <p>
                        </p>
                        <p>
                            <asp:Label id="Label1" runat="server" cssclass="ErrorText" width="100%" height="40px" font-size="X-Large">Label</asp:Label>
                        </p>
                        <p>
                            <table style="HEIGHT: 21px" width="100%" border="1">
                                <tbody>
                                    <tr>
                                        <td>
                                            <div align="center"><asp:Label id="Label2" runat="server" cssclass="Instruction" width="100%">MATERIAL
                                                SHORTAGE LIST</asp:Label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:DataGrid id="dtgShortage" runat="server" width="100%" Height="35px" Font-Names="Verdana" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PageSize="100" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow">
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
                                                    <asp:BoundColumn DataField="PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="LOT_NO" HeaderText="LOT NO"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="MODEL_NO" HeaderText="MODEL NO"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="PART_DESC" HeaderText="DESCRIPTION/SPEC"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="BUYER_CODE" HeaderText="BUYER"></asp:BoundColumn>
                                                    <asp:BoundColumn DataField="QTY" HeaderText="QTY" DataFormatString="{0:f}">
                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                    </asp:BoundColumn>
                                                    <asp:BoundColumn HeaderText="SRC" >
                                                        <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                        <ItemStyle horizontalalign="Right"></ItemStyle>
                                                    </asp:BoundColumn>
                                                </Columns>
                                            </asp:DataGrid>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </p>
                        <p>
                        </p>
                        <p>
                        </p>
                        <p>
                            <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" Width="157px" Text="Finish"></asp:Button>
                        </p>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
