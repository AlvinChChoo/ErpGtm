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
                    Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                    Dim rsRequest as SQLDataReader = ReqCOM.ExeDataReader("Select * from Issuing_M where seq_no = " & request.params("ID") & ";")
    
                    do while rsRequest.read
                        lblRequestNo.text = rsRequest("Issuing_No").tostring
                        lblLevel.text = rsRequest("P_LEVEL").tostring
                        lblLotNo.text = rsRequest("Lot_No").tostring
                        lblReqLotSize.text = rsRequest("LOT_SIZE").tostring
    
                        lblApp2By.text = rsRequest("App2_By").tostring
                        if isdbnull(rsRequest("App2_By")) = false then lblApp2Date.text = format(cdate(rsRequest("App2_Date")),"dd/MMM/yy")
                        lblApp1By.text = rsRequest("App1_By").tostring
                        lblApp1Date.text = format(cdate(rsRequest("App1_Date")),"dd/MMM/yy")
                    Loop
    
                Dim rsSO as SQLDataReader = ReqCOM.ExeDataReader("Select * from SO_Model_M where Lot_No = '" & trim(lbllotNo.text) & "';")
                Do while rsSo.read
                    lblModelNo.text = rsSO("Model_No").tostring
                    lblLotSize.text = rsSO("Order_Qty").tostring
                    lblBOMRev.text = rsSO("BOM_Rev").tostring
                    lblQtyAllowed.text = cint(rsSO("Order_Qty")) - cint(rsSO("Open_Qty"))
                    'lblBOMDate.text = rsSO("BOM_Date").tostring
                Loop
    
                RsSO.Close()
                rsRequest.close()
                procLoadGridData()
                end if
            End Sub
    
         Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
         End Sub
    
         Sub ProcLoadGridData()
             Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
             Dim StrSql as string = "Select pm.part_spec,pm.m_part_no,req.part_no,req.req_qty,pm.part_desc from Issuing_D req, part_master pm where req.part_no = pm.part_no and req.Issuing_No = '" & trim(lblRequestNo.text) & "';"
             Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"Issuing_D")
    
             dtgPartList.visible = true
             dtgPartList.DataSource=resExePagedDataSet.Tables("Issuing_D").DefaultView
             dtgPartList.DataBind()
         end sub
    
         Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
    
         End Sub
    
         Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            Dim ReqCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.ERp_Gtm
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                Dim BalQty As Label = CType(e.Item.FindControl("BalQty"), Label)
                Dim ReqQty As Label = CType(e.Item.FindControl("ReqQty"), Label)
                Dim PartNo As Label = CType(e.Item.FindControl("PartNo"), Label)
                Dim Iss As Textbox = CType(e.Item.FindControl("Iss"), Textbox)
    
                BalQty.text = Cint(ReqCOM.GetFieldVal("select sum(Bal_Qty) as [Bal_Qty] from part_master where part_no = '" & trim(PartNo.text) & "';","Bal_Qty"))
                'if cmdSubmit.visible = false then
                '    Iss.enabled = false
                'End if
            End if
         End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("LotMaterialRequestHOD.aspx")
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
    
    Sub cmdApprove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCom.executeNonQuery("Update Issuing_M set App2_By = '" & trim(request.cookies("U_ID").value) & "',App2_Date= '" & now & "' where Issuing_No = '" & trim(lblRequestNo.text) & "';")
        ShowAlert("Selected MIF has been approved")
        redirectPage("LotMaterialRequestPCMCDet.aspx?ID=" & Request.params("ID"))
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
    
    Sub cmdReject_Click(sender As Object, e As EventArgs)
        Response.redirect("LotMaterialRequestRej.aspx?" & request.params("ID"))
    End Sub

</script>
<! Customer.aspx ><html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
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
                                <asp:Label id="Label3" runat="server" width="100%" cssclass="FormDesc">NEW LOT MATERIAL
                                REQUEST REGISTRATION</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="80%" align="center" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label9" runat="server" width="126px" cssclass="LabelNormal">Request
                                                                No</asp:Label></td>
                                                            <td width="70%">
                                                                <asp:Label id="lblRequestNo" runat="server" width="223px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label1" runat="server" width="126px" cssclass="LabelNormal">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" width="223px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" width="126px" cssclass="LabelNormal">Level</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLevel" runat="server" width="223px" cssclass="OutputText"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp; 
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" width="126px" cssclass="LabelNormal">Model No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" width="126px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="126px" cssclass="LabelNormal">Lot Size</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotSize" runat="server" width="126px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" width="126px" cssclass="LabelNormal">Qty Allowed</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblQtyAllowed" runat="server" width="126px" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label10" runat="server" width="126px" cssclass="LabelNormal">Req. Lot
                                                                Size</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblReqLotSize" runat="server" cssclass="OutputText"></asp:Label><asp:Label id="lblBOMRev" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label12" runat="server" width="139px" cssclass="LabelNormal">Store
                                                                By / Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp1By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label13" runat="server" cssclass="LabelNormal">Production App By /
                                                                Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp2By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p align="center">
                                                </p>
                                                <p>
                                                    <asp:DataGrid id="dtgPartList" runat="server" width="100%" BorderColor="Black" GridLines="Vertical" cellpadding="4" Font-Name="Verdana" AutoGenerateColumns="False" Font-Names="Verdana" Font-Size="XX-Small" OnSortCommand="SortGrid" AllowSorting="True" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PageSize="100" Height="35px">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Part No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="PART_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="Part_Spec" HeaderText="Specification"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="M_Part_No" HeaderText="Mfg. Part No."></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Bal Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="BalQty" runat="server" text='' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Req Qty.">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="ReqQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Qty") %>' /> 
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
                                                                    <asp:Button id="cmdApprove" onclick="cmdApprove_Click" runat="server" Text="Approve" Width="113px"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdReject" onclick="cmdReject_Click" runat="server" Text="Reject" Width="113px"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="113px" CausesValidation="False"></asp:Button>
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
