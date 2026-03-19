<%@ Control Language="VB" Debug="true" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=550,height=300');")
        Script.Append("</script" & ">")
        page.RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        lblSNNo.text = ReqCOM.GetFieldVal("select SN_No from Shipping_Notice_M where seq_no = " & clng(request.params("ID")) & ";","SN_No")
        LoadSNItem
    End Sub
    
         Sub FormatRow()
    
         End sub
    
        Sub LoadSNItem()
            Dim strSql as string = "select sn.rem,SN.jo_no,SN.carton_no,SN.Loading_Priority,SN.Pallet_No,SN.Seq_No,JO.Prod_Qty,mm.model_code,mm.model_desc from shipping_notice_d SN,Job_Order_M JO,so_models_m so,model_master mm where so.lot_no = jo.lot_no and mm.model_code = so.model_no and sn.jo_no = jo.jo_no and SN.sn_No = '" & trim(lblSNNo.text) & "';"
    
            Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"shipping_notice_d")
            GridControl1.DataSource=resExePagedDataSet.Tables("shipping_notice_d").DefaultView
            GridControl1.DataBind()
        End sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<p align="center">
    <asp:Label id="Label2" cssclass="SectionHeader" width="100%" runat="server">SHIPPING
    NOTICE DETAILS</asp:Label> 
    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
        <tbody>
            <tr>
                <td>
                    <p>
                        <asp:Label id="lblSNNo" runat="server" visible="False"></asp:Label>
                        <asp:DataGrid id="GridControl1" width="100%" runat="server" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AllowSorting="False" AutoGenerateColumns="False" ShowFooter="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right">
                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                            <ItemStyle cssclass="GridItem"></ItemStyle>
                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                            <Columns>
                                <asp:TemplateColumn Visible="false">
                                    <ItemTemplate>
                                        <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderText="J/O #">
                                    <ItemTemplate>
                                        <asp:Label id="JONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "JO_No") %>' /> 
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderText="Model Desc.">
                                    <ItemTemplate>
                                        <asp:Label id="ModelDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_Desc") %>' /> 
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderText="Ship Qty.">
                                    <ItemTemplate>
                                        <asp:Label id="ProdQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prod_Qty") %>' /> 
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderText="Pallet #">
                                    <ItemTemplate>
                                        <asp:Label id="PalletNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Pallet_No") %>' /> 
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderText="Carton #">
                                    <ItemTemplate>
                                        <asp:Label id="CartonNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Carton_No") %>' /> 
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderText="Loading Prio.">
                                    <ItemTemplate>
                                        <asp:Label id="LoadingPriority" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Loading_Priority") %>' /> 
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderText="Remarks">
                                    <ItemTemplate>
                                        <asp:textbox id="Rem" CssClass="ListOutput" runat="server" width= "200px" ReadOnly="True" TextMode="MultiLine" text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>'></asp:textbox>
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
<p align="center">
</p>