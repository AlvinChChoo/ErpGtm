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
            LoadPOMain()
            LoadPODet()
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
    
    Sub LoadPODet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update PO_D set prev_del_date = del_date where po_no = '" & trim(lblPONo.text) & "' and prev_del_date is null")
        Dim StrSql as string = "Select po.prev_del_date,PO.REM,PO.Modify_By, PO.Modify_Date,PO.Del_Date_Con ,PO.Del_Date_Con,PO.SEQ_NO,PM.M_PART_NO, PM.PART_DESC + '  -  ' + PM.PART_SPEC as [PART_DESC], PO.PO_NO,PO.PART_NO,PO.DEL_DATE,PO.ORDER_QTY,PO.UP from PO_D PO,PART_MASTER PM where PO.PO_NO = '" & trim(lblPONo.text) & "' AND PO.PART_NO = PM.PART_NO order by po.part_no, PO.DEL_DATE asc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"PO_D")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("PO_D").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        LoadPODet()
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim InQty As Label = CType(e.Item.FindControl("InQty"), Label)
            Dim BalQty As Label = CType(e.Item.FindControl("BalQty"), Label)
            Dim ETA As Label = CType(e.Item.FindControl("ETA"), Label)
            Dim ConDate As Textbox = CType(e.Item.FindControl("ConDate"), Textbox)
            Dim ModifyDate As Label = CType(e.Item.FindControl("ModifyDate"), Label)
            Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
            Dim OrderQty As Label = CType(e.Item.FindControl("OrderQty"), Label)
            Dim Amount As Label = CType(e.Item.FindControl("Amount"), Label)
            Dim UP As Label = CType(e.Item.FindControl("UP"), Label)
            Dim ETACon As CheckBox = CType(e.Item.FindControl("ETACon"), CheckBox)
    
            if reqCom.FuncCheckDuplicate("Select * from MIF_D where PO_NO = '" & trim(lblPONo.text) & "' and Part_no = '" & trim(PartNo.text) & "' and Del_Date = '" & cdate(ETA.text) & "';","Po_no") = true then
                InQty.text = ReqCOM.GetFieldVal("Select sum(In_Qty) as [inQty] from mif_d where PO_NO = '" & trim(lblPONo.text) & "' and Part_No = '" & trim(PartNo.text) & "';","InQty")
                BalQty.text = cint(OrderQty.text) - cint(InQty.text)
            Else
                InQty.text = 0
                BalQty.text = cint(OrderQty.text)
            end if
            Amount.text = format(cdec(OrderQty.text) * cdec(UP.text),"##,##0.00")
            if cint(balQty.text) = 0 then e.Item.CssClass = "PartSource"
            if trim(ModifyDate.text) <> "" then ModifyDate.text = format(cdate(ModifyDate.text),"dd/MMM/yy")
            if trim(ConDate.text) <> "" then ConDate.text = format(cdate(ConDate.text),"dd/MM/yy")
            if trim(eta.text) <> "" then ETA.text = format(cdate(ETA.text),"dd/MMM/yy")
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("PurchaseOrder.aspx")
    End Sub
    
    Sub cmdComnETA_Click(sender As Object, e As EventArgs)
        Dim SeqNo,i,CMonth,CDay,CYear as integer
        Dim CDt as string
        Dim ConDate,Remarks as Textbox
        Dim ETA,PartNo,ActualConDate as label
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
    
        if page.isvalid = true then
            For i = 0 To dtgPartWithSource.Items.Count - 1
                SeqNo = dtgPartWithSource.items(i).cells(0).text
                ConDate = CType(dtgPartWithSource.Items(i).FindControl("ConDate"), Textbox)
                Remarks = CType(dtgPartWithSource.Items(i).FindControl("Remarks"), Textbox)
                ETA = CType(dtgPartWithSource.Items(i).FindControl("ETA"), label)
                ActualConDate = CType(dtgPartWithSource.Items(i).FindControl("ActualConDate"), label)
                PartNo = CType(dtgPartWithSource.Items(i).FindControl("PartNo"), label)
                CDt = ConDate.text
                Cmonth = CDt.substring(3,2)
                CDay  = CDt.substring(0,2)
                CYear = CDt.substring(6,2)
                Cdt = CMonth & "/" & Cday & "/" & CYear
    
                if cdate(ActualConDate.text) <> cdate(CDt) then
                    ReqCOM.ExecuteNonQuery("Update PO_D set Del_Date_Con = 'Y',Del_Date = '" & cdate(CDt) & "',Modify_By = '" & trim(request.cookies("U_ID").value) & "',Modify_Date='" & now & "' where Seq_No = " & cint(SeqNo) & ";")
                    ReqCOM.ExecuteNonQuery("Insert into po_eta_trail(PO_NO,PART_NO,ETA_DATE,CON_DATE,REM,create_by,create_date) select '" & trim(lblPONo.text) & "','" & trim(PartNo.text) & "','" & ETA.text & "','" & CDt & "','" & trim(replace(Remarks.text,"'","`")) & "','" & trim(request.cookies("U_ID").value) & "','" & now & "'")
                end if
                ReqCOM.ExecuteNonQuery("Update PO_D set Rem = '" & trim(replace(Remarks.text,"'","`")) & "' where Seq_No = " & cint(SeqNo) & ";")
            Next
            ShowAlert("P/O details updated.")
            redirectPage("PurchaseOrderDet.aspx?ID=" & Request.params("ID"))
        End if
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
        For i = 0 To dtgPartWithSource.Items.Count - 1
            ConDate = Ctype(dtgPartWithSource.Items(i).FindControl("ConDate"), Textbox)
            CDt = ConDate.text
            Cmonth = CDt.substring(3,2)
            CDay  = CDt.substring(0,2)
            CYear = CDt.substring(6,2)
            Cdt = CMonth & "/" & Cday & "/" & CYear
    
            if isdate(cdt) = false then  CustomValidator1.text = "You don't seem to have supplied a valid ETA Date." : e.isvalid = false :Exit sub
    
        '    Dim ETACon As CheckBox = Ctype(dtgPartWithSource.Items(i).FindControl("ETACon"), CheckBox)
        '    if ETACon.checked = true then
        '        if trim(ConDate.text) = "" then CustomValidator1.text = "You don't seem to have supplied a valid ETA Date." : e.isvalid = false :Exit for
        '        if isdate(ConDate.text) = false then CustomValidator1.text = "You don't seem to have supplied a valid ETA Date.": e.isvalid = false : Exit for
        '    end if
        Next
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub SplitVendor(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        response.redirect("SplitPO.aspx?ID=" & SeqNo.text)
    End sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=900,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        LoadPODet()
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
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
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">Purchase Order
                                Details.</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                            </td>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="CustomValidator1" runat="server" Width="100%" Display="Dynamic" OnServerValidate="ValDuplicateDate" CssClass="ErrorText" ForeColor=" "></asp:CustomValidator>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
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
                                                <p>
                                                    <asp:Label id="Label3" runat="server" cssclass="Legend" width="100%">Highlighted item
                                                    indicates that parts already fully shipped in.</asp:Label>
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartWithSource" runat="server" width="100%" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" OnSortCommand="SortGrid" AllowSorting="True" OnItemDataBound="FormatRow" OnEditCommand="SplitVendor">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:BoundColumn Visible="False" DataField="Seq_No"></asp:BoundColumn>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Part No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_DESC" HeaderText="DESCRIPTION"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="M_PART_NO" HeaderText="MFG. PART NO"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="ETA">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="ETA" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prev_Del_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Order Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="OrderQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Order_Qty") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="U/P">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Amount">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="Amount" runat="server" text='' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="In Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="InQty" runat="server" text='' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Bal Qty.">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="BalQty" runat="server" text='' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Con. ETA">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="ConDate" Font-Size="11px" runat="server" align="right" Columns="10" MaxLength="10" Text='<%# DataBinder.Eval(Container.DataItem, "Del_Date") %>' width="65px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Remarks">
                                                                <HeaderStyle horizontalalign="left"></HeaderStyle>
                                                                <ItemStyle horizontalalign="left"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:TextBox id="Remarks" Font-Size="11px" runat="server" align="right" Text='<%# DataBinder.Eval(Container.DataItem, "Rem") %>' width="300px" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Modify_By" HeaderText="Edit By"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Edit Date">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModifyDate" runat="server" align="right" columns="10" maxlength="10" text='<%# DataBinder.Eval(Container.DataItem, "Modify_Date") %>' width="65px" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:EditCommandColumn ButtonType="PushButton" UpdateText="" CancelText="" EditText="Split"></asp:EditCommandColumn>
                                                            <asp:BoundColumn Visible="False" DataField="Del_Date_Con"></asp:BoundColumn>
                                                            <asp:TemplateColumn visible= "false">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="ActualConDate" font-size="11px" runat="server" align="right" columns="10" maxlength="10" text='<%# DataBinder.Eval(Container.DataItem, "Del_Date") %>' width="65px" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdComnETA" onclick="cmdComnETA_Click" runat="server" Width="192px" Text="Update PO Item"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Width="192px" Text="Refresh PO Item"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="134px" Text="Back"></asp:Button>
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
