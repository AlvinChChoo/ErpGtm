<%@ Control Language="VB" Debug="true" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.ispostback = false then ProcLoadGridData()
        End Sub
    
        Sub ProcLoadGridData()
            Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
            Dim MRFNo as string
            MRFNo = ReqCOM.GetFieldVal("select MRF_No from mrf_m where seq_no = " & clng(request.params("ID")) & ";","MRF_No")
            Dim StrSql as string = "Select ISS.Main_Alt,ISS.Qty_Reissue,iss.P_Location,iss.Qty_other_Scrap,iss.type,iss.seq_no,iss.extra_req,iss.total_usage,iss.total_issued,iss.main_part,iss.qty_scrap,iss.qty_store,iss.qty_ir,iss.return_type,iss.rem,iss.qty_return,ISS.Part_No,ISS.Qty_Issued,PM.Part_Desc from MRF_D ISS,Part_Master PM where ISS.MRF_NO = '" & trim(MRFNo) & "' and ISS.PART_No = PM.Part_No order by main_part,main_alt desc"
    
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"Issuing_D")
            dtgShortage.DataSource=resExePagedDataSet.Tables("Issuing_D").DefaultView
            dtgShortage.DataBind()
        end sub
    
                 Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
                 If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                     Dim TotalUsage As Label = CType(e.Item.FindControl("TotalUsage"), Label)
                     Dim TotalIssued As Label = CType(e.Item.FindControl("TotalIssued"), Label)
                     Dim MainAlt As Label = CType(e.Item.FindControl("MainAlt"), Label)
                     Dim ExtraIssued As Label = CType(e.Item.FindControl("ExtraIssued"), Label)
                     Dim Type As Label = CType(e.Item.FindControl("Type"), Label)
                     'Dim QtyToStore As textbox = CType(e.Item.FindControl("QtyToStore"), textbox)
                     'Dim QtyToIR As textbox = CType(e.Item.FindControl("QtyToIR"), textbox)
                     'Dim QtyScrap As textbox = CType(e.Item.FindControl("QtyScrap"), textbox)
    
                     'if trim(TotalIssued.text) = "" then TotalIssued.text = "0"
                     'if trim(TotalUsage.text) = "" then TotalUsage.text = "0"
    
                     'ExtraIssued.text = clng(TotalIssued.text) - clng(TotalUsage.text)
                     'if clng(ExtraIssued.text) < 0 then ExtraIssued.text = "0"
    
                     'if trim(lblSubmitBy.text) = "" then
                     '    QtyToIR.text = "0"
                     '    QtyScrap.text = "0"
                     'End if
    
    
                     if ucase(MainAlt.text) = "ALT." then e.Item.CssClass = "IssuingListAltPart"
                     if ucase(MainAlt.text) = "MAIN" then e.Item.CssClass = "IssuingListMainPart"
                 End if
             End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<asp:DataGrid id="dtgShortage" runat="server" width="100%" Height="35px" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Font-Size="XX-Small" Font-Names="Verdana" BorderColor="Black" GridLines="None" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" OnItemDataBound="FormatRow">
    <FooterStyle cssclass="GridFooter"></FooterStyle>
    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
    <ItemStyle cssclass="GridItem"></ItemStyle>
    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
    <Columns>
        <asp:TemplateColumn HeaderText="Main Part">
            <ItemTemplate>
                <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> <asp:Label id="MainAlt" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Main_Alt") %>' /> <asp:Label id="MainPart" runat="server" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART") %>' /> 
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Part Return / Description">
            <ItemTemplate>
                <asp:Label id="PartNo" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' /> - <asp:Label id="PartDesc" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Total Return">
            <HeaderStyle horizontalalign="Right"></HeaderStyle>
            <ItemStyle horizontalalign="Right"></ItemStyle>
            <ItemTemplate>
                <asp:Label id="QtyReturn" cssclass="OutputText" runat="server" align="right" width= "80px" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Return") %>' /> 
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Good">
            <HeaderStyle horizontalalign="Right"></HeaderStyle>
            <ItemStyle horizontalalign="Right"></ItemStyle>
            <ItemTemplate>
                <asp:Label id="QtyToStore" runat="server" width= "50px" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Store") %>' /> 
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="IR">
            <HeaderStyle horizontalalign="Right"></HeaderStyle>
            <ItemStyle horizontalalign="Right"></ItemStyle>
            <ItemTemplate>
                <asp:Label id="QtyToIR" runat="server" width= "50px" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Qty_IR") %>' /> 
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Scrap">
            <HeaderStyle horizontalalign="Right"></HeaderStyle>
            <ItemStyle horizontalalign="Right"></ItemStyle>
            <ItemTemplate>
                <asp:Label id="QtyScrap" runat="server" width= "50px" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Scrap") %>' /> 
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Others">
            <HeaderStyle horizontalalign="Right"></HeaderStyle>
            <ItemStyle horizontalalign="Right"></ItemStyle>
            <ItemTemplate>
                <asp:Label id="QtyOtherScrap" runat="server" width= "50px" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Other_Scrap") %>' /> 
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn Visible="False">
            <ItemTemplate>
                <asp:Label id="Type" runat="server" width= "50px" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Type") %>' /> 
            </ItemTemplate>
        </asp:TemplateColumn>
    </Columns>
</asp:DataGrid>