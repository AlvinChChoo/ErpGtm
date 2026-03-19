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
                 if page.ispostback = false then ShowModelDet() : ProcLoadGridData()
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
                 Dim BOMRev as decimal = lblBOMRev.text
                 Dim StrSql as string = "Select PM.Bal_Qty,BOM.Seq_No,BOM.Part_No,PM.Part_Desc,BOM.P_Usage from BOM_D BOM,Part_Master PM where BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & BOMRev & " and BOM.P_Level = '" & trim(lblLevel.text) & "' and BOM.Part_No = PM.Part_No;"
                 Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"BOM_D")
                 dtgShortage.DataSource=resExePagedDataSet.Tables("BOM_D").DefaultView
                 dtgShortage.DataBind()
             end sub

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
                    Dim StoreBal As Label = CType(e.Item.FindControl("StoreBal"), Label)


                    StoreBal.text = cint(StoreBal.text)
                    LotQty.text = Usage.text * lblLotSize.text

                    IssuedQty.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(lblLotNo.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'ISSUING'","QtyIssued")
                    if IssuedQty.text = "" then IssuedQty.text = "0"

                    MRBRet.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(lblLotNo.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'MRBRET'","QtyIssued")
                    if MRBRet.text = "" then MRBRet.text = "0"

                    MRBRej.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(lblLotNo.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'MRBREJ'","QtyIssued")
                    if MRBRej.text = "" then MRBRej.text = "0"

                    MRBScrap.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(lblLotNo.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'MRBSCRAP'","QtyIssued")
                    if MRBScrap.text = "" then MRBScrap.text = "0"

                    OtherScrap.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(lblLotNo.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'OTHERSCRAP'","QtyIssued")
                    if OtherScrap.text = "" then OtherScrap.text = "0"

                    SpecialReq.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from Issuing_D where lot_No = '" & trim(lblLotNo.text) & "' and Part_No = '" & trim(PartNo.text) & "' and ISSUING_TYPE = 'SPECIALREQ'","QtyIssued")
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


              End Sub

              Sub ShowModelDet()
                  Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
                  Dim RsIssuing as SQLDataReader = ReqCOM.ExeDataReader("Select ISS.Issuing_No ,ISS.Lot_No ,ISS.P_Level,SO.Model_No ,SO.Lot_No ,SO.Color_Desc ,SO.Pack_Code ,SO.BOM_DATE,SO.Order_Qty,SO.BOM_REV from Mat_Iss_M ISS, So_model_M SO where ISS.Seq_no = " & request.params("ID") & " and ISS.Lot_No = SO.Lot_No")

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



                  Loop
                  RsIssuing.Close
              End sub

              Sub cmbLevel_SelectedIndexChanged(sender As Object, e As EventArgs)

              End Sub

    Sub ValIssuingQty(sender As Object, e As ServerValidateEventArgs)
        Dim i As Integer

        For i = 0 To dtgShortage.Items.Count - 1
            Dim QtyToIss As Textbox = CType(dtgShortage.Items(i).FindControl("QtyToIss"), Textbox)
            Dim StoreBal As Label = CType(dtgShortage.Items(i).FindControl("StoreBal"), Label)
            Dim BalToIss As Label = CType(dtgShortage.Items(i).FindControl("BalToIss"), Label)

            dtgShortage.Items(i).CssClass = ""

            if QtyToIss.text = "" then QtyToIss.text = "0"

            if QtyToIss.text < 0  then
                dtgShortage.Items(i).CssClass = "PartSource":e.isvalid = false
                response.write("1")
            elseif isnumeric(QtyToIss.text) = false then
                dtgShortage.Items(i).CssClass = "PartSource":e.isvalid = false
                response.write("2")
            elseIf (cint(QtyToIss.text) > 0) and (QtyToIss.text > StoreBal.text) then
                dtgShortage.Items(i).CssClass = "PartSource":e.isvalid = false
                response.write("3")
            elseIf (cint(QtyToIss.text) > 0) and (QtyToIss.text > BalToIss.text) then
                dtgShortage.Items(i).CssClass = "PartSource":e.isvalid = false
                response.write("4")
            End if
            response.write("5")
        Next
    End Sub

    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim i as integer

        For i = 0  to dtgShortage.items.count - 1
            Dim QtyToIss As Textbox = Ctype(dtgShortage.Items(i).FindControl("QtyToIss"), Textbox)
            Dim PartNo As Label = Ctype(dtgShortage.Items(i).FindControl("PartNo"), Label)
            if cint(QtyToIss.text) > 0 then ReqCOM.ExecuteNonQuery("Insert into Mat_Iss_D(ISSUING_NO,PART_NO,ISSUING_QTY) select '" & trim(lblIssuingNo.text) & "','" & trim(PartNo.text) & "'," & cint(QtyToIss.text) & ";")
        Next i
        response.redirect("PartIssuingAddNew2.aspx?ID=" & request.params("ID"))
    End Sub

    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("PartIssuing.aspx")
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
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
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
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:CustomValidator id="DuplicateIssuingQty" runat="server" Width="100%" OnServerValidate="ValIssuingQty" ForeColor=" " Display="Dynamic" ErrorMessage="Please re-confirm the qty to issu on the highlighted item." CssClass="ErrorText" EnableClientScript="False"></asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" AllowSorting="True" Height="35px" Font-Names="Verdana" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PageSize="100" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:BoundColumn DataField="Seq_No" HeaderText="ID"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Part No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Usage">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Usage" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Store Bal">
                                                                <ItemTemplate>
                                                                    <asp:Label id="StoreBal" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Bal_Qty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Lot Qty">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LotQty" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MRB Ret.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MRBRet" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MRB Rej.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MRBRej" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MRB Scrap">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MRBScrap" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Other Scrap">
                                                                <ItemTemplate>
                                                                    <asp:Label id="OtherScrap" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Special Req.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SpecialReq" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Bal to Iss">
                                                                <ItemTemplate>
                                                                    <asp:Label id="BalToIss" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Iss. Qty">
                                                                <ItemTemplate>
                                                                    <asp:Label id="IssuedQty" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Qty To Issue">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="QtyToIss" runat="server" align="right" Columns="8" MaxLength="6" Text='0' width="48px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                </p>
                                                <p align="left">
                                                    <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="164px" Text="Update Part Issuing"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="164px" Text="Cancel" CausesValidation="False"></asp:Button>
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
