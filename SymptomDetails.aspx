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
            Response.Cache.SetCacheability(HttpCacheability.NoCache)
             if not ispostback then
    
    
    
                cmdDelete.attributes.add("onClick","javascript:if(confirm('Are you sure to delete the selected Symptom ?')==false) return false;")
    
                cmdUpdate.attributes.add("onClick","javascript:if(confirm('Are you sure to update the selected Symptom ?')==false) return false;")
                Dissql ("select Category_ID from KBCategory order by Category_ID asc","Category_ID",cmbCategory)
                LoadSymptomsData
    
                if trim(ucase(request.cookies("U_ID").value)) = trim(ucase(lblAuthor.text)) then
                    cmdUpdate.visible = true
                    cmdDelete.visible = true
                else
                    cmdUpdate.visible = false
                    cmdDelete.visible = false
                End if
                ShowAlert
             End if
         End Sub
    
         Sub LoadSymptomsData
             Dim ReqCOM as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
             Dim strSql as string = "SELECT * FROM KBProblems WHERE Seq_No = " & cint(request.params("ID"))  & ";"
             Dim ResExeDataReader as SQLDataReader = ReqCOM.ExeDataReader(strSql)
             Dim Category as string
             do while ResExeDataReader.read
                 lblAuthor.text = ResExeDataReader("U_ID").tostring()
                 lblDate.text = format(cdate(ResExeDataReader("Trans_Date")),"MM/dd/yy")
    
                 txtSymptoms.text = ResExeDataReader("Symptoms").tostring()
                 txtCauses.text = ResExeDataReader("Causes").tostring()
                 txtResolution.text = ResExeDataReader("Resolution").tostring()
                 txtWorkAround.text = ResExeDataReader("Workaround").tostring()
                 txtAppliedTo.text = ResExeDataReader("Applies_To").tostring()
                 Category = ReqCOM.GetFieldVal("Select Category_ID from KBCategory where Category_ID in (Select Category_ID from KBProblems where Seq_No = " & cint(Request.params("ID")) & ")","Category_ID")
    '            cmbCategory.Items.FindByValue(Category.ToString).Selected = True
             loop
             ResExeDataReader.close
         end sub
    
         SUb Dissql(ByVal strSql As String,FName as string,Obj as Object)
             Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
             Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
             with obj
                 .items.clear
                 .DataSource = ResExeDataReader
                 .DataValueField = trim(FName)
                 .DataTextField = trim(FName)
                 .DataBind()
             end with
             ResExeDataReader.close()
    
         End Sub
    
         Sub cmdBack_Click(sender As Object, e As EventArgs)
             Response.redirect("KnowledgeBase.aspx")
         End Sub
    
         Sub cmdUpdate_Click(sender As Object, e As EventArgs)
             if page.isvalid = true then
                 Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                 Dim StrSql as string
                 StrSql = "Update KBProblems set CATEGORY_ID = '" & trim(cmbCategory.selecteditem.value) & "',"
                 StrSql = StrSql & "SYMPTOMS = '" & trim(txtSymptoms.text) & "',"
                 StrSql = StrSql & "CAUSES = '" & trim(txtCauses.text) & "',"
                 StrSql = StrSql & "RESOLUTION = '" & trim(txtResolution.text) & "',"
                 StrSql = StrSql & "WORKAROUND = '" & trim(txtWorkaround.text) & "',"
                 StrSql = StrSql & "APPLIES_TO = '" & trim(txtAppliedTo.text) & "'"
                 StrSql = StrSql & " where Seq_No = " & cint(request.params("ID")) & ";"
                 ReqCOM.ExecuteNonQuery (StrSql)
                 Response.cookies("AlertMessage").value = "The selected symptom have been updated."
             end if
         End Sub
    
        Sub ShowAlert()
            Dim Msg as string
            Dim strScript as string
    
            If  trim(request.cookies("AlertMessage").value) = "" then
            else
                msg = trim(Request.cookies("AlertMessage").value)
                Response.Cookies("AlertMessage").Value = ""
                strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
                If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
            end if
        End sub
    
        Sub cmdDelete_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            ReqCOM.executeNonQuery("Delete from KBProblems where Seq_No = " & cint(request.params("ID")) & ";")
            Response.redirect("KnowledgeBase.aspx")
        End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SYMPTOM DETAILS</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 137px" cellspacing="0" cellpadding="0" width="80%" align="center" border="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top">
                                            </td>
                                            <td valign="top" nowrap="nowrap" align="left" width="100%">
                                                <p>
                                                    <table style="HEIGHT: 218px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">Date Posted</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left"><asp:Label id="lblDate" runat="server" cssclass="OutputText" width="318px"></asp:Label>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="126px">Author</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left"><asp:Label id="lblAuthor" runat="server" cssclass="OutputText" width="414px"></asp:Label>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="126px">Category</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left">
                                                                            <asp:DropDownList id="cmbCategory" runat="server" Width="484px" CssClass="OutputText"></asp:DropDownList>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="126px">Symptoms</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left">
                                                                            <div align="left">
                                                                                <asp:TextBox id="txtSymptoms" runat="server" Width="484px" CssClass="OutputText" TextMode="MultiLine" Height="67px"></asp:TextBox>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="126px">Causes</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left">
                                                                            <asp:TextBox id="txtCauses" runat="server" Width="484px" CssClass="OutputText" TextMode="MultiLine" Height="67px"></asp:TextBox>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="126px">Resolution</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <p align="left">
                                                                            <asp:TextBox id="txtResolution" runat="server" Width="484px" CssClass="OutputText" TextMode="MultiLine" Height="67px"></asp:TextBox>
                                                                        </p>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="126px">Workaround</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <div align="left">
                                                                            <asp:TextBox id="txtWorkAround" runat="server" Width="484px" CssClass="OutputText" TextMode="MultiLine" Height="67px"></asp:TextBox>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="126px">Applied
                                                                        To</asp:Label></td>
                                                                    <td colspan="3">
                                                                        <asp:TextBox id="txtAppliedTo" runat="server" Width="484px" CssClass="OutputText" TextMode="MultiLine" Height="67px"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Text="Update Symptom"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdDelete" onclick="cmdDelete_Click" runat="server" Text="Remove Symptom"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="183px" Text="Back"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
