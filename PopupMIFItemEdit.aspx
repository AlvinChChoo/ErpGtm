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
        if page.isPostBack = false then
    
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            lblPONo.text = ReqCOM.GetFieldVal("select PO_No from MIF_D where Seq_No = " & request.params("ID") & ";","PO_No")
            lblPartNo.text = ReqCOM.GetFieldVal("select Part_No from MIF_D where Seq_No = " & request.params("ID") & ";","Part_No")
            lblDelDate.text = ReqCOM.GetFieldVal("select DEl_Date from MIF_D where Seq_No = " & request.params("ID") & ";","DEl_Date")
    
            'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            'Dim QtyDel as decimal
            'Dim CurrDate as date = format(now,"dd/MMM/yyyy")
    
            'lblSupplier.text = trim(request.params("VenCode"))
            'lblMifNo.text = trim(request.params("MIFNo"))
            'lblLoc.text = ReqCOM.GetFieldVal("Select top 1 Loc from Vendor where Ven_Code = '" & trim(lblSupplier.text) & "';","Loc")
    
        end if
    End Sub
    
    
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            E.Item.Cells(4).Text = format(cdate(e.Item.Cells(4).Text),"MM/dd/yy")
            Dim InQty As Label = CType(e.Item.FindControl("InQty"), Label)
            InQty.text = cint(InQty.text)
        End if
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
    End Sub
    
    SUb Dissql(ByVal strSql As String,FValue as string, FText as string,Obj as Object)
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(StrSql)
    
        with obj
            .DataSource = ResExeDataReader
            .DataValueField = FValue
            .DataTextField = FText
            .DataBind()
        end with
        ResExeDataReader.close()
    End Sub
    
    Sub cmbPONo_SelectedIndexChanged(sender As Object, e As EventArgs)
        ShowPart()
    End Sub
    
    Sub ShowPart()
        'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        'ReqCOM.ExecuteNonQuery("Update PO_D set SCH_Date = Del_Date where po_no = '" & trim(cmbPONo.selectedItem.value) & "' and Sch_Date is null")
    
        'Dim CurrDate as date = now
        'if trim(lblLoc.text) = "L" then CurrDate = CurrDate.addDays(1)
        'if trim(lblLoc.text) = "S" then CurrDate = CurrDate.addDays(2)
        'if trim(lblLoc.text) = "F" then CurrDate = CurrDate.addDays(3)
        'cmbPartNo.items.clear
        'Dissql("Select Part_No + '   |   ' + CONVERT(char(12), SCH_Date, 3)  as [Part_No],Seq_No from PO_D where PO_NO = '" & trim(cmbPONo.selectedItem.Text) & "' and Sch_Date <= '" & cdate(CurrDate) & "';","Seq_No","Part_No",cmbPartNo)
    End Sub
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim QtyDel as decimal
        DisplayPartQty()
    End Sub
    
    Sub DisplayPartQty()
        'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        'txtOrderQty.text = ReqCOM.GetFieldVal("Select Order_Qty from PO_D where Seq_No = " & cmbPartNo.selectedItem.value & ";","Order_Qty")
        'lblUP.text = ReqCOM.GetFieldVal("Select UP from PO_D where Seq_No = " & cmbPartNo.selectedItem.value & ";","UP")
        'Dim ETADate as datetime = ReqCOM.GetFieldVal("Select Del_Date from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Del_Date")
        'Dim PartNo as string = ReqCOM.GetFieldVal("Select Part_No from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Part_No")
    
        'txtQtyDel.text = ReqCOM.GetFieldVal("Select In_Qty from PO_D where Seq_no = " & cint(cmbPartNo.selecteditem.value) & ";","IN_QTY")
        'lblWAC.text = ReqCOM.GetFieldVal("Select WAC_Cost from part_master where part_no = '" & trim(PartNo) & "';","WAC_Cost")
        'lblCurrCode.text = ReqCOM.GetFieldVal("Select Curr_Code from Vendor where Ven_Code = '" & trim(lblSupplier.text) & "';","Curr_Code")
        'lblUPRM.text = cdec(lblUP.text) * ReqCOM.GetFieldVal("Select Rate/unit_conv as [Desc] from curr where Curr_Code = '" & trim(lblCurrCode.text) & "';","Desc")
        'txtBalQty.text = cint(txtOrderQty.text) - cint(txtQtyDel.text)
    End sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            'Dim StrSql as string
            'Dim PartNo as string = ReqCOM.GetFieldVal("Select Part_No from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Part_No")
            'Dim ETADate as datetime = ReqCOM.GetFieldVal("Select Del_Date from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Del_Date")
            'Try
            '    StrSql = "Insert into MIF_D(MIF_NO,PO_NO,PART_NO,IN_QTY,Del_Date,Date_Receive,ORDER_QTY,FOC_QTY,UP,UP_RM,WAC) "
            '    StrSql = StrSql + "Select '" & trim(lblMIFNo.text) & "','" & trim(cmbPONo.selectedItem.text) & "','" & trim(PartNo) & "'," & cint(txtInQty.text) & ",'" & cdate(ETADate) & "','" & now & "'," & cdec(txtOrderQty.text) & ",0," & cdec(lblUP.text) & "," & cdec(lblUPRM.text) & "," & cdec(lblWAC.text) & ";"
            '    ReqCOM.ExecuteNonQuery(StrSql)
            'Catch Err as exception
            '    response.write(err.tostring())
            'End try
        End if
    End Sub
    
    Sub ValSources(sender As Object, e As ServerValidateEventArgs)
        'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        'if ReqCOM.FuncCheckDuplicate("Select Part_No from mif_d where MIF_NO = '" & trim(lblMIFNo.text) & "' and Part_No = '" & trim(cmbPartNo.selectedItem.text) & "' and PO_NO = '" & trim(cmbPONo.selecteditem.text) & "';","Part_No") = true then
        '    e.isvalid = false
        'End if
    End Sub
    
    Sub ValInQty(sender As Object, e As ServerValidateEventArgs)
        if txtInQty.text = "" then exit sub
        if isnumeric(txtInQty.text) = false then exit sub
        if cint(txtInQty.text) > cint(txtBalQty.text) then e.isvalid = false
    End Sub
    
    
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub
    
    Sub LoadPartDel()
    
    End sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    'Sub Validate_ServerValidate(sender As Object, e As ServerValidateEventArgs)
    '    Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    '    Dim PartNo as string = ReqCOM.GetFieldVal("Select Part_No from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Part_No")
    '    Dim ETADate as datetime = ReqCOM.GetFieldVal("Select Del_Date from PO_D where Seq_No = " & cint(cmbPartNo.selectedItem.value) & ";","Del_Date")
    
    '    if ReqCOM.funcCheckDuplicate("Select Top 1 MIF_NO from MIF_D where MIF_NO = '" & trim(lblMIFNo.text) & "' and Part_No = '" & trim(PartNo) & "' and po_no = '" & trim(cmbPONo.selecteditem.value) & "' and Del_Date = '" & ETADate & "';","MIF_NO") = true then
    '        e.isvalid = false
    '    End if
    'End Sub
    
    
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub txtPONo_TextChanged(sender As Object, e As EventArgs)
    
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 15px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" width="100%" cssclass="FormDesc">MATERIAL INCOMING
                                FORM (MIF) ITEM</asp:Label>
                            </p>
                            <p>
                                <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" width="118px" cssclass="LabelNormal">P/O No</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:Label id="lblPONo" runat="server" width="100%" cssclass="LabelNormal"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" width="138px" cssclass="LabelNormal">Part No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPartNo" runat="server" width="100%" cssclass="LabelNormal"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" width="138px" cssclass="LabelNormal">ETA Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblETADate" runat="server" width="100%" cssclass="LabelNormal"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="94px" cssclass="LabelNormal">Quantity</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtInQty" runat="server" Width="221px" CssClass="OutputText"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" width="124px" cssclass="LabelNormal">Order Qty</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtOrderQty" runat="server" Width="221px" CssClass="OutputText" Enabled="False"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label11" runat="server" width="130px" cssclass="LabelNormal">Qty. Delivered</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtQtyDel" runat="server" Width="221px" CssClass="OutputText" Enabled="False"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label12" runat="server" width="82px" cssclass="LabelNormal">Bal. Qty.</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtBalQty" runat="server" Width="221px" CssClass="OutputText" Enabled="False"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdAdd" onclick="cmdAdd_Click" runat="server" Width="174px" Text="Add to list"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                    </p>
                                                                </td>
                                                                <td width="34%">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td width="33%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="95px" Text="Exit" CausesValidation="False"></asp:Button>
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
