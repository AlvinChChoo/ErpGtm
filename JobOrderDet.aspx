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
            Dim SumProdQty as long
            loaddata
            ProcLoadJobOrder
    
    
            if GridControl1.items.count = 0 then
                GridControl1.visible = false
                lblRem.visible = true
                LinkButton1.visible = true
            elseif GridControl1.items.count <> 0 then
                GridControl1.visible = true:lblRem.visible = false
    
                SumProdQty = ReqCOM.GetFieldVal("select sum(Prod_Qty) as [Prod_Qty] from Job_Order_M where Lot_No = '" & trim(lblLotNo.text) & "';","Prod_Qty")
                if SumProdQty = lblOrderQty.text then LinkButton1.visible = false
                if SumProdQty <> lblOrderQty.text then LinkButton1.visible = true
            End if
    
        End if
    End Sub
    
    Sub LoadData
        Dim strSql as string = "SELECT * FROM SO_MODELS_M WHERE SEQ_NO = " & request.params("ID")  & ";"
        Dim ReqExeDataReader as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim ResExeDataReader as SQLDataReader = ReqExeDataReader.ExeDataReader(strSql)
    
        do while ResExeDataReader.read
            lblCustCode.text = ResExeDataReader("Cust_Code")
            lblModelNo.text = trim(ResExeDataReader("Model_No").tostring)
            lblModelName.text = ReqExeDataReader.GetFieldVal("Select Model_Desc from model_master where model_code = '" & trim(trim(ResExeDataReader("Model_No").tostring)) & "';","Model_Desc")
            lblLotNo.text = ResExeDataReader("LOT_NO")
            lblSODate.text = format(cdate(ResExeDataReader("SO_DATE")),"dd/MM/yyyy")
            lblCustName.text = ReqExeDataReader.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(ResExeDataReader("Cust_Code")) & "';","Cust_Name")
            lblOrderQty.text = ResExeDataReader("ORDER_QTY").tostring
            lblDelDate.text = format(ResExeDataReader("req_date"),"dd/MM/yy")
        loop
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("JobOrder.aspx")
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=400');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub ProcLoadJobOrder()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
        StrSql = "Select * from job_order_m where Lot_No = '" & trim(lblLotNo.text) & "';"
    
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Job_Order_D")
            GridControl1.DataSource=resExePagedDataSet.Tables("Job_Order_D").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub LinkButton1_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Delete from Split_Lot_M_Temp where U_ID = '" & trim(request.cookies("U_ID").value) & "';")
        ReqCOM.ExecuteNonQuery("insert into Split_Lot_M_Temp(LOT_NO,JO_NO,PROD_QTY,U_ID,SHOW_IND) select '" & trim(lblLotNo.text) & "',JO_NO,PROD_QTY,'" & trim(request.cookies("U_ID").value) & "','N' from Job_Order_M where lot_no = '" & trim(lblLotNo.text) & "';")
        ReqCOM.ExecuteNonQuery("Delete from Split_Lot_D_Temp where U_ID = '" & trim(request.cookies("U_ID").value) & "';")
        ReqCOM.ExecuteNonQuery("Insert into Split_Lot_D_Temp(JO_NO,PD_LEVEL,PROD_QTY,U_ID) select JO_NO,PD_LEVEL,PROD_QTY,'" & TRIM(request.cookies("U_ID").value) & "' from Job_Order_D where Jo_no in (select jo_no from job_order_m where lot_no = '" & trim(lblLotNo.text) & "')")
    
        ReqCOM.ExecuteNonQuery("truncate table split_lot_m_temp")
        ReqCOM.ExecuteNonQuery("truncate table split_lot_d_temp")
    
        Response.redirect("PopupSplitLot.aspx?ID=" & ReqCOM.GetFieldVal("Select top 1 Seq_No from SO_Models_M where Lot_No = '" & trim(lblLotNo.text) & "';","Seq_No"))
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim CreateDate As Label
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            'CreateDate = CType(e.Item.FindControl("CreateDate"), Label)
            'CreateDate.text = format(CDate(CreateDate.text),"dd/MMM/yy")
        End if
    End Sub
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        Response.redirect("JobOrderDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    
    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub ShowDet(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim JONo As Label = CType(e.Item.FindControl("JONo"), Label)
    
    
    
        'Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        'Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        'Dim ModelNo as string
        'Dim Revision as decimal
    
        'Try
        '    ModelNo = ReqCOM.GetFieldVal("Select Model_No from FECN_M where Seq_No = " & clng(SeqNo.text) & ";","Model_No")
        '    if trim(ModelNo) = "COMMON" and trim(ucase(e.commandArgument)) = "COST" then exit sub
        '    Revision = ReqCOM.GetFieldVal("Select top 1 Revision as [Revision] from BOM_M where model_no = '" & trim(ModelNo) & "' order by revision desc;","Revision")
        'Catch
        'Finally
        '    if trim(ucase(e.commandArgument)) = "COST" then
        '        ShowReport("PopupReportViewer.aspx?RptName=FECNPartWithoutStdCost&ModelNo=" & trim(ModelNo) & "&Revision=" & cdec(Revision))
        '    Elseif trim(ucase(e.commandArgument)) = "VIEW" then
        '        Response.redirect("FECNDet.aspx?ID=" & clng(SeqNo.text))
        '    end if
        'end try
    End sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        'Dim FECNNo As Label = CType(e.Item.FindControl("FECNNo"), Label)
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("JobOrderExp.aspx?ID=" & clng(SeqNo.text))
    
        'if ucase(e.commandArgument) = "VIEW" then Response.write(SeqNo.text)
    
    end sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <erp:HEADER id="UserControl2" runat="server"></erp:HEADER>
                    </td>
                </tr>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" cssclass="fORMdESC" width="100%">SALES ORDER
                            DETAILS - BY MODEL</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                <tbody>
                                                    <tr>
                                                        <td width="30%" bgcolor="silver">
                                                            <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="134px">Lot No </asp:Label></td>
                                                        <td width="70%">
                                                            <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label3" runat="server" cssclass="LabelNormal" width="134px">Issued
                                                            Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblSODate" runat="server" cssclass="OutputText" width="379px"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label4" runat="server" cssclass="LabelNormal" width="134px">Cust. Code
                                                            / Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                            -&nbsp; <asp:Label id="lblCustName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label5" runat="server" cssclass="LabelNormal" width="134px">Model No
                                                            / Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                            -&nbsp; <asp:Label id="lblModelName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label30" runat="server" cssclass="LabelNormal" width="134px">Req. Del.
                                                            Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblDelDate" runat="server" cssclass="OutputText" width="323px"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label13" runat="server" cssclass="LabelNormal" width="134px">Lot Qty</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblOrderQty" runat="server" cssclass="OutputText" width="323px"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                                <asp:Label id="lblRem" runat="server" cssclass="ErrorText" width="100%">No Job Order
                                                created for this lot.</asp:Label>
                                            </p>
                                            <p>
                                                <asp:LinkButton id="LinkButton1" onclick="LinkButton1_Click" runat="server" CssClass="OutputText">Click here to add Job Order</asp:LinkButton>
                                            </p>
                                            <p>
                                                <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemDataBound="FormatRow" AutoGenerateColumns="False" cellpadding="4" GridLines="None" BorderColor="Black" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnItemCommand="ItemCommand">
                                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                    <Columns>
                                                        <asp:TemplateColumn>
                                                            <ItemTemplate>
                                                                <asp:ImageButton id="ImgView" ToolTip="View this S/O" ImageUrl="View.gif" CommandArgument='View' runat="server"></asp:ImageButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Job Order #">
                                                            <ItemTemplate>
                                                                <asp:Label id="JONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "JO_NO") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Prod. Qty">
                                                            <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                            <ItemStyle horizontalalign="Left"></ItemStyle>
                                                            <ItemTemplate>
                                                                <asp:Label id="ProdQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prod_Qty") %>' /> 
                                                            </ItemTemplate>
                                                            <FooterStyle horizontalalign="Left"></FooterStyle>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Create By/Date">
                                                            <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                            <ItemStyle horizontalalign="Left"></ItemStyle>
                                                            <ItemTemplate>
                                                                <asp:Label id="CreateBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Create_By") %>' /> - <asp:Label id="CreateDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Create_Date") %>' /><asp:Label id="SeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                            </ItemTemplate>
                                                            <FooterStyle horizontalalign="Left"></FooterStyle>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                </asp:DataGrid>
                                            </p>
                                            <p align="left">
                                                <table style="HEIGHT: 13px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="33%">
                                                                <div align="left">
                                                                    <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Text="Refresh Job Order"></asp:Button>
                                                                </div>
                                                            </td>
                                                            <td width="33%">
                                                                <div align="right">
                                                                    <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="157px"></asp:Button>
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
    </form>
</body>
</html>
