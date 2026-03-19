<%@ Page Language="VB" %>
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
        if page.ispostback = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dissql("Select Lot_No from so_model_m where lot_close = 'N'","Lot_No","Lot_No",cmbLotNo)
        end if
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
    
        Dim oList As ListItemCollection = obj.Items
        oList.Add(New ListItem(""))
        obj.Items.FindByText("").Selected = True
    End Sub
    
    
    Sub cmdSave_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim SRNo as string = ReqCOM.GetDocumentNo("SR_NO")
            Dim StrSql as string
            StrSql = "Insert into SR_M(SR_NO,LOT_NO,P_LEVEL,CREATE_BY,CREATE_DATE) Select '" & trim(SRNo) & "','" & trim(cmbLotNo.selectedItem.value) & "','" & trim(cmbLevel.SelectedItem.value) & "','" & trim(request.cookies("U_ID").value) & "','" & now & "';"
    
            ReqCOM.executeNonQuery(StrSql)
            ReqCOM.ExecuteNonQuery("Update main set SR_NO = SR_NO + 1")
    
            Response.redirect("SpecialRequestAddNew1.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from SR_M where SR_NO = '" & trim(SRNo) & "';","Seq_No"))
        end if
    End Sub
    
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("SpecialRequest.aspx")
    End Sub
    
    Sub cmbLotNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rsSR as SQLDataReader = ReqCOM.ExeDataReader("Select BOM_REV,Model_No from SO_MODEL_M where Lot_No = '" & trim(cmbLotNo.selectedItem.value) & "';")
    
        Do while rsSR.read
            lblModelNo.text = rsSR("Model_No").tostring
            lblBOMRev.text = rsSR("BOM_REV").tostring
        Loop
        rsSR.close()
        Dissql("Select distinct(P_Level) from BOM_D where Model_No = '" & trim(lblModelNo.text) & "' and Revision = " & cdec(lblBomRev.text) & ";","P_Level","P_LEVEL",cmbLevel)
    End Sub
    
    Sub cmbLevel_SelectedIndexChanged(sender As Object, e As EventArgs)
    
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
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p>
                                <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" width="100%" cssclass="FormDesc">NEW SPECIAL
                                REQUEST REGISTRATION</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    &nbsp;
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 46px" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label2" runat="server" width="125px" cssclass="LabelNormal">S/R No</asp:Label></td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label7" runat="server" width="125px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label8" runat="server" width="125px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label9" runat="server" width="125px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                </td>
                                                                <td>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label3" runat="server" width="125px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbLotNo" runat="server" Width="286px" CssClass="OutputText" OnSelectedIndexChanged="cmbLotNo_SelectedIndexChanged" autopostback="true"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label5" runat="server" width="125px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblModelNo" runat="server" width="321px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label6" runat="server" width="125px" cssclass="LabelNormal">BOM Rev.</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblBOMRev" runat="server" width="321px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label4" runat="server" width="125px" cssclass="LabelNormal">Level</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbLevel" runat="server" Width="286px" CssClass="OutputText" OnSelectedIndexChanged="cmbLevel_SelectedIndexChanged"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="Button1" onclick="cmdSave_Click" runat="server" Width="141px" Text="Save"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="97px" Text="Back" CausesValidation="False"></asp:Button>
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
