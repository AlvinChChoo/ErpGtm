<%@ Page Language="VB" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
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
            ProcLoadData()
            ProcLoadGridData()
        End if
    End Sub

    Sub ProcLoadData()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        lblJONo.text = ReqCOM.GetFieldVal("select JO_No from job_Order_M where seq_no = " & clng(request.params("ID")) & ";","JO_No")

        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand("select * from so_models_m where lot_no in (select lot_no from Job_Order_M where jo_no = '" & trim(lblJONo.text) & "')", myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)

        lblJOQty.text = ReqCOM.GetFieldVal("select Prod_Qty from Job_Order_M where jo_no = '" & trim(lblJONo.text) & "';","Prod_Qty")

        do while drGetFieldVal.read
            lblLotNo.text = drGetFieldVal("Lot_No")
            lblModelNo.text = drGetFieldVal("Model_No")
            lblCustReqDate.text = drGetFieldVal("Req_Date")
            lblOrderQty.text = drGetFieldVal("Order_Qty")
        loop

        lblModelDesc.text = ReqCOM.GetFieldVal("Select model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","model_Desc")

        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub

    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        StrSql = "Select jd.on_hold_qty,jd.jo_status,jd.in_qty,jd.out_qty,jd.released_date,jd.released_by,jd.seq_no,jm.lot_no,jd.jo_no,jd.pd_level,jd.prod_qty from Job_Order_D jd,job_order_m JM where jm.JO_No = '" & trim(lblJONo.text) & "' and jd.jo_no = jm.jo_no order by jd.jo_no asc"

        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Job_Order_D")
            GridControl1.DataSource=resExePagedDataSet.Tables("Job_Order_D").DefaultView
            GridControl1.DataBind()
        End if
    end sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ReleasedBy As Label = CType(e.Item.FindControl("ReleasedBy"), Label)
            Dim ReleasedDate As Label = CType(e.Item.FindControl("ReleasedDate"), Label)
            Dim Release As checkbox = CType(e.Item.FindControl("Release"), checkbox)

            If trim(ReleasedDate.text) <> "" then ReleasedBy.text = ReleasedBy.text & "-" & format(cdate(ReleasedDate.text),"dd/MM/yy")
            if trim(ReleasedBy.text) <> "" then Release.enabled = false
            if trim(ReleasedBy.text) <> "" then Release.checked = true
            if trim(ucase(ReleasedDate.text)) = "" then e.Item.CssClass = "PartSource"
        End if
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        response.redirect("JobOrderDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from SO_Models_m where lot_no = '" & trim(lblLotNo.text) & "';","Seq_No"))
    End Sub

    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        ProcLoadGridData
    End Sub

    Sub cmdRelease_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim Release As CheckBox
        Dim SeqNo As Label

        For i = 0 To GridControl1.Items.Count - 1
            Release = CType(GridControl1.Items(i).FindControl("Release"), CheckBox)
            SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
            if Release.enabled = true and release.checked = true then
                ReqCOM.ExecuteNonQuery("Update Job_Order_D set Released_by = '" & trim(request.cookies("U_ID").value) & "',Released_Date = '" & cdate(now) & "' where seq_no = " & clng(SeqNo.text) & ";")
            end if
        Next i
        ProcLoadGridData
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UCcontent" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%" forecolor="" backcolor="">JOB
                                ORDER DETAILS (J/O + LEVEL)</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="70%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Job Order #</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblJONo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Job Order Qty</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblJOQty" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Lot #</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Model # / Description</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Cust. Req. Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCustReqDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Lot Size</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblOrderQty" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" BorderColor="Black" GridLines="None" cellpadding="4" AutoGenerateColumns="False">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Section">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PDLevel" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PD_Level") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Released">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ReleasedBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Released_By") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Input Qty">
                                                                <ItemTemplate>
                                                                    <asp:Label id="InQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "In_Qty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="On Hold Qty">
                                                                <ItemTemplate>
                                                                    <asp:Label id="OnHoldQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "ON_HOLD_QTY") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Output Qty">
                                                                <ItemTemplate>
                                                                    <asp:Label id="OutQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Out_Qty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Status">
                                                                <ItemTemplate>
                                                                    <asp:Label id="JOStatus" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "JO_Status") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ReleasedDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Released_Date") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Release">
                                                                <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <center>
                                                                        <asp:CheckBox id="Release" runat="server" />
                                                                    </center>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Text="Refresh List" Width="127px"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRelease" onclick="cmdRelease_Click" runat="server" Text="Release selected Job" Width="167px"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="143px"></asp:Button>
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
