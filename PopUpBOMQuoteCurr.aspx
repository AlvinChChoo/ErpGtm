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
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            lblBOMQuoteNo.text = ReqCOM.GetFieldVal("select BOM_Quote_No from BOM_Quote_M where seq_no = " & trim(request.params("ID")) & ";","BOM_Quote_No")
            ProcLoadCurr()
        End if
    End Sub
    
    Sub ProcLoadCurr()
        Dim StrSql as string = "Select * from BOM_Quote_Curr where BOM_Quote_No = '" & trim(lblBOMQuoteNo.text) & "'"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"BOM_Quote_Curr")
        dtgCurr.DataSource=resExePagedDataSet.Tables("BOM_Quote_Curr").DefaultView
        dtgCurr.DataBind()
    end sub
    
    Sub dtgCurr_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">Currency Table</asp:Label>
                            </p>
                            <p align="left">
                                <asp:Label id="lblBOMQuoteNo" runat="server" visible="False"></asp:Label>
                            </p>
                            <p align="center">
                                <asp:DataGrid id="dtgCurr" runat="server" OnSelectedIndexChanged="dtgCurr_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black">
                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="Code">
                                            <ItemTemplate>
                                                <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CURR_CODE") %>' /> 
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="CURR_DESC" HeaderText="Description"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="UNIT_CONV" HeaderText="Unit Conversion" DataFormatString="{0:F}">
                                            <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                            <ItemStyle horizontalalign="Right"></ItemStyle>
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="Rate" HeaderText="Rate to RM">
                                            <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                            <ItemStyle horizontalalign="Right"></ItemStyle>
                                        </asp:BoundColumn>
                                        <asp:BoundColumn DataField="US_DLR" HeaderText="Rate to USD">
                                            <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                            <ItemStyle horizontalalign="Right"></ItemStyle>
                                        </asp:BoundColumn>
                                        <asp:TemplateColumn Visible="False" HeaderText="Remove">
                                            <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                            <ItemStyle horizontalalign="Center"></ItemStyle>
                                            <ItemTemplate>
                                                <center>
                                                    <asp:CheckBox id="Remove" runat="server" />
                                                </center>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                </asp:DataGrid>
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
