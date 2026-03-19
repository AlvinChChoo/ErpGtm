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
                loaddata()
                ProcLoadGridData()
                lblTotal.text = format(cdec(ReqCOM.GetFieldVal("select Sum(ship_qty * UP) as [SubTotal] from sales_invoice_d where SI_No = '" & trim(lblSINo.text) & "';","SubTotal")),"##,##0.00")
                lblAmtInWords.text = "SAY TOTAL " & trim(lblCurrCode.text) & " " & ucase(NoToWords(lblTotal.text)) & " ONLY"
                lblTotal.text = "Total  :  " & lblTotal.text
            end if
        End Sub
    
        Sub LoadData
            Dim ReqCOM as ERP_GTM.ERP_GTM = new ERP_GTM.ERP_GTM
            Dim myConnection As SqlConnection = New SqlConnection(ConfigurationSettings.AppSettings("ConnectionString"))
            myConnection.Open()
            Dim myCommand As SqlCommand = New SqlCommand("Select cust.curr_code, Cust.Cust_Code,SI.SI_No,SI.SI_Date,SI.Cust_Code,SI.Cust_Name,SI.Ship_Add1,SI.Ship_Add2,SI.Ship_Add3 from Sales_Invoice_M SI,Cust where SI.cust_code = si.cust_code and SI.seq_no = " & request.params("ID") & ";", myConnection)
            Dim drGetFieldVal As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
    
            do while drGetFieldVal.read
                lblSINo.text = drGetFieldVal("SI_No")
                lblSIDate.text = drGetFieldVal("SI_Date")
                lblCustCode.text = drGetFieldVal("Cust_Code")
                lblCustName.text = drGetFieldVal("Cust_Name")
                lblShipAdd1.text = drGetFieldVal("Ship_Add1")
                lblShipAdd2.text = drGetFieldVal("Ship_Add2")
                lblShipAdd3.text = drGetFieldVal("Ship_Add3")
                lblCurrCode.text = drGetFieldVal("Curr_Code")
            loop
    
            drGetFieldVal.close()
            myCommand.dispose()
            myConnection.Close()
            myConnection.Dispose()
        End sub
    
        Sub ShowAlert(Msg as string)
            Dim strScript as string
            strScript = "<" & "script language=JavaScript>alert(""" & Msg & """)</script" & ">"
            If (Not IsStartupScriptRegistered("clientScript")) Then Page.RegisterStartupScript("clientScript", strScript)
        End sub
    
        Sub cmbUpdate_Click(sender As Object, e As EventArgs)
            if page.isvalid = true then
                SaVeDetails
                ShowAlert("Sales Order Details updated.")
                redirectPage("SalesOrderModelDet.aspx?ID=" & Request.params("ID"))
            End if
        End Sub
    
        Sub SaveDetails()
            if page.isvalid = true then
    
            End if
        End sub
    
    Sub redirectPage(ReturnURL as string)
        Dim strScript as string
        strScript = "<" & "script language=JavaScript>window.location=""" & ReturnURL & """;</script" & ">"
        If (Not IsStartupScriptRegistered("ClientRedirect")) Then Page.RegisterStartupScript("ClientRedirect", strScript)
    End sub
    
    
    Sub cmdSubmit_Click(sender As Object, e As EventArgs)
        if page.isvalid =true then
    '        Dim ReqCOM as ERP_GTm.ERP_GTM = new ERP_GTM.ERP_GTM
    '        SaVeDetails
    '        ReqCOM.ExecuteNonQuery("Update SO_MODELS_M set CSD_App_by = '" & trim(request.cookies("U_ID").value) & "', CSD_App_Date = '" & now & "',so_status = 'PENDING APPROVAL' where Lot_No = '" & trim(lblLotNo.text) & "';")
    '        ShowAlert("Selected S/O submitted for PCMC approval.")
    '        redirectPage("SalesOrderModelDet.aspx?ID=" & Request.params("ID"))
        end if
    End Sub
    
    Sub GetNextControl(ByVal FocusControl As Control)
        Dim Script As New System.Text.StringBuilder
        Dim ClientID As String = FocusControl.ClientID
    
            Script.Append("<script language=javascript>")
            Script.Append("document.getElementById('")
            Script.Append(ClientID)
            Script.Append("').focus();")
            Script.Append("</script" & ">")
            RegisterStartupScript("setFocus", Script.ToString())
    End Sub
    
    Protected Sub FormatRow(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
            If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
                Dim UP As Label = CType(e.Item.FindControl("UP"), Label)
                Dim Amt As Label = CType(e.Item.FindControl("Amt"), Label)
                Dim ShipQty As Label = CType(e.Item.FindControl("ShipQty"), Label)
    
    
    
    
                Amt.text = format(cdec(cdec(UP.text) * clng(ShipQty.text)),"##,##0.00")
    
                UP.text = trim(lblCurrcODE.text) & "  " & format(cdec(UP.text),"##,##0.00")
                Amt.text = trim(lblCurrcODE.text) & "  " & format(cdec(Amt.text),"##,##0.00")
    
            End if
    End Sub
    
    Sub ProcLoadGridData()
        Dim StrSql as string
        Dim reqExePagedDataSet as Erp_Gtm.ERp_Gtm = new Erp_Gtm.ERp_Gtm
        StrSql = "Select * from Sales_Invoice_d where SI_No = '" & trim(lblSINo.text) & "';"
        IF StrSql <> "" THEN
            Dim resExePagedDataSet as Dataset = ReqExePagedDataSet.ExePagedDataSet(StrSql,"ship_notice_m")
            GridControl1.DataSource=resExePagedDataSet.Tables("ship_notice_m").DefaultView
            GridControl1.DataBind()
        End if
    end sub
    
    Sub GridControl1_SelectedIndexChanged(sender As Object, e As EventArgs)
    
    End Sub
    
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

</script>
<html>
<head>
    <link href="IBuySpy.css" type="text/css" rel="stylesheet" />
    <script language="javascript" src="script.js" type="text/javascript"></script>
</head>
<body onkeypress="KeyPress()" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
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
                            <asp:Label id="Label1" runat="server" width="100%" cssclass="fORMdESC">SALES INVOCIE
                            DETAILS</asp:Label>
                        </p>
                        <p align="center">
                            <table style="HEIGHT: 14px" cellspacing="0" cellpadding="0" width="76%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <p>
                                                <table style="FONT-SIZE: xx-small; BORDER-LEFT-COLOR: black; BORDER-BOTTOM-COLOR: black; WIDTH: 100%; BORDER-TOP-COLOR: black; FONT-FAMILY: Verdana; BORDER-COLLAPSE: collapse; BORDER-RIGHT-COLOR: black" width="100%" border="1">
                                                    <tbody>
                                                        <tr>
                                                            <td width="30%" bgcolor="silver">
                                                                <asp:Label id="Label2" runat="server" width="100%" cssclass="LabelNormal">Invoice
                                                                No</asp:Label></td>
                                                            <td width="70%">
                                                                <asp:Label id="lblSINo" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label17" runat="server" width="100%" cssclass="LabelNormal">Invoice
                                                                Date</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblSIDate" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="silver">
                                                                <asp:Label id="Label11" runat="server" width="100%" cssclass="LabelNormal">Cust. Code
                                                                / Name</asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblCustCode" runat="server" cssclass="OutputText"></asp:Label>&nbsp;- <asp:Label id="lblCustname" runat="server" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" bgcolor="silver" rowspan="3">
                                                                <asp:Label id="Label3" runat="server" width="100%" cssclass="LabelNormal">Shipping
                                                                Address</asp:Label><asp:Label id="lblCurrCode" runat="server" cssclass="OutputText" visible="False"></asp:Label></td>
                                                            <td>
                                                                <asp:Label id="lblShipAdd1" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblShipAdd2" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label id="lblShipAdd3" runat="server" width="100%" cssclass="OutputText"></asp:Label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </p>
                                            <p>
                                                <asp:DataGrid id="GridControl1" runat="server" width="100%" PagerStyle-HorizontalAligh="Right" OnSelectedIndexChanged="GridControl1_SelectedIndexChanged" OnItemDataBound="FormatRow" BorderColor="Black" GridLines="Vertical" cellpadding="4" ShowFooter="False" AutoGenerateColumns="False">
                                                    <FooterStyle cssclass="GridFooter"></FooterStyle>
                                                    <HeaderStyle bordercolor="White" cssclass="GridHeaderSmall"></HeaderStyle>
                                                    <AlternatingItemStyle cssclass="GridItemAlt"></AlternatingItemStyle>
                                                    <ItemStyle cssclass="GridItem"></ItemStyle>
                                                    <Columns>
                                                        <asp:TemplateColumn HeaderText="Lot #">
                                                            <ItemTemplate>
                                                                <asp:Label id="LotNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Lot_No") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Qty.">
                                                            <ItemTemplate>
                                                                <asp:Label id="ShipQty" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Ship_Qty") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Description">
                                                            <ItemTemplate>
                                                                <asp:Label id="ModelDesc" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Model_Desc") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="U/P">
                                                            <ItemTemplate>
                                                                <asp:Label id="UP" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "UP") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn HeaderText="Amount">
                                                            <ItemTemplate>
                                                                <asp:Label id="Amt" runat="server" /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                        <asp:TemplateColumn Visible= "false">
                                                            <ItemTemplate>
                                                                <asp:Label id="SeqNo" runat="server" text='<%# DataBinder.Eval(Container.DataItem, "Seq_No") %>' /> 
                                                            </ItemTemplate>
                                                        </asp:TemplateColumn>
                                                    </Columns>
                                                </asp:DataGrid>
                                            </p>
                                            <p align="right">
                                                <asp:Label id="lblTotal" runat="server" width="100%" cssclass="OutputText"></asp:Label><asp:Label id="lblAmtInWords" runat="server" width="100%" cssclass="OutputText"></asp:Label>
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
