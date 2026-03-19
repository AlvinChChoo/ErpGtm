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
                loaddata
                ProcLoadJobOrder
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
        StrSql = "SELECT * from job_order_d where jo_no in (select jo_no from job_order_M where lot_no = '" & trim(lblLotNo.text) & "') order by jo_no asc"
    
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Job_Order")
            GridControl1.DataSource=resExePagedDataSet.Tables("Job_Order").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub cmdExit_Click(sender As Object, e As EventArgs)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim StartDate As label = CType(e.Item.FindControl("StartDate"), label)
            Dim EndDate As label = CType(e.Item.FindControl("EndDate"), label)
    
            if StartDate.text <> "" then StartDate.text = format(cdate(startDate.text),"dd/MM/yy")
            if EndDate.text <> "" then EndDate.text = format(cdate(EndDate.text),"dd/MM/yy")
        End if
    End Sub
    
    Sub cmdClose_Click(sender As Object, e As EventArgs)
        CloseIE
    End Sub
    
    Sub CloseIE()
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.close();</script" & ">"
        If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
    End sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <table style="HEIGHT: 24px" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
                <tr>
                    <td>
                        <p align="center">
                            <asp:Label id="Label1" runat="server" width="100%" cssclass="fORMdESC">JOB ORDER</asp:Label>
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
                                                            <asp:Label id="Label2" runat="server" width="134px" cssclass="LabelNormal">Lot No </asp:Label></td>
                                                        <td width="70%">
                                                            <asp:Label id="lblLotNo" runat="server" width="379px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label4" runat="server" width="134px" cssclass="LabelNormal">Cust. Code
                                                            / Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                            -&nbsp; <asp:Label id="lblCustName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label5" runat="server" width="134px" cssclass="LabelNormal">Model No
                                                            / Name</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;
                                                            -&nbsp; <asp:Label id="lblModelName" runat="server" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label30" runat="server" width="134px" cssclass="LabelNormal">Req. Del.
                                                            Date</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblDelDate" runat="server" width="323px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="silver">
                                                            <asp:Label id="Label13" runat="server" width="134px" cssclass="LabelNormal">Lot Qty</asp:Label></td>
                                                        <td>
                                                            <asp:Label id="lblOrderQty" runat="server" width="323px" cssclass="OutputText"></asp:Label></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                                <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemDataBound="FormatRow" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" BorderColor="Black" GridLines="Vertical" cellpadding="4" AutoGenerateColumns="False">
                                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                                    <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                    <Columns>
                                                        <asp:TemplateColumn visible="false">
                                                            <ItemTemplate>
                                                                <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Job Order #">
                                                            <ItemTemplate>
                                                                <asp:Label id="JONo" runat="server" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "JO_NO") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="PD">
                                                            <ItemTemplate>
                                                                <asp:Label id="PDLevel" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PD_Level") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Start Date">
                                                            <ItemTemplate>
                                                                <asp:Label id="StartDate" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Start_Date") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="End Date">
                                                            <ItemTemplate>
                                                                <asp:Label id="EndDate" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "End_Date") %>' /> 
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
                                                                <div align="center">
                                                                </div>
                                                            </td>
                                                            <td width="25%">
                                                                <div align="right">
                                                                    <asp:Button id="cmdClose" onclick="cmdClose_Click" runat="server" Text="Close" Width="122px"></asp:Button>
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
