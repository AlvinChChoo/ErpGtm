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
        cmdDelete.attributes.add("onClick","javascript:if(confirm('This action will remove the selected attachment from this SSER.\nYou will not be able to undo the changes made.\nAre you sure to continue ?')==false) return false;")
        if page.ispostback = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            lblSRNo.text = reqCOM.GetFieldVal("Select top 1 SR_NO from SR_m where Seq_No = " & request.params("ID") & ";","SR_NO")
            procLoadGridData()
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from SR_ATTACHMENT where SR_NO = '" & trim(lblSRNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SR_ATTACHMENT")
        dtgModelPic.DataSource=resExePagedDataSet.Tables("SR_ATTACHMENT").DefaultView
        dtgModelPic.DataBind()
    end sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqExecuteNonQuery as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        For i = 0 To dtgModelPic.Items.Count - 1
            Dim SeqNo As Label = Ctype(dtgModelPic.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(dtgModelPic.Items(i).FindControl("chkRemove"), CheckBox)
            If remove.Checked = True Then ReqExecuteNoNQuery.ExecuteNonQuery("Delete from SR_ATTACHMENT where Seq_No = " & SeqNo.text & ";")
        Next
        procLoadGridData()
    End Sub
    
    Sub dtgModelPic_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim strSql as string
            Dim FileType as string = FileControl.PostedFile.ContentType
            Dim FileName as string = FileControl.PostedFile.FileName
            Dim FileLength as long = FileControl.PostedFile.ContentLength ' in bytes
            Dim FileExt as string = right(FileName,len(FileName) - (instrRev(FileName,".")))
            Dim SeqNo as long
            Dim Filename1 as string
            StrSql = "Insert into SR_ATTACHMENT(File_Desc,SR_NO,File_Size) "
            StrSql = StrSql + "Select '" & trim(txtfileDesc.text) & "','" & trim(lblSRNo.text) & "'," & FileLength & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
            SeqNo = ReqCOM.GetFieldVal("Select top 1 Seq_No from SR_ATTACHMENT where SR_NO = '" & trim(lblSRNo.text) & "' and File_Desc = '" & trim(txtFileDesc.text) & "' order by seq_no desc","Seq_No")
            FileName1 = SeqNo & "." & FileExt
            StrSql = "Update SR_ATTACHMENT set file_name = '" & trim(FileName1) & "' where seq_no = " & SeqNo & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
            fileControl.PostedFile.SaveAs((Mappath("") + "\PCMCSRAttachment\" + FileName1))
            Response.redirect("PopupPCMCSRAtt.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub ValReqPic_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim FilePath as string = fileControl.PostedFile.FileName
        if FilePath.length > 0 then e.isvalid = true else e.isvalid = false
    End Sub
    
    Sub cmdExit_Click(sender As Object, e As EventArgs)
        CloseIE
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
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">SPECIAL REQUEST(PCMC)
                                ATTACHMENT</asp:Label>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ForeColor=" " EnableClientScript="False" Display="Dynamic" ControlToValidate="txtFileDesc" ErrorMessage="You don't seem to have supplied a valid file description." CssClass="ErrorText" Width="100%"></asp:RequiredFieldValidator>
                                <asp:CustomValidator id="ValReqPic" runat="server" ForeColor=" " EnableClientScript="False" Display="Dynamic" ErrorMessage="You don't seem to have supplied a valid File Path." CssClass="ErrorText" Width="100%" OnServerValidate="ValReqPic_ServerValidate"></asp:CustomValidator>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; WIDTH: 100%; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal">S/R No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSRNo" runat="server" width="359px" cssclass="OutputText">Label</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">File Description</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtFileDesc" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">File Path</asp:Label></td>
                                                                <td>
                                                                    <input class="OutputText" id="fileControl" style="WIDTH: 100%; HEIGHT: 20px" type="file" size="22" runat="server" /></td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <p align="center">
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" CssClass="OutputText" Text="Attach File to SSER"></asp:Button>
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
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate >
                                                                    <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
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
                                                                    <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" Width="178px" Text="Remove Attachment" CausesValidation="False"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdExit" onclick="cmdExit_Click" runat="server" Width="131px" Text="Exit"></asp:Button>
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
