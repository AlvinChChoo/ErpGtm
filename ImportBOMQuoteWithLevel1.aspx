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
        if page.isPostBack = false then procLoadGridData()
    End Sub
    
    Sub SetCurrecntInd()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update Import_BoM_Quote set ind = 'N'")
        ReqCOM.ExecuteNonQuery("Update Import_BoM_Quote set ind = 'Y' where curr_code in (select distinct(curr_code) from bom_Quote_Curr where Bom_Quote_no = '" & trim(request.params("BOMQuoteNo")) & "')")
    ENd Sub
    
    Sub ProcLoadGridData()
        SetCurrecntInd
        Dim StrSql as string = "Select * from Import_BOM_Quote order by seq_No asc"
    
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"Import_BOM_Quote")
        Dim DV as New DataView(resExePagedDataSet.Tables("Import_BOM_Quote"))
    
        GridControl1.DataSource=DV
        GridControl1.DataBind()
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdAdd_Click(sender As Object, e As EventArgs)
        response.redirect("FECNAddNew.aspx")
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim ReqCOm as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim SPQ As Label = CType(e.Item.FindControl("SPQ"), Label)
            Dim MOQ As Label = CType(e.Item.FindControl("MOQ"), Label)
            Dim Ind As Label = CType(e.Item.FindControl("Ind"), Label)
            Dim LeadTime As Label = CType(e.Item.FindControl("LeadTime"), Label)
    
            SPQ.text = clng(SPQ.text)
            MOQ.text = clng(MOQ.text)
            LeadTime.text = clng(LeadTime.text)
    
            if trim(Ind.text) <> "Y" then e.Item.CssClass = "Urgent"
        End if
    End Sub
    
    Sub cmdGo_Click(sender As Object, e As EventArgs)
        ProcLoadGridData
    End Sub
    
    Sub ShowDet(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        Dim ModelNo as string
        Dim Revision as decimal
    
        Try
            ModelNo = ReqCOM.GetFieldVal("Select Model_No from FECN_M where Seq_No = " & clng(SeqNo.text) & ";","Model_No")
            if trim(ModelNo) = "COMMON" and trim(ucase(e.commandArgument)) = "COST" then exit sub
            Revision = ReqCOM.GetFieldVal("Select top 1 Revision as [Revision] from BOM_M where model_no = '" & trim(ModelNo) & "' order by revision desc;","Revision")
        Catch
        Finally
            if trim(ucase(e.commandArgument)) = "COST" then
                ShowReport("PopupReportViewer.aspx?RptName=FECNPartWithoutStdCost&ModelNo=" & trim(ModelNo) & "&Revision=" & cdec(Revision))
            Elseif trim(ucase(e.commandArgument)) = "VIEW" then
                Response.redirect("FECNDet.aspx?ID=" & clng(SeqNo.text))
            end if
        end try
    End sub
    
    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub
    
    Sub cmdImport_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        SetCurrecntInd
    
        if ReqCOM.FuncCheckDuplicate("Select top 1 Part_No from Import_Bom_Quote where Ind = 'N'","Part_No") = true then
            ShowAlert("Invalid Curr. Code.")
        else
            ReqCOM.ExecuteNonQuery("insert into bom_quote_d(BOM_QUOTE_NO,MAIN_PART,PART_NO,CUST_PART_NO,PART_DESC,PART_SPEC,P_USAGE,STD_VEN_CODE,STD_VEN_NAME,MFG_MPN,STD_CURR_CODE,STD_ORI_UP,STD_LT,STD_SPQ,STD_MOQ,std_date,rem,MAIN_PART_TEMP,PART_NO_TEMP) select BOM_QUOTE_NO,MAIN_PART,PART_NO,CUST_PART_NO,PART_DESC,PART_SPEC,P_USAGE,VEN_CODE,VEN_NAME,MFG_MPN,CURR_CODE,UP,LEAD_TIME,SPQ,MOQ,submit_date,rem,MAIN_PART,PART_NO from import_bom_quote order by seq_no asc")
            ReqCOM.ExecuteNonQuery("Truncate table import_bom_quote")
            ReqCOM.ExecuteNonQuery("update bom_quote_d set bom_quote_d.std_up = bom_quote_d.std_ori_up * bom_quote_curr.rate / bom_quote_curr.unit_conv from bom_quote_d,bom_quote_curr where bom_quote_d.bom_quote_no = bom_quote_curr.bom_quote_no and bom_quote_d.std_curr_code = bom_quote_curr.curr_code and bom_quote_d.bom_quote_no = '" & request.params("BOMQuoteNo") & "';")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Main = 'MAIN' WHERE MAIN_PART = PART_NO AND BOM_QUOTE_NO = '" & trim(request.params("BOMQuoteNo")) & "';")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Main = 'ALT' WHERE MAIN_PART <> PART_NO AND BOM_QUOTE_NO = '" & trim(request.params("BOMQuoteNo")) & "';")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_M set Import_File_Name = '" & trim(Request.params("FileName")) & "' where BOM_Quote_No = '" & trim(request.params("BOMQuoteNo")) & "';")
            UpdatePartNo
    
            ReqCOM.ExecuteNonQuery("Update bom_quote_d set part_no = part_no_temp where bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and part_no_temp in (select part_no from part_master)")
            ReqCOM.ExecuteNonQuery("Update bom_quote_d set main_part = main_part_temp where bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and main_part_temp in (select part_no from part_master)")
    
    
            ShowAlert("BOM Imported successfully.")
            redirectPage("ImportBOMQuote.aspx")
        end if
    End Sub
    
    Sub UpdateMainPartNo
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set BOM_Quote_D.mfg_mpn = part_master.m_part_no from BOM_Quote_D,Part_Master where BOM_Quote_D.bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and BOM_Quote_D.part_no = part_master.part_no")
        Dim strSql as string = "Select * from BOM_Quote_D where bom_Quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and main_part not in (select part_no from part_master)"
        'Dim strSql as string = "Select * from BOM_Quote_D where bom_Quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and mfg_mpn is null ORDER BY SEQ_NO ASC"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        Dim TempPartNo as string
        Dim MainPart as string
    
        do while drGetFieldVal.read
    
            MainPart = drGetFieldVal("Main_Part")
            TempPartNo = ReqCOm.GetTempPartNo
            response.write(TempPartNo)
        '    ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Part_No = '" & trim(TempPartNo) & "' where Part_No = '" & trim(PartNo) & "';")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Main_Part = '" & trim(TempPartNo) & "' where Main_Part = '" & trim(MainPart) & "';")
        loop
    
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    
    
    Sub UpdatePartNoTemp
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set BOM_Quote_D.mfg_mpn = part_master.m_part_no from BOM_Quote_D,Part_Master where BOM_Quote_D.bom_quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and BOM_Quote_D.part_no = part_master.part_no")
        Dim strSql as string = "Select * from BOM_Quote_D where bom_Quote_no = '" & trim(request.params("BOMQuoteNo")) & "' ORDER BY SEQ_NO ASC"
        'Dim strSql as string = "Select * from BOM_Quote_D where bom_Quote_no = '" & trim(request.params("BOMQuoteNo")) & "' and mfg_mpn is null ORDER BY SEQ_NO ASC"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        Dim TempPartNo as string
        Dim PartNo as string
    
        do while drGetFieldVal.read
            PartNo = drGetFieldVal("Part_No")
            TempPartNo = ReqCOm.GetTempPartNo
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Part_No = '" & trim(TempPartNo) & "' where Part_No = '" & trim(PartNo) & "';")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Main_Part = '" & trim(TempPartNo) & "' where Main_Part = '" & trim(PartNo) & "';")
        loop
    
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
    End sub
    
    Sub UpdatePartNo
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim strSql as string = "Select * from BOM_Quote_D where bom_Quote_no = '" & trim(request.params("BOMQuoteNo")) & "' ORDER BY SEQ_NO ASC"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(StrSql, myConnection)
        Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        Dim TempPartNo as string
        Dim PartNo as string
    
        do while drGetFieldVal.read
            PartNo = drGetFieldVal("Part_No")
            TempPartNo = ReqCOm.GetTempPartNo
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Part_No = '" & trim(TempPartNo) & "' where Part_No = '" & trim(PartNo) & "';")
            ReqCOM.ExecuteNonQuery("Update BOM_Quote_D set Main_Part = '" & trim(TempPartNo) & "' where Main_Part = '" & trim(PartNo) & "';")
        loop
    
        drGetFieldVal.close()
        myCommand.dispose()
        myConnection.Close()
        myConnection.Dispose()
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
    
    Sub cmdUpdateCurr_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
    
        Dim SeqNo As Label
        Dim CurrCode As textbox
    
        For i = 0 To GridControl1.Items.Count - 1
            SeqNo = CType(GridControl1.Items(i).FindControl("SeqNo"), Label)
            CurrCode = CType(GridControl1.Items(i).FindControl("CurrCode"), Textbox)
            ReqCOM.ExecutenonQuery("Update Import_BOM_Quote set Curr_Code = '" & trim(CurrCode.text) & "' where seq_no = " & seqNo.text & ";")
        Next i
        procLoadGridData
    End Sub

