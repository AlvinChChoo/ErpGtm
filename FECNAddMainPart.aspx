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
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
            lblFECNNo.text = ReqCOM.GetFieldVal("Select FECN_NO from FECN_M where SEQ_NO = " & Request.params("ID") & ";","FECN_NO")
            lblModelNo.text = ReqCOm.GetFieldVal("Select Model_No from FECN_M where Seq_No = " & Request.params("ID") & ";","Model_No")
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
    
    Sub cmbPartNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCom as ERp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
        lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
    End Sub
    
    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub Save_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERp_Gtm.Erp_gtm = new Erp_Gtm.ERP_Gtm
            Dim PartNo,PartDesc,PartSpec,MPN As Label
            Dim StrSql, RefAlt as string
            Dim Remove as checkbox
            Dim SeqNo as long
            Dim i as integer
    
            StrSql = "Insert into FECN_D(FECN_NO,MAIN_PART_B4,ALT_PART_B4,PART_DESC_B4,PART_SPEC_B4,"
            StrSql = StrSql + "M_PART_NO_B4,P_USAGE_B4,P_LEVEL_B4,P_LOCATION_B4,MAIN_PART,ALT_PART,"
            StrSql = StrSql + "PART_DESC,PART_SPEC,M_PART_NO,P_USAGE,P_LEVEL,P_LOCATION,REASON_CHANGE,IMP_TYPE,TYPE_CHANGE) "
    
            StrSql = StrSql + "Select '" & trim(lblFECNNo.text) & "','-','-','-','-',"
            StrSql = StrSql + "'-',0,'-','-',Part_No,'-',"
            StrSql = StrSql + "Part_Desc,Part_Spec,M_Part_No," & txtUsage.text & ","
            StrSql = StrSql + "'" & trim(cmbLevel.selectedItem.value) & "',"
            StrSql = StrSql + "'" & trim(txtLoc.text) & "','" & trim(txtReasonChange.text) & "','" & TRIM(cmbImpType.SELECTEDITEM.VALUE) & "','Add Main Part' "
            StrSql = StrSql + "from Part_Master where Part_No = '" & trim(cmbPartNo.selectedItem.value) & "';"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = ""
            RefAlt = ""
            SeqNo = ReqCOM.GetFieldVal("Select top 1 Seq_No from FECN_D order by seq_no desc","Seq_No")
            For i = 0 To dtgAltAfter.Items.Count - 1
    
                Remove = CType(dtgAltAfter.Items(i).FindControl("Remove"), Checkbox)
    
                if Remove.checked = false then
                    PartNo = CType(dtgAltAfter.Items(i).FindControl("PartNo"), Label)
                    PartDesc = CType(dtgAltAfter.Items(i).FindControl("PartDesc"), Label)
                    PartSpec = CType(dtgAltAfter.Items(i).FindControl("PartSpec"), Label)
                    MPN = CType(dtgAltAfter.Items(i).FindControl("MPN"), Label)
    
                    if trim(StrSql) = "" then
                        StrSql = "Insert into FECN_ALT(FECN_NO,Main_Part,Part_No,Ref_Seq,Status) select '" & TRIM(lblFECNNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "','" & trim(PartNo.text) & "'," & clng(SeqNo) & ",'A'"
                        RefAlt = trim(PartNo.text) & "-" & trim(PartDesc.text) & "-" & trim(PartSpec.text) & "-" & trim(MPN.text)
                    elseif trim(StrSql) <> "" then
                        StrSql = StrSql & ";Insert into FECN_ALT(FECN_NO,Main_Part,Part_No,Ref_Seq,Status) select '" & TRIM(lblFECNNo.text) & "','" & trim(cmbPartNo.selecteditem.value) & "','" & trim(PartNo.text) & "'," & clng(SeqNo) & ",'A'"
                        RefAlt = RefAlt & vblf & trim(partNo.text) & "-" & trim(PartDesc.text) & "-" & trim(partSpec.text) & "-" & trim(MPN.text)
                    End if
                End if
            Next i
    
            if trim(StrSql) <> "" then ReqCOM.ExecuteNonQuery(StrSql)
            ReqCOM.ExecuteNonQuery("Delete from FECN_ALT_VAR where u_id = '" & trim(request.cookies("U_ID").value) & "';")
            ReqCOM.ExecuteNonQuery("Update FECN_D set Ref_Alt = '" & trim(RefAlt) & "' where seq_no = " & SeqNo & ";")
    
            Response.redirect("FECNDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        Dim PartDesc as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Delete from FECN_ALT_VAR where U_ID = '" & trim(Request.cookies("U_ID").value) & "';")
        cmbPartNo.items.clear
        ClearDet
        Dissql ("Select Part_No,Part_No as [Desc] from Part_Master where part_no like '%" & cstr(txtSearchPart.Text) & "%' order by Part_No asc","Part_No","Desc",cmbPartNo)
    
        if cmbPartNo.selectedindex <> -1 then
            ReqCOM.ExecuteNonQuery("Insert into FECN_ALT_VAR(Part_No,U_ID) Select distinct(Part_No),'" & trim(request.cookies("U_ID").value) & "' from BOM_ALT where Main_Part = '" & trim(cmbPartNo.selectedItem.Value) & "';")
            LoadAltPart
            lblPartSpec.text = ReqCOM.GetFieldVal("Select Part_Spec from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Spec")
            lblPartDesc.text = ReqCOM.GetFieldVal("Select Part_Desc from Part_Master where Part_No = '" & cmbPartNo.selecteditem.value & "';","Part_Desc")
            txtSearchPart.text = "-- Search --"
        Else
            txtSearchPart.text = "-- Search --"
            ShowAlert("Invalid Part No.")
        end if
    
    End Sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Sub ClearDet()
        lblPartSpec.text = ""
        lblPartDesc.text = ""
    End sub
    
    Sub cmdLevel_Click(sender As Object, e As EventArgs)
        Dim Level as string
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    
        cmbLevel.items.clear
        Dissql ("Select Level_Code from P_Level where Level_Code like '%" & cstr(txtSearchLevel.Text) & "%' order by Level_Code asc","Level_Code","Level_Code",cmbLevel)
        txtSearchLevel.text = "-- Search --"
    
        if cmbLevel.Selectedindex = -1 then
            ShowAlert("Invalid Level.")
        end if
    End Sub
    
    Sub LoadAltPart()
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim StrSql as string = "Select distinct(Part_No), Part_Desc, Part_Spec,M_Part_No from Part_master where part_no in (Select Part_No from fecn_alt_var where u_id = '" & trim(request.cookies("U_ID").value) & "')"
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Part_Master")
        dtgAltAfter.DataSource=resExePagedDataSet.Tables("Part_Master").DefaultView
        dtgAltAfter.DataBind()
    end sub
    
    Sub lnkAddAlt_Click(sender As Object, e As EventArgs)
        ShowPopup("PopupFECNAddAlt.aspx")
    End Sub
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=350');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdRefreshAltPart_Click(sender As Object, e As EventArgs)
        LoadAltPart()
    End Sub
    
        Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                'Dim App1By As Label = CType(e.Item.FindControl("App1By"), Label)
                'Dim App1Date As Label = CType(e.Item.FindControl("App1Date"), Label)
                Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
    
                if trim(ucase(PartNo.text)) = trim(cmbPartNo.selecteditem.value) then e.Item.CssClass = "Urgent"
            End if
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
            <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">FECN - ADD
                                MAIN PART</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 13px" cellspacing="0" cellpadding="0" width="82%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="cmbLevel" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Level" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="cmbPartNo" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Part No" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator3" runat="server" ControlToValidate="txtLoc" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Location" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator4" runat="server" ControlToValidate="txtReasonChange" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Reason of Changes" Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:RequiredFieldValidator id="RequiredFieldValidator5" runat="server" ControlToValidate="txtUsage" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Usage." Width="100%" CssClass="ErrorText"></asp:RequiredFieldValidator>
                                                </div>
                                                <div align="center">
                                                    <asp:comparevalidator id="valUsage" runat="server" ControlToValidate="txtUsage" EnableClientScript="False" Display="Dynamic" ForeColor=" " ErrorMessage="You don't seem to have supplied a valid Usage" Width="100%" CssClass="ErrorText" ValueToCompare="0" Operator="GreaterThan" Type="Double"></asp:comparevalidator>
                                                    <asp:Label id="Label12" runat="server" cssclass="SectionHeader" width="100%">Part
                                                    Details and Alternate Part (New Part)</asp:Label> 
                                                    <table class="sideboxnotop" style="HEIGHT: 9px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p>
                                                                        <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                                            <tbody>
                                                                                <tr>
                                                                                    <td width="23%" bgcolor="silver">
                                                                                        <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="116px">FECN No</asp:Label></td>
                                                                                    <td width="77%">
                                                                                        <asp:Label id="lblFECNNo" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="116px">Model No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblModelNo" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="116px">Part No</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtSearchPart" onkeydown="KeyDownHandler(cmdGo)" onclick="GetFocus(txtSearchPart)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdGo" onclick="cmdGo_Click" runat="server" CssClass="OutputText" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                                        &nbsp; 
                                                                                        <asp:DropDownList id="cmbPartNo" runat="server" Width="355px" CssClass="OutputText" OnSelectedIndexChanged="cmbPartNo_SelectedIndexChanged" autopostback="True"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">Level</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtSearchLevel" onkeydown="KeyDownHandler(cmdLevel)" onclick="GetFocus(txtSearchLevel)" runat="server" Width="78px" CssClass="OutputText">-- Search --</asp:TextBox>
                                                                                        <asp:Button id="cmdLevel" onclick="cmdLevel_Click" runat="server" CssClass="OutputText" Height="20px" Text="GO" CausesValidation="False"></asp:Button>
                                                                                        &nbsp; 
                                                                                        <asp:DropDownList id="cmbLevel" runat="server" Width="355px" CssClass="OutputText"></asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="116px">Description</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblPartDesc" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="116px">Specification</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:Label id="lblPartSpec" runat="server" cssclass="OutputText" width="472px"></asp:Label></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="116px">Location</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtLoc" runat="server" Width="100%" CssClass="OutputText" Height="66px" TextMode="MultiLine"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="">Reason of changes</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtReasonChange" runat="server" Width="473px" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="116px">Usage</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:TextBox id="txtUsage" runat="server" Width="176px" CssClass="OutputText"></asp:TextBox>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td bgcolor="silver">
                                                                                        <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="116px">Implementation</asp:Label></td>
                                                                                    <td>
                                                                                        <asp:DropDownList id="cmbImpType" runat="server" Width="176px" CssClass="OutputText">
                                                                                            <asp:ListItem Value="Immediate">Immediate</asp:ListItem>
                                                                                            <asp:ListItem Value="Running Change">Running Change</asp:ListItem>
                                                                                            <asp:ListItem Value="Next Lot">Next Lot</asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                    </td>
                                                                                </tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </p>
                                                                    <p>
                                                                        <asp:LinkButton id="lnkAddAlt" onclick="lnkAddAlt_Click" runat="server" Width="100%" CssClass="OutputText" CausesValidation="False">Click here to add alternate part</asp:LinkButton>
                                                                        <asp:DataGrid id="dtgAltAfter" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn HeaderText="Part No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Description">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Specification">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PartSpec" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="MPN">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="MPN" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "M_Part_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Remove">
                                                                                    <ItemTemplate>
                                                                                        <asp:checkbox id="Remove" runat="server" />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <p>
                                                    <table style="HEIGHT: 22px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="Save" onclick="Save_Click" runat="server" Width="134px" Text="Save" CausesValidation="True"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRefreshAltPart" onclick="cmdRefreshAltPart_Click" runat="server" Width="134px" Text="Refresh Alt Part" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="134px" Text="Cancel" CausesValidation="False"></asp:Button>
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
