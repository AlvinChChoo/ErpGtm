<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ Register TagPrefix="ERP" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            Dissql ("Select Model_No + '   (' + cast(Revision as nvarchar(20)) + ')' as [desc],seq_no from BOM_M order by Model_No,Revision asc","seq_no","desc",cmbModel1)
            Dissql ("Select Model_No + '   (' + cast(Revision as nvarchar(20)) + ')' as [desc],seq_no from BOM_M order by Model_No,Revision asc","seq_no","desc",cmbModel2)
        End if
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
        Dim StrSql,Model1,Model2 as string
        Dim Rev1,Rev2 as decimal
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
    
        myConnection.Open()
    
        Model1 = ReqCOM.GetFieldVal("Select Model_No from BOM_M where Seq_No = " & cmbModel1.selecteditem.value & ";","Model_No")
        Model2 = ReqCOM.GetFieldVal("Select Model_No from BOM_M where Seq_No = " & cmbModel2.selecteditem.value & ";","Model_No")
        Rev1 = ReqCOM.GetFieldVal("Select Revision from BOM_M where Seq_No = " & cmbModel1.selecteditem.value & ";","Revision")
        Rev2 = ReqCOM.GetFieldVal("Select Revision from BOM_M where Seq_No = " & cmbModel2.selecteditem.value & ";","Revision")
    
        ReqCOM.ExecuteNonQuery("Truncate Table BOM_DIFF_LIST")
    
        ReqCOM.ExecuteNonQuery("Insert into BOM_DIFF_LIST(MODEL_NO,PART_NO,P_LEVEL,P_LOCATION,P_USAGE,Revision) select MODEL_NO,PART_NO,P_LEVEL,P_LOCATION,P_USAGE,Revision from BOM_D where (Model_No = '" & trim(model1) & "' and Revision = " & cdec(rev1) & ")")
        ReqCOM.ExecuteNonQuery("Insert into BOM_DIFF_LIST(MODEL_NO,PART_NO,P_LEVEL,P_LOCATION,P_USAGE,Revision) select MODEL_NO,PART_NO,P_LEVEL,P_LOCATION,P_USAGE,Revision from BOM_D where (Model_No = '" & trim(model2) & "' and Revision = " & cdec(rev2) & ")")
    
        StrSql = "Select * from BOM_DIFF_LIST"
    
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while drGetFieldVal.read
            if ReqCOM.FuncCheckDuplicate("Select Part_No from BOM_DIFF_LIST where Seq_No <> " & drGetFieldVal("Seq_No") & " and part_no = '" & trim(drGetFieldVal("part_no")) & "' and p_level = '" & trim(drGetFieldVal("p_level")) & "' and p_location = '" & trim(drGetFieldVal("p_location")) & "' and p_usage = " & drGetFieldVal("p_usage") & ";","Part_No") = true then
                ReqCOM.ExecuteNonQuery("Delete from BOM_DIFF_LIST where Part_No = '" & trim(drGetFieldVal("Part_No")) & "' and p_level='" & trim(drGetFieldVal("P_Level")) & "' and p_location = '" & trim(drGetFieldVal("P_Location")) & "' and p_usage = " & trim(drGetFieldVal("p_usage")) & ";")
            end if
        loop
    
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    
        Response.redirect("ReportViewer.aspx?RptName=BOMDiffList&ReturnURL=Default.aspx")
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
        with obj
            .items.clear
            .DataSource = ResExeDataReader
            .DataValueField = trim(FValue)
            .DataTextField = trim(FText)
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmbModelNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        'Dissql ("Select Revision, cast(Revision as nvarchar(20)) + '   (' + convert(nvarchar(30),Effective_Date,3) + ')' as [EffDate] from BOM_M where model_no = '" & trim(cmbModelNo.selectedItem.value) & "' order by revision asc","Revision","EffDate",cmbRevision)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub cmbModel1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmbRev1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmbModel2_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub cmbRev2_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form method="post" runat="server">
        <p>
            <font face="Verdana" size="4"> 
            <table style="HEIGHT: 38px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="3">
                            <font color="red"><strong>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                            </strong></font></td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%" backcolor="" forecolor="">BOM
                                DIFFERENT LIST</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="60%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 68px" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center"><asp:Label id="Label4" runat="server" width="100%">BOM List by
                                                                        Model</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <div align="center">
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="25%" bgcolor="silver">
                                                                                        <asp:Label id="LotNo" runat="server" cssclass="LabelNormal">Model 1 </asp:Label></td>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:DropDownList id="cmbModel1" runat="server" CssClass="OutputText" Width="100%" autopostback="True" OnSelectedIndexChanged="cmbModel1_SelectedIndexChanged"></asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Model 2</asp:Label></td>
                                                                                    <td>
                                                                                        <p align="center">
                                                                                            <asp:DropDownList id="cmbModel2" runat="server" CssClass="OutputText" Width="100%" autopostback="True" OnSelectedIndexChanged="cmbModel2_SelectedIndexChanged"></asp:DropDownList>
                                                                                        </p>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="Button1" onclick="Button1_Click" runat="server" Width="85px" Text="View Report"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="97px" Text="Back"></asp:Button>
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
            </font>
        </p>
    </form>
</body>
</html>
