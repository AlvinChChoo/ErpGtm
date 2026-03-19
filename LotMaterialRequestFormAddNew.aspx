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

    Dim ButtonCommand as string

        Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
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

        Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
        End Sub

        Sub cmdBack_Click(sender As Object, e As EventArgs)
            response.redirect("LotMaterialRequestForm.aspx")
        End Sub

        Sub cmdSave_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then
                CheckIssueQty()
                if lblValQty.visible = False then

                    Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                    Dim StrSql as string
                    Dim i As Integer

                    StrSql = "Insert into ISSUING_M (ISSUING_NO,LOT_NO,P_LEVEL,App1_By,App1_Date) "
                    StrSql = StrSql + "Select '" & trim(cmbKitLotNo.selecteditem.value) & "','" & trim(lblLotNo.text) & "','" & trim(lblPLevel.text) & "','" & request.cookies("U_ID").value & "','" & now & "';"
                    ReqCOM.executeNonQuery(StrSql)
                    ReqCOM.ExecuteNonQuery("Update Main set Lot_mat_req_no = Lot_mat_req_no + 1")
                    ReqCOM.ExecuteNonQuery("Update Kit_Lot set Issuing_No = Kit_Lot_No where Kit_Lot_No = '" & trim(cmbKitLotNo.selecteditem.value) & "';")

                    For i = 0 To dtgPartList.Items.Count - 1
                        Dim IssueQty As Textbox = CType(dtgPartList.Items(i).FindControl("IssueQty"), Textbox)
                        Dim PartNo As Label = CType(dtgPartList.Items(i).FindControl("PartNo"), Label)

                        if IssueQty.text > 0 then
                            ReqCom.executeNonQuery("Insert into ISSUING_D(ISSUING_NO,PART_NO,REQ_QTY) select '" & trim(cmbKitLotNo.selecteditem.value) & "','" & trim(PartNo.text) & "'," & cdec(IssueQty.text) & ";")
                            ReqCOM.ExecuteNonQuery("Insert into Issuing_Trail(ISSUING_NO,PART_NO,REQ_QTY,P_LEVEL,ISSUING_TYPE,lot_no) select '" & trim(cmbKitLotNo.selecteditem.value) & "','" & trim(partNo.text) & "'," & cdec(IssueQty.text) & ",'" & trim(lblPLevel.text) & "','LOT REQ','" & trim(lblLotNo.text) & "';")
                        end if
                    Next
                    response.redirect("LotMaterialRequestFormDet.aspx?ID=" & ReqCOM.getFieldVal("Select Seq_No from ISSUING_M where ISSUING_NO = '" & trim(cmbKitLotNo.selecteditem.value) & "';","Seq_No"))
                End if
            End if
        End Sub

        Sub CheckIssueQty()
            Dim i As Integer
            lblValQty.visible = false

            For i = 0 To dtgPartList.Items.Count - 1
                Dim IssueQty As Textbox = CType(dtgPartList.Items(i).FindControl("IssueQty"), Textbox)
                Dim BalToIssue As label = CType(dtgPartList.Items(i).FindControl("BalToIssue"), label)
                Dim StoreBal As label = CType(dtgPartList.Items(i).FindControl("StoreBal"), label)

                dtgPartList.Items(i).CssClass = ""
                if IssueQty.text = "" then
                    dtgPartList.Items(i).CssClass = "PartSource"
                    lblValQty.visible = true
                elseif isnumeric(IssueQty.text) = false then
                    dtgPartList.Items(i).CssClass = "PartSource"
                    lblValQty.visible = true
                elseif IssueQty.text < 0 then
                    dtgPartList.Items(i).CssClass = "PartSource"
                    lblValQty.visible = true
                elseif IssueQty.text > cdec(BalToIssue.text) then
                    if cdec(IssueQty.text) <> 0 then
                        dtgPartList.Items(i).CssClass = "PartSource"
                        lblValQty.visible = true
                    end if
                elseif IssueQty.text > cdec(StoreBal.text) then
                    dtgPartList.Items(i).CssClass = "PartSource"
                    lblValQty.visible = true
                end if
            Next
        End sub

        Sub cmbLevel_SelectedIndexChanged(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim QtyRequested as integer
            dtgPartList.DataSource = nothing
            dtgPartList.DataBind()
        End Sub

        Sub ProcLoadGridData()
            Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
            Dim StrSql as string = "Select PM.Bal_Qty, BOM.P_Usage, BOM.Part_No,BOM.P_Color,BOM.Packing,PM.Part_Desc from BOM_D bom,Part_master PM where Model_No = '" & trim(lblModelNo.text) & "' and PM.Part_No = BOM.Part_No and Revision = " & cdec(lblBOMRev.text) & " and P_Level = '" & trim(lblPLevel.text) & "';"
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"BOM_D")
            dtgPartList.visible = true
            dtgPartList.DataSource=resExePagedDataSet.Tables("BOM_D").DefaultView
            dtgPartList.DataBind()
        end sub

        Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        End Sub

        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                Dim TotalUsage As Label = CType(e.Item.FindControl("TotalUsage"), Label)
                Dim Usage As Label = CType(e.Item.FindControl("Usage"), Label)
                Dim QtyIssued As Label = CType(e.Item.FindControl("QtyIssued"), Label)
                Dim BalToIssue As Label = CType(e.Item.FindControl("BalToIssue"), Label)
                Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
                Dim StoreBal As Label = CType(e.Item.FindControl("StoreBal"), Label)
                Dim IssueQty As Textbox = CType(e.Item.FindControl("IssueQty"), TextBox)

                TotalUsage.text = cdec(Usage.text) * cdec(lblLotSize.text)

                if ReqCOM.FuncCheckDuplicate("Select TOP 1 * from Issuing_TRAIL where PART_NO = '" & trim(PartNo.text) & "' AND lot_no = '" & trim(lblLotNo.text) & "' and p_level = '" & trim(lblPLevel.text) & "';","Lot_No") =  true then
                    QtyIssued.text = ReqCOM.GetFieldVal("Select sum(Req_Qty) as [Qty_Issued] from Issuing_Trail where lot_no = '" & trim(lblLotNo.text) & "' and Part_no = '" & trim(PartNo.text) & "' and P_level = '" & trim(lblPLevel.text) & "';","Qty_Issued")
                    IssueQty.text = QtyIssued.text
                Else
                    QtyIssued.text = 0
                    IssueQty.text = QtyIssued.text
                end if

                StoreBal.text = format(cdec(StoreBal.text),"##,##0")
                BalToIssue.text = cint(TotalUsage.text) - cint(QtyIssued.text)
                TotalUsage.text = format(cdec(TotalUsage.text),"##,##0")
                if cint(BalToIssue.text) >= cint(StoreBal.text) then
                    IssueQty.text = StoreBal.text
                elseif cint(StoreBal.text) >= cint(BalToIssue.text) then
                    IssueQty.text = BalToIssue.text
                end if
            End if
        End Sub

        Sub cmdGo_Click(sender As Object, e As EventArgs)
            cmbKitLotNo.items.clear
            Dissql ("Select kit_Lot_No from Kit_Lot where kit_lot_no like '%" & trim(txtSearchKitLot.text) & "%' and issuing_no is null","Kit_Lot_No","Kit_Lot_No",cmbKitLotNo)

            if cmbKitLotNo.selectedIndex = 0 then
                ShowKitLotDet()
                txtSearchKitLot.text = "-- Search --"
            else
                txtSearchKitLot.text = "-- Search --"
            end if
        End Sub

        Sub ShowKitLotDet()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim rs As SqlDataReader = ReqCOM.ExeDataReader("Select top 1 * from Kit_lot where kit_LOT_NO = '" & trim(cmbKitLotNo.selecteditem.value) & "';")
            Do while rs.read
                lblLotno.text = rs("Lot_No").tostring
                lblPLevel.text = rs("P_Level").tostring
                lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_Model_M where Lot_No = '" & trim(lblLotNo.text) & "';","Model_No")
                lblLotSize.text = ReqCOM.GetFieldVal("Select Order_Qty from SO_Model_M where Lot_No = '" & trim(lblLotNo.text) & "';","Order_Qty")
                lblModelDesc.text = ReqCOM.GetFieldVal("Select top 1 Model_Desc from Model_Master where model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
                lblReqLotSize.text = rs("Req_Qty")
                lblDateToIssue.text = format(cdate(rs("Date_To_Issue")),"dd/MM/yy")
                lblBOMRev.text = ReqCOM.GetFieldVal("Select Max(Revision) as [RevNo] from BOM_M where Model_No = '" & trim(lblModelNo.text) & "';","RevNo")
            loop
            rs.close
            ProcLoadGridData
        End sub

    Sub cmbKitLotNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        ShowKitLotDet
    End Sub

</script>
<html>
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
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">NEW LOT MATERIAL
                                REQUEST REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="lblValQty" runat="server" cssclass="ErrorText" width="100%" visible="False">Please
                                                    re-confirm the on issue qty for the highlighted item(s).</asp:Label>
                                                </div>
                                                <div align="center">
                                                </div>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 80%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="80%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="126px">Kit Lot
                                                                Form #</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtSearchKitLot" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchKitLot)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                <asp:DropDownList id="cmbKitLotNo" runat="server" Width="236px" CssClass="OutputText" OnSelectedIndexChanged="cmbKitLotNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="126px">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="126px">Level</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPLevel" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="126px">Date To
                                                                Issue</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblDateToIssue" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="126px">Req. Lot
                                                                Size</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblReqLotSize" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="126px">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                -&nbsp; <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">Lot Size</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotSize" runat="server" cssclass="OutputText" width="126px"></asp:Label><asp:Label id="lblBOMRev" runat="server" cssclass="OutputText" width="126px" visible="False"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p align="center">
                                                    <asp:DataGrid id="dtgPartList" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnSortCommand="SortGrid" AllowSorting="True" Font-Names="Verdana" PageSize="100" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Part No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="PART_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Usage">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="Usage" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Total Usage">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="TotalUsage" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Issued">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyIssued" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Bal. To Issue">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="BalToIssue" runat="server" text='' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Store Bal.">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="StoreBal" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Bal_Qty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Issue Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="IssueQty" runat="server" CssClass="outputtext" align="right" Columns="8" MaxLength="6" Text='0' width="48px" />
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
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="181px" Text="Save as new request"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="181px" Text="Back" CausesValidation="False"></asp:Button>
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
