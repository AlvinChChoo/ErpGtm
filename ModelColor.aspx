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
        if ispostback = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dissql ("Select Color_Desc from Color order by Color_Desc asc","Color_Desc","Color_Desc",cmbModelColor)
            lblModelCode.text = ReqCOM.GetFieldVal("Select Model_Code from Model_Master where SEQ_No = " & trim(request.params("ID")) & ";","Model_Code")
            lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_master where Seq_No = " & trim(request.params("ID")) & ";","Model_Desc")
            procLoadGridData()
        end if
    End Sub
    
    Sub ProcLoadGridData()
    
        Dim StrSql as string = "Select * from Model_Color where Model_Code = '" & trim(lblModelCode.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"model_Color")
        dtgModelColor.DataSource=resExePagedDataSet.Tables("model_Color").DefaultView
        dtgModelColor.DataBind()
    end sub
    
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
    
    Sub Menu1_Load(sender As Object, e As EventArgs)
    End Sub
    
    Sub UserControl2_Load(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgModelFeature_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqExecuteNonQuery as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        For i = 0 To dtgModelColor.Items.Count - 1
            Dim SeqNo As Label = Ctype(dtgModelColor.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(dtgModelColor.Items(i).FindControl("chkRemove"), CheckBox)
                Try
                    If remove.Checked = True Then
                        ReqExecuteNoNQuery.ExecuteNonQuery("Delete from Model_Color where Seq_No = " & SeqNo.text & ";")
                    end if
                Catch
                   'MyError.Text = "There has been a problem with one or more of your inputs."
                End Try
        Next
        procLoadGridData()
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim StrSql as string
            StrSql = "Insert into Model_Color"
            StrSql = StrSql + "(Model_Code,Color_Desc) "
            StrSql = StrSql + "Select '" & trim(lblModelCode.text) & "',"
            StrSql = StrSql + "'" & trim(cmbModelColor.selecteditem.text) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
            Response.redirect("ModelColor.aspx?ID=" & request.params("ID"))
        end if
    End Sub
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        procLoadGridData()
    End Sub
    
    
    
    Sub dtgModelColor_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    'SUb Dissql(ByVal strSql As String,FName as string,Obj as Object)
    Sub Dissql()
        '"Select * from Color","Color_Desc","cmbModelColor"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader("Select * from Color")
    
        with cmbModelColor
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = "Color_Desc"
            .DataTextField = "Color_Desc"
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub ValDuplicateColor(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select Model_Code from Model_Color where Color_Desc = '" & trim(cmbModelColor.selecteditem.text) & "' and Model_Code = '" & trim(lblModelCode.text) & "';","Model_Code") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("ModelDet.aspx?ID=" + request.params("ID"))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 197px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" backcolor="" forecolor="" width="100%">MODEL
                                COLOR LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="323px" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ControlToValidate="cmbModelColor" OnServerValidate="ValDuplicateColor">
                                    Model with this color already exist.
                                </asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 38px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="114px">Model No</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="lblModelCode" runat="server" cssclass="OutputText" width="359px"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="114px">Model Name</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                </td>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText" width="359px"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 9px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Model Color</asp:Label>&nbsp;&nbsp; 
                                                                    <asp:DropDownList id="cmbModelColor" runat="server" Width="288px" CssClass="OutputText"></asp:DropDownList>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="Server" Text="Save as new product color" Width="185px" autopostback="true"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgModelColor" runat="server" width="100%" PageSize="20" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgModelColor_SelectedIndexChanged">
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible= "false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Color_Desc" HeaderText="Model Colors"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Remove">
                                                                <HeaderStyle horizontalalign="Center"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <center>
                                                                        <asp:CheckBox id="chkRemove" runat="server" />
                                                                    </center>
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" CausesValidation="False" Text="Remove Selected Item(s)" Width="175px"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" CausesValidation="False" Text="Back" Width="140px"></asp:Button>
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
</body>
</html>
