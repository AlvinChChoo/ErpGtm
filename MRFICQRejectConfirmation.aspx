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
            ShowModelDet
            ProcLoadGridData()
        end if
    End Sub

    Sub ProcLoadGridData()
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim StrSql as string = "Select ISS.Part_No,ISS.Qty_Issued,PM.Part_Desc from Issuing_D ISS,Part_Master PM where ISS.Lot_No = '" & trim(lblLotNo.text) & "' and ISS.P_Level = '" & trim(lblLevel.text) & "' and ISS.PART_No = PM.Part_No"

        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"Issuing_D")
        dtgShortage.DataSource=resExePagedDataSet.Tables("Issuing_D").DefaultView
        dtgShortage.DataBind()
    end sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
    End Sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub ShowModelDet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
        lblLotNo.text = ""
        lblLevel.text = ""
        lblModelNo.text = ""
        lblLotSize.text = ""
        lblColor.text = ""
        lblPacking.text = ""
        lblBOMDate.text = ""

        lblMRFNo.text = ReqCOM.GetFieldVal("Select MRF_NO from MRF_M where SEQ_NO = " & request.params("ID") & ";","MRF_NO")
        lblLotNo.text = ReqCOM.GetFieldVal("Select Lot_No from MRF_M where SEQ_NO = " & request.params("ID") & ";","Lot_No")
        lblLevel.text = ReqCOM.GetFieldVal("Select P_Level from MRF_M where Seq_No = " & request.params("ID") & ";","P_Level")
            Dim RsSO as SQLDataReader = ReqCOM.ExeDataReader("Select * from SO_Model_M where Lot_No = '" & trim(lblLotNo.text) & "';")
            Do while rsSo.read
                lblModelNo.text = rsSO("Model_No").tostring
                lblLotSize.text = rsSO("Order_Qty").tostring
                lblColor.text = rsSO("Color_Desc").tostring
                lblPacking.text = rsSO("Pack_Code").tostring
                lblBOMDate.text = rsSO("BOM_Date").tostring
            Loop
            RsSO.Close
    End sub

    Sub cmdConfirm_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.executeNonQuery("Update MRF_M set PROD_App = 'No', IQC_APP = 'NO' where MRF_NO = '" & trim(lblMRFNo.text) & "'")
        Response.redirect("MRF.aspx")
    End Sub

    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("MRFIQC.aspx?ID=" & Request.params("ID"))
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
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">MATERIAL ISSUING</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="HEIGHT: 9px" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="126px">MRF NO</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblMRFNo" runat="server" cssclass="OutputText" width="126px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="126px">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="126px"></asp:Label>&nbsp;&nbsp;&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="126px">Level</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLevel" runat="server" cssclass="OutputText" width="126px"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
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
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="126px">Color</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblColor" runat="server" cssclass="OutputText" width="382px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="126px">Packing</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPacking" runat="server" cssclass="OutputText" width="382px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="126px">BOM Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblBOMDate" runat="server" cssclass="OutputText" width="382px"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" Height="35px" Font-Names="Verdana" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="PART NO">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Qty. To Return">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="ToReturn" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Issued") %>' width="48px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 23px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="cmdConfirm" onclick="cmdConfirm_Click" runat="server" Text="Reject this MRF" Width="150px"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Text="Cancel" Width="150px"></asp:Button>
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
