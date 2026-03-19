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
                    ShowModelDet
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
    
                  Dim StrSql as string = "Select iss.qty_reissue,iss.Qty_Other_Scrap,iss.seq_no,iss.qty_scrap,iss.qty_store,iss.qty_ir,iss.return_type,iss.rem,iss.qty_return,ISS.Part_No,ISS.Qty_Issued,PM.Part_Desc from MRF_D ISS,Part_Master PM where ISS.MRF_NO = '" & trim(lblMRFNo.text) & "' and ISS.PART_No = PM.Part_No"
    
    
                  Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"Issuing_D")
                  dtgShortage.DataSource=resExePagedDataSet.Tables("Issuing_D").DefaultView
                  dtgShortage.DataBind()
              end sub
    
            Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
                If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
    
    
                End if
            End Sub
    
              Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
              End Sub
    
              Sub cmdBack_Click(sender As Object, e As EventArgs)
                  response.redirect("MRFApp3.aspx")
              End Sub
    
            Sub ShowMRFDet()
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
                lblJONo.text = ""
    
                Dim RsSO as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 * from MRF_M where Seq_No = " & request.params("ID") & ";")
                Do while rsSo.read
                    lblmrfNo.text = rsSO("MRF_NO").tostring
                    lblJONo.text = rsSO("JO_NO").tostring
    
                    if isdbnull(rsSO("Submit_Date")) = false then
                        lblSubmitBy.text = rsSO("Submit_By").tostring
                        lblSubmitDate.text = format(cdate(rsSO("Submit_Date")),"dd/MMM/yy")
                    elseif isdbnull(rsSO("Submit_Date")) = true then
                        lblSubmitBy.text = ""
                        lblSubmitDate.text = ""
                    end if
    
                    if isdbnull(rsSO("App1_Date")) = false then
                        lblApp1Date.text = format(cdate(rsSO("App1_Date")),"dd/MMM/yy")
                        lblApp1By.text = rsSO("App1_By")
                    elseif isdbnull(rsSO("App1_Date")) = true then
                        lblApp1by.text = ""
                        lblApp1Date.text = ""
                    end if
    
                    if isdbnull(rsSO("App2_Date")) = false then
                        lblApp2Date.text = format(cdate(rsSO("App2_Date")),"dd/MMM/yy")
                        lblApp2By.text = rsSO("App2_By")
                    elseif isdbnull(rsSO("App2_Date")) = true then
                        lblApp2by.text = ""
                        lblApp2Date.text = ""
                    end if
    
                    if isdbnull(rsSO("App3_Date")) = false then
                        lblApp3Date.text = format(cdate(rsSO("App3_Date")),"dd/MMM/yy")
                        lblApp3By.text = rsSO("App3_By")
                    elseif isdbnull(rsSO("App3_Date")) = true then
                        lblApp3by.text = ""
                        lblApp3Date.text = ""
                    end if
    
                    if isdbnull(rsSO("App4_Date")) = false then
                        lblApp4Date.text = format(cdate(rsSO("App4_Date")),"dd/MMM/yy")
                        lblApp4By.text = rsSO("App4_By")
                    elseif isdbnull(rsSO("App4_Date")) = true then
                        lblApp4by.text = ""
                        lblApp4Date.text = ""
                    end if
    
                    if trim(lblApp3Date.text) <> "" then
                        cmdApproved.enabled = false
                    elseif trim(lblApp3Date.text) = "" then
                        cmdApproved.enabled = true
                    end if
                Loop
                RsSO.Close
            End sub
    
            Sub ShowModelDet()
                'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
    
                'Dim RsSO as SQLDataReader = ReqCOM.ExeDataReader("Select * from SO_Model_M where Lot_No = '" & trim(lblLotNo.text) & "';")
                'Do while rsSo.read
                '    lblModelNo.text = rsSO("Model_No").tostring
                '    lblLotSize.text = rsSO("Order_Qty").tostring
                '    lblModelDesc.text = ReqCom.getFieldVal("Select Model_Desc from Model_Master where Model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")
                'Loop
                'RsSO.Close
            End sub
    
            Sub cmbLevel_SelectedIndexChanged(sender As Object, e As EventArgs)
            End Sub
    
            Sub cmdApproved_Click(sender As Object, e As EventArgs)
                if page.isvalid = true then
                    Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
                    Dim i As Integer
                    Dim SeqNo,QtyReturn as label
                    Dim QtyToStore,QtyToIr,QtyScrap,QtyOtherScrap as textbox
    
                    For i = 0 To dtgShortage.Items.Count - 1
                        SeqNo = CType(dtgShortage.Items(i).FindControl("SeqNo"), Label)
                        QtyToStore = CType(dtgShortage.Items(i).FindControl("QtyToStore"), textbox)
                        QtyToIr = CType(dtgShortage.Items(i).FindControl("QtyToIr"), textbox)
                        QtyScrap = CType(dtgShortage.Items(i).FindControl("QtyScrap"), textbox)
                        QtyReturn = CType(dtgShortage.Items(i).FindControl("QtyReturn"), Label)
                        QtyOtherScrap = CType(dtgShortage.Items(i).FindControl("QtyOtherScrap"), textbox)
    
                        if QtyToIR.text = "" then QtyToIR.text = 0
                        if QtyScrap.text = "" then QtyScrap.text = 0
                        if QtyReturn.text = "" then QtyReturn.text = 0
                        if QtyToStore.text = "" then QtyToStore.text = 0
                        if QtyOtherScrap.text = "" then QtyOtherScrap.text = 0
    
                        ReqCOM.ExecuteNonQuery("Update MRF_D set Qty_Store = " & QtyToStore.text & ", Qty_IR = " & QtyToIR.text & ", Qty_Scrap = " & QtyScrap.text & ",Qty_Other_Scrap = " & clng(QtyOtherScrap.text) & " where seq_no = " & SeqNo.text & ";")
                    next
    
                    ReqCOM.ExecuteNonQuery("Update MRF_M set App3_By = '" & trim(request.cookies("U_ID").value) & "',App3_Date = '" & now & "',App3_Status = 'Y' where MRF_NO = '" & trim(lblMRFNo.text) & "'")
                    ShowAlert("Selected MRF has been submitted.")
                    redirectPage("MRFApp3Det.aspx?ID=" & Request.params("ID"))
                End if
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
    
            Sub ShowPopup(ReturnURL as string)
                Dim Script As New System.Text.StringBuilder
                Script.Append("<script language=javascript>")
                Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
                Script.Append("</script" & ">")
                RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
            End sub
    
            Sub ValInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
                Dim i As Integer
                Dim SeqNo,QtyReturn as label
                Dim QtyToStore,QtyToIr,QtyScrap,QtyOtherScrap as textbox
    
                For i = 0 To dtgShortage.Items.Count - 1
                    SeqNo = CType(dtgShortage.Items(i).FindControl("SeqNo"), Label)
                    QtyToStore = CType(dtgShortage.Items(i).FindControl("QtyToStore"), textbox)
                    QtyToIr = CType(dtgShortage.Items(i).FindControl("QtyToIr"), textbox)
                    QtyScrap = CType(dtgShortage.Items(i).FindControl("QtyScrap"), textbox)
                    QtyReturn = CType(dtgShortage.Items(i).FindControl("QtyReturn"), Label)
                    QtyOtherScrap = CType(dtgShortage.Items(i).FindControl("QtyOtherScrap"), textbox)
    
                    if QtyToIR.text = "" then QtyToIR.text = 0
                    if QtyScrap.text = "" then QtyScrap.text = 0
                    if QtyReturn.text = "" then QtyReturn.text = 0
                    if QtyToStore.text = "" then QtyToStore.text = 0
                    if QtyOtherScrap.text = "" then QtyOtherScrap.text = 0
    
                    if clng(QtyToIR.text) + clng(QtyScrap.text) + clng(QtyToStore.text) + clng(QtyOtherScrap.text) <> clng(QtyReturn.text) then e.isvalid = false
                next
            End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">MRF DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="ValInput" runat="server" ErrorMessage="Good, IR and PR Qty not tally with return Qty." Display="Dynamic" ForeColor=" " EnableClientScript="False" OnServerValidate="ValInput_ServerValidate" CssClass="ErrorText" Width="100%"></asp:CustomValidator>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" width="126px" cssclass="LabelNormal">MRF NO</asp:Label></td>
                                                            <td width="75%">
                                                                <asp:Label id="lblMRFNo" runat="server" width="126px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label1" runat="server" width="126px" cssclass="LabelNormal">Job Order
                                                                No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblJONo" runat="server" width="126px" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp; 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label10" runat="server" width="126px" cssclass="LabelNormal">Submit
                                                                By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" width="126px" cssclass="LabelNormal">Approved
                                                                By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" width="126px" cssclass="LabelNormal">PCMC By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" width="126px" cssclass="LabelNormal">IQC by/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label8" runat="server" width="126px" cssclass="LabelNormal">Store By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" AutoGenerateColumns="False" Font-Size="XX-Small" Font-Name="Verdana" cellpadding="4" GridLines="Vertical" BorderColor="Black" Font-Names="Verdana" Height="35px">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="PART NO">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' /> <asp:Label id="SeqNo" runat="server" visible="false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Qty Return">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyReturn" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Return") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Good">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyToStore" css="css" class="outputtext" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Store") %>' width="48px" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="IR">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyToIR" css="css" class="outputtext" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_IR") %>' width="48px" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Scrap">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyScrap" css="css" class="outputtext" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Scrap") %>' width="48px" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Others">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyOtherScrap" runat="server" columns="8" cssclass="OutputText" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Other_Scrap") %>' width="48px" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="ReIssue">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyReissue" runat="server" columns="8" cssclass="OutputText" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Reissue") %>' width="48px" /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
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