</script>
<html>
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
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                            </p>
                            <p align="center">
                            </p>
                            <p>
                                <table style="HEIGHT: 27px" width="94%" align="center">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <asp:DataGrid id="GridControl1" runat="server" width="100%" OnItemDataBound="FormatRow" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" PagerStyle-HorizontalAligh="Right" PagerStyle-PrevPageText="Prev" PagerStyle-NextPageText="Next" BorderColor="Black" GridLines="None" cellpadding="4" ShowFooter="True" AutoGenerateColumns="False">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn HeaderText="Main Part">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MainPart" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Main_Part") %>' /> <asp:Label id="SeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> <asp:Label id="Ind" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Ind") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Part No">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Cust Part #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CustPartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Cust_Part_No") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Description">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Specification">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartSpec" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Usage">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PUsage" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "P_Usage") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Ven Name">
                                                                <ItemTemplate>
                                                                    <asp:Label id="VenName" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Name") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Mfg MPN">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MFGMPN" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MFG_MPN") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Curr">
                                                                <ItemTemplate>
                                                                    <asp:textbox id="CurrCode" runat="server" width= "50px" text='<%# DataBinder.Eval(Container.DataItem, "Curr_Code") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="U/P">
                                                                <ItemTemplate>
                                                                    <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="L/T">
                                                                <ItemTemplate>
                                                                    <asp:Label id="LeadTime" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lead_Time") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="SPQ">
                                                                <ItemTemplate>
                                                                    <asp:Label id="SPQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SPQ") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="MOQ">
                                                                <ItemTemplate>
                                                                    <asp:Label id="MOQ" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MOQ") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Remarks">
                                                                <ItemTemplate>
                                                                    <asp:Label id="REM" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "REM") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Duplicate">
                                                                <ItemTemplate>
                                                                    <asp:Label id="Duplicate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "duplicate") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 20px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <p align="left">
                                                                        <asp:Button id="cmdImport" onclick="cmdImport_Click" runat="server" Width="108px" Text="Import"></asp:Button>
                                                                    </p>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <p align="center">
                                                                            <asp:Button id="cmdUpdateCurr" onclick="cmdUpdateCurr_Click" runat="server" Text="Update Currency"></asp:Button>
                                                                        </p>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="120px" Text="Back"></asp:Button>
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
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
    <!-- Insert content here -->
</body>
</html>
