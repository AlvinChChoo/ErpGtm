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
                    Dim oList As ListItemCollection = cmbType.Items
                    oList.Add(New ListItem(""))
    
                    oList = cmbSpecial.Items
                    oList.Add(New ListItem(""))
    
    
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
                  Dim StrSql as string = "Select iss.seq_no,iss.extra_req,iss.total_usage,iss.total_issued,iss.main_part,iss.qty_Req,ISS.Part_No,ISS.Qty_Issued,PM.Part_Desc from MERF_D ISS,Part_Master PM where ISS.MERF_NO = '" & trim(lblMRFNo.text) & "' and ISS.PART_No = PM.Part_No"
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
                  response.redirect("MERFApp2.aspx")
              End Sub
    
            Sub ShowMRFDet()
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
                lblJONo.text = ""
    
    
                Dim RsSO as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 * from MERF_M where Seq_No = " & request.params("ID") & ";")
                Do while rsSo.read
                    lblmrfNo.text = rsSO("MERF_NO").tostring
                    lblJONo.text = rsSO("JO_No").tostring
                    lblSection.text = rsSO("P_Level")
                    txtSubmitRem.text = trim(rsSO("Submit_Rem").tostring)
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
                        lblApp3By.text = rsSO("App1_By")
                    elseif isdbnull(rsSO("App3_Date")) = true then
                        lblApp3by.text = ""
                        lblApp3Date.text = ""
                    end if
    
                    if trim(lblApp2Date.text) = "" then
                        lblRem.visible = true
                        txtRem.visible = true
                        rbApprove.visible = true
                        rbReject.visible = true
                        cmdApproved.visible = true
                    elseif trim(lblApp2Date.text) <> "" then
                        lblRem.visible = false
                        txtRem.visible = false
                        rbApprove.visible = false
                        rbReject.visible = false
                        cmdApproved.visible = false
                    end if
    
                    if isdbnull(rsSO("Type")) = false then
                        cmbType.items.FindByValue(trim(rsSO("Type"))).selected = true
                    elseif isdbnull(rsSO("Type")) = true then
                        cmbType.items.FindByValue("").selected = true
                    End if
    
                    if isdbnull(rsSO("Special")) = false then
                        cmbSpecial.items.FindByValue(trim(rsSO("Special"))).selected = true
                    elseif isdbnull(rsSO("Special")) = true then
                        cmbSpecial.items.FindByValue("").selected = true
                    End if
    
    
    
    
    
    
    
                    'if trim(ucase(FECNEffectTemp.text)) = "EXTRA" then FECNEffect.items.FindByValue("EXTRA").selected = true
    
                Loop
                RsSO.Close
            End sub
    
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
    
    Sub cmdApproved_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
            if rbApprove.checked = true then
                ReqCOM.ExecuteNonQuery("Update MERF_M set App2_By = '" & trim(request.cookies("U_ID").value) & "',App2_Date = '" & now & "',App2_Status = 'Y',App2_Rem = '" & replace(trim(txtRem.text),"'","`") & "',Type = '" & trim(cmbType.selecteditem.value) & "', Special = '" & trim(cmbSpecial.selecteditem.value) & "' where MERF_NO = '" & trim(lblMRFNo.text) & "'")
            elseif rbReject.checked = true then
                ReqCOM.ExecuteNonQuery("Update MERF_M set App2_By = '" & trim(request.cookies("U_ID").value) & "',App2_Date = '" & now & "',App2_Status = 'N',App2_Rem = '" & replace(trim(txtRem.text),"'","`") & "',MERF_Status = 'REJECTED',Type = '" & trim(cmbType.selecteditem.value) & "', Special = '" & trim(cmbSpecial.selecteditem.value) & "' where MERF_NO = '" & trim(lblMRFNo.text) & "'")
            end if
    
            ShowAlert("Selected MERF has been submitted.")
            redirectPage("MERFApp2Det.aspx?ID=" & Request.params("ID"))
        End if
    End Sub
    
    Sub ValInput_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        if rbReject.checked = true then
            if txtRem.text = "" then e.isvalid = false
        end if
    End Sub

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
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">MATERIAL EXTRA
                                REQUEST FORM (MERF) DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:CustomValidator id="ValInput" runat="server" EnableClientScript="False" Width="100%" CssClass="ErrorText" ErrorMessage="You don't seem to have supplied a valid remarks" Display="Dynamic" ForeColor=" " OnServerValidate="ValInput_ServerValidate"></asp:CustomValidator>
                                                </p>
                                                <p>
                                                    <asp:Label id="lblStatus" runat="server" width="344px" visible="False">Label</asp:Label>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
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
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">Type</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbType" runat="server" Width="232px" CssClass="OutputText">
                                                                    <asp:ListItem Value="SPECIAL">SPECIAL</asp:ListItem>
                                                                    <asp:ListItem Value="REPLACEMENT">REPLACEMENT</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="126px">Special</asp:Label></td>
                                                            <td>
                                                                <asp:DropDownList id="cmbSpecial" runat="server" Width="232px" CssClass="OutputText">
                                                                    <asp:ListItem Value="AUTO">AUTO</asp:ListItem>
                                                                    <asp:ListItem Value="FINAL">FINAL</asp:ListItem>
                                                                    <asp:ListItem Value="MI">MI</asp:ListItem>
                                                                    <asp:ListItem Value="FECN">FECN</asp:ListItem>
                                                                    <asp:ListItem Value="SAMPLE">SAMPLE</asp:ListItem>
                                                                    <asp:ListItem Value="OTHERS">OTHERS</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="126px">Submit
                                                                By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox id="txtSubmitRem" runat="server" Width="499px" CssClass="OutputText" Height="63px" ReadOnly="True" TextMode="MultiLine"></asp:TextBox>
                                                            </td>
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
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="126px">Store By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <asp:DataGrid id="dtgShortage" runat="server" width="100%" Height="35px" Font-Names="Verdana" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" Font-Size="XX-Small" AutoGenerateColumns="False" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn visible= "false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MAIN PART">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MainPart" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MAIN_PART") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PART NO">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Total Usage">
                                                                <ItemTemplate>
                                                                    <asp:Label id="TotalUSage" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Total_Usage") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Qty Issued">
                                                                <ItemTemplate>
                                                                    <asp:Label id="TotalIssued" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Total_Issued") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Total Xtra Req.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ExtraReq" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Extra_Req") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Xtra Req.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyReq" cssclass="OutputText" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Req") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Label id="lblRem" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                                                                <td width="55%">
                                                                    <asp:TextBox id="txtRem" runat="server" Width="100%" CssClass="OutputText" Height="56px"></asp:TextBox>
                                                                </td>
                                                                <td width="20%">
                                                                    <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:RadioButton id="rbApprove" runat="server" CssClass="OutputText" Text="Approve" GroupName="Status"></asp:RadioButton>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <asp:RadioButton id="rbReject" runat="server" CssClass="OutputText" Text="Reject" GroupName="Status"></asp:RadioButton>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
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
