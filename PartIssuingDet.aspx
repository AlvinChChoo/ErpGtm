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
            if page.ispostback = false then procLoadGridData() :ShowModelDet()
    End Sub

    Sub ProcLoadGridData()
        Dim SortSeq as String
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim IssuingNo as string = ReqCOM.GEtFIeldVal("Select ISSUING_NO from MAT_ISS_M where Seq_No = " & request.params("ID") & ";","ISSUING_NO")
        Dim StrSql as string = "Select ISS.PART_NO, ISS.ISSUING_QTY,PM.PART_DESC, PM.PART_SPEC from MAT_ISS_D iss,PART_MASTER PM where iss.ISSUING_NO = " & cint(IssuingNo) & " AND ISS.PART_NO = PM.PART_NO order by pm.Part_No desc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MAT_ISS_M")

        dtgShortage.visible = true
        dtgShortage.DataSource=resExePagedDataSet.Tables("MAT_ISS_M").DefaultView
        dtgShortage.DataBind()
    end sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
        End if
    End Sub

    Sub cmdNew_Click(sender As Object, e As EventArgs)
    End Sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub ShowModelDet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
        Dim RsIssuing as SQLDataReader = ReqCOM.ExeDataReader("Select ISS.CREATE_DATE,ISS.CREATE_BY,ISS.Issuing_No ,ISS.Lot_No ,ISS.P_Level,SO.Model_No ,SO.Lot_No ,SO.Color_Desc ,SO.Pack_Code ,SO.BOM_DATE,SO.Order_Qty,SO.BOM_REV from Mat_Iss_M ISS, So_model_M SO where ISS.Seq_no = " & request.params("ID") & " and ISS.Lot_No = SO.Lot_No")

        Do while RsIssuing.read
            lblIssuingNo.text = RsIssuing("Issuing_No").tostring
            lblLotNo.text = RsIssuing("Lot_No").tostring
            lblLevel.text = RsIssuing("P_Level").tostring
            lblModelNo.text = RsIssuing("Model_No").tostring
            lblLotSize.text = RsIssuing("Order_Qty").tostring
            lblBOMRev.text = RsIssuing("BOM_REV").tostring
            lblColor.text = RsIssuing("Color_Desc").tostring
            lblPacking.text = RsIssuing("Pack_Code").tostring
            lblBOMDate.text = format(RsIssuing("BOM_Date"),"MM/dd/yy")
            lblCreateDate.text = format(RsIssuing("Create_Date"),"MM/dd/yy")
            lblCreateBy.text = ucase(RsIssuing("Create_By").tostring)
        Loop
        RsIssuing.Close
    End sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PartIssuing.aspx")
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">MATERIAL ISSUING
                                DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <table style="HEIGHT: 9px" width="70%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="126px">Issuing
                                                                    No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblIssuingNo" runat="server" cssclass="OutputText" width="223px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="126px">Lot No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="223px"></asp:Label>&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="126px">Level</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLevel" runat="server" cssclass="OutputText" width="223px"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="126px">Model No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="126px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">Lot Size</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLotSize" runat="server" cssclass="OutputText" width="126px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="126px">BOM Rev.</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblBOMRev" runat="server" cssclass="OutputText" width="126px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="126px">Color</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblColor" runat="server" cssclass="OutputText" width="209px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="126px">Packing</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPacking" runat="server" cssclass="OutputText" width="195px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="157px">BOM Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblBOMDate" runat="server" cssclass="OutputText" width="281px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="157px">Created
                                                                    By</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText" width="239px"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label12" runat="server" cssclass="LabelNormal" width="157px">Date Created</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCreateDate" runat="server" cssclass="OutputText" width="251px"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" PageSize="20" Height="35px" Font-Names="Verdana" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="Part No"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Part_Spec" HeaderText="Specification"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="ISSUING_QTY" HeaderText="Qty. Issued">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 25px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="113px" Text="Back"></asp:Button>
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
