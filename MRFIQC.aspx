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
                ShowModelDet
                ProcLoadGridData()
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
             Dim StrSql as string = "Select MRF.REM,MRF.Seq_No,MRF.Part_No,MRF.Qty_Issued,MRF.QTY_Good,MRF.QTY_Return,MRF.QTY_Scrap,PM.Part_Desc from MRF_D MRF,Part_Master PM where MRF.MRF_NO = '" & trim(lblMRFNo.text) & "' and MRF.Part_No = PM.Part_No"

             Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"MRF_D")
             dtgShortage.DataSource=resExePagedDataSet.Tables("MRF_D").DefaultView
             dtgShortage.DataBind()
         end sub

          Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
                 If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                    Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
                    Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
                    Dim QtyIssued As Label = CType(e.Item.FindControl("QtyIssued"), Label)


                    'Dim TOReturn As Textbox = CType(e.Item.FindControl("TOReturn"), Textbox)


                    'if trim(lblStatus.text) = "YES" then
                    '    TOReturn.enabled = false
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

            For i = 0 To dtgShortage.Items.Count - 1
                Dim SeqNo As Label = CType(dtgShortage.Items(i).FindControl("SeqNo"), Label)
                Dim QtyGood As textbox = CType(dtgShortage.Items(i).FindControl("Good"), textbox)
                Dim QtyReturn As textbox = CType(dtgShortage.Items(i).FindControl("Return"), textbox)
                Dim QtyScrap As textbox = CType(dtgShortage.Items(i).FindControl("Scrap"), textbox)
                Dim Remarks As textbox = CType(dtgShortage.Items(i).FindControl("Rem"), textbox)

                StrSql = "Update MRF_D set QTY_GOOD = " & cint(QtyGood.text) & ",QTY_SCRAP = " & cint(QtyScrap.text) & ",QTY_Return = " & cint(QtyReturn.text) & ",Rem = '" & trim(Remarks.text) & "' where Seq_No = " & cint(SeqNo.text) & ";"
                ReqCOM.ExecuteNonQuery(StrSql)
            Next
            Response.redirect("MRFIQC.aspx?ID=" & Request.Params("ID"))
            'ProcLoadGridData
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

         Sub cmbLevel_SelectedIndexChanged(sender As Object, e As EventArgs)

         End Sub

        Sub cmdReject_Click(sender As Object, e As EventArgs)
            response.redirect("MRFICQRejectConfirmation.aspx?ID=" & Request.params("ID"))
        End Sub

        Sub cmdApprove_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim i As Integer
            Dim StrSql as string

            For i = 0 To dtgShortage.Items.Count - 1
            '    Dim PartNo As Label = CType(dtgShortage.Items(i).FindControl("PartNo"), Label)
            '    Dim ToReturn As textbox = CType(dtgShortage.Items(i).FindControl("ToReturn"), textbox)

            '    if ToReturn.text <> "" then
            '        if isnumeric(ToReturn.text) = true then
            '            StrSql = "Insert into MRF_D(LOT_NO,PART_NO,QTY_ISSUED,P_Level,CREATE_BY, CREATE_DATE) "
            '            StrSql = StrSql & "Select '" & trim(lblLotNo.text) & "','" & trim(PartNo.text) & "'," & cint(ToReturn.text) & ",'" & trim(lblLevel.text) & "','" & request.cookies("U_ID").value & "','" & Now & "';"
            '            ReqCOM.ExecuteNonQuery(StrSql)
            '        end if
            '    End if

            Next
            'ProcLoadGridData
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
                                                <p>
                                                    <asp:Label id="lblStatus" runat="server" width="344px" visible="False">Label</asp:Label>
                                                </p>
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
                                                            <asp:TemplateColumn HeaderText="ID">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
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
                                                            <asp:TemplateColumn HeaderText="Good">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="Good" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "QTY_GOOD") %>' width="48px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Return">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="Return" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "QTY_RETURN") %>' width="48px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Scrap">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="Scrap" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "QTY_SCRAP") %>' width="48px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Remarks">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="Rem" runat="server" align="right" columns="350" maxlength="350" text='<%# DataBinder.Eval(Container.DataItem, "REM") %>' width="350px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 81px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdApprove" onclick="cmdApprove_Click" runat="server" Text="Approve this MRF" Width="181px"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdReject" onclick="cmdReject_Click" runat="server" Text="Reject this MRF" Width="181px"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Text="Update Transaction" Width="181px"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="181px"></asp:Button>
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
