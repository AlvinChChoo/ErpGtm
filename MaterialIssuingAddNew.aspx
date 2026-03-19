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
        if page.ispostback = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            'dissql ("Select Cust_Code,Cust_Code + '|' + Cust_Name as [Desc] from Cust order by Cust_Code asc","Cust_Code","Desc",cmbCustCode)
            'Dissql ("Select Model_Code, Model_Code + '|' + model_Desc as [Desc] from Model_Master where Cust_Code = '" & trim(cmbCustCode.selecteditem.value) & "' order by Model_Code asc","Model_Code","Desc",cmbModelNo)
            'lblSODate.text = format(cdate(Now),"dd/MM/yy")
            'ShowCustDet
        end if
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("MaterialIssuing.aspx")
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
    
    Sub cmbShipCo_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        If ReqCOM.FuncCheckDuplicate("Select JO_No from Job_Order_D where JO_No = '" & trim(txtJONo.text) & "' and Released_By is not null","Jo_No") = false then
            ShowAlert("You don't seem to have select a valid Job Order No.\n\nThis could be due to job order Not yet released.")
            txtJONo.text = ""
            cmbPDSection.items.clear
            cmbLevel.items.clear
            lblLotNo.text = ""
            lblModelNo.text = ""
            lblJobOrderSize.text = ""
            Exit sub
        end if
    
        lblLotNo.text = ReqCOM.GetFieldVal("select Lot_No from Job_Order_M where JO_No = '" & trim(txtJONo.text) & "';","Lot_No")
        lblJobOrderSize.text = ReqCOM.GetFieldVal("select prod_qty from Job_Order_M where JO_No = '" & trim(txtJONo.text) & "';","prod_qty")
        lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_Models_M where lot_no = '" & trim(lblLotNo.text) & "';","Model_No")
        Dissql ("Select PD_Level from Job_Order_D where JO_No = '" & trim(txtJONo.text) & "' and Released_Date is not null order by pd_level asc","PD_Level","PD_Level",cmbPDSection)
    
        if cmbPDSection.selectedindex = 0 then
            Dissql ("Select Level_Code from p_level where pd_level = '" & trim(mid(cmbPDSection.selecteditem.value,1,3)) & "' and level_code in (Select p_level from BOM_D where Model_No = '" & trim(lblModelNo.text) & "') order by level_code asc","level_code","level_code",cmbLevel)
        end if
    End Sub
    
    Sub cmbPDSection_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dissql ("Select Level_Code from p_level where pd_level = '" & trim(mid(cmbPDSection.selecteditem.value,1,3)) & "' and level_code in (Select p_level from BOM_D where Model_No = '" & trim(lblModelNo.text) & "')","level_code","level_code",cmbLevel)
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim Revision as decimal
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim IssuingNo as string = ReqCOM.GetDocumentNo("Mat_Req_No")
        Dim rs as SQLDataReader
    
        Revision = ReqCOM.GetFieldVal("Select Top 1 Revision from BOM_M where Model_No = '" & trim(lblModelNo.text) & "' order by revision desc","Revision")
    
        ReqCOM.ExecuteNonQuery("insert into mat_issuing_m(issuing_no,jo_no,p_level,lot_size) Select '" & trim(IssuingNo) & "','" & trim(txtJONo.text) & "','" & trim(cmbLevel.selecteditem.value) & "'," & clng(lblJobOrderSize.text) & ";")
        'ReqCOM.ExecuteNonQuery("Insert into Mat_Issuing_D(Issuing_No,part_no,MAIN_PART,QTY_REQ,p_uSAGE,Total_Usage,Qty_Issued,type) select '" & trim(IssuingNo) & "',part_No,part_no,0,P_Usage, P_Usage * " & clng(lblJobOrderSize.text) & ",0,'M' from BOM_D where Revision = " & cdec(Revision) & " and model_No = '" & trim(lblModelNo.text) & "' and p_Level = '" & trim(cmbLevel.selecteditem.value) & "'")
        'ReqCOM.ExecuteNonQuery("Insert into Mat_Issuing_D(Issuing_No,Part_No,Main_Part,QTY_REQ,P_Usage,Total_Usage,Qty_Issued,type) select '" & trim(IssuingNo) & "',Part_No,Main_Part,0,0,0,0,'A' from BOM_Alt where model_no = '" & trim(lblModelNo.text) & "' and Main_Part in (Select distinct(part_no) as [PartNo] from Mat_Issuing_D where Issuing_No = '" & trim(IssuingNo) & "')")
    
        ReqCOM.ExecuteNonQuery("Insert into Mat_Issuing_D(Issuing_No,part_no,MAIN_PART,p_uSAGE,Total_Usage,Qty_Issued,type) select '" & trim(IssuingNo) & "',part_No,part_no,P_Usage, P_Usage * " & clng(lblJobOrderSize.text) & ",0,'M' from BOM_D where Revision = " & cdec(Revision) & " and model_No = '" & trim(lblModelNo.text) & "' and p_Level = '" & trim(cmbLevel.selecteditem.value) & "'")
        ReqCOM.ExecuteNonQuery("Insert into Mat_Issuing_D(Issuing_No,Part_No,Main_Part,P_Usage,Total_Usage,Qty_Issued,type) select '" & trim(IssuingNo) & "',Part_No,Main_Part,0,0,0,'A' from BOM_Alt where model_no = '" & trim(lblModelNo.text) & "' and Main_Part in (Select distinct(part_no) as [PartNo] from Mat_Issuing_D where Issuing_No = '" & trim(IssuingNo) & "')")
    
    
        rs = ReqCOM.ExeDataReader("Select Main_Part,P_Usage,part_no,Total_Usage,Qty_Issued from Mat_Issuing_d where Type = 'M' and Issuing_No = '" & trim(IssuingNo) & "' and Main_Part in (Select Main_Part from Mat_Issuing_D where type = 'A' and Issuing_No = '" & trim(IssuingNo) & "')")
        Do while rs.read
            ReqCOM.ExecuteNonQuery("Update Mat_Issuing_d set P_Usage = " & rs("P_Usage") & ",Total_Usage = " & rs("Total_Usage") & ",Qty_Issued = " & rs("Qty_Issued") & " where Type = 'A' and main_part = '" & trim(rs("Main_Part")) & "' and Issuing_no = '" & trim(IssuingNo) & "';")
        loop
    
        ReqCOm.ExecuteNonQuery("Update Mat_Issuing_d set main_alt = 'Main' where main_part = part_no and Issuing_no = '" & trim(IssuingNo) & "';")
        ReqCOm.ExecuteNonQuery("Update Mat_Issuing_d set main_alt = 'Alt.' where main_part <> part_no and Issuing_no = '" & trim(IssuingNo) & "';")
        ReqCOM.ExecuteNonQuery("Update Main set Mat_Req_No = Mat_Req_No + 1")
        Response.redirect ("MaterialIssuingDet.aspx?ID=" & ReqCOm.GetFieldVal("Select Seq_No from Mat_Issuing_M where Issuing_No = '" & trim(IssuingNo) & "';","Seq_No"))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" cssclass="fORMdESC" width="100%">ISSUING LIST</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="76%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="100%">Job Order
                                                                #</asp:Label></td>
                                                            <td width="75%">
                                                                <asp:TextBox id="txtJONo" onkeydown="KeyDownHandler(cmdGo)" runat="server" Width="261px" CssClass="OutputText"></asp:TextBox>
                                                                <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Width="64px" CssClass="OutputText" Text="GO"></asp:Button>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="100%">Prod. Section</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbPDSection" runat="server" Width="261px" CssClass="OutputText" autopostback="true" OnSelectedIndexChanged="cmbPDSection_SelectedIndexChanged"></asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="100%">Level</asp:Label></td>
                                                            <td>
                                                                <p>
                                                                    <asp:DropDownList id="cmbLevel" runat="server" Width="261px" CssClass="OutputText"></asp:DropDownList>
                                                                </p>
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
                                            <p>
                                                <table style="HEIGHT: 27px" cellspacing="0" cellpadding="0" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <p>
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="105px" Text="Update"></asp:Button>
                                                                </p>
                                                            </td>
                                                            <td>
                                                                <div align="right">
                                                                    <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="118px" Text="Back" CausesValidation="False"></asp:Button>
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
    </form>
</body>
</html>
