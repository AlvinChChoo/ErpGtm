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
                     Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                     Dim rsRequest as SQLDataReader = ReqCOM.ExeDataReader("Select * from ISSUING_M where seq_no = " & request.params("ID") & ";")
    
                     do while rsRequest.read
                         lblRequestNo.text = rsRequest("ISSUING_NO").tostring
                         lblLevel.text = rsRequest("P_LEVEL").tostring
                         lblLotNo.text = rsRequest("Lot_No").tostring
                         lblReqLotSize.text = rsRequest("LOT_SIZE").tostring
    
                         lblApp1By.text = rsRequest("App1_by").tostring
                         lblApp1Date.text = rsRequest("App1_Date").tostring
                         lblApp2By.text = rsRequest("App2_By").tostring
                         lblApp2Date.text = rsRequest("App2_Date").tostring
                     Loop
    
                    Dim rsSO as SQLDataReader = ReqCOM.ExeDataReader("Select * from SO_Model_M where Lot_No = '" & trim(lbllotNo.text) & "';")
                    Do while rsSo.read
                        lblModelNo.text = rsSO("Model_No").tostring
                        lblBOMRev.text = rsSO("BOM_Rev").tostring
                        lblBOMDate.text = rsSO("BOM_Date").tostring
                    Loop
    
                    'if lblApp1By.text <> "" then cmdSubmit.visible = false
    
                    RsSO.Close()
                    rsRequest.close()
                    procLoadGridData()
                 end if
             End Sub
    
    
         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
         Sub ProcLoadGridData()
             Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
             Dim StrSql as string = "Select pm.part_spec,pm.m_part_no,req.part_no,req.req_qty,pm.part_desc from ISSUING_D req, part_master pm where req.part_no = pm.part_no and req.ISSUING_NO = '" & trim(lblRequestNo.text) & "';"
             Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"ISSUING_D")
    
             dtgPartList.visible = true
             dtgPartList.DataSource=resExePagedDataSet.Tables("ISSUING_D").DefaultView
             dtgPartList.DataBind()
         end sub
    
         Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
    
         End Sub
    
         Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
    
         End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("LotMaterialRequestForm.aspx")
    End Sub
    
    'Sub cmdSubmit_Click(sender As Object, e As EventArgs)
    '    Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    '    ReqCOM.ExecuteNonQuery("Update Lot_Mat_Req_M set Approve1_By = '" & trim(request.cookies("U_ID").value) & "', Approve1_Date = '" & now & "' where seq_no = " & request.params("ID") & ";")
    '    Response.redirect("LotMaterialRequestFormDet.aspx?ID=" & Request.params("ID"))
    'End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">LOT MATERIAL
                                REQUEST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:Label id="lblValQty" runat="server" width="100%" cssclass="ErrorText" visible="False">Please
                                                    re-confirm the on hold qty for the highlighted item(s).</asp:Label>
                                                </p>
                                                <table style="HEIGHT: 9px" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label9" runat="server" width="126px" cssclass="LabelNormal">Request
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblRequestNo" runat="server" width="223px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label1" runat="server" width="126px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                            <td>
                                                                &nbsp;<asp:Label id="lblLotNo" runat="server" width="223px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label5" runat="server" width="126px" cssclass="LabelNormal">Level</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLevel" runat="server" width="223px" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label4" runat="server" width="126px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" width="126px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label10" runat="server" width="126px" cssclass="LabelNormal">Req. Lot
                                                                Size</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblReqLotSize" runat="server" width="223px" cssclass="OutputText"></asp:Label><asp:Label id="lblBOMRev" runat="server" width="126px" cssclass="OutputText" visible="False"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label8" runat="server" width="126px" cssclass="LabelNormal" visible="False">BOM
                                                                Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblBOMDate" runat="server" width="382px" cssclass="OutputText" visible="False"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label12" runat="server" width="153px" cssclass="LabelNormal">Request
                                                                App By / Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                -&nbsp; <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label13" runat="server" width="156px" cssclass="LabelNormal">PCMC App
                                                                By / Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                -&nbsp; <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p align="center">
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartList" runat="server" width="100%" OnSortCommand="SortGrid" AllowSorting="True" Height="35px" Font-Names="Verdana" PageSize="100" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Part No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="PART_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Part_Spec" HeaderText="Specification"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="M_Part_No" HeaderText="Mfg. Part No."></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Req_Qty" HeaderText="Req Qty.">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CausesValidation="False" Text="Back" Width="181px"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
        <p align="left">
        </p>
    </form>
</body>
</html>
