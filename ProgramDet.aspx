<%@ Page Language="VB" Debug="true" %>
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
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            lblGroup.text = ReqCOM.GetFieldVal("Select Group_Name from Program_Group_M where Seq_No = " & cint(request.params("ID")) & ";","Group_Name")
            lblDesc.text = ReqCOM.GetFieldVal("Select Group_Desc from Program_Group_M where Seq_No = " & cint(request.params("ID")) & ";","Group_Desc")
            procLoadGridData ()
    
    
            Dissql ("Select * from Mod_Reg_D order by Mod_Desc asc","Seq_No","Mod_Name",cmbGroup)
    
        end if
    End Sub
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        ProcLoadGridData()
    end sub
    
    Sub ProcLoadGridData()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim GroupDesc as string = reqExePagedDataSet.getFieldVal("select Group_Name from Program_Group_m where seq_No = " & cint(request.params("ID")) & ";","Group_Name")
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("SELECT mod.Mod_Name,PG.Seq_No,PG.Group_desc,PG.Form_ID,MOD.MOD_Desc FROM program_group_d PG,Mod_Reg_D Mod where pg.form_ID = mod.Seq_No AND GROUP_DESC = '" & TRIM(GroupDesc) & "' ORDER BY PG.Group_desc ASC","program_group_m")
        GridControl1.DataSource=resExePagedDataSet.Tables("program_group_m").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ValDuplicateColor(sender As Object, e As ServerValidateEventArgs)
    
    End Sub
    
    Sub ValDuplicateGroup(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select Form_ID,group_desc from Program_Group_D where group_desc = '" & trim(lblGroup.text) & "' and FORM_ID = " & cint(cmbGroup.selectedItem.value) & ";","group_desc") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        Dim ReqCom as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if page.isvalid = true then
            ReqCOM.ExecuteNonQuery("Insert into Program_group_d(Group_Desc,Form_ID) select '" & ucase(trim(lblGroup.text)) & "'," & cint(cmbGroup.selectedItem.value) & ";")
            response.redirect("ProgramDet.aspx?ID=" & request.params("ID"))
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
        Dim oList As ListItemCollection = obj.Items
        oList.Add(New ListItem(""))
        obj.Items.FindByText("").Selected = True
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim lblSeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
    
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQuery("Delete from Program_Group_d where Seq_No = '" & trim(lblSeqNo.text) & "';") : Response.redirect("ProgramDet.aspx?ID=" & Request.params("ID"))
    end sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("ProgramGroup.aspx")
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
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">GROUP
                                ACCESS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 231px" cellspacing="0" cellpadding="0" width="80%" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Program Group</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:Label id="lblGroup" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Description</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblDesc" runat="server" cssclass="OutputText" width="318px"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="valFeature" runat="server" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid Program Name." CssClass="ErrorText" ControlToValidate="cmbGroup"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" ForeColor=" " Display="Dynamic" ErrorMessage="Program Name already exist." CssClass="ErrorText" OnServerValidate="ValDuplicateGroup"></asp:CustomValidator>
                                                </div>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="150px">Program
                                                                    Name</asp:Label></td>
                                                                <td width="100%">
                                                                    <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td width="75%">
                                                                                    <asp:DropDownList id="cmbGroup" runat="server" Width="100%" CssClass="OutputText"></asp:DropDownList>
                                                                                </td>
                                                                                <td>
                                                                                    <div align="right">
                                                                                        <asp:Button id="cmdNew" onclick="cmdAddNew_Click" runat="server" Width="86px" CssClass="OutputText" Text="Add New"></asp:Button>
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
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemCommand="ItemCommand" AutoGenerateColumns="False" cellpadding="4" BorderColor="Gray" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Description">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblModName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MOD_DESC") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Module Name">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblModName1" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MOD_NAME") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Action">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgDelete" ToolTip="Delete this item" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server" CausesValidation="False"></asp:ImageButton>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 4px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="114px" CssClass="OutputText" Text="Back" CausesValidation="False"></asp:Button>
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
