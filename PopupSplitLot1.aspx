<%@ Page Language="VB" Debug="true" %>
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
    
            'if page.isvalid = true then
            '    UpdateJO
            '    ShowAlert("Job Orders Updated.")
            '    redirectPage("JobOrderDet.aspx?ID=" & Request.params("ID"))
            '    Response.redirect("JobOrderDet.aspx?ID=" & Request.params("ID"))
            'End if
    
            loaddata
            ProcLoadJobOrder
    
                UpdateJO
    
            '    ShowAlert("Job Orders Updated.")
            '    redirectPage("JobOrderDet.aspx?ID=" & Request.params("ID"))
                Response.redirect("JobOrderDet.aspx?ID=" & Request.params("ID"))
    
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
            lblCustName.text = ReqExeDataReader.GetFieldVal("Select Cust_Name from Cust where Cust_Code = '" & trim(ResExeDataReader("Cust_Code")) & "';","Cust_Name")
            lblOrderQty.text = ResExeDataReader("ORDER_QTY").tostring
            lblDelDate.text = format(ResExeDataReader("req_date"),"dd/MM/yy")
        loop
    End sub
    
     Sub cmdBack_Click(sender As Object, e As EventArgs)
     End Sub
    
     Sub ShowReport(ReturnURL as string)
         Dim Script As New System.Text.StringBuilder
         Script.Append("<script language=javascript>")
         Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
         Script.Append("</script" & ">")
         RegisterStartupScript("ShowExistingSupplier", Script.ToString())
     End sub
    
     Sub ProcLoadJobOrder()
         Dim StrSql as string
         Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
    
         StrSql = "SELECT sm.prod_qty,sd.jo_no,sd.pd_level,sd.seq_no from split_lot_D_temp SD,split_lot_M_temp SM where sd.Jo_No = sm.jo_no and sd.u_id = '" & trim(request.cookies("U_ID").value) & "' and sd.jo_no in (select jo_no from split_lot_M_temp where lot_no = '" & trim(lblLotNo.text) & "' and show_ind = 'Y') order by sd.jo_no,sd.PD_Level asc"
    
         IF StrSql <> "" THEN
             Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Job_Order")
             GridControl1.DataSource=resExePagedDataSet.Tables("Job_Order").DefaultView
             GridControl1.DataBind()
         End if
     end sub
    
    
    Sub UpdateJO()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo as Label
        Dim StartDate as textbox
        Dim EndDate as label
        Dim StartDateInput,EndDateInput as string
        Dim DDay,DMth,DYr as string
        Dim i As Integer
        Dim TotalJobOrderQty as string
    
        'ReqCOM.ExecuteNonQuery("Delete from Job_Order_D where JO_No in (Select JO_No from Job_Order_M where Lot_No = '" & trim(lblLotNo.text) & "')")
        'ReqCOM.ExecuteNonQuery("Delete from Job_Order_M where Lot_No = '" & trim(lblLotNo.text) & "';")
    
        ReqCOM.ExecuteNonQuery("Insert into Job_Order_M(JO_NO,LOT_NO,PROD_QTY,create_by,create_date) select JO_NO,LOT_NO,PROD_QTY,'" & trim(request.cookies("U_ID").value) & "','" & cdate(now) & "' from split_lot_m_temp where lot_no = '" & trim(lblLotNo.text) & "';")
        ReqCom.ExecuteNonQuery("Insert into Job_Order_D(JO_NO,PD_LEVEL,PROD_QTY) select JO_NO,PD_LEVEL,PROD_QTY from Split_Lot_d_temp where jo_no in (select jo_no from split_lot_m_temp where lot_no = '" & trim(lblLotNo.text) & "')")
    
        TotalJobOrderQty = ReqCOM.GetFieldVal("Select Sum(Prod_Qty) as [TotalQty] from Job_Order_M where Lot_No = '" & trim(lblLotNo.text) & "';","TotalQty")
        if TotalJobOrderQty = "<NULL>" then TotalJobOrderQty = "0"
        ReqCOM.ExecuteNonQuery("Update SO_Models_M set Job_Order_Qty = " & clng(TotalJobOrderQty)  & " where Lot_No = '" & trim(lblLotNo.text) & "';")
        ReqCOM.ExecuteNonQuery("Update Job_Order_D set Job_Order_D.Prod_Qty = Job_Order_M.Prod_Qty from Job_Order_D, Job_Order_M where Job_Order_D.JO_No = Job_Order_M.JO_NO and Job_Order_M.Lot_No = '" & trim(lblLotNo.text) & "';")
    End sub
    
    Sub ShowAlert(Msg as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
    
        End if
    End Sub
    
    Sub Val1_ServerValidate(sender As Object, e As ServerValidateEventArgs)
    End Sub
    
     Sub cmdBack_Click_1(sender As Object, e As EventArgs)
         Response.redirect("PopupSplitLot.aspx?ID=" & Request.params("ID"))
     End Sub
    
     Sub redirectPage(ReturnURL as string)
         Dim strScript as string
         strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
         If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
     End sub
    
    Sub UpdatePCSchDays()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        StrSql = "SELECT DISTINCT(PD_LEVEL) as [PDLevel], MAX(PC_SCH_DAYS) as [PCSchDays] FROM P_LEVEL GROUP BY PD_LEVEL ORDER BY PD_LEVEL"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
        do while drGetFieldVal.read
            ReqCom.ExecuteNonQUery("Update Split_Lot_D_Temp set pc_sch_days = " & drGetFieldVal("PCSchDays") & " where pd_level = '" & trim(drGetFieldVal("PDLevel")) & "' and u_id = '" & trim(request.cookies("U_ID").value) & "';")
        loop
    
        ReqCOM.ExecuteNonQuery("Update split_lot_d_temp set end_date = start_date + pc_sch_days where u_id = '" & trim(request.cookies("U_ID").value) & "';")
    
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub

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
                        <p align="center">
                            <asp:Label id="Label1" runat="server" cssclass="fORMdESC" width="100%">JOB ORDER</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <p align="center">
                                                <asp:CustomValidator id="Val1" runat="server" Width="100%" CssClass="ErrorText" OnServerValidate="Val1_ServerValidate" EnableClientScript="False" ForeColor=" " Display="Dynamic" ErrorMessage=""></asp:CustomValidator>
                                            </p>
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
                                                <asp:DataGrid id="GridControl1" runat="server" width="100%" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" OnItemDataBound="FormatRow">
                                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                    <Columns>
                                                        <asp:TemplateColumn visible="false">
                                                            <ItemTemplate>
                                                                <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Job Order #">
                                                            <ItemTemplate>
                                                                <asp:Label id="JONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "JO_NO") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="PD">
                                                            <ItemTemplate>
                                                                <asp:Label id="PDLevel" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PD_Level") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="J/O Qty">
                                                            <ItemTemplate>
                                                                <asp:Label id="ProdQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Prod_Qty") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                    <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                </asp:DataGrid>
                                            </p>
                                            <p align="left">
                                                <table style="HEIGHT: 13px" width="100%">
                                                    <tbody>
                                                        <tr>
                                                            <td width="25%">
                                                            </td>
                                                            <td width="25%">
                                                                <div align="right">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click_1" runat="server" Width="105px" Text="Back"></asp:Button>
                                                                    </div>
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
