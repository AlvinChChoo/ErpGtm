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
            ProcLoadGridData("Select * from user_profile where " & cmbSearchField.selectedItem.value & " LIKE '%" & txtSearch.Text & "%' order by u_name")
        End if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData("Select * from user_profile where " & cmbSearchField.selectedItem.value & " LIKE '%" & txtSearch.Text & "%' order by u_name")
    end sub
    
    Sub ProcLoadGridData(StrSql as string)
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"User_Profile")
        GridControl1.DataSource=resExePagedDataSet.Tables("User_Profile").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdNew_Click(sender As Object, e As EventArgs)
        response.redirect("UserProfileAddNew.aspx")
    End Sub
    
    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        For i = 0 To GridControl1.Items.Count - 1
            Dim UserID As Label = CType(GridControl1.Items(i).FindControl("UserID"), Label)
            Dim remove As CheckBox = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from User_Profile where U_ID = '" & trim(UserID.text) & "';")
                end if
            Catch
    
            End Try
        Next
        Response.redirect("UserProfile.aspx")
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        ProcLoadGridData("Select * from user_profile where " & cmbSearchField.selectedItem.value & " LIKE '%" & txtSearch.Text & "%' order by u_name")
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        'UserProfileDet
    
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("UserProfileDet.aspx?ID=" & clng(SeqNo.text))
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQuery("Delete from User_Profile where Seq_No = " & clng(SeqNo.text) & ";") : Response.redirect("UserProfile.aspx")
    
    
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
        </p>
        <p>
            <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" forecolor="" backcolor="" cssclass="FormDesc" width="100%">USER
                                PROFILE</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 10px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <asp:Label id="Label2" runat="server" cssclass="OutputText">Search</asp:Label>&nbsp;<asp:TextBox id="txtSearch" runat="server" Width="131px" CssClass="OutputText"></asp:TextBox>
                                                                        &nbsp;<asp:Label id="Label3" runat="server" cssclass="OutputText">By</asp:Label>&nbsp;<asp:DropDownList id="cmbSearchField" runat="server" Width="188px" CssClass="OutputText">
                                                                            <asp:ListItem Value="U_Name">User Name</asp:ListItem>
                                                                            <asp:ListItem Value="Dept_Code">Dept</asp:ListItem>
                                                                            <asp:ListItem Value="U_ID">User ID</asp:ListItem>
                                                                        </asp:DropDownList>
                                                                        &nbsp;&nbsp; 
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="58px" CssClass="OutputText" CausesValidation="False" Text="GO"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemCommand="ItemCommand" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" GridLines="None" BorderColor="Black" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Font-Names="Verdana" Font-Size="XX-Small">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="User ID">
                                                                <ItemTemplate>
                                                                    <asp:Label id="UserID" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "U_ID") %>' /> <asp:Label id="SeqNo" runat="server" visible="false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="U_NAME" HeaderText="User Name"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="DEPT_CODE" HeaderText="Dept"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="CONTACT_NO" HeaderText="Contact No."></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="EMAIL" HeaderText="EMAIL"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Action">
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgView" ToolTip="View this item" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                                                    <asp:ImageButton id="ImgDelete" ToolTip="Delete this item" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdNew" onclick="cmdNew_Click" runat="server" Width="173px" Text="New User Registration"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="190px" CausesValidation="False" Text="Remove Selected User"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" runat="server" Width="138px" CausesValidation="False" Text="Back"></asp:Button>
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
