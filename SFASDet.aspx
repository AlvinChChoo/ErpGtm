<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="System.Web.Mail" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            loadGridData
            ProcLoadGridData
        End if
    End Sub

    Sub loadGridData()
        Dim strSql as string = "SELECT * FROM SFAS_M where SEQ_NO = " & request.params("ID") & ";"
        Dim ReqCOM as Erp_Gtm.Erp_Gtm  = new Erp_Gtm.Erp_Gtm
        Dim rs as SQLDataReader = ReqCOM.ExeDataReader(strSql)
        do while rs.read
            lblSFASNo.text = rs("SFAS_No").tostring
            txtRem.text = rs("Submit_rem").tostring

            if isdbnull(rs("submit_date")) = false then
                lblSubmitBy.text = rs("Submit_By")
                lblSubmitDate.text = format(cdate(rs("Submit_Date")),"dd/MM/yy")
                cmdAddNew.enabled = false
                cmdSubmit.enabled = false
                cmdUpdate.enabled = false
            else
                cmdAddNew.enabled = true
                cmdSubmit.enabled = true
                cmdUpdate.enabled = true
            end if

            if isdbnull(rs("App1_Date")) = false then
                lblApp1By.text = rs("App1_By")
                lblApp1Date.text = format(cdate(rs("App1_Date")),"dd/MM/yy")
            end if

            if isdbnull(rs("App2_Date")) = false then
                lblApp2By.text = rs("App2_By")
                lblApp2Date.text = format(cdate(rs("App2_Date")),"dd/MM/yy")
            end if



        loop
    end sub

    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim ForecastDate As Label = CType(e.Item.FindControl("ForecastDate"), Label)
            Dim lblSeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
            Dim SOQty As Label = CType(e.Item.FindControl("SOQty"), Label)
            Dim ForecastDateTemp As Label = CType(e.Item.FindControl("ForecastDateTemp"), Label)
            Dim ModelNo As Label = CType(e.Item.FindControl("ModelNo"), Label)
            Dim Variance As Label = CType(e.Item.FindControl("Variance"), Label)
            Dim Amt As Label = CType(e.Item.FindControl("Amt"), Label)
            Dim UP As Label = CType(e.Item.FindControl("UP"), Label)

            select case month(cdate(ForecastDate.text))
                case 1 : ForecastDate.text = "Jan, " & year(cdate(ForecastDate.text))
                case 2 : ForecastDate.text = "Feb, " & year(cdate(ForecastDate.text))
                case 3 : ForecastDate.text = "Mar, " & year(cdate(ForecastDate.text))
                case 4 : ForecastDate.text = "Apr, " & year(cdate(ForecastDate.text))
                case 5 : ForecastDate.text = "May, " & year(cdate(ForecastDate.text))
                case 6 : ForecastDate.text = "June, " & year(cdate(ForecastDate.text))
                case 7 : ForecastDate.text = "July, " & year(cdate(ForecastDate.text))
                case 8 : ForecastDate.text = "Aug, " & year(cdate(ForecastDate.text))
                case 9 : ForecastDate.text = "Sep, " & year(cdate(ForecastDate.text))
                case 10 : ForecastDate.text = "Oct, " & year(cdate(ForecastDate.text))
                case 11 : ForecastDate.text = "Nov, " & year(cdate(ForecastDate.text))
                case 12 : ForecastDate.text = "Dec, " & year(cdate(ForecastDate.text))
            end select

            up.text = format(cdec(up.text),"##,##0.00000")
            Amt.text = format(cdec(Amt.text),"##,##0.00")

            if ReqCom.funcCheckDuplicate("Select Order_Qty from SO_ModelS_M where Model_No = '" & trim(ModelNo.text) & "' and month(REQ_DATE) = " & month(cdate(ForecastDateTemp.text)) & " and year(REQ_DATE) = " & year(cdate(ForecastDateTemp.text)) & ";","Order_Qty") = true then
                SOQty.text = ReqCOM.GetFieldVal("Select sum(Order_Qty) as [TotalOrderQty] from SO_Models_M where Model_No = '" & trim(ModelNo.text) & "' and month(REQ_Date) = " & month(cdate(ForecastDateTemp.text)) & " and year(req_Date) = " & year(cdate(ForecastDateTemp.text)) & ";","TotalOrderQty")
            else
                SOQty.text = "0"
            end if
            Variance.text = format(cdec((SOQty.text * UP.text) - Amt.text),"##,##0.00")
        End if
    End Sub

    Sub ShowSFAS(sender as Object,e as DataGridCommandEventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim SeqNo As Label = CType(e.Item.FindControl("lblSeqNo"), Label)
        ShowReport("PopupSFASEdit.aspx?ID=" & trim(SeqNo.text))
    End sub

    Sub dtgUPASAttachment_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
    End Sub

    Sub ProcLoadGridData
        Dim StrSql as string = "select sf.seq_no,mm.cust_code,MM.MODEL_DESC,SF.MODEL_NO,sf.forecast_date,SF.FORECAST_QTY,SF.UP,Cust.Curr_Code,sf.amt from SFAS_D SF, MODEL_MASTER MM,cust where sfas_no = '" & trim(lblSFASNo.text) & "' AND MM.model_code = SF.MODEL_NO AND MM.CUST_CODE = CUST.CUST_CODE"
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"SFAS_D")
        GridControl1.DataSource=resExePagedDataSet.Tables("SFAS_D").DefaultView
        GridControl1.DataBind()
    end sub

    Sub cmdBack_Click_1(sender As Object, e As EventArgs)
        Response.redirect("SFAS.aspx")
    End Sub

    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as erp_gtm.erp_gtm = new erp_gtm.erp_gtm
        ReqCOM.ExecuteNonQuery("Update SFAS_M set Submit_By = '" & trim(request.cookies("U_ID").value) & "', Submit_Date = '" & now & "',sfas_status = 'PENDING APPROVAL' where SFAS_No = '" & trim(lblSFASNo.text) & "';")
        ShowAlert("Selected Sales Forecast has been submitted.")
        redirectPage("SFASDet.aspx?ID=" & Request.params("ID"))
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

    Sub cmdAddNew_Click(sender As Object, e As EventArgs)
        ShowReport("PopupSFASItem.aspx?ID=" & request.params("ID"))
    End Sub

    Sub ShowReport(ReturnURL as string)
        Dim Script As New System.Text.StringBuilder
        Script.Append("<script language=javascript>")
        Script.Append("pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        Script.Append("</script" & ">")
        RegisterStartupScript("ShowExistingSupplier", Script.ToString())
    End sub

    Sub cmdRefresh_Click(sender As Object, e As EventArgs)
        Response.redirect("SFASDet.aspx?ID=" & Request.params("ID"))
    End Sub

    Sub cmdUpdate_Click(sender As Object, e As EventArgs)
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM

        ReqCOM.ExecuteNonQuery("Update SFAS_M set Submit_rem = '" & trim(replace(txtRem.text,"'","`")) & "' where SFAS_No = '" & trim(lblSFASNo.text) & "';")
        ShowAlert("Sales Forecast updated.")
        redirectPage("SFASDet.aspx?ID=" & Request.params("ID"))
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 5px" cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td>
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">SALES FORECAST
                                APPROVAL SHEET</asp:Label>
                            </p>
                            <p align="center">
                                <table style="HEIGHT: 3px" cellspacing="0" cellpadding="0" width="96%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" align="center" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label3" runat="server" cssclass="LabelNormal">SFAS No</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSFASNo" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label9" runat="server" cssclass="LabelNormal">Submitted By / Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblSubmitBy" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;- <asp:Label id="lblSubmitDate" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label1" runat="server" cssclass="LabelNormal">Verified By / Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp1By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;
                                                                    -&nbsp; <asp:Label id="lblApp1Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="silver">
                                                                    <asp:Label id="Label4" runat="server" cssclass="LabelNormal">Approved By / Date</asp:Label></td>
                                                                <td>
                                                                    <asp:Label id="lblApp2By" runat="server" cssclass="OutputText" width=""></asp:Label>&nbsp;
                                                                    -&nbsp; <asp:Label id="lblApp2Date" runat="server" cssclass="OutputText" width=""></asp:Label></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="25%" bgcolor="silver">
                                                                    <asp:Label id="Label5" runat="server" cssclass="LabelNormal">Remarks</asp:Label></td>
                                                                <td>
                                                                    <asp:TextBox id="txtRem" runat="server" MaxLength="200" CssClass="OutputText" Width="100%"></asp:TextBox>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                    <asp:DataGrid id="GridControl1" runat="server" Width="100%" OnEditCommand="ShowSFAS" AllowSorting="True" OnSortCommand="SortGrid" AutoGenerateColumns="False" cellpadding="4" GridLines="Vertical" BorderColor="Black" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" Font-Names="Verdana" Font-Name="Verdana" Font-Size="XX-Small" OnItemDataBound="FormatRow" PagerStyle-HorizontalAligh="Right">
                                                        <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                        <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                        <ItemStyle cssclass="GridItem"></ItemStyle>
                                                        <HeaderStyle bordercolor="White" cssclass="GridHeader"></HeaderStyle>
                                                        <Columns>
                                                            <asp:EditCommandColumn ButtonType="LinkButton" UpdateText="" CancelText="" EditText="View"></asp:EditCommandColumn>
                                                            <asp:TemplateColumn visible="false">
                                                                <ItemTemplate>
                                                                    <asp:Label id="lblSeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Cust #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CustCode" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Cust_Code") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Model #">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ModelNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_No") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Forecast Month">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ForecastDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Forecast_Date") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn Visible="False">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ForecastDateTemp" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Forecast_Date") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Forecast Qty">
                                                                <ItemTemplate>
                                                                    <asp:Label id="ForecastQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Forecast_Qty") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="U/P">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Currency">
                                                                <ItemTemplate>
                                                                    <asp:Label id="CurrCode" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Curr_Code") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Amount">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="Amt" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Amt") %>' />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="S/O Qty">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="SOQty" runat="server" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                            <asp:TemplateColumn HeaderText="Variance">
                                                                <HeaderStyle horizontalalign="Right"></HeaderStyle>
                                                                <ItemStyle horizontalalign="Right"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:Label id="Variance" runat="server" />
                                                                </ItemTemplate>
                                                            </asp:TemplateColumn>
                                                        </Columns>
                                                        <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                    </asp:DataGrid>
                                                </p>
                                                <p align="right">
                                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="20%">
                                                                    <asp:Button id="cmdAddNew" onclick="cmdAddNew_Click" runat="server" Width="123px" Text="Add New Item"></asp:Button>
                                                                </td>
                                                                <td width="20%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdSubmit" onclick="cmdSubmit_Click" runat="server" Width="123px" Text="Submit"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="20%">
                                                                    <div align="center">
                                                                        <asp:Button id="cmdUpdate" onclick="cmdUpdate_Click" runat="server" Width="90px" Text="Update"></asp:Button>
                                                                    </div>
                                                                </td>
                                                                <td width="20%">
                                                                    <div align="center">
                                                                        <div align="center">
                                                                            <asp:Button id="cmdRefresh" onclick="cmdRefresh_Click" runat="server" Width="123px" Text="Refresh"></asp:Button>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td width="20%">
                                                                    <p align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click_1" runat="server" Width="123px" Text="Back"></asp:Button>
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
</body>
</html>
