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

    Sub ProcLoadGridData()
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim StrSql as string = "Select iss.qty_reissue,iss.Qty_Other_Scrap,iss.qty_scrap,iss.qty_store,iss.qty_ir,iss.return_type,iss.rem,iss.qty_return,ISS.Part_No,ISS.Qty_Issued,PM.Part_Desc from MRF_D ISS,Part_Master PM where ISS.MRF_NO = '" & trim(lblMRFNo.text) & "' and ISS.PART_No = PM.Part_No"
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
        response.redirect("MRFApp4.aspx")
    End Sub

    Sub ShowMRFDet()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTm.ERP_GTM
        lblJONo.text = ""

        Dim RsSO as SQLDataReader = ReqCOM.ExeDataReader("Select top 1 * from MRF_M where Seq_No = " & request.params("ID") & ";")
        Do while rsSo.read
            lblmrfNo.text = rsSO("MRF_NO").tostring
            lblJONo.text = rsSO("JO_No").tostring
            lblMIFNo.text = rsSO("ISSUING_NO").tostring
            lblLevel.text = rsSO("P_Level").tostring

            lblLotNo.text = ReqCOM.GetFieldVal("Select Lot_No from Job_Order_M where jo_no = '" & trim(lblJONo.text) & "';","lot_No")

            lblModelNo.text = ReqCOm.GetFieldVal("select Model_No from SO_Models_M where Lot_No = '" & trim(lblLotNo.text) & "';","Model_No")
            lblModelDesc.text = ReqCOm.GetFieldVal("select Model_Desc from model_master where model_Code = '" & trim(lblModelNo.text) & "';","Model_Desc")

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
                lblApp3By.text = rsSO("App3_By")
            elseif isdbnull(rsSO("App3_Date")) = true then
                lblApp3by.text = ""
                lblApp3Date.text = ""
            end if

            if isdbnull(rsSO("App4_Date")) = false then
                lblApp4Date.text = format(cdate(rsSO("App4_Date")),"dd/MMM/yy")
                lblApp4By.text = rsSO("App4_By")
            elseif isdbnull(rsSO("App4_Date")) = true then
                lblApp4by.text = ""
                lblApp4Date.text = ""
            end if

            if trim(lblApp4Date.text) <> "" then
                cmdApproved.enabled = false

            elseif trim(lblApp4Date.text) = "" then
                cmdApproved.enabled = true

            end if
        Loop
        RsSO.Close
    End sub

    Sub cmdApproved_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM


        ReqCOM.ExecuteNonQuery("Update MRF_M set App4_By = '" & trim(request.cookies("U_ID").value) & "',App4_Date = '" & now & "',App4_Status = 'Y',MRF_Status = 'APPROVED' where MRF_NO = '" & trim(lblMRFNo.text) & "'")

        if ReqCOM.FuncCheckDuplicate("Select top 1 Qty_Reissue from MRF_D where MRF_No = '" & trim(lblMRFNo.text) & "';","Qty_Reissue") = true then
            Dim MIFNo as string = ReqCOM.GetDocumentNo("ISSUING_NO")
            ReqCOM.ExecuteNonQUery("Update Main set ISSUING_NO = ISSUING_NO + 1")
            ReqCOM.Executenonquery("Update MRF_M set ISSUING_NO = '" & trim(MIFNo) & "' where MRF_NO = '" & trim(lblMRFNo.text) & "';")
            GenerateMIF(MIFNo,trim(lblMRFNo.text))
        End if



        ShowAlert("Selected MRF has been submitted.")
        redirectPage("MRFApp4Det.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub GenerateMIF(IssuingNo as string,MRFNo as string)

        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim JOSize as long = ReqCOM.GetFieldVal("select PROD_QTY from job_order_m where jo_no = '" & trim(lblJONo.text) & "';","PROD_QTY")
        Dim BOMRev as decimal = ReqCOM.GetFieldVal("Select top 1 Revision from BOM_M where Model_No = '" & trim(lblModelNo.text) & "' order by revision desc","Revision")

        ReqCOM.ExecuteNonQuery("Insert into Mat_Issuing_M(ISSUING_NO,JO_NO,P_LEVEL,LOT_SIZE,CREATE_BY,CREATE_DATE,APP1_BY,APP1_DATE,APP2_BY,APP2_DATE,APP2_REM,APP2_STATUS,APP3_BY,APP3_DATE,APP3_REM,APP3_STATUS,APP4_BY,APP4_DATE,APP4_REM,APP4_STATUS,APP5_BY,APP5_DATE,APP5_REM,APP5_STATUS,ISSUING_STATUS) select '" & trim(IssuingNo) & "','" & trim(lblJONo.text) & "','" & trim(lblLevel.text) & "',0,'" & trim(lblSubmitBy.text) & "','" & CDATE(NOW) & "','" & trim(lblSubmitBy.text) & "','" & CDATE(NOW) & "','SYSADMIN','" & CDATE(NOW) & "','','Y','SYSADMIN','" & CDATE(NOW) & "','','Y','SYSADMIN','" & CDATE(NOW) & "','','Y','SYSADMIN','" & CDATE(NOW) & "','','Y','APPROVED'")
        ReqCOM.ExecuteNonQuery("Insert into Mat_Issuing_D(ISSUING_NO,MAIN_PART,PART_NO,QTY_ISSUED,REQ_QTY) select '" & trim(IssuingNo) & "',MAIN_PART,PART_NO,Qty_Reissue,Qty_Reissue from MRF_D where MRF_No = '" & trim(MRFNo) & "';")

        ReqCOM.ExecuteNonQuery("Update Mat_Issuing_D set Mat_Issuing_D.p_usage = bom_d.p_usage from Mat_Issuing_D,bom_d where bom_d.revision = " & BOMRev & " and bom_d.model_no = '" & trim(lblModelNo.text) & "' and bom_d.part_no = mat_issuing_d.main_part and mat_issuing_d.issuing_no = '" & trim(IssuingNo) & "'")
        ReqCOM.ExecuteNonQuery("Update Mat_Issuing_D set total_Usage = P_Usage * " & clng(JOSize) & " where Issuing_no = '" & trim(IssuingNo) & "'")
        

        'ReqCOM.ExecuteNonQuery("Update Mat_Issuing_D set Mat_Issuing_D.p_usage = bom_d.p_usage from Mat_Issuing_D,bom_d where bom_d.revision = " & BOMRev & " and bom_d.model_no = '" & trim(lblModelNo.text) & "' and bom_d.part_no = mat_issuing_d.main_part and mat_issuing_d.issuing_no = '" & trim(IssuingNo) & "'")


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

    Sub ShowPopup(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=500');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowAttachmentPopup", Script.ToString())
    End sub

</script>
<html>
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
                                <asp:Label id="Label3" runat="server" cssclass="FormDesc" width="100%">MRF DETAILS</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 11px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
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
                                                            <td>
                                                                <asp:Label id="Label11" runat="server" cssclass="LabelNormal" width="126px">Lot No</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblLotNo" runat="server" cssclass="OutputText" width="126px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" cssclass="LabelNormal" width="126px">Issuing
                                                                NO</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblMIFNo" runat="server" cssclass="OutputText" width="126px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Model No/Description</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblModelNo" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblModelDesc" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                            </td>
                                                            <td>
                                                                <asp:Label id="lblLevel" runat="server" cssclass="OutputText" width="126px"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label10" runat="server" cssclass="LabelNormal" width="126px">Submit
                                                                By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText"></asp:Label></td>
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
                                                                <asp:Label id="Label7" runat="server" cssclass="LabelNormal" width="126px">IQC by/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp3By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp3Date" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label8" runat="server" cssclass="LabelNormal" width="126px">Store By/Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblApp4By" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblApp4Date" runat="server" cssclass="OutputText"></asp:Label></td>
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
                                                            <asp:TemplateColumn HeaderText="PART NO">
                                                                <ItemTemplate>
                                                                    <asp:Label id="PartNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PART_NO") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:BoundColumn DataField="Part_Desc" HeaderText="Description"></asp:BoundColumn>
                                                            <asp:TemplateColumn HeaderText="Qty Return">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyReturn" cssclass="OutputText" runat="server" align="right" columns="8" maxlength="6" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Return") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Good">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyToStore" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Store") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="IR">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyToIR" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_IR") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Scrap">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyScrap" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Scrap") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Others">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyOtherScrap" runat="server" columns="8" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Other_Scrap") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="ReIssue">
                                                                <ItemTemplate>
                                                                    <asp:Label id="QtyReissue" runat="server" columns="8" cssclass="OutputText" text='<%# DataBinder.Eval(Container.DataItem, "Qty_Reissue") %>' />
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
