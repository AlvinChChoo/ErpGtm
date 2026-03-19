<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="erp" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
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
            If SortField = "" then SortField = "Part_Desc"
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim RsModelMaster as SQLDataReader = ReqCOM.ExeDataReader("Select * from BOM_M where Seq_No = " & request.params("ID") & ";")

            Do while RsModelMaster.read
                lblEffectiveDate.text = format(cdate(RsModelMaster("Effective_Date")),"dd/MMM/yy")
                lblModelNo.text = RsModelMaster("Model_No")
                lblDescription.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
                lblPartListNo.text = RsModelMaster("PartList_No").toString()
                lblRevNo.text = RsModelMaster("Revision")
                lblCustomer.text = ReqCOM.GetFieldVal("Select Cust_Code from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Cust_Code")
                lblCustomer.text = ReqCOM.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(lblCustomer.text) & "';","Cust_name")
                lblNoOfParts.text = "There are " & ReqCOM.GetFieldVal("Select count(Part_no) as NoOfParts from bom_d where Model_No = '" & trim(lblModelNo.text) & "' and Revision = " & cint(lblRevNo.text) & ";","NoOfParts") & " parts for this Model."
            loop

            Dim RevNo as decimal = ReqCOM.GetFieldVal("Select top 1 revision from bom_m where model_no = '" & lblModelNo.text & "' order by revision desc","Revision")
            ProcLoadGridData("Select substring(PM.Part_Spec,1,25) + '...' as [Short_Part_Spec],bom.Seq_No,PM.Part_Desc,BOM.P_USAGE,PM.Part_Spec,BOM.Seq_No,BOM.Part_No,BOM.P_Level from BOM_D BOM,Part_Master PM where BOM.PART_NO LIKE '%" & trim(txtSearch.Text) & "%' and BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & lblRevNo.text & " and BOM.Part_No = PM.Part_No ")
        end if
    End Sub

    Property SortField() As String
            Get
                Dim o As Object = ViewState("SortField")
                If o Is Nothing Then Return [String].Empty
                Return CStr(o)
            End Get
            Set(ByVal Value As String)
                If Value = SortField Then
                    SortAscending = Not SortAscending
                End If
                ViewState("SortField") = Value
            End Set
        End Property

        Property SortAscending() As Boolean
             Get
                 Dim o As Object = ViewState("SortAscending")
                 If o Is Nothing Then
                     Return True
                 End If
                 Return CBool(o)
             End Get
             Set(ByVal Value As Boolean)
                 ViewState("SortAscending") = Value
             End Set
    End Property

    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData("Select substring(PM.Part_Spec,1,25) + '...' as [Short_Part_Spec], PM.Part_Desc,BOM.P_USAGE,PM.Part_Spec,BOM.Seq_No,BOM.Part_No,BOM.P_Level from BOM_D BOM,Part_Master PM where BOM.PART_NO LIKE '%" & trim(txtSearch.Text) & "%' and BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & lblRevNo.text & " and BOM.Part_No = PM.Part_No ")
    end sub

    Sub ProcLoadGridData(StrSql as string)
        Dim SortSeq as string
        SortSeq = IIF((SortAscending=True),"Asc","Desc")
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset

        if trim(SortField) = "P_LEVEL" then
            resExePagedDataSet = ReqExePagedDataSet.ExePagedDataSet(StrSql & " order by BOM.P_Level,BOM.Part_No " & SortSeq,"BOM_D")
        elseif trim(SortField) = "Part_No" then
            resExePagedDataSet = ReqExePagedDataSet.ExePagedDataSet(StrSql & " order by BOM.Part_No,BOM.P_Level " & SortSeq,"BOM_D")
        Else
            resExePagedDataSet = ReqExePagedDataSet.ExePagedDataSet(StrSql & " order by " & SortField & " " & SortSeq,"BOM_D")
        end if

         GridControl1.DataSource=resExePagedDataSet.Tables("BOM_D").DefaultView
         GridControl1.DataBind()
         UpdateAltPart()
     end sub

    Sub UpdateAltPart()
    Dim StrSql as string
    DIm i as integer
    Dim MainPart, Spec, AltPart as Label
    Dim ReqCOM as ERp_Gtm.ERp_Gtm = new ERp_Gtm.ERp_Gtm

    For i = 0 to GridControl1.items.count-1
        AltPart = ctype(GridControl1.items(i).FindControl("lblAltPart"), Label)
        MainPart = ctype(GridControl1.items(i).FindControl("lblMainPart"), Label)
        Spec = ctype(GridControl1.items(i).FindControl("lblSpec"),Label)
        AltPart.text = ReqCOM.GetFieldVal("Select count(BOM_Alt.Main_Part) as [AltPart] from bom_alt where Model_No = '" & trim(lblModelNo.text) & "' and Revision = " & lblRevNo.text & " and Main_Part = '" & trim(MainPart.text) & "';","AltPart")
    Next
    End sub

    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        response.redirect("BOMMainAddNew.aspx?ID=" + ReqCOM.GetFieldVal("Select Seq_No from BOM_M where Model_No = '" & trim(lblModelNo.text) & "';","Seq_No") )
    End Sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        gridControl1.CurrentPageIndex  = 0
        ProcLoadGridData("Select substring(PM.Part_Spec,1,25) + '...' as [Short_Part_Spec],PM.Part_Desc,BOM.P_USAGE,PM.Part_Spec,BOM.Seq_No,BOM.Part_No,BOM.P_Level from BOM_D BOM,Part_Master PM where " & trim(cmbBy.selectedItem.value) & " LIKE '%" & trim(txtSearch.Text) & "%' and BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & lblRevNo.text & " and BOM.Part_No = PM.Part_No ")
    End Sub

    Sub cmdRemove_Click_1(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1

            Dim SeqNo As Label = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
            Try
                If remove.Checked = true Then ReqCOM.ExecuteNonQuery("Delete from BOM_D where Seq_No = " & SeqNo.text & ";")
            Catch
            End Try
        Next
        ProcLoadGridData("Select substring(PM.Part_Spec,1,25) + '...' as [Short_Part_Spec],PM.Part_Desc,BOM.P_USAGE,PM.Part_Spec,BOM.Seq_No,BOM.Part_No,BOM.P_Level from BOM_D BOM,Part_Master PM where BOM.PART_NO LIKE '%" & trim(txtSearch.Text) & "%' and BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & lblRevNo.text & " and BOM.Part_No = PM.Part_No ")
    End Sub

    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        SortField = CStr(e.SortExpression)
        ProcLoadGridData("Select substring(PM.Part_Spec,1,25) + '...' as [Short_Part_Spec],PM.Part_Desc,BOM.P_USAGE,PM.Part_Spec,BOM.Seq_No,BOM.Part_No,BOM.P_Level from BOM_D BOM,Part_Master PM where BOM.PART_NO LIKE '%" & trim(txtSearch.Text) & "%' and BOM.Model_No = '" & trim(lblModelNo.text) & "' and BOM.Revision = " & lblRevNo.text & " and BOM.Part_No = PM.Part_No ")
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("BOM.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <ERP:HEADER id="UserControl1" runat="server"></ERP:HEADER>
                            </div>
                            <div align="center">
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    BOM Header</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <table style="HEIGHT: 25px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:Label id="lblNoOfParts" runat="server" cssclass="ErrorText" width="389px"></asp:Label></td>
                                                                                <td>
                                                                                    <p align="right">
                                                                                        <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Visible="False" Text="Add New Main Part" Width="190px"></asp:Button>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="96%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="25%" bgcolor="silver">
                                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="114px">Model</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; <asp:Label id="lblDescription" runat="server" cssclass="OutputText"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="114px">Customer</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblCustomer" runat="server" cssclass="OutputText" width="440px"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="114px">Revision</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblRevNo" runat="server" cssclass="OutputText" width="342px"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="114px">Effective
                                                                                    Date</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblEffectiveDate" runat="server" cssclass="OutputText" width="342px"></asp:Label></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td bgcolor="silver">
                                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="114px">Part List
                                                                                    No</asp:Label></td>
                                                                                <td>
                                                                                    <asp:Label id="lblPartListNo" runat="server" cssclass="OutputText" width="342px"></asp:Label></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <br />
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Part List
                                                                </td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <br />
                                                                    <table style="HEIGHT: 11px" width="96%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p align="center">
                                                                                        <asp:Label id="Label7" runat="server" cssclass="OutputText" width="">Search</asp:Label>&nbsp;
                                                                                        <asp:TextBox id="txtSearch" runat="server" Width="155px" CssClass="Input_Box"></asp:TextBox>
                                                                                        &nbsp; <asp:Label id="Label8" runat="server" cssclass="OutputText" width="">By</asp:Label>&nbsp;
                                                                                        <asp:DropDownList id="cmbBy" runat="server" CssClass="Input_Box">
                                                                                            <asp:ListItem Value="BOM.Part_No">Part No</asp:ListItem>
                                                                                            <asp:ListItem Value="PM.Part_Desc">Description</asp:ListItem>
                                                                                            <asp:ListItem Value="PM.Part_Spec">Specification</asp:ListItem>
                                                                                            <asp:ListItem Value="BOM.P_Level">Level</asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                        &nbsp;&nbsp;
                                                                                        <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" Text="SEARCH" CssClass="OutputText"></asp:Button>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <br />
                                                                    <p align="center">
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="96%" AllowSorting="True" OnSortCommand="SortGrid" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" OnPageIndexChanged="OurPager" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:HyperLinkColumn Text="View" DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="BOMMainDet.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                                <asp:TemplateColumn SortExpression="Part_No" HeaderText="Part No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblMainPart" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="Part_Desc" SortExpression="Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                                                <asp:TemplateColumn SortExpression="Part_Spec" HeaderText="Specification">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblPartSpec" runat="server" tooltip='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>' text='<%# DataBinder.Eval(Container.DataItem, "Short_Part_Spec") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:BoundColumn DataField="P_USAGE" HeaderText="USAGE">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:TemplateColumn SortExpression="P_Level" HeaderText="Level">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblLevel" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Level") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Alt">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="lblAltPart" runat="server" text='' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:HyperLinkColumn Text="View Alt" DataNavigateUrlField="seq_no" DataNavigateUrlFormatString="BOMAltList.aspx?ID={0}"></asp:HyperLinkColumn>
                                                                                <asp:TemplateColumn Visible="False">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                        <br />
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <p>
                                                        <table style="HEIGHT: 23px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Button id="Button1" onclick="cmdAddNew_Click" runat="server" Visible="False" Text="Add New Main Part" Width="190px"></asp:Button>
                                                                    </td>
                                                                    <td>
                                                                        <div align="center">
                                                                            <asp:Button id="cmdRemove" onclick="cmdRemove_Click_1" runat="server" Visible="False" Text="Remove selected item(s)" Width="191px"></asp:Button>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <div align="right">
                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="119px"></asp:Button>
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
                                <p>
                                </p>
                                <p>
                                </p>
                                <p>
                                    <Footer:Footer id="Footer" runat="server"></Footer:Footer>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
