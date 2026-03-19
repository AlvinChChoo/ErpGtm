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
            lblUPASNo.text = reqCOM.GetFieldVal("Select top 1 SSER_NO from SSER_M where Seq_No = " & request.params("ID") & ";","sser_no")
            procLoadGridData()
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from SSeR_Attachment where sser_no = '" & trim(lblUPASNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SSeR_Attachment")
        dtgModelPic.DataSource=resExePagedDataSet.Tables("SSeR_Attachment").DefaultView
        dtgModelPic.DataBind()
    end sub
    
    
    
    Sub dtgModelPic_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim strSql as string
            Dim FileType as string = FileControl.PostedFile.ContentType
            Dim FileName as string = FileControl.PostedFile.FileName
            Dim FileLength as long = FileControl.PostedFile.ContentLength ' in bytes
            Dim FileExt as string = right(FileName,len(FileName) - (instr(FileName,".")))
            Dim SeqNo as long
            Dim Filename1 as string
    
            StrSql = "Insert into SSeR_Attachment(File_Desc,sser_no,File_Size) "
            StrSql = StrSql + "Select '" & trim(txtfileDesc.text) & "','" & trim(lblUPASNo.text) & "'," & FileLength & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            SeqNo = ReqCOM.GetFieldVal("Select top 1 Seq_No from SSeR_Attachment where sser_no = '" & trim(lblUPASNo.text) & "' and File_Desc = '" & trim(txtFileDesc.text) & "' order by seq_no desc","Seq_No")
            FileName1 = SeqNo & "." & FileExt
    
            StrSql = "Update SSeR_Attachment set file_name = '" & trim(FileName1) & "' where seq_no = " & SeqNo & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            fileControl.PostedFile.SaveAs((Mappath("") + "\SSERAttachment\" + FileName1))
            Response.redirect("PopupSSERAtt.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub ValReqPic_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim FilePath as string = fileControl.PostedFile.FileName
        if FilePath.length > 0 then e.isvalid = true else e.isvalid = false
    End Sub
    
    Sub cmdExit_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("SSERDet.aspx?ID=" & request.params("ID"))
    End Sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ucase(e.commandArgument) = "DELETE" then ReqCOM.ExecuteNonQUery("Delete from SSER_Attachment where seq_no = " & clng(SeqNo.text) & ";") : response.redirect("PopupSSERAtt.aspx?ID=" & clng(request.params("ID")))
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SSER ATTACHMENT</asp:Label>
                            </p>
                            <p align="center">
                                <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid file descriptiuon." ControlToValidate="txtFileDesc" Display="Dynamic" EnableClientScript="False" ForeColor=" "></asp:RequiredFieldValidator>
                                <asp:CustomValidator id="ValReqPic" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid File Path." Display="Dynamic" EnableClientScript="False" ForeColor=" " OnServerValidate="ValReqPic_ServerValidate"></asp:CustomValidator>
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
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal">SSER No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblUPASNo" runat="server" cssclass="OutputText" width="359px">Label</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">File Description</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtFileDesc" runat="server" Width="100%" CssClass="OutputText"></asp:TextBox>
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
                                                    <asp:DataGrid id="dtgModelPic" runat="server" width="100%" PageSize="50" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" AutoGenerateColumns="False" cellpadding="4" GridLines="None" BorderColor="Black" OnSelectedIndexChanged="dtgModelPic_SelectedIndexChanged" OnItemCommand="ItemCommand">
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                                            <asp:TemplateColumn>
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:ImageButton id="ImgDelete" ToolTip="Delete this item" ImageUrl="Delete.gif" CommandArgument='Delete' runat="server"></asp:ImageButton>
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
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="131px" CssClass="OutputText" Text="Back"></asp:Button>
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
