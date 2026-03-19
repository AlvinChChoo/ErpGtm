
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
                lblIssuingNo.text = ReqCOM.GetDocumentNo("Issuing_No")
                dissql ("Select Lot_No from SO_Model_M where bom_rev is not null","Lot_No","Lot_No",cmbLotNo)
                ShowModelDet
                dissql ("Select distinct(P_Level) as [P_Level] from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Revision = " & lblBOMRev.text & ";","P_Level","P_Level",cmbLevel)
            end if
        End Sub

    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
            Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)

            with obj
                .items.clear
                .DataSource = ResExeDataReader
                .DataValueField = FValue
                .DataTextField = FText
                .DataBind()
            end with
            ResExeDataReader.close()
        End Sub

     Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)

            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
                Dim Usage As Label = CType(e.Item.FindControl("Usage"), Label)
                Dim LotQty As Label = CType(e.Item.FindControl("LotQty"), Label)
                Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
                Dim IssuedQty As Label = CType(e.Item.FindControl("IssuedQty"), Label)
                Dim MRBRet As Label = CType(e.Item.FindControl("MRBRet"), Label)
                Dim MRBRej As Label = CType(e.Item.FindControl("MRBRej"), Label)
                Dim MRBScrap As Label = CType(e.Item.FindControl("MRBScrap"), Label)
                Dim OtherScrap As Label = CType(e.Item.FindControl("OtherScrap"), Label)
                Dim SpecialReq As Label = CType(e.Item.FindControl("SpecialReq"), Label)
                Dim BalToIss As Label = CType(e.Item.FindControl("BalToIss"), Label)

                LotQty.text = Usage.text * lblLotSize.text

                IssuedQty.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(cmbLotNo.selecteditem.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'ISSUING'","QtyIssued")
                if IssuedQty.text = "" then IssuedQty.text = "0"

                MRBRet.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(cmbLotNo.selecteditem.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'MRBRET'","QtyIssued")
                if MRBRet.text = "" then MRBRet.text = "0"

                MRBRej.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(cmbLotNo.selecteditem.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'MRBREJ'","QtyIssued")
                if MRBRej.text = "" then MRBRej.text = "0"

                MRBScrap.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(cmbLotNo.selecteditem.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'MRBSCRAP'","QtyIssued")
                if MRBScrap.text = "" then MRBScrap.text = "0"

                OtherScrap.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(cmbLotNo.selecteditem.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'OTHERSCRAP'","QtyIssued")
                if OtherScrap.text = "" then OtherScrap.text = "0"

                SpecialReq.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(cmbLotNo.selecteditem.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'SPECIALREQ'","QtyIssued")
                if SpecialReq.text = "" then SpecialReq.text = "0"

                BalToIss.text = LotQty.text - IssuedQty.text + MRBRet.text + MRBRej.text + MRBScrap.text + OtherScrap.text + SpecialReq.text
            End if
        End Sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub

    Sub cmdSave_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string

        StrSql = "Insert into MAT_ISS_M(ISSUING_NO,LOT_NO,P_LEVEL,CREATE_BY,CREATE_DATE) "
        StrSql = StrSql + "Select '" & trim(lblIssuingNo.text) & "','" & trim(cmbLotNo.selectedItem.value) & "','" & trim(cmbLevel.selectedItem.value) & "','" & trim(request.cookies("U_ID").value) & "','" & now & "';"
        ReqCOM.ExecuteNonQuery(StrSql)

        ReqCOM.executeNonQuery("Update Main set Issuing_No = Issuing_NO + 1")
        response.redirect("PartIssuingAddNew1.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from Mat_Iss_m","Seq_No"))
    End Sub

    Sub cmbLotNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        dissql ("Select distinct(P_Level) as [P_Level] from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Revision = " & lblBOMRev.text & ";","P_Level","P_Level",cmbLevel)
        ShowModelDet
    End Sub

    Sub ShowModelDet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM

        lblModelNo.text = ""
        lblLotSize.text = ""
        lblBOMRev.text = ""
        lblColor.text = ""
        lblPacking.text = ""
        lblBOMDate.text = ""

        Dim RsSO as SQLDataReader = ReqCOM.ExeDataReader("Select * from SO_Model_M where Lot_No = '" & cmbLotNo.selectedItem.text & "';")

        Do while rsSo.read
            lblModelNo.text = rsSO("Model_No").tostring
            lblLotSize.text = rsSO("Order_Qty").tostring
            lblBOMRev.text = rsSO("BOM_Rev").tostring

            lblColor.text = rsSO("Color_Desc").tostring
            lblPacking.text = rsSO("Pack_Code").tostring
            lblBOMDate.text = rsSO("BOM_Date").tostring
        Loop
        RsSO.Close
    End sub

    Sub cmbLevel_SelectedIndexChanged(sender As Object, e As EventArgs)

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
                                <asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">MATERIAL ISSUING</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" CssClass="ErrorText" ControlToValidate="cmbLotNo" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Lot No." Width="100%"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" CssClass="ErrorText" ControlToValidate="cmbLevel" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Level." Width="100%"></asp:RequiredFieldValidator>
                                                </p>
                                                <table style="HEIGHT: 9px" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label9" runat="server" width="126px" cssclass="LabelNormal">Issuing
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblIssuingNo" runat="server" width="223px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label1" runat="server" width="126px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbLotNo" runat="server" CssClass="OutputText" Width="186px" autopostback="true" OnSelectedIndexChanged="cmbLotNo_SelectedIndexChanged"></asp:DropDownList>
                                                                &nbsp;&nbsp;&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label5" runat="server" width="126px" cssclass="LabelNormal">Level</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbLevel" runat="server" CssClass="OutputText" Width="186px" OnSelectedIndexChanged="cmbLevel_SelectedIndexChanged"></asp:DropDownList>
                                                                &nbsp;&nbsp;&nbsp;&nbsp;
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
                                                                <asp:Label id="Label2" runat="server" width="126px" cssclass="LabelNormal">Lot Size</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotSize" runat="server" width="126px" cssclass="OutputText"></asp:Label><asp:Label id="lblBOMRev" runat="server" width="126px" cssclass="OutputText" visible="False"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label6" runat="server" width="126px" cssclass="LabelNormal">Color</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblColor" runat="server" width="382px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label7" runat="server" width="126px" cssclass="LabelNormal">Packing</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPacking" runat="server" width="382px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label8" runat="server" width="126px" cssclass="LabelNormal">BOM Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblBOMDate" runat="server" width="382px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="181px" Text="Save as new issuing"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="181px" Text="Back"></asp:Button>
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
