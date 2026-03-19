<%@ Control Language="VB" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            procLoadGridData ()
            lblMaxRec.text = cint(ReqCOM.GetFieldVal("Select Grid_Max_Rec from Main","Grid_Max_Rec"))
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "SELECT * FROM UOM WHERE UOM like '%" & cstr(txtSearch.Text) & "%'  ORDER BY UOM ASC"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"UOM")
        GridControl1.DataSource=resExePagedDataSet.Tables("UOM").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        GridControl1.currentpageindex=0
        if isnumeric(txtNoOfRec.text) = false then  txtNoOfRec.text = lblMaxRec.text
        if txtNoOfRec.text = "" then txtNoOfRec.text = lblMaxRec.text
        if txtNoOfRec.text > cint(lblMaxRec.text) then  txtNoOfRec.text = lblMaxRec.text
        if txtNoOfRec.text < 1 then  txtNoOfRec.text = lblMaxRec.text
        gridcontrol1.PageSize= txtNoOfRec.text
        ProcLoadGridData()
    End Sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
            ReqCOM.ExecuteNonQuery("Insert into UOM(UOM) select '" & trim(txtUOM.text) & "';")
            procLoadGridData ()
        end if
    End Sub
    
    Sub ValDuplicateUOM(sender As Object, e As ServerValidateEventArgs)
    Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select uom from uom where uom = '" & trim(txtUOM.text) & "';","uom") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim SeqNo As Label = CType(GridControl1.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from UOM where UOM = '" & trim(SeqNo.text) & "';")
                end if
            Catch
    
            End Try
        Next
        procLoadGridData ()
    End Sub

</script>
<link href="IBuySpy.css" type="text/css" rel="stylesheet">
<table style="HEIGHT: 497px" cellspacing="0" cellpadding="0" width="100%" border="0">
    <tbody>
        <tr>
            <td valign="top" nowrap="nowrap" align="left" width="100%">
                <p align="center">
                    <asp:Label id="Label1" cssclass="FormDesc" width="100%" runat="server">UNIT OR MEASUREMENT
                    (UOM)LIST</asp:Label>
                </p>
                <p align="center">
                    <table style="WIDTH: 100%; HEIGHT: 51px" align="center" border="1">
                        <tbody>
                            <tr>
                                <td>
                                    <table style="WIDTH: 100%; HEIGHT: 7px">
                                        <tbody>
                                            <tr>
                                                <td colspan="3">
                                                    <asp:Label id="Label2" cssclass="LabelNormal" width="55px" runat="server">Search :</asp:Label>&nbsp;<asp:TextBox id="txtSearch" runat="server" Width="222px"></asp:TextBox>
                                                    &nbsp; <asp:Label id="Label3" cssclass="LabelNormal" width="95px" runat="server">By
                                                    Description</asp:Label></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="WIDTH: 100%; HEIGHT: 19px">
                                        <tbody>
                                            <tr valign="top">
                                                <td>
                                                    <asp:Label id="Label4" cssclass="LabelNormal" width="158px" runat="server">No of Records
                                                    to display</asp:Label>&nbsp;&nbsp;<asp:TextBox id="txtNoOfRec" runat="server" Width="63px"></asp:TextBox>
                                                    <asp:Label id="Label5" cssclass="LabelNormal" width="28px" runat="server"> (Max</asp:Label>&nbsp;<asp:Label id="lblMaxRec" runat="server"></asp:Label>&nbsp;<asp:Label id="Label6" cssclass="LabelNormal" width="68px" runat="server"> records)</asp:Label></td>
                                                <td valign="top" colspan="2">
                                                    <div align="left">
                                                    </div>
                                                    <div align="right">
                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Text="GO" CausesValidation="False"></asp:Button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </p>
                <p>
                </p>
                <p>
                </p>
                <p align="center">
                    <table style="HEIGHT: 25px" width="100%" border="1">
                        <tbody>
                            <tr>
                                <td>
                                    <p>
                                        &nbsp;<asp:DataGrid id="GridControl1" width="100%" runat="server" AutoGenerateColumns="False" ShowFooter="True" cellpadding="4" GridLines="Vertical" BorderColor="Black" AllowPaging="True" OnPageIndexChanged="OurPager" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Height="216px">
                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                            <Columns>
                                                <asp:TemplateColumn HeaderText="DESCRIPTION">
                                                    <ItemTemplate>
                                                        <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UOM") %>' /> 
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderText="Remove">
                                                    <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                    <ItemStyle horizontalalign="Center"></ItemStyle>
                                                    <ItemTemplate>
                                                        <center>
                                                            <asp:CheckBox id="Remove" runat="server" />
                                                        </center>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                            </Columns>
                                        </asp:DataGrid>
                                    </p>
                                    <p align="right">
                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" Width="185px" Text="Remove Selected Item(s)" CausesValidation="False"></asp:Button>
                                    </p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </p>
                <p>
                    <table style="HEIGHT: 28px" width="100%" border="1">
                        <tbody>
                            <tr>
                                <td>
                                    <p>
                                        <asp:Label id="Label7" cssclass="LabelNormal" width="394px" runat="server">To add
                                        new UOM, key in Unit and click 'Add New' </asp:Label>
                                    </p>
                                    <table style="HEIGHT: 17px" width="100%" border="1">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <asp:Label id="Label8" width="90px" runat="server">Unit</asp:Label></td>
                                                <td width="100%">
                                                    <asp:TextBox id="txtUOM" runat="server" Width="359px" CssClass="OutputText" MaxLength="100"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <p>
                                        <asp:CustomValidator id="CustomValidator1" runat="server" CssClass="ErrorText" Display="Dynamic" ControlToValidate="txtUOM" OnServerValidate="ValDuplicateUOM" ForeColor=" ">
                                    'Unit' already exist.
                                </asp:CustomValidator>
                                    </p>
                                    <p>
                                        <asp:RequiredFieldValidator id="valFeature" runat="server" CssClass="ErrorText" Display="Dynamic" ControlToValidate="txtUOM" ForeColor=" " ErrorMessage="'Unit' must not be left blank."></asp:RequiredFieldValidator>
                                    </p>
                                    <p>
                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="Server" Text="Add New" autopostback="true"></asp:Button>
                                        &nbsp;&nbsp; 
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