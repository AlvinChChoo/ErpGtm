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
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
    
        Dim FileName as string = ""
        Dim StrSql as string
        Dim FileType as string = FileControl.PostedFile.ContentType
        Dim FileSize as Integer = FileControl.PostedFile.ContentLength
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim PicSeq as String = ReqCOM.GetFieldVal("Select Max(Seq_No)+1 as [MaxSeq] from Model_Pic","MaxSeq")
    
        if FileType = "image/pjpeg" then FileName = "ModelPic\" + PicSeq + ".jpg"
        if FileType = "image/bmp" then FileName = "ModelPic\" + PicSeq +".bmp"
        if FileType = "image/gif" then FileName = "ModelPic\" + PicSeq +".gif"
    
    
        Try
            fileControl.PostedFile.SaveAs((Mappath("") + "\" + FileName))
            StrSQL = "Insert into Model_Pic(Model_Code,Pic_Desc,Pic_Path)"
            StrSql = StrSql + " Select '" & trim(lblModelCode.text) & "',"
            StrSql = StrSql + "'" & trim(txtDesc.text) & "',"
            StrSql = StrSql + "'" & trim(FileName) & "';"
            ReqCOM.ExecuteNonQuery(StrSQL)
            ProcLoadGridData()
        Catch err As Exception
            'lblerror.text = err.tostring()
        End Try
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

</script>
<link href="IBuySpy.css" type="text/css" rel="stylesheet">
<script language="javascript" src="script.js" type="text/javascript"></script>
<table style="HEIGHT: 497px" cellspacing="0" cellpadding="0" width="100%" border="0">
    <tbody>
        <tr>
            <td valign="top" nowrap="nowrap" align="left" width="100%">
                <p align="center">
                    &nbsp;
                </p>
                <p>
                    &nbsp;
                </p>
                <p>
                    &nbsp;
                </p>
                <p>
                    <table style="HEIGHT: 12px" width="100%" border="1">
                        <tbody>
                            <tr>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p>
                                        &nbsp;
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
                                        To add new&nbsp;Photo for this model, fill in details and click 'Add New' 
                                    </p>
                                    <table style="HEIGHT: 62px" width="100%" border="1">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    Image&nbsp;Description&nbsp;&nbsp;&nbsp;&nbsp; 
                                                </td>
                                                <td>
                                                    <asp:TextBox id="txtDesc" runat="server" Width="376px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Image Path</td>
                                                <td width="100%">
                                                    <input id="fileControl" style="WIDTH: 374px; HEIGHT: 20px" type="file" runat="server" /></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <p>
                                        <asp:RequiredFieldValidator id="ValDesc" runat="server" Display="Dynamic" ControlToValidate="txtDesc" ErrorMessage="'Description' must not be left blank."></asp:RequiredFieldValidator>
                                    </p>
                                    <p>
                                        &nbsp;<asp:CustomValidator id="CustomValidator1" runat="server" Display="Dynamic" ControlToValidate="txtDesc" OnServerValidate="ValDuplicateDesc">
                                    Photo Description already exist.
                                </asp:CustomValidator>
                                    </p>
                                    <p>
                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="Server" Text="Add New" autopostback="true"></asp:Button>
                                    </p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </p>
                <p>
                    <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="130px" Text="<<  Back" CausesValidation="False"></asp:Button>
                </p>
            </td>
        </tr>
    </tbody>
</table>