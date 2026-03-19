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
        'if page.ispostback = false then loaddata()
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
    
    Sub LoadData()
    End sub
    
    Sub redirectPage
        Dim strScript as string
        Dim ReturnURL as string
        ReturnURL= "PartDet.aspx?ID=" & Request.params("ID")
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        if ReqCOM.FuncCheckDuplicate("Select JO_No From Mat_Issuing_M where JO_No = '" & trim(txtJONo.text) & "';","JO_No") = false then
            ShowAlert ("You don't seem to have supplied a valid Job Order #.")
            Exit sub
        End if
        Dissql ("Select distinct(P_Level) as [PLevel] from Mat_Issuing_M where JO_No = '" & trim(txtJONo.text) & "';","PLevel","PLevel",cmbLevel)
    End Sub
    
    Sub cmdView_Click(sender As Object, e As EventArgs)
        'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        'Dim JobOrderSize as long
    
        'ReqCOM.ExecuteNonQuery("TRUNCATE TABLE MAT_ISSUING_LIST")
        'ReqCOM.ExecuteNonQuery("INSERT INTO MAT_ISSUING_LIST(JO_NO,P_LEVEL,PART_NO,MAIN_PART,TOTAL_ISSUED) SELECT '" & trim(txtJoNo.text) & "','" & trim(cmbLevel.selecteditem.value) & "',PART_NO,MAIN_PART,SUM(QTY_ISSUED) FROM MAT_ISSUING_D WHERE ISSUING_NO IN (SELECT ISSUING_NO FROM MAT_ISSUING_M WHERE JO_NO = '" & trim(txtJONo.text) & "' AND P_LEVEL = '" & trim(cmbLevel.selecteditem.value) & "') GROUP BY PART_NO,MAIN_PART")
        'ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET MAT_ISSUING_LIST.STORE_BAL = PART_MASTER.BAL_QTY FROM MAT_ISSUING_LIST, PART_MASTER WHERE PART_MASTER.PART_NO = MAT_ISSUING_LIST.PART_NO")
        'ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET MAT_ISSUING_LIST.P_USAGE = BOM_D.P_USAGE FROM MAT_ISSUING_LIST, BOM_D WHERE MAT_ISSUING_LIST.PART_NO = BOM_D.PART_NO AND MAT_ISSUING_LIST.MODEL_NO = BOM_D.MODEL_NO AND MAT_ISSUING_LIST.P_LEVEL = BOM_D.P_LEVEL")
        'ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET TOTAL_USAGE = LOT_SIZE * P_USAGE")
        'ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET BAL_TO_ISSUE = TOTAL_USAGE - TOTAL_ISSUED")
    
    
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim JobOrderSize as long
    
        ReqCOM.ExecuteNonQuery("TRUNCATE TABLE MAT_ISSUING_LIST")
    
        'ReqCOM.ExecuteNonQuery("INSERT INTO MAT_ISSUING_LIST(JO_NO,P_LEVEL,PART_NO,MAIN_PART,TOTAL_ISSUED) SELECT '-','-',PART_NO,MAIN_PART,SUM(QTY_ISSUED) FROM MAT_ISSUING_D WHERE Lot_No = '" & trim(txtLotNo.text) & "' GROUP BY PART_NO,MAIN_PART")
        ReqCOM.ExecuteNonQuery("INSERT INTO MAT_ISSUING_LIST(JO_NO,P_LEVEL,PART_NO,MAIN_PART,TOTAL_ISSUED) SELECT '-','-',PART_NO,MAIN_PART,SUM(QTY_ISSUED) FROM MAT_ISSUING_D WHERE issuing_no in (select issuing_no from mat_issuing_m where lot_no = '" & trim(txtlotNo.text) & "') GROUP BY PART_NO,MAIN_PART")
    
    
    
    
        ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET MAT_ISSUING_LIST.STORE_BAL = PART_MASTER.BAL_QTY FROM MAT_ISSUING_LIST, PART_MASTER WHERE PART_MASTER.PART_NO = MAT_ISSUING_LIST.PART_NO")
    
    
        ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET MAT_ISSUING_LIST.P_USAGE = BOM_D.P_USAGE FROM MAT_ISSUING_LIST, BOM_D WHERE MAT_ISSUING_LIST.PART_NO = BOM_D.PART_NO AND MAT_ISSUING_LIST.MODEL_NO = BOM_D.MODEL_NO AND MAT_ISSUING_LIST.P_LEVEL = BOM_D.P_LEVEL")
        ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET TOTAL_USAGE = LOT_SIZE * P_USAGE")
        ReqCOM.ExecuteNonQuery("UPDATE MAT_ISSUING_LIST SET BAL_TO_ISSUE = TOTAL_USAGE - TOTAL_ISSUED")
    
    
    
    End Sub
    
    Sub cmdSearchByLotNo_Click(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" forecolor="" width="100%">MATERIAL
                                ISSUING SUMMARY</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 12px" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="100%">Job Order
                                                                    #</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:TextBox id="txtJONo" runat="server" CssClass="OutputText" Width="261px"></asp:TextBox>
                                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Width="64px" Text="GO"></asp:Button>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="100%">Level</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbLevel" runat="server" CssClass="OutputText" Width="261px"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="100%">Lot No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="100%">Model No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="100%">Job Order
                                                                    Size</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblJobOrderSize" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <asp:TextBox id="txtLotNO" runat="server" CssClass="OutputText"></asp:TextBox>
                                                <asp:Button id="cmdSearchByLotNo" onclick="cmdSearchByLotNo_Click" runat="server" CssClass="OutputText" Width="69px" Text="GO"></asp:Button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </p>
                            <asp:Button id="cmdView" onclick="cmdView_Click" runat="server" Text="View Report"></asp:Button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
