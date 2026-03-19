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
            rbTemoCustName.Attributes.Add("onclick", "checkedChange();")
            rbGtekCustName.Attributes.Add("onclick", "checkedChange();")
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            lblCustCodeB.text = ReqCOM.GetFieldVal("Select Cust_Code from BOM_Quote_M where Seq_No = " & clng(Request.params("ID")) & ";","Cust_Code")
            lblCustNameB.text = ReqCOM.GetFieldVal("Select Cust_Name from BOM_Quote_M where Seq_No = " & clng(Request.params("ID")) & ";","Cust_Name")
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
        Dissql ("Select Cust_Code + '|' + Cust_Name as [Cust_Desc], Cust_Code from Cust where Cust_Code+ Cust_Name like '%" & trim(txtSearch.text) & "%';","Cust_CODE","Cust_Desc",cmbCustCOdeA)
        if cmbCustCodeA.selectedindex = -1 then
            lblCustNameA.text = ""
            txtSearch.text = "--Search--"
            ShowAlert ("You don't seem to have supplied a valid Model No or Model Description. \nPls try again.")
        elseif cmbCustCodeA.selectedindex <> -1 then
            lblCustNameA.text = ReqCOM.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(cmbCustCodeA.selecteditem.value) & "';","Cust_name")
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
    
            if rbTemoCustName.checked = true then
                 if trim(txtTempCustName.text) = "" then
                    ShowAlert ("Invalid Customer Name selected.")
                    redirectPage("BOMQuoteEditModelName.aspx?ID=" & Request.params("ID"))
                Elseif trim(txtTempCustName.text) <> "" then
                    ReqCOM.ExecuteNonQUery("Update BOM_Quote_M set Cust_Name = '" & trim(txtTempCustName.text) & "' where Seq_No = '" & clng(request.params("ID")) & "';")
                    response.redirect("BOMQuoteWorkSheet.aspx?ID=" & Request.params("ID"))
                end if
            elseif rbGtekCustName.checked = true then
                if cmbCustCodeA.selectedindex = -1 then
                    ShowAlert ("Invalid Model Name selected.")
                    redirectPage("BOMQuoteEditModelName.aspx?ID=" & Request.params("ID"))
                elseif cmbCustCodeA.selectedindex <> -1 then
                    ReqCOM.ExecuteNonQuery("Update BOM_Quote_M set Cust_Code = '" & trim(cmbCustCodeA.selecteditem.value) & "',Cust_Name = '" & trim(lblCustNameA.text) & "' where Seq_No = " & clng(request.params("ID")) & ";")
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
        var rbTemoCustName = new getObj('rbTemoCustName');
        var txtTempCustName = new getObj('txtTempCustName');
        var rbGtekCustName = new getObj('rbGtekCustName');
        var txtSearch = new getObj('txtSearch');
        var cmdGo = new getObj('cmdGo');
        var cmbCustCodeA = new getObj('cmbCustCodeA');

        if (rbTemoCustName.obj.checked == true)
            {
                txtTempCustName.obj.disabled = false;
                txtSearch.obj.disabled = true;
                cmdGo.obj.disabled = true;
                cmbCustCodeA.obj.disabled = true;
                txtSearch.obj.value = "";
                cmbCustCodeA.obj.value = "--Search--";
            }
        else if (rbGtekCustName.obj.checked == true)
            {
                txtTempCustName.obj.disabled = true;
                txtSearch.obj.disabled = false;
                cmdGo.obj.disabled = false;
                cmbCustCodeA.obj.disabled = false;
                txtTempCustName.obj.value = "";
                txtSearch.obj.value = "--Search--";
                cmbCustCodeA.obj.value = "--Search--";
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
                                EDIT CUSTOMER CODE / NAME</asp:Label>
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
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="116px">Customer
                                                                No</asp:Label></td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:Label id="lblCustCodeB" runat="server" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="116px">Customer
                                                                Name</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCustNameB" runat="server" cssclass="OutputText"></asp:Label></td>
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
                                                                    <asp:RadioButton id="rbTemoCustName" runat="server" GroupName="ModelName" Text="Temp. Customer Name" CssClass="OutputText"></asp:RadioButton>
                                                                </td>
                                                                <td colspan="3">
                                                                    <p>
                                                                        <asp:TextBox id="txtTempCustName" runat="server" CssClass="OutputText" Enabled="False" Width="453px"></asp:TextBox>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:RadioButton id="rbGtekCustName" runat="server" GroupName="ModelName" Text="G-Tek Customer Name" CssClass="OutputText" Checked="True"></asp:RadioButton>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox id="txtSearch" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearch)" runat="server" CssClass="OutputText" Width="78px">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Text="GO" Height="20px" CausesValidation="False"></asp:Button>
                                                                    <asp:DropDownList id="cmbCustCodeA" runat="server" CssClass="OutputText" Width="344px"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <asp:Label id="lblCustNameA" runat="server" cssclass="OutputText" visible="False"></asp:Label>
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
