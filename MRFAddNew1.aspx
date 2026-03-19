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
                'lblStatus.text = ReqCOM.GetFieldVal("Select Prod_App from MRF_M where MRF_NO = '" & trim(lblMRFNo.text) & "';","Prod_App")
                ProcLoadGridData()
                if trim(lblStatus.text) = "YES" then
                    cmdSave.enabled = false
    '                cmdApproved.enabled = false
                end if
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

         Sub cmdSearch_Click(sender As Object, e As EventArgs)
             ProcLoadGridData()
         End Sub

         Sub ProcLoadGridData()
            Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
            Dim StrSql as string

            'StrSql = "Select PM.PART_NO,PM.PART_DESC from Mat_Iss_M M, Mat_Iss_D D,Part_Master PM where M.LOT_NO = '" & TRIM(lblLotNo.text) & "' and M.P_Level = '" & trim(lblLevel.text) & "' and d.part_no = PM.Part_No"

            StrSql = "Select distinct(PM.Part_no) as [Part_no],sum(Issuing_qty) as [Issuing_Qty], PM.PART_NO,PM.PART_DESC from Mat_Iss_M M, Mat_Iss_D D,Part_Master PM where M.LOT_NO = '" & TRIM(lblLotNo.text) & "' and M.P_Level = '" & trim(lblLevel.text) & "' and d.part_no = PM.Part_No group by pm.Part_no, PM.Part_Desc"

             Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"Issuing_D")
             dtgShortage.DataSource=resExePagedDataSet.Tables("Issuing_D").DefaultView
             dtgShortage.DataBind()
         end sub

          Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
                 If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                    Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm

                    Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
                    Dim QtyIssued As Label = CType(e.Item.FindControl("QtyIssued"), Label)

                    Dim TOReturn As Textbox = CType(e.Item.FindControl("TOReturn"), Textbox)

                    'if trim(lblStatus.text) = "YES" then
                    '    TOReturn.enabled = false
                    '    QtyIssued.enabled = false
                    '    QtyIssued.text = "-"
                    'elseif trim(lblStatus.text) = "NO"
                    '    QtyIssued.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(lblLotNo.text) & "' and Part_No = '" & trim(PartNo.text) & "' and P_Level = '" & trim(lblLevel.text) & "';","QtyIssued")
                    '    if QtyIssued.text = "" then QtyIssued.text = "0"
                    'end if
                 End if
             End Sub

         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub

         Sub cmdBack_Click(sender As Object, e As EventArgs)
             response.redirect("Default.aspx")
         End Sub

         Sub cmdSave_Click(sender As Object, e As EventArgs)
             Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
             Dim i As Integer
             Dim StrSql as string


           try
                For i = 0 To dtgShortage.Items.Count - 1
                Dim PartNo As Label = CType(dtgShortage.Items(i).FindControl("PartNo"), Label)
                Dim ToReturn As textbox = CType(dtgShortage.Items(i).FindControl("ToReturn"), textbox)

                 if ToReturn.text <> "" then
                     if isnumeric(ToReturn.text) = true then
                         StrSql = "Insert into MRF_D(MRF_NO,LOT_NO,PART_NO,QTY_ISSUED,P_Level,CREATE_BY, CREATE_DATE) "
                         StrSql = StrSql & "Select '" & trim(lblMRFNo.text) & "','" & trim(lblLotNo.text) & "','" & trim(PartNo.text) & "'," & cint(ToReturn.text) & ",'" & trim(lblLevel.text) & "','" & request.cookies("U_ID").value & "','" & Now & "';"
                         ReqCOM.ExecuteNonQuery(StrSql)
                     end if
                 End if
             Next
             Response.redirect("MRFDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from MRF_M where MRF_NO = '" & trim(lblMRFNo.text) & "';","Seq_No"))
             Catch Err as exception
                response.write(Err.tostring)
             End try
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
            lblBOMRev.text = ReqCOM.GetFieldVal("Select BOM_Rev from SO_Model_M where Lot_No = '" & trim(lblLotNo.text) & "';","BOM_Rev")

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
                                <asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">NEW MRF REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:Label id="lblStatus" runat="server" width="344px" visible="False">Label</asp:Label>
                                                </p>
                                                <table style="HEIGHT: 9px" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label9" runat="server" width="126px" cssclass="LabelNormal">MRF NO</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblMRFNo" runat="server" width="126px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label1" runat="server" width="126px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" width="126px" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label10" runat="server" width="126px" cssclass="LabelNormal">BOM Revision</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblBOMRev" runat="server" width="126px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label5" runat="server" width="126px" cssclass="LabelNormal">Level</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLevel" runat="server" width="126px" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
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
                                                                <asp:Label id="lblLotSize" runat="server" width="126px" cssclass="OutputText"></asp:Label></td>
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
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" Height="35px" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black">
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
                                                            <asp:TemplateColumn HeaderText="Qty Issued">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyIssued" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Issuing_Qty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Ret. Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="ToReturn" runat="server" align="right" Columns="8" MaxLength="6" Text='' width="48px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="181px" Text="Update Transaction"></asp:Button>
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
