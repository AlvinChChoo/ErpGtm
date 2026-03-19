<%@ Page Language="VB" Debug="true" %>
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
        if ispostback = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            rbTempModelName.Attributes.Add("onclick", "checkedChange();")
            rbGtekModelName.Attributes.Add("onclick", "checkedChange();")
    
            lblModelNoB.text = ReqCOM.GetFieldVal("Select Model_No from BOM_Quote_M where Seq_No = " & clng(Request.params("ID")) & ";","Model_No")
            lblModelDescB.text = ReqCOM.GetFieldVal("Select Model_Desc from BOM_Quote_M where Seq_No = " & clng(Request.params("ID")) & ";","Model_Desc")
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
        End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("BOMQuoteWorkSheet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        Dissql ("Select MODEL_CODE,Model_Code + '|' + Model_Desc as [Desc] from Model_Master where model_code in (select model_no from bom_m where model_no+Model_Desc like '%" & trim(txtSearch.text) & "%') order by MODEL_CODE asc","MODEL_CODE","Desc",cmbModelNoA)
    
        if cmbModelNoA.selectedindex = -1 then
            lblModelDescA.text = ""
            txtSearch.text = "--Search--"
            ShowAlert ("You don't seem to have supplied a valid Model No or Model Description. \nPls try again.")
        elseif cmbModelNoA.selectedindex = 0 then
            lblModelDescA.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(cmbModelNoA.selecteditem.value) & "';","Model_Desc")
            txtSearch.text = "--Search--"
        end if
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim Revision as decimal
    
            if rbTempModelName.checked = true then
                if trim(txtTempModelName.text) = "" then
                    ShowAlert ("Invalid Model Name selected.")
                    redirectPage("BOMQuoteEditModelName.aspx?ID=" & Request.params("ID"))
                Elseif trim(txtTempModelName.text) <> "" then
                    ReqCOM.ExecuteNonQUery("Update BOM_Quote_M set Model_Desc = '" & trim(txtTempModelName.text) & "' where Seq_No = '" & clng(request.params("ID")) & "';")
                    response.redirect("BOMQuoteWorkSheet.aspx?ID=" & Request.params("ID"))
                end if
            elseif rbGTekModelName.checked = true then
                if cmbModelNoA.selectedindex = -1 then
                    ShowAlert ("Invalid Model Name selected.")
                    redirectPage("BOMQuoteEditModelName.aspx?ID=" & Request.params("ID"))
                elseif cmbModelNoA.selectedindex <> -1 then
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_M set Model_No = '" & trim(cmbModelNoA.selecteditem.value) & "',Model_Desc = '" & trim(lblModelDescA.text) & "',BOM_Quote_Rev = " & cdec(Revision) & " where Seq_No = " & clng(request.params("ID")) & ";")
                    response.redirect("BOMQuoteWorkSheet.aspx?ID=" & Request.params("ID"))
                end if
            end if
        End if
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <script language="javascript">

function getObj(name)
    {
        if (document.getElementById) // test if browser supports document.getElementById
            {
                this.obj = document.getElementById(name);
                this.style = document.getElementById(name).style;
            }
        else if (document.all) // test if browser supports document.all
            {
                this.obj = document.all[name];
                this.style = document.all[name].style;
            }
        else if (document.layers) // test if browser supports document.layers
            {
                this.obj = document.layers[name];
                this.style = document.layers[name].style;
            }
    }

function checkedChange()
    {

        var firstCheck = new getObj('rbTempModelName');
        var secondCheck = new getObj('rbGTekModelName');
        var txtTempModelName = new getObj('txtTempModelName');
        var txtSearch = new getObj('txtSearch');
        var cmdGO = new getObj('cmdGO');
        var cmbModelNoA = new getObj('cmbModelNoA');

        if (firstCheck.obj.checked == true)
            {
                txtTempModelName.obj.disabled = false;
                txtSearch.obj.disabled = true;
                cmdGO.obj.disabled = true;
                cmbModelNoA.obj.disabled = true;
                txtSearch.obj.value = "";
                
                cmbModelNoA.obj.value = "--Search--";
            }
        else if (secondCheck.obj.checked == true)
            {
                txtTempModelName.obj.disabled = true;
                txtSearch.obj.disabled = false;
                cmdGO.obj.disabled = false;
                cmbModelNoA.obj.disabled = false;
                txtTempModelName.obj.value = "";
                txtSearch.obj.value = "--Search--";

                cmbModelNoA.obj.value = "--Search--";
            }
    }
</script>
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">BOM QUOTE -
                                EDIT MODEL CODE / NAME</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td colspan="4">
                                                                <p align="center">
                                                                    <asp:Label id="Label8" runat="server">Before Change</asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="116px">Model No</asp:Label></td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:Label id="lblModelNoB" runat="server" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="116px">Model Name</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelDescB" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="4">
                                                                    <div align="center"><asp:Label id="Label9" runat="server">After Change</asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <p>
                                                                        <asp:RadioButton id="rbTempModelName" runat="server" CssClass="OutputText" Text="Temp. Model Name" GroupName="ModelName"></asp:RadioButton>
                                                                    </p>
                                                                </td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtTempModelName" runat="server" CssClass="OutputText" Width="453px" Enabled="False"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <p>
                                                                        <asp:RadioButton id="rbGtekModelName" runat="server" CssClass="OutputText" Text="G-Tek Model Name" GroupName="ModelName" Checked="True"></asp:RadioButton>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox id="txtSearch" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearch)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Text="GO" Height="20px" CausesValidation="False"></asp:Button>
                                                                    <asp:DropDownList id="cmbModelNoA" runat="server" CssClass="OutputText" Width="343px"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <asp:Label id="lblModelDescA" runat="server" cssclass="OutputText"></asp:Label>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Text="Update" Width="113px" CausesValidation="True"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="113px" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
