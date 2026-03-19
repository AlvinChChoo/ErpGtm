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
                Dim rsRequest as SQLDataReader = ReqCOM.ExeDataReader("Select * from mat_Issuing_M where seq_no = " & request.params("ID") & ";")

                do while rsRequest.read
                    lblIssuingNo.text = rsRequest("Issuing_No").tostring
                    lblLevel.text = rsRequest("P_LEVEL").tostring
                    lblReqLotSize.text = rsRequest("LOT_SIZE").tostring
                    lblJONo.text = rsRequest("JO_No").tostring
                    lblLotNo.text = ReqCOM.GetFieldVal("Select lot_no from job_order_m where JO_No = '" & trim(lblJONo.text) & "';","Lot_No")
                    lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_Models_M where Lot_No = '" & trim(lblLotNo.text) & "';","Model_No")
                    lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")

                    if isdbnull(rsRequest("App1_Date")) = false then
                        lblIssuedBy.text = rsRequest("App1_By")
                        lblIssuedDate.text = format(cdate(rsRequest("App1_Date")),"dd/MM/yy")
                    End if
                Loop

                rsRequest.close()
                UpdateTotalIssuedQty()
                procLoadGridData()

                if trim(lblIssuedDate.text) <> "" then
                    cmdUpdate.enabled = false
                    cmdRemove.enabled = false
                End if
            end if
        End Sub

        Sub UpdateTotalIssuedQty()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim rs as SQLDataReader = ReqCOM.ExeDataReader("Select Part_No from Mat_Issuing_D where Issuing_No = '" & trim(lblIssuingNo.text) & "';")
            Dim TotalIssued as String

            do while rs.read
                TotalIssued = ReqCOM.GetFieldVal("Select sum(Md.Qty_Issued) as [TotalIssued] from Mat_Issuing_d MD,Mat_Issuing_M MM where MD.Part_No = '" & trim(rs("Part_No")) & "' and MD.ISSUING_NO = MM.ISSUING_NO AND MM.JO_NO = '" & TRIM(lblJONo.text) & "';","TotalIssued")
                if TotalIssued = "<NULL>" then TotalIssued = "0"
                ReqCOM.ExecuteNonQuery("Update Mat_Issuing_D set Total_Issued = " & clng(TotalIssued) & " where Issuing_No = '" & trim(lblIssuingNo.text) & "' and Part_No = '" & rs("Part_No") & "';")
            loop
        End sub

        Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
        End Sub

        Sub ProcLoadGridData()
            Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
            Dim StrSql as string = "Select req.main_alt,req.type,req.main_part,req.seq_no,req.total_issued,req.qty_issued,pm.bal_qty,req.p_usage,req.total_usage,pm.part_spec,pm.m_part_no,req.part_no,pm.part_desc from mat_issuing_d req, part_master pm where req.part_no = pm.part_no and req.issuing_no = '" & trim(lblIssuingNo.text) & "' order by req.main_part,req.Main_Alt desc"
            Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"mat_issuing_d")

            dtgPartList.visible = true
            dtgPartList.DataSource=resExePagedDataSet.Tables("mat_issuing_d").DefaultView
            dtgPartList.DataBind()
        end sub

         Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)

         End Sub

         Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                Dim TotalUsage As Label = CType(e.Item.FindControl("TotalUsage"), Label)
                Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)

                Dim PartType As Label = CType(e.Item.FindControl("PartType"), Label)

                Dim MainPart As Label = CType(e.Item.FindControl("MainPart"), Label)
                Dim TotalIssued As Label = CType(e.Item.FindControl("TotalIssued"), Label)
                Dim BalQty As Label = CType(e.Item.FindControl("BalQty"), Label)
                'Dim QtyIssued As textbox = CType(e.Item.FindControl("QtyIssued"), textbox)
                Dim MainAlt As Label = CType(e.Item.FindControl("MainAlt"), Label)

                Dim PUsage As Label = CType(e.Item.FindControl("PUsage"), Label)






                'TotalUsage.text = PUsage.text * lblReqLotSize.text
    'lblReqLotSize

                BalQty.text = clng(BalQty.text)

                'TotalUsage.text = format(clng(TotalUsage.text),"##,##0")
                'BalQty.text = format(clng(BalQty.text),"##,##0")

                'if trim(lblIssuedDate.text) = "" then
                '    QtyIssued.text = clng(TotalUsage.text) - clng(TotalIssued.text)
                '    if clng(BalQty.text) < clng(QtyIssued.text) then QtyIssued.text = clng(BalQty.text)

                '    if clng(TotalUsage.text) = clng(TotalIssued.text) then
                '        QtyIssued.text = "0"
                '        QtyIssued.enabled = false
                '    End if
                'elseif trim(lblIssuedDate.text) <> "" then
                '    QtyIssued.enabled = false
                'end if

                'if clng(QtyIssued.text) <= 0 then QtyIssued.text = "0": QtyIssued.enabled = false

                'if ucase(MainAlt.text) = "ALT." then e.Item.CssClass = "IssuingListAltPart"
                'if ucase(MainAlt.text) = "MAIN" then e.Item.CssClass = "IssuingListMainPart"
            End if
         End Sub

        Sub cmdBack_Click(sender As Object, e As EventArgs)
            response.redirect("MaterialIssuing.aspx")
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

        Sub cmdSubmit_Click(sender As Object, e As EventArgs)
            Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.ExecuteNonQuery("Update Lot_Mat_Req_M set Approve2_By = '" & trim(request.cookies("U_ID").value) & "', Approve2_Date = '" & now & "' where seq_no = " & request.params("ID") & ";")
            Response.redirect("LotMaterialRequestPCMCDet.aspx?ID=" & Request.params("ID"))
        End Sub

    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        Dim SeqNo,PartNo As Label
        Dim QtyIssued as Textbox

        For i = 0 To dtgPartList.Items.Count - 1
            SeqNo = CType(dtgPartList.Items(i).FindControl("SeqNo"), Label)
            PartNo = CType(dtgPartList.Items(i).FindControl("PartNo"), Label)
            QtyIssued = CType(dtgPartList.Items(i).FindControl("QtyIssued"), Textbox)
            ReqCOM.ExecuteNonQuery("Update Mat_Issuing_D set Qty_Issued = " & QtyIssued.text & " where Seq_No = " & SeqNo.text & ";")
        Next

        ReqCOM.ExecuteNonQUery("delete from mat_issuing_d where qty_issued = 0")
        ReqCOM.ExecuteNonQuery("Update Part_Master set part_master.bal_qty = Part_Master.bal_qty - mat_issuing_d.Qty_Issued from mat_issuing_d, part_master where mat_issuing_d.issuing_no = '" & trim(lblIssuingNo.text) & "' and mat_issuing_d.part_no = part_master.part_no")
        ReqCOM.ExecuteNonQuery("Update Mat_Issuing_M set App1_By = '" & trim(request.cookies("U_ID").value) & "',App1_Date = '" & cdate(now) & "' where Issuing_No = '" & trim(lblIssuingNo.text) & "';")
        Response.redirect("MaterialIssuingDet.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQUery("Delete from mat_issuing_m where issuing_no = '" & trim(lblIssuingNo.text) & "';")
        ReqCOM.ExecuteNonQUery("Delete from mat_issuing_d where issuing_no = '" & trim(lblIssuingNo.text) & "';")
        Response.redirect("MaterialIssuing.aspx")
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
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:Label id="lblValQty" runat="server" cssclass="ErrorText" width="100%" visible="False">Please
                                                    re-confirm the on hold qty for the highlighted item(s).</asp:Label>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 80%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="126px">Issuing
                                                                No</asp:Label></td>
                                                            <td width="75%">
                                                                <asp:Label id="lblIssuingNo" runat="server" cssclass="OutputText" width="223px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="126px">Job Order
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblJONo" runat="server" cssclass="OutputText" width="223px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="126px">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="126px">Level</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLevel" runat="server" cssclass="OutputText" width="223px"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="126px">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="126px">Req. Lot
                                                                Size</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblReqLotSize" runat="server" cssclass="OutputText" width="223px"></asp:Label><asp:Label id="lblBOMRev" runat="server" cssclass="OutputText" width="126px" visible="False"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">Issued
                                                                By / Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblIssuedBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblIssuedDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p align="center">
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartList" runat="server" width="100%" Height="35px" PageSize="100" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" AllowSorting="True" OnSortCommand="SortGrid" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Main Part">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MainPart" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Main_Part") %>' /> <asp:Label id="MainAlt" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Main_Alt") %>' /> <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' visible= "false" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Part No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="PART_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Part_Spec" HeaderText="Specification"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="M_Part_No" HeaderText="Mfg. Part No."></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Usage">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PUsage" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Total Usage">
                                                                <ItemTemplate>
                                                                    <asp:Label id="TotalUsage" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Total_Usage") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Issued">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyIssued" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Issued") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Store">
                                                                <ItemTemplate>
                                                                    <asp:Label id="BalQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Bal_Qty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Type" width="60px" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Type") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#0000c0">
                                                                </td>
                                                                <td>
                                                                    &nbsp;&nbsp; <asp:Label id="Label7" runat="server" cssclass="OutputText">Main Part</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="10%" bgcolor="red">
                                                                </td>
                                                                <td>
                                                                    &nbsp;&nbsp; <asp:Label id="Label8" runat="server" cssclass="OutputText">Alternate
                                                                    Part</asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="122px" Text="Update"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="168px" Text="Remove this Issuing" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="141px" Text="Back" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
