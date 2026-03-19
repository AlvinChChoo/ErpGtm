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
        IF page.ispostback=false then
            Dim ReqCOm as Erp_Gtm.Erp_Gtm = new Erp_Gtm.Erp_Gtm
            Dim RsUPASM as SqlDataReader = ReqCOm.ExeDataReader("Select * from JOAS_M where Seq_No = '" & trim(request.params("ID")) & "';")
    
            Do while RsUPASM.read
                lblJoasNO.text = RsUPASM("JOAS_No")
                lblJoasDate.text = format(cdate(RsUPASM("JOAS_Date")),"dd/MM/yy")
            loop
            ProcLoadGridData
    
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
    
    
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("JOAS.aspx")
    End Sub
    
    
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    
    
    
    
    
    Sub ShowDetails(s as object,e as DataListCommandEventArgs)
        Dim PartNo As Label = CType(e.Item.FindControl("lblPartNo"), Label)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim Script As New System.Text.StringBuilder
        Dim StrSql as string
    
        if e.commandArgument = "WhereUseList" then
            ReqCOM.ExecuteNonQuery("Truncate Table Where_Use_M")
            ReqCOM.ExecuteNonQuery("Truncate Table Where_Use_D")
            ReqCOM.ExecuteNonQuery("Insert into Where_Use_M(MODEL_NO,PART_NO,P_LEVEL,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision) select MODEL_NO,PART_NO,P_LEVEL,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision from BOM_D where part_no = '" & trim(PartNo.text) & "';")
            ReqCOM.ExecuteNonQuery("Insert into Where_Use_D(MODEL_NO,MAIN_PART,PART_NO,REVISION) select MODEL_NO,MAIN_PART,PART_NO,REVISION from BOM_ALT where Part_No = '" & trim(PartNo.text) & "';")
    
            Dim rsWhereUse as SQLDataReader = ReqCOM.ExeDataReader("Select distinct(Model_No),Max(Revision) as [Revision] from where_use_m group by Model_No")
    
            Do while rsWhereUse.read
                ReqCOM.executeNonQuery("Delete from Where_use_m where model_no = '" & trim(rsWhereUse("Model_No")) & "' and Revision < " & rsWhereUse("Revision") & ";")
                ReqCOM.executeNonQuery("Delete from Where_use_d where model_no = '" & trim(rsWhereUse("Model_No")) & "' and Revision < " & rsWhereUse("Revision") & ";")
            loop
    
            rsWhereUse.close()
    
            StrSql = "Insert into Where_Use_M(MODEL_NO,PART_NO,P_LEVEL,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision) select MODEL_NO,PART_NO,P_LEVEL,LOT_FACTOR1,LOT_FACTOR2,P_USAGE,Revision from BOM_D where part_no in (select main_part from where_use_d where main_part not in(select part_no from where_use_m))"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update Part_Master set where_use_ind = 'N'"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            StrSql = "Update Part_Master set where_use_ind = 'Y' where Part_No in(Select distinct(Part_No) as [Part_No] from Where_use_m)"
            ReqCOM.ExecuteNonQuery(StrSql)
    
            Script.Append("<script language=javascript>")
            Script.Append("pupUp=window.open('PopUpReportViewer.aspx?RptName=WhereUseListWithSupplier&PartNofrom=" & trim(PartNo.text) & "&PartNoTo=" & trim(PartNo.text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=950,height=250');")
            Script.Append("</script" & ">")
            RegisterStartupScript("NewPopUp", Script.ToString())
        elseif e.commandArgument = "BOMCost" then
            UpdateLatestBOMRev(PartNo.text)
            'UpdateBOMCost
            Script.Append("<script language=javascript>")
            Script.Append("pupUp=window.open('PopUpBOMCostSummary.aspx?PartNo=" & trim(PartNo.text) & "','','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=700,height=250');")
            Script.Append("</script" & ">")
            RegisterStartupScript("BOMCost", Script.ToString())
        end if
    end sub
    
    Sub UpdateBOMCost()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrSql as string
        StrSql = "Update BOM_D set bom_d.part_up_rpt = part_master.wac_cost from part_master where part_master.part_no = bom_d.part_no"
        ReqCOM.executeNonQuery(StrSql)
    End sub
    
    Sub UpdateLatestBOMRev(PartNo as string)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim rs as SQLDataReader
        Dim cnn As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
    
        ReqCOM.ExecuteNonQuery("Update BOM_M set Ind = 'N'")
        ReqCOM.ExecuteNonQuery("Update BOM_M set ind = 'Y' from BOM_M, BOM_D where BOM_D.Part_No = '" & trim(PartNo) & "' and BOM_M.Model_No = BOM_D.Model_No and BOM_M.Revision = BOM_D.Revision")
        cnn.Open()
    
        Dim cmd As SqlCommand = New SqlCommand("Select * from BOM_M where ind = 'Y'", cnn )
        rs = cmd.ExecuteReader(CommandBehavior.CloseConnection)
    
        Do while rs.read
            ReqCOm.ExecutenonQuery("Update BOM_M set Ind = 'N' where ind = 'Y' and Model_No = '" & trim(rs("Model_No")) & "' and Revision < " & rs("Revision") & ";")
        Loop
    
        cmd.dispose()
        rs.close()
        cnn.Close()
        cnn.Dispose()
    End sub
    
    Sub ProcLoadGridData()
        'Dim StrSql as string = "Select * from joas_d where joas_NO = '" & trim(lblJoasNo.text) & "';"
        Dim StrSql as string = "Select JD.PROD_LEVEL,JD.JO_NO,JD.SEQ_NO,JO.START_DATE,JO.END_DATE from JOAS_D JD,JOB_ORDER_D JO where JD.JOAs_No = '" & TRIM(lblJOASNo.text) & "' AND JD.JO_NO = JO.JO_NO AND JD.PROD_LEVEL = JO.PD_LEVEL order by JD.seq_no asc"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"joas_d")
        GridControl1.DataSource=resExePagedDataSet.Tables("joas_d").DefaultView
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub Button1_Click(sender As Object, e As EventArgs)
    
    End Sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim StartDate As Label = CType(e.Item.FindControl("StartDate"), Label)
            Dim EndDate As Label = CType(e.Item.FindControl("EndDate"), Label)
            StartDate.text = format(cdate(StartDate.text),"dd/MM/yy")
            EndDate.text = format(cdate(EndDate.text),"dd/MM/yy")
        End if
    End Sub
    
    Sub lnkAddItem_Click(sender As Object, e As EventArgs)
        ShowReport("PopupJobOrderItem.aspx?ID=" & Request.params("ID"))
        redirectPage("JOASDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        Response.redirect("JOASDet.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update JOAS_M set App1_By = '" & trim(request.cookies("U_ID").value) & "',App1_Date = '" & cdate(now) & "' where JOAS_No = '" & trim(lblJOASNo.text) & "';")
        Response.redirect("JOASDet.aspx?ID=" & Request.params("ID"))
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
            <table style="HEIGHT: 28px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label5" runat="server" width="100%" cssclass="FormDesc">JOB ORDER APPROVAL
                                SHEET DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="80%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" width="100%" cssclass="LabelNormal">J/O Approval
                                                                    Sheet #</asp:Label></td>
                                                                <td width="70%">
                                                                    <div align="left"><asp:Label id="lblJOASNo" runat="server" width="384px" cssclass="OutputText"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="100%" cssclass="LabelNormal">JOAS Date</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblJOASDate" runat="server" width="384px" cssclass="OutputText"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <div>
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="70%">
                                                                    <asp:LinkButton id="lnkAddItem" onclick="lnkAddItem_Click" runat="server" CausesValidation="False">Click here to add item to J/O Approval Sheet</asp:LinkButton>
                                                                </td>
                                                                <td width="30%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Text="Refresh" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" Font-Name="Verdana" PagerStyle-NextPageText="Next" PagerStyle-PrevPageText="Prev" PagerStyle-HorizontalAligh="Right" PageSize="10" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="JO #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="JONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "jo_no") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="PROD.">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ProdLevel" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "prod_level") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Start Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="StartDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Start_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="End Date">
                                                                <ItemTemplate>
                                                                    <asp:Label id="EndDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "End_Date") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                    &nbsp; 
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 21px" width="100%" align="right">
                                                        <tbody>
                                                            <tr>
                                                                <td width="50%">
                                                                    <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Text="Submit" Width="127px"></asp:Button>
                                                                </td>
                                                                <td width="50%">
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Text="Back" Width="134px"></asp:Button>
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
        <td>
        </td>
    </form>
    <!-- Insert content here -->
</body>
</html>
