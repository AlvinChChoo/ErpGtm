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
        if page.isPostBack = false then GetMainData():ProcLoadGridData()
    End Sub

    Sub GetMainData()
        Dim cnnGetFieldVal As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        cnnGetFieldVal.Open()
        Dim myCommand As SqlCommand = New SqlCommand("Select * from Lot_Closure_M where seq_no = " & clng(request.params("ID")) & ";", cnnGetFieldVal )
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)

        do while drGetFieldVal.read
            lblLotClosureNo.text = drGetFieldVal("Lot_Closure_No")
            lblSubmitBy.text = drGetFieldVal("Submit_By").tostring
            lblSubmitDate.text = drGetFieldVal("Submit_Date").tostring
            lblCreateBy.text = drGetFieldVal("Create_By").tostring
            lblCreateDate.text = drGetFieldVal("Create_Date").tostring
            lblIQCDate.text = drGetFieldVal("IQC_Date").tostring
            lblStoreDate.text = drGetFieldVal("Store_Date").tostring
            lblPOOutDate.text = drGetFieldVal("PO_Out_Date").tostring

            if trim(lblSubmitDate.text) <> "" then lblSubmitDate.text = format(cdate(lblSubmitDate.text),"dd/MM/yy")
            if trim(lblCreateDate.text) <> "" then lblCreateDate.text = format(cdate(lblCreateDate.text),"dd/MM/yy")
            if trim(lblIQCDate.text) <> "" then lblIQCDate.text = format(cdate(lblIQCDate.text),"dd/MM/yy")
            if trim(lblStoreDate.text) <> "" then lblStoreDate.text = format(cdate(lblStoreDate.text),"dd/MM/yy")
            if trim(lblPOOutDate.text) <> "" then lblPOOutDate.text = format(cdate(lblPOOutDate.text),"dd/MM/yy")
        loop

        myCommand.dispose()
        drGetFieldVal.close()
        cnnGetFieldVal.Close()
        cnnGetFieldVal.Dispose()
    End sub



    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        'Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("SELECT * FROM LOT_CLOSURE_D where lot_closure_no = '" & trim(lblLotClosureNo.text) & "' ORDER BY Lot_Closure_No DESC","FECN_M")

        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("SELECT * FROM SO_Models_M where lot_no in (Select lot_no from lot_closure_d where lot_closure_no = '" & trim(lblLotClosureNo.text) & "')","FECN_M")


        Dim DV as New DataView(resExePagedDataSet.Tables("FECN_M"))

        GridControl1.DataSource=DV
        GridControl1.DataBind()
    end sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("LotClosure.aspx")
    End Sub

    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        'response.redirect("FECNAddNew.aspx")
    End Sub



    Sub cmdGo_Click(sender As Object, e As EventArgs)
        gridControl1.currentpageindex = 0
        ProcLoadGridData
    End Sub



    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

    Sub cmdAddLots_Click(sender As Object, e As EventArgs)
        Response.redirect("LotClosureAddLot.aspx?ID=" & trim(Request.params("ID")))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">LOT
                                CLOSURE LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="60%" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="40%" bgcolor="silver">
                                                <asp:Label id="Label4" runat="server">Lot Closure no</asp:Label></td>
                                            <td>
                                                <p align="left">
                                                    <asp:Label id="lblLotClosureNo" runat="server" cssclass="OutputText"></asp:Label>
                                                </p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label5" runat="server">Create By/Date</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCreateDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label7" runat="server" tooltip="Submit By/Date">Submit By/Date</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label8" runat="server">IQC</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblIQCDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label9" runat="server">Store</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblStoreDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:Label id="Label6" runat="server">P/O Order Outstanding</asp:Label></td>
                                            <td>
                                                <asp:Label id="lblPOOutDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                            </p>
                            <p>
                                <table style="HEIGHT: 27px" width="60%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Gray" cellpadding="4" AutoGenerateColumns="False">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Model No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModelNo" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Lot No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LotNo" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Quantity">
                                                                <ItemTemplate>
                                                                    <asp:Label id="OrderQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Order_Qty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdAddLots" onclick="cmdAddLots_Click" runat="server" CssClass="OutputText" Width="173px" Text="Add New Lots"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <p align="center">
                                                                        </p>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CssClass="OutputText" Width="173px" Text="Back"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
