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
            loaddata
            ProcLoadGridData
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
    End Sub

    Sub LoadData
        Dim strSql as string = "SELECT * FROM SO_PART_M WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)

        do while ResExeDataReader.read
            lblLotNo.text = ResExeDataReader("LOT_NO")
            lblSODate.text = format(ResExeDataReader("SO_DATE"),"dd/MM/yy")
            lblCustCode.text = ResExeDataReader("cust_code").tostring
            lblPONo.text = ResExeDataReader("PO_NO").tostring
            lblPODate.text = format(ResExeDataReader("PO_DATE"),"dd/MM/yy")
            Dim CurrShipCo as string = ReqExeDataReader.GetFieldVal("Select * from Cust_Ship where Cust_Code = '" & trim(lblCustCode.text) & "' and Ship_CO = '" & trim(ResExeDataReader("SHIP_CO").tostring) & "';","Ship_Co")
            lblDelDate.text =  format(ResExeDataReader("Req_Date"),"dd/MM/yy")
            txtRem.text = ResExeDataReader("REM").tostring

            if isdbnull(ResExeDataReader("App2_By")) = false then
                lblPCMCBy.text = ResExeDataReader("App2_By")
                lblPCMCDate.text = format(cdate(ResExeDataReader("App2_Date")),"dd/MM/yy")
            End if

            lblCSDAppBy.text = ResExeDataReader("CSD_App_BY").tostring
            lblCSDAppDate.text = format(cdate(ResExeDataReader("CSD_App_DATE")),"dd/MM/yy")

            if trim(lblPCMCBy.text) <> "" then
                cmdApprove.visible = false
                rbApprove.visible = false
                rbReject.visible = false
                Label10.visible = false
                txtAppRem.visible = false
            End if

            if isdbnull(ResExeDataReader("Create_by")) = false then
                lblPreparedBy.text = ResExeDataReader("Create_by").tostring
                lblPreparedDate.text = format(cdate(ResExeDataReader("Create_Date").tostring),"dd/MM/yy")
            End if
        loop
        ResExeDataReader.close()

        Dim RsCust as SQLDataReader = ReqExeDataReader.ExeDataReader("Select * from cust where Cust_Code = '" & trim(lblCustCode.text) & "'")
        Do while RsCust.read
            lblCustName.text = rsCust("Cust_Name").tostring
        loop
        RsCust.close()
    End sub

    Sub ProcLoadGridData()
        Dim strSql as string = "Select * from SO_Part_D where Lot_No = '" & trim(lblLotNo.text) & "';"
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

    Sub cmdAddNewPart_Click(sender As Object, e As EventArgs)
        Dim resCOM as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
        Dim CurrID as String = resCOM.getFieldVal("Select Seq_No from SO_Part_M where LOT_NO = '" & trim(lblLotNo.text) & "';","Seq_No")
        response.redirect("SalesOrderPartAddParts.aspx?ID=" + trim(CurrID))
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

    Sub cmdApprove_Click(sender As Object, e As EventArgs)
        Dim ReqCom as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM

        if rbApprove.checked = true then ReqCOM.ExecuteNonQuery("Update SO_PART_M set App2_By = '" & trim(request.cookies("U_ID").value) & "',App2_Date = '" & NOW & "',App2_Status = 'Y',App2_Rem = '" & txtRem.text & "' where Seq_No = " & request.params("ID") & ";")

        if rbReject.checked = true then ReqCOM.ExecuteNonQuery("Update SO_PART_M set App2_By = '" & trim(request.cookies("U_ID").value) & "',App2_Date = '" & now & "',App2_Status = 'N', App2_Rem = '" & txtRem.text & "' where Seq_No = " & request.params("ID") & ";")
        response.redirect("SalesOrderPartsDetPCMC.aspx?ID=" & Request.params("ID"))

    '    Response.redirect("SalesOrderPartsPCMCApproval.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub cmdReject_Click(sender As Object, e As EventArgs)
    '    Response.redirect("SalesOrderPartsPCMCRej.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("SalesOrderPartApp.aspx")
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
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
                                <table style="HEIGHT: 19px" cellspacing="0" cellpadding="0" width="84%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                </p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%" bgcolor="silver">
                                                                <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="133px">Issue Date</asp:Label></td>
                                                            <td width="75%">
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
                                                                <asp:Label id="Label27" runat="server" cssclass="LabelNormal" width="133px">Req. Del.
                                                                Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblDelDate" runat="server" cssclass="OutputText" width="378px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="133px">P / O No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPONo" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label6" runat="server" cssclass="LabelNormal" width="133px">P / O Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblPODate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="133px">Remarks</asp:Label></td>
                                                            <td colspan="1">
                                                                <asp:TextBox id="txtRem" runat="server" Width="100%" ReadOnly="True" CssClass="OutputText"></asp:TextBox>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                                <p>
                                                    <table style="HEIGHT: 13px" width="100%" border="1">
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
                                                                    <p>
                                                                        <asp:DataGrid id="GridControl1" runat="server" width="100%" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Border="Border" GridLines="Vertical" AutoGenerateColumns="False" CellPadding="2">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                                            <Columns>
                                                                                <asp:BoundColumn DataField="PART_NO" HeaderText="PART NO"></asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="PART_QTY" HeaderText="PART QTY" DataFormatString="{0:F}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="INVOICE_UP" HeaderText="UNIT PRICE" >
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                                <asp:BoundColumn DataField="INVOICE_TOTAL" HeaderText="TOTAL" DataFormatString="{0:F}">
                                                                                    <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                                </asp:BoundColumn>
                                                                            </Columns>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev"></PagerStyle>
                                                                        </asp:DataGrid>
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Prepared by</asp:Label></td>
                                                                <td width="75%">
                                                                    <asp:Label id="lblPreparedBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblPreparedDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">CSD Approved By</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCSDAppBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCSDAppDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal">PCMC - Approved By</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPCMCBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblPCMCDate" runat="server" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p>
                                                    <table id="table" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <asp:Label id="Label10" runat="server" cssclass="OutputText">Remarks</asp:Label></td>
                                                                <td width="55%">
                                                                    <asp:TextBox id="txtAppRem" runat="server" Width="100%" CssClass="OutputText" Height="56px"></asp:TextBox>
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
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdApprove" onclick="cmdApprove_Click" runat="server" Width="105px" Text="Approve"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="93px" Text="Back"></asp:Button>
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
