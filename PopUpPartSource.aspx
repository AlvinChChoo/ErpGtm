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
                'Dim NoOfSOurce as integer
                'Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                'lblPartNo.text = trim(Request.params("PartNo").tostring)
                LoadPartDet
                procLoadGridData ()
            end if
        End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select PS.UP_APP_NO, PS.MODIFY_DATE, PS.Lead_Time,PS.SEQ_NO,PS.UP,PS.Modify_By,PS.Std_Pack_Qty,PS.Min_Order_Qty,V.Ven_name as [Vendor],ps.part_no from Part_Source PS,Vendor v where PS.Part_No = '" & trim(lblPartNo.text) & "' and PS.Ven_Code = V.Ven_Code"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_source")
        GridControl1.DataSource=resExePagedDataSet.Tables("Part_source").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            e.Item.Cells(2).Text = cint(e.Item.Cells(2).Text)
            e.Item.Cells(3).Text = cint(e.Item.Cells(3).Text)
            e.Item.Cells(4).Text = format(cdec(e.Item.Cells(4).Text),"##,##0.00000")
        End if
    End Sub
    
    Sub LoadPartDet
        Dim strSql as string = "Select top 1 Part_No,Part_Spec,Part_Desc from Part_Master where Part_No = '" & trim(request.params("PartNo")) & "';"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        do while drGetFieldVal.read
            lblPartNo.text = drGetFieldVal("Part_No")
            lblPartSpec.text = drGetFieldVal("Part_Spec")
            lblPartDesc.text = drGetFieldVal("Part_Desc")
        loop
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">PART
                                SOURCE LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <p>
                                                                        <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Part No</asp:Label>
                                                                    </p>
                                                                </td>
                                                                <td width="75%">
                                                                    <p>
                                                                        <asp:Label id="lblPartNo" runat="server" cssclass="OutputText"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <p>
                                                                        <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Description</asp:Label>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblPartDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <p>
                                                                        <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Specification</asp:Label>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <asp:Label id="lblPartSpec" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" Font-Name="Verdana" Font-Names="Verdana" Font-Size="XX-Small" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="Vendor" HeaderText="SUPPLIER"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Lead_Time" HeaderText="L/T(Wks)">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Std_Pack_Qty" HeaderText="STD PACK">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Min_Order_Qty" HeaderText="MOQ">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="UP" HeaderText="U/P">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="UP_APP_NO" HeaderText="APP. NO">
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
