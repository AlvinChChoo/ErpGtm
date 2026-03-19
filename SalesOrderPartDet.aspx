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
        cmdSubmit.attributes.add("onClick","javascript:if(confirm('You will not be able to make any changes after the submission.\nAre you sure you want to submit this Sales Order ?')==false) return false;")
        cmdRemove.attributes.add("onClick","javascript:if(confirm('Are you sure you want to remove this Sales Order ?')==false) return false;")
        if page.ispostback = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            loaddata
            ProcLoadGridData
            if GridControl1.items.count = 0 then lblPart.visible = true: GridControl1.visible = false else lblPart.visible = false: GridControl1.visible = true
            if GridControl1.items.count > 0 then lblTotal.text = "Total  :  " & format(cdec(ReqCOM.GetFieldVal("Select Sum(Invoice_Total) as [SubTotal] from SO_Part_D where lot_no = '" & trim(lblLotNo.text) & "';","SubTotal")),"##,##0.00")
        end if
    End Sub

    Sub Dissql(ByVal strSql As String,FValue as string,FText as string,Obj as Object)
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
        Dim oList As ListItemCollection = obj.Items
        oList.Add(New ListItem(""))
    End Sub

    Sub LoadData
        Dim strSql as string = "SELECT * FROM SO_PART_M WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)

        do while ResExeDataReader.read
            lblLotNo.text = ResExeDataReader("LOT_NO")
            lblSODate.text = format(ResExeDataReader("SO_DATE"),"dd/MM/yy")
            lblCustCode.text = ResExeDataReader("cust_code").tostring
            Dissql ("Select * from Cust_Ship where Cust_Code = '" & trim(lblCustCode.text) & "';","Ship_CO","Ship_CO",cmbShipCo)
            txtPONo.text = ResExeDataReader("PO_NO").tostring
            txtPODate.text = format(ResExeDataReader("PO_DATE"),"dd/MM/yy")
            lblBillAtt.text =  ResExeDataReader("BILL_ATT").tostring
            lblBillAdd1.text = ResExeDataReader("BILL_ADD1").tostring
            lblBillAdd2.text = ResExeDataReader("BILL_ADD2").tostring
            lblBillAdd3.text = ResExeDataReader("BILL_ADD3").tostring
            lblBillState.text  = ResExeDataReader("BILL_STATE").tostring
            lblBillCountry.text = ResExeDataReader("BILL_COUNTRY").tostring

            Dim CurrShipCo as string = ResExeDataReader("Ship_Co").tostring
            txtDelDate.text =  format(ResExeDataReader("Req_Date"),"dd/MM/yy")
            lblShipAtt.text =  ResExeDataReader("SHIP_ATT").tostring
            lblShipAdd1.text = ResExeDataReader("SHIP_ADD1").tostring
            lblShipAdd2.text = ResExeDataReader("SHIP_ADD2").tostring
            lblShipAdd3.text = ResExeDataReader("SHIP_ADD3").tostring
            lblShipCountry.text = ResExeDataReader("SHIP_COUNTRY").tostring
            lblShipState.text = ResExeDataReader("SHIP_STATE").tostring

            lblPCMCRem.text = ResExeDataReader("App2_Rem").tostring

            if ReqExeDataReader.FuncCheckDuplicate("Select * from Cust_Ship where Cust_Code = '" & trim(lblCustCode.text) & "' and Ship_CO = '" & trim(CurrShipCo) & "';","Ship_Co") = true then
                CurrShipCo = ReqExeDataReader.GetFieldVal("Select * from Cust_Ship where Cust_Code = '" & trim(lblCustCode.text) & "' and Ship_CO = '" & trim(CurrShipCo) & "';","Ship_Co")
                cmbShipCo.Items.FindByText(CurrShipCo.ToString).Selected = True
            else
                cmbShipCo.Items.FindByText("").Selected = True
            end if



            if isdbnull(ResExeDataReader("App2_By")) = false then
                lblPCMCBy.text = ResExeDataReader("App2_By").tostring
                lblPCMCDate.text = ResExeDataReader("App2_Date").tostring
            End if

            if trim(ReqExeDataReader.FuncCheckDuplicate("Select CSD_APP_By from SO_Part_M where lot_no = '" & trim(lblLotNo.text) & "';","CSD_APP_By")) = true then
                cmbUpdate.enabled = false
                cmdSubmit.enabled = false
                cmdRemove.enabled = false
                lnkPart.visible = false
            End if

            if isdbnull(ResExeDataReader("CSD_App_DATE")) = false then
                lblCSDAppBy.text = ResExeDataReader("CSD_App_BY").tostring
                lblCSDAppDate.text = format(cdate(ResExeDataReader("CSD_App_DATE")),"dd/MM/yy")
            end if

            if isdbnull(ResExeDataReader("Create_by").tostring) = false then
                lblPreparedBy.text = ResExeDataReader("Create_by").tostring
                lblPreparedDate.text = format(cdate(ResExeDataReader("Create_Date")),"dd/MM/yy")
            End if

        loop
        ResExeDataReader.close()

        Dim RsCust as SQLDataReader = ReqExeDataReader.ExeDataReader("Select * from cust where Cust_Code = '" & trim(lblCustCode.text) & "'")
        Do while RsCust.read
            lblCustName.text = rsCust("Cust_Name").tostring
            lblPayTerm.text = rsCust("Pay_Term").tostring
            lblBillAtt.text = rsCust("Bill_Att").toString
            lblBillAdd1.text = rsCust("Bill_Add1").toString
            lblBillAdd2.text = rsCust("Bill_Add2").toString
            lblBillAdd3.text = rsCust("Bill_Add3").toString
            lblBillState.text = rsCust("Bill_State").toString
            lblBillCountry.text = rsCust("Bill_Country").toString
        loop
        RsCust.close()
    End sub

    Sub cmbUpdate_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim DMth,DYr,DDay,strsql,DateInput as string
            Dim ReqExecutenonQuery as Erp_Gtm.erp_gtm = new Erp_Gtm.Erp_Gtm

            strsql = "Update SO_PART_M set LOT_NO = '" & trim(lblLotno.text) & "',"
            strsql = strsql + "PO_NO = '" & trim(txtPONo.text) & "',"
            strsql = strsql + "Req_Date = '" & ReqExecutenonQuery.FormatDate(txtDelDate.text) & "',"
            strsql = strsql + "PO_Date = '" & ReqExecutenonQuery.FormatDate(txtPODate.text) & "',"
            strsql = strsql + "CUST_CODE = '" & trim(lblCustCode.text) & "',"
            strsql = strsql + "BILL_ATT = '" & trim(lblBillAtt.text) & "',"
            strsql = strsql + "BILL_ADD1 = '" & trim(lblBillAdd1.text) & "',"
            strsql = strsql + "BILL_ADD2 = '" & trim(lblBillAdd2.text) & "',"
            strsql = strsql + "BILL_ADD3 = '" & trim(lblBillAdd3.text) & "',"
            strsql = strsql + "BILL_STATE = '" & trim(lblBillState.text) & "',"
            strsql = strsql + "BILL_COUNTRY = '" & trim(lblBillCountry.text) & "',"
            strsql = strsql + "SHIP_CO = '" & trim(cmbShipCo.selectedItem.value) & "',"
            strsql = strsql + "SHIP_ATT = '" & trim(lblShipAtt.text) & "',"
            strsql = strsql + "SHIP_ADD1 = '" & trim(lblShipAdd1.text) & "',"
            strsql = strsql + "SHIP_ADD2 = '" & trim(lblShipAdd2.text) & "',"
            strsql = strsql + "SHIP_ADD3 = '" & trim(lblShipAdd3.text) & "',"
            strsql = strsql + "SHIP_STATE = '" & trim(lblShipState.text) & "',"
            strsql = strsql + "SHIP_COUNTRY = '" & trim(lblShipCountry.text) & "',"
            strsql = strsql + "PAY_TERM = '" & trim(lblPayTerm.text) & "',"
            strsql = strsql + "REM = '" & (txtREM.text) & "' "
            strsql = strsql + "where Lot_No = '" & trim(lbllotNo.text) & "'"

            reqExecuteNonQuery.ExecuteNonQuery(strsql)
            response.redirect("SalesOrderPartDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub

    Sub ProcLoadGridData()
        Dim strSql as string = "Select * from SO_Part_D where LOT_No = '" & trim(lblLOTNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"SO_PART_D")
        GridControl1.DataSource=resExePagedDataSet.Tables("SO_PART_D").DefaultView
        GridControl1.DataBind()
    end sub

    Sub cmdMain_Click(sender As Object, e As EventArgs)
        response.redirect("Main.aspx")
    End Sub

    Sub cmdList_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderPart.aspx")
    End Sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub cmbShipCo_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim RsShip as SQLDataReader = ReqCOM.ExeDataReader("Select * from Cust_Ship where Ship_Co = '" & trim(cmbShipCo.selectedItem.value) & "';")

        Do while RsShip.read
            lblShipAtt.text =  RsShip("SHIP_ATT").tostring
            lblShipAdd1.text = RsShip("SHIP_ADD1").tostring
            lblShipAdd2.text = RsShip("SHIP_ADD2").tostring
            lblShipAdd3.text = RsShip("SHIP_ADD3").tostring
            lblShipCountry.text = RsShip("SHIP_COUNTRY").tostring
            lblShipState.text = RsShip("SHIP_STATE").tostring
        Loop
    End Sub

    Sub cmdCancel_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderPart.aspx")
    End Sub

    Sub cmdApp_Click(sender As Object, e As EventArgs)
        Response.redirect("SalesOrderPartsPCMCApproval.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update SO_Part_M set CSD_App_by = '" & trim(request.cookies("U_ID").value) & "', CSD_App_Date = '" & now & "',pcmc_app_by=null,pcmc_app_date=null,pcmc_app_rem=null, pcmc_rej_by=null,pcmc_rej_date=null,pcmc_rej_rem=null where Lot_No = '" & trim(lblLotNo.text) & "';")
        Response.redirect("SalesOrderPartDet.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub lnkPart_Click(sender As Object, e As EventArgs)
        Dim resCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim CurrID as String = resCOM.getFieldVal("Select Seq_No from SO_Part_M where LOT_NO = '" & trim(lblLotNo.text) & "';","Seq_No")
        response.redirect("SalesOrderPartAddParts.aspx?ID=" + trim(CurrID))
    End Sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim PartQty As Label = CType(e.Item.FindControl("PartQty"), Label)
            Dim UP As Label = CType(e.Item.FindControl("UP"), Label)
            PartQty.text = clng(PartQty.text)
            UP.text = format(cdec(UP.text),"##,##0.00")
        End if
    End Sub

    Sub CustomVal1_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        if ReqCom.IsDate(txtPODate.text) = false then e.isvalid = false:CustomVal1.errormessage = "You don't seem to have supplied a valid P/O Date":exit sub
        if ReqCom.IsDate(txtDelDate.text) = false then e.isvalid = false:CustomVal1.errormessage = "You don't seem to have supplied a valid Del. Date":exit sub
    End Sub

    Sub cmdRemove_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Delete from SO_Part_M where Lot_No = '" & trim(lbllotNo.text) & "';")
        ReqCOM.ExecuteNonQuery("Delete from SO_Part_d where Lot_No = '" & trim(lbllotNo.text) & "';")
        Response.redirect("SalesOrderPart.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form id="SalesOrderPartDet" runat="server">
        <p>
            <table style="HEIGHT: 18px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <p>
                                <ERP:HEADER id="UserControl2" runat="server"></ERP:HEADER>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label1" runat="server" cssclass="FormDesc" width="100%">SALES ORDER
                                DETAILS (BY PART)</asp:Label>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="CustomVal1" runat="server" CssClass="ErrorText" Width="100%" ErrorMessage="You don't seem to have supplied a valid P/O date." Display="Dynamic" ForeColor=" " EnableClientScript="False" OnServerValidate="CustomVal1_ServerValidate"></asp:CustomValidator>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="133px">Issue Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSODate" runat="server" cssclass="OutputText" width="378px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="133px">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="378px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="133px">Cust. Code</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCustCode" runat="server" cssclass="OutputText" width="378px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label26" runat="server" cssclass="LabelNormal" width="133px">Cust.
                                                                Name</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCustName" runat="server" cssclass="OutputText" width="378px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="133px">Payment
                                                                Term</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPayTerm" runat="server" cssclass="OutputText" width="378px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label27" runat="server" cssclass="LabelNormal" width="133px">Del. Date</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtDelDate" runat="server" CssClass="OutputText" Width="198px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="100%">P / O Date
                                                                (dd/mm/yy)</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPODate" runat="server" CssClass="OutputText" Width="198px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="133px">P / O No</asp:Label></td>
                                                            <td>
                                                                <asp:TextBox id="txtPONo" runat="server" CssClass="OutputText" Width="198px"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label23" runat="server" cssclass="LabelNormal" width="134px">CSD Approval</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCSDAppBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCSDAppDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:TextBox id="txtRem" runat="server"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver" rowspan="2">
                                                                <asp:Label id="Label24" runat="server" cssclass="LabelNormal" width="154px">PCMC Approval</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPCMCBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblPCMCDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="1">
                                                                <asp:Label id="lblPCMCRem" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="center">
                                                                        PARTS
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblPart" runat="server" cssclass="ErrorText" width="100%">No part available
                                                                    for this sales order.</asp:Label>
                                                                    <asp:LinkButton id="lnkPart" onclick="lnkPart_Click" runat="server">Click here to add new / remove
part for this sales order.</asp:LinkButton>
                                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Border="Border" GridLines="Vertical" AutoGenerateColumns="False" CellPadding="2" OnItemDataBound="FormatRow">
                                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                        <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                        <Columns>
                                                                            <asp:BoundColumn DataField="PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="part_desc" HeaderText="Description"></asp:BoundColumn>
                                                                            <asp:BoundColumn DataField="part_spec" HeaderText="Specification"></asp:BoundColumn>
                                                                            <asp:TemplateColumn HeaderText="Quantity">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="PartQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_QTY") %>' />
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:TemplateColumn HeaderText="U/P">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                <ItemTemplate>
                                                                                    <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "INVOICE_UP") %>' />
                                                                                </ItemTemplate>
                                                                            </asp:TemplateColumn>
                                                                            <asp:BoundColumn DataField="INVOICE_TOTAL" HeaderText="TOTAL" DataFormatString="{0:F}">
                                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                            </asp:BoundColumn>
                                                                        </Columns>
                                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev"></PagerStyle>
                                                                    </asp:DataGrid>
                                                                    <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="100%">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <div align="right"><asp:Label id="lblTotal" runat="server" width="440px"></asp:Label>
                                                                                    </div>
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
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label31" runat="server" cssclass="LabelNormal" width="134px">Prepared
                                                                    by</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:Label id="lblPreparedBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblPreparedDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                </td>
                                                                <td>
                                                                    &nbsp;-
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                </td>
                                                                <td>
                                                                    &nbsp;-
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 21px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <p>
                                                                        <asp:Button id="cmbUpdate" onclick="cmbUpdate_Click" runat="server" Width="90%" Text="Update Changes"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="25%">
                                                                    <p align="center">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="90%" Text="Submit to PCMC" CausesValidation="False"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdRemove" onclick="cmdRemove_Click" runat="server" Width="90%" Text="Remove S/O" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdCancel" onclick="cmdCancel_Click" runat="server" Width="90%" Text="Back" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="133px" visible="False">Shipping
                                                                    Details</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Label id="Label18" runat="server" cssclass="LabelNormal" width="133px" visible="False">Company</asp:Label></td>
                                                                <td>
                                                                    <asp:DropDownList id="cmbShipCo" runat="server" CssClass="OutputText" Width="378px" OnSelectedIndexChanged="cmbShipCo_SelectedIndexChanged" autopostback="true" Visible="False"></asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label19" runat="server" cssclass="LabelNormal" width="133px" visible="False">Attention</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblShipAtt" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td rowspan="3">
                                                                    <asp:Label id="Label20" runat="server" cssclass="LabelNormal" width="133px" visible="False">Address</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblShipAdd1" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblShipAdd2" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblShipAdd3" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label21" runat="server" cssclass="LabelNormal" width="133px" visible="False">State</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblShipState" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label22" runat="server" cssclass="LabelNormal" width="133px" visible="False">Country</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblShipCountry" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="133px" visible="False">Billing
                                                                    Details</asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Label id="Label14" runat="server" cssclass="LabelNormal" width="133px" visible="False">Attention</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblBillAtt" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td rowspan="3">
                                                                    <asp:Label id="Label15" runat="server" cssclass="LabelNormal" width="133px" visible="False">Address</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblBillAdd1" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblbillAdd2" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblBillAdd3" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label16" runat="server" cssclass="LabelNormal" width="133px" visible="False">State</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblBillState" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="Label17" runat="server" cssclass="LabelNormal" width="133px" visible="False">Country</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblBillCountry" runat="server" cssclass="OutputText" width="378px" visible="False"></asp:Label></td>
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
