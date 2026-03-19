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
                    ShowMRFDet
                    ProcLoadGridData()
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
    
            Sub cmdSearch_Click(sender As Object, e As EventArgs)
                ProcLoadGridData()
            End Sub
    
            Sub ProcLoadGridData()
                Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
                Dim StrSql as string = "Select ISS.Main_Alt,ISS.Qty_Reissue,iss.P_Location,iss.Qty_other_Scrap,iss.type,iss.seq_no,iss.extra_req,iss.total_usage,iss.total_issued,iss.main_part,iss.qty_scrap,iss.qty_store,iss.qty_ir,iss.return_type,iss.rem,iss.qty_return,ISS.Part_No,ISS.Qty_Issued,PM.Part_Desc from MRF_D ISS,Part_Master PM where ISS.MRF_NO = '" & trim(lblMRFNo.text) & "' and ISS.PART_No = PM.Part_No order by main_part,main_alt desc"
    
                Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"Issuing_D")
                dtgShortage.DataSource=resExePagedDataSet.Tables("Issuing_D").DefaultView
                dtgShortage.DataBind()
            end sub
    
            Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
                If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                    Dim TotalUsage As Label = CType(e.Item.FindControl("TotalUsage"), Label)
                    Dim TotalIssued As Label = CType(e.Item.FindControl("TotalIssued"), Label)
                    Dim MainAlt As Label = CType(e.Item.FindControl("MainAlt"), Label)
                    Dim ExtraIssued As Label = CType(e.Item.FindControl("ExtraIssued"), Label)
                    Dim Type As Label = CType(e.Item.FindControl("Type"), Label)
                    Dim QtyToStore As textbox = CType(e.Item.FindControl("QtyToStore"), textbox)
                    Dim QtyToIR As textbox = CType(e.Item.FindControl("QtyToIR"), textbox)
                    Dim QtyScrap As textbox = CType(e.Item.FindControl("QtyScrap"), textbox)
    
                    if trim(TotalIssued.text) = "" then TotalIssued.text = "0"
                    if trim(TotalUsage.text) = "" then TotalUsage.text = "0"
    
                    ExtraIssued.text = clng(TotalIssued.text) - clng(TotalUsage.text)
                    if clng(ExtraIssued.text) < 0 then ExtraIssued.text = "0"
    
                    if trim(lblSubmitBy.text) = "" then
                        QtyToIR.text = "0"
                        QtyScrap.text = "0"
                    End if
    
    
                    if ucase(MainAlt.text) = "ALT." then e.Item.CssClass = "IssuingListAltPart"
                    if ucase(MainAlt.text) = "MAIN" then e.Item.CssClass = "IssuingListMainPart"
                End if
            End Sub
    
            Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
            End Sub
    
            Sub cmdBack_Click(sender As Object, e As EventArgs)
                response.redirect("MRF.aspx")
            End Sub
    
            Sub ShowMRFDet()
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
                lblJONo.text = ""
                Dim RsSO as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 * from MRF_M where Seq_No = " & request.params("ID") & ";")
                Do while rsSo.read
                    lblmrfNo.text = rsSO("MRF_NO").tostring
                    lblJONo.text = rsSO("JO_No").tostring
                    lblSection.text = rsSO("P_Level")
    
                    if isdbnull(rsSO("Submit_Date")) = false then
                        lblSubmitBy.text = rsSO("Submit_By").tostring
                        lblSubmitDate.text = format(cdate(rsSO("Submit_Date")),"dd/MM/yy (hh:mm:ss)")
                    elseif isdbnull(rsSO("Submit_Date")) = true then
                        lblSubmitBy.text = ""
                        lblSubmitDate.text = ""
                    end if
    
                    if isdbnull(rsSO("App1_Date")) = false then
                        lblApp1Date.text = format(cdate(rsSO("App1_Date")),"dd/MM/yy (hh:mm:ss)")
                        lblApp1By.text = rsSO("App1_By")
                    elseif isdbnull(rsSO("App1_Date")) = true then
                        lblApp1by.text = ""
                        lblApp1Date.text = ""
                    end if
    
                    if isdbnull(rsSO("App2_Date")) = false then
                        lblApp2Date.text = format(cdate(rsSO("App2_Date")),"dd/MM/yy (hh:mm:ss)")
                        lblApp2By.text = rsSO("App2_By")
                    elseif isdbnull(rsSO("App2_Date")) = true then
                        lblApp2by.text = ""
                        lblApp2Date.text = ""
                    end if
    
                    if isdbnull(rsSO("App3_Date")) = false then
                        lblApp3Date.text = format(cdate(rsSO("App3_Date")),"dd/MM/yy (hh:mm:ss)")
                        lblApp3By.text = rsSO("App1_By")
                    elseif isdbnull(rsSO("App3_Date")) = true then
                        lblApp3by.text = ""
                        lblApp3Date.text = ""
                    end if
    
                    if isdbnull(rsSO("App4_Date")) = false then
                        lblApp4Date.text = format(cdate(rsSO("App4_Date")),"dd/MM/yy (hh:mm:ss)")
                        lblApp4By.text = rsSO("App4_By")
                    elseif isdbnull(rsSO("App4_Date")) = true then
                        lblApp4by.text = ""
                        lblApp4Date.text = ""
                    end if
                    if trim(lblSubmitDate.text) <> "" then
                        cmdApproved.enabled = false
                    elseif trim(lblSubmitDate.text) = "" then
                        cmdApproved.enabled = true
                    end if
                Loop
                RsSO.Close
                lblModelNo.text = ReqCOM.GetFieldVal("Select Model_No from SO_MODELS_M where lot_no in (select lot_NO from job_order_m where jo_no = '" & trim(lblJONo.text) & "')","Model_No")
                lblModelDesc.text = ReqCOM.GetFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
                lblRevision.text = ReqCOM.GetFieldVal("Select top 1 revision from bom_m where model_no = '" & trim(lblModelNo.text) & "' order by revision desc","Revision")
            End sub
    
            Sub ShowAlert(Msg as string)
                Dim strScript as string
                strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
                If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
            End sub
    
             Sub lnkMRFItem_Click(sender As Object, e As EventArgs)
                 ShowPopup("PopupMRFItem.aspx?ID=" & Request.params("ID"))
             End Sub
    
             Sub ShowPopup(ReturnURL as string)
                 Dim Script As New System.Text.StringBuilder
                 Script.Append("<script language=javascript>")
                 Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
                 Script.Append("</script" & ">")
                 RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
             End sub
    
    Sub ValReturnQty_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim QtyToStore,QtyToIR,QtyScrap,QtyOtherScrap As textbox
        Dim TotalIssued,ExtraReq As Label
        Dim IssuedQty,ReturnQty as long
        Dim i as integer
    
        For i = 0 To dtgShortage.Items.Count - 1
            QtyToStore = CType(dtgShortage.Items(i).FindControl("QtyToStore"), textbox)
            QtyToIR = CType(dtgShortage.Items(i).FindControl("QtyToIR"), textbox)
            QtyScrap = CType(dtgShortage.Items(i).FindControl("QtyScrap"), textbox)
            QtyOtherScrap = CType(dtgShortage.Items(i).FindControl("QtyOtherScrap"), textbox)
            TotalIssued = CType(dtgShortage.Items(i).FindControl("TotalIssued"), Label)
            ExtraReq = CType(dtgShortage.Items(i).FindControl("ExtraReq"), Label)
    
            if trim(QtyToStore.text) = "" then ValReturnQty.text = "You don seem to have supplied a valid Good Qty.":e.isvalid = false:Exit sub
            if trim(QtyToIR.text) = "" then ValReturnQty.text = "You don seem to have supplied a valid IR Qty.":e.isvalid = false:Exit sub
            if trim(QtyScrap.text) = "" then ValReturnQty.text = "You don seem to have supplied a valid Scrap Qty.":e.isvalid = false:Exit sub
            if trim(QtyOtherScrap.text) = "" then ValReturnQty.text = "You don seem to have supplied a valid Other Scrap Qty.":e.isvalid = false:Exit sub
    
            if isnumeric(QtyToStore.text) = false then ValReturnQty.text = "You don seem to have supplied a valid Good Qty.":e.isvalid = false:Exit sub
            if isnumeric(QtyToIR.text) = false then ValReturnQty.text = "You don seem to have supplied a valid IR Qty.":e.isvalid = false:Exit sub
            if isnumeric(QtyScrap.text) = false then ValReturnQty.text = "You don seem to have supplied a valid Scrap Qty.":e.isvalid = false:Exit sub
            if isnumeric(QtyOtherScrap.text) = false then ValReturnQty.text = "You don seem to have supplied a valid Other Scrap Qty.":e.isvalid = false:Exit sub
    
            IssuedQty = clng(TotalIssued.text) + clng(ExtraReq.text)
            ReturnQty = clng(QtyToStore.text) + clng(QtyToIR.text) + clng(QtyScrap.text) + clng(QtyOtherScrap.text)
    
            if clng(ReturnQty) > clng(IssuedQty) then
                ValReturnQty.text = "Total Return Qty. not match with Issued Qty."
                e.isvalid = false
                exit sub
            End if
        next i
    End Sub
    
    Sub cmdApproved_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim i as integer
            Dim QtyToStore,QtyToIR,QtyScrap,QtyOtherScrap As textbox
            Dim SeqNo As Label
            Dim ReturnQty as long
    
            For i = 0 To dtgShortage.Items.Count - 1
                SeqNo = CType(dtgShortage.Items(i).FindControl("SeqNo"), Label)
                QtyToStore = CType(dtgShortage.Items(i).FindControl("QtyToStore"), textbox)
                QtyToIR = CType(dtgShortage.Items(i).FindControl("QtyToIR"), textbox)
                QtyScrap = CType(dtgShortage.Items(i).FindControl("QtyScrap"), textbox)
                QtyOtherScrap = CType(dtgShortage.Items(i).FindControl("QtyOtherScrap"), textbox)
                ReturnQty = clng(QtyToStore.text) + clng(QtyToIR.text) + clng(QtyScrap.text) + clng(QtyOtherScrap.text)
                ReqCOM.ExecuteNonQuery("Update MRF_D set Qty_Return = " & clng(ReturnQty) & ", Qty_Scrap = " & clng(QtyScrap.text) & ",Qty_Store = " & clng(QtyToStore.text) & ", Qty_IR = " & clng(QtyToIR.text) & ", Qty_Other_Scrap = " & clng(QtyOtherScrap.text) & " where seq_no = " & clng(SeqNo.text) & ";")
            Next i
            ReqCOM.ExecuteNonQuery("delete from mrf_d where qty_ir = 0 and qty_store = 0 and qty_scrap = 0 and extra_req = 0 and MRF_No = '" & trim(lblMRFNo.text) & "';")
            ReqCOM.ExecuteNonQuery("Update MRF_M set Submit_By = '" & trim(request.cookies("U_ID").value) & "',Submit_Date = '" & now & "',MRF_Status = 'PENDING APPROVAL' where MRF_No = '" & trim(lblMRFNo.text) & "';")
            ShowAlert("Selected MRF has been submitted.")
            redirectPage("MRFDet.aspx?ID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub Calculate(sender as Object,e as DataGridCommandEventArgs)
        Dim ExtraIssued As Label = CType(e.Item.FindControl("ExtraIssued"), Label)
        Dim QtyToStore As Textbox = CType(e.Item.FindControl("QtyToStore"), Textbox)
        Dim QtyToIR As Textbox = CType(e.Item.FindControl("QtyToIR"), Textbox)
        Dim QtyScrap As Textbox = CType(e.Item.FindControl("QtyScrap"), Textbox)
        Dim QtyOtherScrap As Textbox = CType(e.Item.FindControl("QtyOtherScrap"), Textbox)
    
        QtyToStore.text = clng(ExtraIssued.text) - clng(QtyToIR.text) - clng(QtyScrap.text) - clng(QtyOtherScrap.text)
    End sub
    
    Sub cmdPrint_Click(sender As Object, e As EventArgs)
        ShowReport("PopupReportViewer.aspx?RptName=MRF&ID=" & request.params("ID"))
        redirectPage("MRFDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
       'Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
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
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">MRF DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="ValReturnQty" runat="server" Width="100%" CssClass="ErrorText" ErrorMessage="Total return qty. not match." Display="Dynamic" ForeColor=" " OnServerValidate="ValReturnQty_ServerValidate"></asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <asp:Label id="lblStatus" runat="server" width="344px" visible="False">Label</asp:Label>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 70%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="70%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" cssclass="LabelNormal" width="126px">MRF NO</asp:Label></td>
                                                            <td width="75%">
                                                                <asp:Label id="lblMRFNo" runat="server" cssclass="OutputText" width="126px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label1" runat="server" cssclass="LabelNormal" width="126px">Job Order
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblJONo" runat="server" cssclass="OutputText" width="126px"></asp:Label>&nbsp;&nbsp;&nbsp; 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="126px">Section</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSection" runat="server" cssclass="OutputText" width="126px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">Model No
                                                                / Desc</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                                /&nbsp; <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label><asp:Label id="lblRevision" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="1">
                                                                <asp:Label id="Label10" runat="server" cssclass="LabelNormal">Submit By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="126px">Approved
                                                                By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="126px">PCMC By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="126px">IQC by/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="126px">Store By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" OnEditCommand="Calculate" Height="35px" Font-Names="Verdana" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="MAIN PART">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> <asp:Label id="MainAlt" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Main_Alt") %>' /> <asp:Label id="MainPart" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART") %>' cssclass="OutputText" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PART Issued / Description">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' /> - <asp:Label id="PartDesc" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Total Usage">
                                                                <ItemTemplate>
                                                                    <asp:Label id="TotalUSage" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Total_Usage") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Total Issued">
                                                                <ItemTemplate>
                                                                    <asp:Label id="TotalIssued" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Total_Issued") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Xtra Req.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ExtraReq" runat="server" cssclass="outputText" text='<%# DataBinder.Eval(Container.DataItem, "Extra_Req") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Xtra Issued">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ExtraIssued" runat="server" cssclass="outputText" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Total Return">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyReturn" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Return") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Good">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="QtyToStore" runat="server" columns="4" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Store") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="IR">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="QtyToIR" runat="server" columns="4" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Qty_IR") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Scrap">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="QtyScrap" runat="server" columns="4" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Scrap") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Others">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="QtyOtherScrap" runat="server" columns="4" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Other_Scrap") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Type" runat="server" columns="4" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Type") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:EditCommandColumn ButtonType="PushButton" UpdateText="" CancelText="" EditText="Calculate"></asp:EditCommandColumn>
                                                            <asp:TemplateColumn HeaderText="Reissue">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="Reissue" runat="server" columns="4" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "QTY_REISSUE") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Location">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="PLocation" TextMode="MultiLine" runat="server" columns="50" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "P_Location") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#0000c0">
                                                                </td>
                                                                <td>
                                                                    &nbsp;&nbsp; <asp:Label id="Label4" runat="server" cssclass="OutputText">Main Part</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="10%" bgcolor="red">
                                                                </td>
                                                                <td>
                                                                    &nbsp;&nbsp; <asp:Label id="Label12" runat="server" cssclass="OutputText">Alternate
                                                                    Part</asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="left">
                                                                        <asp:Button id="cmdApproved" onclick="cmdApproved_Click" runat="server" Width="153px" Text="Submit"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdPrint" onclick="cmdPrint_Click" runat="server" Width="153px" Text="Print"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="181px" Text="Back"></asp:Button>
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
