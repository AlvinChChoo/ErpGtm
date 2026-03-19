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
            ProcLoadGridData
        end if
    End Sub

    Sub ProcLoadGridData()

        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        'Dim StrSql as string = "select bm.model_no,bm.revision, sum(bd.p_usage*bd.part_up_rpt) as [TotalCost] from bom_M BM, bom_d bd where bm.ind = 'Y' and bm.model_no = bd.model_no and bd.revision = bd.revision group by bm.model_no,bm.Revision"
        Dim StrSql as string = "Select bm.model_no,bm.Revision,sum(bd.p_usage * pm.wac_cost) as [TotalCost] from part_master pm,bom_m bm, bom_d bd where bm.model_no = bd.model_no and bm.revision = bd.revision and pm.part_no = bd.part_no and bm.ind='Y' group by bm.model_no,bm.revision"

        'Dim StrSql as string'

        'StrSql = "SELECT "BOM_D"."MODEL_NO", "BOM_D"."Revision", "BOM_D"."PART_NO", "BOM_D"."P_LEVEL", "BOM_D"."P_USAGE", "BOM_D"."Part_UP_Rpt", "VENDOR"."CURR_CODE", "PART_SOURCE"."UP", "CURR"."RATE", "CURR"."UNIT_CONV", "VENDOR"."VEN_NAME", "PART_MASTER"."WAC_COST" "
        'StrSql = StrSql + "FROM   ((("erp_gtm"."dbo"."BOM_D" "BOM_D" INNER JOIN "erp_gtm"."dbo"."PART_SOURCE" "PART_SOURCE" ON "BOM_D"."PART_NO"="PART_SOURCE"."PART_NO") INNER JOIN "erp_gtm"."dbo"."PART_MASTER" "PART_MASTER" ON "BOM_D"."PART_NO"="PART_MASTER"."PART_NO") INNER JOIN "erp_gtm"."dbo"."VENDOR" "VENDOR" ON "PART_SOURCE"."VEN_CODE"="VENDOR"."VEN_CODE") INNER JOIN "erp_gtm"."dbo"."CURR" "CURR" ON "VENDOR"."CURR_CODE"="CURR"."CURR_CODE" "
        'StrSql = StrSql + "WHERE  "BOM_D"."MODEL_NO"=N'STORE' AND "BOM_D"."Revision"=1 "
        'StrSql = StrSql + "ORDER BY "BOM_D"."MODEL_NO", "BOM_D"."Revision", "BOM_D"."PART_NO", "BOM_D"."P_LEVEL""

        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"BOM_M")
        GridControl1.DataSource=resExePagedDataSet.Tables("BOM_M").DefaultView
        GridControl1.DataBind()
    end sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            e.item.cells(1).text = format(cdec(e.item.cells(1).text),"##,##0.00000")
            e.item.cells(2).text = format(cdec(e.item.cells(2).text),"####0.00")
            e.item.cells(0).text = e.item.cells(0).text & " (Rev. " & e.item.cells(2).text & ") "
        End if
    End Sub

    Sub ShowDetails(s as object,e as DataGridCommandEventArgs)

        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim Script As New System.Text.StringBuilder


        if e.commandArgument = "BOMCost" then

            ReqCOM.ExecuteNonQuery("update bom_d set bom_d.wac_cost_rpt = part_master.wac_cost from part_master where part_master.part_no = bom_d.part_no")
            ReqCOM.ExecuteNonQuery("Update bom_d set wac_cost_rpt = 0 where wac_cost_rpt is null")

            ReqCOM.ExecuteNonQuery("update bom_d set bom_d.ven_name_rpt = part_source.ven_code from part_source where part_source.part_no = bom_d.part_no and part_source.ven_seq = 1")
            ReqCOM.ExecuteNonQuery("Update bom_d set part_up_rpt = 0 where part_up_rpt is null")
            Script.Append("<script language=javascript>")
            Script.Append("pupUp=window.open('popupReportViewer.aspx?RptName=BOMCost&ModelNo=" & trim(e.item.cells(3).text) & "&Revision=" & cdec(e.item.cells(2).text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=700,height=250');")
            Script.Append("</script" & ">")
            RegisterStartupScript("NewPopUp", Script.ToString())

        end if
    end sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">BOM
                                COST</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PageSize="20" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False" OnItemCommand="ShowDetails">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="Model_No" HeaderText="Model No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="TotalCost" HeaderText="BOM Cost"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Revision" HeaderText="Revision" visible="false"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Model_No" HeaderText="Model No" visible="false"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton id="BOMCost" CommandArgument='BOMCost' runat="server" Font-Size="X-Small" ForeColor="Red" Font-Bold="True">BOM Cost Details</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
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
