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
        if page.ispostback = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
                    lblModelCode.text = ReqCOM.GetFieldVal("Select Model_Code from Model_Master where SEQ_No = " & trim(request.params("ID")) & ";","Model_Code")
            lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_master where Seq_No = " & trim(request.params("ID")) & ";","Model_Desc")
            procLoadGridData()
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from Model_Pic where Model_Code = '" & trim(lblModelCode.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Model_Pic")
        dtgModelPic.DataSource=resExePagedDataSet.Tables("Model_Pic").DefaultView
        dtgModelPic.DataBind()
    end sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqExecuteNonQuery as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        For i = 0 To dtgModelPic.Items.Count - 1
            Dim SeqNo As Label = Ctype(dtgModelPic.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(dtgModelPic.Items(i).FindControl("chkRemove"), CheckBox)
            If remove.Checked = True Then ReqExecuteNoNQuery.ExecuteNonQuery("Delete from Model_Pic where Seq_No = " & SeqNo.text & ";")
        Next
        procLoadGridData()
    End Sub
    
    
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        procLoadGridData()
    End Sub
    
    Sub lnkBack_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub dtgModelColor_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgModelPic_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ImageButton1_Click(sender As Object, e As ImageClickEventArgs)
    End Sub
    
    Sub Menu1_Load(sender As Object, e As EventArgs)
    End Sub
    
    Sub UserControl2_Load(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgModelFeature_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ValDuplicateDesc(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        if ReqCOM.funcCheckDuplicate("Select * from Model_Pic where Model_Code='" & trim(lblModelCode.text) & "' and Pic_Desc='" & trim(txtDesc.text) & "';","Model_Code") = True then
            e.isvalid = false
        else
            e.isvalid = true
        end if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("ModelDet.aspx?ID=" + request.params("ID"))
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim PicID as integer = ReqCOM.FuncGetPicID()
            Dim strSql,FileName,ThumbName as string
            Dim FileType as string = FileControl.PostedFile.ContentType
    
            Select case FileType
                case "image/pjpeg" : FileName = "ModelPic\" & PicID & ".jpg"
                case "image/bmp" : FileName = "ModelPic\" & PicID &".bmp"
                case "image/gif" : FileName = "ModelPic\" & PicID &".gif"
                case "image/jpeg" : FileName = "ModelPic\" & PicID & ".jpg"
                case "image/jpg" : FileName = "ModelPic\" & PicID & ".jpg"
            end select
    
            StrSQL = "Insert into Model_Pic(Model_Code,Pic_Desc,Photo_name)"
            StrSql = StrSql + " Select '" & trim(lblModelCode.text) & "',"
            StrSql = StrSql + "'" & trim(txtDesc.text) & "',"
            StrSql = StrSql + "'" & trim(FileName) & "';"
            ReqCOM.ExecuteNonQuery(StrSQL)
    
            fileControl.PostedFile.SaveAs((Mappath("") + "\" + FileName))
            Response.redirect("ModelPic.aspx?ID=" & Request.params("ID"))
        End if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 4px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">MODEL PHOTO
                                LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:RequiredFieldValidator id="ValDesc" runat="server" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid image description." ControlToValidate="txtDesc" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                </p>
                                                <p>
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" CssClass="ErrorText" ControlToValidate="txtDesc" Display="Dynamic" ForeColor=" " OnServerValidate="ValDuplicateDesc">
                                    Photo Description already exist.
                                </asp:CustomValidator>
                                                </p>
                                                <table style="HEIGHT: 38px" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Model No</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:Label id="lblModelCode" runat="server" width="359px" cssclass="OutputText">Label</asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal">Model Name</asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                            </td>
                                                            <td>
                                                                <p>
                                                                    <asp:Label id="lblModelDesc" runat="server" width="359px" cssclass="OutputText">Label</asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 62px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Image Description</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtDesc" runat="server" Width="439px"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">File Path</asp:Label></td>
                                                                <td>
                                                                    <input id="fileControl" style="WIDTH: 437px; HEIGHT: 20px" type="file" size="22" runat="server" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <p align="center">
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Text="Add Product Image"></asp:Button>
                                                                        <asp:Label id="lblFileType" runat="server" visible="false">Label</asp:Label>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgModelPic" runat="server" width="100%" OnSelectedIndexChanged="dtgModelPic_SelectedIndexChanged" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False" HeaderStyle-CssClass="CartListHead" ItemStyle-CssClass="CartListItem" AlternatingItemStyle-CssClass="CartListItemAlt" PageSize="50">
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn>
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Pic_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Picture">
                                                                <ItemTemplate>
                                                                    <a href="javascript:ShowPic('<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>')"><img style="WIDTH: 50px; HEIGHT: 50px" height="21" src='<%# Container.DataItem( "Photo_Name" )%>' width="24" align="absBottom" border="0" /></a> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Remove">
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
                                                    <table style="HEIGHT: 13px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" Width="179px" Text="Remove selected Image" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="130px" Text="Back" CausesValidation="False"></asp:Button>
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
