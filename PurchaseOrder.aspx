<%@ Page Language="VB" Debug="true" %>
<%@ Register TagPrefix="IBuySpy" TagName="Header" Src="_Header.ascx" %>
<%@ Register TagPrefix="Footer" TagName="Footer" Src="_Footer.ascx" %>
<%@ Register TagPrefix="cr" Namespace="CrystalDecisions.Web" Assembly="CrystalDecisions.Web, Version=10.0.3300.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" %>
<%@ import Namespace="System.data" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.configuration" %>
<%@ import Namespace="System.data.sqlclient" %>
<%@ import Namespace="System.Collections" %>
<%@ import Namespace="System.Web.Mail" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Web.UI.WebControls" %>
<%@ import Namespace="CrystalDecisions.Web" %>
<%@ import Namespace="CrystalDecisions.Shared" %>
<%@ import Namespace="CrystalDecisions.CrystalReports.Engine" %>
<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        if page.isPostBack = false then
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            lblSenderEMail.text = ReqCOM.GetFieldVal("select PO_Email from main","PO_Email")
            LoadDataWithSource()
        end if
    End Sub
    
    Private Sub dtgPartWithSource_ItemCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ReturnURL as string
    
            'Dim lnkDelete As LinkButton = CType(e.Item.Cells(0).Controls(0), LinkButton)
            'ReturnURL = "Signin.aspx"
            'lnkDelete.Attributes.Add("onclick", "pupUp=window.open(""" & ReturnURL & """,'','toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=1,width=750,height=250');")
        End If
    
        'If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
        '    Dim lnkDelete As LinkButton = CType(e.Item.Cells(0).Controls(0), LinkButton)
        '    lnkDelete.Attributes.Add("onclick", "return confirm('Are you sure you want to delete this record?');")
    
        '    Dim btnDelete As Button = CType(e.Item.Cells(1).Controls(0), Button)
        '    btnDelete.Attributes.Add("onclick", "return confirm('Are you sure you want to delete this record?');")
        'End If
    End Sub
    
    Sub LoadDataWithSource()
        Dim ReqCom as Erp_Gtm.ERp_Gtm = new ERP_GTM.ERP_GTM
        Dim StrSql as string = "Select ven.EMAIL_PO,po.Send_By,po.send_date, PO.PO_NO, VEN.VEN_CODE + '-' + left(VEN.VEN_NAME,15) + '...' AS [VEN_CODE],PO.PO_DATE,PO.SEQ_NO,VEN.CURR_CODE,VEN.SHIP_TERM,PO.PAY_TERM from PO_M PO, Vendor ven where " & TRIM(CMBBY.SELECTEDITEM.VALUE) & " LIKE '%" & TRIM(TXTsEARCH.TEXT) & "%' AND VEN.VEN_CODE = PO.VEN_CODE order by PO.PO_No desc"
        Dim resExePagedDataSet as Dataset = ReqCOM.ExePagedDataSet(StrSql,"PO_M")
        dtgPartWithSource.DataSource=resExePagedDataSet.Tables("PO_M").DefaultView
        dtgPartWithSource.DataBind()
    end sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim SendDate,PODate As Label
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            PODate = CType(e.Item.FindControl("PODate"), Label)
            SendDate = CType(e.Item.FindControl("SendDate"), Label)
            PODate.text = format(cdate(PODate.text),"dd/MM/yy")
            if trim(SendDate.text) <> "" then SendDate.text = format(cdate(SendDate.text),"dd/MM/yy")
        End if
    End Sub
    
    Sub dtgPartWithSource_SelectedIndexChanged(sender As Object, e As EventArgs)
    End Sub
    
    Protected Sub SortGrid(ByVal sender As [Object], ByVal e As DataGridSortCommandEventArgs)
        LoadDataWithSource()
    End Sub
    
    Sub cmdBack_Click(sender As Object, e As EventArgs)
        response.redirect("Default.aspx")
    End Sub
    
    Sub cmdSearch_Click(sender As Object, e As EventArgs)
        LoadDataWithSource()
    End Sub
    
    Sub cmdEMail_Click(sender As Object, e As EventArgs)
        Dim i as integer
        Dim SupplierEMail as string
        Dim ReqCOM as Erp_Gtm.ERp_Gtm = new ERp_Gtm.Erp_Gtm
        Dim POTotal as decimal
    
        For i = 0 To dtgPartWithSource.Items.Count - 1
            Dim Mail As CheckBox = CType(dtgPartWithSource.Items(i).FindControl("Mail"), CheckBox)
            if mail.checked = true then
                POTotal = 0
                POTotal = ReqCOM.GetFieldVal("Select sum((PO_D.ORDER_QTY + PO_D.FOC_QTY) * UP) as [POTotal] from po_d where po_d.po_no = '" & trim(dtgPartWithSource.Items(i).Cells(1).Text) & "';","POTotal")
                ReqCOM.ExecuteNonquery("Update PO_M set Amt_E = '" & trim(NoToWords(POTotal)) & "' where po_no = '" & trim(dtgPartWithSource.Items(i).Cells(1).Text) & "';")
                SupplierEMail = ReqCOM.GetFieldVal("Select eMAIL_po from vendor where Ven_Code in (Select Ven_Code from po_m where PO_NO = '" & trim(dtgPartWithSource.Items(i).Cells(1).Text) & "')","EMAIL_PO")
                REQcom.ExecuteNonQuery("Update PO_M set Send_By = '" & trim(request.cookies("U_ID").value) & "', Send_Date = '" & now & "' where po_no = '" & trim(dtgPartWithSource.Items(i).Cells(1).Text) & "';")
                rEQcom.eXECUTEnONqUERY("Insert into PO_EMail_Trail(send_by,send_date,PO_No) select '" & trim(request.cookies("U_ID").value) & "','" & now & "','" & trim(dtgPartWithSource.Items(i).Cells(1).Text) & "'")
                GeneratePO1(SupplierEMail,dtgPartWithSource.Items(i).Cells(1).Text)
                ShowAlert ("Selected P/O has been email to supplier.")
                redirectPage("PurchaseOrder.aspx")
            end if
        Next i
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
    
    Sub GeneratePO1(SupplierEMail as string,PONo as string)
        if page.isvalid = true then
            Dim objEmail as New MailMessage()
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim StrMsg as string
            Dim TotalQty as decimal
            Dim TotalAmt as Decimal
            Dim POTotal as Decimal
            Dim ObjAttachment as MailAttachment
            Dim SupplierName,SupplierCode,Add1,Add2,Add3,PaymentTerm,ShipTerm,Note,Currency,CreatedBy,PODate,ModifiedDate,CreatedDate,Modifiedby as string
            Dim rsGeneratePO as SQLDataReader = ReqCOM.ExeDataReader("Select * from PO_M where PO_No = '" & trim(PONo) & "';")
            Dim CompanyName, CompanyAdd1,CompanyAdd2,CompanyTel,POEmail,CompanyFax as STRING
    
            ReqCOM.ExecuteNonQuery("Update PO_M set ind = 'N'")
            ReqCOM.ExecuteNonQuery("Update PO_M set ind = 'Y' where po_no = '" & trim(PONo) & "';")
    
            GenerateAttachment
            objEmail.To       = trim(SupplierEMail)
            objEmail.From     = trim(lblSenderEMail.text)
            objEmail.Subject  = "Test Run : Purchase Order : " & PONo
            objEmail.Body     = StrMsg
            objEmail.Priority = MailPriority.High
            objEmail.BodyFormat = MailFormat.HTML
            ObjAttachment = New MailAttachment ((Mappath("") + "\Report\PurchaseOrder.pdf"))
            objEmail.Attachments.ADD(ObjAttachment)
            ObjAttachment = New MailAttachment ((Mappath("") + "\" + "logo.jpg"))
            objEmail.Attachments.ADD(ObjAttachment)
    
            SmtpMail.SmtpServer  = "192.168.42.111"
            SmtpMail.Send(objEmail)
        End if
    End sub
    
        Sub GenerateAttachment
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim RptnAME as string = "PurchaseOrder"
            Dim repDoc As New ReportDocument()
            repDoc.Load(Mappath("") + "\Report\" & trim(RptName) & ".rpt")
            Dim subRepDoc As New ReportDocument()
            Dim myDBName as string = "erp_gtm"
            Dim myOwner as string = "dbo"
            Dim crSections As Sections
            Dim crSection As Section
            Dim crReportObjects As ReportObjects
            Dim crReportObject As ReportObject
            Dim crSubreportObject As SubreportObject
            Dim crDatabase As Database
            Dim crTables As Tables
            Dim crTable As CrystalDecisions.CrystalReports.Engine.Table
            Dim RptTitle as string
            Dim crLogOnInfo As TableLogOnInfo
            Dim crConnInfo As New ConnectionInfo()
    
            crDatabase = repDoc.Database
            crTables = crDatabase.Tables
    
            For Each crTable In crTables
                With crConnInfo
                    .ServerName = ConfigurationSettings.AppSettings("ServerName")
                    .DatabaseName = ConfigurationSettings.AppSettings("DatabaseName")
                    .UserID = ConfigurationSettings.AppSettings("UserID")
                    .Password = ConfigurationSettings.AppSettings("Password")
                End With
                crLogOnInfo = crTable.LogOnInfo
                crLogOnInfo.ConnectionInfo = crConnInfo
                crTable.ApplyLogOnInfo(crLogOnInfo)
            Next
            crTable.Location = myDBName & "." & myOwner & "." & crTable.Location.Substring(crTable.Location.LastIndexOf(".") + 1)
            crSections = repDoc.ReportDefinition.Sections
    
            For Each crSection In crSections
                crReportObjects = crSection.ReportObjects
                For Each crReportObject In crReportObjects
                    If crReportObject.Kind = ReportObjectKind.SubreportObject Then
                        crSubreportObject = CType(crReportObject, SubreportObject)
                        subRepDoc = crSubreportObject.OpenSubreport(crSubreportObject.SubreportName)
                        crDatabase = subRepDoc.Database
                        crTables = crDatabase.Tables
                            For Each crTable In crTables
                                With crConnInfo
                                    .ServerName = ConfigurationSettings.AppSettings("ServerName")
                                    .DatabaseName = ConfigurationSettings.AppSettings("DatabaseName")
                                    .UserID = ConfigurationSettings.AppSettings("UserID")
                                    .Password = ConfigurationSettings.AppSettings("Password")
                                End With
    
                                crLogOnInfo = crTable.LogOnInfo
                                crLogOnInfo.ConnectionInfo = crConnInfo
                                crTable.ApplyLogOnInfo(crLogOnInfo)
                            Next
                        crTable.Location = myDBName & "." & myOwner & "." & crTable.Location.Substring(crTable.Location.LastIndexOf(".") + 1)
                    End If
                Next
            Next
    
            Dim StrExportFile as string = Server.MapPath(".") & "\Report\PurchaseOrder.pdf"
            repDoc.ExportOptions.ExportDestinationType = ExportDestinationType.DiskFile
            repDoc.ExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat
    
            Dim objOptions as DiskFileDestinationOptions = New DiskFileDestinationOptions
            objOptions.DiskFilename = strExportFile
            repDoc.ExportOptions.DestinationOptions = objOptions
            repDoc.export()
            objoptions = nothing
            repDoc = nothing
        End sub
    
    Function NoToWords(Num as decimal) as string
        Dim numval as decimal = cdec(Num)
        Dim NTW, NText, dollars, cents, NWord, totalcents As String
        Dim decplace, TotalSets, cnt, LDollHold As Integer
        Dim NumParts(9) As String 'Array For Amount (sets of three)
        Dim Place(9) As String 'Array containing place holders
        Dim LDoll As Integer 'Length of the Dollars Text Amount
    
            Place(2) = " Thousand " '
            Place(3) = " Million " 'Place holder names For money
            Place(4) = " Billion " 'amounts
            Place(5) = " Trillion " '
            NTW = "" 'Temp value For the Function
            NText = round_curr(numval) 'Roundup the cents To eliminate     cents gr 2
    
            NText = Trim(CStr(NText)) 'String representation of amount
            decplace = InStr(Trim(NText), ".") 'Position of Decimal 0 If none
            dollars = Trim(Left(NText, IIf(decplace = 0, Len(numval), decplace - 1)))
            LDoll = Len(dollars)
            cents = Trim(Right(NText, IIf(decplace = 0, 0, math.abs(decplace - Len(NText)))))
    
            If Len(cents) = 1 Then
                cents = cents & "0"
            End If
    
            If (LDoll Mod 3) = 0 Then
                TotalSets = (LDoll \ 3)
            Else
                TotalSets = (LDoll \ 3) + 1
            End If
    
            cnt = 1
            LDollHold = LDoll
    
            Do While LDoll > 0
            NumParts(cnt) = IIf(LDoll > 3, Right(dollars, 3), Trim(dollars))
            dollars = IIf(LDoll > 3, Left(dollars, (IIf(LDoll < 3, 3, LDoll)) - 3), "")
            LDoll = Len(dollars)
            cnt = cnt + 1
        Loop
    
        For cnt = TotalSets To 1 Step -1 'step through NumParts array
            NWord = GetWord(NumParts(cnt)) 'convert 1 element of                NumParts
            NTW = NTW & NWord 'concatenate it To temp                variable
            If NWord <> "" Then NTW = NTW & Place(cnt)
        Next cnt 'loop through
    
        If LDollHold > 0 Then
            NTW = Trim$(NTW) & " and" 'concatenate text
        Else
            NTW = NTW & " # VOID # " 'concatenate text
        End If
    
        totalcents = GetTens(cents) 'Convert cents part to word
        If totalcents = "" Then cents = "00" 'Concat NO if cents=0
        NTW = Trim$(NTW) & " " & Trim$(cents) & "/100"   'Concat Dollars and Cents
        NoToWords = NTW
        return NoToWords
    End Function
    
    Function GetWord(NumText)
        Dim GW As String, x As Integer
        GW = "" 'null out temporary Function value
            If Val(NumText) > 0 Then
                For x = 1 To Len(NumText) 'loop the length of NumText times
                    Select Case Len(NumText)
                        Case 3:
                            If Val(NumText) > 99 Then
                                GW = GetDigit(Left(NumText, 1)) & " Hundred "
                            End If
                            NumText = Right(NumText, 2)
                            Case 2:
                            GW = GW & GetTens(NumText)
                            NumText = ""
                            Case 1:
                            GW = GetDigit(NumText)
                        Case Else
                    End Select
                Next x
            End If
            GetWord = GW 'assign Function return value
    End Function
    
    Function GetDigit(Digit)
        Select Case Val(Digit)
            Case 1: GetDigit = "One" '
            Case 2: GetDigit = "Two" '
            Case 3: GetDigit = "Three" '
            Case 4: GetDigit = "Four" ' Assign a numeric word value
            Case 5: GetDigit = "Five" ' based on a Single digit.
            Case 6: GetDigit = "Six" '
            Case 7: GetDigit = "Seven" '
            Case 8: GetDigit = "Eight" '
            Case 9: GetDigit = "Nine" '
            Case Else: GetDigit = "" '
        End Select
    End Function
    
    Function GetTens(tenstext)
    Dim GT As String
        GT = "" 'null out the temporary Function value
    
        If Val(Left(tenstext, 1)) = 1 Then ' If value between 10-19
            Select Case Val(tenstext)
                Case 10: GT = "Ten" '
                Case 11: GT = "Eleven" '
                Case 12: GT = "Twelve" '
                Case 13: GT = "Thirteen" ' Retrieve numeric word
                Case 14: GT = "Fourteen" ' value If between ten and
                Case 15: GT = "Fifteen" ' nineteen inclusive.
                Case 16: GT = "Sixteen" '
                Case 17: GT = "Seventeen" '
                Case 18: GT = "Eighteen" '
                Case 19: GT = "Nineteen" '
                Case Else
            End Select
        Else ' If value between 20-99
            Select Case Val(Left(tenstext, 1))
                Case 2: GT = "Twenty " '
                Case 3: GT = "Thirty " '
                Case 4: GT = "Forty " '
                Case 5: GT = "Fifty " ' Retrieve value if it is
                Case 6: GT = "Sixty " ' divisible by ten
                Case 7: GT = "Seventy " ' excluding the value ten.
                Case 8: GT = "Eighty " '
                Case 9: GT = "Ninety " '
                Case Else
            End Select
            GT = GT & GetDigit(Right(tenstext, 1)) 'Retrieve ones place
        End If
        GetTens = GT ' Assign Function return value.
    End Function
    
    Function round_curr(currValue)
        Const Factor As Long = 100
         If Val(currValue) <> 0 Then
         round_curr = Int(Val(currValue) * Factor + 0.5) / Factor
         End If
    End Function
    
    Sub OurPager(sender as object,e as datagridpagechangedeventargs)
        dtgPartWithSource.CurrentPageIndex = e.NewPageIndex
        LoadDataWithSource()
    end sub
    
    Sub ItemCommand(sender as Object,e as DataGridCommandEventArgs)
        Dim SeqNo As Label = CType(e.Item.FindControl("SeqNo"), Label)
        if ucase(e.commandArgument) = "VIEW" then Response.redirect("PurchaseOrderDet.aspx?ID=" & clng(SeqNo.text))
    end sub

</script>
<html xmlns:footer= "xmlns:footer">
<head>
    <link href="ibuyspy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginwidth="0" marginheight="0">
    <form enctype="multipart/form-data" runat="server">
        <p>
            <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="727" align="center">
                <tbody>
                    <tr>
                        <td>
                            <div align="center">
                                <IBUYSPY:HEADER id="UserControl1" runat="server"></IBUYSPY:HEADER>
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                            </div>
                            <div align="center">
                                <p>
                                    <table style="HEIGHT: 12px" cellspacing="0" cellpadding="0" width="100%">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <table style="HEIGHT: 10px" cellspacing="0" cellpadding="0" width="100%">
                                                        <tbody>
                                                            <tr>
                                                                <td width="28" background="Frame-Top-left.jpg" height="28">
                                                                </td>
                                                                <td class="SideTableHeading" background="Frame-Top-Center.jpg">
                                                                    Purchase Order List</td>
                                                                <td width="28" background="Frame-Top-right.jpg">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <table class="sideboxnotopGrey" cellspacing="0" cellpadding="0" width="100%" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <br />
                                                                    <table style="HEIGHT: 11px" width="96%" align="center" border="1">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <p align="center">
                                                                                        <asp:Label id="Label1" runat="server">SEARCH</asp:Label>&nbsp; 
                                                                                        <asp:TextBox id="txtSearch" runat="server" Width="101px" CssClass="input_box"></asp:TextBox>
                                                                                        &nbsp; <asp:Label id="Label3" runat="server">BY</asp:Label>&nbsp; 
                                                                                        <asp:DropDownList id="cmbBy" runat="server" Width="121px" CssClass="input_box">
                                                                                            <asp:ListItem Value="PO.PO_NO">PO NO</asp:ListItem>
                                                                                            <asp:ListItem Value="VEN.VEN_CODE">SUPPLIER CODE</asp:ListItem>
                                                                                            <asp:ListItem Value="VEN.VEN_NAME">SUPPLIER NAME</asp:ListItem>
                                                                                        </asp:DropDownList>
                                                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                        <asp:Button id="cmdSearch" onclick="cmdSearch_Click" runat="server" CssClass="OutputText" Text="SEARCH"></asp:Button>
                                                                                    </p>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <br />
                                                                    <p align="center">
                                                                        <asp:DataGrid id="dtgPartWithSource" runat="server" PageSize="20" OnItemCommand="ItemCommand" OnItemDataBound="FormatRow" AllowSorting="True" OnSortCommand="SortGrid" Font-Size="XX-Small" Font-Names="Verdana" AutoGenerateColumns="False" Font-Name="Verdana" cellpadding="4" BorderColor="Gray" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="dtgPartWithSource_SelectedIndexChanged" AllowPaging="True" OnPageIndexChanged="OurPager" OnItemCreated="dtgPartWithSource_ItemCreated" width="96%">
                                                                            <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                                            <HeaderStyle horizontalalign="Left" bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                                            <PagerStyle nextpagetext="Next" prevpagetext="Prev" mode="NumericPages"></PagerStyle>
                                                                            <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                                            <ItemStyle cssclass="GridItem"></ItemStyle>
                                                                            <Columns>
                                                                                <asp:TemplateColumn>
                                                                                    <ItemTemplate>
                                                                                        <asp:ImageButton id="ImgView" ToolTip="View this item" ImageUrl="View.gif" CommandArgument='VIEW' runat="server"></asp:ImageButton>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="P/O No">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PONo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PO_No") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:ButtonColumn Visible="False" Text="Delete" HeaderImageUrl="view.gif" CommandName="Delete"></asp:ButtonColumn>
                                                                                <asp:ButtonColumn Visible="False" Text="Delete" ButtonType="PushButton" CommandName="Delete"></asp:ButtonColumn>
                                                                                <asp:BoundColumn DataField="Ven_Code" HeaderText="Supp. Code / Name"></asp:BoundColumn>
                                                                                <asp:TemplateColumn HeaderText="P/O Date">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="PODate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "PO_Date") %>' /> <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' visible= "false" /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Mail">
                                                                                    <HeaderStyle horizontalalign="Left"></HeaderStyle>
                                                                                    <ItemStyle horizontalalign="Center"></ItemStyle>
                                                                                    <HeaderTemplate>
                                                                                        <input class="OutputText" id="chkAllItems" onclick="CheckAllDataGridCheckBoxes('Mail',document.forms[0].chkAllItems.checked)" type="Checkbox" value="Check All" />
                                                                                    </HeaderTemplate>
                                                                                    <ItemTemplate>
                                                                                        <center>
                                                                                            <asp:CheckBox id="Mail" runat="server" />
                                                                                        </center>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="EMail Add">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="Email" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "EMAIL_PO") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                                <asp:TemplateColumn HeaderText="Sent By">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label id="SendBy" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Send_By") %>' /> - <asp:Label id="SendDate" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Send_Date") %>' /> 
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateColumn>
                                                                            </Columns>
                                                                        </asp:DataGrid>
                                                                        <br />
                                                                    </p>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <table style="HEIGHT: 7px" cellspacing="0" cellpadding="0" width="96%" align="center">
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <asp:Button id="cmdEMail" onclick="cmdEMail_Click" runat="server" Width="136px" Text="Send P/O by mail"></asp:Button>
                                                                    <asp:Label id="lblSenderEMail" runat="server" visible="False">Label</asp:Label></td>
                                                                <td>
                                                                    <div align="right">
                                                                        <asp:Button id="cmdBack" onclick="cmdBack_Click" runat="server" Width="121px" Text="Back"></asp:Button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </p>
                            </div>
                            <footer:footer id="footer" runat="server"></footer:footer>
                        </td>
                    </tr>
                </tbody>
            </table>
        </p>
    </form>
</body>
</html>
