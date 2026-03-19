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
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        lblFECNNo.text = ReqCOM.GEtFieldVal("Select FECN_No from FECN_M where Seq_no = " & trim(Request.params("ID")) & ";","FECN_No")
        ProcLoadAtt
    End Sub
    
    Sub ProcLoadAtt()
        Dim StrSql as string = "Select * from fecn_ATTACHMENT where fecn_NO = '" & trim(lblfecnNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"fecn_ATTACHMENT")
        dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("fecn_ATTACHMENT").DefaultView
        dtgUPASAttachment.DataBind()
    end sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<p align="center">
    <asp:Label id="Label2" runat="server" width="100%" cssclass="SectionHeader">FECN ATTACHMENT</asp:Label> 
    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
        <tbody>
            <tr>
                <td>
                    <p>
                        <asp:Label id="lblFECNNo" runat="server" visible="False"></asp:Label>
                    </p>
                    <p>
                        <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" PageSize="50" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged">
                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                            <ItemStyle cssclass="GridItem"></ItemStyle>
                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                            <Columns>
                                <asp:TemplateColumn visible="false">
                                    <ItemTemplate>
                                        <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadFECNAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                            </Columns>
                        </asp:DataGrid>
                    </p>
                </td>
            </tr>
        </tbody>
    </table>
</p>
<p align="center">
</p>