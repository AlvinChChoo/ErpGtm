<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
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
            LoadData
            procLoadGridData ()
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select ps.up_app_date,ps.ori_ven_name,ps.ori_up,ps.ori_curr_code,V.Curr_Code,PS.VEN_SEQ, PS.CANCEL_LT,PS.RESCHEDULE_LT,PS.UP_APP_NO, PS.MODIFY_DATE, PS.Lead_Time,PS.SEQ_NO,PS.UP,PS.Modify_By,PS.Std_Pack_Qty,PS.Min_Order_Qty,V.Ven_name as [Vendor],ps.part_no from Part_Source PS,Vendor v where PS.Part_No = '" & trim(lblPartNo.text) & "' and PS.Ven_Code = V.Ven_Code ORDER BY PS.VEN_SEQ ASC"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_source")
        GridControl1.DataSource=resExePagedDataSet.Tables("Part_source").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub LoadData
        Dim strSql as string = "SELECT * FROM Part_Master WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
        Dim PartType,TariffCode,ObsolutePart,UOM as string
        do while ResExeDataReader.read
            lblPartNo.text = ResExeDataReader("Part_No").tostring
            lblSpecification.text= ResExeDataReader("Part_Spec").tostring
            lblPartType.text = ResExeDataReader("Part_Type").tostring  & " / " & ResExeDataReader("Part_Desc").tostring
            lblMfgPartNo.text = ResExeDataReader("M_Part_No").tostring
            lblWAC.text = "RM " & format(cdec(ResExeDataReader("WAC_Cost").tostring),"##,##0.00000")
            lblStdCost.text = "RM " & format(cdec(ResExeDataReader("Std_Cost_rd").tostring),"##,##0.00000")
            lblOriStdCost.text = format(cdec(ResExeDataReader("Ori_Std_Cost_rd").tostring),"##,##0.00000")
            lblCurrCode.text = ResExeDataReader("std_cost_rd_Curr_Code").tostring
        loop
    End sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("PartSourceAddNew.aspx?ID=" + request.params("ID").tostring)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim UPADate As Label = CType(e.Item.FindControl("UPADate"), Label)
            Dim OriUP As Label = CType(e.Item.FindControl("OriUP"), Label)
            Dim UPAPPDate As Label = CType(e.Item.FindControl("UPAPPDate"), Label)
    
            e.Item.Cells(4).Text = cint(e.Item.Cells(4).Text)
            e.Item.Cells(5).Text = format(cdec(e.Item.Cells(5).Text),"####0")
            UPAPPDate.text = format(cdate(UPAPPDate.text),"dd/MM/yy")
    
            if trim(OriUP.text) = "" then OriUP.text = ""
            if trim(OriUP.text) <> 0 then OriUP.text = format(cdec(OriUP.text),"##,##0.00000")
            if trim(OriUP.text) = 0 then OriUP.text = ""
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("PartSource.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
            <tbody>
                <tr>
                    <td>
                        <div align="center">
                            <ERP:HEADER id="UserControl1" runat="server"></ERP:HEADER>
                        </div>
                        <div align="center">
                            <p>
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="28" background="Frame-Top-left.jpg" height="28">
                                                            </td>
                                                            <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                Part Source List</td>
                                                            <td width="28" background="Frame-Top-right.jpg">
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <br />
                                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="80%" align="center" border="1">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td width="25%" bgcolor="silver">
                                                                                <p>
                                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="112px">Part No</asp:Label>
                                                                                </p>
                                                                            </td>
                                                                            <td colspan="3">
                                                                                <p>
                                                                                    <asp:Label id="lblPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                </p>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td bgcolor="silver">
                                                                                <p>
                                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Part Type / Description</asp:Label>
                                                                                </p>
                                                                            </td>
                                                                            <td colspan="3">
                                                                                <p>
                                                                                    <asp:Label id="lblPartType" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                </p>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td bgcolor="silver">
                                                                                <p>
                                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Specification</asp:Label>
                                                                                </p>
                                                                            </td>
                                                                            <td colspan="3">
                                                                                <p>
                                                                                    <asp:Label id="lblSpecification" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                </p>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td bgcolor="silver">
                                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Mfg. Part No</asp:Label></td>
                                                                            <td colspan="3">
                                                                                <asp:Label id="lblMfgPartNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td bgcolor="silver">
                                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal">WAC</asp:Label></td>
                                                                            <td colspan="3">
                                                                                <p>
                                                                                    <asp:Label id="lblWAC" runat="server" cssclass="OutputText" width="100%"></asp:Label>
                                                                                </p>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td bgcolor="silver">
                                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Ori. Std Cost</asp:Label></td>
                                                                            <td colspan="3">
                                                                                <asp:Label id="lblOriStdCost" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td bgcolor="silver">
                                                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Curr Code</asp:Label></td>
                                                                            <td colspan="3">
                                                                                <asp:Label id="lblCurrCode" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td bgcolor="silver">
                                                                                <p>
                                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Std. Cost</asp:Label>
                                                                                </p>
                                                                            </td>
                                                                            <td colspan="3">
                                                                                <asp:Label id="lblStdCost" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                                <br />
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <br />
                                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="28" background="Frame-Top-left.jpg" height="28">
                                                            </td>
                                                            <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                Part Source List</td>
                                                            <td width="28" background="Frame-Top-right.jpg">
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <p>
                                                                    <br />
                                                                </p>
                                                                <p align="center">
                                                                    <asp:DataGrid id="GridControl1" runat="server" width="96%" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" Font-Size="XX-Small" Font-Names="Verdana" Font-Name="Verdana" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" PageSize="20" BorderColor="Gray" cellpadding="4" AutoGenerateColumns="False">
                                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                        <Columns>
                                                                            <asp:BoundColumn DataField="Ven_Seq"></asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Vendor" HeaderText="SUPPLIER"></asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Curr_Code" HeaderText="Curr."></asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="UP" HeaderText="U/P">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Std_Pack_Qty" HeaderText="SPQ">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Min_Order_Qty" HeaderText="MOQ">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Lead_Time" HeaderText="L/T">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                            </asp:BoundColumn>
                                                                            <asp:TemplateColumn HeaderText="UPA Date">
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="UPAppDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP_APP_DATE") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:BoundColumn DataField="UP_APP_NO" HeaderText="APP. NO">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Cancel_LT" HeaderText="CANC.">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Reschedule_LT" HeaderText="RE-SCH">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="ori_Ven_Name" HeaderText="Ori. Supp.">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                            </asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="Ori_Curr_Code" HeaderText="Ori. Curr Code">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                            </asp:BoundColumn>
                                                                            <asp:TemplateColumn HeaderText="Ori. UP">
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="OriUP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ori_UP") %>' /> 
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                        </Columns>
                                                                    </asp:DataGrid>
                                                                </p>
                                                                <p>
                                                                    <br />
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <br />
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="189px" Text="Back"></asp:Button>
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
                        </div>
                        <footer:footer id="footer" runat="server"></footer:footer>
                    </td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
