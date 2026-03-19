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
            dissql ("Select Distinct(Buyer_Code) as [Buyer_Code] from Part_Master order by Buyer_Code asc","Buyer_Code","Buyer_Code",cmbBuyerCode)
            lblLastMRPRun.text = ReqCOM.GetFieldVal("select top 1 'Last MRP Explosion as at ' + CONVERT(varchar(20), end_Date, 13) + ' (MRP No : ' + cast(MRP_No as nvarchar(20)) + ')' as [LastMRP] from mrp_history_m order by seq_no desc","LastMRP")
        end if
    End Sub
    
    Sub cmdGO_Click(sender As Object, e As EventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCom.ExecuteNonQuery("UPDATE PART_MASTER SET PART_MASTER.LOCATION = PART_LOC.LOC FROM PART_MASTER,PART_LOC WHERE PART_MASTER.PART_NO = PART_LOC.PART_NO")
        ShowReport("PopupReportViewer.aspx?RptName=PartList&ReturnURL=PartListRpt.aspx&Type=PartRange&PartNoFrom=" & trim(txtPartNoFrom.text) & "&PartNoTo=" & trim(txtPartNoTo.text))
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdView_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if rbPartNo.checked = true then
            ReqCOM.ProcessSupplyDemandRpt (trim(txtPartNoFrom.text),trim(txtPartNoTo.text))
            ShowReport("PopUpReportViewer.aspx?RptName=SupplyVSDemandSummary&RptTitle=Part Range from " & trim(txtPartNoFrom.text) & " to " & trim(txtPartNoTo.text))
        elseif rbBuyerCode.checked = true then
            ReqCOM.ProcessSupplyDemandRptByBuyerCode (cmbBuyerCode.selecteditem.value)
            ShowReport("PopUpReportViewer.aspx?RptName=SupplyVSDemandSummary&RptTitle=Part Filtered by " & trim(cmbBuyerCode.selecteditem.value))
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
        Response.redirect("Default.aspx")
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

        var txtPartNoFrom = new getObj('txtPartNoFrom');
        var txtPartNoTo = new getObj('txtPartNoTo');

        var cmbBuyerCode = new getObj('cmbBuyerCode');

        if (rbPartNo.obj.checked == true)
            {
                txtPartNoFrom.obj.disabled = false;
                txtPartNoTo.obj.disabled = false;
                txtPartNoFrom.obj.value = "";
                txtPartNoTo.obj.value = "";

                cmbBuyerCode.obj.disabled = true;
                cmbBuyerCode.obj.value = "";
            }
        else if (rbBuyerCode.obj.checked == true)
            {
                txtPartNoFrom.obj.disabled = true;
                txtPartNoTo.obj.disabled = true;
                txtPartNoFrom.obj.value = "";
                txtPartNoTo.obj.value = "";

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
                            <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">PART
                                SUPPLY VS DEMAND REPORT</asp:Label> 
                                <div align="center"><asp:Label id="lblLastMRPRun" runat="server" width="100%" cssclass="SectionHeader"></asp:Label>
                                </div>
                            </div>
                            <p>
                                <table style="HEIGHT: 9px" width="60%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:RadioButton id="rbPartNo" runat="server" Checked="True" GroupName="optSelection" Text="Part No" CssClass="OutputText"></asp:RadioButton>
                                                                </td>
                                                                <td width="75%">
                                                                    <p>
                                                                        <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="45%">
                                                                                        <asp:TextBox id="txtPartNoFrom" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                                    </td>
                                                                                    <td width="10%">
                                                                                        <p align="center">
                                                                                            <asp:Label id="Label2" runat="server" width="" cssclass="OutputText">To</asp:Label>
                                                                                        </p>
                                                                                    </td>
                                                                                    <td width="45%">
                                                                                        <div align="right">
                                                                                            <asp:TextBox id="txtPartNoTo" runat="server" CssClass="OutputText" Width="100%"></asp:TextBox>
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
                                                                    <asp:RadioButton id="rbBuyerCode" runat="server" GroupName="optSelection" Text="Buyer Code" CssClass="OutputText"></asp:RadioButton>
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
                                                <p align="right">
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdView" onclick="cmdView_Click" runat="server" Text="View Report" CssClass="OutputText" Width="120px"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" CssClass="OutputText" Width="120px"></asp:Button>
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
