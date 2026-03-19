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

    Dim MRPNo,PRNoFrom,PRNo,PRNoTo,CurrVendor,Strpr1 as string
         Dim CurrUP as decimal
    
         Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
             if page.ispostback = false then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                'Dissql("select distinct(Buyer_Code) as [Buyer_Code] from mrp_d_net where type <> 'F' and lead_time is not null and on_hold = 0 and source = 'P' and VEN_CODE IS NOT NULL order by Buyer_Code asc","Buyer_Code","Buyer_Code", cmbBuyerCode)
    
    
                Dissql("select Buyer_Code + '-' + U_ID as [BuyerDesc],Buyer_Code from Buyer where buyer_code in (select distinct(Buyer_Code) from mrp_d_net where type <> 'F' and lead_time is not null and on_hold = 0 and source = 'P' and VEN_CODE IS NOT NULL) order by Buyer_Code asc","Buyer_Code","BuyerDesc", cmbBuyerCode)
    
    
                lblLastMRPRun.text = ReqCOM.GetFieldVal("select top 1 'Last MRP Explosion as at ' + CONVERT(varchar(20), end_Date, 13) + ' (MRP No : ' + cast(MRP_No as nvarchar(20)) + ')' as [LastMRP] from mrp_history_m order by seq_no desc","LastMRP")
    
                if ReqCOM.FuncCheckDuplicate("select top 1 Buyer_Code as [Buyer_Code] from mrp_d_net where type <> 'F' and lead_time is not null and on_hold = 0 and source = 'P' and VEN_CODE IS NOT NULL","Buyer_Code") = false then
                    lblRem.VISIBLE = TRUE
                    cmdSubmit.enabled = false
                    txtPartFrom.enabled = false
                    txtPartTo.enabled = false
                    cmbBuyerCode.enabled = false
                end if
    
            End if
         End Sub
    
         SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
             Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
             Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
             with obj
                 .items.clear
                 .DataSource = ResExeDataReader
                 .DataValueField = ucase(FValue)
                 .DataTextField = ucase(FText)
                 .DataBind()
             end with
             ResExeDataReader.close()
         End Sub
    
         Sub cmdBack_Click(sender As Object, e As EventArgs)
             Response.redirect("Default.aspx")
         End Sub
    
        Sub cmdSubmit_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then Response.redirect("MRPPRExplosionCon.aspx?BuyerCode=" & trim(cmbBuyerCode.selecteditem.value) & "&PartFrom=" & trim(txtPartFrom.text) & "&PartTo=" & trim(txtPartTo.text))
        End Sub
    
        Sub LoopPartNoForPRAdj(PRNo as string)
            Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrSql as string
    
            ReqCOM.ExecuteNonQuery("Truncate table PR_QTY_ADJ_TEMP")
            ReqCOM.ExecuteNonQuery("Insert into PR_QTY_ADJ_TEMP select part_no,qty_to_buy,seq_no,(select sum(pr_qty) from pr1_d where pr1_d.seq_no <= pr1.seq_no and pr1_d.part_no = pr1.part_no) as [RUNNING_TOTAL] from pr1_d pr1 where pr1.pr_no = '" & trim(PRNo) & "';")
            ReqCOM.ExecuteNonQuery("Update PR1_D set PR1_D.RUNNING_TOTAL=PR_QTY_ADJ_TEMP.running_total from PR1_D,PR_QTY_ADJ_TEMP where PR1_D.seq_no = PR_QTY_ADJ_TEMP.ref_seq_no")
        End sub
    
        Sub ValPartExp_ServerValidate(sender As Object, e As ServerValidateEventArgs)
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            e.isvalid = true
            if ReqCOM.FuncCheckDuplicate("select top 1 part_no as [part_no] from mrp_d_net where type <> 'F' and lead_time is not null and on_hold = 0 and source = 'P' and VEN_CODE IS NOT NULL and part_no in (Select Part_No from Part_Master where Buyer_Code = '" & trim(cmbBuyerCode.selecteditem.value) & "' and part_no between '" & trim(txtPartFrom.text) & "' and '" & trim(txtPartTo.text) & "')","part_no") = false then e.isvalid = false
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
                            <div align="center"><asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">MRP
                                - P/R EXPLOSION</asp:Label><asp:Label id="lblLastMRPRun" runat="server" width="100%" cssclass="SectionHeader"></asp:Label>
                            </div>
                            <div align="center">
                                <div align="center"><asp:Label id="lblRem" runat="server" cssclass="Instruction" visible="False">No
                                    more parts pending for P/R explosion.</asp:Label>
                                </div>
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                                <asp:CustomValidator id="ValPartExp" runat="server" ForeColor=" " Display="Dynamic" ErrorMessage="No parts to explode to P/R based on the selected criteria." EnableClientScript="False" OnServerValidate="ValPartExp_ServerValidate" Width="100%" CssClass="ErrorText"></asp:CustomValidator>
                            </div>
                            <p>
                                <table style="HEIGHT: 9px" width="50%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; HEIGHT: 26px; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" width="" cssclass="OutputText">Part Range</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtPartFrom" runat="server" Width="80px" CssClass="OutputText" MaxLength="2"></asp:TextBox>
                                                                    &nbsp;<asp:Label id="Label4" runat="server" width="" cssclass="OutputText">To</asp:Label>&nbsp;<asp:TextBox id="txtPartTo" runat="server" Width="80px" CssClass="OutputText" MaxLength="2"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="" cssclass="OutputText">Buyer Code</asp:Label>&nbsp;&nbsp; 
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:DropDownList id="cmbBuyerCode" runat="server" Width="100%" CssClass="OutputText"></asp:DropDownList>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="right">
                                                    <table style="HEIGHT: 11px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="120px" CssClass="OutputText" Text="Submit"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="120px" CssClass="OutputText" Text="Back" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    &nbsp; 
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <div align="center">
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
