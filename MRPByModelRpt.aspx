<%@ Page Language="VB" Debug="TRUE" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.ispostback = false then Dissql("Select Model_Code, Model_Code + ' (' + model_Desc + ')' as [Desc] from Model_Master where Model_Code in (Select distinct(Model_No) from MRP_D_Gross) order by Model_Code asc","Model_Code","Desc",cmbModel)
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
    
    
    
    
         Sub cmdUpdate_Click(sender As Object, e As EventArgs)
         End Sub
    
         Sub cmdMain_Click(sender As Object, e As EventArgs)
             response.redirect("Main.aspx")
         End Sub
    
         Sub cmdFinish_Click(sender As Object, e As EventArgs)
             response.redirect("Default.aspx")
         End Sub
    
         Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
    
         End Sub
    
    
    
    
    
    
    
    
    
         Sub cmdGO_Click(sender As Object, e As EventArgs)
            Response.redirect("PopupReportViewer.aspx?RptName=MRPModel&ReturnURL=MRPByModelRpt.aspx&ModelNo=" & trim(cmbModel.selecteditem.value))
         End Sub
    
    
         Sub LinkButton2_Click(sender As Object, e As EventArgs)
             Response.redirect("MRPByLot.aspx?ID=" & Request.params("ID"))
         End Sub
    
         Sub LinkButton1_Click(sender As Object, e As EventArgs)
             response.redirect("MRPAll.aspx?ID=" & Request.params("ID"))
         End Sub
    
         Sub LinkButton3_Click(sender As Object, e As EventArgs)
             response.redirect("MRPByPart.aspx?ID=" & Request.params("ID"))
         End Sub
    
         Sub LinkButton4_Click(sender As Object, e As EventArgs)
             response.redirect("MRPByModel.aspx?ID=" & Request.params("ID"))
         End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div align="center"><asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">Material
                                Shortage List (By Model)</asp:Label> 
                            </div>
                            <p>
                                <table style="HEIGHT: 6px" cellspacing="0" cellpadding="0" width="60%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="OutputText" width="">MODEL NO</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbModel" runat="server" CssClass="OutputText"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td width="50%">
                                                                    <p>
                                                                        <asp:Button id="cmdGO" onclick="cmdGO_Click" runat="server" CssClass="OutputText" Text="View Report" Width="124px"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="50%">
                                                                    <p align="right">
                                                                        <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" CssClass="OutputText" Text="Back" Width="124px"></asp:Button>
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
