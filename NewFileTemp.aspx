<%@ Page Language="VB" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            cmdAddNew.attributes.add("onClick","javascript:if(confirm('This will create a new approval sheet document.\nAre you sure to continue ?')==false) return false;")
            procLoadGridData ()
        End If
    End Sub

    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub

    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string

        StrSql = "SELECT * FROM Lot_Closure_M ORDER BY lot_closure_no desc"

        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"CUST")
        GridControl1.DataSource=resExePagedDataSet.Tables("CUST").DefaultView
        GridControl1.DataBind()
    end sub


    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        response.redirect("UnitPriceApprovalSheetAddNew.aspx")
    End Sub

    Sub Button3_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        ProcLoadGridData()
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            'Dim Create as label = CType(e.Item.FindControl("Create"), Label)

            Dim CreateDate as label = CType(e.Item.FindControl("CreateDate"), Label)

            if trim(CreateDate.text) <> "" then format(cdate(CreateDate.text),"dd/MM/yy")




        End if
    End Sub

    Sub cmbSearch_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub ItemCommandUPAS(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim UPANo As Label = CType(e.Item.FindControl("UPANo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM

        if ucase(e.commandArgument) = "VIEW" then Response.redirect("NewFileTemp1.aspx?ID=" & clng(SeqNo.text))

    end sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)

    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">UNIT PRICE
                                APPROVAL LIST</asp:Label>
                                <table style="HEIGHT: 12px" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center"><asp:Label id="Label3" runat="server" cssclass="OutputText">SEARCH</asp:Label>&nbsp;&nbsp;
                                                    <asp:TextBox id="txtSearch" runat="server" Width="134px" CssClass="OutputText"></asp:TextBox>
                                                    &nbsp;&nbsp; <asp:Label id="Label2" runat="server" cssclass="OutputText">BY</asp:Label>&nbsp;&nbsp;
                                                    <asp:DropDownList id="cmbSearch" runat="server" CssClass="OutputText" OnSelectedIndexChanged="cmbSearch_SelectedIndexChanged">
                                                        <asp:ListItem Value="UPA_NO">UPA No</asp:ListItem>
                                                        <asp:ListItem Value="PART_NO">PART NO</asp:ListItem>
                                                        <asp:ListItem Value="SUBMIT_BY">BUYER USER ID</asp:ListItem>
                                                        <asp:ListItem Value="VEN_CODE">SUPPLIER</asp:ListItem>
                                                        <asp:ListItem Value="M_PART_NO">MPN</asp:ListItem>
                                                        <asp:ListItem Value="PART_SPEC">SPECIFICATION</asp:ListItem>
                                                        <asp:ListItem Value="PART_DESC">DESCRIPTION</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;<asp:Label id="Label7" runat="server" cssclass="OutputText">Show </asp:Label>
                                                    <asp:DropDownList id="cmbUPAStatus" runat="server" CssClass="OutputText">
                                                        <asp:ListItem Value= "">ALL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING APPROVAL" Selected="True">PENDING APPROVAL</asp:ListItem>
                                                        <asp:ListItem Value="PENDING SUBMISSION">PENDING SUBMISSION</asp:ListItem>
                                                        <asp:ListItem Value="REJECTED">REJECTED</asp:ListItem>
                                                        <asp:ListItem Value="APPROVED">APPROVED</asp:ListItem>
                                                    </asp:DropDownList>
                                                    &nbsp;&nbsp;&nbsp;<asp:Button id="Button3" onclick="Button3_Click" runat="server" CssClass="OutputText" Text="QUICK SEARCH"></asp:Button>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemCommand="ItemCommandUPAS" OnItemDataBound="FormatRow" AutoGenerateColumns="False" ShowFooter="True" Font-Name="Verdana" cellpadding="4" BorderColor="Gray" AllowPaging="True" OnPageIndexChanged="OurPager" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgView" ToolTip="View this item" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                                                    <asp:Label id="SeqNo" runat="server" visible="false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Create By/Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CreateBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "CREATE_BY") %>' /> - <asp:Label id="CreateDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_Closure_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="10%" bgcolor="red">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label4" runat="server" cssclass="OutputText" width="100%">Urgent
                                                                    UPA</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="yellow">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label5" runat="server" cssclass="OutputText" width="100%">Normal
                                                                    UPA</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="white">
                                                                </td>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label6" runat="server" cssclass="OutputText" width="100%">Completed
                                                                    UPA</asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="177px" Text="Add New Approval Sheet"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="136px" Text="Back"></asp:Button>
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
