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
        if page.ispostback = false then ProcLoadGridData
    End Sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "Select bm.model_no,bm.Revision,sum(bd.p_usage * pm.std_cost_rd) as [TotalCost] from part_master pm,bom_m bm, bom_d bd where bm.model_no = bd.model_no and bm.revision = bd.revision and pm.part_no = bd.part_no and bm.ind='Y' group by bm.model_no,bm.revision"
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"BOM_M")
        GridControl1.DataSource=resExePagedDataSet.Tables("BOM_M").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ModelNo as string = ReqCom.GetFieldVal("Select Model_No from FECN_M where FECN_No = '" & trim(request.params("FECNNo")) & "';","Model_No")
        Dim lblModelNo As Label
        Dim Var As Label
        Dim TotalCostC As Label
        Dim TotalCostN As Label
    
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            lblModelNo = CType(e.Item.FindControl("ModelNo"), Label)
    
            Var = CType(e.Item.FindControl("Var"), Label)
    
            TotalCostC = CType(e.Item.FindControl("TotalCostC"), Label)
            TotalCostN = CType(e.Item.FindControl("TotalCostN"), Label)
    
            if trim(lblModelNo.text) = trim(ModelNo) then TotalCostN.text = GetBomCost (Request.params("FECNNo"))
    
            TotalCostC.text = format(cdec(TotalCostC.text),"##,##0.00000")
            TotalCostN.text = format(cdec(TotalCostN.text),"##,##0.00000")
            e.item.cells(0).text = e.item.cells(0).text & " (Rev. " & e.item.cells(4).text & ") "
            Var.text = format(cdec(TotalCostN.text) - cdec(TotalCostC.text),"##,##0.00000")
        End if
    End Sub
    
    Sub ShowDetails(s as object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim Script As New System.Text.StringBuilder
        Dim FECNModelNo as string = ReqCOM.GetFieldVal("Select Model_No from FECN_M where fecn_no = '" & trim(request.params("FecnNo")) & "';","Model_No")
        Dim ModelNo As Label = CType(e.Item.FindControl("ModelNo"), Label)
        if e.commandArgument = "BOMCost" then
            if trim(FECNModelNo) = trim(ModelNo.text) then
                GetBOMCost (Request.params("FECNNo"))
                Script.Append("<script language=javascript>")
                Script.Append("pupUp=window.open('popupReportViewer.aspx?RptName=FECNBomCost1&ModelNo=" & trim(ModelNo.text) & "&Revision=" & cdec(e.item.cells(5).text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=700,height=250');")
                Script.Append("</script" & ">")
                RegisterStartupScript("NewPopUp", Script.ToString())
            Else
                GetBOMCost1 (ModelNo.text)
                Script.Append("<script language=javascript>")
                Script.Append("pupUp=window.open('popupReportViewer.aspx?RptName=FECNBomCost1&ModelNo=" & trim(ModelNo.text) & "&Revision=" & cdec(e.item.cells(5).text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=700,height=250');")
                Script.Append("</script" & ">")
                RegisterStartupScript("NewPopUp", Script.ToString())
            end if
        end if
    end sub
    
    public function GetBomCost(FECNNo as string) as decimal
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim ModelNo as string = ReqCOM.GetFieldVal("Select Model_No from FECN_M where FECN_No = '" & trim(FECNNo) & "';","Model_No")
        Dim BomRev as decimal = ReqCOM.GetFieldVal("Select top 1 revision from bom_M where Model_No = '" & trim(ModelNo) & "' order by revision desc","revision")
        Dim strSql as string
        Dim rs as SqldataReader = ReqCom.ExeDataReader("Select * from FECN_D where FECN_No = '" & trim(FECNNo) & "';")
        ReqCOM.ExecuteNonQuery ("TRUNCATE TABLE fecn_bom_comparison")
        ReqCOM.ExecuteNonQuery ("insert into fecn_bom_comparison(MODEL_NO,PART_NO,P_LEVEL,P_USAGE,P_USAGE1) select MODEL_NO,PART_NO,P_LEVEL,P_USAGE,p_usage from bom_d where model_no = '" & trim(ModelNo) & "' and Revision = " & BomRev & ";")
    
        do while rs.read
            if trim(rs("TYPE_CHANGE")) = "Add Main Part" then
                Strsql = "insert into fecn_bom_comparison(MODEL_NO,PART_NO,P_USAGE,P_USAGE1) select '" & trim(ModelNo) & "',Main_Part,0,P_Usage from fecn_d where Seq_No = " & rs("Seq_No") & ";"
                reqCOM.ExecuteNonQuery(StrSql)
            end if
    
            if trim(rs("TYPE_CHANGE")) = "Remove Main Part" then
                StrSql = "Update FECN_BOM_COMPARISON set P_USAGE1 = 0 where Part_No = '" & trim(rs("main_Part_b4")) & "';"
                reqCOM.ExecuteNonQuery(StrSql)
            end if
    
            if trim(rs("TYPE_CHANGE")) = "Edit Main Part" then
                if trim(rs("main_part_b4")) = trim(rs("main_part")) then
                    StrSql = "Update FECN_BOM_COMPARISON set P_USAGE1 = " & RS("P_Usage") & " where Part_No = '" & trim(rs("main_Part")) & "';"
                    reqCOM.ExecuteNonQuery(StrSql)
                end if
    
                if trim(rs("main_part_b4")) <> trim(rs("main_part")) then
                    StrSql = "Update FECN_BOM_COMPARISON set P_USAGE1 = 0 where Part_No = '" & trim(rs("main_Part_b4")) & "';"
                    reqCOM.ExecuteNonQuery(StrSql)
                    StrSql = "Insert into FECN_BOM_COMPARISON(MODEL_NO,PART_NO,P_LEVEL,P_USAGE,Revision,P_USAGE1) "
                    StrSql = StrSql + "Select '" & trim(ModelNo) & "','" & trim(rs("main_Part")) & "','" & trim(rs("P_Level")) & "',0,0," & rs("P_Usage") & ";"
                    reqCOM.ExecuteNonQuery(StrSql)
                end if
            end if
        loop
        ReqCom.ExecuteNonQuery("update FECN_BOM_COMPARISON set FECN_BOM_COMPARISON.std_cost_a = part_master.std_cost_rd from FECN_BOM_COMPARISON,part_master where FECN_BOM_COMPARISON.part_no = part_master.part_no")
        GetBomCost = ReqCOM.GetFieldVal("Select sum(Std_Cost_A * P_Usage1) as [TotalCost] from FECN_BOM_COMPARISON","TotalCost")
    End Function
    
    Sub GetBOMCost1(ModelNo as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim BomRev as decimal = ReqCOM.GetFieldVal("Select top 1 revision from bom_M where Model_No = '" & trim(ModelNo) & "' order by revision desc","revision")
        Dim strSql as string
        ReqCOM.ExecuteNonQuery ("TRUNCATE TABLE fecn_bom_comparison")
        ReqCOM.ExecuteNonQuery ("insert into fecn_bom_comparison(MODEL_NO,PART_NO,P_LEVEL,P_USAGE,P_USAGE1) select MODEL_NO,PART_NO,P_LEVEL,P_USAGE,p_usage from bom_d where model_no = '" & trim(ModelNo) & "' and Revision = " & BomRev & ";")
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
                                <asp:Label id="Label1" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">BOM
                                COST</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemCommand="ShowDetails" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="20" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="Model_No" HeaderText="Model No"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Model No" visible="false" >
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModelNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="R&D Std Cost (C)(RM)" >
                                                                <ItemTemplate>
                                                                    <asp:Label id="TotalCostC" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "TotalCost") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="R&D Std Cost (N)(RM)" >
                                                                <ItemTemplate>
                                                                    <asp:Label id="TotalCostN" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "TotalCost") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Variance (RM)" >
                                                                <ItemTemplate>
                                                                    <asp:Label id="Var" runat="server" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Revision" HeaderText="Revision" visible="false"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Model_No" HeaderText="Model No" visible="false"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="">
                                                                <ItemTemplate>
                                                                    <asp:LinkButton id="BOMCost" CommandArgument='BOMCost' runat="server" Font-Size="X-Small" ForeColor="Red" Font-Bold="True">BOM Cost Details</asp:LinkButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PART NO" visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Model_No" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' /> 
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
