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
        if page.isPostBack = false then
            Dim ReqGetFieldVal as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            procLoadGridData ()
            Dissql("Select U_ID from User_Profile where Dept_Code = 'R D' order by U_ID asc","U_ID","U_ID",cmbUID)
    
        end if
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
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        gridControl1.CurrentPageIndex = e.NewPageIndex
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("SELECT * FROM part_type_pic ORDER BY Part_Type ASC","part_type_pic")
        GridControl1.DataSource=resExePagedDataSet.Tables("part_type_pic").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Dim ReqCom as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if page.isvalid = true then
            ReqCOM.ExecuteNonQuery("Insert into Part_Type_PIC(part_type,U_ID) select '" & ucase(trim(cmbPartType.selecteditem.value)) & "','" & trim(cmbUID.selecteditem.value) & "';")
            procLoadGridData ()
        end if
    End Sub
    
    Sub cmdpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim i As Integer
        Dim SeqNo As Label
        Dim remove As CheckBox
    
    
        For i = 0 To GridControl1.Items.Count - 1
            SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
            remove = CType(GridControl1.Items(i).FindControl("Remove"), CheckBox)
    
            Try
                If remove.Checked = true Then
                    ReqCOM.ExecuteNonQuery("Delete from Part_Type_PIC where Seq_No = " & SeqNo.text & ";")
                end if
            Catch
            End Try
        Next
        procLoadGridData ()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub ValInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCom as erp_gtm.ERp_gtm = new erp_gtm.ERp_gtm
        e.isvalid = true
        if ReqCOM.funcCheckDuplicate("select part_type from Part_Type_PIC where part_type = '" & trim(cmbpartType.selecteditem.value) & "' and U_ID = '" & trim(cmbUId.selecteditem.value) & "';","Part_Type") = true then e.isvalid = false :Exit sub
        'cmbpartType
        'cmbUId
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">PART
                                TYPE PIC</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 231px" cellspacing="0" cellpadding="0" width="75%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <div align="center">
                                                    <asp:CustomValidator id="ValInput" runat="server" Width="100%" CssClass="ErrorText" OnServerValidate="ValInput_ServerValidate" EnableClientScript="False" ForeColor=" " Display="Dynamic" ErrorMessage="Part type for this engineer already exist."></asp:CustomValidator>
                                                </div>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Part Type">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartType" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Type") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Engineer">
                                                                <ItemTemplate>
                                                                    <asp:Label id="UID" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "U_ID") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
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
                                                <p align="center">
                                                    <table style="HEIGHT: 8px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="79px">Part Type</asp:Label></td>
                                                                                    <td width="75%">
                                                                                        <asp:DropDownList id="cmbPartType" runat="server" Width="100%" CssClass="OutputText">
                                                                                            <asp:ListItem Value="MECHANICAL">MECHANICAL</asp:ListItem>
                                                                                            <asp:ListItem Value="ELECTRICAL">ELECTRICAL</asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="79px">User ID</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:DropDownList id="cmbUId" runat="server" Width="100%" CssClass="OutputText"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="2">
                                                                                        <p align="center">
                                                                                            <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Width="173px" Text="Add New"></asp:Button>
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
                                                <p align="center">
                                                    <table style="HEIGHT: 16px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="50%">
                                                                    <p align="left">
                                                                        <asp:Button id="cmdpdate" onclick="cmdpdate_Click" runat="server" Width="188px" Text="Remove Selected Item(s)" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="50%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="188px" Text="Back" CausesValidation="False"></asp:Button>
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
