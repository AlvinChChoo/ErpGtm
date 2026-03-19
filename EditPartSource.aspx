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
            lblUPASNo.text = ReqCOM.GetFIeldVal("Select Top 1 UPAS_No from UPAS_M where Seq_No = " & clng(request.params("ID")) & ";","UPAS_No")
        end if
    End Sub
    
    Sub ProcLoadGridData(PartNo as string)
        Dim StrSql as string = "Select ps.up_app_no as [UPAS_No], ps.ori_ven_name,ps.ori_up,ps.ori_curr_code,V.Curr_Code,PS.VEN_SEQ, PS.CANCEL_LT,PS.RESCHEDULE_LT,PS.UP_APP_NO, PS.MODIFY_DATE, PS.Lead_Time,PS.SEQ_NO,PS.UP,PS.Modify_By,PS.Std_Pack_Qty,PS.Min_Order_Qty,V.Ven_name as [Vendor],V.Ven_Code,ps.part_no from Part_Source PS,Vendor v where PS.Part_No = '" & trim(PartNo) & "' and PS.Ven_Code = V.Ven_Code ORDER BY PS.VEN_SEQ ASC"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_source")
        GridControl1.DataSource=resExePagedDataSet.Tables("Part_source").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub LoadData()
        Dim strSql as string = "SELECT * FROM Part_Master WHERE Part_No = '" & trim(cmbPartNo.selecteditem.value) & "';"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
        Dim PartType,TariffCode,ObsolutePart,UOM as string
        do while ResExeDataReader.read
            lblSpecification.text= ResExeDataReader("Part_Spec").tostring
            lblPartType.text = ResExeDataReader("Part_Type").tostring  & " / " & ResExeDataReader("Part_Desc").tostring
            lblMfgPartNo.text = ResExeDataReader("M_Part_No").tostring
        loop
    End sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim UP As Label = CType(e.Item.FindControl("UP"), Label)
            Dim MOQ As Label = CType(e.Item.FindControl("MOQ"), Label)
            Dim SPQ As Label = CType(e.Item.FindControl("SPQ"), Label)
    
            UP.text = format(cdec(UP.text),"##,##0.00000")
            MOQ.text = clng(MOQ.text)
            SPQ.text = clng(SPQ.text)
        End if
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("UnitPriceApprovalSheetDet.aspx?ID=" & clng(Request.params("ID")))
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        cmbPartNo.items.clear
    
        Dissql ("Select Part_No,Part_No + '|' + Part_Desc as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' order by Part_No asc","Part_No","Desc",cmbPartNo)
    
        if cmbPartNo.selectedIndex = -1 then
            lblSpecification.text = ""
            lblPartType.text = ""
            lblMfgPartNo.text = ""
            procLoadGridData(txtSearchPart.text)
        elseif cmbPartNo.selectedIndex <> -1 then
            LoadData
            procLoadGridData(txtSearchPart.text)
        end if
        txtSearchPart.text = "-- Search --"
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
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadData
        procLoadGridData (txtSearchPart.text)
    End Sub
    
    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim StrSql as string
    
        if page.isvalid = true then
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim i as integer
            Dim LeadTime,ReSch,Canc As Textbox
            Dim SeqNo,LeadTimeB4,ReschB4,CancB4 as label
            Dim Changes as string
    
            For i = 0 To GridControl1.Items.Count - 1
                Changes = "N"
                SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
    
                LeadTimeB4 = CType(GridControl1.Items(i).FindControl("LeadTimeB4"), Label)
                ReschB4 = CType(GridControl1.Items(i).FindControl("ReschB4"), Label)
                CancB4 = CType(GridControl1.Items(i).FindControl("CancB4"), Label)
    
                LeadTime = CType(GridControl1.Items(i).FindControl("LeadTime"), textbox)
                Canc = CType(GridControl1.Items(i).FindControl("Canc"), textbox)
                ReSch = CType(GridControl1.Items(i).FindControl("ReSch"), textbox)
    
                if trim(LeadTimeB4.text) <> trim(LeadTime.text) then Changes = "Y"
                if trim(ReschB4.text) <> trim(ReSch.text) then Changes = "Y"
                if trim(CancB4.text) <> trim(Canc.text) then Changes = "Y"
    
                if trim(Changes) = "Y" then
                    StrSql = "Insert into UPAS_D(UPAS_No,Part_No,Ven_Code,ACT,UP,Std_Pack,Min_Order_Qty,Lead_Time,FOC_PCTG,A_Ven_Code,A_UP,A_Lead_Time,A_Std_Pack,A_Min_Order_Qty,Diff_Amt,Diff_Pctg,Validity,Cancel_Lt,A_Cancel_Lt,Reschedule_lt,A_Reschedule_lt,Ori_Ven_Name,Ori_Curr_Code,Ori_UP,A_Ori_Ven_Name,A_Ori_Curr_Code,A_Ori_UP)"
                    StrSql = StrSql & " Select '" & trim(lblUPASNo.text) & "',"
                    StrSql = StrSql & "Part_No,Ven_Code,'EDIT',UP,STD_PACK_QTY,MIN_ORDER_QTY,LEAD_TIME,FOC_PCTG,Ven_Code,UP," & clng(LeadTime.text) & ",Std_Pack_Qty,Min_Order_Qty,0,0,0,CanCel_LT," & clng(Canc.text) & ",Reschedule_LT," & clng(ReSch.text) & ",Ori_Ven_Name,Ori_Curr_Code,Ori_UP,Ori_Ven_Name,Ori_Curr_Code,Ori_UP "
                    StrSql = StrSql & " from Part_Source where seq_no = " & clng(SeqNo.text) & ";"
                    ReqCOM.ExecuteNonQUery(StrSql)
                    ReqCOM.ExecuteNonQUery("Update UPAs_D set upas_d.A_Curr_Code = vendor.Curr_Code, upas_d.Curr_Code = vendor.Curr_Code,upas_d.ven_code_temp = vendor.ven_name,upas_d.A_ven_code_temp = vendor.ven_name from Vendor,UPAS_D where UPAS_d.vEN_cODE_temp is null and upas_d.ven_code = Vendor.ven_code")
                    ReqCOM.ExecuteNonQUery("Update UPAS_D set UPAS_D.UP_RM = UPAS_D.UP * Curr.Rate / Curr.Unit_Conv,UPAS_D.A_UP_RM = UPAS_D.UP * Curr.Rate / Curr.Unit_Conv from UPAS_D,Curr where UPAS_D.CUrr_Code = Curr.Curr_Code and upas_d.UP_RM is null")
                End if
            Next i
        End if
        response.redirect("EditPartSource.aspx?ID=" & clng(Request.params("ID")))
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub ValQtyInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim i as integer
        Dim LeadTime, Resch,Canc as textbox
        For i = 0 To GridControl1.Items.Count - 1
            LeadTime = CType(GridControl1.Items(i).FindControl("LeadTime"), Textbox)
            Resch = CType(GridControl1.Items(i).FindControl("Resch"), Textbox)
            Canc = CType(GridControl1.Items(i).FindControl("Canc"), Textbox)
            if trim(LeadTime.text) = "" then e.isvalid = false : Exit sub
            if trim(Resch.text) = "" then e.isvalid = false : Exit sub
            if trim(Canc.text) = "" then e.isvalid = false : Exit sub
            if isnumeric(LeadTime.text) = false then e.isvalid = false : Exit sub
            if isnumeric(Resch.text) = false then e.isvalid = false : Exit sub
            if isnumeric(Canc.text) = false then e.isvalid = false : Exit sub
        Next i
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 9px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p>
                                <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" backcolor="" forecolor="" width="100%" cssclass="FormDesc">PART
                                SOURCE LIST</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="90%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="ValQtyInput" runat="server" EnableClientScript="False" ErrorMessage="You don't seem to have supplied a valid value." Display="Dynamic" ForeColor=" " OnServerValidate="ValQtyInput_ServerValidate" Width="100%" CssClass="ErrorText"></asp:CustomValidator>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="80%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" width="112px" cssclass="LabelNormal">UPA No</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:Label id="lblUPASNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label3" runat="server" width="112px" cssclass="LabelNormal">Part No</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                    <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" Text="GO" CausesValidation="False" Height="20px"></asp:Button>
                                                                    &nbsp;
                                                                    <asp:DropDownList id="cmbPartNo" runat="server" Width="245px" CssClass="OutputText" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Part Type / Description</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:Label id="lblPartType" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <p>
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Specification</asp:Label>
                                                                </p>
                                                            </td>
                                                            <td colspan="3">
                                                                <p>
                                                                    <asp:Label id="lblSpecification" runat="server" width="100%" cssclass="OutputText"></asp:Label>
                                                                </p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal">Mfg. Part No</asp:Label></td>
                                                            <td colspan="3">
                                                                <asp:Label id="lblMfgPartNo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PageSize="20" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" Font-Name="Verdana" Font-Names="Verdana" Font-Size="XX-Small" PagerStyle-HorizontalAligh="Right" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn Visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Ven_Seq" HeaderText="SEQ"></asp:BoundColumn>
                                                            <asp:TemplateColumn Visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="VenCode" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Code") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Vendor">
                                                                <ItemTemplate>
                                                                    <asp:Label id="VenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Vendor") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Curr_Code" HeaderText="Curr."></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="SPQ">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Std_Pack_Qty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MOQ">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Min_Order_Qty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="U/P">
                                                                <ItemTemplate>
                                                                    <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="UPA #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="UPASNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UPAS_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="CANC.">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="Canc" CssClass="OutputText" runat="server" width= "50px" text='<%# DataBinder.Eval(Container.DataItem, "Cancel_LT") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="RE-SCH">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="ReSch" CssClass="OutputText" runat="server" width= "50px" text='<%# DataBinder.Eval(Container.DataItem, "Reschedule_LT") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="L/T(Wks)">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="LeadTime" CssClass="OutputText" width= "50px" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lead_Time") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CancB4" cssclass="OutputText" runat="server" width= "50px" text='<%# DataBinder.Eval(Container.DataItem, "Cancel_LT") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ReSchB4" cssclass="OutputText" runat="server" width= "50px" text='<%# DataBinder.Eval(Container.DataItem, "Reschedule_LT") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LeadTimeB4" cssclass="OutputText" width= "50px" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lead_Time") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="50%">
                                                                    <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Text="Update Changes"></asp:Button>
                                                                </td>
                                                                <td width="50%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="189px" Text="Back"></asp:Button>
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
