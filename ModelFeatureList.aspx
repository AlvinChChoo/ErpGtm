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
            lblModelCode.text = ReqCOM.GetFieldVal("Select Model_Code from Model_Master where SEQ_No = " & trim(request.params("ID")) & ";","Model_Code")
            lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_master where Seq_No = " & trim(request.params("ID")) & ";","Model_Desc")
    
            procLoadGridData()
        end if
    End Sub
    
    Sub ProcLoadGridData
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet("Select * from Model_Feature_List where Model_Code = '" & trim(lblModelCode.text) & "' order by seq_no asc","Model_Feature_List")
        dtgModelFeature.DataSource=resExePagedDataSet.Tables("Model_Feature_List").DefaultView
        dtgModelFeature.DataBind()
    end sub
    
    
    Sub dtgModelFeature_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqExecuteNonQuery as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        For i = 0 To dtgModelFeature.Items.Count - 1
            Dim SeqNo As Label = Ctype(dtgModelFeature.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(dtgModelFeature.Items(i).FindControl("chkRemove"), CheckBox)
                Try
                    If remove.Checked = True Then
                        ReqExecuteNoNQuery.ExecuteNonQuery("Delete from Model_Feature_List where Seq_No = " & SeqNo.text & ";")
                    end if
                Catch
                   'MyError.Text = "There has been a problem with one or more of your inputs."
                End Try
        Next
        procLoadGridData()
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
    
    
        if page.isvalid = true then
            Dim StrSql as string
            StrSql = "Insert into Model_Feature_List"
            StrSql = StrSql + "(Model_Code,Feature) "
            StrSql = StrSql + "Select '" & trim(lblModelCode.text) & "',"
            StrSql = StrSql + "'" & trim(txtFeature.text) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
    
    
            txtFeature.text = ""
            Response.redirect("ModelFeatureList.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        procLoadGridData()
    End Sub
    
    Sub lnkBack_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ValDuplicateFeature(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select Model_Code from Model_Feature_List where Feature = '" & trim(txtFeature.text) & "' and Model_Code = '" & trim(lblModelCode.text) & "';","Model_Code") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("ModelDet.aspx?ID=" + request.params("ID"))
    End Sub

</script>
<! Customer.aspx ><html xmlns:erp= "xmlns:erp">
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
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
                                <asp:Label id="Label1" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">MODEL
                                FEATURE LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="valFeature" runat="server" ErrorMessage="You don't seem to have supplied a valid Model Feature." ControlToValidate="txtFeature" Display="Dynamic" ForeColor=" " CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" ControlToValidate="txtFeature" Display="Dynamic" ForeColor=" " CssClass="ErrorText" OnServerValidate="ValDuplicateFeature">
                                    'Model Feature' already exist.
                                </asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 38px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" width="139px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="lblModelCode" runat="server" width="380px" cssclass="OutputText"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label3" runat="server" width="122px" cssclass="LabelNormal">Model Name</asp:Label></td>
                                                                <td>
                                                                    <p>
                                                                        <asp:Label id="lblModelDesc" runat="server" width="359px" cssclass="OutputText"></asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    &nbsp; <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Model Feature </asp:Label>&nbsp;&nbsp; 
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:TextBox id="txtFeature" runat="server" CssClass="OutputText" MaxLength="100" Width="328px"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="Server" Width="151px" autopostback="true" Text="Save as new Feature"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgModelFeature" runat="server" width="100%" AutoGenerateColumns="False" ShowFooter="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="20" OnSelectedIndexChanged="dtgModelFeature_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right">
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Feature" HeaderText="Feature(s)"></asp:BoundColumn>
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
                                                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" Width="168px" Text="Remove Selected Item(s)" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="136px" Text="Back" CausesValidation="False"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
