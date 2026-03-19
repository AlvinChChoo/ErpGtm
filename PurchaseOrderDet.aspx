<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
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
            LoadPOMain()
            LoadPO
            FormatRow()
        End if
    End Sub
    
    Sub LoadPOMain()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rsPO as SQLDataReader = ReqCOM.ExeDataReader("Select * from PO_M where Seq_No = " & request.params("ID") & ";")
        Do while rsPO.read
            lblPONo.text = rsPO("PO_NO").tostring
            lblSupplierName.text = ReqCOM.getFieldVal("Select Top 1 Ven_Name from Vendor where ven_code = '" & trim(rsPO("VEN_CODE")) & "';","Ven_Name")
            lblPayTerm.text = rsPO("PAY_TERM").tostring
            lblNotes.text = rsPO("REM").tostring
            lblCreateBy.text = rsPO("CREATE_BY").tostring
            lblCreateDate.text = format(rsPO("CREATE_DATE"),"MM/dd/yy")
            lblModifyBy.text = rsPO("MODIFY_BY").tostring
            if isdbnull(rsPO("MODIFY_DATE")) = false then lblModifyDate.text = format(rsPO("MODIFY_DATE").tostring,"MM/dd/yy")
            lblPODate.text = format(rsPO("PO_DATE"),"MM/dd/yy")
            lblSupplierID.text = rsPO("VEN_CODE").tostring
            lblShipTerm.text = rsPO("SHIP_TERM").tostring
            lblCurrency.text = rsPO("CURR_CODE").tostring
        loop
    End sub
    
    Sub FormatRow()
        Dim i As Integer
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        Dim ETA,PartNo,InQty,BalQty,OrderQty,UP,Amt,EditDate as label
        Dim ConETA as textbox
    
        For i = 0 To MyList.Items.Count - 1
            ETA = CType(MyList.Items(i).FindControl("ETA"), Label)
            ConETA = CType(MyList.Items(i).FindControl("ConETA"), textbox)
            PartNo = CType(MyList.Items(i).FindControl("PartNo"), Label)
            ETA = CType(MyList.Items(i).FindControl("ETA"), Label)
            'InQty = CType(MyList.Items(i).FindControl("InQty"), Label)
            'BalQty = CType(MyList.Items(i).FindControl("BalQty"), Label)
            OrderQty = CType(MyList.Items(i).FindControl("OrderQty"), Label)
            UP = CType(MyList.Items(i).FindControl("UP"), Label)
            Amt = CType(MyList.Items(i).FindControl("Amt"), Label)
            EditDate = CType(MyList.Items(i).FindControl("EditDate"), Label)
    
            Amt.text = format(cdec(cdec(UP.text) * cdec(OrderQty.text)),"##,##0.00")
    
            if ETA.text <> "" then ETA.text = format(cdate(ETA.text),"dd/MM/yy")
            if ConETA.text <> "" then ConETA.text = format(cdate(ConETA.text),"dd/MM/yy")
            if EditDate.text <> "" then EditDate.text = format(cdate(EditDate.text),"dd/MM/yy")
        Next
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("PurchaseOrder.aspx")
    End Sub
    
    Sub cmdComnETA_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim SeqNo as label
            Dim RemInput,ConDate as textbox
            Dim CDt as string
            Dim i as integer
            Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            For i = 0 To MyList.Items.Count - 1
    
                ConDate = CType(MyList.Items(i).FindControl("ConETA"), textbox)
                SeqNo = CType(MyList.Items(i).FindControl("SeqNo"), label)
                RemInput = CType(MyList.Items(i).FindControl("RemInput"), textbox)
                if ConDate.text <> "" then
                    CDt = ConDate.text
                    ConDate.text = cint(CDt.substring(3,2)) & "/" & cint(CDt.substring(0,2)) & "/" & cint(CDt.substring(6,2))
    
    
                    ReqCOM.ExecuteNonQuery("Update PO_D set REM = '" & trim(replace(RemInput.text,"'","`")) & "',Del_Date_Con = 'Y',prev_Del_Date = '" & cdate(ConDate.text) & "',Modify_By = '" & trim(request.cookies("U_ID").value) & "',Modify_Date='" & now & "' where seq_no = " & SeqNo.text & ";")
                elseif ConDate.text = "" then
                    ReqCOM.ExecuteNonQuery("Update PO_D set REM = '" & trim(replace(RemInput.text,"'","`")) & "',prev_Del_Date = null where seq_no = " & SeqNo.text & ";")
                End if
            next i
            ShowAlert("P/O details updated.")
            redirectPage("PurchaseOrderDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ValDuplicateDate(sender As Object, e As ServerValidateEventArgs)
        Dim CMonth,CDay,CYear as integer
        Dim CDt as string
        Dim ConDate As Textbox
        Dim i as integer
    
        e.isvalid = true
        For i = 0 To MyList.Items.Count - 1
            ConDate = Ctype(MyList.Items(i).FindControl("ConETA"), Textbox)
            if ConDate.text <> "" then
                CDt = ConDate.text
                Cmonth = CDt.substring(3,2)
                CDay  = CDt.substring(0,2)
                CYear = CDt.substring(6,2)
                Cdt = CMonth & "/" & Cday & "/" & CYear
                if isdate(cdt) = false then  CustomValidator1.text = "You don't seem to have supplied a valid ETA Date." : e.isvalid = false :Exit sub
            End if
        Next
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=900,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        Response.redirect("PurchaseOrderDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    sub LoadPO()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        'ReqCOM.UpdatePOInQty (lblPONo.text)
        Dim StrSql as string = "Select po.bal_qty,po.in_qty,po.foc_qty,po.prev_del_date,PO.REM,PO.Modify_By, PO.Modify_Date,PO.Del_Date_Con ,PO.Del_Date_Con,PO.SEQ_NO,PM.M_PART_NO, PM.PART_DESC,PM.PART_SPEC, PO.PO_NO,PO.PART_NO,PO.DEL_DATE,PO.ORDER_QTY,PO.UP from PO_D PO,PART_MASTER PM where PO.PO_NO = '" & trim(lblPONo.text) & "' AND PO.PART_NO = PM.PART_NO order by po.part_no, PO.DEL_DATE asc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ShowSelection(s as object,e as DataListCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        response.redirect("SplitPO.aspx?ID=" & SeqNo.text)
    end sub
    
    Sub SplitVendor(sender as Object,e as DataGridCommandEventArgs)
    '    Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    '    Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
    '    response.redirect("SplitPO.aspx?ID=" & SeqNo.text)
    End sub

</script>
<html>
<head>
    <link href="ibuyspy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <IBUYSPY:HEADER id="UserControl1" runat="server"></IBUYSPY:HEADER>
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                                <p align="center">
                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" Display="Dynamic" OnServerValidate="ValDuplicateDate" CssClass="ErrorText" ForeColor=" "></asp:CustomValidator>
                                </p>
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Purchase Order Header</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        <br />
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="96%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="15%" bgcolor="silver">
                                                                                        <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="137px">P/O No</asp:Label></td>
                                                                                    <td width="35%" colspan="2">
                                                                                        <span><label></label></span><asp:Label id="lblPONo" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                    <td width="15%" bgcolor="silver" colspan="2">
                                                                                        <asp:Label id="Label16" runat="server" cssclass="LabelNormal" width="137px">P/O Date</asp:Label></td>
                                                                                    <td width="35%">
                                                                                        <asp:Label id="lblPODate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="137px">Supplier
                                                                                        Name</asp:Label></td>
                                                                                    <td colspan="2">
                                                                                        <asp:Label id="lblSupplierName" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                    <td bgcolor="silver" colspan="2">
                                                                                        <asp:Label id="Label17" runat="server" cssclass="LabelNormal" width="137px">Supplier
                                                                                        ID</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblSupplierID" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="137px">Payment
                                                                                        Term</asp:Label></td>
                                                                                    <td colspan="2">
                                                                                        <asp:Label id="lblPayTerm" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                    <td bgcolor="silver" colspan="2">
                                                                                        <asp:Label id="Label18" runat="server" cssclass="LabelNormal" width="137px">Shipment
                                                                                        Term</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblShipTerm" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="137px">Notes</asp:Label></td>
                                                                                    <td colspan="2">
                                                                                        <asp:Label id="lblNotes" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                    <td bgcolor="silver" colspan="2">
                                                                                        <asp:Label id="Label19" runat="server" cssclass="LabelNormal" width="137px">Currency</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblCurrency" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="137px">Created
                                                                                        by</asp:Label></td>
                                                                                    <td colspan="2">
                                                                                        <asp:Label id="lblCreateBy" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                    <td bgcolor="silver" colspan="2">
                                                                                        <asp:Label id="Label20" runat="server" cssclass="LabelNormal" width="137px">Created
                                                                                        Date</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblCreateDate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="137px">Revised
                                                                                        By</asp:Label></td>
                                                                                    <td colspan="2">
                                                                                        <asp:Label id="lblModifyBy" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                    <td bgcolor="silver" colspan="2">
                                                                                        <asp:Label id="Label21" runat="server" cssclass="LabelNormal" width="137px">Revised
                                                                                        Date</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblModifyDate" runat="server" cssclass="OutputText" width="100%"></asp:Label></td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                        <br />
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <p>
                                                        <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                            <tbody>
                                                                <tr>
                                                                    <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                    </td>
                                                                    <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                        Purchase Order Item Details</td>
                                                                    <td width="28" background="Frame-Top-right.jpg">
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                        <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <p align="center">
                                                                            <br />
                                                                            <asp:DataList id="MyList" runat="server" Width="96%" Height="101px" CellPadding="1" BorderWidth="0px" RepeatColumns="1" OnItemCommand="ShowSelection" OnSelectedIndexChanged="MyList_SelectedIndexChanged">
                                                                                <ItemStyle font-size="XX-Small"></ItemStyle>
                                                                                <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                                                <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                                                <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                                                <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                                                <ItemTemplate>
                                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                        <tbody>
                                                                                            <tr>
                                                                                                <td bgcolor="silver" width= "20%">
                                                                                                    <asp:Label id="label1" runat="server">Part #</asp:Label></td>
                                                                                                <td>
                                                                                                    <asp:Label id="PartNo" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>'></asp:Label> <asp:Label id="SeqNo" cssclass="ListOutput" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_no") %>'></asp:Label> 
                                                                                                </td>
                                                                                                <td bgcolor="silver" >
                                                                                                    <asp:Label id="Label3" runat="server">Mfg Part #</asp:Label></td>
                                                                                                <td width= "25%">
                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "M_part_no") %> </span> 
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td bgcolor="silver" width= "25%">
                                                                                                    <asp:Label id="Label212" runat="server">Description</asp:Label></td>
                                                                                                </td>
                                                                                                <td colspan="5" width= "75%">
                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Part_Desc") %> </span> 
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td bgcolor="silver">
                                                                                                    <asp:Label id="Label21" runat="server">Specification</asp:Label></td>
                                                                                                </td>
                                                                                                <td colspan="5">
                                                                                                    <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Part_Spec") %> </span> 
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td bgcolor="silver">
                                                                                                    <asp:Label id="Label2112" runat="server">Remarks</asp:Label></td>
                                                                                                </td>
                                                                                                <td colspan="5">
                                                                                                    <asp:Textbox id="RemInput" cssclass="ListOutput" width="100%" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>'></asp:Textbox>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </tbody>
                                                                                    </table>
                                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label21212222" runat="server">ETA</asp:Label></td>
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label2131" runat="server">Order Qty.</asp:Label></td>
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label21311" runat="server">FOC Qty.</asp:Label></td>
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label2141" runat="server">U/P</asp:Label></td>
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label2151" runat="server">Amt.</asp:Label></td>
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label2161" runat="server">In Qty.</asp:Label></td>
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label2171" runat="server">Bal. Qty</asp:Label></td>
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label2181" runat="server">Con. ETA.</asp:Label></td>
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label2182" runat="server">Edit By</asp:Label></td>
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <asp:Label id="Label2183" runat="server">Edit Date</asp:Label></td>
                                                                                            </td>
                                                                                            <td bgcolor="silver"></td>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label id="ETA" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "del_date") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label id="OrderQty" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "order_qty") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label id="FOCQty" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "FOC_qty") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label id="UP" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "up") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label id="Amt" cssclass="ListOutput" runat="server" text=''></asp:Label> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label id="InQty" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "IN_Qty") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label id="BalQty" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Bal_Qty") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:textbox id="ConETA" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "prev_del_date") %>'></asp:textbox>
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label id="EditBy" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Modify_By") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label id="EditDate" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Modify_Date") %>'></asp:Label> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:LinkButton font-size="xx-small" id="myLinkBtns" text='Split' CssClass="ErrorText" CommandArgument='<%# Container.DataItem("Seq_No")%>' runat="server" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <br />
                                                                                </ItemTemplate>
                                                                                <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                                            </asp:DataList>
                                                                        </p>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </p>
                                                    <p>
                                                        <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Button id="cmdComnETA" onclick="cmdComnETA_Click" runat="server" Width="171px" CssClass="OutputText" Text="Update PO Item"></asp:Button>
                                                                    </td>
                                                                    <td>
                                                                        <div align="center">
                                                                            <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Width="157px" CssClass="OutputText" Text="Refresh PO Item"></asp:Button>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <div align="right">
                                                                            <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="129px" CssClass="OutputText" Text="Back"></asp:Button>
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
                                <p>
                                </p>
                                <p>
                                </p>
                                <p>
                                    <footer:footer id="footer" runat="server"></footer:footer>
                                </p>
                            </div>
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
