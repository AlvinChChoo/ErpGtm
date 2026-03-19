<%@ Page Language="VB" debug="true" %>
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

    Public TotalAmt as decimal
        Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
            if page.isPostBack = false then
                Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
                lblPRNo.text = ReqCOm.GetFieldVal("select top 1 PR_No from pr1_m where Seq_No = " & trim(request.params("ID")) & ";","PR_No")
                LoadPO
                FormatRow()
                lblRem1.text = cint(MyList.items.count) & " items have been selected to reject."
            end if
        End Sub

        Sub FormatRow()
            Dim i As Integer
            Dim ReqDate,PRDate,RowSeq,OrderQty as label

            For i = 0 To MyList.Items.Count - 1
                OrderQty = CType(MyList.Items(i).FindControl("OrderQty"), Label)
                ReqDate = CType(MyList.Items(i).FindControl("ReqDate"), Label)
                PRDate = CType(MyList.Items(i).FindControl("PRDate"), Label)
                RowSeq = CType(MyList.Items(i).FindControl("RowSeq"), Label)
                ReqDate.text = format(cdate(ReqDate.text),"dd/MM/yy")
                PRDate.text = format(cdate(PRDate.text),"dd/MM/yy")
                OrderQty.text = clng(OrderQty.text)
                RowSeq.text = i + 1
            Next
        End sub

    sub LoadPO()
        Dim ReqCOM as ERp_Gtm.Erp_Gtm = new ERP_Gtm.ERp_Gtm
        Dim StrSql as string = "SELECT pr.calculated_qty,pr.Item_Buyer_Rem,pm.part_spec,pm.m_part_no,pr.sel,PR.Item_Rem,pm.part_desc,pr.moq,pr.spq,PM.Buyer_Code,PR.Approval_No,PR.Approved,PR.VARIANCE,PR.mrp_no,PR.SO_TYPE,PR.REQ_DATE,PR.QTY_TO_BUY,PR.pr_qty,PR.pr_date,PR.up,PR.seq_no,PR.part_no,ven.ven_NAME FROM pr1_d PR, vendor ven, Part_Master PM WHERE pr.ven_code = ven.ven_code and PR.Part_No = PM.Part_No and pr_no = '" & trim(lblPRNo.text) & "' and item_sel = 'Y' order by PR.Part_no,pr.req_date asc"
        Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
        myConnection.Open()
        Dim myCommand As SqlCommand = New SqlCommand(strsql, myConnection)
        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        MyList.DataSource = result
        MyList.DataBind()
    end sub

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

    Sub cmdBack_Click(sender As Object, e As EventArgs)
        Response.redirect("PRApp1Det.aspx?ID=" & trim(request.params("ID")))
    End Sub

    Sub GenerateMail(Sender as string, Receiver as string,CC as string)
        Dim objEmail as New MailMessage()
        Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
        Dim StrMsg as string
        Dim TotalQty as decimal
        Dim TotalAmt as Decimal
        Dim POTotal as Decimal
        Dim ObjAttachment as MailAttachment

        StrMsg = "Dear " & ReqCOM.GetFieldVal("Select U_Name from User_Profile where EMail = '" & trim(Receiver) & "';","U_Name")  & vblf & vblf & vblf
        StrMsg = StrMsg + "There is a P/R submitted by Buyer pending for your approval." & vblf & vblf & vblf
        StrMsg = StrMsg + "Click on http://gtekapp/erp/signin.aspx?ReturnURL=PRApp2Det.aspx?ID=" & ReqCOM.GetFieldVal("Select Seq_No from PR1_M where PR_No = '" & trim(lblPRNo.text) & "';","Seq_No") & " to view the details."   & vblf & vblf
        StrMsg = StrMsg + "For assistance, please contact " & ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf  & vblf & vblf
        StrMsg = StrMsg + "Regards," & vblf & vblf
        StrMsg = StrMsg + ReqCOM.GetFieldval("Select U_Name from User_Profile where EMail = '" & trim(Sender) & "';","U_Name") & vblf & vblf
        objEmail.Subject  = "P/R Pending Approval : " & trim(lblPRNo.text)

        objEmail.To       = trim(Receiver)
        objEmail.From     = trim(Sender)
        objEmail.CC       = trim(CC)
        objEmail.Body     = StrMsg
        objEmail.Priority = MailPriority.High
        SmtpMail.SmtpServer  = "192.168.42.111"
        SmtpMail.Send(objEmail)
    End sub

    Sub cmdReject_Click(sender As Object, e As EventArgs)
        if page.isvalid = true then
            Dim i as integer
            Dim ReqCOM as Erp_Gtm.ERP_Gtm = new ERp_Gtm.Erp_Gtm
            Dim StrSql,PRNo as string
            Dim SeqNo As Label
            Dim ItemBuyerRem as TextBox
            PRNo = ReqCOM.GetDocumentNo("PR_No")

            StrSql = ""

            For i = 0 To MyList.Items.Count - 1
                SeqNo = CType(MyList.Items(i).FindControl("lblSeqNo"), Label)

                if trim(strsql) = "" then
                    StrSql = trim(SeqNo.text)
                elseif trim(strsql) <> "" then
                    StrSql = StrSql & "," & trim(SeqNo.text)
                end  if
            Next i
            StrSql = "(" & trim(StrSql) & ")"

            UpdateRejRemarks
            ReqCOM.ExecuteNonQuery ("Update PR1_D set PR_No = '" & trim(PRNo) & "' where seq_no in " & trim(StrSql) & "")
            ReqCOM.ExecuteNonQuery("Insert into pr1_m(PR_NO,MRP_NO,PR_SOURCE,PR_DATE,STATUS,TO_PURC,SOURCE,CREATE_BY,CREATE_DATE,Buyer_Code,PR_STATUS,PR_TYPE) select '" & trim(PRNo) & "',MRP_NO,PR_SOURCE,PR_DATE,STATUS,TO_PURC,SOURCE,CREATE_BY,CREATE_DATE,Buyer_Code,PR_STATUS,PR_TYPE from pr1_m where pr_no = '" & trim(lblPRNo.text) & "';")
            ReqCOM.ExecuteNonQuery("Update Main set PR_No = PR_No + 1")
            ShowAlert("Selected parts has been rejected.\nNew generated PR no : " & trim(PRNo))
            redirectPage("PRApp1Det.aspx?ID=" & Request.params("ID"))
        End if
    End Sub

    Sub UpdateRejRemarks
        Dim i as integer
        Dim ReqCOM as Erp_Gtm.ERP_Gtm = new ERp_Gtm.Erp_Gtm
        Dim StrSql,PRNo as string
        Dim SeqNo As Label
        Dim ItemBuyerRem as TextBox
        PRNo = ReqCOM.GetDocumentNo("PR_No")

        StrSql = ""

        For i = 0 To MyList.Items.Count - 1
            ItemBuyerRem = CType(MyList.Items(i).FindControl("ItemBuyerRem"), Textbox)
            SeqNo = CType(MyList.Items(i).FindControl("SeqNo"), Label)
            ReqCOM.ExecuteNonQUery("Update PR1_D set Item_Buyer_Rem = '" & trim(ItemBuyerRem.text) & "' where Seq_No = " & clng(SeqNo.text) & ";")
        Next i
    End sub

    Sub MyList_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub

    Sub ValRemVal_ServerValidate(sender As Object, e As ServerValidateEventArgs)
        Dim i as integer
        Dim ItemBuyerRem As Textbox
        For i = 0 To MyList.Items.Count - 1
            ItemBuyerRem = CType(MyList.Items(i).FindControl("ItemBuyerRem"), Textbox)
            if trim(ItemBuyerRem.text) = "" then ValRemVal.errorMessage = "Error Line " & i + 1 & " : Invalid Remarks." : e.isvalid = false
        Next i
    End Sub

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
    <form runat="server">
        <p>
            <table style="HEIGHT: 184px" height="184" cellspacing="0" cellpadding="0" width="100%" border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <IBUYSPY:HEADER id="UserControl2" runat="server"></IBUYSPY:HEADER>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" nowrap="nowrap" align="left" width="100%">
                            <p align="center">
                                <asp:Label id="Label2" runat="server" cssclass="FormDesc" width="100%">P/R BUYER REJECTED
                                PARTS </asp:Label>
                            </p>
                            <p align="center">
                                <asp:CustomValidator id="ValRemVal" runat="server" Width="100%" EnableClientScript="False" OnServerValidate="ValRemVal_ServerValidate" CssClass="ErrorText" ForeColor=" " Display="Dynamic" ErrorMessage="Invalid remarks"></asp:CustomValidator>
                            </p>
                            <p align="center">
                                <asp:Label id="lblPRNo" runat="server" visible="False"></asp:Label>
                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <p align="center">
                                                    <asp:DataList id="MyList" runat="server" Width="90%" OnSelectedIndexChanged="MyList_SelectedIndexChanged" Height="101px" RepeatColumns="1" BorderWidth="0px" CellPadding="1">
                                                        <SelectedItemStyle font-size="XX-Small"></SelectedItemStyle>
                                                        <EditItemStyle font-size="XX-Small"></EditItemStyle>
                                                        <AlternatingItemStyle font-size="XX-Small"></AlternatingItemStyle>
                                                        <SeparatorStyle font-size="XX-Small"></SeparatorStyle>
                                                        <ItemStyle font-size="XX-Small"></ItemStyle>
                                                        <ItemTemplate>
                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                <tbody>
                                                                    <tr>
                                                                        <td width= "20%" bgcolor= "silver" valign= "top">
                                                                            <asp:Label id="lblSeqNo" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>'></asp:Label> <asp:Label id="RowSeq" runat="server" text= '1' cssclass= "ErrorText"></asp:Label> <asp:Label id="lblRejRem" runat="server" cssclass= "OutputText" text= 'Rej ? / Buyer Rem :' ></asp:Label>
                                                                        </td>
                                                                        <td valign= "top">
                                                                            <asp:Textbox id="ItemBuyerRem" runat="server" cssclass= "OutputText" width= "500px" text='<%# DataBinder.Eval(Container.DataItem, "Item_Buyer_Rem") %>'></asp:Textbox>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                <tbody>
                                                                    <tr>
                                                                        <td bgcolor="silver" width= "10%">
                                                                            <asp:Label id="label1" runat="server">Part #</asp:Label>
                                                                        </td>
                                                                        <td>
                                                                            <asp:Label id="PartNo" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_No") %>'></asp:Label> <asp:Label id="SeqNo" cssclass="ListOutput" runat="server" visible= "false" text='<%# DataBinder.Eval(Container.DataItem, "Seq_no") %>'></asp:Label>
                                                                        </td>
                                                                        <td bgcolor="silver" width= "10%">
                                                                            <asp:Label id="Label4" runat="server">Description</asp:Label>
                                                                        </td>
                                                                        <td >
                                                                            <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "Part_Desc") %> </span>
                                                                        </td>
                                                                        <td bgcolor="silver" width= "10%">
                                                                            <asp:Label id="Label3" runat="server">Mfg Part #</asp:Label>
                                                                        </td>
                                                                        <td >
                                                                            <span class="ListOutput"><%# DataBinder.Eval(Container.DataItem, "M_part_no") %> </span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td bgcolor="silver" width= "10%">
                                                                            <asp:Label id="label11" runat="server">Spec</asp:Label>
                                                                        </td>
                                                                        <td colspan="5">
                                                                            <asp:Label id="PartSpec" cssclass="ListOutput" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Part_Spec") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td bgcolor="silver" width= "10%" >
                                                                            <asp:Label id="label1111" runat="server">Supplier</asp:Label>
                                                                        </td>
                                                                        <td >
                                                                            <asp:Label id="label1121" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ven_Name") %>'></asp:Label>
                                                                        </td>
                                                                        <td bgcolor="silver" width= "10%">
                                                                            <asp:Label id="label1132" runat="server">MOQ</asp:Label>
                                                                        </td>
                                                                        <td >
                                                                            <asp:Label id="label1142" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "MOQ") %>'></asp:Label>
                                                                        </td>
                                                                        <td bgcolor="silver" width= "10%">
                                                                            <asp:Label id="label1153" runat="server">SPQ</asp:Label>
                                                                        </td>
                                                                        <td >
                                                                            <asp:Label id="label1163" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "SPQ") %>'></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                            <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                                <tr>
                                                                    <td bgcolor="silver" width= "15%">
                                                                        <asp:Label id="label11632" cssclass="LabelNormal" runat="server" text='P/R Date'></asp:Label>
                                                                    </td>
                                                                    <td bgcolor="silver" width= "15%">
                                                                        <asp:Label id="label11631" cssclass="LabelNormal" runat="server" text='Req. Date'></asp:Label>
                                                                    </td>
                                                                    <td bgcolor="silver" width= "14%">
                                                                        <asp:Label id="label11633" cssclass="LabelNormal" runat="server" text='P/R Qty'></asp:Label>
                                                                    </td>
                                                                    <td bgcolor="silver" width= "14%">
                                                                        <asp:Label id="label11634" cssclass="LabelNormal" runat="server" text='Order Qty'></asp:Label>
                                                                    </td>
                                                                    <td bgcolor="silver" width= "14%">
                                                                        <asp:Label id="label11635" cssclass="LabelNormal" runat="server" text='U/P'></asp:Label>
                                                                    </td>
                                                                    <td bgcolor="silver" width= "14%">
                                                                        <asp:Label id="label11636" cssclass="LabelNormal" runat="server" text='Amt'></asp:Label>
                                                                    </td>
                                                                    <td bgcolor="silver" width= "14%">
                                                                        <asp:Label id="label116361" cssclass="LabelNormal" runat="server" text='Adj Qty.'></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:Label id="PRDate" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Date") %>'></asp:Label>
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label id="ReqDate" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Req_Date") %>'></asp:Label>
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label id="PRQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PR_Qty") %>'></asp:Label>
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label id="OrderQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Calculated_qty") %>'></asp:Label>
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label id="UP" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>'></asp:Label>
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label id="Amt" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") * DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>'></asp:Label>
                                                                    </td>
                                                                    <td>
                                                                        <asp:Label id="AdjQty" cssclass="OutputText" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Qty_To_Buy") %>'></asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <br />
                                                        </ItemTemplate>
                                                        <HeaderStyle font-size="XX-Small"></HeaderStyle>
                                                    </asp:DataList>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="lblRem1" runat="server" cssclass="Instruction" width="100%"></asp:Label>
                                                </p>
                                                <p align="center">
                                                    <asp:Label id="Label1" runat="server" cssclass="Instruction" width="100%">You will
                                                    not be able to undo the changes after submission.</asp:Label><asp:Label id="Label4" runat="server" cssclass="Instruction">Are
                                                    you sure you want to proceed to reject selected parts ?</asp:Label>
                                                </p>
                                                <p align="center">
                                                    <table style="HEIGHT: 5px" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdReject" onclick="cmdReject_Click" runat="server" Width="71px" CssClass="OutputText" Text="Yes"></asp:Button>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div align="left">&nbsp;&nbsp;&nbsp;&nbsp;
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="71px" CssClass="OutputText" Text="No" CausesValidation="False"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </p>
                                                <p align="center">
                                                </p>
                                                <p>
                                                    <table style="HEIGHT: 17px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="25%">
                                                                    <div align="left">
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="center">
                                                                    </div>
                                                                </td>
                                                                <td width="25%">
                                                                    <div align="right">
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
    <!-- Insert content here -->
</body>
</html>
