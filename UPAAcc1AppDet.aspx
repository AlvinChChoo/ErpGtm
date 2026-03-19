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
            Dim RsUPASM as SqlDataReader = ReqCOm.ExeDataReader("Select * from UPAS_M where Seq_No = '" & trim(request.params("ID")) & "';")
    
            Do while RsUPASM.read
                lblUPASNo.text = RsUPASM("UPAS_NO").tostring
                lblRem.text = RsUPASM("REM").tostring
                if isdbnull(RsUPASM("CREATE_BY")) = false then lblCreateBy.text = trim(ucase(RsUPASM("CREATE_BY"))) & " - " & format(RsUPASM("CREATE_DATE"),"dd/MMM/yy")
                if isdbnull(RsUPASM("SUBMIT_BY")) = false then lblSubmitBy.text = trim(ucase(RsUPASM("submit_BY"))) & " - " & format(RsUPASM("submit_Date"),"dd/MMM/yy")
                if isdbnull(RsUPASM("PURC_BY")) = false then lblPurcApp.text = trim(ucase(RsUPASM("PURC_BY"))) & " - " & format(RsUPASM("PURC_DATE"),"dd/MMM/yy")
                if isdbnull(RsUPASM("ACC1_BY")) = false then lblACC1By.text = trim(ucase(RsUPASM("ACC1_BY"))) & " - " & format(RsUPASM("ACC1_DATE"),"dd/MMM/yy")
                if isdbnull(RsUPASM("ACC2_BY")) = false then lblACC2By.text = trim(ucase(RsUPASM("ACC2_BY"))) & " - " & format(RsUPASM("ACC2_DATE"),"dd/MMM/yy")
                if isdbnull(RsUPASM("MGT_BY")) = false then lblMgtApp.text = trim(ucase(RsUPASM("MGT_BY"))) & " - " & format(RsUPASM("MGT_DATE"),"dd/MMM/yy")
    
                lblPurcRem.text = trim(RsUPASM("purc_rem").tostring)
                lblACC1Rem.text = trim(RsUPASM("ACC1_rem").tostring)
                lblACC2Rem.text = trim(RsUPASM("ACC2_rem").tostring)
                lblMGTRem.text = trim(RsUPASM("Mgt_rem").tostring)
    
                if isdbnull(RsUPASM("ACC1_BY")) = false
                    cmdREject.enabled = false
                    cmdapprove.enabled = false
                elseif isdbnull(RsUPASM("ACC1_BY")) = true
                    cmdREject.enabled = true
                    cmdapprove.enabled = true
                End if
            loop
            RsUPASM.Close
            LoadData
            ProcLoadAttachment
            FormatRow
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
    
    sub LoadData
        Dim OurCommand as sqlcommand
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        Dim ourDataAdapter as SQLDataAdapter
        dim OurDataset as new dataset()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
        OurCommand = New SQLCommand("Select UPA.ORI_VEN_NAME,UPA.ORI_CURR_CODE,UPA.ORI_UP,UPA.A_ORI_VEN_NAME,UPA.A_ORI_CURR_CODE,UPA.A_ORI_UP,UPA.VALIDITY,PM.WAC_COST,PM.OLD_WAC_COST,UPA.MIN_ORDER_QTY,UPA.A_MIN_ORDER_QTY,upa.cancel_lt,upa.a_cancel_lt,upa.reschedule_lt,upa.a_reschedule_lt,UPA.UP_RM,UPA.A_UP_RM,UPA.Curr_Code,UPA.A_Curr_Code, UPA.Ven_Code_temp,UPA.A_Ven_Code_Temp,PM.M_Part_No,PM.Part_Desc,PM.Part_Spec,UPA.aCT,UPA.part_no,UPA.seq_no,UPA.ven_code,UPA.up,UPA.diff_amt,UPA.lead_time,UPA.std_pack,UPA.a_ven_code,UPA.A_up,UPA.Diff_Pctg,UPA.A_Lead_Time,UPA.A_Std_pack,UPA.rem from UPAS_D UPA,Part_Master PM where UPA.UPAS_NO = '" & trim(lblUPASNo.text) & "' and UPA.Part_No = PM.Part_No order by upa.seq_no asc" ,myconnection)
        ourdataadapter=new sqldataadapter(ourcommand)
        ourDataAdapter.fill(OurDataset,"Items")
        Dim OurDataTable as new dataview(ourDataSet.Tables("Items"))
        MyList.DataSource = OurDatatable
        MyList.DataBind()
    End sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("UPAAcc1App.aspx")
    End Sub
    
    Sub cmdApprove_Click(sender As Object, e As EventArgs)
        response.redirect("UPAAcc1Approve.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub cmdReject_Click(sender As Object, e As EventArgs)
        response.redirect("UPAAcc1Reject.aspx?ID=" & Request.params("ID"))
    End Sub
    
    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Sub ProcLoadAttachment()
        Dim StrSql as string = "Select * from UPAS_ATTACHMENT where UPAS_NO = '" & trim(lblUPASNo.text) & "';"
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"UPAS_ATTACHMENT")
        dtgUPASAttachment.DataSource=resExePagedDataSet.Tables("UPAS_ATTACHMENT").DefaultView
        dtgUPASAttachment.DataBind()
    end sub
    
    Sub FormatRow()
        Dim i As Integer
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
    
    
        For i = 0 To MyList.Items.Count - 1
            Dim Validity As Label = CType(MyList.Items(i).FindControl("Validity"), Label)
            Dim DiffAmt As Label = CType(MyList.Items(i).FindControl("DiffAmt"), Label)
            Dim DiffPctg As Label = CType(MyList.Items(i).FindControl("DiffPctg"), Label)
            Dim WACCost As Label = CType(MyList.Items(i).FindControl("WACCost"), Label)
            Dim SeqNo As Label = CType(MyList.Items(i).FindControl("SeqNo"), Label)
    
            if trim(DiffAmt.text) <> "" then
                if cdec(DiffAmt.text) > 0 then DiffAmt.CssClass = "PartSource" : DiffPctg.CssClass = "PartSource"
            End if
    
            DiffAmt.text = "RM " & DiffAmt.text
            if trim(WACCost.text) = "" then WACCost.text = "0"
            WACCost.text = "RM " & format(cdec(WACCost.text),"##,##0.00000")
            if cint(validity.text) = 0 then
                validity.text = "-"
            elseif cint(validity.text) > 0 then
                validity.text = Validity.text & " days upon approval."
            end if
        Next
    end sub
    
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
                                <asp:Label id="Label5" runat="server" width="100%" cssclass="FormDesc">UNIT PRICE
                                APPROVAL SHEET DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="98%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p>
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: white; BORDER-BOTTOM-COLOR: white; BORDER-TOP-COLOR: white; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: white" width="80%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="30%" bgcolor="silver">
                                                                    <asp:Label id="Label10" runat="server" width="128px" cssclass="LabelNormal">Approval
                                                                    Sheet No</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblUPASNo" runat="server" width="384px" cssclass="OutputText"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" width="128px" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblRem" runat="server" width="384px" cssclass="OutputText"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" width="128px" cssclass="LabelNormal">Prepared
                                                                    By</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblCreateBy" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label6" runat="server" cssclass="LabelNormal">Submit </asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSubmitBy" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label7" runat="server" cssclass="LabelNormal">Approved (Purc)</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblPurcApp" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblPurcRem" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label8" runat="server" cssclass="LabelNormal">Accounts 1</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblACC1By" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblAcc1Rem" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label81" runat="server" cssclass="LabelNormal">Accounts 2</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblACC2By" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label id="lblAcc2Rem" runat="server" width="384px" cssclass="OutputText"></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver" rowspan="2">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Approved (Mgt)</asp:Label></td>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblMgtApp" runat="server" width="384px" cssclass="OutputText"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <div align="left"><asp:Label id="lblMgtRem" runat="server" width="384px" cssclass="OutputText"></asp:Label>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:DataGrid id="dtgUPASAttachment" runat="server" width="100%" PageSize="50" AlternatingItemStyle-CssClass="CartListItemAlt" ItemStyle-CssClass="CartListItem" HeaderStyle-CssClass="CartListHead" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" OnSelectedIndexChanged="dtgUPASAttachment_SelectedIndexChanged">
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SEQ_NO") %>' /> 
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="File_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="File_Name" HeaderText="File Name"></asp:BoundColumn>
                                                            <asp:BoundColumn DataField="File_Size" HeaderText="File Size (Byte)"></asp:BoundColumn>
                                                            <asp:HyperLinkColumn Text="Download" DataNavigateUrlField="Seq_No" DataNavigateUrlFormatString="DownloadUPAAttachment.aspx?ID={0}"></asp:HyperLinkColumn>
                                                        </Columns>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="center">
                                                    <asp:DataList id="MyList" runat="server" OnSelectedIndexChanged="MyList_SelectedIndexChanged" Font-Names="Arial" Font-Size="XX-Small" Width="100%" Height="101px" OnItemCommand="ShowDetails" CellPadding="1" BorderWidth="0px" RepeatColumns="1">
                                                        <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                        <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                        <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                        <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                        <ItemStyle font-size="XX-Small"></ItemStyle>
                                                        <ItemTemplate>
                                                            <table border="1" width="100%" bordercolor="black" style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black">
                                                                <tr>
                                                                    <td>
                                                                        <table border="0" width="100%">
                                                                            <tr>
                                                                                <td>
                                                                                    <table border="0" >
                                                                                        <tr>
                                                                                            <td></td>
                                                                                            <td>
                                                                                                <span class="LabelNormal">Action : </span> <span class="OutputText"><%# DataBinder.Eval(Container.DataItem, "Act") %> </span> 
                                                                                            </td>
                                                                                            <td></td>
                                                                                            <td>
                                                                                                <asp:Label id="SeqNo" visible="false" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <ItemTemplate>
                                                                                                    <asp:LinkButton id="LinkButton1" CommandArgument='WhereUseList' runat="server" Font-Size="X-Small" ForeColor="Red" Font-Bold="True">Where Use List / Part Source Details</asp:LinkButton>
                                                                                                    <asp:LinkButton id="Edit" CommandArgument='BOMCost' runat="server" Font-Size="X-Small" ForeColor="Red" Font-Bold="True">WAC BOM Cost</asp:LinkButton>
                                                                                                </ItemTemplate>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" border="1" width="100%">
                                                                                        <tr>
                                                                                            <td width="25%" bgcolor="silver">
                                                                                                <span class="LabelNormal">Part No/Desc/Mfg. part No </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="OutputText"> <asp:Label id="lblPartNo" runat="server" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>' /> 
                                                                                                </asp:TemplateColumn>
                                                    ( <%# DataBinder.Eval(Container.DataItem, "Part_Desc") %>)(<%# DataBinder.Eval(Container.DataItem, "M_Part_No")%>)</span> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="LabelNormal">Specification</span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="OutputText"><%# DataBinder.Eval(Container.DataItem, "Part_Spec") %> </span> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="LabelNormal">Remarks</span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="OutputText"><%# DataBinder.Eval(Container.DataItem, "Rem") %> </span> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="LabelNormal">Validity</span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="OutputText"><asp:Label id="Validity" cssclass= "ListOutput" width= "100%" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Validity") %>' /> </span> 
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" border='1' width="100%">
                                                                                        <tr>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">Supplier(C) 
                                                                                                <br />
                                                                                                Supplier(N) </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">U/P(C) 
                                                                                                <br />
                                                                                                U/P(N) </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel"> 
                                                                                                <br />
                                                                                                WAC</span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">Diff(Amt) 
                                                                                                <br />
                                                                                                Diff(%) </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">L/T(C) 
                                                                                                <br />
                                                                                                L/T (N) </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">SPQ(C) 
                                                                                                <br />
                                                                                                SPQ(N) </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">MOQ(C) 
                                                                                                <br />
                                                                                                MOQ(N) </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">Can.(C) 
                                                                                                <br />
                                                                                                Can.(N) </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">Resch(C) 
                                                                                                <br />
                                                                                                Resch(N) </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">Ori. Ven.(C) 
                                                                                                <br />
                                                                                                Ori. Ven. (N) </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">Ori. UP(C) 
                                                                                                <br />
                                                                                                Ori. UP(N) </span> 
                                                                                            </td>
                                                                                            <td bgcolor="silver">
                                                                                                <span class="ListLabel">Ori. Curr(C) 
                                                                                                <br />
                                                                                                Ori. Curr(N) </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Ven_Code_Temp") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Curr_Code") %> <%# DataBinder.Eval(Container.DataItem, "UP") %> (RM <%# DataBinder.Eval(Container.DataItem, "UP_RM") %>) </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"></span> 
                                                                                            </td>
                                                                                            <td ">
                                                                                                <span class="ListOutput"><asp:Label id="DiffAmt" cssclass= "ListOutput" width= "100%" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Diff_Amt") %>' /> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Lead_Time") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "STD_PACK") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "MIN_ORDER_QTY") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Cancel_LT") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Reschedule_lt") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "ORI_VEN_NAME") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "ORI_UP") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "ORI_CURR_CODE") %> </span> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_Ven_Code_Temp") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_Curr_Code") %> <%# DataBinder.Eval(Container.DataItem, "A_UP") %> (RM <%# DataBinder.Eval(Container.DataItem, "A_UP_RM") %>)</span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><asp:Label id="WACCost" cssclass= "ListOutput" width= "100%" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "WAC_COST") %>' /></span> 
                                                                                            </td>
                                                                                            <td >
                                                                                                <span class="ListOutput"><asp:Label id="DiffPctg" width= "100%" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Diff_PCTG") %>' /> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_Lead_Time") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_STD_PACK") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "a_MIN_ORDER_QTY") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_Cancel_LT") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_Reschedule_LT") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_ORI_VEN_NAME") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_ORI_UP") %> </span> 
                                                                                            </td>
                                                                                            <td>
                                                                                                <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "A_ORI_CURR_CODE") %> </span> 
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <br />
                                                        </ItemTemplate>
                                                        <HeaderStyle font-size="XX-Small">
                                                        </HeaderStyle>
                                                    </asp:DataList>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 21px" width="100%" align="right">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdApprove" onclick="cmdApprove_Click" runat="server" Width="134px" Text="Approve"></asp:Button>
                                                                </td>
                                                                <td>
                                                                    <div align="center">
                                                                        <asp:Button id="cmdReject" onclick="cmdReject_Click" runat="server" Width="134px" Text="Reject"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="134px" Text="Back"></asp:Button>
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
