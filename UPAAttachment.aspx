<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        cmdDelete.attributes.add("onClick","javascript:if(confirm('This action will remove the selected attachment from this Approval Sheet.\nYou will not be able to undo the changes made.\nAre you sure to continue ?')==false) return false;")
        if page.ispostback = false then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            lblUPASNo.text = reqCOM.GetFieldVal("Select top 1 UPAS_No from UPAS_M where Seq_No = " & request.params("ID") & ";","UPAS_No")
            procLoadGridData()
        end if
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string = "Select * from UPAS_ATTACHMENT where UPAS_NO = '" & trim(lblUPASNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"UPAS_ATTACHMENT")
        dtgModelPic.DataSource=resExePagedDataSet.Tables("UPAS_ATTACHMENT").DefaultView
        dtgModelPic.DataBind()
    end sub
    
    Sub cmdDelete_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqExecuteNonQuery as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        For i = 0 To dtgModelPic.Items.Count - 1
            Dim SeqNo As Label = Ctype(dtgModelPic.Items(i).FindControl("lblSeqNo"), Label)
            Dim remove As CheckBox = CType(dtgModelPic.Items(i).FindControl("chkRemove"), CheckBox)
            If remove.Checked = True Then ReqExecuteNoNQuery.ExecuteNonQuery("Delete from UPAS_Attachment where Seq_No = " & SeqNo.text & ";")
        Next
        procLoadGridData()
    End Sub
    
    
    Sub dtgModelPic_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect(Request.params("ReturnURL"))
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
    
            StrSql = "Insert into UPAS_Attachment(File_Desc,UPAS_NO,File_Size) "
            StrSql = StrSql + "Select '" & trim(txtfileDesc.text) & "','" & trim(lblUPASNo.text) & "'," & FileLength & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            SeqNo = ReqCOM.GetFieldVal("Select top 1 Seq_No from UPAS_Attachment where UPAS_NO = '" & trim(lblUPASNo.text) & "' and File_Desc = '" & trim(txtFileDesc.text) & "' order by seq_no desc","Seq_No")
            FileName1 = SeqNo & "." & FileExt
    
            StrSql = "Update UPAS_Attachment set file_name = '" & trim(FileName1) & "' where seq_no = " & SeqNo & ";"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            fileControl.PostedFile.SaveAs((Mappath("") + "\UPAAttachment\" + FileName1))
            Response.redirect("UPAAttachment.aspx?ID=" & Request.params("ID") & "&ReturnURL=" & Request.params("ReturnURL"))
        end if
    End Sub
    
    Sub ValReqPic_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim FilePath as string = fileControl.PostedFile.FileName
        if FilePath.length > 0 then e.isvalid = true else e.isvalid = false
    End Sub

</script>
<html xmlns:ibuyspy= "xmlns:ibuyspy">
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p align="center">
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <IBUYSPY:HEADER id="UserControl1" runat="server"></IBUYSPY:HEADER>
                            </div>
                            <div align="center">
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Unit Price Apporval (UPA) Attachment</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="center">
                                                                        <div align="center">
                                                                            <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid file descriptiuon." ControlToValidate="txtFileDesc" Display="Dynamic" ForeColor=" "></asp:RequiredFieldValidator>
                                                                        </div>
                                                                        <div align="center">
                                                                            <asp:CustomValidator id="ValReqPic" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid File Path." Display="Dynamic" ForeColor=" " EnableClientScript="False" OnServerValidate="ValReqPic_ServerValidate"></asp:CustomValidator>
                                                                            <br />
                                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="98%" border="1">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td width="25%" bgcolor="silver">
                                                                                            <asp:Label id="Label2" runat="server" cssclass="LabelNormal">UPA No</asp:Label></td>
                                                                                        <td>
                                                                                            <asp:Label id="lblUPASNo" runat="server" cssclass="OutputText" width="359px">Label</asp:Label></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td bgcolor="silver">
                                                                                            <asp:Label id="Label4" runat="server" cssclass="LabelNormal">File Description</asp:Label></td>
                                                                                        <td>
                                                                                            <asp:TextBox id="txtFileDesc" runat="server" Width="458px" CssClass="Input_Box"></asp:TextBox>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td bgcolor="silver">
                                                                                            <asp:Label id="Label5" runat="server" cssclass="LabelNormal">File Path</asp:Label></td>
                                                                                        <td>
                                                                                            <input class="Input_Box" id="fileControl" style="WIDTH: 87.08%; HEIGHT: 20px" type="file" size="17" runat="server" /></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td colspan="2">
                                                                                            <p align="center">
                                                                                                <asp:Button id="Button1" onclick="Button1_Click" runat="server" CssClass="Submit_Button" Text="Attach File to UPA"></asp:Button>
                                                                                                <asp:Label id="lblFileType" runat="server" visible="false">Label</asp:Label>
                                                                                            </p>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                            <p>
                                                                                <asp:DataGrid id="dtgModelPic" runat="server" width="98%" PageSize="50" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" OnSelectedIndexChanged="dtgModelPic_SelectedIndexChanged">
                                                                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                                    <Columns>
                                                                                        <asp:TemplateColumn Visible="False">
                                                                                            <ItemTemplate>
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
                                                                                <br />
                                                                            </p>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <p>
                                                        <table style="HEIGHT: 13px" width="98%">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <p align="left">
                                                                            <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" Width="161px" CssClass="Submit_Button" Text="Remove Attachment" CausesValidation="False"></asp:Button>
                                                                        </p>
                                                                    </td>
                                                                    <td>
                                                                        <p align="right">
                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="161px" CssClass="Submit_Button" Text="Back" CausesValidation="False"></asp:Button>
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
                                <p>
                                    <Footer:Footer id="Footer" runat="server"></Footer:Footer>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
