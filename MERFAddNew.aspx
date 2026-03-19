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
                if page.ispostback = false then
                    Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                    lblMERFNo.text = ReqCOM.GetDocumentNo("MERF_NO")
                    ShowModelDet()
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
    
            Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
                If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                    Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
                    Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
                    Dim QtyIssued As Label = CType(e.Item.FindControl("QtyIssued"), Label)
                    Dim TOReturn As Textbox = CType(e.Item.FindControl("TOReturn"), Textbox)
    
                    'QtyIssued.text = ReqCOM.GetFieldVal("Select sum(Qty_Issued) as QtyIssued from mat_iss_d where lot_No = '" & trim(cmbLotNo.selectedItem.value) & "' and Part_No = '" & trim(PartNo.text) & "' and P_Level = '" & trim(cmbLevel.selectedItem.value) & "';","QtyIssued")
                    'if QtyIssued.text = "" then QtyIssued.text = "0"
                End if
            End Sub
    
              Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
              End Sub
    
              Sub cmdBack_Click(sender As Object, e As EventArgs)
                  response.redirect("Default.aspx")
              End Sub
    
            Sub cmdSave_Click(sender As Object, e As EventArgs)
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                Dim JOSize as long
                JOSize = ReqCOM.GetFieldVal("Select top 1 Prod_Qty from Job_Order_M where JO_No = '" & trim(cmbJONo.selecteditem.value) & "';","Prod_Qty")
                ReqCOM.ExecuteNonQuery("Insert into MERF_M(MERF_NO,JO_NO,P_LEVEL) SELECT '" & trim(lblMERFNo.text) & "','" & trim(cmbJONo.selecteditem.value) & "','" & trim(cmbPDLevel.selecteditem.value) & "';")
    
                ReqCOM.ExecuteNonQuery("INSERT INTO MERF_D(MERF_NO,JO_NO,P_LEVEL,PART_NO,MAIN_PART,TOTAL_ISSUED) SELECT '" & TRIM(lblMERFNo.text) & "','" & trim(cmbJONo.selecteditem.value) & "','" & trim(cmbPDLevel.selecteditem.value) & "',PART_NO,MAIN_PART,SUM(QTY_ISSUED) FROM MAT_ISSUING_D WHERE ISSUING_NO IN (SELECT ISSUING_NO FROM MAT_ISSUING_M WHERE JO_NO = '" & trim(cmbJONo.SELECTEDITEM.value) & "' AND P_LEVEL = '" & trim(cmbPDLevel.selecteditem.value) & "') GROUP BY PART_NO,MAIN_PART")
                ReqCOM.ExecuteNonQuery("UPDATE MERF_D SET MERF_D.STORE_BAL = PART_MASTER.BAL_QTY FROM MERF_D, PART_MASTER WHERE PART_MASTER.PART_NO = MERF_D.PART_NO")
                ReqCOM.ExecuteNonQuery("UPDATE MERF_D SET MODEL_NO = '" & trim(lblModelNo.text) & "';")
                ReqCOM.ExecuteNonQuery("UPDATE MERF_D SET LOT_SIZE = " & clng(JOSize) & ";")
                ReqCOM.ExecuteNonQuery("UPDATE MERF_D SET MERF_D.P_USAGE = BOM_D.P_USAGE FROM MERF_D, BOM_D WHERE MERF_D.PART_NO = BOM_D.PART_NO AND MERF_D.MODEL_NO = BOM_D.MODEL_NO AND MERF_D.P_LEVEL = BOM_D.P_LEVEL")
                ReqCOM.ExecuteNonQuery("UPDATE MERF_D SET TOTAL_USAGE = LOT_SIZE * P_USAGE")
                ReqCOM.ExecuteNonQuery("UPDATE MERF_D SET BAL_TO_ISSUE = TOTAL_USAGE - TOTAL_ISSUED")
                ReqCOM.ExecuteNonQuery("Update MERF_D set Extra_Req = 0")
                ReqCOM.ExecuteNonQuery("Update MERF_D set Type = 'M' where main_part = part_no and MERF_No = '" & trim(lblMERFNo.text) & "';")
                ReqCOM.ExecuteNonQuery("Update MERF_D set Type = 'A' where main_part <> part_no and MERF_No = '" & trim(lblMERFNo.text) & "';")
    
                ReqCOM.ExecuteNonQuery("Delete from MERF_D where Type = 'A'")
    
                ReqCOM.ExecuteNonQuery("Update Main set MERF_NO = MERF_NO + 1")
                Response.redirect("MERFDet.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from MERF_M where MERF_NO = '" & trim(lblMERFNo.text) & "';","Seq_No"))
            End Sub
    
             Sub ShowModelDet()
              End sub
    
              Sub cmbLevel_SelectedIndexChanged(sender As Object, e As EventArgs)
              End Sub
    
             Sub cmbLotNo_SelectedIndexChanged(sender As Object, e As EventArgs)
             '    ShowModelDet()
             End Sub
    
         Sub cmdGo_Click(sender As Object, e As EventArgs)
            Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
            Dissql ("Select distinct(JO_No) as [JONo] from Mat_Issuing_m where jo_No like '%" & trim(txtSearchJO.text) & "%'","JONo","JONo",cmbJONo)
            txtSearchJO.text = "-- Search --"
    
            if cmbJONo.selectedindex = 0 then
                lblModelNo.text = ReqCOM.GetFieldVal("Select model_No from SO_Models_m where lot_No in (Select Lot_No from job_order_m where jo_no = '" & trim(cmbJONo.selecteditem.value) & "')","Model_No")
                lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from SO_Models_m where lot_No in (Select Lot_No from job_order_m where jo_no = '" & trim(cmbJONo.selecteditem.value) & "')","Model_Desc")
                Dissql ("Select distinct(P_Level) as [PLevel] from Mat_Issuing_m where jo_No = '" & trim(cmbJONo.selecteditem.value) & "'","PLevel","PLevel",cmbPDLevel)
            elseif cmbJONo.selectedindex <> 0 then
                lblModelNo.text = ""
                lblModelDesc.text = ""
                cmbPDLevel.items.clear
                ShowAlert("Invalid Job Order No.")
            end if
         End Sub
    
         Sub ShowAlert(Msg as string)
             Dim strScript as string
             strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
             If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
         End sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 16px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">MATERIAL RETURN
                                FORM (MRF)</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="28%" bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="126px">Extra Req.
                                                                NO</asp:Label></td>
                                                            <td width="72%">
                                                                <asp:Label id="lblMERFNo" runat="server" cssclass="OutputText" width="126px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="126px">Job Order
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtSearchJO" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchJO)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Height="20px" CausesValidation="False" Text="GO"></asp:Button>
                                                                <asp:DropDownList id="cmbJONo" runat="server" Width="259px" CssClass="OutputText" autopostback="True" OnSelectedIndexChanged="cmbLotNo_SelectedIndexChanged"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="126px">Section</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbPDLevel" runat="server" Width="259px" CssClass="OutputText" autopostback="True" OnSelectedIndexChanged="cmbLotNo_SelectedIndexChanged"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Model Code /Description</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdSave" onclick="cmdSave_Click" runat="server" Width="181px" Text="Update Transaction"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="181px" CausesValidation="False" Text="Back"></asp:Button>
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
        <p align="left">
        </p>
    </form>
</body>
</html>
