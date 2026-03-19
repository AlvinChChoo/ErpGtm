<%@ Page Language="VB" %>
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
        if page.isPostBack = false then procLoadGridData ()
     End Sub
    
     Sub OurPager(sender as object,e as datagridpagechangedeventargs)
         gridControl1.CurrentPageIndex = e.NewPageIndex
         ProcLoadGridData()
     end sub
    
     Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from tariff where TARIFF_CODE + TARIFF_DESC like '%" & txtSearch.Text & "%'  order by tariff_code"
         Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
         Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Tariff")
         GridControl1.DataSource=resExePagedDataSet.Tables("Tariff").DefaultView
         GridControl1.DataBind()
     end sub
    
     Sub Button1_Click(sender As Object, e As EventArgs)
         ProcLoadGridData()
     End Sub
    
     Sub UpdateList()
        'MyError.Text = ""
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim TariffCode As Label = CType(GridControl1.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from tariff where Tariff_Code = '" & trim(TariffCode.text) & "';")
                end if
            Catch
               ' MyError.Text = "There has been a problem with one or more of your inputs."
            End Try
        Next
        procLoadGridData ()
    
    End Sub
    
     Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
     End Sub
    
     Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        UpdateList()
    End Sub
    
    Sub cmdNew_Click(sender As Object, e As EventArgs)
        response.redirect("TariffAdd.aspx")
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        If page.isvalid = true then
            Dim ReqCom as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim strSql as string
            StrSql = "Insert into Tariff (Tariff_Code,Tariff_Desc,Create_By,Create_Date) "
            StrSql = StrSql + "Select '" & ucase(trim(txtTariffCode.text)) & "','" & ucase(trim(txtTariffDesc.text)) & "',"
            StrSql = StrSql + "'" & trim(request.cookies("U_ID").value) & "','" & now & "';"
            ReqCOM.ExecuteNonQuery(StrsQL)
            txtTariffCode.text = ""
            txtTariffDesc.text = ""
            response.redirect("Tariff.aspx")
        End if
    End Sub
    
    Sub ValDuplicateTariff(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as erp_gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If ReqCom.FuncCheckDuplicate("Select Tariff_Code from Tariff where Tariff_Code = '" & trim(txtTariffCode.text) & "';","Tariff_Code") = true then
            e.isvalid = false
        else
            e.isvalid = true
        end if
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
            <table style="HEIGHT: 497px" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <div align="center"><asp:Label id="Label1" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">TARIFF
                                LIST</asp:Label>
                            </div>
                            <p>
                                <table style="WIDTH: 100%; HEIGHT: 51px" align="center" border="1" nowrap="nowrap">
                                    <tbody>
                                        <tr valign="top">
                                            <td nowrap="nowrap">
                                                <table style="WIDTH: 100%; HEIGHT: 7px">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label3" runat="server" cssclass="labelNormal" width="73px">Search :</asp:Label>
                                                                <asp:TextBox id="txtSearch" runat="server" Width="208px"></asp:TextBox>
                                                            </td>
                                                            <td colspan="3">
                                                                <div align="right">
                                                                    <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="93px" Text="GO" CausesValidation="False"></asp:Button>
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
                                <table style="HEIGHT: 16px" width="100%" align="center" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="4" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="TARIFF CODE">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "TARIFF_CODE") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="TARIFF_DESC" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CURR_BAL" HeaderText="CURRENT BAL" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
                                                            <asp:BoundColumn DataField="BAL_CF" HeaderText="C / F" DataFormatString="{0:f}">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                            </asp:BoundColumn>
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
                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="179px" Text="Remove Selected Item(s)" CausesValidation="False"></asp:Button>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <p>
                            </p>
                            <p>
                                <table style="HEIGHT: 28px" width="100%" border="1">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    &nbsp;<asp:Label id="Label2" runat="server" cssclass="Instruction">To add new Tariff,
                                                    key in Tariff Code, Tariff Description and click 'Add New'</asp:Label> 
                                                </p>
                                                <p>
                                                    <table width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label8" runat="server" cssclass="labelNormal" width="114px">Tariff
                                                                    Code</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtTariffCode" runat="server" Width="258px" CssClass="OutputText" MaxLength="20"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label9" runat="server" cssclass="labelNormal" width="128px">Tariff
                                                                    Description</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtTariffDesc" runat="server" Width="100%" CssClass="OutputText" MaxLength="35"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" CssClass="ErrorText" ForeColor=" " OnServerValidate="ValDuplicateTariff" ControlToValidate="txttariffCode" Display="Dynamic">
                                    'Tariff Code' already exist.
                                </asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="valTariffCode" runat="server" CssClass="ErrorText" ForeColor=" " ControlToValidate="txtTariffCode" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Tariff Code."></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:RequiredFieldValidator id="ValTariffDesc" runat="server" CssClass="ErrorText" ForeColor=" " ControlToValidate="txtTariffDesc" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Tariff Description."></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:Button id="Button2" onclick="cmdAddNew_Click" runat="server" Width="173px" Text="Add New"></asp:Button>
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
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
