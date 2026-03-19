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
        if page.ispostback = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            rbBuyerCode.Attributes.Add("onclick", "checkedChange();")
            rbPartNo.Attributes.Add("onclick", "checkedChange();")
            lblLastMRPRun.text = ReqCOM.GetFieldVal("select top 1 'Last MRP Explosion as at ' + CONVERT(varchar(20), end_Date, 13) + ' (MRP No : ' + cast(MRP_No as nvarchar(20)) + ')' as [LastMRP] from mrp_history_m order by seq_no desc","LastMRP")
            Dissql("Select distinct(Buyer_Code) from Part_Master order by buyer_code asc","Buyer_Code","Buyer_Code",cmbBuyerCode)
        end if
    End Sub
    
    Sub cmdFinish_Click(sender As Object, e As EventArgs)
        Response.redirect("Default.aspx")
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
    
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Truncate table MRP_PART_ALLOCATION")
    
        if rbPartNo.checked = true then
            Response.redirect("PopupReportViewer.aspx?RptName=MRPAllocation&PartFrom=" & trim(txtPartFrom.text) & "&PartTo=" & trim(txtPartTo.text))
        elseif rbBuyerCode.checked = true then
            Response.redirect("PopupReportViewer.aspx?RptName=MRPAllocation&BuyerCode=" & trim(cmbBuyerCode.selecteditem.value) & "&By=Buyer")
        End if
        ShowReport("PopupReportViewer.aspx?RptName=MRPAllocation")
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

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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

        var rbPartNo = new getObj('rbPartNo');
        var rbBuyerCode = new getObj('rbBuyerCode');

        var txtPartFrom = new getObj('txtPartFrom');
        var txtPartTo = new getObj('txtPartTo');

        var cmbBuyerCode = new getObj('cmbBuyerCode');

        if (rbPartNo.obj.checked == true)
            {
                txtPartFrom.obj.disabled = false;
                txtPartTo.obj.disabled = false;
                txtPartFrom.obj.value = "";
                txtPartTo.obj.value = "";

                cmbBuyerCode.obj.disabled = true;
                cmbBuyerCode.obj.value = "";
            }
        else if (rbBuyerCode.obj.checked == true)
            {
                txtPartFrom.obj.disabled = true;
                txtPartTo.obj.disabled = true;
                txtPartFrom.obj.value = "";
                txtPartTo.obj.value = "";

                cmbBuyerCode.obj.disabled = false;
                cmbBuyerCode.obj.value = "";
            }
    }
</script>
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
                            <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">MRP
                                EXPLOSION - PART ALLOCATION</asp:Label><asp:Label id="lblLastMRPRun" runat="server" width="100%" cssclass="SectionHeader"></asp:Label>
                            </div>
                            <p>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="60%" align="center" border="1">
                                    <tbody>
                                        <tr>
                                            <td width="25%" bgcolor="silver">
                                                <asp:RadioButton id="rbPartNo" runat="server" CssClass="OutputText" Text="Part No" GroupName="optSelection"></asp:RadioButton>
                                            </td>
                                            <td width="75%">
                                                <p>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="45%">
                                                                    <div align="left">
                                                                        <asp:TextBox id="txtPartFrom" runat="server" CssClass="OutputText" Enabled="False" Width="100%"></asp:TextBox>
                                                                    </div>
                                                                </td>
                                                                <td width="10%">
                                                                    <p align="center">
                                                                        <asp:Label id="Label1" runat="server" width="" cssclass="OutputText">To</asp:Label>
                                                                    </p>
                                                                </td>
                                                                <td width="45%">
                                                                    <div align="right">
                                                                        <div align="right">
                                                                            <asp:TextBox id="txtPartTo" runat="server" CssClass="OutputText" Enabled="False" Width="100%"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td bgcolor="silver">
                                                <asp:RadioButton id="rbBuyerCode" runat="server" CssClass="OutputText" Text="Buyer Code" GroupName="optSelection" Checked="True"></asp:RadioButton>
                                            </td>
                                            <td>
                                                <p>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="40%">
                                                                    <asp:DropDownList id="cmbBuyerCode" runat="server" CssClass="OutputText" Width="100%"></asp:DropDownList>
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
                                <table style="HEIGHT: 8px" cellspacing="0" cellpadding="0" width="60%" align="center">
                                    <tbody>
                                        <tr>
                                            <td width="50%">
                                                <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Text="GO" Width="117px"></asp:Button>
                                            </td>
                                            <td width="50%">
                                                <p align="right">
                                                    <asp:Button id="cmdFinish" onclick="cmdFinish_Click" runat="server" CssClass="OutputText" Text="Back" Width="117px"></asp:Button>
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
